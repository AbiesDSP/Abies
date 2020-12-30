import edalize
import os

work_root = 'build/vivado-prj'
post_imp_file = os.path.realpath(os.path.join(work_root, 'post.tcl'))
os.makedirs(work_root, exist_ok=True)

synth_tool = 'yosys'
yosys_synth_options = ['-iopad', '-family xc7']

files = [
  {'name' : os.path.relpath('framework/blinky.v', work_root), 'file_type' : 'verilogSource'},
  {'name' : os.path.relpath('framework/abies_top.v', work_root), 'file_type' : 'verilogSource'},
  {'name' : os.path.relpath('framework/pwm/pwm.v', work_root), 'file_type' : 'verilogSource'},
  {'name' : os.path.relpath('framework/sram_arbiter/sram_arbiter.v', work_root), 'file_type' : 'verilogSource'},
  {'name' : os.path.relpath('framework/cmoda7.xdc', work_root), 'file_type' : 'xdc'}
]

tool = 'vivado'

edam = {
    'files' : files,
    'name'  : 'abies',
    # 'parameters' : parameters,
    'toplevel' : 'abies_top',
    'tool_options' : {'vivado' : {
        'part' : 'xc7a35tcpg236-1',
        'post_imp' : post_imp_file,
        'synth' : synth_tool,
        'yosys_synth_options' : yosys_synth_options
        }}
}

backend = edalize.get_edatool(tool)(edam=edam, work_root=work_root)
backend.configure()
backend.build()
