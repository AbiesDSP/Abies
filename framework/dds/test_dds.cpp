#include "dds.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/dds/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

TEST_GROUP(DdsGroup)
{
    Dds *tb;
    void setup()
    {
        tb = new Dds;
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(DdsGroup, basic)
{
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "basic.vcd";
    tb->open_trace(trace_string.c_str());
    tb->reset(RESET_DURATION);

    unsigned int sample_div = 10; // sample clock.

    tb->top->tuning_word = 1;

    for (int i = 0; i < 8192; i++) {
        tb->top->ce = 1;
        tb->tick();
        tb->top->ce = 0;
        tb->tick(sample_div-1);
    }
}
