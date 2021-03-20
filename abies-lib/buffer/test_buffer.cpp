#include "buffer.h"
#include "CppUTest/TestHarness.h"

#define TRACE_PATH_BASE "./traces/buffer/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

TEST_GROUP(BufferGroup)
{
    Buffer *tb;

    void setup()
    {
        tb = new Buffer;
    }

    void teardown()
    {
        delete tb;
        tb = NULL;
    }
};

TEST(BufferGroup, basic)
{
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "basic.vcd";
    tb->open_trace(trace_string.c_str());
    tb->reset(RESET_DURATION);

    tb->top->en = 1;
    tb->top->sample_i = 42;

    // 
    for (int i = 0; i < 8; i++) {
        tb->tick();
        tb->top->sample_i++;
    }
    tb->top->en = 0;
    for (int i = 0; i < 8; i++) {
        tb->tick();
        CHECK_EQUAL(42 + i, tb->top->sample_o);
        CHECK_EQUAL(1, tb->top->valid);
    }
    tb->top->en = 1;
    tb->top->sample_i = 42;

    // do it again.
    for (int i = 0; i < 8; i++) {
        tb->tick();
        tb->top->sample_i++;
    }
    tb->top->en = 0;
    for (int i = 0; i < 8; i++) {
        tb->tick();
        CHECK_EQUAL(42 + i, tb->top->sample_o);
        CHECK_EQUAL(1, tb->top->valid);
    }
    // See the end of the waveform.
    for (int i = 0; i < 8; i++){tb->tick();}
}
