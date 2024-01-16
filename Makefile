setup :
	docker build --tag hdl:latest . 

run :
	docker run -dt -v $(shell pwd):"/circuit_design" --name hdl hdl:latest /bin/zsh 
stop :
	docker stop hdl && docker rm hdl 

shell : 
	docker exec -it hdl /bin/zsh 
