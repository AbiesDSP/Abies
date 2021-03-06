#pragma once

#include "testbench.h"
#include "V${module_class}.h"
#include <stdint.h>

class ${module_class} : public Abies::Testbench <V${module_class}>
{
public:
    ${module_class}(unsigned int clock_period = 10);
    ~${module_class}(void);
};
