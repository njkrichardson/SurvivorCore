setup :
	docker build --tag hdl:latest . 

run :
	docker run -dt -v $(shell pwd):"/circuit_design" --name hdl hdl:latest /bin/zsh 
clean :
	docker stop hdl && docker rm hdl 

shell : 
	docker exec -it hdl /bin/zsh 

test : tests/test_load_memory.cpp
	# instruction memory 
	docker exec hdl verilator --trace --cc --top-module instruction_memory design/memory.sv --exe tests/test_load_memory.cpp
	docker exec hdl make -C obj_dir -f Vinstruction_memory.mk Vinstruction_memory
	docker exec hdl ./obj_dir/Vinstruction_memory

test_core : tests/test_single_cycle.cpp
	docker exec hdl verilator --trace --cc --top-module processor design/processor.sv \
		design/memory.sv \
		design/single_cycle_arm.sv \
		design/controller.sv \
		design/core.sv \
		design/state.sv \
		design/datapath.sv \
		design/alu.sv \
		design/decode.sv \
		--exe tests/test_single_cycle.cpp
	docker exec hdl make -C obj_dir -f Vprocessor.mk Vprocessor
	docker exec hdl ./obj_dir/Vprocessor
