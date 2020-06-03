#include <stdio.h>
#include <string.h>

int main(int argc, char** argv) {

  char buffer_a[16];
  char buffer_b[16];

  strcpy(buffer_a, "123456789ABCDEF");

  printf("buffer_a @ 0x%p: '%s'\n", (void*)buffer_a, buffer_a);
  printf("buffer_b @ 0x%p: '%s'\n", (void*)buffer_b, buffer_b);

  return 0;
}
