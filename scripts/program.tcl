set part_family [lindex $argv 0]
set bit_file [lindex $argv 1]

open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target
current_hw_device [get_hw_devices ${part_family}_0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices ${part_family}_0] 0]
set_property PROBES.FILE {} [get_hw_devices ${part_family}_0]
set_property FULL_PROBES.FILE {} [get_hw_devices ${part_family}_0]
set_property PROGRAM.FILE ${bit_file} [get_hw_devices ${part_family}_0]
program_hw_devices [get_hw_devices ${part_family}_0]
refresh_hw_device [lindex [get_hw_devices ${part_family}_0] 0]
