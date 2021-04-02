#pragma once

#include "testbench.h"
#include "VDds.h"
#include <stdint.h>

class Dds : public Abies::Testbench <VDds>
{
public:
    Dds(unsigned int clock_period = 10);
    ~Dds(void);
    void reset(unsigned int duration)
    {
        top->rst = 1;
        for (unsigned int i = 0; i < duration; i++) {
            tick();
        }
        top->rst = 0;
    }
};
