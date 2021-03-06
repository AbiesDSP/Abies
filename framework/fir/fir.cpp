#include "fir.h"

Fir::Fir(unsigned int clock_period) : Abies::Testbench <VFir>(clock_period)
{
    top->rst = 1;
    eval();
}

Fir::~Fir(void)
{

}
