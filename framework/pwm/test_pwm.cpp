#include "VPwm.h"
#include "testbench.h"
#include "CppUTest/TestHarness.h"

#define TRACE_PATH_BASE "./traces/pwm/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

using Abies::Testbench;

TEST_GROUP(PwmGroup)
{
    Testbench<VPwm> *tb;

    void setup()
    {
        // Create a new trace using the test name.
        std::string test_name(UtestShell::getCurrent()->getName().asCharString());
        std::string trace_path(TRACE_PATH_BASE + test_name + ".vcd");

        tb = new Testbench<VPwm>(trace_path);
    }

    void teardown()
    {
        delete tb;
        tb = NULL;
    }
};

TEST(PwmGroup, dc_check)
{
    const unsigned int duty = 128;

    tb->top->rst = 1;
    tb->tick(RESET_DURATION);
    tb->top->rst = 0;

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
