// Sleeping locks

#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
  lk->head = 0; /* Initialize head of waiter queue. */
}

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  
  if (lk->locked || lk->head)
	{
	  /* If lock is acquired or waiting queue is not empty,
		 push current process to head of queue.
	   */	  
	  struct proc* head = lk->head;
	  myproc()->next = head;
	  lk->head = myproc();
	  /* Next, sleep the process. */
	  sleep(lk, &lk->lk);
	}
  // now, lock is acquired.
  lk->locked = 1;
  lk->pid = myproc()->pid;

  release(&lk->lk);
}

void
releasesleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
 
  struct proc* tail; // tail of waiter queue.
  struct proc* prev_tail; // process before the tail of waiter queue.
  
  tail = lk->head;
  prev_tail = 0;

  if (tail)
	{
	  /* Set tail to the end of the queue.*/
	  while (tail->next)
		{
		  prev_tail = tail;
		  tail = tail->next;
		}
	  /* Get rid of the tail from the queue, and wake up the process. */
	  if (prev_tail)
		prev_tail->next = 0;
	  else
		lk->head = 0;
	  lk->locked = 0;
	  lk->pid = 0;
	  /* wakeup tail */
	  wakeup_p(tail);
	}
  else
	{
	  /* when queue is empty */
	  lk->locked = 0;
	  lk->pid = 0;
	}
  release(&lk->lk);
}

int
holdingsleep(struct sleeplock *lk)
{
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
  release(&lk->lk);
  return r;
}



