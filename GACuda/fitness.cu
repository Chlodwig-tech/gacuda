#ifndef FITNESS_CU
#define FITNESS_CU

#include "fitnessData.cu"
#include "cudaCallableFunctionPointer.cu"

#define CUDA_CALL(x, message) {if((x) != cudaSuccess) { \
    printf("%s(%d): error: %s\n", __FILE__, __LINE__, message); \
    exit(EXIT_FAILURE); }}

/*--------------------------------Fitness--------------------------------*/

template<typename T> using FitnessFunc = T (*)(T*, int, T*);
template<typename T> __device__ T fitness(T *population, int index, T *FitnessData=nullptr);
template<typename T> __device__ FitnessFunc<T> fitness_func = fitness;

template<typename T> __global__ void fitness_kernel(
    T *fitnesses, T *population, int population_size, T*addata, FitnessFunc<T>* f)
{
    int index = blockDim.x * blockIdx.x + threadIdx.x;

    if(index < population_size){
        fitnesses[index] = (*f)(population, index, addata);
    }
}

template<typename T> class Fitness{
public:
    T *data;
    int size;
    FitnessData<T> *fitnessData;
public:
    Fitness(int size);
    ~Fitness();
    void uploadFitnessData(T *hdata, int size);
    void evaluate(T* population);
    void evaluate(T* population, T *hdata);
};

template<typename T> Fitness<T>::Fitness(int size) : size(size){
    CUDA_CALL(cudaMalloc((void **)&data, size * sizeof(T)), "Fitness cudaMalloc");
    fitnessData = nullptr;
}

template<typename T> Fitness<T>::~Fitness(){
    CUDA_CALL(cudaFree(data), "Fitness cudaFree");
    if(fitnessData != nullptr)
        delete fitnessData;
}

template<typename T> void Fitness<T>::uploadFitnessData(T *hdata, int size){
    fitnessData = new FitnessData<T>(hdata, size);
}

template<typename T> void Fitness<T>::evaluate(T* population){
    int numThreads = 1024;
    int numBlocks = size / numThreads + 1;
    cudaCallableFunctionPointer<FitnessFunc<T>> ccfp(&fitness_func<T>);
    fitness_kernel<<<numBlocks, numThreads>>>(data, population, size, fitnessData->data, ccfp.ptr);
    cudaDeviceSynchronize();
}

template<typename T> void Fitness<T>::evaluate(T* population, T *hdata){
    evaluate(population);
    CUDA_CALL(cudaMemcpy(hdata, data, size * sizeof(T), cudaMemcpyDeviceToHost), "Fitness cudaMemcpy d2h");
}

#endif // FITNESS_CU