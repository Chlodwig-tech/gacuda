#ifndef FITNESS_DATA_H
#define FITNESS_DATA_H

/*--------------------------------FitnessData--------------------------------*/

template<typename T> struct FitnessData{
    T *data;
    int size;

    FitnessData(T *hdata, int size);
    ~FitnessData();
};

template<typename T> FitnessData<T>::FitnessData(T *hdata, int size) : size(size){
    CUDA_CALL(cudaMalloc((void **)&data, size * sizeof(T)), "FitnessData cudaMalloc");
    CUDA_CALL(cudaMemcpy(data, hdata, size * sizeof(T), cudaMemcpyHostToDevice), "FitnessData cudaMemcpy h2d");
}

template<typename T> FitnessData<T>::~FitnessData(){
    CUDA_CALL(cudaFree(data), "FitnessData cudaFree");
}

#endif // FITNESS_DATA_H