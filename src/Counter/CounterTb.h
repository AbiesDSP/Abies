#ifndef COUNTERTB_H
#define COUNTERTB_H

#include "VTestbench.h"
#include "VCounter.h"
#include <stdint.h>

class CounterTb : public VTestbench <VCounter>
{
public:
    // counter_tb(void);
    CounterTb(unsigned int clockPeriod = 10);
    ~CounterTb(void);
    void setPeriod(uint32_t period);
};

#endif
