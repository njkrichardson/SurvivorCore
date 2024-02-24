![armtest](https://github.com/njkrichardson/SurvivorCore/actions/workflows/single-cycle.yml/badge.svg?event=push)

## SurvivorCore 

This repository contains (very) basic processor implementations for the ApocalypseStack in the [SystemVerilog](https://en.wikipedia.org/wiki/SystemVerilog#:~:text=SystemVerilog%2C%20standardized%20as%20IEEE%201800,test%20and%20implement%20electronic%20systems.) HDL. I use [Verilator](https://www.veripool.org/verilator/) for linting and simulation, and the [Yosys](https://github.com/YosysHQ/yosys) synthesis suite, along with several open-source tools to target the [Lattice Ice40HX1k FPGA](https://www.digikey.com/en/products/detail/lattice-semiconductor-corporation/ICE40HX1K-STICK-EVN/4289604?utm_adgroup=&utm_source=google&utm_medium=cpc&utm_campaign=PMax%20Shopping_Product_Low%20ROAS%20Categories&utm_term=&utm_content=&utm_id=go_cmp-20243063506_adg-_ad-__dev-c_ext-_prd-4289604_sig-CjwKCAiAzJOtBhALEiwAtwj8tsEv08OAD9aENZi-URh97ZXJN-5Z8yJPRgj2hK7YBSriVwATMQiS0hoC3EIQAvD_BwE&gad_source=1&gclid=CjwKCAiAzJOtBhALEiwAtwj8tsEv08OAD9aENZi-URh97ZXJN-5Z8yJPRgj2hK7YBSriVwATMQiS0hoC3EIQAvD_BwE). 

### Usage 
The easiest way to get started is running via [Docker](https://docs.docker.com/reference/), using the provided Dockerfile.

```bash
$ make 
```

Several `make` targets are provided, the default target above builds a container image. To run the container, compile the processor, and run the tests, use the following targets: 

```bash
$ make run
$ make test_core 
```

### Waveforms 

Verilator provides a C++ interface to dump [VCD](https://en.wikipedia.org/wiki/Value_change_dump#:~:text=Value%20change%20dump%20(VCD)%20(,Standard%201364%2D1995%20in%201996.) files tracing interface and internal processor signals for debugging and viewing waveforms (for instance, in a GTK+ viwer). Our tests dump VCD files to the `vcds` directory at the project level, which can be viewed using: 

```bash
$ gtkwave vcds/*.vcd & 
```
