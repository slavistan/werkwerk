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

/*
 * Free shared memory, delete keyfile.
 */
void
cleanup(int exitafter) {
  if (shmid >= 0)
    shmctl(shmid, IPC_RMID, NULL);
  if (access(keyfile, F_OK) != -1)
    remove(keyfile);
  if (exitafter)
    exit(0);
}

int main(int argc, char** argv) {
  char *shm;
  key_t key;
  FILE *file;

  // guarantee proper cleanup
  signal(SIGQUIT, cleanup);
  signal(SIGTERM, cleanup);
  signal(SIGINT, cleanup);
  signal(SIGHUP, cleanup);

  // create a unique key
  if (snprintf(keyfile, sizeof(keyfile), "/tmp/shmem-ipc-%d", getuid()) >= sizeof(keyfile))
    die("keyfile output truncated");
  if (!(file = fopen(keyfile, "w+")))
    die("Cannot open keyfile 'pid-file.");
  fclose(file);
  if ((key = ftok(keyfile, 1)) < 0) {
    die("ftok() failed:");
  }

  // allocate shared memory segment and return its identifier
  if ((shmid = shmget(key, shmsz, IPC_CREAT | IPC_EXCL | 0600)) < 0)
    die("shmget() failed:");

  // attach shared memory segment to this processes' address space
  if ((shm = (char*)shmat(shmid, NULL, 0)) == -1)
    die("shmat() failed:");

  // repeatedly override shmem segment
  while (1) {
    printf("shm current value = '%s'. Override with: ", shm);
    if (shm != fgets(shm, shmsz, stdin))
      die("fgets() failed");
    if (shm[strlen(shm)-1] == '\n')
      shm[strlen(shm)-1] = '\0';
    printf("\n");
  }

  // detach shared memory from process
  shmdt(shm);

  // mark shmem segment to be destroyed.
  cleanup(0);

  return 0;
}
