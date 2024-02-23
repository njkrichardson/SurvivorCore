#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vprocessor.h" 

#define SIMULATION_DURATION 22

int main(int argc, char** argv, char** env) {
    vluint64_t simulation_time{0}; 
    Vprocessor * dut = new Vprocessor; 

    Verilated::traceEverOn(true); 
    VerilatedVcdC* m_trace = new VerilatedVcdC; 
    int max_depth{5}; 
    dut->trace(m_trace, max_depth); 
    m_trace->open("vcds/processor.vcd"); 

    // reset the processor 
    dut->reset = 1; 
    dut->eval(); 
    dut->reset = 0; 

    while(simulation_time <= SIMULATION_DURATION) {
        dut->clock ^= 1; 
        dut->eval(); 
        m_trace->dump(simulation_time); 
        simulation_time++; 
    }

    m_trace->close(); 
    delete dut; 
    exit(EXIT_SUCCESS);
    return 0; 
}
