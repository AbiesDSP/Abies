#include "VI2SMTx.h"
#include "testbench.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/i2sm_tx/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

using Abies::Testbench;

TEST_GROUP(I2SMTxGroup)
{
    Testbench<VI2SMTx> *tb;

    void setup()
    {
        // Create a new trace using the test name.
        std::string test_name(UtestShell::getCurrent()->getName().asCharString());
        std::string trace_path(TRACE_PATH_BASE + test_name + ".vcd");

        tb = new Testbench<VI2SMTx>(trace_path);
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(I2SMTxGroup, basic)
{
    tb->tick(1000);
}
