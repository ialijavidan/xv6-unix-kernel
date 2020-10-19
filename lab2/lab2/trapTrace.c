#include "param.h"
#include "types.h"
#include "defs.h"
#include "memlayout.h"
#include "traps.h"
#include "mmu.h"
#include "x86.h"
#include "syscall.h"

struct sysCallTraces traces[MAX_PID_NUMS];

void addNewTrace(int pid, int syscallNumber, char* args)
{
    int i = 0 ;
    while (traces[pid].exists[i] != 0)
        i++;  
    traces[pid].exists[i] = 1;
    traces[pid].syscallNumber[i] = syscallNumber;
    strncpy(traces[pid].syscallArgs[i],args, strlen(args));
    cmostime( &traces[pid].times[i] );

}

int timeToNumber(struct rtcdate date)
{
    int minute = ((date.minute % 10) * 100) + (((date.minute / 10) % 10) * 1000);
    int hour = ((date.hour % 10) * 10000) + (((date.hour / 10) % 10) * 100000);
    int day = ((date.day % 1000000) * 100) + (((date.day / 10) % 10) * 10000000);
    int month = ((date.month % 100000000) * 100) + (((date.month / 10) % 10) * 1000000000);
    return date.second + minute + hour + day + month;
}

char* syscallName(int syscallNum)
{
    switch(syscallNum)
    {
        case ( 1 ) : return "fork";
        case ( 2 ) : return "exit";
        case ( 3 ) : return "wait";
        case ( 4 ) : return "pipe";
        case ( 5 ) : return "read";
        case ( 6 ) : return "kill";
        case ( 7 ) : return "exec";
        case ( 8 ) : return "fstat";
        case ( 9 ) : return "chdir";
        case ( 10 ) : return "dup";
        case ( 11 ) : return "getpid";
        case ( 12 ) : return "sbrk";
        case ( 13 ) : return "sleep";
        case ( 14 ) : return "uptime";
        case ( 15 ) : return "open";
        case ( 16 ) : return "write";
        case ( 17 ) : return "mknod";
        case ( 18 ) : return "unlink";
        case ( 19 ) : return "link";
        case ( 20 ) : return "mkdir";
        case ( 21 ) : return "close";
        case ( 22 ) : return "inc_num";
        case ( 23 ) : return "invoked_syscalls";
        case ( 24 ) : return "get_count";
        case ( 25 ) : return "sort_syscalls";
        case ( 26 ) : return "log_syscalls";
        case ( 27 ) : return "releasesleep_syscalls";
        case ( 28 ) : return "acquiresleep_syscalls";
        case ( 29 ) : return "ticketlockinit";
        case ( 30 ) : return "ticketlocktest";
        case ( 31 ) : return "rwinit";
        case ( 32 ) : return "rwtest";
        case ( 33 ) : return "wrinit";
        case ( 34 ) : return "wrtest";
    }
    return "";
}

void showLogOfProcesses()
{
    int numberOfTraps = 0;
    struct syscallLog logTrace[MAX_PID_NUMS * MAX_SYS_CALLS];
    int i=0, j=0;
    for(i=0; i<MAX_PID_NUMS; i++) {
        for(j=0; j<MAX_SYS_CALLS; j++) {
            if(!traces[i].exists[j] || !traces[i].isAlive )
                break;
            logTrace[numberOfTraps].date = traces[i].times[j];            
            logTrace[numberOfTraps].dateTime = timeToNumber(traces[i].times[j]);
            logTrace[numberOfTraps].pid = i;
            logTrace[numberOfTraps].syscallNumber = traces[i].syscallNumber[j];
            numberOfTraps++;
        }
    }

    for (i = 0; i < numberOfTraps; i++)
    {
        for (j = 0; j < numberOfTraps; j++)
        {
            if (logTrace[j].dateTime > logTrace[i].dateTime)             
            {
                int tmp = logTrace[i].syscallNumber;
                logTrace[i].syscallNumber = logTrace[j].syscallNumber;
                logTrace[j].syscallNumber = tmp;

                tmp = logTrace[i].dateTime;
                logTrace[i].dateTime = logTrace[j].dateTime;
                logTrace[j].dateTime = tmp;
                            
                tmp = logTrace[i].pid;
                logTrace[i].pid = logTrace[j].pid;
                logTrace[j].pid = tmp;
                            
                struct rtcdate temp;
                temp = logTrace[i].date;
                logTrace[i].date = logTrace[j].date;
                logTrace[j].date = temp;
            }  
        }
    }
    
    for(i = 0; i < numberOfTraps; i++)
    {
        cprintf("~ SystemCall %s called by process %d at %d/%d/%d  %d:%d:%d\n",
                    syscallName(logTrace[i].syscallNumber),
                    logTrace[i].pid,
                    logTrace[i].date.year,
                    logTrace[i].date.month,
                    logTrace[i].date.day,
                    logTrace[i].date.hour,
                    logTrace[i].date.minute,
                    logTrace[i].date.second);
    }
}