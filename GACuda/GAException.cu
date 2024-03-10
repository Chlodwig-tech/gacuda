#ifndef GAEXCEPTION_CU
#define GAEXCEPTION_CU

#include <iostream>

/*-----------------------------GAException-----------------------------*/

class GAException : public std::exception{
    std::string errorMessage;
public:
    GAException(const char *message) : errorMessage(message) {}

    const char * what() const noexcept override{
        return errorMessage.c_str();
    }
};

#endif // GAEXCEPTION_CU