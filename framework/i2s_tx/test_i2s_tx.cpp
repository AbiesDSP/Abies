#include "i2s_tx.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/i2s_tx/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

TEST_GROUP(I2STxGroup)
{
    I2STx *tb;

    void setup()
    {
        tb = new I2STx;
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(I2STxGroup, basic)
{
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "basic.vcd";
    tb->open_trace(trace_string.c_str());
    tb->reset(RESET_DURATION);
}
