// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"


#define TAB          0x9
#define MAX_HISTORY                 (16)      /*the max number of the comand histories*/
#define MAX_COMMAND_LENGTH          (128)     /*the max length of the comand*/

char commandHistory[MAX_HISTORY][MAX_COMMAND_LENGTH];
int commandHistoryCounter = 0;
int currentCommandId = 0;

static void consputc(int);

static int panicked = 0;

static struct {
  struct spinlock lock;
  int locking;
} cons;

int 
sys_history(void){
  char * buffer;
  int historyId;
  int ret = 0;

  //get parameters
  if(argstr(0, &buffer) < 0)
    return -1;
  if(argint(1, &historyId) < 0)
    return -1;

  if(historyId >= commandHistoryCounter){
    return ret = -1;
  }else if(historyId < 0 || historyId >= MAX_HISTORY){
    return ret = -2;
  }else{
    memmove(buffer, commandHistory[historyId], MAX_COMMAND_LENGTH * sizeof(char));
  }

  return ret;
}

/*
add a command to the history array
*/
void addHistory(char *command){
  if((command[0]!='\0'))
  {
    int length = strlen(command) <= MAX_COMMAND_LENGTH ? strlen(command) : MAX_COMMAND_LENGTH-1;
    int i;

    if(commandHistoryCounter < MAX_HISTORY){
      commandHistoryCounter++;
    }else{
    // move back
      for(i = 0; i < MAX_HISTORY - 1; i++){
        memmove(commandHistory[i], commandHistory[i+1], sizeof(char)* MAX_COMMAND_LENGTH);
      }   
    }
  //store
    memmove(commandHistory[commandHistoryCounter-1], command, sizeof(char)* length);
    commandHistory[commandHistoryCounter-1][length] = '\0';

    currentCommandId = commandHistoryCounter - 1;
  }
}

static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i]);
}
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

//PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
  if(panicked){
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}

#define INPUT_BUF 128
struct {
  char buf[INPUT_BUF];
  uint r;  // Read index
  uint w;  // Write index
  uint e;  // Edit index
} input;


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

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  char buffer[MAX_COMMAND_LENGTH];
  int x;
  int pos;
  int i;
  char a[18]="\033[2J\033[1;1H";//On printing this it resets ubuntu terminal's cursor position to top-left
  char d;
  int c, doprocdump = 0;
  int ifFound = 0;
  int index = -1; 
  char consoleReadBuf[128];
  char temp[128];
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){

    case TAB:

      for(int i = input.w, j = 0; i < input.e;i++, j++)
        consoleReadBuf[j] = input.buf[i];

      for(i = 0; i < strlen(*commandHistory) && !ifFound; i++){
        for(int j = 0; j < strlen(consoleReadBuf); j++)
          temp[j] = commandHistory[i][j]; 

        if(compare_strings(temp, consoleReadBuf) == 0){
          ifFound = 1;
          index = i;
        }
      }

      if(index != -1){
        //show last command
        for(int i = strlen(consoleReadBuf); i < strlen(commandHistory[index]); i++){
          x = commandHistory[index][i];
          consputc(x);
          input.buf[input.e++] = x;
        }
      }
      break;

    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
  
    //clear
    case C('R'):
   
      //c('L') header in kbd.h
      i=0;
      //clearing ubuntu terminal
      //resets the cursor of ubuntu terminal to top-left
      while(i<14)
      {
      d=a[i];
      uartputc(d);  //writing to ubuntu terminal  
        i++;    
      }
      //clearing qemu
      //screen resolution of terminal is 24*80.Print 24 newlines    
      i=0;    
      while(i<=24)
      {
        cgaputc('\n');//writing to qemu 
        i=i+1;
      } 
      //shifting cursor position back(Qemu)
      //outb header in x86.h  
      pos=0;
      outb(CRTPORT, 14);
      outb(CRTPORT+1, pos>>8);
      outb(CRTPORT, 15);
      outb(CRTPORT+1, pos);
    
      cgaputc('$');
      cgaputc(' ');
      uartputc('$');
      uartputc(' ');  

      break;  

    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){ 
          //copy the command
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
            buffer[k] = input.buf[i % INPUT_BUF];
          }
          buffer[(input.e-1-input.w) % INPUT_BUF] = '\0';

          //add histories
          addHistory(buffer);
          
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}
