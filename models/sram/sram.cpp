#include "sram.h"

namespace Abies {

void Sram::eval(void) {
    uint32_t addr_mod = 0;
    // Even if sram is asynchronous, clk is our only time reference.
    // We're assuming the driver is synchronous, so this will be pseudo-synchronous.
    // Sample data on the rising edge, then change data on the falling.
    // This is 1/2 clk_per of delay, which may be a close enough approximation
    if (rising_edge(clk_)) {
        // Chip enable.
        if (!ce_n_) {
            if(addr_ >= ram_size_) {
                std::cout << "SRAM address out of range." << std::endl;
                addr_mod = (addr_ % ram_size_);
            } else {
                addr_mod = addr_;
            }
            // Write enable
            if (!we_n_) {
                if (addr_ < ram_size_) {
                    ram_data[addr_mod] = dq_wr_;
                } 
            } else if (!oe_n_) {
                read_ram_ = 1;
                data_lock_ = ram_data[addr_mod];
            }
        }
    }
    // If data needs to change.
    if (falling_edge(clk_)) {
        if (read_ram_) {
            dq_rd_ = data_lock_;
            read_ram_ = 0;
        }
    }
}

}