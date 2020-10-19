#include "types.h"
#include "user.h"
#include "fcntl.h"

#define PROCNUM 10
#define SLEEPTOTAL 10

int
main()
{
  int i, pid;

  prioritylocktest();

  for (i=0; i< PROCNUM; i++)
	{
	  pid = fork();
	  if (pid)
		{
		  printf(1, "Process %d created.\n", i);
		  sleep(SLEEPTOTAL/PROCNUM);
		}
	  else
		break;
	}

  if (pid)
	{
	  sleep(SLEEPTOTAL);
	  prioritylocktest();
	  for (i=0; i<PROCNUM; i++)
		wait();
	}
  else
	{
	  prioritylocktest();
	  printf(1, "Lock has been acquired by process %d.\n", i);
	  prioritylocktest();
	}

  exit();
}
