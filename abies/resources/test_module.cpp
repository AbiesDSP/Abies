#include "${module_name}.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/${module_name}/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

TEST_GROUP(${module_class}Group)
{
    ${module_class} *tb;

    void setup()
    {
        tb = new ${module_class};
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(${module_class}Group, basic)
{
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "basic.vcd";
    tb->open_trace(trace_string.c_str());
    tb->reset(RESET_DURATION);
}
