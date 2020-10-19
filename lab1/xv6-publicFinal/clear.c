#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"

#define CTRLC 0x23

int main(int argc, char *argv[])
{
    static char buf[100];
    int err;
        if((err=open("console", O_RDWR)) < 0)
        {
            printf(1,"touch: error where creating");
        }
        fflush(err);
        close(err);
    
    exit();
        
}