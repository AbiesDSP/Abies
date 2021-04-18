#pragma once
#include <stdint.h>
#include <iostream>

using std::cout;
using std::endl;

namespace Abies
{
    class ClkGen
    {
    public:
        // All time units are ns.
        // Assume clock starts at 0, immediately after a falling edge.
        ClkGen(uint64_t period) : period_(period), clk_(NULL), current_time_(0)
        {
        };
        ~ClkGen() {};

        void connect(uint8_t *clk)
        {
            clk_ = clk;
        }

        uint64_t period(void) {return period_;};

        uint64_t current(void)
        {
            return current_time_;
        };

        void next_edge(uint32_t offset=0)
        {
            uint64_t fall_remaining = period_ - (current_time_ % period_);
            uint64_t rise_remaining = period_ - ((current_time_ + period_ / 2) % period_);
            uint64_t next;

            if (!rise_remaining) {
                next = fall_remaining;
            } else if (!fall_remaining) {
                next = rise_remaining;
            } else {
                next = rise_remaining < fall_remaining ? rise_remaining : fall_remaining;
            }

            current_time_ += next - offset;
            if (clk_ && !(current_time_ % (period_ / 2))) {
                *clk_ = *clk_ ? 0 : 1;
            }
        }

    public:
        uint64_t period_;
        uint64_t current_time_;
    private:
        uint8_t *clk_;
    };
}