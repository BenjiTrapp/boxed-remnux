.PHONY: all build start stop clean browser logs shell

all: build

build:
	docker build -t boxed-remnux .

start:
	docker run --rm -d -p 9020:8080 -p 5901:5900 --name boxed-remnux boxed-remnux

stop:
	docker rm -f boxed-remnux

clean:
	docker rmi boxed-remnux

browser:
	open "http://localhost:9020/vnc.html"

logs:
	docker logs boxed-remnux

shell:
	docker exec -it boxed-remnux bash
