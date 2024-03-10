#ifndef POPULATION_CU
#define POPULATION_CU

#define CUDA_CALL(x, message) {if((x) != cudaSuccess) { \
    printf("%s(%d): error: %s\n", __FILE__, __LINE__, message); \
    exit(EXIT_FAILURE); }}
#define CUDA_GPU_CALL(x, message) {if((x) != cudaSuccess) { \
    printf("%s(%d): error: %s\n", __FILE__, __LINE__, message);}}

template<typename T> __device__ void swap(T *a, T *b){
    T temp = *a;
    *a = *b;
    *b = temp;
}

template<typename T> __device__ void swap(T* a, int i, int j, int size){
    int n = size * sizeof(T);
    i *= size;
    j *= size;
    T *temp = (T*)malloc(n);
    memcpy(temp, &a[i], n);
    memcpy(&a[i], &a[j], n);
    memcpy(&a[j], temp, n);
    free(temp);
}

template<typename T> __global__ void bitonicSortKernel(T *array, int population_size, int individual_size, T *keys, int j, int k){
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    int ixj = tid ^ j;

    if(tid < population_size && ixj > tid && !(((tid & k) == 0) ^ (keys[tid] > keys[ixj]))){
        swap(array, tid, ixj, individual_size);
        swap(&keys[tid], &keys[ixj]);
    }
}

template<typename T> void bitonicSort(T *array, int population_size, int individual_size, T *keys){
    T *xd = new T[5];
    CUDA_CALL(cudaMemcpy(xd, keys, 5 * sizeof(T), cudaMemcpyDeviceToHost), "Fitness cudaMemcpy d2h");
    for(int i = 0; i < 5; i++){
        printf("%d\n", xd[i]);
    }
    delete[] xd;
    int numThreads = 1024;
    int numBlocks = population_size / numThreads + 1;
    for(int k = 2; k <= population_size; k *= 2){
        for(int j = k >> 1; j > 0; j >>= 1){
            bitonicSortKernel<<<numBlocks, numThreads>>>(array, population_size, individual_size, keys, j, k);
            cudaDeviceSynchronize();
        }
    }
}
    
/*--------------------------------Population--------------------------------*/

template<typename T> class Population{
public:
    T *data;
    int population_size;
    int individual_size;
    int size;

    void sort(T *fitnesses);
public:
    Population(int individual_size, int population_size);
    ~Population();
    void Get(T *hdata);
    void Set(T *hdata);
};


template<typename T> void Population<T>::sort(T *fitnesses){
    bitonicSort<T>(data, population_size, individual_size, fitnesses);
}

template<typename T> Population<T>::Population(
    int individual_size, int population_size
):
    individual_size(individual_size),
    population_size(population_size)
{
    size = individual_size * population_size;
    CUDA_CALL(cudaMalloc((void **)&data, size * sizeof(T)), "Population cudaMalloc");
}

template<typename T> Population<T>::~Population(){
    CUDA_CALL(cudaFree(data), "Population cudaFree");
}

template<typename T> void Population<T>::Get(T *hdata){
    CUDA_CALL(cudaMemcpy(hdata, data, size * sizeof(T), cudaMemcpyDeviceToHost), "Population cudaMemcpy d2h");
}
template<typename T> void Population<T>::Set(T *hdata){
    CUDA_CALL(cudaMemcpy(data, hdata, size * sizeof(T), cudaMemcpyHostToDevice), "Population cudaMemcpy h2d");
}

#endif // POPULATION_CU