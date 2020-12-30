#include "pwm.h"

Pwm::Pwm(unsigned int clock_period) : Abies::Testbench <VPwm>(clock_period)
{
    // Set initial state.
    top->rst = 1;
    eval();
}

Pwm::~Pwm(void)
{

}
