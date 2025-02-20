#include <iostream>
using namespace std;

int main() {
    string name = "Shuvo";
    int age = 21;

    {{ Hello, ${ name }. You are ${ age } years old. }};  
    return 0;
}
