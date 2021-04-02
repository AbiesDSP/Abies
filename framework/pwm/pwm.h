#pragma once

#include "testbench.h"
#include "VPwm.h"
#include <stdint.h>

class Pwm : public Abies::Testbench <VPwm>
{
public:
    Pwm(unsigned int clock_period = 10);
    ~Pwm(void);
    void reset(unsigned int duration)
    {
        top->rst = 1;
        for (unsigned int i = 0; i < duration; i++) {
            tick();
        }
        top->rst = 0;
    }
};
