#include "V${module_class}.h"
#include "testbench.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/${module_name}/"
#define RESET_DURATION  10

using Abies::Testbench;

TEST_GROUP(${module_class}Group)
{
    Testbench<V${module_class}> *tb;

    void setup()
    {
        // Create a new trace using the test name.
        std::string test_name(UtestShell::getCurrent()->getName().asCharString());
        std::string trace_path(TRACE_PATH_BASE + test_name + ".vcd");

        tb = new Testbench<V${module_class}>(trace_path);
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(${module_class}Group, basic)
{
    tb->tick(100);
}
