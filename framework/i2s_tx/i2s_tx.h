#pragma once

#include "testbench.h"
#include "VI2STx.h"
#include <stdint.h>

class I2STx : public Abies::Testbench <VI2STx>
{
public:
    I2STx(unsigned int clock_period = 10);
    ~I2STx(void);
};
