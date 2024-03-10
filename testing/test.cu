#include <iostream>
#include <string.h>

#include "../GACuda/gacuda.h"

int passed = 0;
int tests  = 0;
void Test(bool (*func)()){
    tests++;
    bool result;
    try
    {
        result = func();
    }
    catch(const std::exception& e)
    {
        std::cerr << e.what() << '\n';
        result = false;
    }
        
    if(result){
        passed++;
        printf("\033[32;1m✅ Test %d passed\033[0m\n", tests);
    }else{
        printf("\033[31;1m❌ Test %d failed\033[0m\n", tests);
    }
}   

bool test(){
    return true;
}

int main(){
    Test(&test);

    printf("----------------------------\n");
    printf("\033[32;1m✅ Tests passed - %d/%d(%d%)\033[0m\n", passed, tests, 100*passed/tests);
    printf("\033[31;1m❌ Tests failed - %d/%d(%d%)\033[0m\n", tests - passed, tests, 100*(tests - passed)/tests);
}