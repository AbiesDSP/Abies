#include "fifo.h"

Fifo::Fifo(unsigned int clock_period) : Abies::Testbench <VFifo>(clock_period)
{
    eval();
}

Fifo::~Fifo(void)
{

}
