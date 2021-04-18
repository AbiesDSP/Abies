#include "VI2S.h"
#include "testbench.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/i2s/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

/* Audio clock period
    tsamp = 1 / 48e03
    tsamp(ps) = tsamp / 1e-012
*/

#define AUDIO_CLK_PERIOD 81830
using Abies::Testbench;

TEST_GROUP(I2SGroup)
{
    Testbench<VI2S> *tb;

    void setup()
    {
        // Create a new trace using the test name.
        std::string test_name(UtestShell::getCurrent()->getName().asCharString());
        std::string trace_path(TRACE_PATH_BASE + test_name + ".vcd");

        tb = new Testbench<VI2S>(trace_path, AUDIO_CLK_PERIOD);
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(I2SGroup, basic)
{
    unsigned int max_val = 420000;
    tb->top->rst = 1;
    tb->tick(10);
    tb->top->rst = 0;

    for (unsigned int ii=0; ii<max_val; ii+=1001) {
        while (!tb->top->rd_en) {
            tb->tick();
        }
        tb->top->ldac = ii;
        tb->top->rdac = ii;
        tb->top->rd_valid = 1;
        tb->tick();
        tb->top->rd_valid = 0;
        
        while (!tb->top->adc_valid) {
            tb->tick();
        }
        CHECK_EQUAL(ii, tb->top->ladc);
        CHECK_EQUAL(ii, tb->top->radc);
    }
}
