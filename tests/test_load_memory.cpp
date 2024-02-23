#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vinstruction_memory.h" 

#define SIMULATION_DURATION 23

int main(int argc, char** argv, char** env) {
    vluint64_t simulation_time{0}; 
    Vinstruction_memory * dut = new Vinstruction_memory; 

    Verilated::traceEverOn(true); 
    VerilatedVcdC* m_trace = new VerilatedVcdC; 
    int max_depth{5}; 
    dut->trace(m_trace, max_depth); 
    m_trace->open("vcds/instruction_memory.vcd"); 

    uint64_t address{0}; 

    while(simulation_time <= SIMULATION_DURATION) {
        dut->address = address; 
        dut->eval(); 
        m_trace->dump(simulation_time); 
        simulation_time++; 
        address += 4; 
    }

    m_trace->close(); 
    delete dut; 
    exit(EXIT_SUCCESS);
    return 0; 
}
