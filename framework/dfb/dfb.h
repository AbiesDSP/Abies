#pragma once

#include "testbench.h"
#include "VDfb.h"
#include <stdint.h>

class Dfb : public Abies::Testbench <VDfb>
{
public:
    Dfb(unsigned int clock_period = 10){};
    ~Dfb(){};
};
