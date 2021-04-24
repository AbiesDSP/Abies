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
    tb->tick(100);
}
