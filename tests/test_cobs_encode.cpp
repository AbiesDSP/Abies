#include "VCobsEncode.h"
#include "testbench.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/cobs_encode/"
#define RESET_DURATION  10

using Abies::Testbench;

TEST_GROUP(CobsEncodeGroup)
{
    Testbench<VCobsEncode> *tb;

    void setup()
    {
        // Create a new trace using the test name.
        std::string test_name(UtestShell::getCurrent()->getName().asCharString());
        std::string trace_path(TRACE_PATH_BASE + test_name + ".vcd");

        tb = new Testbench<VCobsEncode>(trace_path);
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(CobsEncodeGroup, basic)
{
    const uint8_t msg_length = 5;
    uint8_t cmd[msg_length] = {0, 1, 2, 3, 0};

    tb->tick(10);
    tb->top->i_ready = 1;
    for (int i = 0; i < msg_length; i++) {
        tb->top->i_valid = 1;
        tb->top->i_data = cmd[i];
        tb->top->i_last = i==4;
        tb->tick();
        tb->top->i_valid = 0;
        tb->top->i_last = 0;
        tb->tick(2);
    }
    tb->tick(2);
    for (int i = 0; i < 10; i++) {
        while (!tb->top->o_valid){tb->tick();};
        if (tb->top->o_last) break;
        tb->top->i_ready = 0;
        tb->tick(9);
        tb->top->i_ready = 1;
        tb->tick();
    }

    tb->tick(100);
}
