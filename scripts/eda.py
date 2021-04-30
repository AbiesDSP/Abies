import os, sys
import yaml
import edalize
from platform import uname
import subprocess

# Find all design sources in a directory
def add_srcs(srcdir, work_root):
    files = os.listdir(srcdir)
    return [entry for entry in (src_entry(src, srcdir, work_root) for src in files) if entry is not None]

# Format src file entry for edalize
def src_entry(src, srcdir, work_root):
    file_detect = {
        '.sv'   : 'systemVerilogSource',
        '.v'    : 'verilogSource',
        '.xci'  : 'read_ip',
        '.xdc'  : 'xdc',
        '.tcl'  : 'tclSource',
        '.mem'  : 'mem'}
    _, src_ext = os.path.splitext(src)

    # Only allow valid files.
    try:
        entry = {'name' : os.path.relpath(srcdir+src, work_root), 'file_type' : file_detect[src_ext]}
        return entry
    except:
        return None

# Read project config file.
def read_config(cfg_file):
    # Prefer to use the user config file if using a different build system.
    # Be aware of the differences. Release should be build using the default.
    if(os.path.exists(cfg_file)):
        with open(cfg_file, 'r') as stream:
            print(f"Loading {cfg_file}")
            config = yaml.safe_load(stream)
    else:
        raise "Config file doesn't exist."

    return config

# Usage: python3 scripts/eda.py
if __name__ == "__main__":

    if len(sys.argv) != 2:
        print("Specify a config file: python3 scripts/eda.py config.yaml")
        exit()
    
    config = read_config(sys.argv[1])
    # # Default configuration file.
    vivado_location=config['vivado_location']
    vivado_version=config['vivado_version']
    work_root=config['work_root']
    tool=config['tool']
    synth_tool=config['synth_tool']
    part_family=config['part_family']
    part=config['part']
    source_mgmt_mode=config['source_mgmt_mode']

    project_name=config['project_name']
    top_module=config['top_module']

    # Pass optional top level parameters.
    # parameters = {  'DW' : {'datatype' : 'int', 'default' : 24, 'paramtype' : 'vlogparam'}} # Example

    # Command to build project on windows. It still uses the edalize-generated tcl scripts.
    # Sources settings64, generates .xpr, and runs vivado batch mode command to build the project.
    win_build_cmd = f'{vivado_location}\\{vivado_version}\\settings64.bat && cd {project_name}-viv && vivado -notrace -mode batch -source {project_name}.tcl && vivado -notrace -mode batch -source {project_name}_run.tcl {project_name}.xpr && cd ..'

    # Gather all design files.
    rtl_files = add_srcs('framework/', work_root)
    mem_files = add_srcs('mem/', work_root)

    constraints = [{'name' : os.path.relpath(cset, work_root), 'file_type' : 'xdc'} for cset in config['constraints']]

    src_files = rtl_files + mem_files + constraints

    # Configure hardware project.
    post_imp_file = os.path.realpath(os.path.join(work_root, 'post.tcl'))
    yosys_synth_options = ['-iopad', '-family ' + part_family]
    edam = {
        'files' : src_files,
        'name'  : project_name,
        # 'parameters' : parameters,
        'toplevel' : top_module,
        'tool_options' : {'vivado' : {
            'vivado-settings' : f'{vivado_location}/{vivado_version}/settings64.sh',
            'source_mgmt_mode' : source_mgmt_mode,
            'part' : part, 
            'post_imp' : post_imp_file,
            'yosys_synth_options' : yosys_synth_options,
            'synth' : synth_tool
            }}
    }

    # Configure project
    print(f"Configuring Project: {project_name}")
    os.makedirs(work_root, exist_ok=True)
    backend = edalize.get_edatool(tool)(edam=edam, work_root=work_root)
    backend.configure()

    # If running within WSL, run the build scripts in Windows cmd.exe instead of linux.
    if ('Microsoft' in uname().release):
        viv_win_cmd = ["/mnt/c/Windows/System32/cmd.exe", "/c", win_build_cmd]
        subprocess.run(viv_win_cmd)
    else:
        # Run in linux using edalize tools.
        backend.build()
