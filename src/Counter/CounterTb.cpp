#include "CounterTb.h"

CounterTb::CounterTb(unsigned int clockPeriod) : VTestbench <VCounter>(clockPeriod)
{
    // Set initial state
    m_top->en = 0;
    m_top->period = 0;
    eval();
}

CounterTb::~CounterTb(void)
{
}

void CounterTb::setPeriod(uint32_t period)
{
    m_top->period = period;
}
