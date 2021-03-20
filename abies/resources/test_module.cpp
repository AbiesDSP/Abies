#include "${module_name}.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/${module_name}/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

TEST_GROUP(${module_class}Group)
{
    void setup()
    {

    }

    void teardown()
    {

    }
};

TEST(${module_class}Group, basic)
{
    ${module_class} tb;
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "basic.vcd";
    tb.open_trace(trace_string.c_str());
    tb.reset(RESET_DURATION);
}
