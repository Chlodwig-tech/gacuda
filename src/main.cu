#include <stdio.h>
#include "../GACuda/gacuda.h"

template<> __device__ int fitness(int *population, int index, int *fitnessData){
    int sum = 0;
    int n = 5;
    for(int i = 0; i < n - 1; i++){
        sum += fitnessData[population[index * n + i] * n + population[index * n + i + 1]];
    }
    sum += fitnessData[population[index * n + 4] * n + population[index * n]];
    return sum;
}

int main(){
    /*int number_of_epochs = 10;
    int max_fitness = 10;
    int best[5];*/
    int *fitnesses = new int[5];

    int tab[] = {
        0, 1, 2, 3, 4, // 17
        0, 2, 1, 3, 4, // 19
        0, 1, 3, 2, 4, // 15
        0, 4, 2, 3, 1, // 15
        0, 2, 3, 1, 4  // 20
    };
    int prices[] = {
        0, 2, 3, 4, 5,
        2, 0, 3, 4, 5,
        3, 3, 0, 3, 1,
        4, 4, 3, 0, 4,
        5, 5, 1, 4, 0
    };

    GA<int> ga(5, 5);
    ga.upload(tab);
    ga.uploadFitnessData(prices, 25);

    ga.start();

    ga.get_fitnesses(fitnesses);
    ga.download(tab);
    for(int i = 0; i < 5; i++){
        for(int j = 0; j < 5; j++){
            printf("%d ", tab[i * 5 + j]);
        }
        printf(" - fitness = %d\n", fitnesses[i]);
    }

    delete[] fitnesses;
}