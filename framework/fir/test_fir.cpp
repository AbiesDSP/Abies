#include "fir.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/fir/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

TEST_GROUP(FirGroup)
{
    Fir *tb;

    void setup()
    {
        tb = new Fir;
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(FirGroup, basic)
{
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "basic.vcd";
    tb->open_trace(trace_string.c_str());
    tb->reset(RESET_DURATION);
    // tb->tick();
    
    for (int i = 6; i < 20; i++) {
        tb->top->ce = 1;
        tb->top->samp_i = i;
        tb->tick();
        tb->top->ce = 0;
        tb->tick(4);
    }
}

TEST(FirGroup, bandpass)
{
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "bandpass.vcd";
    tb->open_trace(trace_string.c_str());
    tb->reset(RESET_DURATION);
    tb->tick();

    int16_t ampl = 0;
    double gain = 0.3;
    double phase = 0;
    double dc_offset = 14000; 
    double f = 8000;
    unsigned long long i;
    const unsigned long long max_iter = 200;
    for (i = 0; i < max_iter; i++) {
        ampl = (gain * 32767 * sin(2*M_PI*f*(i/1000000.0))) + dc_offset;
        tb->top->ce = 1;
        tb->top->samp_i = ampl;
        tb->tick();
        tb->top->ce = 0;
        tb->tick(99);
    }
    // 100k wave?
}
