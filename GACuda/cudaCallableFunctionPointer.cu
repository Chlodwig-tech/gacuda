#ifndef CUDA_CALLABLE_FUNCTION_POINTER
#define CUDA_CALLABLE_FUNCTION_POINTER

/*-----------------cudaCallableFunctionPointer-----------------*/

template<typename T> struct cudaCallableFunctionPointer{
  cudaCallableFunctionPointer(T* f_);
  ~cudaCallableFunctionPointer();
  T* ptr;
};

template<typename T> cudaCallableFunctionPointer<T>::cudaCallableFunctionPointer(T* f_){
    T* host_ptr = (T*)malloc(sizeof(T));
    CUDA_CALL(cudaMalloc((void**)&ptr, sizeof(T)), "cudaMalloc f_ (cudaCallableFunctionPointer)");

    CUDA_CALL(cudaMemcpyFromSymbol(host_ptr, *f_, sizeof(T)), "cudaMemcpyFromSymbol f_ (cudaCallableFunctionPointer)");
    CUDA_CALL(cudaMemcpy(ptr, host_ptr, sizeof(T), cudaMemcpyHostToDevice), "cudaMemcpy f_ (cudaCallableFunctionPointer)");
    
    free(host_ptr);
}

template<typename T> cudaCallableFunctionPointer<T>::~cudaCallableFunctionPointer(){
    CUDA_CALL(cudaFree(ptr), "cudaFree f_ (cudaCallableFunctionPointer)");
}

#endif // CUDA_CALLABLE_FUNCTION_POINTER