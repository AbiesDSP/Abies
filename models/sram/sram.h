#pragma once
#include "co_sim.h"
#include <vector>

namespace Abies
{
class Sram : public CoSim
{
public:
    std::vector<uint8_t> ram_data;
    Sram (uint8_t DW, uint8_t AW, uint8_t ODELAY, uint8_t &clk, uint32_t &addr, uint8_t &ce_n, uint8_t &we_n, uint8_t &oe_n, uint8_t &dq_wr, uint8_t &dq_rd) :
        // Requires 100MHz reference clock for timing.
        CoSim({&clk}),
        clk_(clk),
        // Parameters
        DW_(DW),
        AW_(AW),
        o_delay_(ODELAY),
        // SRAM Package Pins
        addr_(addr),
        ce_n_(ce_n),
        we_n_(we_n),
        oe_n_(oe_n),
        dq_wr_(dq_wr),
        dq_rd_(dq_rd)
    {
        ram_size_ = 1 << AW_;
        ram_data.resize(ram_size_, 0);
        read_ram_ = 0;
    }

    ~Sram() {};
    void init(uint8_t val) {
        std::fill(ram_data.begin(), ram_data.end(), val);
    }
    void init(const char *mem_file);
    size_t size(void) {
        return ram_data.size();
    }
    virtual void eval(void);
protected:
    // Parameters
    uint8_t DW_, AW_;
    // Hardware connections.
    uint8_t &clk_, &ce_n_, &oe_n_, &we_n_;
    uint32_t &addr_;
    uint8_t &dq_wr_, &dq_rd_;
private:
    unsigned int o_delay_;
    int read_ram_;
    uint8_t data_lock_;
    uint32_t ram_size_;
    unsigned int max_value_;
};
}