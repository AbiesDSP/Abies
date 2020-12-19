#include "buffer.h"

Buffer::Buffer(unsigned int clock_period) : Abies::Testbench <VBuffer>(clock_period)
{
    // Set initial state
    top->en = 0;
    eval();
}

Buffer::~Buffer(void)
{

}
