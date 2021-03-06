import edalize
import os, sys
import yaml

# Load yaml config file
def load_config_file(config_file=None):
    # 1. Check if user provided a config file on the command line
    if config_file:
        try:
            with open(config_file, 'r') as stream:
                try:
                    config = yaml.safe_load(stream)
                    # print("Loading " + config_file + "...")
                    return config
                except yaml.YAMLError as exc:
                    print("Error reading " + config_file + "...")
                    print(exc)
                    raise
        except:
            print("Couldn't find " + config_file)
            raise
    else:
        # 2. Look for config settings in the local directory
        try:
            with open("config.yml", 'r') as stream:
                try:
                    config = yaml.safe_load(stream)
                    print("Loading config.yml...")
                    return config
                except yaml.YAMLError as exc:
                    print("Error reading config.yml")
                    print(exc)
                    raise
        except:
            print("Couldn't find config.yml.")
            raise

def src_entry(src, work_root):
    return {'name' : os.path.relpath(src, work_root), 'file_type' : 'verilogSource'}

# Configure build scripts using edalize
def build(args):
    try:
        config = load_config_file(args.config)
    except:
        print("Aborting configure.")
        return
    
    viv_prj_root = config['work_root'] + "/vivado-prj"
    # Get source files.
    src_files = []
    # verilog source files
    try:
        for src in config['framework']['src']:
            src_files.append({'name' : os.path.relpath(src, viv_prj_root), 'file_type' : 'verilogSource'})
    except:
        print("No source files specified for framework.")
        raise
    # xdc constraints
    try:
        for xdc in config['framework']['constraints']:
            src_files.append({'name' : os.path.relpath(xdc, viv_prj_root), 'file_type' : 'xdc'})
    except:
        # Check for constraints if it's an implementation project
        pass
        # print("Specify constraints")
    # tcl scripts. bd_gen for example.
    try:
        for tcl_src in config['framework']['tcl_srcs']:
            src_files.append({'name' : os.path.relpath(tcl_src, viv_prj_root), 'file_type' : 'tclSource'})
    except:
        # no tcl srcs is okay.
        pass

    # Build folder contains vivado project files.
    post_imp_file = os.path.realpath(os.path.join(viv_prj_root, 'post.tcl'))
    os.makedirs(viv_prj_root, exist_ok=True)

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

    backend = edalize.get_edatool(config['tool'])(edam=edam, work_root=viv_prj_root)
    backend.configure()
    if args.scripts_only != True:
        backend.build()
