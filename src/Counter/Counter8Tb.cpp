#include "Counter8Tb.h"

Counter8Tb::Counter8Tb(unsigned int clockPeriod) : VTestbench <VCounter8>(clockPeriod)
{
    // Set initial state
    m_top->en = 0;
    m_top->period = 0;
    eval();
}

Counter8Tb::~Counter8Tb(void)
{
}

void Counter8Tb::setPeriod(uint32_t period)
{
    m_top->period = period;
}
