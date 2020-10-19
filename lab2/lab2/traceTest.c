#include "types.h"
#include "stat.h"

#include "fcntl.h"
#include "user.h"

int main(int argc, char *argv[]) 
{
    printf(1, "What system call do you like to test ? \n");
    printf(1, "0.log_syscalls\n");

    char buf[1024];
    read(1, buf, 1024);

    if(atoi(buf) == 0)
    {
        log_syscalls();
    }
    exit();
}