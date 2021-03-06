#pragma once

#include "testbench.h"
#include "VSramArbiter.h"
#include <stdint.h>

class SramArbiter : public Abies::Testbench <VSramArbiter>
{
public:
    SramArbiter(unsigned int clock_period = 10);
    ~SramArbiter(void);
};
