#pragma once

#include "util/testbench.h"
#include "V${module_class}.h"
#include <stdint.h>

class ${module_class} : public WD::Testbench <V${module_class}>
{
public:
    ${module_class}(unsigned int clock_period = 10);
    ~${module_class}(void);
    void reset(unsigned int reset_duration = 10);
};
