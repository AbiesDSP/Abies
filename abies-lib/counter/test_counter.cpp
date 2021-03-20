#include "counter.h"
#include "CppUTest/TestHarness.h"

#define TRACE_PATH_BASE "./traces/counter/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10
#define N_CYCLES        (64u)
#define PERIOD          8

TEST_GROUP(CounterGroup)
{
    Counter *tb;

    void setup()
    {
        tb = new Counter;
        tb->set_period(PERIOD);
    }

    void teardown()
    {
        delete tb;
        tb = NULL;
    }
};

TEST(CounterGroup, tc_check)
{
    unsigned int counter_ctr = PERIOD;
    // Opening the file here lets us save file names with the test name.
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "tc_check.vcd";
    // Open trace for viewing.
    tb->open_trace(trace_string.c_str());
    tb->reset(RESET_DURATION);

    for (int i = 0; i < 10; i++) {tb->tick();}

    for (unsigned int i = 0; i < N_CYCLES; i++) {
        // Update Inputs:
        tb->top->en = 1;
        
        // Update Clock.
        tb->tick();

        // Check Outputs:
        // TC should be active when tc reaches the period.
        if (counter_ctr == 0) {
            counter_ctr = PERIOD;
            CHECK_EQUAL(1, tb->top->tc);
            CHECK_EQUAL(PERIOD, tb->top->counter__DOT__ctr);
        } else {
            counter_ctr--;
        }
    }
}
