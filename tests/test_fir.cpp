#include "VFir.h"
#include "testbench.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/fir/"
#define RESET_DURATION  10

using Abies::Testbench;

TEST_GROUP(FirGroup)
{
    Testbench<VFir> *tb;

    void setup()
    {
        // Create a new trace using the test name.
        std::string test_name(UtestShell::getCurrent()->getName().asCharString());
        std::string trace_path(TRACE_PATH_BASE + test_name + ".vcd");

        tb = new Testbench<VFir>(trace_path);
    }

    void teardown()
    {
        delete tb;
        tb = NULL;
    }
};

TEST(FirGroup, basic)
{
    tb->top->rst = 1;
    tb->tick(RESET_DURATION);
    tb->top->rst = 0;
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
    tb->top->rst = 1;
    tb->tick(RESET_DURATION);
    tb->top->rst = 0;
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
