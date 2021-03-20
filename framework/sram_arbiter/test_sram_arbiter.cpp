#include "sram_arbiter.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/sram_arbiter/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

TEST_GROUP(SramArbiterGroup)
{
    SramArbiter *tb;

    void setup()
    {
        tb = new SramArbiter;
    }

    void teardown()
    {
        delete tb;
        tb = NULL;
    }
};

TEST(SramArbiterGroup, read_init)
{
    // const unsigned int duration = 524288;
    const unsigned int duration = 524288;
    const unsigned int skip = 512;
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "read_init.vcd";
    tb->open_trace(trace_string.c_str());
    tb->reset(RESET_DURATION);
    tb->tick();
    tb->tick();
    tb->top->en = 1;
    tb->top->ena = 1;
    tb->top->wea = 0;
    
    // // Write to sram
    // for (int i = 0; i < 11; i++){
    //     tb.top->addra = i;
    //     tb.top->data_wr = i;
    //     tb.tick();
    // }
    // 1 cycle latency.
    tb->tick();
    for (int i = 0; i < duration; i+=skip) {
        tb->top->addra = i;
        tb->tick();
    }
}
