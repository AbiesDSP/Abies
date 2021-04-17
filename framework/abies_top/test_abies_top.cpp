#include "VAbiesTop.h"
#include "testbench.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/abies_top/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10
#define AUDIO_CLK_PERIOD 81830

using Abies::Testbench;

TEST_GROUP(AbiesTopGroup)
{
    Testbench<VAbiesTop> *tb;

    void setup()
    {
        // Create a new trace using the test name.
        std::string test_name(UtestShell::getCurrent()->getName().asCharString());
        std::string trace_path(TRACE_PATH_BASE + test_name + ".vcd");

        tb = new Testbench<VAbiesTop>(trace_path, AUDIO_CLK_PERIOD);
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(AbiesTopGroup, basic)
{
    tb->tick(1000000);
}
