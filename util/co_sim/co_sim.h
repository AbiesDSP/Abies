#pragma once

#include <vector>
#include <stdint.h>
#include <iostream>

namespace Abies {
    // Co-Simulation class for C++ models, peripherals.
    class CoSim {
    public:
        // Sensitivity list. Used for rising/falling.
        CoSim(std::initializer_list<uint8_t*> slist) : slist_(slist), slist_prev_(slist.size(),0)
        {
            for (size_t i = 0; i < slist.size(); i++) {
                slist_prev_[i] = *slist_[i];
            }
        };
        ~CoSim() {};
        int rising_edge(uint8_t& clk)
        {
            unsigned int s_index = 0;
            int found = 0;
            // Find reference in sensitivity list.
            for (s_index = 0; s_index < slist_.size(); s_index++) {
                if (slist_[s_index] == &clk) {
                    found = 1;
                    break;
                }
            }
            // Rising edge detected.
            return (found && (*slist_[s_index] && !slist_prev_[s_index]));
        }
        int falling_edge(uint8_t& clk)
        {
            unsigned int s_index = 0;
            int found = 0;
            // Find reference in sensitivity list.
            for (s_index = 0; s_index < slist_.size(); s_index++) {
                if (slist_[s_index] == &clk) {
                    found = 1;
                    break;
                }
            }
            // Falling edge detected.
            return (found && (!*slist_[s_index] && slist_prev_[s_index]));
        }
        virtual void eval(void)=0;
        virtual void update_slist(void)
        {
            // Call derived-class 'eval' before update_slist()
            // Save sensitivity list at end of evaluation
            for (unsigned int s_index = 0; s_index < slist_prev_.size(); s_index++) {
                slist_prev_[s_index] = *slist_[s_index];
            }
        };
    private:
        std::vector<uint8_t*> slist_;
        std::vector<uint8_t> slist_prev_; 
    };
}
