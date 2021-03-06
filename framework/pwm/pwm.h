#pragma once

#include "testbench.h"
#include "VPwm.h"
#include <stdint.h>

class Pwm : public Abies::Testbench <VPwm>
{
public:
    Pwm(unsigned int clock_period = 10);
    ~Pwm(void);
};
