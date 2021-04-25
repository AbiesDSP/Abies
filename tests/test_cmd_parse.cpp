#include "VCmdParse.h"
#include "testbench.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/cmd_parse/"
#define RESET_DURATION  10

using Abies::Testbench;

TEST_GROUP(CmdParseGroup)
{
    Testbench<VCmdParse> *tb;

    void setup()
    {
        // Create a new trace using the test name.
        std::string test_name(UtestShell::getCurrent()->getName().asCharString());
        std::string trace_path(TRACE_PATH_BASE + test_name + ".vcd");

        tb = new Testbench<VCmdParse>(trace_path);
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(CmdParseGroup, basic)
{
    const uint8_t msg_size = 4;
    uint8_t cmd[msg_size+1] = {1, 2, 3, 4, 0};

    tb->tick(10);

    for (int i = 0; i < 5; i++) {
        tb->top->i_valid = 1;
        tb->top->i_data = cmd[i];
        if (i==msg_size) tb->top->i_last = 1;
        tb->tick();
        tb->top->i_valid = 0;
        tb->top->i_last = 0;
        tb->tick(9);
    }

    tb->tick(100);
}
