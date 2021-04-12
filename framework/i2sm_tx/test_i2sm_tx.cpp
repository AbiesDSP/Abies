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
        tb = new Testbench<VI2SMTx>;
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(I2SMTxGroup, basic)
{
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "basic.vcd";
    tb->open_trace(trace_string.c_str());
    tb->tick(1000);
}
