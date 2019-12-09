#pragma once

#define uint  unsigned int

int mprintf(char* format, ...);
uint stlen(char* str);
int itos(int val,char* buffer, int base);
char* reverse(char* str, uint  len);