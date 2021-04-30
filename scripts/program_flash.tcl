# Vivado TCL Script to program flash. This gets called from prog.py
set part_family [lindex $argv 0]
set bit_file [lindex $argv 1]
set flash_file [lindex $argv 2]
set prm_file [lindex $argv 3]
set mem_part [lindex $argv 4]
# Open vivado hw manager
open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target
current_hw_device [get_hw_devices ${part_family}_0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices ${part_family}_0] 0]

# Generate memory file
write_cfgmem -format bin -size 4 -interface SPIx4 -loadbit "up 0x00000000 ${bit_file}" -force -file ${flash_file}

# Set up device
create_hw_cfgmem -hw_device [lindex [get_hw_devices ${part_family}_0] 0] [lindex [get_cfgmem_parts "${mem_part}"] 0]
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
refresh_hw_device [lindex [get_hw_devices ${part_family}_0] 0]

# Program
set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
set_property PROGRAM.FILES [list "${flash_file}" ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
set_property PROGRAM.PRM_FILE "${flash_file}" [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
startgroup 
create_hw_bitstream -hw_device [lindex [get_hw_devices ${part_family}_0] 0] [get_property PROGRAM.HW_CFGMEM_BITFILE [ lindex [get_hw_devices ${part_family}_0] 0]]; program_hw_devices [lindex [get_hw_devices ${part_family}_0] 0]; refresh_hw_device [lindex [get_hw_devices ${part_family}_0] 0];
program_hw_cfgmem -hw_cfgmem [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${part_family}_0] 0]]
endgroup
