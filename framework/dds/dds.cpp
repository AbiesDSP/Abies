#include "dds.h"

Dds::Dds(unsigned int clock_period) : Abies::Testbench <VDds>(clock_period)
{
    top->rst = 1;
    eval();
}

Dds::~Dds(void)
{

}
