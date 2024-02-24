/* Basic test for the Arm single-cycle processor implementationl. We run 
 * a short test program provided in vectors/basic.dat, and confirm that 
 * the program results in the value 7 written to the data memory at address 
 * 100. 
 *
 * If supported, this test can be used to generate a vcd for viewing waveforms 
 * in an application like GTKWave. 
 */
#include <iostream>
#include <stdlib.h>

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vprocessor.h"

#define MAX_SIMULATION_DURATION 100

int main(int argc, char **argv, char **env) {
  vluint64_t simulation_time{0};
  Vprocessor *dut = new Vprocessor;

  Verilated::traceEverOn(true);
  VerilatedVcdC *m_trace = new VerilatedVcdC;
  int max_depth{9};
  dut->trace(m_trace, max_depth);
  m_trace->open("vcds/processor.vcd");

  // reset the processor
  dut->reset = 1;
  m_trace->dump(simulation_time);
  dut->reset = 0;

  while (simulation_time <= MAX_SIMULATION_DURATION) {
    dut->clock ^= 1;
    dut->eval();
    m_trace->dump(simulation_time);
    simulation_time++;

    if (dut->write_memory) {
      if (dut->address == 100 && dut->write_data == 7) {
        std::cout << "Simulation succeeded!" << std::endl;
        break;
      }
    }
  }

  m_trace->close();
  delete dut;
  exit(EXIT_SUCCESS);
  return 0;
}
