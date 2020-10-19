#include "types.h"
#include "stat.h"
#include "user.h"


int main()
{
  int is_child = 0;
  
  for(int i = 0; i < 10; i++) {
    int pid = fork();
  
    if(pid == 0) {
      is_child = 1;
      break;
    }
    else if (pid > 0) {
      change_process_level(pid, 0);
    }
    else {
      printf(1, "error forking\n");
    }
  }
  
  int c = 2;
  for(int i = 0; i < 1000000000; i++)
    c *= 2;
  
  if (is_child == 0) {
    for(int i = 0; i < 10; i++) {
      wait();
    }

    int pid = getpid();
    change_process_level(pid, 0);
  }

  printf(1, "%d", c);
  
  exit();
}

