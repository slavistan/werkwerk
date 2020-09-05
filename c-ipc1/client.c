#include <sys/types.h>
#include <sys/shm.h>

int main(int argc, char** argv) {

  int authorized = 0;
  char sys_pass[16] = "secret!";
  char usr_pass[16] = " preset";

  printf("enter password: \n");
  // enter enough characters to overwrite sys_pass and usr_pass like so:
  // strcpy(usr_pass, "1234567890abcdef" "1234567890abcdef" "1234567890abc" );
  scanf("%s", usr_pass);

  printf("usr_pass: %s\n", usr_pass);
  printf("sys_pass: %s\n", sys_pass);
  printf("authorized: %d\n", authorized);
  printf("usr_pass   @ %p\n", (void*)usr_pass);
  printf("sys_pass   @ %p\n", (void*)sys_pass);
  printf("authorized @ %p\n", (void*)&authorized);

  if (strcmp(sys_pass, usr_pass) == 0) {
    authorized = 1;
  }

  if (authorized) {
    printf("Authorized! Access granted.\n");
  } else {
    printf("Access denied.\n");
  }

  return 0;
}
