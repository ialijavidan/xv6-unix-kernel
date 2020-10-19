#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "syscall.h"

int
sys_alarm(void)
{
  int ticks;
  void (*handler)();

  if(argint(0, &ticks) < 0)
    return -1;
  if(argptr(1, (char**)&handler, 1))
    return -1;

  myproc()->alarmticks = ticks;
  myproc()->alarmleft = ticks;
  myproc()->alarmhandler = handler;
  return 0;
}

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  
  return kill(pid);
}

int
sys_getpid(void)
{
  struct proc *curproc = myproc();
  curproc->count++;

  return curproc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;
  struct proc *curproc = myproc();
  curproc->count++;
  
  if(argint(0, &n) < 0)
    return -1;

  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  struct proc *curproc = myproc();
  curproc->count++;
 
  if(argint(0, &n) < 0)
    return -1;

  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

int
sys_uptime(void)
{
  uint xticks;
  struct proc *curproc = myproc();
  curproc->count++;
  addNewTrace(curproc -> pid, SYS_uptime, "");
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

void
sys_log_syscalls(void)
{
  struct proc *curproc = myproc();
  curproc->count++;
  addNewTrace(curproc -> pid, SYS_log_syscalls, "");
  showLogOfProcesses();
}