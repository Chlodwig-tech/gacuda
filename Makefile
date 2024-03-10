GREEN = \033[1;32m
RESET = \033[0m

NVCC=nvcc
CXX=g++
CUDALIBDIR=/usr/local/cuda/lib64
BUILD_DIR=.build

.PHONY: all gacuda src testing clean

all: clean gacuda src testing

gacuda:
	@tput setaf 3
	$(MAKE) -C GACuda
	@tput sgr0

src:
	@tput setaf 6
	$(MAKE) -C src
	@tput sgr0

testing:
	@tput setaf 5
	$(MAKE) -C testing
	@tput sgr0

clean:
	$(MAKE) -C src clean
	$(MAKE) -C testing clean
	$(MAKE) -C GACuda clean

run:
	./src/main
test:
	./testing/test