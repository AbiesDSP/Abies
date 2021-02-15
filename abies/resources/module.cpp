#include "${module_name}.h"

${module_class}::${module_class}(unsigned int clock_period) : WD::Testbench <V${module_class}>(clock_period)
{
    top->rst = 1;
    eval();
}

${module_class}::~${module_class}(void)
{

}

void ${module_class}::reset(unsigned int duration)
{
    top->rst = 1;
    for (unsigned int i = 0; i < duration; i++) {
        tick();
    }
    top->rst = 0;
}
