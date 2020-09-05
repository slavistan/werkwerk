#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>

static const int shmsz = 64; /* size of shmem segment in bytes */

static int shmid = -1;
static char keyfile[128] = "\0";

/*
 * Print error and shut down.
 */
void
die(const char *fmt, ...) {
  va_list ap;
  va_start(ap, fmt);
  vfprintf(stderr, fmt, ap);
  va_end(ap);
  if (fmt[0] && fmt[strlen(fmt)-1] == ':') {
    fputc(' ', stderr);
    perror(NULL);
  } else {
    fputc('\n', stderr);
  }
  exit(1);
}

int
main(int argc, char** argv) {
  char *shm;
  key_t key;

  // retrieve unique key
  if (snprintf(keyfile, sizeof(keyfile), "/tmp/shmem-ipc-%d", getuid()) >= sizeof(keyfile))
    die("keyfile output truncated");
  if ((key = ftok(keyfile, 1)) < 0) {
    die("ftok() failed:");
  }

  // retrieve identifier of shmem segment created by server
  if ((shmid = shmget(key, shmsz, 0)) < 0)
    die("shmget() failed:");

  // attach shared memory segment to this processes' address space
  if ((shm = (char*)shmat(shmid, NULL, SHM_RDONLY)) == (char*)-1)
    die("shmat() failed:");

  // repeatedly print shmem segment
  while (1) {
    printf("shm = '%s'\n", shm);
    sleep(1);
  }

  // detach shared memory from process
  shmdt(shm);

  return 0;
}

// TODO: factor out common code shared by client and server
