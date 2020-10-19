#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"

int compare_strings(char a[], char b[])
{
   int c = 0;
 
   while (a[c] == b[c]) {
      if (a[c] == '\0' || b[c] == '\0')
         break;
      c++;
   }
   
   if (a[c] == '\0' && b[c] == '\0')
      return 0;
   else
      return -1;
}

int main(int argc, char *argv[])
{
    static char buf[100];
    if(argc == 3){
    	if(compare_strings(argv[1], "-w") != 0){
    		printf(1,"Error");
			exit();
    	}
    	int errFileOpen;
        if((errFileOpen=open(argv[2],O_CREATE|O_RDWR)) < 0)
        {
            printf(1,"Error");
        }
        int errConsoleOpen;
        if((errConsoleOpen=open("console", O_RDWR)) < 0)
        {
            printf(1,"Error");
        }
        int errConsoleRead;
        if((errConsoleRead=read(errConsoleOpen,buf,100)) < 0)
        {
            printf(1,"Error");
        }
		int errFileWrite;
		if((errFileWrite=write(errFileOpen, buf, 100)) < 0)
			printf(1,"Error");
        close(errFileOpen);
        close(errFileWrite);
        close(errConsoleRead);
        close(errConsoleOpen);
        exit();
    }    
    
    if(argc < 2)
    {
        printf(1,"Error");
		exit();
    }

	int err;
    if((err = open(argv[1], O_CREATE|O_RDWR)) < 0)
    {
        printf(1,"Error");
        exit();
    }
    close(err);
    exit();
}