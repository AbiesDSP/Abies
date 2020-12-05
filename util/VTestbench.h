#ifndef TESTBENCH_H
#define TESTBENCH_H

#include "verilated_vcd_c.h"
#include <iostream>
#include <cstdint>

#define DEFAULT_CLOCK_PERIOD    (10)

template <class Vmodule> class VTestbench 
{
public:
    // Module under test.
    Vmodule         *m_top;
    // Tests can generate a trace.
    VerilatedVcdC   *m_trace;
    unsigned int    m_clockPeriod = DEFAULT_CLOCK_PERIOD;
    // Total elapsed clock cycles.
    uint64_t        m_cycleCtr;

    // Module can be initialized with a specific clock period, otherwise 100MHz will be used.
    VTestbench(unsigned int clockPeriod = DEFAULT_CLOCK_PERIOD) : m_trace(NULL), m_cycleCtr(0), m_clockPeriod(clockPeriod)
    {
        m_top = new Vmodule;
        Verilated::traceEverOn(true);   // Must always be called.
        // Start state is in reset
        m_top->clk = 1;
        m_top->rst = 1;
        eval();
    }

    virtual ~VTestbench(void)
    {
        // Always close traces on deletion.
        closeTrace();
        delete m_top;
        m_top = NULL;
    }

    // Open a new trace with the given filename.
    virtual void openTrace(const char *filename)
    {
        // Don't create duplicate traces.
        if (m_trace == NULL) {
            m_trace = new VerilatedVcdC;
            std::string timeUnit = std::to_string(m_clockPeriod / 2) + "ns";
            m_trace->set_time_resolution("1ns");
            m_trace->set_time_unit(timeUnit);
            m_top->trace(m_trace, 99);
            m_trace->open(filename);
        }
    }

    virtual void closeTrace(void)
    {
        if (m_trace) {
            m_trace->close();
            delete m_trace;
            m_trace = NULL;
        }
    }

    virtual void eval(void)
    {
        m_top->eval();
    }

    virtual void tick(void)
    {
        m_top->clk = 1;
        eval();
        if (m_trace) {
            m_trace->dump((vluint64_t)(m_cycleCtr * m_clockPeriod));
        }

        m_top->clk = 0;
        eval();
        if (m_trace) {
            m_trace->dump((vluint64_t)(m_cycleCtr * m_clockPeriod + m_clockPeriod / 2));
            m_trace->flush();
        }
        m_cycleCtr++;
    }

    // Hold in reset for N clock cycles.
    virtual void reset(unsigned int duration)
    {
        m_top->rst = 1;
        for (unsigned int i = 0; i < duration; i++) {
            tick();
        }
        m_top->rst = 0;
    }

    uint64_t cycles(void)
    {
        return m_cycleCtr;
    }
};

#endif
