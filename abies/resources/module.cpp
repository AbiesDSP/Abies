#include "${module_name}.h"

${module_class}::${module_class}(unsigned int clock_period) : Abies::Testbench <V${module_class}>(clock_period)
{
    top->rst = 1;
    eval();
}

${module_class}::~${module_class}(void)
{

}
