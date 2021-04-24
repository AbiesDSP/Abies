import os, sys
import yaml
import edalize

def add_srcs(srcdir, work_root):
    files = os.listdir(srcdir)
    return [src_entry(src, srcdir, work_root) for src in files]

def src_entry(src, srcdir, work_root):
    file_detect = {
        '.sv'   : 'systemVerilogSource',
        '.v'    : 'verilogSource',
        '.xci'  : 'read_ip',
        '.xdc'  : 'xdc',
        '.tcl'  : 'tclSource',
        '.mem'  : 'mem'}
    _, src_ext = os.path.splitext(src)

    return {'name' : os.path.relpath(srcdir+src, work_root), 'file_type' : file_detect[src_ext]}

if __name__ == "__main__":

    config_file = 'config.yml'
    with open(config_file, 'r') as stream:
        config = yaml.safe_load(stream)

    work_root = config['work_root']
    os.makedirs(work_root, exist_ok=True)

    rtl_files = add_srcs('framework/', work_root)
    mem_files = add_srcs('mem/', work_root)
    constraints = [src_entry('cmoda7_pmod.xdc', 'constraints/', work_root)]
    src_files = rtl_files + mem_files + constraints

    # Build folder contains vivado project files.
    post_imp_file = os.path.realpath(os.path.join(work_root, 'post.tcl'))

    yosys_synth_options = ['-iopad', '-family ' + config['part_family']]

    edam = {
        'files' : src_files,
        'name'  : config["project_name"],
        # 'parameters' : parameters,
        'toplevel' : config["top_module"],
        'tool_options' : {'vivado' : {
            'vivado-settings' : config['vivado_location'] + config['vivado_version'] + '/settings64.sh',
            'source_mgmt_mode' : config['source_mgmt_mode'],
            'part' : config['part'], 
            'post_imp' : post_imp_file,
            'yosys_synth_options' : yosys_synth_options,
            'synth' : config['synth_tool']
            }}
    }

    backend = edalize.get_edatool(config['tool'])(edam=edam, work_root=work_root)
    backend.configure()
    backend.build()


    # print([src_entry(src) for src in rtl_files])
    # parameters = {  'DW' : {'datatype' : 'int', 'default' : 24, 'paramtype' : 'vlogparam'},
    #                 'FS_RATIO' : {'datatype' : 'int', 'default' : 256, 'paramtype' : 'vlogparam'},
    #                 'WFM_FILE' : {'datatype' : 'string', 'default' : "sin_w24_d10.mem", 'paramtype' : 'vlogparam'},
    #                 'DEPTH' : {'datatype' : 'int', 'default' : 1024, 'paramtype' : 'vlogparam'},
    # }
