NVCC=nvcc
CUDALIBDIR=/usr/local/cuda/lib64
BUILD_DIR=.build

all: cu

cu: $(BUILD_DIR)/libgpu.a

$(BUILD_DIR)/temp.o: gacuda.cu gacuda.h
	$(NVCC) -rdc=true -c -o $@ $< -L$(CUDALIBDIR) -lcuda -allow-unsupported-compiler

$(BUILD_DIR)/gacuda.o: $(BUILD_DIR)/temp.o
	$(NVCC) -dlink -o $@ $^ -lcudart

$(BUILD_DIR)/libgpu.a: $(BUILD_DIR)/gacuda.o $(BUILD_DIR)/temp.o
	rm -f $@
	ar cru $@ $^
	ranlib $@

clean:
	rm -f $(BUILD_DIR)/*