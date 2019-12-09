#include <printf.h>
#include <stdio.h>

int main(){

    char* s = "Hello world\0";
    mprintf("%x %x %s %x\n",0x4a4a4a4a,0x4a4a4a,s,0x444);
    char buffer[20];
    itos(65,buffer,16);

    
    return 0;
}