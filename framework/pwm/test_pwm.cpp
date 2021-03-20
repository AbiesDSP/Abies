#include "pwm.h"
#include "CppUTest/TestHarness.h"

#define TRACE_PATH_BASE "./traces/pwm/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

TEST_GROUP(PwmGroup)
{
    Pwm *tb;
    void setup()
    {
        tb = new Pwm;
    }

    void teardown()
    {
        tb->close_trace();
        delete tb;
        tb = NULL;
    }
};

TEST(PwmGroup, dc_check)
{
    const unsigned int duty = 128;

    // Opening the file here lets us save file names with the test name.
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "dc_check.vcd";
    // Open trace for viewing.
    tb->open_trace(trace_string.c_str());
    tb->reset(RESET_DURATION);

    tb->top->duty = duty;

    for (unsigned int i = 0; i < 1024; i++) {
        tb->tick();
        if (tb->top->q) {
            CHECK(i%256 < duty);
        } else {
            CHECK_FALSE(i%256 < duty);
        }
    }
}
