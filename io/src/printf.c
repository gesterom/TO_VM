#include <printf.h>
#include <unistd.h>
#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>

int mprintf(char* format, ...){
    char* sp = (char *) &format + sizeof format + 0x58;
                                                // ^
                                                // |
                                                // magic offset dont touch
                                                // Propably some memory dont we dont need
                                                // If you add some variables change this
                                                // using gdb x/40x $sp and info frame and subtract current frame vs where 
                                                // variables realy begin
    uint iter = 0;
    uint len;
    int error;
    uint i =0;
    char * substring; 
    while(format[iter] != '\0'){
        if(format[iter] == '%'){
            switch (format[iter + 1]){
                int val;
                char buffer[20];
                case 'd': 
                    val = *((int*)(sp));
                    sp += sizeof(long);
                    len = itos(val,buffer,10);
                    error = write(0,buffer,len);
                    break;
                case 'x':
                    val = *((int*)(sp));
                    sp += sizeof(long);
                    len = itos(val,buffer,16);
                    error = write(0,buffer,len);
                    break;
                case 'b':
                    val = *((int*)(sp));
                    sp += sizeof(long);
                    len = itos(val,buffer,2);
                    error = write(0,buffer,len);
                    break;
                case 's':
                    i =0;
                    substring = (char*)(*((long*)(sp)));
                    while( (buffer[0] = substring[i]) != '\0'){
                        error = write(0,buffer,1);
                        i++;
                    }
                    sp += sizeof(long);
                    break;
                case '%':
                    error = write(0,"%%",1);
                    break;
                default:
                    return -1;
            }
            iter +=2;
        }
        else{
            write(0,format + iter,1);   
            iter++;
        }
    }

}

uint stlen(char* str){
    uint size = 0;
    while(str[size] != '\0'){
        ++size;
    }
    return size;
}
//TODO fix hex and binary for negative numbers
int itos(int val,char* buffer, int base){
    bool negative = false;
    uint i = 0;
    uint rem;
    if(val == 0){
        buffer[i++] = '0';
        buffer[i] = '\0';
        return i;
    }
    if(val < 0){
        negative = true;
        val = -val;
    }
    while(val != 0){
        rem = val % base;
        buffer[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
        val  = val/base;
    }
    if(negative) buffer[i++] = '-';
    buffer[i] = '\0';
    buffer = reverse(buffer,i);
    return i;

}
char* reverse(char* str, uint len){
    uint beg = 0;
    uint end = len - 1;
    char tmp;
    while(beg < end){
        tmp = str[end];
        str[end--] = str[beg];
        str[beg++] = tmp;
    }
    return str;
}