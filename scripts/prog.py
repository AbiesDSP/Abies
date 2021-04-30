import os, sys
from platform import uname
import subprocess
import re
from eda import read_config

def win_path(lin_path):
    # Extract drive letter.
    p = re.compile(r"/mnt/([a-z])/")
    m = p.search(lin_path)
    drive_letter = m.group(1).upper()

    return re.sub(r"/mnt/[a-z]/", f"{drive_letter}:/", lin_path)

# Temporary programming:        python3 scripts/prog.py config.yaml
# Program Configuration Flash:  python3 scripts/prog.py config.yaml --flash
if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Specify a config file and program mode: python3 scripts/prog.py config.yaml")
        exit()

    config = read_config(sys.argv[1])
    project_name = config['project_name']
    vloc = config['vivado_location']
    vver = config['vivado_version']
    work_root = config['work_root']
    mem_part = config['flash']
    part_family = config['part_family']

    if ('Microsoft' in uname().release):
        bit_file = win_path(os.path.abspath(f"{work_root}/{project_name}.bit"))
        # Create memory cfg file and program flash.
        if (len(sys.argv) == 3 and sys.argv[2] == '--flash'):
            print("Program flash")
            flash_file = win_path(os.path.abspath(f"{work_root}/{project_name}.bin"))
            prm_file = win_path(os.path.abspath(f"{work_root}/{project_name}.prm"))
            # Program flash.
            prog_flash_cmd = f'{vloc}\\{vver}\\settings64.bat && cd {project_name}-viv && vivado -notrace -mode batch -source ../scripts/program_flash.tcl -tclargs {part_family} {bit_file} {flash_file} {prm_file} {mem_part}'
            viv_win_cmd = ["/mnt/c/Windows/System32/cmd.exe", "/c", prog_flash_cmd]
            subprocess.run(viv_win_cmd)

        else:
            # Program temporary
            win_prog_cmd = f'{vloc}\\{vver}\\settings64.bat && cd {project_name}-viv && vivado -notrace -mode batch -source ../scripts/program.tcl -tclargs {part_family} {bit_file}'
            viv_win_cmd = ["/mnt/c/Windows/System32/cmd.exe", "/c", win_prog_cmd]
            subprocess.run(viv_win_cmd)
