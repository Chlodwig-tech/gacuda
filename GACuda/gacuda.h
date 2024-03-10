#ifndef GACUDA_H
#define GACUDA_H

#include <iostream>
#include "population.cu"
#include "fitness.cu"

/*--------------------------------GA--------------------------------*/

template<typename T> class GA{
    Population<T> *population;
    Fitness<T> *fitness;

public:
    GA(int individual_size, int population_size);
    ~GA();

    void upload(T *hdata);
    void download(T *hdata);
    void uploadFitnessData(T *hdata, int size);

    void start();

    void get_fitnesses(T *hfitnesses);
};

template<typename T> GA<T>::GA(int individual_size, int population_size){
    population = new Population<T>(individual_size, population_size);
    fitness = new Fitness<T>(population_size);
}

template<typename T> GA<T>::~GA(){
    delete population;
    delete fitness;
}

template<typename T> void GA<T>::upload(T *hdata){
    population->Set(hdata);
}
template<typename T> void GA<T>::download(T *hdata){
    population->Get(hdata);
}

template<typename T> void GA<T>::uploadFitnessData(T *hdata, int size){
    fitness->uploadFitnessData(hdata, size);
}

template<typename T> void GA<T>::start(){
    fitness->evaluate(population->data);
    population->sort(fitness->data);
}

template<typename T> void GA<T>::get_fitnesses(T *hfitnesses){
    fitness->evaluate(population->data, hfitnesses);
}

#endif // GACUDA_H