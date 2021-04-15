#include "VFifo.h"
#include "testbench.h"
#include "CppUTest/TestHarness.h"
#include <string>

#define TRACE_PATH_BASE "./traces/fifo/"
#define CLOCK_PERIOD    10
#define RESET_DURATION  10

using Abies::Testbench;

TEST_GROUP(FifoGroup)
{
    Testbench<VFifo> *tb;

    void setup()
    {
        // Create a new trace using the test name.
        std::string test_name(UtestShell::getCurrent()->getName().asCharString());
        std::string trace_path(TRACE_PATH_BASE + test_name + ".vcd");

        tb = new Testbench<VFifo>(trace_path);
    }

    void teardown()
    {
        delete tb;
    }
};

TEST(FifoGroup, write2read2)
{
    tb->tick(10);

    for (int j = 0; j < 10; j++) {
        // Write two elements into 4-deep fifo
        for (int i = 0; i < 2; i++) {
            tb->top->i_wr = 1;
            tb->top->i_wdata = j+42;
            tb->tick();
            tb->top->i_wr = 0;
            tb->tick(3);
        }
        tb->top->i_wr = 0;
        tb->tick(2);
        for (int i = 0; i < 2; i++) {
            tb->top->i_rd = 1;
            tb->tick();
            tb->top->i_rd = 0;
            tb->tick(3);
        }
        tb->tick(2);
    }
}

TEST(FifoGroup, almostflags)
{
    tb->tick(10);

    tb->top->i_wr = 1;
    tb->top->i_wdata = 42;
    tb->tick();
    tb->top->i_wr = 0;
    tb->tick();
    CHECK_EQUAL(1, tb->top->o_rempty);
    CHECK_EQUAL(0, tb->top->o_wfull);
    
    tb->top->i_wr = 1;
    tb->top->i_wdata = 43;
    tb->tick();
    tb->top->i_wr = 0;
    tb->tick();
    CHECK_EQUAL(0, tb->top->o_rempty);
    CHECK_EQUAL(0, tb->top->o_wfull);

    tb->top->i_wr = 1;
    tb->top->i_wdata = 44;
    tb->tick();
    tb->top->i_wr = 0;
    tb->tick();
    CHECK_EQUAL(0, tb->top->o_rempty);
    CHECK_EQUAL(1, tb->top->o_wfull);

    //
    tb->top->i_wr = 1;
    tb->top->i_wdata = 45;
    tb->tick();
    tb->top->i_wr = 0;
    tb->tick();
    CHECK_EQUAL(0, tb->top->o_rempty);
    CHECK_EQUAL(1, tb->top->o_wfull);

    tb->top->i_rd = 1;
    tb->tick();
    tb->top->i_rd = 0;
    CHECK_EQUAL(42, tb->top->o_rdata);
    tb->tick();
    CHECK_EQUAL(0, tb->top->o_rempty);
    CHECK_EQUAL(1, tb->top->o_wfull);
    tb->top->i_rd = 1;
    tb->tick();
    tb->top->i_rd = 0;
    CHECK_EQUAL(43, tb->top->o_rdata);
    tb->tick();
    CHECK_EQUAL(0, tb->top->o_rempty);
    CHECK_EQUAL(0, tb->top->o_wfull);
    tb->top->i_rd = 1;
    tb->tick();
    tb->top->i_rd = 0;
    CHECK_EQUAL(44, tb->top->o_rdata);
    tb->tick();
    CHECK_EQUAL(1, tb->top->o_rempty);
    CHECK_EQUAL(0, tb->top->o_wfull);
    tb->top->i_rd = 1;
    tb->tick();
    tb->top->i_rd = 0;
    CHECK_EQUAL(45, tb->top->o_rdata);
    tb->tick();
    CHECK_EQUAL(1, tb->top->o_rempty);
    CHECK_EQUAL(0, tb->top->o_wfull);
}

TEST(FifoGroup, overflow)
{
    tb->tick(10);

    // Write two elements into 4-deep fifo
    for (int i = 0; i < 5; i++) {
        tb->top->i_wr = 1;
        tb->top->i_wdata = i+42;
        tb->tick();
        tb->top->i_wr = 0;
        tb->tick(3);
    }
    tb->top->i_wr = 0;
    tb->tick(2);
    for (int i = 0; i < 2; i++) {
        tb->top->i_rd = 1;
        tb->tick();
        tb->top->i_rd = 0;
        tb->tick(3);
    }
    tb->tick(2);
}