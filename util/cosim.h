#pragma once

#include <vector>
#include <stdint.h>
#include <iostream>

namespace Abies {
    // Co-Simulation class for C++ models, peripherals.
    class CoSim {
    public:
        // Clk used for Rising/Falling edge methods.
        // CoSim(uint8_t& clk) : m_clk(clk), m_clk_prev(clk)
        // Sensitivity list. Used for rising/falling.
        CoSim(std::initializer_list<uint8_t*> slist)
        {
            m_slist.resize(slist.size(), 0);
            m_slist = slist;
            m_slist_prev.resize(slist.size(), 0);
        };
        ~CoSim() {};
        int rising_edge(uint8_t& clk)
        {
            unsigned int s_index = 0;
            int found = 0;
            // Find reference in sensitivity list.
            for (s_index = 0; s_index < m_slist.size(); s_index++) {
                if (m_slist[s_index] == &clk) {
                    found = 1;
                    break;
                }
            }
            // Rising edge detected.
            return (found && (*m_slist[s_index] && !m_slist_prev[s_index]));
        }
        int falling_edge(uint8_t& clk)
        {
            unsigned int s_index = 0;
            int found = 0;
            // Find reference in sensitivity list.
            for (s_index = 0; s_index < m_slist.size(); s_index++) {
                if (m_slist[s_index] == &clk) {
                    found = 1;
                    break;
                }
            }
            // Falling edge detected.
            return (found && (!*m_slist[s_index] && m_slist_prev[s_index]));
        }
        virtual void eval(void)=0;
        virtual void update_slist(void)
        {
            // Call derived-class 'eval' before update_slist()
            // Save sensitivity list at end of evaluation
            for (unsigned int s_index = 0; s_index < m_slist_prev.size(); s_index++) {
                m_slist_prev[s_index] = *m_slist[s_index];
            }
        };
    private:
        std::vector<uint8_t*> m_slist;
        std::vector<uint8_t> m_slist_prev; 
    };
}
