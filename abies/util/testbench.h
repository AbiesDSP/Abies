#ifndef TESTBENCH_H
#define TESTBENCH_H

#include "verilated_vcd_c.h"
#include <iostream>
#include <cstdint>

#define DEFAULT_CLOCK_PERIOD    (10)

namespace WD
{
    template <class Vmodule> class Testbench 
    {
    public:
        // Module under test.
        Vmodule         *top;
        // Tests can generate a trace.
        VerilatedVcdC   *trace;
        unsigned int    clock_period = DEFAULT_CLOCK_PERIOD;
        // Total elapsed clock cycles.
        uint64_t        cycle_ctr;

        // Module can be initialized with a specific clock period, otherwise 100MHz will be used.
        Testbench(unsigned int clock_period = DEFAULT_CLOCK_PERIOD) : trace(NULL), cycle_ctr(0), clock_period(clock_period)
        {
            top = new Vmodule;
            Verilated::traceEverOn(true);   // Must always be called.
            // Start state is in reset
            top->clk = 1;
            eval();
        }

        virtual ~Testbench(void)
        {
            // Always close traces on deletion.
            close_trace();
            delete top;
            top = NULL;
        }

        // Open a new trace with the given filename.
        virtual void open_trace(const char *filename)
        {
            // Don't create duplicate traces.
            if (trace == NULL) {
                trace = new VerilatedVcdC;
                std::string time_unit = std::to_string(clock_period / 2) + "ns";
                trace->set_time_resolution("1ns");
                trace->set_time_unit(time_unit);
                top->trace(trace, 99);
                trace->open(filename);
            }
        }

        virtual void close_trace(void)
        {
            if (trace) {
                trace->close();
                delete trace;
                trace = NULL;
            }
        }

        virtual void eval(void)
        {
            top->eval();
        }

        virtual void tick(void)
        {
            top->clk = 1;
            eval();
            if (trace) {
                trace->dump((vluint64_t)(cycle_ctr * clock_period));
            }

            top->clk = 0;
            eval();
            if (trace) {
                trace->dump((vluint64_t)(cycle_ctr * clock_period + clock_period / 2));
                trace->flush();
            }
            cycle_ctr++;
        }

        virtual void wait(unsigned int duration)
        {
            for (int i = 0; i < duration; i++) {
                tick();
            }
        }

        // Hold in reset for N clock cycles.
        virtual void reset(unsigned int duration)
        {
            // top->rst = 1;
            // for (unsigned int i = 0; i < duration; i++) {
            //     tick();
            // }
            // top->rst = 0;
        }

        uint64_t cycles(void)
        {
            return cycle_ctr;
        }
    };
}

#endif
