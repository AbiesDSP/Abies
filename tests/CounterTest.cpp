#include "Counter/CounterTb.h"
#include "Counter/Counter8Tb.h"
#include "CppUTest/TestHarness.h"

#define TRACE_PATH_BASE "./traces/counter/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10
#define N_CYCLES        64
#define PERIOD          8

TEST_GROUP(Counter)
{
    CounterTb *tb;
    Counter8Tb *tb8;

    void setup()
    {
        tb = new CounterTb;
        tb8 = new Counter8Tb;
        tb->setPeriod(PERIOD);
        tb8->setPeriod(PERIOD);
    }

    void teardown()
    {
        delete tb;
        delete tb8;
    }
};

TEST(Counter, tc_check)
{
    unsigned int counterCtr = PERIOD;
    // Opening the file here lets us save file names with the test name.
    std::string traceString = TRACE_PATH_BASE;
    traceString += "tc_check.vcd";
    // Open trace for viewing.
    tb->openTrace(traceString.c_str());
    tb->reset(RESET_DURATION);

    for (int i = 0; i < 10; i++) {tb->tick();}

    for (unsigned int i = 0; i < N_CYCLES; i++) {
        // Update Inputs:
        tb->m_top->en = 1;
        
        // Update Clock.
        tb->tick();

        // Check Outputs:
        // TC should be active when tc reaches the period.
        if (counterCtr == 0) {
            counterCtr = PERIOD;
            CHECK_EQUAL(1, tb->m_top->tc);
            CHECK_EQUAL(PERIOD, tb->m_top->counter__DOT____Vtogcov__ctr);
        } else {
            counterCtr--;
        }
    }
}

TEST(Counter, counter8bit)
{
    unsigned int counterCtr = PERIOD;
    // Opening the file here lets us save file names with the test name.
    std::string traceString = TRACE_PATH_BASE;
    traceString += "8bit_check.vcd";
    // Open trace for viewing.
    tb8->openTrace(traceString.c_str());
    tb8->reset(RESET_DURATION);

    for (int i = 0; i < 10; i++) {tb8->tick();}

    for (unsigned int i = 0; i < N_CYCLES; i++) {
        // Update Inputs:
        tb8->m_top->en = 1;
        
        // Update Clock.
        tb8->tick();

        // Check Outputs:
        // TC should be active when tc reaches the period.
        if (counterCtr == 0) {
            counterCtr = PERIOD;
            CHECK_EQUAL(1, tb8->m_top->tc);
            // CHECK_EQUAL(PERIOD, tb8->m_top->counter__DOT____Vtogcov__ctr);
        } else {
            counterCtr--;
        }
    }
}
