#pragma once

#include "testbench.h"
#include "VFifo.h"
#include <stdint.h>

class Fifo : public Abies::Testbench <VFifo>
{
public:
    Fifo(unsigned int clock_period = 10);
    ~Fifo(void);
};
