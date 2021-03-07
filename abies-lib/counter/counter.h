#pragma once

#include "testbench.h"
#include "VCounter.h"
#include <stdint.h>

class Counter : public Abies::Testbench <VCounter>
{
public:
    // counter_tb(void);
    Counter(unsigned int clock_period = 10);
    ~Counter(void);
    void reset(unsigned int duration)
    {
        top->rst = 1;
        for (unsigned int i = 0; i < duration; i++) {
            tick();
        }
        top->rst = 0;
    }
    void set_period(uint32_t period);
};
