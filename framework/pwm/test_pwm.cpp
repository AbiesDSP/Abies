#include "VPwm.h"
#include "testbench.h"
#include "clk_gen.h"
#include "CppUTest/TestHarness.h"

#define TRACE_PATH_BASE "./traces/pwm/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

using Abies::Testbench;
using Abies::ClkGen;

TEST_GROUP(PwmGroup)
{
    Testbench<VPwm> *tb;
    ClkGen *clk;

    void setup()
    {
        // Create a new trace using the test name.
        std::string test_name(UtestShell::getCurrent()->getName().asCharString());
        std::string trace_path(TRACE_PATH_BASE + test_name + ".vcd");

        clk = new ClkGen(10000);
        tb = new Testbench<VPwm>(trace_path, clk);
        clk->connect(&tb->top->clk);
    }

    void teardown()
    {
        delete tb;
        delete clk;
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
