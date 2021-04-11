#include "VSramArbiter.h"
#include "testbench.h"
#include "sram.h"

#include "CppUTest/TestHarness.h"
#include <string>
#include <math.h>

#define TRACE_PATH_BASE "./traces/sram_arbiter/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

using Abies::Testbench;
using Abies::Sram;

static void init_sin(Sram *sr)
{
    double step;

    step = (2.0 * M_PI) / sr->size();
    for (size_t i = 0; i < sr->size(); i++) {
        double entry = 255.0 * ((sin(i*step) + 1.0)/2.0);
        sr->ram_data[i] = entry;
    }
}

TEST_GROUP(SramArbiterGroup)
{
    Testbench<VSramArbiter> *tb;
    Sram *extsram;

    void setup()
    {
        tb = new Testbench<VSramArbiter>;
        extsram = new Sram(
            8,
            19,
            8,
            tb->top->clk,
            tb->top->sram_addr,
            tb->top->sram_ce_n,
            tb->top->sram_we_n,
            tb->top->sram_oe_n,
            tb->top->sram_dq_wr,
            tb->top->sram_dq_rd
        );
        tb->cosim_attach(extsram);
    }

    void teardown()
    {
        delete tb;
        delete extsram;
        tb = NULL;
    }
};

TEST(SramArbiterGroup, read_init)
{
    // const unsigned int duration = 524288;
    const unsigned int duration = 524288;
    const unsigned int skip = 1;
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "read_init.vcd";
    tb->open_trace(trace_string.c_str());

    init_sin(extsram);

    tb->reset(RESET_DURATION);

    tb->tick(2);

    tb->top->en = 1;
    tb->top->ena = 1;
    tb->top->wea = 0;
    
    // 1 cycle latency.
    tb->tick();
    for (int i = 0; i < duration; i+=skip) {
        tb->top->addra = i;
        tb->tick();
    }
}
