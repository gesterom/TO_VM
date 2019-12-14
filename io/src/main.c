#include <mprintf.h>
#include <stdio.h>
#include <unistd.h>

int main(){

    char* s = "Hello world\0";
    mprintf("%s %x %x\n",s,0x4a4a4a4a,'a');
    char buffer[80];
    printf("%s\n",buffer);
    
    return 0;
}