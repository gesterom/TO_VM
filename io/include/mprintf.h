#pragma once

#define uint  unsigned int
#define ulong unsigned long

int mprintf(char* format, ...);
uint stlen(char* str);
int itos(int val,char* buffer, int base);
char* reverse(char* str, uint  len);