#pragma once

#include "util/testbench.h"
#include "VBuffer.h"
#include <stdint.h>

class Buffer : public Abies::Testbench <VBuffer>
{
public:
    Buffer(unsigned int clock_period = 10);
    ~Buffer(void);
};
