NVCC=nvcc
CUDALIBDIR=/usr/local/cuda/lib64

all: main

main.o: main.cu ../GACuda/gacuda.h
	$(NVCC) -c -o $@ $< -allow-unsupported-compiler

main: main.o ../GACuda/.build/libgpu.a
	$(NVCC) $^ -o $@ -L$(CUDALIBDIR) -lcudart

clean:
	rm -f main main.o