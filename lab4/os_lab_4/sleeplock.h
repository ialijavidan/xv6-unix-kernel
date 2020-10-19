// Long-term locks for processes
struct sleeplock {
  uint locked;       // Is the lock held?
  struct spinlock lk; // spinlock protecting this sleep lock
  struct proc* head; // Project6. head of waiter queue
  
  // For debugging:
  char *name;        // Name of lock.
  int pid;           // Process holding lock
};

