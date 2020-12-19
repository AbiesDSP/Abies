#include "counter.h"

Counter::Counter(unsigned int clock_period) : Abies::Testbench <VCounter>(clock_period)
{
    // Set initial state
    top->en = 0;
    top->period = 0;
    eval();
}

Counter::~Counter(void)
{
}

void Counter::set_period(uint32_t period)
{
    top->period = period;
}
