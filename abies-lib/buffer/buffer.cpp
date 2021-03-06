#include "buffer.h"

Buffer::Buffer(unsigned int clock_period) : Abies::Testbench <VBuffer>(clock_period)
{
    // Set initial state
    eval();
}

Buffer::~Buffer(void)
{

}
