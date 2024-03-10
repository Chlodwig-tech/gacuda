#ifndef KERNELS_CU
#define KERNELS_CU
#include "gacuda.h"

/*template<typename T> __global__ void fitness_kernel(T *fitnesses, T *population, int population_size, int individual_size, T *addata, Func<T>* f){
    int index = blockDim.x * blockIdx.x + threadIdx.x;

    if(index < population_size){
        int individual_number = individual_size * index;
        
    }
}
template<typename T> __global__ void fitness_kernel(T *fitnesses, T *population, int population_size, int individual_size, Func<T>* f){
    int index = blockDim.x * blockIdx.x + threadIdx.x;

    if(index < population_size){

    }
}*/



#endif // KERNELS_CU