#ifndef COUNTER8TB_H
#define COUNTER8TB_H

#include "VTestbench.h"
#include "VCounter8.h"
#include <stdint.h>

class Counter8Tb : public VTestbench <VCounter8>
{
public:
    // counter_tb(void);
    Counter8Tb(unsigned int clockPeriod = 10);
    ~Counter8Tb(void);
    void setPeriod(uint32_t period);
};

#endif
