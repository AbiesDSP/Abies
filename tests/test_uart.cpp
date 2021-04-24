#include "VUart.h"
#include "testbench.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/uart/"
#define RESET_DURATION  10

using Abies::Testbench;

TEST_GROUP(UartGroup)
{
    Testbench<VUart> *tb;

    void setup()
    {
        // Create a new trace using the test name.
        std::string test_name(UtestShell::getCurrent()->getName().asCharString());
        std::string trace_path(TRACE_PATH_BASE + test_name + ".vcd");

        tb = new Testbench<VUart>(trace_path);
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(UartGroup, basic)
{
    tb->tick(10);
    tb->top->s_axis_tvalid = 1;
    tb->top->s_axis_tdata = 42;
    tb->top->m_axis_tready = 1;

    tb->tick(10000);
}
