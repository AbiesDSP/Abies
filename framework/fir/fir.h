#pragma once

#include "testbench.h"
#include "VFir.h"
#include <stdint.h>

class Fir : public Abies::Testbench <VFir>
{
public:
    Fir(unsigned int clock_period = 10);
    ~Fir(void);
};
