#include "i2s_tx.h"

I2STx::I2STx(unsigned int clock_period) : Abies::Testbench <VI2STx>(clock_period)
{
    top->rst = 1;
    eval();
}

I2STx::~I2STx(void)
{

}
