#include <mprintf.h>
#include <unistd.h>
#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#define SIZE 67//
int mprintf(char* format, ...){
    char buffer[SIZE];
    int error;
    char* sp = (char *)( &format) + sizeof format + (SIZE/sizeof(long) + 1)*sizeof(long) + 8*sizeof(long);
                                                //      ^                                    ^
                                                //      |                                    |
                                                // size of buffer                    accounts for local variables
                                                //  padded to cpu bit count          8 propably comes from padding  
                                                // 
                                                // I know it's weird but I guess this is proper behaviour 
                                                // So i guess memory is 1st argument then loval variables and then rest of variables
    for(uint iter=0;format[iter] != '\0';){
        if(format[iter] == '%'){
            char * substring; //switch case weirdness
            uint len;
            switch (format[iter + 1]){
                long val;
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
                    substring = (char*)(*((ulong*)(sp)));
                    len = stlen(substring);
                    error = write(0,substring,len);
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
    return error;
}

uint stlen(char* str){
    uint size = 0;
    while(str[size] != '\0'){
        ++size;
    }
    return size;
}
int itos(int val,char* buffer, int base){
    uint i = 0;
    uint rem;
    if(val == 0){
        buffer[i++] = '0';
        buffer[i] = '\0';
        return i;
    }
    if(base == 10){
        bool negative = false;
    
        if(val < 0){
            negative = true;
            val = -val;
        }

        while(val != 0){
            rem = val % base;
            buffer[i++] = rem + '0';
            val  = val/base;
        }
        if(negative) buffer[i++] = '-';
    }
    else{
        uint uval = (uint)val;
        while(uval != 0){
            rem = uval % base;
            buffer[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
            uval  = uval/base;
        }

        if(base == 16){
            buffer[i++] = 'x';
            buffer[i++] = '0';
        }

        if(base == 2){
            buffer[i++] = 'b';
            buffer[i++] = '0';
        }
    }
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