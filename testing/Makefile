NVCC=nvcc
CUDALIBDIR=/usr/local/cuda/lib64

all: test

test.o: test.cu ../GACuda/gacuda.h
	$(NVCC) -c -o $@ $< -allow-unsupported-compiler

test: test.o ../GACuda/.build/libgpu.a
	$(NVCC) $^ -o $@ -L$(CUDALIBDIR) -lcudart

clean:
	rm -f test test.o