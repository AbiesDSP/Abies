#include "VCobsCmdTb.h"
#include "testbench.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/cobs_cmd_tb/"
#define RESET_DURATION  10

using Abies::Testbench;

TEST_GROUP(CobsCmdTbGroup)
{
    Testbench<VCobsCmdTb> *tb;

    void setup()
    {
        // Create a new trace using the test name.
        std::string test_name(UtestShell::getCurrent()->getName().asCharString());
        std::string trace_path(TRACE_PATH_BASE + test_name + ".vcd");

        tb = new Testbench<VCobsCmdTb>(trace_path);
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(CobsCmdTbGroup, basic)
{
    const uint8_t msg_size = 4;
    uint8_t cmd[msg_size+2] = {5, 1, 2, 3, 4, 0};

    tb->tick(10);

    for (int i = 0; i < 6; i++) {
        tb->top->i_valid = 1;
        tb->top->i_data = cmd[i];
        tb->tick();
        tb->top->i_valid = 0;
        tb->tick(9);
    }

    tb->tick(100);
}
