#include "sram_arbiter/sram_arbiter.h"
#include "CppUTest/TestHarness.h"

#define TRACE_PATH_BASE "./traces/sram_arbiter/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

TEST_GROUP(SramArbiter)
{
    SramArbiter *tb;

    void setup()
    {
        tb = new SramArbiter;
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(SramArbiter, read_init)
{
    // const unsigned int duration = 524288;
    const unsigned int duration = 1024;
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
    //     tb->top->addra = i;
    //     tb->top->data_wr = i;
    //     tb->tick();
    // }
    // 1 cycle latency.
    tb->tick();
    for (int i = 1; i < duration; i++) {
        tb->top->addra = i;
        tb->tick();
        CHECK_EQUAL(tb->top->data_rd, (i - 1)%256);
    }
}
