#include "sram_arbiter.h"

SramArbiter::SramArbiter(unsigned int clock_period) : Abies::Testbench <VSramArbiter>(clock_period)
{
    // Set initial state.
    top->rst = 1;
    top->en = 0;
    eval();
}

SramArbiter::~SramArbiter(void)
{

}
