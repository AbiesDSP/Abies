#include "VDfb.h"
#include "testbench.h"
#include "sram.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/dfb/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

using Abies::Testbench;
using Abies::Sram;

TEST_GROUP(DfbGroup)
{
    Testbench<VDfb> *tb;
    
    void setup()
    {
        tb = new Testbench<VDfb>;
    }

    void teardown()
    {
        delete tb;
    }
};

IGNORE_TEST(DfbGroup, basic)
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
TEST(DfbGroup, cosimstuff)
{
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "cosim.vcd";
    uint8_t ce_n, oe_n, we_n;
    uint32_t addr;
    uint8_t dq;

    tb->open_trace(trace_string.c_str());
    tb->tick(10);
}
