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
    const unsigned int duration = 524288;
    const unsigned int skip = 32;
    std::string trace_string = TRACE_PATH_BASE;
    trace_string += "read_init.vcd";
    tb->open_trace(trace_string.c_str());

    extsram->init("../mem/sin_w8_d19.coe");

    tb->reset(RESET_DURATION);
    tb->tick();

    tb->top->en = 1;
    tb->top->ena = 1;
    tb->top->wea = 0;
    
    tb->tick();
    for (int i = 0; i < duration; i+=skip) {
        tb->top->addra = i;
        tb->tick();
    }
}
