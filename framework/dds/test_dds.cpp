#include "VDds.h"
#include "testbench.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/dds/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

using Abies::Testbench;

TEST_GROUP(DdsGroup)
{
    Testbench<VDds> *tb;

    void setup()
    {
        // Create a new trace using the test name.
        std::string test_name(UtestShell::getCurrent()->getName().asCharString());
        std::string trace_path(TRACE_PATH_BASE + test_name + ".vcd");

        tb = new Testbench<VDds>(trace_path);
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(DdsGroup, basic)
{
    tb->top->rst = 1;
    tb->tick(RESET_DURATION);
    tb->top->rst = 0;

    unsigned int sample_div = 10; // sample clock.

    tb->top->tuning_word = 320;

    for (int i = 0; i < 8192; i++) {
        tb->top->ce = 1;
        tb->tick();
        tb->top->ce = 0;
        tb->tick(sample_div-1);
    }
}
