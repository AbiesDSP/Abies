#pragma once

#include "co_sim.h"
#include "verilated_vcd_c.h"
#include <list>
#include <iostream>
#include <string.h>
#include <stdint.h>

#define DEFAULT_CLOCK_PERIOD    (10)

namespace Abies
{
    template <class Vmodule>
    class Testbench 
    {
    public:
        // Module under test.
        Vmodule         *top;
        // Tests can generate a trace.
        VerilatedVcdC   *trace;
        unsigned int    clock_period = DEFAULT_CLOCK_PERIOD;
        // Total elapsed clock cycles.
        uint64_t        cycle_ctr;
        // External co-simulations driven by this testbench.
        std::list<CoSim*> ext_sims;

        // Module can be initialized with a specific clock period, otherwise 100MHz will be used.
        Testbench(std::string trace_path, unsigned int clock_period = DEFAULT_CLOCK_PERIOD) : trace(NULL), cycle_ctr(0), clock_period(clock_period)
        {
            top = new Vmodule;
            Verilated::traceEverOn(true);   // Must always be called.
            if (!trace_path.empty()) {
                open_trace(trace_path);
            }
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
        virtual void open_trace(std::string trace_path)
        {
            // Don't create duplicate traces.
            if (trace == NULL) {
                trace = new VerilatedVcdC;
                std::string time_unit = std::to_string(clock_period / 2) + "ns";
                trace->set_time_resolution("1ns");
                trace->set_time_unit(time_unit);
                top->trace(trace, 99);
                trace->open(trace_path.c_str());
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

        void cosim_attach(CoSim *extsim)
        {
            if (extsim) {
                ext_sims.push_back(extsim);
            }
        }

        void cosim_detach(CoSim *extsim)
        {
            ext_sims.erase(std::remove(ext_sims.begin(), ext_sims.end(), extsim));
        }

        virtual void eval(void)
        {
            // Evaluate co-simulations.
            for (auto sim : ext_sims) {
                sim->eval();
                sim->update_slist();
            }
            // Evaluate HDL
            top->eval();
        }

        virtual void tick(void)
        {
            cycle_ctr++;
            top->clk = 0;
            eval();
            if (trace) {
                trace->dump((vluint64_t)(cycle_ctr * clock_period - (clock_period/10)));
            }

            top->clk = 1;
            eval();
            if (trace) {
                trace->dump((vluint64_t)(cycle_ctr * clock_period));
            }
            top->clk = 0;
            eval();
            if (trace) {
                trace->dump((vluint64_t)(cycle_ctr * clock_period + (clock_period / 2)));
                trace->flush();
            }
        }
        virtual void tick(unsigned int duration)
        {
            for (unsigned int i = 0; i < duration; i++) {
                tick();
            }
        }

        uint64_t cycles(void)
        {
            return cycle_ctr;
        }
    };
}
