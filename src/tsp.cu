#include <stdio.h>
#include "../GACuda/gacuda.h"

/*template<> __device__ int fitness(int x)
{
    return x + 3;
}*/

/*template<> __device__ int fitness(int *population, int index, int *addata){
    int sum = 0;
    for(int i = 0; i < 5; i++){
        sum += i * population[index * 5 + i];
    }
    return sum;
}*/

template<> __device__ int fitness(int *population, int index, int *addata){
    int sum = 0;
    for(int i = 0; i < 5 - 1; i++){
        sum += addata[population[index * 5 + i] * 5 + population[index * 5 + i + 1]];
    }
    sum += addata[population[index * 5 + 4] * 5 + population[index * 5]];
    return sum;
}

int main(){

    int n = 5;
    int *fitnesses = new int[n];
    int tab[] = {
        0, 1, 2, 3, 4,
        0, 2, 1, 3, 4,
        0, 1, 3, 2, 4,
        0, 4, 2, 3, 1,
        0, 2, 3, 1, 4
    };
    int prices[] = {
        0, 2, 3, 4, 5,
        2, 0, 3, 4, 5,
        3, 3, 0, 3, 1,
        4, 4, 3, 0, 4,
        5, 5, 1, 4, 0
    };

    GA<int> ga(5, n);
    ga.upload(tab); // generate or upload population
    ga.uploadA(prices, n * n);

    int number_of_epochs = 10;
    for(int i = 0; i < number_of_epochs; i++){
        printf("Epoch %d\n", i + 1);
    }
    
    ga.get_fitnesses(fitnesses);

    //ga.runf(23);
    ga.download(tab);

    for(int i = 0; i < n; i++){
        for(int j = 0; j < 5; j++){
            printf("%d ", tab[i * 5 + j]);
        }
        printf(" - fitness = %d\n", fitnesses[i]);
    }

    delete[] fitnesses;
}