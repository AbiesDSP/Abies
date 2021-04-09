#include "dfb.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/dfb/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

TEST_GROUP(DfbGroup)
{
    Dfb *tb;
    void setup()
    {
        tb = new Dfb;
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(DfbGroup, basic)
{
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "basic.vcd";
    tb->open_trace(trace_string.c_str());
    tb->tick(10);
    tb->top->i_ready = 1;

    for (int i = 0; i < 128; i++) {
        tb->top->i_valid = 1;
        tb->top->i_data = i;
        tb->tick();
        tb->top->i_valid = 0;
        tb->tick();
    }
    tb->tick(100);
}
