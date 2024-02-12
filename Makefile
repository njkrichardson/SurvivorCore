setup :
	docker build --tag hdl:latest . 

run :
	docker run -dt -v $(shell pwd):"/circuit_design" --name hdl hdl:latest /bin/zsh 
stop :
	docker stop hdl && docker rm hdl 

shell : 
	docker exec -it hdl /bin/zsh 

test : tests/mux2_tb.sv
	# tristate buffer
	docker exec hdl iverilog -g2005-sv -o tests/bin/tristate_buffer_tb ./design/core.sv ./tests/tristate_buffer_tb.sv 
	docker exec hdl ./tests/bin/mux2_tb
	
	# mux2 
	docker exec hdl iverilog -g2005-sv -o tests/bin/mux2_tb ./design/core.sv ./tests/mux2_tb.sv 
	docker exec hdl ./tests/bin/mux2_tb

	# decoder
	docker exec hdl iverilog -g2005-sv -o tests/bin/decoder_tb ./design/core.sv ./tests/decoder_tb.sv 
	docker exec hdl ./tests/bin/decoder_tb
