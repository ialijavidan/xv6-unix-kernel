
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc e0 b5 10 80       	mov    $0x8010b5e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 33 10 80       	mov    $0x801033f0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 74 10 80       	push   $0x80107400
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 f5 46 00 00       	call   80104750 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 74 10 80       	push   $0x80107407
80100097:	50                   	push   %eax
80100098:	e8 83 45 00 00       	call   80104620 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 a7 47 00 00       	call   80104890 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 e9 47 00 00       	call   80104950 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 44 00 00       	call   80104660 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 ed 24 00 00       	call   80102670 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 0e 74 10 80       	push   $0x8010740e
80100198:	e8 63 03 00 00       	call   80100500 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 4d 45 00 00       	call   80104700 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 a7 24 00 00       	jmp    80102670 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 74 10 80       	push   $0x8010741f
801001d1:	e8 2a 03 00 00       	call   80100500 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 0c 45 00 00       	call   80104700 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 44 00 00       	call   801046c0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 80 46 00 00       	call   80104890 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 ef 46 00 00       	jmp    80104950 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 74 10 80       	push   $0x80107426
80100269:	e8 92 02 00 00       	call   80100500 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 2b 1a 00 00       	call   80101cb0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
8010028c:	e8 ff 45 00 00       	call   80104890 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 07 11 80    	mov    0x801107c0,%edx
801002a7:	39 15 c4 07 11 80    	cmp    %edx,0x801107c4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 40 a5 10 80       	push   $0x8010a540
801002c0:	68 c0 07 11 80       	push   $0x801107c0
801002c5:	e8 06 40 00 00       	call   801042d0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 07 11 80    	mov    0x801107c0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 07 11 80    	cmp    0x801107c4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 50 3a 00 00       	call   80103d30 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 40 a5 10 80       	push   $0x8010a540
801002ef:	e8 5c 46 00 00       	call   80104950 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 d4 18 00 00       	call   80101bd0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 07 11 80       	mov    %eax,0x801107c0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 07 11 80 	movsbl -0x7feef8c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 40 a5 10 80       	push   $0x8010a540
8010034d:	e8 fe 45 00 00       	call   80104950 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 76 18 00 00       	call   80101bd0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 c0 07 11 80    	mov    %edx,0x801107c0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <addHistory.part.0>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <addHistory.part.0>:
void addHistory(char *command){
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	57                   	push   %edi
80100394:	56                   	push   %esi
80100395:	53                   	push   %ebx
80100396:	89 c6                	mov    %eax,%esi
80100398:	83 ec 28             	sub    $0x28,%esp
    int length = strlen(command) <= MAX_COMMAND_LENGTH ? strlen(command) : MAX_COMMAND_LENGTH-1;
8010039b:	50                   	push   %eax
8010039c:	e8 1f 48 00 00       	call   80104bc0 <strlen>
801003a1:	83 c4 10             	add    $0x10,%esp
801003a4:	83 c0 80             	add    $0xffffff80,%eax
801003a7:	c7 45 e0 7f 00 00 00 	movl   $0x7f,-0x20(%ebp)
801003ae:	c7 45 e4 7f 00 00 00 	movl   $0x7f,-0x1c(%ebp)
801003b5:	0f 8e 8d 00 00 00    	jle    80100448 <addHistory.part.0+0xb8>
    if(commandHistoryCounter < MAX_HISTORY){
801003bb:	a1 24 a5 10 80       	mov    0x8010a524,%eax
801003c0:	83 f8 0f             	cmp    $0xf,%eax
801003c3:	7f 4b                	jg     80100410 <addHistory.part.0+0x80>
      commandHistoryCounter++;
801003c5:	83 c0 01             	add    $0x1,%eax
801003c8:	a3 24 a5 10 80       	mov    %eax,0x8010a524
    memmove(commandHistory[commandHistoryCounter-1], command, sizeof(char)* length);
801003cd:	c1 e0 07             	shl    $0x7,%eax
801003d0:	83 ec 04             	sub    $0x4,%esp
801003d3:	ff 75 e0             	pushl  -0x20(%ebp)
801003d6:	05 c0 fe 10 80       	add    $0x8010fec0,%eax
801003db:	56                   	push   %esi
801003dc:	50                   	push   %eax
801003dd:	e8 6e 46 00 00       	call   80104a50 <memmove>
    commandHistory[commandHistoryCounter-1][length] = '\0';
801003e2:	a1 24 a5 10 80       	mov    0x8010a524,%eax
801003e7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    currentCommandId = commandHistoryCounter - 1;
801003ea:	83 c4 10             	add    $0x10,%esp
    commandHistory[commandHistoryCounter-1][length] = '\0';
801003ed:	83 e8 01             	sub    $0x1,%eax
801003f0:	89 c2                	mov    %eax,%edx
    currentCommandId = commandHistoryCounter - 1;
801003f2:	a3 20 a5 10 80       	mov    %eax,0x8010a520
    commandHistory[commandHistoryCounter-1][length] = '\0';
801003f7:	c1 e2 07             	shl    $0x7,%edx
801003fa:	c6 84 11 40 ff 10 80 	movb   $0x0,-0x7fef00c0(%ecx,%edx,1)
80100401:	00 
}
80100402:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100405:	5b                   	pop    %ebx
80100406:	5e                   	pop    %esi
80100407:	5f                   	pop    %edi
80100408:	5d                   	pop    %ebp
80100409:	c3                   	ret    
8010040a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100410:	b8 40 ff 10 80       	mov    $0x8010ff40,%eax
80100415:	bb c0 06 11 80       	mov    $0x801106c0,%ebx
8010041a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100420:	8d b8 80 00 00 00    	lea    0x80(%eax),%edi
        memmove(commandHistory[i], commandHistory[i+1], sizeof(char)* MAX_COMMAND_LENGTH);
80100426:	83 ec 04             	sub    $0x4,%esp
80100429:	68 80 00 00 00       	push   $0x80
8010042e:	57                   	push   %edi
8010042f:	50                   	push   %eax
80100430:	e8 1b 46 00 00       	call   80104a50 <memmove>
      for(i = 0; i < MAX_HISTORY - 1; i++){
80100435:	83 c4 10             	add    $0x10,%esp
80100438:	39 fb                	cmp    %edi,%ebx
8010043a:	89 f8                	mov    %edi,%eax
8010043c:	75 e2                	jne    80100420 <addHistory.part.0+0x90>
8010043e:	a1 24 a5 10 80       	mov    0x8010a524,%eax
80100443:	eb 88                	jmp    801003cd <addHistory.part.0+0x3d>
80100445:	8d 76 00             	lea    0x0(%esi),%esi
    int length = strlen(command) <= MAX_COMMAND_LENGTH ? strlen(command) : MAX_COMMAND_LENGTH-1;
80100448:	83 ec 0c             	sub    $0xc,%esp
8010044b:	56                   	push   %esi
8010044c:	e8 6f 47 00 00       	call   80104bc0 <strlen>
80100451:	83 c4 10             	add    $0x10,%esp
80100454:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100457:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010045a:	e9 5c ff ff ff       	jmp    801003bb <addHistory.part.0+0x2b>
8010045f:	90                   	nop

80100460 <sys_history>:
sys_history(void){
80100460:	55                   	push   %ebp
80100461:	89 e5                	mov    %esp,%ebp
80100463:	83 ec 20             	sub    $0x20,%esp
  if(argstr(0, &buffer) < 0)
80100466:	8d 45 f0             	lea    -0x10(%ebp),%eax
80100469:	50                   	push   %eax
8010046a:	6a 00                	push   $0x0
8010046c:	e8 df 48 00 00       	call   80104d50 <argstr>
80100471:	83 c4 10             	add    $0x10,%esp
80100474:	85 c0                	test   %eax,%eax
80100476:	78 48                	js     801004c0 <sys_history+0x60>
  if(argint(1, &historyId) < 0)
80100478:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010047b:	83 ec 08             	sub    $0x8,%esp
8010047e:	50                   	push   %eax
8010047f:	6a 01                	push   $0x1
80100481:	e8 1a 48 00 00       	call   80104ca0 <argint>
80100486:	83 c4 10             	add    $0x10,%esp
80100489:	85 c0                	test   %eax,%eax
8010048b:	78 33                	js     801004c0 <sys_history+0x60>
  if(historyId >= commandHistoryCounter){
8010048d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100490:	3b 05 24 a5 10 80    	cmp    0x8010a524,%eax
80100496:	7d 28                	jge    801004c0 <sys_history+0x60>
  }else if(historyId < 0 || historyId >= MAX_HISTORY){
80100498:	83 f8 0f             	cmp    $0xf,%eax
8010049b:	77 33                	ja     801004d0 <sys_history+0x70>
    memmove(buffer, commandHistory[historyId], MAX_COMMAND_LENGTH * sizeof(char));
8010049d:	c1 e0 07             	shl    $0x7,%eax
801004a0:	83 ec 04             	sub    $0x4,%esp
801004a3:	05 40 ff 10 80       	add    $0x8010ff40,%eax
801004a8:	68 80 00 00 00       	push   $0x80
801004ad:	50                   	push   %eax
801004ae:	ff 75 f0             	pushl  -0x10(%ebp)
801004b1:	e8 9a 45 00 00       	call   80104a50 <memmove>
  return ret;
801004b6:	83 c4 10             	add    $0x10,%esp
801004b9:	31 c0                	xor    %eax,%eax
}
801004bb:	c9                   	leave  
801004bc:	c3                   	ret    
801004bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801004c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801004c5:	c9                   	leave  
801004c6:	c3                   	ret    
801004c7:	89 f6                	mov    %esi,%esi
801004c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return ret = -2;
801004d0:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
801004d5:	c9                   	leave  
801004d6:	c3                   	ret    
801004d7:	89 f6                	mov    %esi,%esi
801004d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801004e0 <addHistory>:
void addHistory(char *command){
801004e0:	55                   	push   %ebp
801004e1:	89 e5                	mov    %esp,%ebp
801004e3:	8b 45 08             	mov    0x8(%ebp),%eax
  if((command[0]!='\0'))
801004e6:	80 38 00             	cmpb   $0x0,(%eax)
801004e9:	75 05                	jne    801004f0 <addHistory+0x10>
}
801004eb:	5d                   	pop    %ebp
801004ec:	c3                   	ret    
801004ed:	8d 76 00             	lea    0x0(%esi),%esi
801004f0:	5d                   	pop    %ebp
801004f1:	e9 9a fe ff ff       	jmp    80100390 <addHistory.part.0>
801004f6:	8d 76 00             	lea    0x0(%esi),%esi
801004f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100500 <panic>:
{
80100500:	55                   	push   %ebp
80100501:	89 e5                	mov    %esp,%ebp
80100503:	56                   	push   %esi
80100504:	53                   	push   %ebx
80100505:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100508:	fa                   	cli    
  cons.locking = 0;
80100509:	c7 05 74 a5 10 80 00 	movl   $0x0,0x8010a574
80100510:	00 00 00 
  getcallerpcs(&s, pcs);
80100513:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100516:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100519:	e8 62 27 00 00       	call   80102c80 <lapicid>
8010051e:	83 ec 08             	sub    $0x8,%esp
80100521:	50                   	push   %eax
80100522:	68 2d 74 10 80       	push   $0x8010742d
80100527:	e8 e4 02 00 00       	call   80100810 <cprintf>
  cprintf(s);
8010052c:	58                   	pop    %eax
8010052d:	ff 75 08             	pushl  0x8(%ebp)
80100530:	e8 db 02 00 00       	call   80100810 <cprintf>
  cprintf("\n");
80100535:	c7 04 24 77 7d 10 80 	movl   $0x80107d77,(%esp)
8010053c:	e8 cf 02 00 00       	call   80100810 <cprintf>
  getcallerpcs(&s, pcs);
80100541:	5a                   	pop    %edx
80100542:	8d 45 08             	lea    0x8(%ebp),%eax
80100545:	59                   	pop    %ecx
80100546:	53                   	push   %ebx
80100547:	50                   	push   %eax
80100548:	e8 23 42 00 00       	call   80104770 <getcallerpcs>
8010054d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100550:	83 ec 08             	sub    $0x8,%esp
80100553:	ff 33                	pushl  (%ebx)
80100555:	83 c3 04             	add    $0x4,%ebx
80100558:	68 41 74 10 80       	push   $0x80107441
8010055d:	e8 ae 02 00 00       	call   80100810 <cprintf>
  for(i=0; i<10; i++)
80100562:	83 c4 10             	add    $0x10,%esp
80100565:	39 f3                	cmp    %esi,%ebx
80100567:	75 e7                	jne    80100550 <panic+0x50>
  panicked = 1; // freeze other CPU
80100569:	c7 05 78 a5 10 80 01 	movl   $0x1,0x8010a578
80100570:	00 00 00 
80100573:	eb fe                	jmp    80100573 <panic+0x73>
80100575:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100580 <cgaputc>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100586:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010058b:	89 c3                	mov    %eax,%ebx
8010058d:	89 fa                	mov    %edi,%edx
8010058f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100594:	83 ec 1c             	sub    $0x1c,%esp
80100597:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100598:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010059d:	89 ca                	mov    %ecx,%edx
8010059f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801005a0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801005a3:	89 fa                	mov    %edi,%edx
801005a5:	c1 e0 08             	shl    $0x8,%eax
801005a8:	89 c6                	mov    %eax,%esi
801005aa:	b8 0f 00 00 00       	mov    $0xf,%eax
801005af:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801005b0:	89 ca                	mov    %ecx,%edx
801005b2:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801005b3:	0f b6 c0             	movzbl %al,%eax
801005b6:	09 f0                	or     %esi,%eax
  if(c == '\n')
801005b8:	83 fb 0a             	cmp    $0xa,%ebx
801005bb:	0f 84 df 00 00 00    	je     801006a0 <cgaputc+0x120>
  else if(c == BACKSPACE){
801005c1:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
801005c7:	74 6f                	je     80100638 <cgaputc+0xb8>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801005c9:	0f b6 db             	movzbl %bl,%ebx
801005cc:	8d 70 01             	lea    0x1(%eax),%esi
801005cf:	80 cf 07             	or     $0x7,%bh
801005d2:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801005d9:	80 
  if(pos < 0 || pos > 25*80)
801005da:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
801005e0:	0f 8f d2 00 00 00    	jg     801006b8 <cgaputc+0x138>
  if((pos/80) >= 24){  // Scroll up.
801005e6:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
801005ec:	7f 62                	jg     80100650 <cgaputc+0xd0>
801005ee:	89 f0                	mov    %esi,%eax
801005f0:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801005f7:	0f b6 fc             	movzbl %ah,%edi
801005fa:	88 45 e7             	mov    %al,-0x19(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801005fd:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100602:	b8 0e 00 00 00       	mov    $0xe,%eax
80100607:	89 da                	mov    %ebx,%edx
80100609:	ee                   	out    %al,(%dx)
8010060a:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010060f:	89 f8                	mov    %edi,%eax
80100611:	89 ca                	mov    %ecx,%edx
80100613:	ee                   	out    %al,(%dx)
80100614:	b8 0f 00 00 00       	mov    $0xf,%eax
80100619:	89 da                	mov    %ebx,%edx
8010061b:	ee                   	out    %al,(%dx)
8010061c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80100620:	89 ca                	mov    %ecx,%edx
80100622:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100623:	b8 20 07 00 00       	mov    $0x720,%eax
80100628:	66 89 06             	mov    %ax,(%esi)
}
8010062b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010062e:	5b                   	pop    %ebx
8010062f:	5e                   	pop    %esi
80100630:	5f                   	pop    %edi
80100631:	5d                   	pop    %ebp
80100632:	c3                   	ret    
80100633:	90                   	nop
80100634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
80100638:	85 c0                	test   %eax,%eax
8010063a:	8d 70 ff             	lea    -0x1(%eax),%esi
8010063d:	75 9b                	jne    801005da <cgaputc+0x5a>
8010063f:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100644:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100648:	31 ff                	xor    %edi,%edi
8010064a:	eb b1                	jmp    801005fd <cgaputc+0x7d>
8010064c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100650:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100653:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100656:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010065b:	68 60 0e 00 00       	push   $0xe60
80100660:	68 a0 80 0b 80       	push   $0x800b80a0
80100665:	68 00 80 0b 80       	push   $0x800b8000
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010066a:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100671:	e8 da 43 00 00       	call   80104a50 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100676:	b8 80 07 00 00       	mov    $0x780,%eax
8010067b:	83 c4 0c             	add    $0xc,%esp
8010067e:	29 d8                	sub    %ebx,%eax
80100680:	01 c0                	add    %eax,%eax
80100682:	50                   	push   %eax
80100683:	6a 00                	push   $0x0
80100685:	56                   	push   %esi
80100686:	e8 15 43 00 00       	call   801049a0 <memset>
8010068b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010068e:	83 c4 10             	add    $0x10,%esp
80100691:	e9 67 ff ff ff       	jmp    801005fd <cgaputc+0x7d>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pos += 80 - pos%80;
801006a0:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801006a5:	f7 e2                	mul    %edx
801006a7:	c1 ea 06             	shr    $0x6,%edx
801006aa:	8d 04 92             	lea    (%edx,%edx,4),%eax
801006ad:	c1 e0 04             	shl    $0x4,%eax
801006b0:	8d 70 50             	lea    0x50(%eax),%esi
801006b3:	e9 22 ff ff ff       	jmp    801005da <cgaputc+0x5a>
    panic("pos under/overflow");
801006b8:	83 ec 0c             	sub    $0xc,%esp
801006bb:	68 45 74 10 80       	push   $0x80107445
801006c0:	e8 3b fe ff ff       	call   80100500 <panic>
801006c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801006c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801006d0 <consputc>:
  if(panicked){
801006d0:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
801006d6:	85 d2                	test   %edx,%edx
801006d8:	74 06                	je     801006e0 <consputc+0x10>
  asm volatile("cli");
801006da:	fa                   	cli    
801006db:	eb fe                	jmp    801006db <consputc+0xb>
801006dd:	8d 76 00             	lea    0x0(%esi),%esi
{
801006e0:	55                   	push   %ebp
801006e1:	89 e5                	mov    %esp,%ebp
801006e3:	53                   	push   %ebx
801006e4:	89 c3                	mov    %eax,%ebx
801006e6:	83 ec 04             	sub    $0x4,%esp
  if(c == BACKSPACE){
801006e9:	3d 00 01 00 00       	cmp    $0x100,%eax
801006ee:	74 17                	je     80100707 <consputc+0x37>
    uartputc(c);
801006f0:	83 ec 0c             	sub    $0xc,%esp
801006f3:	50                   	push   %eax
801006f4:	e8 17 59 00 00       	call   80106010 <uartputc>
801006f9:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801006fc:	89 d8                	mov    %ebx,%eax
}
801006fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100701:	c9                   	leave  
  cgaputc(c);
80100702:	e9 79 fe ff ff       	jmp    80100580 <cgaputc>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100707:	83 ec 0c             	sub    $0xc,%esp
8010070a:	6a 08                	push   $0x8
8010070c:	e8 ff 58 00 00       	call   80106010 <uartputc>
80100711:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100718:	e8 f3 58 00 00       	call   80106010 <uartputc>
8010071d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100724:	e8 e7 58 00 00       	call   80106010 <uartputc>
80100729:	83 c4 10             	add    $0x10,%esp
8010072c:	eb ce                	jmp    801006fc <consputc+0x2c>
8010072e:	66 90                	xchg   %ax,%ax

80100730 <printint>:
{
80100730:	55                   	push   %ebp
80100731:	89 e5                	mov    %esp,%ebp
80100733:	57                   	push   %edi
80100734:	56                   	push   %esi
80100735:	53                   	push   %ebx
80100736:	89 d3                	mov    %edx,%ebx
80100738:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010073b:	85 c9                	test   %ecx,%ecx
{
8010073d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100740:	74 04                	je     80100746 <printint+0x16>
80100742:	85 c0                	test   %eax,%eax
80100744:	78 5a                	js     801007a0 <printint+0x70>
    x = xx;
80100746:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010074d:	31 c9                	xor    %ecx,%ecx
8010074f:	8d 75 d7             	lea    -0x29(%ebp),%esi
80100752:	eb 06                	jmp    8010075a <printint+0x2a>
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
80100758:	89 f9                	mov    %edi,%ecx
8010075a:	31 d2                	xor    %edx,%edx
8010075c:	8d 79 01             	lea    0x1(%ecx),%edi
8010075f:	f7 f3                	div    %ebx
80100761:	0f b6 92 70 74 10 80 	movzbl -0x7fef8b90(%edx),%edx
  }while((x /= base) != 0);
80100768:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
8010076a:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
8010076d:	75 e9                	jne    80100758 <printint+0x28>
  if(sign)
8010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100772:	85 c0                	test   %eax,%eax
80100774:	74 08                	je     8010077e <printint+0x4e>
    buf[i++] = '-';
80100776:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
8010077b:	8d 79 02             	lea    0x2(%ecx),%edi
8010077e:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
80100782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
80100788:	0f be 03             	movsbl (%ebx),%eax
8010078b:	83 eb 01             	sub    $0x1,%ebx
8010078e:	e8 3d ff ff ff       	call   801006d0 <consputc>
  while(--i >= 0)
80100793:	39 f3                	cmp    %esi,%ebx
80100795:	75 f1                	jne    80100788 <printint+0x58>
}
80100797:	83 c4 2c             	add    $0x2c,%esp
8010079a:	5b                   	pop    %ebx
8010079b:	5e                   	pop    %esi
8010079c:	5f                   	pop    %edi
8010079d:	5d                   	pop    %ebp
8010079e:	c3                   	ret    
8010079f:	90                   	nop
    x = -xx;
801007a0:	f7 d8                	neg    %eax
801007a2:	eb a9                	jmp    8010074d <printint+0x1d>
801007a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801007b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
801007b5:	53                   	push   %ebx
801007b6:	83 ec 18             	sub    $0x18,%esp
801007b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801007bc:	ff 75 08             	pushl  0x8(%ebp)
801007bf:	e8 ec 14 00 00       	call   80101cb0 <iunlock>
  acquire(&cons.lock);
801007c4:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801007cb:	e8 c0 40 00 00       	call   80104890 <acquire>
  for(i = 0; i < n; i++)
801007d0:	83 c4 10             	add    $0x10,%esp
801007d3:	85 f6                	test   %esi,%esi
801007d5:	7e 18                	jle    801007ef <consolewrite+0x3f>
801007d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
801007da:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
801007dd:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
801007e0:	0f b6 07             	movzbl (%edi),%eax
801007e3:	83 c7 01             	add    $0x1,%edi
801007e6:	e8 e5 fe ff ff       	call   801006d0 <consputc>
  for(i = 0; i < n; i++)
801007eb:	39 fb                	cmp    %edi,%ebx
801007ed:	75 f1                	jne    801007e0 <consolewrite+0x30>
  release(&cons.lock);
801007ef:	83 ec 0c             	sub    $0xc,%esp
801007f2:	68 40 a5 10 80       	push   $0x8010a540
801007f7:	e8 54 41 00 00       	call   80104950 <release>
  ilock(ip);
801007fc:	58                   	pop    %eax
801007fd:	ff 75 08             	pushl  0x8(%ebp)
80100800:	e8 cb 13 00 00       	call   80101bd0 <ilock>

  return n;
}
80100805:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100808:	89 f0                	mov    %esi,%eax
8010080a:	5b                   	pop    %ebx
8010080b:	5e                   	pop    %esi
8010080c:	5f                   	pop    %edi
8010080d:	5d                   	pop    %ebp
8010080e:	c3                   	ret    
8010080f:	90                   	nop

80100810 <cprintf>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
80100816:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100819:	a1 74 a5 10 80       	mov    0x8010a574,%eax
  if(locking)
8010081e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100820:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100823:	0f 85 6f 01 00 00    	jne    80100998 <cprintf+0x188>
  if (fmt == 0)
80100829:	8b 45 08             	mov    0x8(%ebp),%eax
8010082c:	85 c0                	test   %eax,%eax
8010082e:	89 c7                	mov    %eax,%edi
80100830:	0f 84 77 01 00 00    	je     801009ad <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100836:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100839:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010083c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010083e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100841:	85 c0                	test   %eax,%eax
80100843:	75 56                	jne    8010089b <cprintf+0x8b>
80100845:	eb 79                	jmp    801008c0 <cprintf+0xb0>
80100847:	89 f6                	mov    %esi,%esi
80100849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
80100850:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
80100853:	85 d2                	test   %edx,%edx
80100855:	74 69                	je     801008c0 <cprintf+0xb0>
80100857:	83 c3 02             	add    $0x2,%ebx
    switch(c){
8010085a:	83 fa 70             	cmp    $0x70,%edx
8010085d:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
80100860:	0f 84 84 00 00 00    	je     801008ea <cprintf+0xda>
80100866:	7f 78                	jg     801008e0 <cprintf+0xd0>
80100868:	83 fa 25             	cmp    $0x25,%edx
8010086b:	0f 84 ff 00 00 00    	je     80100970 <cprintf+0x160>
80100871:	83 fa 64             	cmp    $0x64,%edx
80100874:	0f 85 8e 00 00 00    	jne    80100908 <cprintf+0xf8>
      printint(*argp++, 10, 1);
8010087a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010087d:	ba 0a 00 00 00       	mov    $0xa,%edx
80100882:	8d 48 04             	lea    0x4(%eax),%ecx
80100885:	8b 00                	mov    (%eax),%eax
80100887:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010088a:	b9 01 00 00 00       	mov    $0x1,%ecx
8010088f:	e8 9c fe ff ff       	call   80100730 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100894:	0f b6 06             	movzbl (%esi),%eax
80100897:	85 c0                	test   %eax,%eax
80100899:	74 25                	je     801008c0 <cprintf+0xb0>
8010089b:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
8010089e:	83 f8 25             	cmp    $0x25,%eax
801008a1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801008a4:	74 aa                	je     80100850 <cprintf+0x40>
801008a6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801008a9:	e8 22 fe ff ff       	call   801006d0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008ae:	0f b6 06             	movzbl (%esi),%eax
      continue;
801008b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801008b4:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008b6:	85 c0                	test   %eax,%eax
801008b8:	75 e1                	jne    8010089b <cprintf+0x8b>
801008ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
801008c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801008c3:	85 c0                	test   %eax,%eax
801008c5:	74 10                	je     801008d7 <cprintf+0xc7>
    release(&cons.lock);
801008c7:	83 ec 0c             	sub    $0xc,%esp
801008ca:	68 40 a5 10 80       	push   $0x8010a540
801008cf:	e8 7c 40 00 00       	call   80104950 <release>
801008d4:	83 c4 10             	add    $0x10,%esp
}
801008d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008da:	5b                   	pop    %ebx
801008db:	5e                   	pop    %esi
801008dc:	5f                   	pop    %edi
801008dd:	5d                   	pop    %ebp
801008de:	c3                   	ret    
801008df:	90                   	nop
    switch(c){
801008e0:	83 fa 73             	cmp    $0x73,%edx
801008e3:	74 43                	je     80100928 <cprintf+0x118>
801008e5:	83 fa 78             	cmp    $0x78,%edx
801008e8:	75 1e                	jne    80100908 <cprintf+0xf8>
      printint(*argp++, 16, 0);
801008ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801008ed:	ba 10 00 00 00       	mov    $0x10,%edx
801008f2:	8d 48 04             	lea    0x4(%eax),%ecx
801008f5:	8b 00                	mov    (%eax),%eax
801008f7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801008fa:	31 c9                	xor    %ecx,%ecx
801008fc:	e8 2f fe ff ff       	call   80100730 <printint>
      break;
80100901:	eb 91                	jmp    80100894 <cprintf+0x84>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100908:	b8 25 00 00 00       	mov    $0x25,%eax
8010090d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100910:	e8 bb fd ff ff       	call   801006d0 <consputc>
      consputc(c);
80100915:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100918:	89 d0                	mov    %edx,%eax
8010091a:	e8 b1 fd ff ff       	call   801006d0 <consputc>
      break;
8010091f:	e9 70 ff ff ff       	jmp    80100894 <cprintf+0x84>
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100928:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010092b:	8b 10                	mov    (%eax),%edx
8010092d:	8d 48 04             	lea    0x4(%eax),%ecx
80100930:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100933:	85 d2                	test   %edx,%edx
80100935:	74 49                	je     80100980 <cprintf+0x170>
      for(; *s; s++)
80100937:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010093a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010093d:	84 c0                	test   %al,%al
8010093f:	0f 84 4f ff ff ff    	je     80100894 <cprintf+0x84>
80100945:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100948:	89 d3                	mov    %edx,%ebx
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100950:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
80100953:	e8 78 fd ff ff       	call   801006d0 <consputc>
      for(; *s; s++)
80100958:	0f be 03             	movsbl (%ebx),%eax
8010095b:	84 c0                	test   %al,%al
8010095d:	75 f1                	jne    80100950 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
8010095f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100962:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100965:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100968:	e9 27 ff ff ff       	jmp    80100894 <cprintf+0x84>
8010096d:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
80100970:	b8 25 00 00 00       	mov    $0x25,%eax
80100975:	e8 56 fd ff ff       	call   801006d0 <consputc>
      break;
8010097a:	e9 15 ff ff ff       	jmp    80100894 <cprintf+0x84>
8010097f:	90                   	nop
        s = "(null)";
80100980:	ba 58 74 10 80       	mov    $0x80107458,%edx
      for(; *s; s++)
80100985:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100988:	b8 28 00 00 00       	mov    $0x28,%eax
8010098d:	89 d3                	mov    %edx,%ebx
8010098f:	eb bf                	jmp    80100950 <cprintf+0x140>
80100991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
80100998:	83 ec 0c             	sub    $0xc,%esp
8010099b:	68 40 a5 10 80       	push   $0x8010a540
801009a0:	e8 eb 3e 00 00       	call   80104890 <acquire>
801009a5:	83 c4 10             	add    $0x10,%esp
801009a8:	e9 7c fe ff ff       	jmp    80100829 <cprintf+0x19>
    panic("null fmt");
801009ad:	83 ec 0c             	sub    $0xc,%esp
801009b0:	68 5f 74 10 80       	push   $0x8010745f
801009b5:	e8 46 fb ff ff       	call   80100500 <panic>
801009ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801009c0 <compare_strings>:
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	56                   	push   %esi
801009c4:	53                   	push   %ebx
801009c5:	8b 75 0c             	mov    0xc(%ebp),%esi
801009c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
   while (a[c] == b[c]) {
801009cb:	0f b6 0e             	movzbl (%esi),%ecx
801009ce:	0f b6 13             	movzbl (%ebx),%edx
801009d1:	38 d1                	cmp    %dl,%cl
801009d3:	75 1e                	jne    801009f3 <compare_strings+0x33>
      return 0;
801009d5:	31 c0                	xor    %eax,%eax
      if (a[c] == '\0' || b[c] == '\0')
801009d7:	84 c9                	test   %cl,%cl
801009d9:	75 09                	jne    801009e4 <compare_strings+0x24>
801009db:	eb 23                	jmp    80100a00 <compare_strings+0x40>
801009dd:	8d 76 00             	lea    0x0(%esi),%esi
801009e0:	84 d2                	test   %dl,%dl
801009e2:	74 24                	je     80100a08 <compare_strings+0x48>
      c++;
801009e4:	83 c0 01             	add    $0x1,%eax
   while (a[c] == b[c]) {
801009e7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
801009eb:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801009ef:	38 ca                	cmp    %cl,%dl
801009f1:	74 ed                	je     801009e0 <compare_strings+0x20>
   if (a[c] == '\0' && b[c] == '\0')
801009f3:	84 d2                	test   %dl,%dl
801009f5:	75 17                	jne    80100a0e <compare_strings+0x4e>
801009f7:	31 c0                	xor    %eax,%eax
801009f9:	84 c9                	test   %cl,%cl
801009fb:	0f 95 c0             	setne  %al
801009fe:	f7 d8                	neg    %eax
}
80100a00:	5b                   	pop    %ebx
80100a01:	5e                   	pop    %esi
80100a02:	5d                   	pop    %ebp
80100a03:	c3                   	ret    
80100a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a08:	5b                   	pop    %ebx
      return 0;
80100a09:	31 c0                	xor    %eax,%eax
}
80100a0b:	5e                   	pop    %esi
80100a0c:	5d                   	pop    %ebp
80100a0d:	c3                   	ret    
      return -1;
80100a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a13:	eb eb                	jmp    80100a00 <compare_strings+0x40>
80100a15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100a20 <consoleintr>:
{
80100a20:	55                   	push   %ebp
  char a[18]="\033[2J\033[1;1H";//On printing this it resets ubuntu terminal's cursor position to top-left
80100a21:	31 d2                	xor    %edx,%edx
{
80100a23:	89 e5                	mov    %esp,%ebp
80100a25:	57                   	push   %edi
80100a26:	56                   	push   %esi
80100a27:	53                   	push   %ebx
  int ifFound = 0;
80100a28:	31 ff                	xor    %edi,%edi
80100a2a:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
{
80100a30:	81 ec d8 01 00 00    	sub    $0x1d8,%esp
  char a[18]="\033[2J\033[1;1H";//On printing this it resets ubuntu terminal's cursor position to top-left
80100a36:	c7 85 56 fe ff ff 1b 	movl   $0x4a325b1b,-0x1aa(%ebp)
80100a3d:	5b 32 4a 
80100a40:	c7 85 5a fe ff ff 1b 	movl   $0x3b315b1b,-0x1a6(%ebp)
80100a47:	5b 31 3b 
  acquire(&cons.lock);
80100a4a:	68 40 a5 10 80       	push   $0x8010a540
  char a[18]="\033[2J\033[1;1H";//On printing this it resets ubuntu terminal's cursor position to top-left
80100a4f:	c7 85 5e fe ff ff 31 	movl   $0x4831,-0x1a2(%ebp)
80100a56:	48 00 00 
80100a59:	c7 85 62 fe ff ff 00 	movl   $0x0,-0x19e(%ebp)
80100a60:	00 00 00 
80100a63:	66 89 95 66 fe ff ff 	mov    %dx,-0x19a(%ebp)
  acquire(&cons.lock);
80100a6a:	e8 21 3e 00 00       	call   80104890 <acquire>
  while((c = getc()) >= 0){
80100a6f:	83 c4 10             	add    $0x10,%esp
  int index = -1; 
80100a72:	c7 85 40 fe ff ff ff 	movl   $0xffffffff,-0x1c0(%ebp)
80100a79:	ff ff ff 
  int c, doprocdump = 0;
80100a7c:	c7 85 3c fe ff ff 00 	movl   $0x0,-0x1c4(%ebp)
80100a83:	00 00 00 
80100a86:	89 bd 38 fe ff ff    	mov    %edi,-0x1c8(%ebp)
80100a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((c = getc()) >= 0){
80100a90:	ff 55 08             	call   *0x8(%ebp)
80100a93:	85 c0                	test   %eax,%eax
80100a95:	89 c3                	mov    %eax,%ebx
80100a97:	0f 88 d3 00 00 00    	js     80100b70 <consoleintr+0x150>
    switch(c){
80100a9d:	83 fb 10             	cmp    $0x10,%ebx
80100aa0:	0f 84 5a 02 00 00    	je     80100d00 <consoleintr+0x2e0>
80100aa6:	0f 8e f4 00 00 00    	jle    80100ba0 <consoleintr+0x180>
80100aac:	83 fb 15             	cmp    $0x15,%ebx
80100aaf:	0f 84 f3 01 00 00    	je     80100ca8 <consoleintr+0x288>
80100ab5:	83 fb 7f             	cmp    $0x7f,%ebx
80100ab8:	0f 84 4a 03 00 00    	je     80100e08 <consoleintr+0x3e8>
80100abe:	83 fb 12             	cmp    $0x12,%ebx
80100ac1:	0f 85 d9 02 00 00    	jne    80100da0 <consoleintr+0x380>
80100ac7:	8d bd 56 fe ff ff    	lea    -0x1aa(%ebp),%edi
80100acd:	8d 9d 64 fe ff ff    	lea    -0x19c(%ebp),%ebx
80100ad3:	90                   	nop
80100ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      uartputc(d);  //writing to ubuntu terminal  
80100ad8:	0f be 07             	movsbl (%edi),%eax
80100adb:	83 ec 0c             	sub    $0xc,%esp
80100ade:	83 c7 01             	add    $0x1,%edi
80100ae1:	50                   	push   %eax
80100ae2:	e8 29 55 00 00       	call   80106010 <uartputc>
      while(i<14)
80100ae7:	83 c4 10             	add    $0x10,%esp
80100aea:	39 fb                	cmp    %edi,%ebx
80100aec:	75 ea                	jne    80100ad8 <consoleintr+0xb8>
80100aee:	bb 19 00 00 00       	mov    $0x19,%ebx
80100af3:	90                   	nop
80100af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cgaputc('\n');//writing to qemu 
80100af8:	b8 0a 00 00 00       	mov    $0xa,%eax
80100afd:	e8 7e fa ff ff       	call   80100580 <cgaputc>
      while(i<=24)
80100b02:	83 eb 01             	sub    $0x1,%ebx
80100b05:	75 f1                	jne    80100af8 <consoleintr+0xd8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b07:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100b0c:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b11:	89 fa                	mov    %edi,%edx
80100b13:	ee                   	out    %al,(%dx)
80100b14:	31 c9                	xor    %ecx,%ecx
80100b16:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100b1b:	89 c8                	mov    %ecx,%eax
80100b1d:	89 da                	mov    %ebx,%edx
80100b1f:	ee                   	out    %al,(%dx)
80100b20:	b8 0f 00 00 00       	mov    $0xf,%eax
80100b25:	89 fa                	mov    %edi,%edx
80100b27:	ee                   	out    %al,(%dx)
80100b28:	89 c8                	mov    %ecx,%eax
80100b2a:	89 da                	mov    %ebx,%edx
80100b2c:	ee                   	out    %al,(%dx)
      cgaputc('$');
80100b2d:	b8 24 00 00 00       	mov    $0x24,%eax
80100b32:	e8 49 fa ff ff       	call   80100580 <cgaputc>
      cgaputc(' ');
80100b37:	b8 20 00 00 00       	mov    $0x20,%eax
80100b3c:	e8 3f fa ff ff       	call   80100580 <cgaputc>
      uartputc('$');
80100b41:	83 ec 0c             	sub    $0xc,%esp
80100b44:	6a 24                	push   $0x24
80100b46:	e8 c5 54 00 00       	call   80106010 <uartputc>
      uartputc(' ');  
80100b4b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100b52:	e8 b9 54 00 00       	call   80106010 <uartputc>
      break;  
80100b57:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100b5a:	ff 55 08             	call   *0x8(%ebp)
80100b5d:	85 c0                	test   %eax,%eax
80100b5f:	89 c3                	mov    %eax,%ebx
80100b61:	0f 89 36 ff ff ff    	jns    80100a9d <consoleintr+0x7d>
80100b67:	89 f6                	mov    %esi,%esi
80100b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&cons.lock);
80100b70:	83 ec 0c             	sub    $0xc,%esp
80100b73:	68 40 a5 10 80       	push   $0x8010a540
80100b78:	e8 d3 3d 00 00       	call   80104950 <release>
  if(doprocdump) {
80100b7d:	8b 85 3c fe ff ff    	mov    -0x1c4(%ebp),%eax
80100b83:	83 c4 10             	add    $0x10,%esp
80100b86:	85 c0                	test   %eax,%eax
80100b88:	74 05                	je     80100b8f <consoleintr+0x16f>
    procdump();  // now call procdump() wo. cons.lock held
80100b8a:	e8 d1 39 00 00       	call   80104560 <procdump>
}
80100b8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b92:	5b                   	pop    %ebx
80100b93:	5e                   	pop    %esi
80100b94:	5f                   	pop    %edi
80100b95:	5d                   	pop    %ebp
80100b96:	c3                   	ret    
80100b97:	89 f6                	mov    %esi,%esi
80100b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    switch(c){
80100ba0:	83 fb 08             	cmp    $0x8,%ebx
80100ba3:	0f 84 5f 02 00 00    	je     80100e08 <consoleintr+0x3e8>
80100ba9:	83 fb 09             	cmp    $0x9,%ebx
80100bac:	0f 85 ee 01 00 00    	jne    80100da0 <consoleintr+0x380>
      for(int i = input.w, j = 0; i < input.e;i++, j++)
80100bb2:	8b 1d c4 07 11 80    	mov    0x801107c4,%ebx
80100bb8:	8b 0d c8 07 11 80    	mov    0x801107c8,%ecx
80100bbe:	39 cb                	cmp    %ecx,%ebx
80100bc0:	73 20                	jae    80100be2 <consoleintr+0x1c2>
80100bc2:	29 d9                	sub    %ebx,%ecx
80100bc4:	31 c0                	xor    %eax,%eax
80100bc6:	8d 76 00             	lea    0x0(%esi),%esi
80100bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        consoleReadBuf[j] = input.buf[i];
80100bd0:	0f b6 94 03 40 07 11 	movzbl -0x7feef8c0(%ebx,%eax,1),%edx
80100bd7:	80 
80100bd8:	88 14 06             	mov    %dl,(%esi,%eax,1)
      for(int i = input.w, j = 0; i < input.e;i++, j++)
80100bdb:	83 c0 01             	add    $0x1,%eax
80100bde:	39 c8                	cmp    %ecx,%eax
80100be0:	75 ee                	jne    80100bd0 <consoleintr+0x1b0>
80100be2:	8b bd 38 fe ff ff    	mov    -0x1c8(%ebp),%edi
   if (a[c] == '\0' && b[c] == '\0')
80100be8:	31 db                	xor    %ebx,%ebx
      for(i = 0; i < strlen(*commandHistory) && !ifFound; i++){
80100bea:	c7 85 44 fe ff ff 00 	movl   $0x0,-0x1bc(%ebp)
80100bf1:	00 00 00 
80100bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100bf8:	83 ec 0c             	sub    $0xc,%esp
80100bfb:	68 40 ff 10 80       	push   $0x8010ff40
80100c00:	e8 bb 3f 00 00       	call   80104bc0 <strlen>
80100c05:	83 c4 10             	add    $0x10,%esp
80100c08:	85 ff                	test   %edi,%edi
80100c0a:	0f 85 00 01 00 00    	jne    80100d10 <consoleintr+0x2f0>
80100c10:	3b 85 44 fe ff ff    	cmp    -0x1bc(%ebp),%eax
80100c16:	0f 8e f4 00 00 00    	jle    80100d10 <consoleintr+0x2f0>
        for(int j = 0; j < strlen(consoleReadBuf); j++)
80100c1c:	31 ff                	xor    %edi,%edi
80100c1e:	eb 12                	jmp    80100c32 <consoleintr+0x212>
          temp[j] = commandHistory[i][j]; 
80100c20:	0f b6 84 3b 40 ff 10 	movzbl -0x7fef00c0(%ebx,%edi,1),%eax
80100c27:	80 
80100c28:	88 84 3d 68 ff ff ff 	mov    %al,-0x98(%ebp,%edi,1)
        for(int j = 0; j < strlen(consoleReadBuf); j++)
80100c2f:	83 c7 01             	add    $0x1,%edi
80100c32:	83 ec 0c             	sub    $0xc,%esp
80100c35:	56                   	push   %esi
80100c36:	e8 85 3f 00 00       	call   80104bc0 <strlen>
80100c3b:	83 c4 10             	add    $0x10,%esp
80100c3e:	39 f8                	cmp    %edi,%eax
80100c40:	7f de                	jg     80100c20 <consoleintr+0x200>
   while (a[c] == b[c]) {
80100c42:	0f b6 95 68 ff ff ff 	movzbl -0x98(%ebp),%edx
80100c49:	0f b6 8d e8 fe ff ff 	movzbl -0x118(%ebp),%ecx
80100c50:	38 ca                	cmp    %cl,%dl
80100c52:	75 23                	jne    80100c77 <consoleintr+0x257>
      if (a[c] == '\0' || b[c] == '\0')
80100c54:	84 d2                	test   %dl,%dl
80100c56:	74 38                	je     80100c90 <consoleintr+0x270>
   int c = 0;
80100c58:	31 c0                	xor    %eax,%eax
80100c5a:	eb 08                	jmp    80100c64 <consoleintr+0x244>
80100c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (a[c] == '\0' || b[c] == '\0')
80100c60:	84 d2                	test   %dl,%dl
80100c62:	74 2c                	je     80100c90 <consoleintr+0x270>
      c++;
80100c64:	83 c0 01             	add    $0x1,%eax
   while (a[c] == b[c]) {
80100c67:	0f b6 94 05 68 ff ff 	movzbl -0x98(%ebp,%eax,1),%edx
80100c6e:	ff 
80100c6f:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80100c73:	38 ca                	cmp    %cl,%dl
80100c75:	74 e9                	je     80100c60 <consoleintr+0x240>
   if (a[c] == '\0' && b[c] == '\0')
80100c77:	31 ff                	xor    %edi,%edi
80100c79:	84 d2                	test   %dl,%dl
80100c7b:	0f 84 62 02 00 00    	je     80100ee3 <consoleintr+0x4c3>
      for(i = 0; i < strlen(*commandHistory) && !ifFound; i++){
80100c81:	83 85 44 fe ff ff 01 	addl   $0x1,-0x1bc(%ebp)
80100c88:	83 eb 80             	sub    $0xffffff80,%ebx
80100c8b:	e9 68 ff ff ff       	jmp    80100bf8 <consoleintr+0x1d8>
      if (a[c] == '\0' || b[c] == '\0')
80100c90:	8b 85 44 fe ff ff    	mov    -0x1bc(%ebp),%eax
          ifFound = 1;
80100c96:	bf 01 00 00 00       	mov    $0x1,%edi
      if (a[c] == '\0' || b[c] == '\0')
80100c9b:	89 85 40 fe ff ff    	mov    %eax,-0x1c0(%ebp)
80100ca1:	eb de                	jmp    80100c81 <consoleintr+0x261>
80100ca3:	90                   	nop
80100ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100ca8:	a1 c8 07 11 80       	mov    0x801107c8,%eax
80100cad:	39 05 c4 07 11 80    	cmp    %eax,0x801107c4
80100cb3:	75 2b                	jne    80100ce0 <consoleintr+0x2c0>
80100cb5:	e9 d6 fd ff ff       	jmp    80100a90 <consoleintr+0x70>
80100cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100cc0:	a3 c8 07 11 80       	mov    %eax,0x801107c8
        consputc(BACKSPACE);
80100cc5:	b8 00 01 00 00       	mov    $0x100,%eax
80100cca:	e8 01 fa ff ff       	call   801006d0 <consputc>
      while(input.e != input.w &&
80100ccf:	a1 c8 07 11 80       	mov    0x801107c8,%eax
80100cd4:	3b 05 c4 07 11 80    	cmp    0x801107c4,%eax
80100cda:	0f 84 b0 fd ff ff    	je     80100a90 <consoleintr+0x70>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100ce0:	83 e8 01             	sub    $0x1,%eax
80100ce3:	89 c2                	mov    %eax,%edx
80100ce5:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100ce8:	80 ba 40 07 11 80 0a 	cmpb   $0xa,-0x7feef8c0(%edx)
80100cef:	75 cf                	jne    80100cc0 <consoleintr+0x2a0>
80100cf1:	e9 9a fd ff ff       	jmp    80100a90 <consoleintr+0x70>
80100cf6:	8d 76 00             	lea    0x0(%esi),%esi
80100cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      doprocdump = 1;
80100d00:	c7 85 3c fe ff ff 01 	movl   $0x1,-0x1c4(%ebp)
80100d07:	00 00 00 
80100d0a:	e9 81 fd ff ff       	jmp    80100a90 <consoleintr+0x70>
80100d0f:	90                   	nop
      if(index != -1){
80100d10:	83 bd 40 fe ff ff ff 	cmpl   $0xffffffff,-0x1c0(%ebp)
80100d17:	89 bd 38 fe ff ff    	mov    %edi,-0x1c8(%ebp)
80100d1d:	0f 84 6d fd ff ff    	je     80100a90 <consoleintr+0x70>
        for(int i = strlen(consoleReadBuf); i < strlen(commandHistory[index]); i++){
80100d23:	83 ec 0c             	sub    $0xc,%esp
80100d26:	56                   	push   %esi
80100d27:	e8 94 3e 00 00       	call   80104bc0 <strlen>
80100d2c:	89 c3                	mov    %eax,%ebx
80100d2e:	8b 85 40 fe ff ff    	mov    -0x1c0(%ebp),%eax
80100d34:	83 c4 10             	add    $0x10,%esp
80100d37:	c1 e0 07             	shl    $0x7,%eax
80100d3a:	89 85 34 fe ff ff    	mov    %eax,-0x1cc(%ebp)
80100d40:	8d b8 40 ff 10 80    	lea    -0x7fef00c0(%eax),%edi
80100d46:	eb 3f                	jmp    80100d87 <consoleintr+0x367>
80100d48:	90                   	nop
80100d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          x = commandHistory[index][i];
80100d50:	8b 85 34 fe ff ff    	mov    -0x1cc(%ebp),%eax
80100d56:	0f be 84 18 40 ff 10 	movsbl -0x7fef00c0(%eax,%ebx,1),%eax
80100d5d:	80 
        for(int i = strlen(consoleReadBuf); i < strlen(commandHistory[index]); i++){
80100d5e:	83 c3 01             	add    $0x1,%ebx
          x = commandHistory[index][i];
80100d61:	88 85 44 fe ff ff    	mov    %al,-0x1bc(%ebp)
          consputc(x);
80100d67:	e8 64 f9 ff ff       	call   801006d0 <consputc>
          input.buf[input.e++] = x;
80100d6c:	a1 c8 07 11 80       	mov    0x801107c8,%eax
80100d71:	0f b6 95 44 fe ff ff 	movzbl -0x1bc(%ebp),%edx
80100d78:	8d 48 01             	lea    0x1(%eax),%ecx
80100d7b:	88 90 40 07 11 80    	mov    %dl,-0x7feef8c0(%eax)
80100d81:	89 0d c8 07 11 80    	mov    %ecx,0x801107c8
        for(int i = strlen(consoleReadBuf); i < strlen(commandHistory[index]); i++){
80100d87:	83 ec 0c             	sub    $0xc,%esp
80100d8a:	57                   	push   %edi
80100d8b:	e8 30 3e 00 00       	call   80104bc0 <strlen>
80100d90:	83 c4 10             	add    $0x10,%esp
80100d93:	39 d8                	cmp    %ebx,%eax
80100d95:	7f b9                	jg     80100d50 <consoleintr+0x330>
80100d97:	e9 f4 fc ff ff       	jmp    80100a90 <consoleintr+0x70>
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100da0:	85 db                	test   %ebx,%ebx
80100da2:	0f 84 e8 fc ff ff    	je     80100a90 <consoleintr+0x70>
80100da8:	a1 c8 07 11 80       	mov    0x801107c8,%eax
80100dad:	89 c2                	mov    %eax,%edx
80100daf:	2b 15 c0 07 11 80    	sub    0x801107c0,%edx
80100db5:	83 fa 7f             	cmp    $0x7f,%edx
80100db8:	0f 87 d2 fc ff ff    	ja     80100a90 <consoleintr+0x70>
80100dbe:	8d 50 01             	lea    0x1(%eax),%edx
80100dc1:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100dc4:	83 fb 0d             	cmp    $0xd,%ebx
        input.buf[input.e++ % INPUT_BUF] = c;
80100dc7:	89 15 c8 07 11 80    	mov    %edx,0x801107c8
        c = (c == '\r') ? '\n' : c;
80100dcd:	74 61                	je     80100e30 <consoleintr+0x410>
        input.buf[input.e++ % INPUT_BUF] = c;
80100dcf:	88 98 40 07 11 80    	mov    %bl,-0x7feef8c0(%eax)
        consputc(c);
80100dd5:	89 d8                	mov    %ebx,%eax
80100dd7:	e8 f4 f8 ff ff       	call   801006d0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){ 
80100ddc:	83 fb 0a             	cmp    $0xa,%ebx
80100ddf:	74 60                	je     80100e41 <consoleintr+0x421>
80100de1:	83 fb 04             	cmp    $0x4,%ebx
80100de4:	74 5b                	je     80100e41 <consoleintr+0x421>
80100de6:	a1 c0 07 11 80       	mov    0x801107c0,%eax
80100deb:	83 e8 80             	sub    $0xffffff80,%eax
80100dee:	39 05 c8 07 11 80    	cmp    %eax,0x801107c8
80100df4:	89 85 44 fe ff ff    	mov    %eax,-0x1bc(%ebp)
80100dfa:	0f 85 90 fc ff ff    	jne    80100a90 <consoleintr+0x70>
80100e00:	eb 4a                	jmp    80100e4c <consoleintr+0x42c>
80100e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w){
80100e08:	a1 c8 07 11 80       	mov    0x801107c8,%eax
80100e0d:	3b 05 c4 07 11 80    	cmp    0x801107c4,%eax
80100e13:	0f 84 77 fc ff ff    	je     80100a90 <consoleintr+0x70>
        input.e--;
80100e19:	83 e8 01             	sub    $0x1,%eax
80100e1c:	a3 c8 07 11 80       	mov    %eax,0x801107c8
        consputc(BACKSPACE);
80100e21:	b8 00 01 00 00       	mov    $0x100,%eax
80100e26:	e8 a5 f8 ff ff       	call   801006d0 <consputc>
80100e2b:	e9 60 fc ff ff       	jmp    80100a90 <consoleintr+0x70>
        input.buf[input.e++ % INPUT_BUF] = c;
80100e30:	c6 80 40 07 11 80 0a 	movb   $0xa,-0x7feef8c0(%eax)
        consputc(c);
80100e37:	b8 0a 00 00 00       	mov    $0xa,%eax
80100e3c:	e8 8f f8 ff ff       	call   801006d0 <consputc>
80100e41:	a1 c8 07 11 80       	mov    0x801107c8,%eax
80100e46:	89 85 44 fe ff ff    	mov    %eax,-0x1bc(%ebp)
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
80100e4c:	8b 8d 44 fe ff ff    	mov    -0x1bc(%ebp),%ecx
80100e52:	a1 c4 07 11 80       	mov    0x801107c4,%eax
80100e57:	8d 79 ff             	lea    -0x1(%ecx),%edi
80100e5a:	89 85 34 fe ff ff    	mov    %eax,-0x1cc(%ebp)
80100e60:	89 c2                	mov    %eax,%edx
80100e62:	39 c7                	cmp    %eax,%edi
80100e64:	76 2b                	jbe    80100e91 <consoleintr+0x471>
80100e66:	8d 9d 68 fe ff ff    	lea    -0x198(%ebp),%ebx
            buffer[k] = input.buf[i % INPUT_BUF];
80100e6c:	29 c3                	sub    %eax,%ebx
80100e6e:	66 90                	xchg   %ax,%ax
80100e70:	89 d1                	mov    %edx,%ecx
80100e72:	c1 f9 1f             	sar    $0x1f,%ecx
80100e75:	c1 e9 19             	shr    $0x19,%ecx
80100e78:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
80100e7b:	83 e0 7f             	and    $0x7f,%eax
80100e7e:	29 c8                	sub    %ecx,%eax
80100e80:	0f b6 80 40 07 11 80 	movzbl -0x7feef8c0(%eax),%eax
80100e87:	88 04 13             	mov    %al,(%ebx,%edx,1)
          for(int i=input.w, k=0; i < input.e-1; i++, k++){
80100e8a:	83 c2 01             	add    $0x1,%edx
80100e8d:	39 d7                	cmp    %edx,%edi
80100e8f:	77 df                	ja     80100e70 <consoleintr+0x450>
          buffer[(input.e-1-input.w) % INPUT_BUF] = '\0';
80100e91:	2b bd 34 fe ff ff    	sub    -0x1cc(%ebp),%edi
80100e97:	83 e7 7f             	and    $0x7f,%edi
80100e9a:	c6 84 3d 68 fe ff ff 	movb   $0x0,-0x198(%ebp,%edi,1)
80100ea1:	00 
  if((command[0]!='\0'))
80100ea2:	80 bd 68 fe ff ff 00 	cmpb   $0x0,-0x198(%ebp)
80100ea9:	74 18                	je     80100ec3 <consoleintr+0x4a3>
80100eab:	8d 9d 68 fe ff ff    	lea    -0x198(%ebp),%ebx
80100eb1:	89 d8                	mov    %ebx,%eax
80100eb3:	e8 d8 f4 ff ff       	call   80100390 <addHistory.part.0>
80100eb8:	a1 c8 07 11 80       	mov    0x801107c8,%eax
80100ebd:	89 85 44 fe ff ff    	mov    %eax,-0x1bc(%ebp)
          wakeup(&input.r);
80100ec3:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100ec6:	8b 85 44 fe ff ff    	mov    -0x1bc(%ebp),%eax
          wakeup(&input.r);
80100ecc:	68 c0 07 11 80       	push   $0x801107c0
          input.w = input.e;
80100ed1:	a3 c4 07 11 80       	mov    %eax,0x801107c4
          wakeup(&input.r);
80100ed6:	e8 a5 35 00 00       	call   80104480 <wakeup>
80100edb:	83 c4 10             	add    $0x10,%esp
80100ede:	e9 ad fb ff ff       	jmp    80100a90 <consoleintr+0x70>
   if (a[c] == '\0' && b[c] == '\0')
80100ee3:	84 c9                	test   %cl,%cl
80100ee5:	8b 85 40 fe ff ff    	mov    -0x1c0(%ebp),%eax
80100eeb:	0f 44 85 44 fe ff ff 	cmove  -0x1bc(%ebp),%eax
80100ef2:	89 85 40 fe ff ff    	mov    %eax,-0x1c0(%ebp)
80100ef8:	31 c0                	xor    %eax,%eax
80100efa:	80 f9 01             	cmp    $0x1,%cl
80100efd:	0f 92 c0             	setb   %al
80100f00:	89 c7                	mov    %eax,%edi
80100f02:	e9 7a fd ff ff       	jmp    80100c81 <consoleintr+0x261>
80100f07:	89 f6                	mov    %esi,%esi
80100f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f10 <consoleinit>:

void
consoleinit(void)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100f16:	68 68 74 10 80       	push   $0x80107468
80100f1b:	68 40 a5 10 80       	push   $0x8010a540
80100f20:	e8 2b 38 00 00       	call   80104750 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100f25:	58                   	pop    %eax
80100f26:	5a                   	pop    %edx
80100f27:	6a 00                	push   $0x0
80100f29:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100f2b:	c7 05 8c 11 11 80 b0 	movl   $0x801007b0,0x8011118c
80100f32:	07 10 80 
  devsw[CONSOLE].read = consoleread;
80100f35:	c7 05 88 11 11 80 70 	movl   $0x80100270,0x80111188
80100f3c:	02 10 80 
  cons.locking = 1;
80100f3f:	c7 05 74 a5 10 80 01 	movl   $0x1,0x8010a574
80100f46:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100f49:	e8 d2 18 00 00       	call   80102820 <ioapicenable>
}
80100f4e:	83 c4 10             	add    $0x10,%esp
80100f51:	c9                   	leave  
80100f52:	c3                   	ret    
80100f53:	66 90                	xchg   %ax,%ax
80100f55:	66 90                	xchg   %ax,%ax
80100f57:	66 90                	xchg   %ax,%ax
80100f59:	66 90                	xchg   %ax,%ax
80100f5b:	66 90                	xchg   %ax,%ax
80100f5d:	66 90                	xchg   %ax,%ax
80100f5f:	90                   	nop

80100f60 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100f6c:	e8 bf 2d 00 00       	call   80103d30 <myproc>
80100f71:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100f77:	e8 74 21 00 00       	call   801030f0 <begin_op>

  if((ip = namei(path)) == 0){
80100f7c:	83 ec 0c             	sub    $0xc,%esp
80100f7f:	ff 75 08             	pushl  0x8(%ebp)
80100f82:	e8 a9 14 00 00       	call   80102430 <namei>
80100f87:	83 c4 10             	add    $0x10,%esp
80100f8a:	85 c0                	test   %eax,%eax
80100f8c:	0f 84 91 01 00 00    	je     80101123 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100f92:	83 ec 0c             	sub    $0xc,%esp
80100f95:	89 c3                	mov    %eax,%ebx
80100f97:	50                   	push   %eax
80100f98:	e8 33 0c 00 00       	call   80101bd0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100f9d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100fa3:	6a 34                	push   $0x34
80100fa5:	6a 00                	push   $0x0
80100fa7:	50                   	push   %eax
80100fa8:	53                   	push   %ebx
80100fa9:	e8 02 0f 00 00       	call   80101eb0 <readi>
80100fae:	83 c4 20             	add    $0x20,%esp
80100fb1:	83 f8 34             	cmp    $0x34,%eax
80100fb4:	74 22                	je     80100fd8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100fb6:	83 ec 0c             	sub    $0xc,%esp
80100fb9:	53                   	push   %ebx
80100fba:	e8 a1 0e 00 00       	call   80101e60 <iunlockput>
    end_op();
80100fbf:	e8 9c 21 00 00       	call   80103160 <end_op>
80100fc4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100fc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fcf:	5b                   	pop    %ebx
80100fd0:	5e                   	pop    %esi
80100fd1:	5f                   	pop    %edi
80100fd2:	5d                   	pop    %ebp
80100fd3:	c3                   	ret    
80100fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100fd8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100fdf:	45 4c 46 
80100fe2:	75 d2                	jne    80100fb6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100fe4:	e8 77 61 00 00       	call   80107160 <setupkvm>
80100fe9:	85 c0                	test   %eax,%eax
80100feb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ff1:	74 c3                	je     80100fb6 <exec+0x56>
  sz = 0;
80100ff3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ff5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100ffc:	00 
80100ffd:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80101003:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80101009:	0f 84 8c 02 00 00    	je     8010129b <exec+0x33b>
8010100f:	31 f6                	xor    %esi,%esi
80101011:	eb 7f                	jmp    80101092 <exec+0x132>
80101013:	90                   	nop
80101014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80101018:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
8010101f:	75 63                	jne    80101084 <exec+0x124>
    if(ph.memsz < ph.filesz)
80101021:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80101027:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
8010102d:	0f 82 86 00 00 00    	jb     801010b9 <exec+0x159>
80101033:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101039:	72 7e                	jb     801010b9 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
8010103b:	83 ec 04             	sub    $0x4,%esp
8010103e:	50                   	push   %eax
8010103f:	57                   	push   %edi
80101040:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80101046:	e8 35 5f 00 00       	call   80106f80 <allocuvm>
8010104b:	83 c4 10             	add    $0x10,%esp
8010104e:	85 c0                	test   %eax,%eax
80101050:	89 c7                	mov    %eax,%edi
80101052:	74 65                	je     801010b9 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80101054:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010105a:	a9 ff 0f 00 00       	test   $0xfff,%eax
8010105f:	75 58                	jne    801010b9 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101061:	83 ec 0c             	sub    $0xc,%esp
80101064:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
8010106a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101070:	53                   	push   %ebx
80101071:	50                   	push   %eax
80101072:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80101078:	e8 43 5e 00 00       	call   80106ec0 <loaduvm>
8010107d:	83 c4 20             	add    $0x20,%esp
80101080:	85 c0                	test   %eax,%eax
80101082:	78 35                	js     801010b9 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101084:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010108b:	83 c6 01             	add    $0x1,%esi
8010108e:	39 f0                	cmp    %esi,%eax
80101090:	7e 3d                	jle    801010cf <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101092:	89 f0                	mov    %esi,%eax
80101094:	6a 20                	push   $0x20
80101096:	c1 e0 05             	shl    $0x5,%eax
80101099:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
8010109f:	50                   	push   %eax
801010a0:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801010a6:	50                   	push   %eax
801010a7:	53                   	push   %ebx
801010a8:	e8 03 0e 00 00       	call   80101eb0 <readi>
801010ad:	83 c4 10             	add    $0x10,%esp
801010b0:	83 f8 20             	cmp    $0x20,%eax
801010b3:	0f 84 5f ff ff ff    	je     80101018 <exec+0xb8>
    freevm(pgdir);
801010b9:	83 ec 0c             	sub    $0xc,%esp
801010bc:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801010c2:	e8 19 60 00 00       	call   801070e0 <freevm>
801010c7:	83 c4 10             	add    $0x10,%esp
801010ca:	e9 e7 fe ff ff       	jmp    80100fb6 <exec+0x56>
801010cf:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
801010d5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801010db:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	53                   	push   %ebx
801010e5:	e8 76 0d 00 00       	call   80101e60 <iunlockput>
  end_op();
801010ea:	e8 71 20 00 00       	call   80103160 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801010ef:	83 c4 0c             	add    $0xc,%esp
801010f2:	56                   	push   %esi
801010f3:	57                   	push   %edi
801010f4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801010fa:	e8 81 5e 00 00       	call   80106f80 <allocuvm>
801010ff:	83 c4 10             	add    $0x10,%esp
80101102:	85 c0                	test   %eax,%eax
80101104:	89 c6                	mov    %eax,%esi
80101106:	75 3a                	jne    80101142 <exec+0x1e2>
    freevm(pgdir);
80101108:	83 ec 0c             	sub    $0xc,%esp
8010110b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80101111:	e8 ca 5f 00 00       	call   801070e0 <freevm>
80101116:	83 c4 10             	add    $0x10,%esp
  return -1;
80101119:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010111e:	e9 a9 fe ff ff       	jmp    80100fcc <exec+0x6c>
    end_op();
80101123:	e8 38 20 00 00       	call   80103160 <end_op>
    cprintf("exec: fail\n");
80101128:	83 ec 0c             	sub    $0xc,%esp
8010112b:	68 81 74 10 80       	push   $0x80107481
80101130:	e8 db f6 ff ff       	call   80100810 <cprintf>
    return -1;
80101135:	83 c4 10             	add    $0x10,%esp
80101138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010113d:	e9 8a fe ff ff       	jmp    80100fcc <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101142:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80101148:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
8010114b:	31 ff                	xor    %edi,%edi
8010114d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010114f:	50                   	push   %eax
80101150:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80101156:	e8 a5 60 00 00       	call   80107200 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
8010115b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010115e:	83 c4 10             	add    $0x10,%esp
80101161:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101167:	8b 00                	mov    (%eax),%eax
80101169:	85 c0                	test   %eax,%eax
8010116b:	74 70                	je     801011dd <exec+0x27d>
8010116d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80101173:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80101179:	eb 0a                	jmp    80101185 <exec+0x225>
8010117b:	90                   	nop
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80101180:	83 ff 20             	cmp    $0x20,%edi
80101183:	74 83                	je     80101108 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101185:	83 ec 0c             	sub    $0xc,%esp
80101188:	50                   	push   %eax
80101189:	e8 32 3a 00 00       	call   80104bc0 <strlen>
8010118e:	f7 d0                	not    %eax
80101190:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101192:	8b 45 0c             	mov    0xc(%ebp),%eax
80101195:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101196:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101199:	ff 34 b8             	pushl  (%eax,%edi,4)
8010119c:	e8 1f 3a 00 00       	call   80104bc0 <strlen>
801011a1:	83 c0 01             	add    $0x1,%eax
801011a4:	50                   	push   %eax
801011a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801011a8:	ff 34 b8             	pushl  (%eax,%edi,4)
801011ab:	53                   	push   %ebx
801011ac:	56                   	push   %esi
801011ad:	e8 ae 61 00 00       	call   80107360 <copyout>
801011b2:	83 c4 20             	add    $0x20,%esp
801011b5:	85 c0                	test   %eax,%eax
801011b7:	0f 88 4b ff ff ff    	js     80101108 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
801011bd:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
801011c0:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
801011c7:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
801011ca:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
801011d0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
801011d3:	85 c0                	test   %eax,%eax
801011d5:	75 a9                	jne    80101180 <exec+0x220>
801011d7:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011dd:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801011e4:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
801011e6:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801011ed:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
801011f1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801011f8:	ff ff ff 
  ustack[1] = argc;
801011fb:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101201:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80101203:	83 c0 0c             	add    $0xc,%eax
80101206:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101208:	50                   	push   %eax
80101209:	52                   	push   %edx
8010120a:	53                   	push   %ebx
8010120b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101211:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101217:	e8 44 61 00 00       	call   80107360 <copyout>
8010121c:	83 c4 10             	add    $0x10,%esp
8010121f:	85 c0                	test   %eax,%eax
80101221:	0f 88 e1 fe ff ff    	js     80101108 <exec+0x1a8>
  for(last=s=path; *s; s++)
80101227:	8b 45 08             	mov    0x8(%ebp),%eax
8010122a:	0f b6 00             	movzbl (%eax),%eax
8010122d:	84 c0                	test   %al,%al
8010122f:	74 17                	je     80101248 <exec+0x2e8>
80101231:	8b 55 08             	mov    0x8(%ebp),%edx
80101234:	89 d1                	mov    %edx,%ecx
80101236:	83 c1 01             	add    $0x1,%ecx
80101239:	3c 2f                	cmp    $0x2f,%al
8010123b:	0f b6 01             	movzbl (%ecx),%eax
8010123e:	0f 44 d1             	cmove  %ecx,%edx
80101241:	84 c0                	test   %al,%al
80101243:	75 f1                	jne    80101236 <exec+0x2d6>
80101245:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101248:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
8010124e:	50                   	push   %eax
8010124f:	6a 10                	push   $0x10
80101251:	ff 75 08             	pushl  0x8(%ebp)
80101254:	89 f8                	mov    %edi,%eax
80101256:	83 c0 6c             	add    $0x6c,%eax
80101259:	50                   	push   %eax
8010125a:	e8 21 39 00 00       	call   80104b80 <safestrcpy>
  curproc->pgdir = pgdir;
8010125f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80101265:	89 f9                	mov    %edi,%ecx
80101267:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
8010126a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
8010126d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
8010126f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80101272:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80101278:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
8010127b:	8b 41 18             	mov    0x18(%ecx),%eax
8010127e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80101281:	89 0c 24             	mov    %ecx,(%esp)
80101284:	e8 a7 5a 00 00       	call   80106d30 <switchuvm>
  freevm(oldpgdir);
80101289:	89 3c 24             	mov    %edi,(%esp)
8010128c:	e8 4f 5e 00 00       	call   801070e0 <freevm>
  return 0;
80101291:	83 c4 10             	add    $0x10,%esp
80101294:	31 c0                	xor    %eax,%eax
80101296:	e9 31 fd ff ff       	jmp    80100fcc <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010129b:	be 00 20 00 00       	mov    $0x2000,%esi
801012a0:	e9 3c fe ff ff       	jmp    801010e1 <exec+0x181>
801012a5:	66 90                	xchg   %ax,%ax
801012a7:	66 90                	xchg   %ax,%ax
801012a9:	66 90                	xchg   %ax,%ax
801012ab:	66 90                	xchg   %ax,%ax
801012ad:	66 90                	xchg   %ax,%ax
801012af:	90                   	nop

801012b0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801012b6:	68 8d 74 10 80       	push   $0x8010748d
801012bb:	68 e0 07 11 80       	push   $0x801107e0
801012c0:	e8 8b 34 00 00       	call   80104750 <initlock>
}
801012c5:	83 c4 10             	add    $0x10,%esp
801012c8:	c9                   	leave  
801012c9:	c3                   	ret    
801012ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801012d0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801012d4:	bb 14 08 11 80       	mov    $0x80110814,%ebx
{
801012d9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801012dc:	68 e0 07 11 80       	push   $0x801107e0
801012e1:	e8 aa 35 00 00       	call   80104890 <acquire>
801012e6:	83 c4 10             	add    $0x10,%esp
801012e9:	eb 10                	jmp    801012fb <filealloc+0x2b>
801012eb:	90                   	nop
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801012f0:	83 c3 18             	add    $0x18,%ebx
801012f3:	81 fb 74 11 11 80    	cmp    $0x80111174,%ebx
801012f9:	73 25                	jae    80101320 <filealloc+0x50>
    if(f->ref == 0){
801012fb:	8b 43 04             	mov    0x4(%ebx),%eax
801012fe:	85 c0                	test   %eax,%eax
80101300:	75 ee                	jne    801012f0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101302:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101305:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010130c:	68 e0 07 11 80       	push   $0x801107e0
80101311:	e8 3a 36 00 00       	call   80104950 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101316:	89 d8                	mov    %ebx,%eax
      return f;
80101318:	83 c4 10             	add    $0x10,%esp
}
8010131b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010131e:	c9                   	leave  
8010131f:	c3                   	ret    
  release(&ftable.lock);
80101320:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101323:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101325:	68 e0 07 11 80       	push   $0x801107e0
8010132a:	e8 21 36 00 00       	call   80104950 <release>
}
8010132f:	89 d8                	mov    %ebx,%eax
  return 0;
80101331:	83 c4 10             	add    $0x10,%esp
}
80101334:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101337:	c9                   	leave  
80101338:	c3                   	ret    
80101339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101340 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	53                   	push   %ebx
80101344:	83 ec 10             	sub    $0x10,%esp
80101347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010134a:	68 e0 07 11 80       	push   $0x801107e0
8010134f:	e8 3c 35 00 00       	call   80104890 <acquire>
  if(f->ref < 1)
80101354:	8b 43 04             	mov    0x4(%ebx),%eax
80101357:	83 c4 10             	add    $0x10,%esp
8010135a:	85 c0                	test   %eax,%eax
8010135c:	7e 1a                	jle    80101378 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010135e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101361:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101364:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101367:	68 e0 07 11 80       	push   $0x801107e0
8010136c:	e8 df 35 00 00       	call   80104950 <release>
  return f;
}
80101371:	89 d8                	mov    %ebx,%eax
80101373:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101376:	c9                   	leave  
80101377:	c3                   	ret    
    panic("filedup");
80101378:	83 ec 0c             	sub    $0xc,%esp
8010137b:	68 94 74 10 80       	push   $0x80107494
80101380:	e8 7b f1 ff ff       	call   80100500 <panic>
80101385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101390 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	53                   	push   %ebx
80101396:	83 ec 28             	sub    $0x28,%esp
80101399:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010139c:	68 e0 07 11 80       	push   $0x801107e0
801013a1:	e8 ea 34 00 00       	call   80104890 <acquire>
  if(f->ref < 1)
801013a6:	8b 43 04             	mov    0x4(%ebx),%eax
801013a9:	83 c4 10             	add    $0x10,%esp
801013ac:	85 c0                	test   %eax,%eax
801013ae:	0f 8e 9b 00 00 00    	jle    8010144f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
801013b4:	83 e8 01             	sub    $0x1,%eax
801013b7:	85 c0                	test   %eax,%eax
801013b9:	89 43 04             	mov    %eax,0x4(%ebx)
801013bc:	74 1a                	je     801013d8 <fileclose+0x48>
    release(&ftable.lock);
801013be:	c7 45 08 e0 07 11 80 	movl   $0x801107e0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801013c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013c8:	5b                   	pop    %ebx
801013c9:	5e                   	pop    %esi
801013ca:	5f                   	pop    %edi
801013cb:	5d                   	pop    %ebp
    release(&ftable.lock);
801013cc:	e9 7f 35 00 00       	jmp    80104950 <release>
801013d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
801013d8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
801013dc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
801013de:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801013e1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
801013e4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801013ea:	88 45 e7             	mov    %al,-0x19(%ebp)
801013ed:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801013f0:	68 e0 07 11 80       	push   $0x801107e0
  ff = *f;
801013f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801013f8:	e8 53 35 00 00       	call   80104950 <release>
  if(ff.type == FD_PIPE)
801013fd:	83 c4 10             	add    $0x10,%esp
80101400:	83 ff 01             	cmp    $0x1,%edi
80101403:	74 13                	je     80101418 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80101405:	83 ff 02             	cmp    $0x2,%edi
80101408:	74 26                	je     80101430 <fileclose+0xa0>
}
8010140a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010140d:	5b                   	pop    %ebx
8010140e:	5e                   	pop    %esi
8010140f:	5f                   	pop    %edi
80101410:	5d                   	pop    %ebp
80101411:	c3                   	ret    
80101412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80101418:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010141c:	83 ec 08             	sub    $0x8,%esp
8010141f:	53                   	push   %ebx
80101420:	56                   	push   %esi
80101421:	e8 7a 24 00 00       	call   801038a0 <pipeclose>
80101426:	83 c4 10             	add    $0x10,%esp
80101429:	eb df                	jmp    8010140a <fileclose+0x7a>
8010142b:	90                   	nop
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101430:	e8 bb 1c 00 00       	call   801030f0 <begin_op>
    iput(ff.ip);
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	ff 75 e0             	pushl  -0x20(%ebp)
8010143b:	e8 c0 08 00 00       	call   80101d00 <iput>
    end_op();
80101440:	83 c4 10             	add    $0x10,%esp
}
80101443:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101446:	5b                   	pop    %ebx
80101447:	5e                   	pop    %esi
80101448:	5f                   	pop    %edi
80101449:	5d                   	pop    %ebp
    end_op();
8010144a:	e9 11 1d 00 00       	jmp    80103160 <end_op>
    panic("fileclose");
8010144f:	83 ec 0c             	sub    $0xc,%esp
80101452:	68 9c 74 10 80       	push   $0x8010749c
80101457:	e8 a4 f0 ff ff       	call   80100500 <panic>
8010145c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101460 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	53                   	push   %ebx
80101464:	83 ec 04             	sub    $0x4,%esp
80101467:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010146a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010146d:	75 31                	jne    801014a0 <filestat+0x40>
    ilock(f->ip);
8010146f:	83 ec 0c             	sub    $0xc,%esp
80101472:	ff 73 10             	pushl  0x10(%ebx)
80101475:	e8 56 07 00 00       	call   80101bd0 <ilock>
    stati(f->ip, st);
8010147a:	58                   	pop    %eax
8010147b:	5a                   	pop    %edx
8010147c:	ff 75 0c             	pushl  0xc(%ebp)
8010147f:	ff 73 10             	pushl  0x10(%ebx)
80101482:	e8 f9 09 00 00       	call   80101e80 <stati>
    iunlock(f->ip);
80101487:	59                   	pop    %ecx
80101488:	ff 73 10             	pushl  0x10(%ebx)
8010148b:	e8 20 08 00 00       	call   80101cb0 <iunlock>
    return 0;
80101490:	83 c4 10             	add    $0x10,%esp
80101493:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101495:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101498:	c9                   	leave  
80101499:	c3                   	ret    
8010149a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
801014a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014a5:	eb ee                	jmp    80101495 <filestat+0x35>
801014a7:	89 f6                	mov    %esi,%esi
801014a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014b0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	57                   	push   %edi
801014b4:	56                   	push   %esi
801014b5:	53                   	push   %ebx
801014b6:	83 ec 0c             	sub    $0xc,%esp
801014b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801014bc:	8b 75 0c             	mov    0xc(%ebp),%esi
801014bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801014c2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801014c6:	74 60                	je     80101528 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801014c8:	8b 03                	mov    (%ebx),%eax
801014ca:	83 f8 01             	cmp    $0x1,%eax
801014cd:	74 41                	je     80101510 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801014cf:	83 f8 02             	cmp    $0x2,%eax
801014d2:	75 5b                	jne    8010152f <fileread+0x7f>
    ilock(f->ip);
801014d4:	83 ec 0c             	sub    $0xc,%esp
801014d7:	ff 73 10             	pushl  0x10(%ebx)
801014da:	e8 f1 06 00 00       	call   80101bd0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801014df:	57                   	push   %edi
801014e0:	ff 73 14             	pushl  0x14(%ebx)
801014e3:	56                   	push   %esi
801014e4:	ff 73 10             	pushl  0x10(%ebx)
801014e7:	e8 c4 09 00 00       	call   80101eb0 <readi>
801014ec:	83 c4 20             	add    $0x20,%esp
801014ef:	85 c0                	test   %eax,%eax
801014f1:	89 c6                	mov    %eax,%esi
801014f3:	7e 03                	jle    801014f8 <fileread+0x48>
      f->off += r;
801014f5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	ff 73 10             	pushl  0x10(%ebx)
801014fe:	e8 ad 07 00 00       	call   80101cb0 <iunlock>
    return r;
80101503:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101506:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101509:	89 f0                	mov    %esi,%eax
8010150b:	5b                   	pop    %ebx
8010150c:	5e                   	pop    %esi
8010150d:	5f                   	pop    %edi
8010150e:	5d                   	pop    %ebp
8010150f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101510:	8b 43 0c             	mov    0xc(%ebx),%eax
80101513:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101516:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101519:	5b                   	pop    %ebx
8010151a:	5e                   	pop    %esi
8010151b:	5f                   	pop    %edi
8010151c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010151d:	e9 2e 25 00 00       	jmp    80103a50 <piperead>
80101522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101528:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010152d:	eb d7                	jmp    80101506 <fileread+0x56>
  panic("fileread");
8010152f:	83 ec 0c             	sub    $0xc,%esp
80101532:	68 a6 74 10 80       	push   $0x801074a6
80101537:	e8 c4 ef ff ff       	call   80100500 <panic>
8010153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101540 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	83 ec 1c             	sub    $0x1c,%esp
80101549:	8b 75 08             	mov    0x8(%ebp),%esi
8010154c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010154f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101553:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101556:	8b 45 10             	mov    0x10(%ebp),%eax
80101559:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010155c:	0f 84 aa 00 00 00    	je     8010160c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101562:	8b 06                	mov    (%esi),%eax
80101564:	83 f8 01             	cmp    $0x1,%eax
80101567:	0f 84 c3 00 00 00    	je     80101630 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010156d:	83 f8 02             	cmp    $0x2,%eax
80101570:	0f 85 d9 00 00 00    	jne    8010164f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101579:	31 ff                	xor    %edi,%edi
    while(i < n){
8010157b:	85 c0                	test   %eax,%eax
8010157d:	7f 34                	jg     801015b3 <filewrite+0x73>
8010157f:	e9 9c 00 00 00       	jmp    80101620 <filewrite+0xe0>
80101584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101588:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010158b:	83 ec 0c             	sub    $0xc,%esp
8010158e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101591:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101594:	e8 17 07 00 00       	call   80101cb0 <iunlock>
      end_op();
80101599:	e8 c2 1b 00 00       	call   80103160 <end_op>
8010159e:	8b 45 e0             	mov    -0x20(%ebp),%eax
801015a1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801015a4:	39 c3                	cmp    %eax,%ebx
801015a6:	0f 85 96 00 00 00    	jne    80101642 <filewrite+0x102>
        panic("short filewrite");
      i += r;
801015ac:	01 df                	add    %ebx,%edi
    while(i < n){
801015ae:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801015b1:	7e 6d                	jle    80101620 <filewrite+0xe0>
      int n1 = n - i;
801015b3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801015b6:	b8 00 06 00 00       	mov    $0x600,%eax
801015bb:	29 fb                	sub    %edi,%ebx
801015bd:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801015c3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801015c6:	e8 25 1b 00 00       	call   801030f0 <begin_op>
      ilock(f->ip);
801015cb:	83 ec 0c             	sub    $0xc,%esp
801015ce:	ff 76 10             	pushl  0x10(%esi)
801015d1:	e8 fa 05 00 00       	call   80101bd0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801015d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801015d9:	53                   	push   %ebx
801015da:	ff 76 14             	pushl  0x14(%esi)
801015dd:	01 f8                	add    %edi,%eax
801015df:	50                   	push   %eax
801015e0:	ff 76 10             	pushl  0x10(%esi)
801015e3:	e8 c8 09 00 00       	call   80101fb0 <writei>
801015e8:	83 c4 20             	add    $0x20,%esp
801015eb:	85 c0                	test   %eax,%eax
801015ed:	7f 99                	jg     80101588 <filewrite+0x48>
      iunlock(f->ip);
801015ef:	83 ec 0c             	sub    $0xc,%esp
801015f2:	ff 76 10             	pushl  0x10(%esi)
801015f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801015f8:	e8 b3 06 00 00       	call   80101cb0 <iunlock>
      end_op();
801015fd:	e8 5e 1b 00 00       	call   80103160 <end_op>
      if(r < 0)
80101602:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101605:	83 c4 10             	add    $0x10,%esp
80101608:	85 c0                	test   %eax,%eax
8010160a:	74 98                	je     801015a4 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010160c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010160f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101614:	89 f8                	mov    %edi,%eax
80101616:	5b                   	pop    %ebx
80101617:	5e                   	pop    %esi
80101618:	5f                   	pop    %edi
80101619:	5d                   	pop    %ebp
8010161a:	c3                   	ret    
8010161b:	90                   	nop
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101620:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101623:	75 e7                	jne    8010160c <filewrite+0xcc>
}
80101625:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101628:	89 f8                	mov    %edi,%eax
8010162a:	5b                   	pop    %ebx
8010162b:	5e                   	pop    %esi
8010162c:	5f                   	pop    %edi
8010162d:	5d                   	pop    %ebp
8010162e:	c3                   	ret    
8010162f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101630:	8b 46 0c             	mov    0xc(%esi),%eax
80101633:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101636:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101639:	5b                   	pop    %ebx
8010163a:	5e                   	pop    %esi
8010163b:	5f                   	pop    %edi
8010163c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010163d:	e9 fe 22 00 00       	jmp    80103940 <pipewrite>
        panic("short filewrite");
80101642:	83 ec 0c             	sub    $0xc,%esp
80101645:	68 af 74 10 80       	push   $0x801074af
8010164a:	e8 b1 ee ff ff       	call   80100500 <panic>
  panic("filewrite");
8010164f:	83 ec 0c             	sub    $0xc,%esp
80101652:	68 b5 74 10 80       	push   $0x801074b5
80101657:	e8 a4 ee ff ff       	call   80100500 <panic>
8010165c:	66 90                	xchg   %ax,%ax
8010165e:	66 90                	xchg   %ax,%ax

80101660 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101667:	c1 ea 0c             	shr    $0xc,%edx
8010166a:	03 15 f8 11 11 80    	add    0x801111f8,%edx
80101670:	83 ec 08             	sub    $0x8,%esp
80101673:	52                   	push   %edx
80101674:	50                   	push   %eax
80101675:	e8 56 ea ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010167a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010167c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010167f:	ba 01 00 00 00       	mov    $0x1,%edx
80101684:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101687:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010168d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101690:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101692:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101697:	85 d1                	test   %edx,%ecx
80101699:	74 25                	je     801016c0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010169b:	f7 d2                	not    %edx
8010169d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010169f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801016a2:	21 ca                	and    %ecx,%edx
801016a4:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801016a8:	56                   	push   %esi
801016a9:	e8 12 1c 00 00       	call   801032c0 <log_write>
  brelse(bp);
801016ae:	89 34 24             	mov    %esi,(%esp)
801016b1:	e8 2a eb ff ff       	call   801001e0 <brelse>
}
801016b6:	83 c4 10             	add    $0x10,%esp
801016b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016bc:	5b                   	pop    %ebx
801016bd:	5e                   	pop    %esi
801016be:	5d                   	pop    %ebp
801016bf:	c3                   	ret    
    panic("freeing free block");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 bf 74 10 80       	push   $0x801074bf
801016c8:	e8 33 ee ff ff       	call   80100500 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <balloc>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	57                   	push   %edi
801016d4:	56                   	push   %esi
801016d5:	53                   	push   %ebx
801016d6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801016d9:	8b 0d e0 11 11 80    	mov    0x801111e0,%ecx
{
801016df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801016e2:	85 c9                	test   %ecx,%ecx
801016e4:	0f 84 87 00 00 00    	je     80101771 <balloc+0xa1>
801016ea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801016f1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801016f4:	83 ec 08             	sub    $0x8,%esp
801016f7:	89 f0                	mov    %esi,%eax
801016f9:	c1 f8 0c             	sar    $0xc,%eax
801016fc:	03 05 f8 11 11 80    	add    0x801111f8,%eax
80101702:	50                   	push   %eax
80101703:	ff 75 d8             	pushl  -0x28(%ebp)
80101706:	e8 c5 e9 ff ff       	call   801000d0 <bread>
8010170b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010170e:	a1 e0 11 11 80       	mov    0x801111e0,%eax
80101713:	83 c4 10             	add    $0x10,%esp
80101716:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101719:	31 c0                	xor    %eax,%eax
8010171b:	eb 2f                	jmp    8010174c <balloc+0x7c>
8010171d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101720:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101722:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101725:	bb 01 00 00 00       	mov    $0x1,%ebx
8010172a:	83 e1 07             	and    $0x7,%ecx
8010172d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010172f:	89 c1                	mov    %eax,%ecx
80101731:	c1 f9 03             	sar    $0x3,%ecx
80101734:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101739:	85 df                	test   %ebx,%edi
8010173b:	89 fa                	mov    %edi,%edx
8010173d:	74 41                	je     80101780 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010173f:	83 c0 01             	add    $0x1,%eax
80101742:	83 c6 01             	add    $0x1,%esi
80101745:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010174a:	74 05                	je     80101751 <balloc+0x81>
8010174c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010174f:	77 cf                	ja     80101720 <balloc+0x50>
    brelse(bp);
80101751:	83 ec 0c             	sub    $0xc,%esp
80101754:	ff 75 e4             	pushl  -0x1c(%ebp)
80101757:	e8 84 ea ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010175c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101763:	83 c4 10             	add    $0x10,%esp
80101766:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101769:	39 05 e0 11 11 80    	cmp    %eax,0x801111e0
8010176f:	77 80                	ja     801016f1 <balloc+0x21>
  panic("balloc: out of blocks");
80101771:	83 ec 0c             	sub    $0xc,%esp
80101774:	68 d2 74 10 80       	push   $0x801074d2
80101779:	e8 82 ed ff ff       	call   80100500 <panic>
8010177e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101780:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101783:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101786:	09 da                	or     %ebx,%edx
80101788:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010178c:	57                   	push   %edi
8010178d:	e8 2e 1b 00 00       	call   801032c0 <log_write>
        brelse(bp);
80101792:	89 3c 24             	mov    %edi,(%esp)
80101795:	e8 46 ea ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010179a:	58                   	pop    %eax
8010179b:	5a                   	pop    %edx
8010179c:	56                   	push   %esi
8010179d:	ff 75 d8             	pushl  -0x28(%ebp)
801017a0:	e8 2b e9 ff ff       	call   801000d0 <bread>
801017a5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801017a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801017aa:	83 c4 0c             	add    $0xc,%esp
801017ad:	68 00 02 00 00       	push   $0x200
801017b2:	6a 00                	push   $0x0
801017b4:	50                   	push   %eax
801017b5:	e8 e6 31 00 00       	call   801049a0 <memset>
  log_write(bp);
801017ba:	89 1c 24             	mov    %ebx,(%esp)
801017bd:	e8 fe 1a 00 00       	call   801032c0 <log_write>
  brelse(bp);
801017c2:	89 1c 24             	mov    %ebx,(%esp)
801017c5:	e8 16 ea ff ff       	call   801001e0 <brelse>
}
801017ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017cd:	89 f0                	mov    %esi,%eax
801017cf:	5b                   	pop    %ebx
801017d0:	5e                   	pop    %esi
801017d1:	5f                   	pop    %edi
801017d2:	5d                   	pop    %ebp
801017d3:	c3                   	ret    
801017d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017e0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801017e8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017ea:	bb 34 12 11 80       	mov    $0x80111234,%ebx
{
801017ef:	83 ec 28             	sub    $0x28,%esp
801017f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801017f5:	68 00 12 11 80       	push   $0x80111200
801017fa:	e8 91 30 00 00       	call   80104890 <acquire>
801017ff:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101802:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101805:	eb 17                	jmp    8010181e <iget+0x3e>
80101807:	89 f6                	mov    %esi,%esi
80101809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101810:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101816:	81 fb 54 2e 11 80    	cmp    $0x80112e54,%ebx
8010181c:	73 22                	jae    80101840 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010181e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101821:	85 c9                	test   %ecx,%ecx
80101823:	7e 04                	jle    80101829 <iget+0x49>
80101825:	39 3b                	cmp    %edi,(%ebx)
80101827:	74 4f                	je     80101878 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101829:	85 f6                	test   %esi,%esi
8010182b:	75 e3                	jne    80101810 <iget+0x30>
8010182d:	85 c9                	test   %ecx,%ecx
8010182f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101832:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101838:	81 fb 54 2e 11 80    	cmp    $0x80112e54,%ebx
8010183e:	72 de                	jb     8010181e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101840:	85 f6                	test   %esi,%esi
80101842:	74 5b                	je     8010189f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101844:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101847:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101849:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010184c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101853:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010185a:	68 00 12 11 80       	push   $0x80111200
8010185f:	e8 ec 30 00 00       	call   80104950 <release>

  return ip;
80101864:	83 c4 10             	add    $0x10,%esp
}
80101867:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010186a:	89 f0                	mov    %esi,%eax
8010186c:	5b                   	pop    %ebx
8010186d:	5e                   	pop    %esi
8010186e:	5f                   	pop    %edi
8010186f:	5d                   	pop    %ebp
80101870:	c3                   	ret    
80101871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101878:	39 53 04             	cmp    %edx,0x4(%ebx)
8010187b:	75 ac                	jne    80101829 <iget+0x49>
      release(&icache.lock);
8010187d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101880:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101883:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101885:	68 00 12 11 80       	push   $0x80111200
      ip->ref++;
8010188a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010188d:	e8 be 30 00 00       	call   80104950 <release>
      return ip;
80101892:	83 c4 10             	add    $0x10,%esp
}
80101895:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101898:	89 f0                	mov    %esi,%eax
8010189a:	5b                   	pop    %ebx
8010189b:	5e                   	pop    %esi
8010189c:	5f                   	pop    %edi
8010189d:	5d                   	pop    %ebp
8010189e:	c3                   	ret    
    panic("iget: no inodes");
8010189f:	83 ec 0c             	sub    $0xc,%esp
801018a2:	68 e8 74 10 80       	push   $0x801074e8
801018a7:	e8 54 ec ff ff       	call   80100500 <panic>
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	89 c6                	mov    %eax,%esi
801018b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801018bb:	83 fa 0b             	cmp    $0xb,%edx
801018be:	77 18                	ja     801018d8 <bmap+0x28>
801018c0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801018c3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801018c6:	85 db                	test   %ebx,%ebx
801018c8:	74 76                	je     80101940 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801018ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018cd:	89 d8                	mov    %ebx,%eax
801018cf:	5b                   	pop    %ebx
801018d0:	5e                   	pop    %esi
801018d1:	5f                   	pop    %edi
801018d2:	5d                   	pop    %ebp
801018d3:	c3                   	ret    
801018d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801018d8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801018db:	83 fb 7f             	cmp    $0x7f,%ebx
801018de:	0f 87 90 00 00 00    	ja     80101974 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801018e4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801018ea:	8b 00                	mov    (%eax),%eax
801018ec:	85 d2                	test   %edx,%edx
801018ee:	74 70                	je     80101960 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801018f0:	83 ec 08             	sub    $0x8,%esp
801018f3:	52                   	push   %edx
801018f4:	50                   	push   %eax
801018f5:	e8 d6 e7 ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801018fa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801018fe:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101901:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101903:	8b 1a                	mov    (%edx),%ebx
80101905:	85 db                	test   %ebx,%ebx
80101907:	75 1d                	jne    80101926 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101909:	8b 06                	mov    (%esi),%eax
8010190b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010190e:	e8 bd fd ff ff       	call   801016d0 <balloc>
80101913:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101916:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101919:	89 c3                	mov    %eax,%ebx
8010191b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010191d:	57                   	push   %edi
8010191e:	e8 9d 19 00 00       	call   801032c0 <log_write>
80101923:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101926:	83 ec 0c             	sub    $0xc,%esp
80101929:	57                   	push   %edi
8010192a:	e8 b1 e8 ff ff       	call   801001e0 <brelse>
8010192f:	83 c4 10             	add    $0x10,%esp
}
80101932:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101935:	89 d8                	mov    %ebx,%eax
80101937:	5b                   	pop    %ebx
80101938:	5e                   	pop    %esi
80101939:	5f                   	pop    %edi
8010193a:	5d                   	pop    %ebp
8010193b:	c3                   	ret    
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101940:	8b 00                	mov    (%eax),%eax
80101942:	e8 89 fd ff ff       	call   801016d0 <balloc>
80101947:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010194a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010194d:	89 c3                	mov    %eax,%ebx
}
8010194f:	89 d8                	mov    %ebx,%eax
80101951:	5b                   	pop    %ebx
80101952:	5e                   	pop    %esi
80101953:	5f                   	pop    %edi
80101954:	5d                   	pop    %ebp
80101955:	c3                   	ret    
80101956:	8d 76 00             	lea    0x0(%esi),%esi
80101959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101960:	e8 6b fd ff ff       	call   801016d0 <balloc>
80101965:	89 c2                	mov    %eax,%edx
80101967:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010196d:	8b 06                	mov    (%esi),%eax
8010196f:	e9 7c ff ff ff       	jmp    801018f0 <bmap+0x40>
  panic("bmap: out of range");
80101974:	83 ec 0c             	sub    $0xc,%esp
80101977:	68 f8 74 10 80       	push   $0x801074f8
8010197c:	e8 7f eb ff ff       	call   80100500 <panic>
80101981:	eb 0d                	jmp    80101990 <readsb>
80101983:	90                   	nop
80101984:	90                   	nop
80101985:	90                   	nop
80101986:	90                   	nop
80101987:	90                   	nop
80101988:	90                   	nop
80101989:	90                   	nop
8010198a:	90                   	nop
8010198b:	90                   	nop
8010198c:	90                   	nop
8010198d:	90                   	nop
8010198e:	90                   	nop
8010198f:	90                   	nop

80101990 <readsb>:
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	56                   	push   %esi
80101994:	53                   	push   %ebx
80101995:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101998:	83 ec 08             	sub    $0x8,%esp
8010199b:	6a 01                	push   $0x1
8010199d:	ff 75 08             	pushl  0x8(%ebp)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801019a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801019aa:	83 c4 0c             	add    $0xc,%esp
801019ad:	6a 1c                	push   $0x1c
801019af:	50                   	push   %eax
801019b0:	56                   	push   %esi
801019b1:	e8 9a 30 00 00       	call   80104a50 <memmove>
  brelse(bp);
801019b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019b9:	83 c4 10             	add    $0x10,%esp
}
801019bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019bf:	5b                   	pop    %ebx
801019c0:	5e                   	pop    %esi
801019c1:	5d                   	pop    %ebp
  brelse(bp);
801019c2:	e9 19 e8 ff ff       	jmp    801001e0 <brelse>
801019c7:	89 f6                	mov    %esi,%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801019d0 <iinit>:
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	53                   	push   %ebx
801019d4:	bb 40 12 11 80       	mov    $0x80111240,%ebx
801019d9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801019dc:	68 0b 75 10 80       	push   $0x8010750b
801019e1:	68 00 12 11 80       	push   $0x80111200
801019e6:	e8 65 2d 00 00       	call   80104750 <initlock>
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801019f0:	83 ec 08             	sub    $0x8,%esp
801019f3:	68 12 75 10 80       	push   $0x80107512
801019f8:	53                   	push   %ebx
801019f9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801019ff:	e8 1c 2c 00 00       	call   80104620 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101a04:	83 c4 10             	add    $0x10,%esp
80101a07:	81 fb 60 2e 11 80    	cmp    $0x80112e60,%ebx
80101a0d:	75 e1                	jne    801019f0 <iinit+0x20>
  readsb(dev, &sb);
80101a0f:	83 ec 08             	sub    $0x8,%esp
80101a12:	68 e0 11 11 80       	push   $0x801111e0
80101a17:	ff 75 08             	pushl  0x8(%ebp)
80101a1a:	e8 71 ff ff ff       	call   80101990 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101a1f:	ff 35 f8 11 11 80    	pushl  0x801111f8
80101a25:	ff 35 f4 11 11 80    	pushl  0x801111f4
80101a2b:	ff 35 f0 11 11 80    	pushl  0x801111f0
80101a31:	ff 35 ec 11 11 80    	pushl  0x801111ec
80101a37:	ff 35 e8 11 11 80    	pushl  0x801111e8
80101a3d:	ff 35 e4 11 11 80    	pushl  0x801111e4
80101a43:	ff 35 e0 11 11 80    	pushl  0x801111e0
80101a49:	68 78 75 10 80       	push   $0x80107578
80101a4e:	e8 bd ed ff ff       	call   80100810 <cprintf>
}
80101a53:	83 c4 30             	add    $0x30,%esp
80101a56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a59:	c9                   	leave  
80101a5a:	c3                   	ret    
80101a5b:	90                   	nop
80101a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a60 <ialloc>:
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101a69:	83 3d e8 11 11 80 01 	cmpl   $0x1,0x801111e8
{
80101a70:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a73:	8b 75 08             	mov    0x8(%ebp),%esi
80101a76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101a79:	0f 86 91 00 00 00    	jbe    80101b10 <ialloc+0xb0>
80101a7f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101a84:	eb 21                	jmp    80101aa7 <ialloc+0x47>
80101a86:	8d 76 00             	lea    0x0(%esi),%esi
80101a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101a90:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101a93:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101a96:	57                   	push   %edi
80101a97:	e8 44 e7 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101a9c:	83 c4 10             	add    $0x10,%esp
80101a9f:	39 1d e8 11 11 80    	cmp    %ebx,0x801111e8
80101aa5:	76 69                	jbe    80101b10 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101aa7:	89 d8                	mov    %ebx,%eax
80101aa9:	83 ec 08             	sub    $0x8,%esp
80101aac:	c1 e8 03             	shr    $0x3,%eax
80101aaf:	03 05 f4 11 11 80    	add    0x801111f4,%eax
80101ab5:	50                   	push   %eax
80101ab6:	56                   	push   %esi
80101ab7:	e8 14 e6 ff ff       	call   801000d0 <bread>
80101abc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101abe:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101ac0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101ac3:	83 e0 07             	and    $0x7,%eax
80101ac6:	c1 e0 06             	shl    $0x6,%eax
80101ac9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101acd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101ad1:	75 bd                	jne    80101a90 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101ad3:	83 ec 04             	sub    $0x4,%esp
80101ad6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ad9:	6a 40                	push   $0x40
80101adb:	6a 00                	push   $0x0
80101add:	51                   	push   %ecx
80101ade:	e8 bd 2e 00 00       	call   801049a0 <memset>
      dip->type = type;
80101ae3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101ae7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101aed:	89 3c 24             	mov    %edi,(%esp)
80101af0:	e8 cb 17 00 00       	call   801032c0 <log_write>
      brelse(bp);
80101af5:	89 3c 24             	mov    %edi,(%esp)
80101af8:	e8 e3 e6 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
80101afd:	83 c4 10             	add    $0x10,%esp
}
80101b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101b03:	89 da                	mov    %ebx,%edx
80101b05:	89 f0                	mov    %esi,%eax
}
80101b07:	5b                   	pop    %ebx
80101b08:	5e                   	pop    %esi
80101b09:	5f                   	pop    %edi
80101b0a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101b0b:	e9 d0 fc ff ff       	jmp    801017e0 <iget>
  panic("ialloc: no inodes");
80101b10:	83 ec 0c             	sub    $0xc,%esp
80101b13:	68 18 75 10 80       	push   $0x80107518
80101b18:	e8 e3 e9 ff ff       	call   80100500 <panic>
80101b1d:	8d 76 00             	lea    0x0(%esi),%esi

80101b20 <iupdate>:
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	56                   	push   %esi
80101b24:	53                   	push   %ebx
80101b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b28:	83 ec 08             	sub    $0x8,%esp
80101b2b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b2e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b31:	c1 e8 03             	shr    $0x3,%eax
80101b34:	03 05 f4 11 11 80    	add    0x801111f4,%eax
80101b3a:	50                   	push   %eax
80101b3b:	ff 73 a4             	pushl  -0x5c(%ebx)
80101b3e:	e8 8d e5 ff ff       	call   801000d0 <bread>
80101b43:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b45:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101b48:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b4c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b4f:	83 e0 07             	and    $0x7,%eax
80101b52:	c1 e0 06             	shl    $0x6,%eax
80101b55:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101b59:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101b5c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b60:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101b63:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101b67:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101b6b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101b6f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101b73:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101b77:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101b7a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b7d:	6a 34                	push   $0x34
80101b7f:	53                   	push   %ebx
80101b80:	50                   	push   %eax
80101b81:	e8 ca 2e 00 00       	call   80104a50 <memmove>
  log_write(bp);
80101b86:	89 34 24             	mov    %esi,(%esp)
80101b89:	e8 32 17 00 00       	call   801032c0 <log_write>
  brelse(bp);
80101b8e:	89 75 08             	mov    %esi,0x8(%ebp)
80101b91:	83 c4 10             	add    $0x10,%esp
}
80101b94:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b97:	5b                   	pop    %ebx
80101b98:	5e                   	pop    %esi
80101b99:	5d                   	pop    %ebp
  brelse(bp);
80101b9a:	e9 41 e6 ff ff       	jmp    801001e0 <brelse>
80101b9f:	90                   	nop

80101ba0 <idup>:
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	53                   	push   %ebx
80101ba4:	83 ec 10             	sub    $0x10,%esp
80101ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101baa:	68 00 12 11 80       	push   $0x80111200
80101baf:	e8 dc 2c 00 00       	call   80104890 <acquire>
  ip->ref++;
80101bb4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101bb8:	c7 04 24 00 12 11 80 	movl   $0x80111200,(%esp)
80101bbf:	e8 8c 2d 00 00       	call   80104950 <release>
}
80101bc4:	89 d8                	mov    %ebx,%eax
80101bc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101bc9:	c9                   	leave  
80101bca:	c3                   	ret    
80101bcb:	90                   	nop
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101bd0 <ilock>:
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	56                   	push   %esi
80101bd4:	53                   	push   %ebx
80101bd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101bd8:	85 db                	test   %ebx,%ebx
80101bda:	0f 84 b7 00 00 00    	je     80101c97 <ilock+0xc7>
80101be0:	8b 53 08             	mov    0x8(%ebx),%edx
80101be3:	85 d2                	test   %edx,%edx
80101be5:	0f 8e ac 00 00 00    	jle    80101c97 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101beb:	8d 43 0c             	lea    0xc(%ebx),%eax
80101bee:	83 ec 0c             	sub    $0xc,%esp
80101bf1:	50                   	push   %eax
80101bf2:	e8 69 2a 00 00       	call   80104660 <acquiresleep>
  if(ip->valid == 0){
80101bf7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101bfa:	83 c4 10             	add    $0x10,%esp
80101bfd:	85 c0                	test   %eax,%eax
80101bff:	74 0f                	je     80101c10 <ilock+0x40>
}
80101c01:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c04:	5b                   	pop    %ebx
80101c05:	5e                   	pop    %esi
80101c06:	5d                   	pop    %ebp
80101c07:	c3                   	ret    
80101c08:	90                   	nop
80101c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c10:	8b 43 04             	mov    0x4(%ebx),%eax
80101c13:	83 ec 08             	sub    $0x8,%esp
80101c16:	c1 e8 03             	shr    $0x3,%eax
80101c19:	03 05 f4 11 11 80    	add    0x801111f4,%eax
80101c1f:	50                   	push   %eax
80101c20:	ff 33                	pushl  (%ebx)
80101c22:	e8 a9 e4 ff ff       	call   801000d0 <bread>
80101c27:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c29:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c2c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c2f:	83 e0 07             	and    $0x7,%eax
80101c32:	c1 e0 06             	shl    $0x6,%eax
80101c35:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101c39:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c3c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101c3f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101c43:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101c47:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101c4b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101c4f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101c53:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101c57:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101c5b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101c5e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c61:	6a 34                	push   $0x34
80101c63:	50                   	push   %eax
80101c64:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101c67:	50                   	push   %eax
80101c68:	e8 e3 2d 00 00       	call   80104a50 <memmove>
    brelse(bp);
80101c6d:	89 34 24             	mov    %esi,(%esp)
80101c70:	e8 6b e5 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101c75:	83 c4 10             	add    $0x10,%esp
80101c78:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101c7d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101c84:	0f 85 77 ff ff ff    	jne    80101c01 <ilock+0x31>
      panic("ilock: no type");
80101c8a:	83 ec 0c             	sub    $0xc,%esp
80101c8d:	68 30 75 10 80       	push   $0x80107530
80101c92:	e8 69 e8 ff ff       	call   80100500 <panic>
    panic("ilock");
80101c97:	83 ec 0c             	sub    $0xc,%esp
80101c9a:	68 2a 75 10 80       	push   $0x8010752a
80101c9f:	e8 5c e8 ff ff       	call   80100500 <panic>
80101ca4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101caa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101cb0 <iunlock>:
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	56                   	push   %esi
80101cb4:	53                   	push   %ebx
80101cb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101cb8:	85 db                	test   %ebx,%ebx
80101cba:	74 28                	je     80101ce4 <iunlock+0x34>
80101cbc:	8d 73 0c             	lea    0xc(%ebx),%esi
80101cbf:	83 ec 0c             	sub    $0xc,%esp
80101cc2:	56                   	push   %esi
80101cc3:	e8 38 2a 00 00       	call   80104700 <holdingsleep>
80101cc8:	83 c4 10             	add    $0x10,%esp
80101ccb:	85 c0                	test   %eax,%eax
80101ccd:	74 15                	je     80101ce4 <iunlock+0x34>
80101ccf:	8b 43 08             	mov    0x8(%ebx),%eax
80101cd2:	85 c0                	test   %eax,%eax
80101cd4:	7e 0e                	jle    80101ce4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101cd6:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101cd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101cdc:	5b                   	pop    %ebx
80101cdd:	5e                   	pop    %esi
80101cde:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101cdf:	e9 dc 29 00 00       	jmp    801046c0 <releasesleep>
    panic("iunlock");
80101ce4:	83 ec 0c             	sub    $0xc,%esp
80101ce7:	68 3f 75 10 80       	push   $0x8010753f
80101cec:	e8 0f e8 ff ff       	call   80100500 <panic>
80101cf1:	eb 0d                	jmp    80101d00 <iput>
80101cf3:	90                   	nop
80101cf4:	90                   	nop
80101cf5:	90                   	nop
80101cf6:	90                   	nop
80101cf7:	90                   	nop
80101cf8:	90                   	nop
80101cf9:	90                   	nop
80101cfa:	90                   	nop
80101cfb:	90                   	nop
80101cfc:	90                   	nop
80101cfd:	90                   	nop
80101cfe:	90                   	nop
80101cff:	90                   	nop

80101d00 <iput>:
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	83 ec 28             	sub    $0x28,%esp
80101d09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101d0c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101d0f:	57                   	push   %edi
80101d10:	e8 4b 29 00 00       	call   80104660 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101d15:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101d18:	83 c4 10             	add    $0x10,%esp
80101d1b:	85 d2                	test   %edx,%edx
80101d1d:	74 07                	je     80101d26 <iput+0x26>
80101d1f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101d24:	74 32                	je     80101d58 <iput+0x58>
  releasesleep(&ip->lock);
80101d26:	83 ec 0c             	sub    $0xc,%esp
80101d29:	57                   	push   %edi
80101d2a:	e8 91 29 00 00       	call   801046c0 <releasesleep>
  acquire(&icache.lock);
80101d2f:	c7 04 24 00 12 11 80 	movl   $0x80111200,(%esp)
80101d36:	e8 55 2b 00 00       	call   80104890 <acquire>
  ip->ref--;
80101d3b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101d3f:	83 c4 10             	add    $0x10,%esp
80101d42:	c7 45 08 00 12 11 80 	movl   $0x80111200,0x8(%ebp)
}
80101d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d4c:	5b                   	pop    %ebx
80101d4d:	5e                   	pop    %esi
80101d4e:	5f                   	pop    %edi
80101d4f:	5d                   	pop    %ebp
  release(&icache.lock);
80101d50:	e9 fb 2b 00 00       	jmp    80104950 <release>
80101d55:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101d58:	83 ec 0c             	sub    $0xc,%esp
80101d5b:	68 00 12 11 80       	push   $0x80111200
80101d60:	e8 2b 2b 00 00       	call   80104890 <acquire>
    int r = ip->ref;
80101d65:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101d68:	c7 04 24 00 12 11 80 	movl   $0x80111200,(%esp)
80101d6f:	e8 dc 2b 00 00       	call   80104950 <release>
    if(r == 1){
80101d74:	83 c4 10             	add    $0x10,%esp
80101d77:	83 fe 01             	cmp    $0x1,%esi
80101d7a:	75 aa                	jne    80101d26 <iput+0x26>
80101d7c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101d82:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101d85:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101d88:	89 cf                	mov    %ecx,%edi
80101d8a:	eb 0b                	jmp    80101d97 <iput+0x97>
80101d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d90:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d93:	39 fe                	cmp    %edi,%esi
80101d95:	74 19                	je     80101db0 <iput+0xb0>
    if(ip->addrs[i]){
80101d97:	8b 16                	mov    (%esi),%edx
80101d99:	85 d2                	test   %edx,%edx
80101d9b:	74 f3                	je     80101d90 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101d9d:	8b 03                	mov    (%ebx),%eax
80101d9f:	e8 bc f8 ff ff       	call   80101660 <bfree>
      ip->addrs[i] = 0;
80101da4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101daa:	eb e4                	jmp    80101d90 <iput+0x90>
80101dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101db0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101db6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101db9:	85 c0                	test   %eax,%eax
80101dbb:	75 33                	jne    80101df0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101dbd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101dc0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101dc7:	53                   	push   %ebx
80101dc8:	e8 53 fd ff ff       	call   80101b20 <iupdate>
      ip->type = 0;
80101dcd:	31 c0                	xor    %eax,%eax
80101dcf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101dd3:	89 1c 24             	mov    %ebx,(%esp)
80101dd6:	e8 45 fd ff ff       	call   80101b20 <iupdate>
      ip->valid = 0;
80101ddb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101de2:	83 c4 10             	add    $0x10,%esp
80101de5:	e9 3c ff ff ff       	jmp    80101d26 <iput+0x26>
80101dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101df0:	83 ec 08             	sub    $0x8,%esp
80101df3:	50                   	push   %eax
80101df4:	ff 33                	pushl  (%ebx)
80101df6:	e8 d5 e2 ff ff       	call   801000d0 <bread>
80101dfb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101e01:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101e04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101e07:	8d 70 5c             	lea    0x5c(%eax),%esi
80101e0a:	83 c4 10             	add    $0x10,%esp
80101e0d:	89 cf                	mov    %ecx,%edi
80101e0f:	eb 0e                	jmp    80101e1f <iput+0x11f>
80101e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e18:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101e1b:	39 fe                	cmp    %edi,%esi
80101e1d:	74 0f                	je     80101e2e <iput+0x12e>
      if(a[j])
80101e1f:	8b 16                	mov    (%esi),%edx
80101e21:	85 d2                	test   %edx,%edx
80101e23:	74 f3                	je     80101e18 <iput+0x118>
        bfree(ip->dev, a[j]);
80101e25:	8b 03                	mov    (%ebx),%eax
80101e27:	e8 34 f8 ff ff       	call   80101660 <bfree>
80101e2c:	eb ea                	jmp    80101e18 <iput+0x118>
    brelse(bp);
80101e2e:	83 ec 0c             	sub    $0xc,%esp
80101e31:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e34:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e37:	e8 a4 e3 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e3c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101e42:	8b 03                	mov    (%ebx),%eax
80101e44:	e8 17 f8 ff ff       	call   80101660 <bfree>
    ip->addrs[NDIRECT] = 0;
80101e49:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101e50:	00 00 00 
80101e53:	83 c4 10             	add    $0x10,%esp
80101e56:	e9 62 ff ff ff       	jmp    80101dbd <iput+0xbd>
80101e5b:	90                   	nop
80101e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e60 <iunlockput>:
{
80101e60:	55                   	push   %ebp
80101e61:	89 e5                	mov    %esp,%ebp
80101e63:	53                   	push   %ebx
80101e64:	83 ec 10             	sub    $0x10,%esp
80101e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101e6a:	53                   	push   %ebx
80101e6b:	e8 40 fe ff ff       	call   80101cb0 <iunlock>
  iput(ip);
80101e70:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101e73:	83 c4 10             	add    $0x10,%esp
}
80101e76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e79:	c9                   	leave  
  iput(ip);
80101e7a:	e9 81 fe ff ff       	jmp    80101d00 <iput>
80101e7f:	90                   	nop

80101e80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	8b 55 08             	mov    0x8(%ebp),%edx
80101e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101e89:	8b 0a                	mov    (%edx),%ecx
80101e8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101e8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101e91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101e94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101e98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101e9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101e9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ea3:	8b 52 58             	mov    0x58(%edx),%edx
80101ea6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ea9:	5d                   	pop    %ebp
80101eaa:	c3                   	ret    
80101eab:	90                   	nop
80101eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101eb0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101eb0:	55                   	push   %ebp
80101eb1:	89 e5                	mov    %esp,%ebp
80101eb3:	57                   	push   %edi
80101eb4:	56                   	push   %esi
80101eb5:	53                   	push   %ebx
80101eb6:	83 ec 1c             	sub    $0x1c,%esp
80101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101ebf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ec2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ec7:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101eca:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ecd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ed0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ed3:	0f 84 a7 00 00 00    	je     80101f80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ed9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101edc:	8b 40 58             	mov    0x58(%eax),%eax
80101edf:	39 c6                	cmp    %eax,%esi
80101ee1:	0f 87 ba 00 00 00    	ja     80101fa1 <readi+0xf1>
80101ee7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101eea:	89 f9                	mov    %edi,%ecx
80101eec:	01 f1                	add    %esi,%ecx
80101eee:	0f 82 ad 00 00 00    	jb     80101fa1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101ef4:	89 c2                	mov    %eax,%edx
80101ef6:	29 f2                	sub    %esi,%edx
80101ef8:	39 c8                	cmp    %ecx,%eax
80101efa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101efd:	31 ff                	xor    %edi,%edi
80101eff:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101f01:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f04:	74 6c                	je     80101f72 <readi+0xc2>
80101f06:	8d 76 00             	lea    0x0(%esi),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101f13:	89 f2                	mov    %esi,%edx
80101f15:	c1 ea 09             	shr    $0x9,%edx
80101f18:	89 d8                	mov    %ebx,%eax
80101f1a:	e8 91 f9 ff ff       	call   801018b0 <bmap>
80101f1f:	83 ec 08             	sub    $0x8,%esp
80101f22:	50                   	push   %eax
80101f23:	ff 33                	pushl  (%ebx)
80101f25:	e8 a6 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101f2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f2d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101f2f:	89 f0                	mov    %esi,%eax
80101f31:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f36:	b9 00 02 00 00       	mov    $0x200,%ecx
80101f3b:	83 c4 0c             	add    $0xc,%esp
80101f3e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101f40:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101f44:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f47:	29 fb                	sub    %edi,%ebx
80101f49:	39 d9                	cmp    %ebx,%ecx
80101f4b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101f4e:	53                   	push   %ebx
80101f4f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f50:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101f52:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f55:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101f57:	e8 f4 2a 00 00       	call   80104a50 <memmove>
    brelse(bp);
80101f5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101f5f:	89 14 24             	mov    %edx,(%esp)
80101f62:	e8 79 e2 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101f6a:	83 c4 10             	add    $0x10,%esp
80101f6d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101f70:	77 9e                	ja     80101f10 <readi+0x60>
  }
  return n;
80101f72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101f75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f78:	5b                   	pop    %ebx
80101f79:	5e                   	pop    %esi
80101f7a:	5f                   	pop    %edi
80101f7b:	5d                   	pop    %ebp
80101f7c:	c3                   	ret    
80101f7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101f84:	66 83 f8 09          	cmp    $0x9,%ax
80101f88:	77 17                	ja     80101fa1 <readi+0xf1>
80101f8a:	8b 04 c5 80 11 11 80 	mov    -0x7feeee80(,%eax,8),%eax
80101f91:	85 c0                	test   %eax,%eax
80101f93:	74 0c                	je     80101fa1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101f95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101f98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f9b:	5b                   	pop    %ebx
80101f9c:	5e                   	pop    %esi
80101f9d:	5f                   	pop    %edi
80101f9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101f9f:	ff e0                	jmp    *%eax
      return -1;
80101fa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fa6:	eb cd                	jmp    80101f75 <readi+0xc5>
80101fa8:	90                   	nop
80101fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101fb0:	55                   	push   %ebp
80101fb1:	89 e5                	mov    %esp,%ebp
80101fb3:	57                   	push   %edi
80101fb4:	56                   	push   %esi
80101fb5:	53                   	push   %ebx
80101fb6:	83 ec 1c             	sub    $0x1c,%esp
80101fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101fbf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101fc7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101fca:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101fcd:	8b 75 10             	mov    0x10(%ebp),%esi
80101fd0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101fd3:	0f 84 b7 00 00 00    	je     80102090 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101fd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101fdc:	39 70 58             	cmp    %esi,0x58(%eax)
80101fdf:	0f 82 eb 00 00 00    	jb     801020d0 <writei+0x120>
80101fe5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101fe8:	31 d2                	xor    %edx,%edx
80101fea:	89 f8                	mov    %edi,%eax
80101fec:	01 f0                	add    %esi,%eax
80101fee:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ff1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ff6:	0f 87 d4 00 00 00    	ja     801020d0 <writei+0x120>
80101ffc:	85 d2                	test   %edx,%edx
80101ffe:	0f 85 cc 00 00 00    	jne    801020d0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102004:	85 ff                	test   %edi,%edi
80102006:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010200d:	74 72                	je     80102081 <writei+0xd1>
8010200f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102010:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102013:	89 f2                	mov    %esi,%edx
80102015:	c1 ea 09             	shr    $0x9,%edx
80102018:	89 f8                	mov    %edi,%eax
8010201a:	e8 91 f8 ff ff       	call   801018b0 <bmap>
8010201f:	83 ec 08             	sub    $0x8,%esp
80102022:	50                   	push   %eax
80102023:	ff 37                	pushl  (%edi)
80102025:	e8 a6 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010202a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010202d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102030:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102032:	89 f0                	mov    %esi,%eax
80102034:	b9 00 02 00 00       	mov    $0x200,%ecx
80102039:	83 c4 0c             	add    $0xc,%esp
8010203c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102041:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102043:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102047:	39 d9                	cmp    %ebx,%ecx
80102049:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010204c:	53                   	push   %ebx
8010204d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102050:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80102052:	50                   	push   %eax
80102053:	e8 f8 29 00 00       	call   80104a50 <memmove>
    log_write(bp);
80102058:	89 3c 24             	mov    %edi,(%esp)
8010205b:	e8 60 12 00 00       	call   801032c0 <log_write>
    brelse(bp);
80102060:	89 3c 24             	mov    %edi,(%esp)
80102063:	e8 78 e1 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102068:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010206b:	01 5d dc             	add    %ebx,-0x24(%ebp)
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102074:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102077:	77 97                	ja     80102010 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102079:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010207c:	3b 70 58             	cmp    0x58(%eax),%esi
8010207f:	77 37                	ja     801020b8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102081:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102084:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102087:	5b                   	pop    %ebx
80102088:	5e                   	pop    %esi
80102089:	5f                   	pop    %edi
8010208a:	5d                   	pop    %ebp
8010208b:	c3                   	ret    
8010208c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102090:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102094:	66 83 f8 09          	cmp    $0x9,%ax
80102098:	77 36                	ja     801020d0 <writei+0x120>
8010209a:	8b 04 c5 84 11 11 80 	mov    -0x7feeee7c(,%eax,8),%eax
801020a1:	85 c0                	test   %eax,%eax
801020a3:	74 2b                	je     801020d0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
801020a5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801020a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020ab:	5b                   	pop    %ebx
801020ac:	5e                   	pop    %esi
801020ad:	5f                   	pop    %edi
801020ae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801020af:	ff e0                	jmp    *%eax
801020b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
801020b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
801020bb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801020be:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801020c1:	50                   	push   %eax
801020c2:	e8 59 fa ff ff       	call   80101b20 <iupdate>
801020c7:	83 c4 10             	add    $0x10,%esp
801020ca:	eb b5                	jmp    80102081 <writei+0xd1>
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
801020d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d5:	eb ad                	jmp    80102084 <writei+0xd4>
801020d7:	89 f6                	mov    %esi,%esi
801020d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020e0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801020e6:	6a 0e                	push   $0xe
801020e8:	ff 75 0c             	pushl  0xc(%ebp)
801020eb:	ff 75 08             	pushl  0x8(%ebp)
801020ee:	e8 cd 29 00 00       	call   80104ac0 <strncmp>
}
801020f3:	c9                   	leave  
801020f4:	c3                   	ret    
801020f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102100 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	57                   	push   %edi
80102104:	56                   	push   %esi
80102105:	53                   	push   %ebx
80102106:	83 ec 1c             	sub    $0x1c,%esp
80102109:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010210c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102111:	0f 85 85 00 00 00    	jne    8010219c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102117:	8b 53 58             	mov    0x58(%ebx),%edx
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010211f:	85 d2                	test   %edx,%edx
80102121:	74 3e                	je     80102161 <dirlookup+0x61>
80102123:	90                   	nop
80102124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102128:	6a 10                	push   $0x10
8010212a:	57                   	push   %edi
8010212b:	56                   	push   %esi
8010212c:	53                   	push   %ebx
8010212d:	e8 7e fd ff ff       	call   80101eb0 <readi>
80102132:	83 c4 10             	add    $0x10,%esp
80102135:	83 f8 10             	cmp    $0x10,%eax
80102138:	75 55                	jne    8010218f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010213a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010213f:	74 18                	je     80102159 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102141:	8d 45 da             	lea    -0x26(%ebp),%eax
80102144:	83 ec 04             	sub    $0x4,%esp
80102147:	6a 0e                	push   $0xe
80102149:	50                   	push   %eax
8010214a:	ff 75 0c             	pushl  0xc(%ebp)
8010214d:	e8 6e 29 00 00       	call   80104ac0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102152:	83 c4 10             	add    $0x10,%esp
80102155:	85 c0                	test   %eax,%eax
80102157:	74 17                	je     80102170 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102159:	83 c7 10             	add    $0x10,%edi
8010215c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010215f:	72 c7                	jb     80102128 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102161:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102164:	31 c0                	xor    %eax,%eax
}
80102166:	5b                   	pop    %ebx
80102167:	5e                   	pop    %esi
80102168:	5f                   	pop    %edi
80102169:	5d                   	pop    %ebp
8010216a:	c3                   	ret    
8010216b:	90                   	nop
8010216c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80102170:	8b 45 10             	mov    0x10(%ebp),%eax
80102173:	85 c0                	test   %eax,%eax
80102175:	74 05                	je     8010217c <dirlookup+0x7c>
        *poff = off;
80102177:	8b 45 10             	mov    0x10(%ebp),%eax
8010217a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010217c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102180:	8b 03                	mov    (%ebx),%eax
80102182:	e8 59 f6 ff ff       	call   801017e0 <iget>
}
80102187:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010218a:	5b                   	pop    %ebx
8010218b:	5e                   	pop    %esi
8010218c:	5f                   	pop    %edi
8010218d:	5d                   	pop    %ebp
8010218e:	c3                   	ret    
      panic("dirlookup read");
8010218f:	83 ec 0c             	sub    $0xc,%esp
80102192:	68 59 75 10 80       	push   $0x80107559
80102197:	e8 64 e3 ff ff       	call   80100500 <panic>
    panic("dirlookup not DIR");
8010219c:	83 ec 0c             	sub    $0xc,%esp
8010219f:	68 47 75 10 80       	push   $0x80107547
801021a4:	e8 57 e3 ff ff       	call   80100500 <panic>
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021b0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801021b0:	55                   	push   %ebp
801021b1:	89 e5                	mov    %esp,%ebp
801021b3:	57                   	push   %edi
801021b4:	56                   	push   %esi
801021b5:	53                   	push   %ebx
801021b6:	89 cf                	mov    %ecx,%edi
801021b8:	89 c3                	mov    %eax,%ebx
801021ba:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801021bd:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801021c0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
801021c3:	0f 84 67 01 00 00    	je     80102330 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801021c9:	e8 62 1b 00 00       	call   80103d30 <myproc>
  acquire(&icache.lock);
801021ce:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801021d1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801021d4:	68 00 12 11 80       	push   $0x80111200
801021d9:	e8 b2 26 00 00       	call   80104890 <acquire>
  ip->ref++;
801021de:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801021e2:	c7 04 24 00 12 11 80 	movl   $0x80111200,(%esp)
801021e9:	e8 62 27 00 00       	call   80104950 <release>
801021ee:	83 c4 10             	add    $0x10,%esp
801021f1:	eb 08                	jmp    801021fb <namex+0x4b>
801021f3:	90                   	nop
801021f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801021f8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801021fb:	0f b6 03             	movzbl (%ebx),%eax
801021fe:	3c 2f                	cmp    $0x2f,%al
80102200:	74 f6                	je     801021f8 <namex+0x48>
  if(*path == 0)
80102202:	84 c0                	test   %al,%al
80102204:	0f 84 ee 00 00 00    	je     801022f8 <namex+0x148>
  while(*path != '/' && *path != 0)
8010220a:	0f b6 03             	movzbl (%ebx),%eax
8010220d:	3c 2f                	cmp    $0x2f,%al
8010220f:	0f 84 b3 00 00 00    	je     801022c8 <namex+0x118>
80102215:	84 c0                	test   %al,%al
80102217:	89 da                	mov    %ebx,%edx
80102219:	75 09                	jne    80102224 <namex+0x74>
8010221b:	e9 a8 00 00 00       	jmp    801022c8 <namex+0x118>
80102220:	84 c0                	test   %al,%al
80102222:	74 0a                	je     8010222e <namex+0x7e>
    path++;
80102224:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80102227:	0f b6 02             	movzbl (%edx),%eax
8010222a:	3c 2f                	cmp    $0x2f,%al
8010222c:	75 f2                	jne    80102220 <namex+0x70>
8010222e:	89 d1                	mov    %edx,%ecx
80102230:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80102232:	83 f9 0d             	cmp    $0xd,%ecx
80102235:	0f 8e 91 00 00 00    	jle    801022cc <namex+0x11c>
    memmove(name, s, DIRSIZ);
8010223b:	83 ec 04             	sub    $0x4,%esp
8010223e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102241:	6a 0e                	push   $0xe
80102243:	53                   	push   %ebx
80102244:	57                   	push   %edi
80102245:	e8 06 28 00 00       	call   80104a50 <memmove>
    path++;
8010224a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
8010224d:	83 c4 10             	add    $0x10,%esp
    path++;
80102250:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80102252:	80 3a 2f             	cmpb   $0x2f,(%edx)
80102255:	75 11                	jne    80102268 <namex+0xb8>
80102257:	89 f6                	mov    %esi,%esi
80102259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80102260:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80102263:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102266:	74 f8                	je     80102260 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102268:	83 ec 0c             	sub    $0xc,%esp
8010226b:	56                   	push   %esi
8010226c:	e8 5f f9 ff ff       	call   80101bd0 <ilock>
    if(ip->type != T_DIR){
80102271:	83 c4 10             	add    $0x10,%esp
80102274:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102279:	0f 85 91 00 00 00    	jne    80102310 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
8010227f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102282:	85 d2                	test   %edx,%edx
80102284:	74 09                	je     8010228f <namex+0xdf>
80102286:	80 3b 00             	cmpb   $0x0,(%ebx)
80102289:	0f 84 b7 00 00 00    	je     80102346 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010228f:	83 ec 04             	sub    $0x4,%esp
80102292:	6a 00                	push   $0x0
80102294:	57                   	push   %edi
80102295:	56                   	push   %esi
80102296:	e8 65 fe ff ff       	call   80102100 <dirlookup>
8010229b:	83 c4 10             	add    $0x10,%esp
8010229e:	85 c0                	test   %eax,%eax
801022a0:	74 6e                	je     80102310 <namex+0x160>
  iunlock(ip);
801022a2:	83 ec 0c             	sub    $0xc,%esp
801022a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801022a8:	56                   	push   %esi
801022a9:	e8 02 fa ff ff       	call   80101cb0 <iunlock>
  iput(ip);
801022ae:	89 34 24             	mov    %esi,(%esp)
801022b1:	e8 4a fa ff ff       	call   80101d00 <iput>
801022b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801022b9:	83 c4 10             	add    $0x10,%esp
801022bc:	89 c6                	mov    %eax,%esi
801022be:	e9 38 ff ff ff       	jmp    801021fb <namex+0x4b>
801022c3:	90                   	nop
801022c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
801022c8:	89 da                	mov    %ebx,%edx
801022ca:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
801022cc:	83 ec 04             	sub    $0x4,%esp
801022cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
801022d2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801022d5:	51                   	push   %ecx
801022d6:	53                   	push   %ebx
801022d7:	57                   	push   %edi
801022d8:	e8 73 27 00 00       	call   80104a50 <memmove>
    name[len] = 0;
801022dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801022e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
801022ea:	89 d3                	mov    %edx,%ebx
801022ec:	e9 61 ff ff ff       	jmp    80102252 <namex+0xa2>
801022f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801022f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801022fb:	85 c0                	test   %eax,%eax
801022fd:	75 5d                	jne    8010235c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
801022ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102302:	89 f0                	mov    %esi,%eax
80102304:	5b                   	pop    %ebx
80102305:	5e                   	pop    %esi
80102306:	5f                   	pop    %edi
80102307:	5d                   	pop    %ebp
80102308:	c3                   	ret    
80102309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	56                   	push   %esi
80102314:	e8 97 f9 ff ff       	call   80101cb0 <iunlock>
  iput(ip);
80102319:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010231c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010231e:	e8 dd f9 ff ff       	call   80101d00 <iput>
      return 0;
80102323:	83 c4 10             	add    $0x10,%esp
}
80102326:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102329:	89 f0                	mov    %esi,%eax
8010232b:	5b                   	pop    %ebx
8010232c:	5e                   	pop    %esi
8010232d:	5f                   	pop    %edi
8010232e:	5d                   	pop    %ebp
8010232f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102330:	ba 01 00 00 00       	mov    $0x1,%edx
80102335:	b8 01 00 00 00       	mov    $0x1,%eax
8010233a:	e8 a1 f4 ff ff       	call   801017e0 <iget>
8010233f:	89 c6                	mov    %eax,%esi
80102341:	e9 b5 fe ff ff       	jmp    801021fb <namex+0x4b>
      iunlock(ip);
80102346:	83 ec 0c             	sub    $0xc,%esp
80102349:	56                   	push   %esi
8010234a:	e8 61 f9 ff ff       	call   80101cb0 <iunlock>
      return ip;
8010234f:	83 c4 10             	add    $0x10,%esp
}
80102352:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102355:	89 f0                	mov    %esi,%eax
80102357:	5b                   	pop    %ebx
80102358:	5e                   	pop    %esi
80102359:	5f                   	pop    %edi
8010235a:	5d                   	pop    %ebp
8010235b:	c3                   	ret    
    iput(ip);
8010235c:	83 ec 0c             	sub    $0xc,%esp
8010235f:	56                   	push   %esi
    return 0;
80102360:	31 f6                	xor    %esi,%esi
    iput(ip);
80102362:	e8 99 f9 ff ff       	call   80101d00 <iput>
    return 0;
80102367:	83 c4 10             	add    $0x10,%esp
8010236a:	eb 93                	jmp    801022ff <namex+0x14f>
8010236c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102370 <dirlink>:
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	57                   	push   %edi
80102374:	56                   	push   %esi
80102375:	53                   	push   %ebx
80102376:	83 ec 20             	sub    $0x20,%esp
80102379:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010237c:	6a 00                	push   $0x0
8010237e:	ff 75 0c             	pushl  0xc(%ebp)
80102381:	53                   	push   %ebx
80102382:	e8 79 fd ff ff       	call   80102100 <dirlookup>
80102387:	83 c4 10             	add    $0x10,%esp
8010238a:	85 c0                	test   %eax,%eax
8010238c:	75 67                	jne    801023f5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010238e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102391:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102394:	85 ff                	test   %edi,%edi
80102396:	74 29                	je     801023c1 <dirlink+0x51>
80102398:	31 ff                	xor    %edi,%edi
8010239a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010239d:	eb 09                	jmp    801023a8 <dirlink+0x38>
8010239f:	90                   	nop
801023a0:	83 c7 10             	add    $0x10,%edi
801023a3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801023a6:	73 19                	jae    801023c1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023a8:	6a 10                	push   $0x10
801023aa:	57                   	push   %edi
801023ab:	56                   	push   %esi
801023ac:	53                   	push   %ebx
801023ad:	e8 fe fa ff ff       	call   80101eb0 <readi>
801023b2:	83 c4 10             	add    $0x10,%esp
801023b5:	83 f8 10             	cmp    $0x10,%eax
801023b8:	75 4e                	jne    80102408 <dirlink+0x98>
    if(de.inum == 0)
801023ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801023bf:	75 df                	jne    801023a0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801023c1:	8d 45 da             	lea    -0x26(%ebp),%eax
801023c4:	83 ec 04             	sub    $0x4,%esp
801023c7:	6a 0e                	push   $0xe
801023c9:	ff 75 0c             	pushl  0xc(%ebp)
801023cc:	50                   	push   %eax
801023cd:	e8 4e 27 00 00       	call   80104b20 <strncpy>
  de.inum = inum;
801023d2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023d5:	6a 10                	push   $0x10
801023d7:	57                   	push   %edi
801023d8:	56                   	push   %esi
801023d9:	53                   	push   %ebx
  de.inum = inum;
801023da:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023de:	e8 cd fb ff ff       	call   80101fb0 <writei>
801023e3:	83 c4 20             	add    $0x20,%esp
801023e6:	83 f8 10             	cmp    $0x10,%eax
801023e9:	75 2a                	jne    80102415 <dirlink+0xa5>
  return 0;
801023eb:	31 c0                	xor    %eax,%eax
}
801023ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023f0:	5b                   	pop    %ebx
801023f1:	5e                   	pop    %esi
801023f2:	5f                   	pop    %edi
801023f3:	5d                   	pop    %ebp
801023f4:	c3                   	ret    
    iput(ip);
801023f5:	83 ec 0c             	sub    $0xc,%esp
801023f8:	50                   	push   %eax
801023f9:	e8 02 f9 ff ff       	call   80101d00 <iput>
    return -1;
801023fe:	83 c4 10             	add    $0x10,%esp
80102401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102406:	eb e5                	jmp    801023ed <dirlink+0x7d>
      panic("dirlink read");
80102408:	83 ec 0c             	sub    $0xc,%esp
8010240b:	68 68 75 10 80       	push   $0x80107568
80102410:	e8 eb e0 ff ff       	call   80100500 <panic>
    panic("dirlink");
80102415:	83 ec 0c             	sub    $0xc,%esp
80102418:	68 5e 7b 10 80       	push   $0x80107b5e
8010241d:	e8 de e0 ff ff       	call   80100500 <panic>
80102422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102430 <namei>:

struct inode*
namei(char *path)
{
80102430:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102431:	31 d2                	xor    %edx,%edx
{
80102433:	89 e5                	mov    %esp,%ebp
80102435:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102438:	8b 45 08             	mov    0x8(%ebp),%eax
8010243b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010243e:	e8 6d fd ff ff       	call   801021b0 <namex>
}
80102443:	c9                   	leave  
80102444:	c3                   	ret    
80102445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102450:	55                   	push   %ebp
  return namex(path, 1, name);
80102451:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102456:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102458:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010245b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010245e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010245f:	e9 4c fd ff ff       	jmp    801021b0 <namex>
80102464:	66 90                	xchg   %ax,%ax
80102466:	66 90                	xchg   %ax,%ax
80102468:	66 90                	xchg   %ax,%ax
8010246a:	66 90                	xchg   %ax,%ax
8010246c:	66 90                	xchg   %ax,%ax
8010246e:	66 90                	xchg   %ax,%ax

80102470 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	57                   	push   %edi
80102474:	56                   	push   %esi
80102475:	53                   	push   %ebx
80102476:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102479:	85 c0                	test   %eax,%eax
8010247b:	0f 84 b4 00 00 00    	je     80102535 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102481:	8b 58 08             	mov    0x8(%eax),%ebx
80102484:	89 c6                	mov    %eax,%esi
80102486:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010248c:	0f 87 96 00 00 00    	ja     80102528 <idestart+0xb8>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102492:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102497:	89 f6                	mov    %esi,%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801024a0:	89 ca                	mov    %ecx,%edx
801024a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024a3:	83 e0 c0             	and    $0xffffffc0,%eax
801024a6:	3c 40                	cmp    $0x40,%al
801024a8:	75 f6                	jne    801024a0 <idestart+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024aa:	31 ff                	xor    %edi,%edi
801024ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801024b1:	89 f8                	mov    %edi,%eax
801024b3:	ee                   	out    %al,(%dx)
801024b4:	b8 01 00 00 00       	mov    $0x1,%eax
801024b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801024be:	ee                   	out    %al,(%dx)
801024bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801024c4:	89 d8                	mov    %ebx,%eax
801024c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801024c7:	89 d8                	mov    %ebx,%eax
801024c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801024ce:	c1 f8 08             	sar    $0x8,%eax
801024d1:	ee                   	out    %al,(%dx)
801024d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801024d7:	89 f8                	mov    %edi,%eax
801024d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801024da:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801024de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024e3:	c1 e0 04             	shl    $0x4,%eax
801024e6:	83 e0 10             	and    $0x10,%eax
801024e9:	83 c8 e0             	or     $0xffffffe0,%eax
801024ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801024ed:	f6 06 04             	testb  $0x4,(%esi)
801024f0:	75 16                	jne    80102508 <idestart+0x98>
801024f2:	b8 20 00 00 00       	mov    $0x20,%eax
801024f7:	89 ca                	mov    %ecx,%edx
801024f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801024fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024fd:	5b                   	pop    %ebx
801024fe:	5e                   	pop    %esi
801024ff:	5f                   	pop    %edi
80102500:	5d                   	pop    %ebp
80102501:	c3                   	ret    
80102502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102508:	b8 30 00 00 00       	mov    $0x30,%eax
8010250d:	89 ca                	mov    %ecx,%edx
8010250f:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102510:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102515:	83 c6 5c             	add    $0x5c,%esi
80102518:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010251d:	fc                   	cld    
8010251e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102520:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102523:	5b                   	pop    %ebx
80102524:	5e                   	pop    %esi
80102525:	5f                   	pop    %edi
80102526:	5d                   	pop    %ebp
80102527:	c3                   	ret    
    panic("incorrect blockno");
80102528:	83 ec 0c             	sub    $0xc,%esp
8010252b:	68 d4 75 10 80       	push   $0x801075d4
80102530:	e8 cb df ff ff       	call   80100500 <panic>
    panic("idestart");
80102535:	83 ec 0c             	sub    $0xc,%esp
80102538:	68 cb 75 10 80       	push   $0x801075cb
8010253d:	e8 be df ff ff       	call   80100500 <panic>
80102542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102550 <ideinit>:
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102556:	68 e6 75 10 80       	push   $0x801075e6
8010255b:	68 a0 a5 10 80       	push   $0x8010a5a0
80102560:	e8 eb 21 00 00       	call   80104750 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102565:	58                   	pop    %eax
80102566:	a1 20 35 11 80       	mov    0x80113520,%eax
8010256b:	5a                   	pop    %edx
8010256c:	83 e8 01             	sub    $0x1,%eax
8010256f:	50                   	push   %eax
80102570:	6a 0e                	push   $0xe
80102572:	e8 a9 02 00 00       	call   80102820 <ioapicenable>
80102577:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010257a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010257f:	90                   	nop
80102580:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102581:	83 e0 c0             	and    $0xffffffc0,%eax
80102584:	3c 40                	cmp    $0x40,%al
80102586:	75 f8                	jne    80102580 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102588:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010258d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102592:	ee                   	out    %al,(%dx)
80102593:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102598:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010259d:	eb 06                	jmp    801025a5 <ideinit+0x55>
8010259f:	90                   	nop
  for(i=0; i<1000; i++){
801025a0:	83 e9 01             	sub    $0x1,%ecx
801025a3:	74 0f                	je     801025b4 <ideinit+0x64>
801025a5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801025a6:	84 c0                	test   %al,%al
801025a8:	74 f6                	je     801025a0 <ideinit+0x50>
      havedisk1 = 1;
801025aa:	c7 05 80 a5 10 80 01 	movl   $0x1,0x8010a580
801025b1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025b4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801025b9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025be:	ee                   	out    %al,(%dx)
}
801025bf:	c9                   	leave  
801025c0:	c3                   	ret    
801025c1:	eb 0d                	jmp    801025d0 <ideintr>
801025c3:	90                   	nop
801025c4:	90                   	nop
801025c5:	90                   	nop
801025c6:	90                   	nop
801025c7:	90                   	nop
801025c8:	90                   	nop
801025c9:	90                   	nop
801025ca:	90                   	nop
801025cb:	90                   	nop
801025cc:	90                   	nop
801025cd:	90                   	nop
801025ce:	90                   	nop
801025cf:	90                   	nop

801025d0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	57                   	push   %edi
801025d4:	56                   	push   %esi
801025d5:	53                   	push   %ebx
801025d6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801025d9:	68 a0 a5 10 80       	push   $0x8010a5a0
801025de:	e8 ad 22 00 00       	call   80104890 <acquire>

  if((b = idequeue) == 0){
801025e3:	8b 1d 84 a5 10 80    	mov    0x8010a584,%ebx
801025e9:	83 c4 10             	add    $0x10,%esp
801025ec:	85 db                	test   %ebx,%ebx
801025ee:	74 67                	je     80102657 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801025f0:	8b 43 58             	mov    0x58(%ebx),%eax
801025f3:	a3 84 a5 10 80       	mov    %eax,0x8010a584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801025f8:	8b 3b                	mov    (%ebx),%edi
801025fa:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102600:	75 31                	jne    80102633 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102602:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102607:	89 f6                	mov    %esi,%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102610:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102611:	89 c6                	mov    %eax,%esi
80102613:	83 e6 c0             	and    $0xffffffc0,%esi
80102616:	89 f1                	mov    %esi,%ecx
80102618:	80 f9 40             	cmp    $0x40,%cl
8010261b:	75 f3                	jne    80102610 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010261d:	a8 21                	test   $0x21,%al
8010261f:	75 12                	jne    80102633 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102621:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102624:	b9 80 00 00 00       	mov    $0x80,%ecx
80102629:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010262e:	fc                   	cld    
8010262f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102631:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102633:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102636:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102639:	89 f9                	mov    %edi,%ecx
8010263b:	83 c9 02             	or     $0x2,%ecx
8010263e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102640:	53                   	push   %ebx
80102641:	e8 3a 1e 00 00       	call   80104480 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102646:	a1 84 a5 10 80       	mov    0x8010a584,%eax
8010264b:	83 c4 10             	add    $0x10,%esp
8010264e:	85 c0                	test   %eax,%eax
80102650:	74 05                	je     80102657 <ideintr+0x87>
    idestart(idequeue);
80102652:	e8 19 fe ff ff       	call   80102470 <idestart>
    release(&idelock);
80102657:	83 ec 0c             	sub    $0xc,%esp
8010265a:	68 a0 a5 10 80       	push   $0x8010a5a0
8010265f:	e8 ec 22 00 00       	call   80104950 <release>

  release(&idelock);
}
80102664:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102667:	5b                   	pop    %ebx
80102668:	5e                   	pop    %esi
80102669:	5f                   	pop    %edi
8010266a:	5d                   	pop    %ebp
8010266b:	c3                   	ret    
8010266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102670 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	53                   	push   %ebx
80102674:	83 ec 10             	sub    $0x10,%esp
80102677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010267a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010267d:	50                   	push   %eax
8010267e:	e8 7d 20 00 00       	call   80104700 <holdingsleep>
80102683:	83 c4 10             	add    $0x10,%esp
80102686:	85 c0                	test   %eax,%eax
80102688:	0f 84 c6 00 00 00    	je     80102754 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010268e:	8b 03                	mov    (%ebx),%eax
80102690:	83 e0 06             	and    $0x6,%eax
80102693:	83 f8 02             	cmp    $0x2,%eax
80102696:	0f 84 ab 00 00 00    	je     80102747 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010269c:	8b 53 04             	mov    0x4(%ebx),%edx
8010269f:	85 d2                	test   %edx,%edx
801026a1:	74 0d                	je     801026b0 <iderw+0x40>
801026a3:	a1 80 a5 10 80       	mov    0x8010a580,%eax
801026a8:	85 c0                	test   %eax,%eax
801026aa:	0f 84 b1 00 00 00    	je     80102761 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801026b0:	83 ec 0c             	sub    $0xc,%esp
801026b3:	68 a0 a5 10 80       	push   $0x8010a5a0
801026b8:	e8 d3 21 00 00       	call   80104890 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026bd:	8b 15 84 a5 10 80    	mov    0x8010a584,%edx
801026c3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801026c6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026cd:	85 d2                	test   %edx,%edx
801026cf:	75 09                	jne    801026da <iderw+0x6a>
801026d1:	eb 6d                	jmp    80102740 <iderw+0xd0>
801026d3:	90                   	nop
801026d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026d8:	89 c2                	mov    %eax,%edx
801026da:	8b 42 58             	mov    0x58(%edx),%eax
801026dd:	85 c0                	test   %eax,%eax
801026df:	75 f7                	jne    801026d8 <iderw+0x68>
801026e1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801026e4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801026e6:	39 1d 84 a5 10 80    	cmp    %ebx,0x8010a584
801026ec:	74 42                	je     80102730 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801026ee:	8b 03                	mov    (%ebx),%eax
801026f0:	83 e0 06             	and    $0x6,%eax
801026f3:	83 f8 02             	cmp    $0x2,%eax
801026f6:	74 23                	je     8010271b <iderw+0xab>
801026f8:	90                   	nop
801026f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102700:	83 ec 08             	sub    $0x8,%esp
80102703:	68 a0 a5 10 80       	push   $0x8010a5a0
80102708:	53                   	push   %ebx
80102709:	e8 c2 1b 00 00       	call   801042d0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010270e:	8b 03                	mov    (%ebx),%eax
80102710:	83 c4 10             	add    $0x10,%esp
80102713:	83 e0 06             	and    $0x6,%eax
80102716:	83 f8 02             	cmp    $0x2,%eax
80102719:	75 e5                	jne    80102700 <iderw+0x90>
  }


  release(&idelock);
8010271b:	c7 45 08 a0 a5 10 80 	movl   $0x8010a5a0,0x8(%ebp)
}
80102722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102725:	c9                   	leave  
  release(&idelock);
80102726:	e9 25 22 00 00       	jmp    80104950 <release>
8010272b:	90                   	nop
8010272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102730:	89 d8                	mov    %ebx,%eax
80102732:	e8 39 fd ff ff       	call   80102470 <idestart>
80102737:	eb b5                	jmp    801026ee <iderw+0x7e>
80102739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102740:	ba 84 a5 10 80       	mov    $0x8010a584,%edx
80102745:	eb 9d                	jmp    801026e4 <iderw+0x74>
    panic("iderw: nothing to do");
80102747:	83 ec 0c             	sub    $0xc,%esp
8010274a:	68 00 76 10 80       	push   $0x80107600
8010274f:	e8 ac dd ff ff       	call   80100500 <panic>
    panic("iderw: buf not locked");
80102754:	83 ec 0c             	sub    $0xc,%esp
80102757:	68 ea 75 10 80       	push   $0x801075ea
8010275c:	e8 9f dd ff ff       	call   80100500 <panic>
    panic("iderw: ide disk 1 not present");
80102761:	83 ec 0c             	sub    $0xc,%esp
80102764:	68 15 76 10 80       	push   $0x80107615
80102769:	e8 92 dd ff ff       	call   80100500 <panic>
8010276e:	66 90                	xchg   %ax,%ax

80102770 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102770:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102771:	c7 05 54 2e 11 80 00 	movl   $0xfec00000,0x80112e54
80102778:	00 c0 fe 
{
8010277b:	89 e5                	mov    %esp,%ebp
8010277d:	56                   	push   %esi
8010277e:	53                   	push   %ebx
  ioapic->reg = reg;
8010277f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102786:	00 00 00 
  return ioapic->data;
80102789:	a1 54 2e 11 80       	mov    0x80112e54,%eax
8010278e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102791:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102797:	8b 0d 54 2e 11 80    	mov    0x80112e54,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010279d:	0f b6 15 80 2f 11 80 	movzbl 0x80112f80,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801027a4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801027a7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801027aa:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801027ad:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801027b0:	39 c2                	cmp    %eax,%edx
801027b2:	74 16                	je     801027ca <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801027b4:	83 ec 0c             	sub    $0xc,%esp
801027b7:	68 34 76 10 80       	push   $0x80107634
801027bc:	e8 4f e0 ff ff       	call   80100810 <cprintf>
801027c1:	8b 0d 54 2e 11 80    	mov    0x80112e54,%ecx
801027c7:	83 c4 10             	add    $0x10,%esp
801027ca:	83 c3 21             	add    $0x21,%ebx
{
801027cd:	ba 10 00 00 00       	mov    $0x10,%edx
801027d2:	b8 20 00 00 00       	mov    $0x20,%eax
801027d7:	89 f6                	mov    %esi,%esi
801027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801027e0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801027e2:	8b 0d 54 2e 11 80    	mov    0x80112e54,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801027e8:	89 c6                	mov    %eax,%esi
801027ea:	81 ce 00 00 01 00    	or     $0x10000,%esi
801027f0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801027f3:	89 71 10             	mov    %esi,0x10(%ecx)
801027f6:	8d 72 01             	lea    0x1(%edx),%esi
801027f9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801027fc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801027fe:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102800:	8b 0d 54 2e 11 80    	mov    0x80112e54,%ecx
80102806:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010280d:	75 d1                	jne    801027e0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010280f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102812:	5b                   	pop    %ebx
80102813:	5e                   	pop    %esi
80102814:	5d                   	pop    %ebp
80102815:	c3                   	ret    
80102816:	8d 76 00             	lea    0x0(%esi),%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102820:	55                   	push   %ebp
  ioapic->reg = reg;
80102821:	8b 0d 54 2e 11 80    	mov    0x80112e54,%ecx
{
80102827:	89 e5                	mov    %esp,%ebp
80102829:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010282c:	8d 50 20             	lea    0x20(%eax),%edx
8010282f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102833:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102835:	8b 0d 54 2e 11 80    	mov    0x80112e54,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010283b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010283e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102841:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102844:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102846:	a1 54 2e 11 80       	mov    0x80112e54,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010284b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010284e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102851:	5d                   	pop    %ebp
80102852:	c3                   	ret    
80102853:	66 90                	xchg   %ax,%ax
80102855:	66 90                	xchg   %ax,%ax
80102857:	66 90                	xchg   %ax,%ax
80102859:	66 90                	xchg   %ax,%ax
8010285b:	66 90                	xchg   %ax,%ax
8010285d:	66 90                	xchg   %ax,%ax
8010285f:	90                   	nop

80102860 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	53                   	push   %ebx
80102864:	83 ec 04             	sub    $0x4,%esp
80102867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010286a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102870:	75 70                	jne    801028e2 <kfree+0x82>
80102872:	81 fb c8 5c 11 80    	cmp    $0x80115cc8,%ebx
80102878:	72 68                	jb     801028e2 <kfree+0x82>
8010287a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102880:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102885:	77 5b                	ja     801028e2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102887:	83 ec 04             	sub    $0x4,%esp
8010288a:	68 00 10 00 00       	push   $0x1000
8010288f:	6a 01                	push   $0x1
80102891:	53                   	push   %ebx
80102892:	e8 09 21 00 00       	call   801049a0 <memset>

  if(kmem.use_lock)
80102897:	8b 15 94 2e 11 80    	mov    0x80112e94,%edx
8010289d:	83 c4 10             	add    $0x10,%esp
801028a0:	85 d2                	test   %edx,%edx
801028a2:	75 2c                	jne    801028d0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801028a4:	a1 98 2e 11 80       	mov    0x80112e98,%eax
801028a9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801028ab:	a1 94 2e 11 80       	mov    0x80112e94,%eax
  kmem.freelist = r;
801028b0:	89 1d 98 2e 11 80    	mov    %ebx,0x80112e98
  if(kmem.use_lock)
801028b6:	85 c0                	test   %eax,%eax
801028b8:	75 06                	jne    801028c0 <kfree+0x60>
    release(&kmem.lock);
}
801028ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028bd:	c9                   	leave  
801028be:	c3                   	ret    
801028bf:	90                   	nop
    release(&kmem.lock);
801028c0:	c7 45 08 60 2e 11 80 	movl   $0x80112e60,0x8(%ebp)
}
801028c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028ca:	c9                   	leave  
    release(&kmem.lock);
801028cb:	e9 80 20 00 00       	jmp    80104950 <release>
    acquire(&kmem.lock);
801028d0:	83 ec 0c             	sub    $0xc,%esp
801028d3:	68 60 2e 11 80       	push   $0x80112e60
801028d8:	e8 b3 1f 00 00       	call   80104890 <acquire>
801028dd:	83 c4 10             	add    $0x10,%esp
801028e0:	eb c2                	jmp    801028a4 <kfree+0x44>
    panic("kfree");
801028e2:	83 ec 0c             	sub    $0xc,%esp
801028e5:	68 66 76 10 80       	push   $0x80107666
801028ea:	e8 11 dc ff ff       	call   80100500 <panic>
801028ef:	90                   	nop

801028f0 <freerange>:
{
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
801028f3:	56                   	push   %esi
801028f4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801028f5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801028f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801028fb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102901:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102907:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010290d:	39 de                	cmp    %ebx,%esi
8010290f:	72 23                	jb     80102934 <freerange+0x44>
80102911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102918:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010291e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102921:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102927:	50                   	push   %eax
80102928:	e8 33 ff ff ff       	call   80102860 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010292d:	83 c4 10             	add    $0x10,%esp
80102930:	39 f3                	cmp    %esi,%ebx
80102932:	76 e4                	jbe    80102918 <freerange+0x28>
}
80102934:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102937:	5b                   	pop    %ebx
80102938:	5e                   	pop    %esi
80102939:	5d                   	pop    %ebp
8010293a:	c3                   	ret    
8010293b:	90                   	nop
8010293c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102940 <kinit1>:
{
80102940:	55                   	push   %ebp
80102941:	89 e5                	mov    %esp,%ebp
80102943:	56                   	push   %esi
80102944:	53                   	push   %ebx
80102945:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102948:	83 ec 08             	sub    $0x8,%esp
8010294b:	68 6c 76 10 80       	push   $0x8010766c
80102950:	68 60 2e 11 80       	push   $0x80112e60
80102955:	e8 f6 1d 00 00       	call   80104750 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010295a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010295d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102960:	c7 05 94 2e 11 80 00 	movl   $0x0,0x80112e94
80102967:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010296a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102970:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102976:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010297c:	39 de                	cmp    %ebx,%esi
8010297e:	72 1c                	jb     8010299c <kinit1+0x5c>
    kfree(p);
80102980:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102986:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102989:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010298f:	50                   	push   %eax
80102990:	e8 cb fe ff ff       	call   80102860 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102995:	83 c4 10             	add    $0x10,%esp
80102998:	39 de                	cmp    %ebx,%esi
8010299a:	73 e4                	jae    80102980 <kinit1+0x40>
}
8010299c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010299f:	5b                   	pop    %ebx
801029a0:	5e                   	pop    %esi
801029a1:	5d                   	pop    %ebp
801029a2:	c3                   	ret    
801029a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029b0 <kinit2>:
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	56                   	push   %esi
801029b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801029b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801029b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801029bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801029c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801029cd:	39 de                	cmp    %ebx,%esi
801029cf:	72 23                	jb     801029f4 <kinit2+0x44>
801029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801029d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801029de:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801029e7:	50                   	push   %eax
801029e8:	e8 73 fe ff ff       	call   80102860 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029ed:	83 c4 10             	add    $0x10,%esp
801029f0:	39 de                	cmp    %ebx,%esi
801029f2:	73 e4                	jae    801029d8 <kinit2+0x28>
  kmem.use_lock = 1;
801029f4:	c7 05 94 2e 11 80 01 	movl   $0x1,0x80112e94
801029fb:	00 00 00 
}
801029fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a01:	5b                   	pop    %ebx
80102a02:	5e                   	pop    %esi
80102a03:	5d                   	pop    %ebp
80102a04:	c3                   	ret    
80102a05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a10 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102a10:	a1 94 2e 11 80       	mov    0x80112e94,%eax
80102a15:	85 c0                	test   %eax,%eax
80102a17:	75 1f                	jne    80102a38 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102a19:	a1 98 2e 11 80       	mov    0x80112e98,%eax
  if(r)
80102a1e:	85 c0                	test   %eax,%eax
80102a20:	74 0e                	je     80102a30 <kalloc+0x20>
    kmem.freelist = r->next;
80102a22:	8b 10                	mov    (%eax),%edx
80102a24:	89 15 98 2e 11 80    	mov    %edx,0x80112e98
80102a2a:	c3                   	ret    
80102a2b:	90                   	nop
80102a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102a30:	f3 c3                	repz ret 
80102a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102a38:	55                   	push   %ebp
80102a39:	89 e5                	mov    %esp,%ebp
80102a3b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102a3e:	68 60 2e 11 80       	push   $0x80112e60
80102a43:	e8 48 1e 00 00       	call   80104890 <acquire>
  r = kmem.freelist;
80102a48:	a1 98 2e 11 80       	mov    0x80112e98,%eax
  if(r)
80102a4d:	83 c4 10             	add    $0x10,%esp
80102a50:	8b 15 94 2e 11 80    	mov    0x80112e94,%edx
80102a56:	85 c0                	test   %eax,%eax
80102a58:	74 08                	je     80102a62 <kalloc+0x52>
    kmem.freelist = r->next;
80102a5a:	8b 08                	mov    (%eax),%ecx
80102a5c:	89 0d 98 2e 11 80    	mov    %ecx,0x80112e98
  if(kmem.use_lock)
80102a62:	85 d2                	test   %edx,%edx
80102a64:	74 16                	je     80102a7c <kalloc+0x6c>
    release(&kmem.lock);
80102a66:	83 ec 0c             	sub    $0xc,%esp
80102a69:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a6c:	68 60 2e 11 80       	push   $0x80112e60
80102a71:	e8 da 1e 00 00       	call   80104950 <release>
  return (char*)r;
80102a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102a79:	83 c4 10             	add    $0x10,%esp
}
80102a7c:	c9                   	leave  
80102a7d:	c3                   	ret    
80102a7e:	66 90                	xchg   %ax,%ax

80102a80 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a80:	ba 64 00 00 00       	mov    $0x64,%edx
80102a85:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102a86:	a8 01                	test   $0x1,%al
80102a88:	0f 84 c2 00 00 00    	je     80102b50 <kbdgetc+0xd0>
80102a8e:	ba 60 00 00 00       	mov    $0x60,%edx
80102a93:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102a94:	0f b6 d0             	movzbl %al,%edx
80102a97:	8b 0d d4 a5 10 80    	mov    0x8010a5d4,%ecx

  if(data == 0xE0){
80102a9d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102aa3:	0f 84 7f 00 00 00    	je     80102b28 <kbdgetc+0xa8>
{
80102aa9:	55                   	push   %ebp
80102aaa:	89 e5                	mov    %esp,%ebp
80102aac:	53                   	push   %ebx
80102aad:	89 cb                	mov    %ecx,%ebx
80102aaf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102ab2:	84 c0                	test   %al,%al
80102ab4:	78 4a                	js     80102b00 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102ab6:	85 db                	test   %ebx,%ebx
80102ab8:	74 09                	je     80102ac3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102aba:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102abd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102ac0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102ac3:	0f b6 82 a0 77 10 80 	movzbl -0x7fef8860(%edx),%eax
80102aca:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102acc:	0f b6 82 a0 76 10 80 	movzbl -0x7fef8960(%edx),%eax
80102ad3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102ad5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102ad7:	89 0d d4 a5 10 80    	mov    %ecx,0x8010a5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102add:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102ae0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102ae3:	8b 04 85 80 76 10 80 	mov    -0x7fef8980(,%eax,4),%eax
80102aea:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102aee:	74 31                	je     80102b21 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102af0:	8d 50 9f             	lea    -0x61(%eax),%edx
80102af3:	83 fa 19             	cmp    $0x19,%edx
80102af6:	77 40                	ja     80102b38 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102af8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102afb:	5b                   	pop    %ebx
80102afc:	5d                   	pop    %ebp
80102afd:	c3                   	ret    
80102afe:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102b00:	83 e0 7f             	and    $0x7f,%eax
80102b03:	85 db                	test   %ebx,%ebx
80102b05:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102b08:	0f b6 82 a0 77 10 80 	movzbl -0x7fef8860(%edx),%eax
80102b0f:	83 c8 40             	or     $0x40,%eax
80102b12:	0f b6 c0             	movzbl %al,%eax
80102b15:	f7 d0                	not    %eax
80102b17:	21 c1                	and    %eax,%ecx
    return 0;
80102b19:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102b1b:	89 0d d4 a5 10 80    	mov    %ecx,0x8010a5d4
}
80102b21:	5b                   	pop    %ebx
80102b22:	5d                   	pop    %ebp
80102b23:	c3                   	ret    
80102b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102b28:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102b2b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102b2d:	89 0d d4 a5 10 80    	mov    %ecx,0x8010a5d4
    return 0;
80102b33:	c3                   	ret    
80102b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102b38:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102b3b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102b3e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102b3f:	83 f9 1a             	cmp    $0x1a,%ecx
80102b42:	0f 42 c2             	cmovb  %edx,%eax
}
80102b45:	5d                   	pop    %ebp
80102b46:	c3                   	ret    
80102b47:	89 f6                	mov    %esi,%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102b55:	c3                   	ret    
80102b56:	8d 76 00             	lea    0x0(%esi),%esi
80102b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b60 <kbdintr>:

void
kbdintr(void)
{
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
80102b63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102b66:	68 80 2a 10 80       	push   $0x80102a80
80102b6b:	e8 b0 de ff ff       	call   80100a20 <consoleintr>
}
80102b70:	83 c4 10             	add    $0x10,%esp
80102b73:	c9                   	leave  
80102b74:	c3                   	ret    
80102b75:	66 90                	xchg   %ax,%ax
80102b77:	66 90                	xchg   %ax,%ax
80102b79:	66 90                	xchg   %ax,%ax
80102b7b:	66 90                	xchg   %ax,%ax
80102b7d:	66 90                	xchg   %ax,%ax
80102b7f:	90                   	nop

80102b80 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102b80:	a1 9c 2e 11 80       	mov    0x80112e9c,%eax
{
80102b85:	55                   	push   %ebp
80102b86:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102b88:	85 c0                	test   %eax,%eax
80102b8a:	0f 84 c8 00 00 00    	je     80102c58 <lapicinit+0xd8>
  lapic[index] = value;
80102b90:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102b97:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b9a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b9d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ba4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102baa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102bb1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bb7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102bbe:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bc4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102bcb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bd1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102bd8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bdb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102bde:	8b 50 30             	mov    0x30(%eax),%edx
80102be1:	c1 ea 10             	shr    $0x10,%edx
80102be4:	80 fa 03             	cmp    $0x3,%dl
80102be7:	77 77                	ja     80102c60 <lapicinit+0xe0>
  lapic[index] = value;
80102be9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102bf0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bf3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bf6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102bfd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c00:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c03:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102c0a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c0d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c10:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c17:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c1a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c1d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102c24:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c27:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c2a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102c31:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102c34:	8b 50 20             	mov    0x20(%eax),%edx
80102c37:	89 f6                	mov    %esi,%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102c40:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102c46:	80 e6 10             	and    $0x10,%dh
80102c49:	75 f5                	jne    80102c40 <lapicinit+0xc0>
  lapic[index] = value;
80102c4b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102c52:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c55:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102c58:	5d                   	pop    %ebp
80102c59:	c3                   	ret    
80102c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102c60:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102c67:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c6a:	8b 50 20             	mov    0x20(%eax),%edx
80102c6d:	e9 77 ff ff ff       	jmp    80102be9 <lapicinit+0x69>
80102c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c80 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102c80:	8b 15 9c 2e 11 80    	mov    0x80112e9c,%edx
{
80102c86:	55                   	push   %ebp
80102c87:	31 c0                	xor    %eax,%eax
80102c89:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102c8b:	85 d2                	test   %edx,%edx
80102c8d:	74 06                	je     80102c95 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102c8f:	8b 42 20             	mov    0x20(%edx),%eax
80102c92:	c1 e8 18             	shr    $0x18,%eax
}
80102c95:	5d                   	pop    %ebp
80102c96:	c3                   	ret    
80102c97:	89 f6                	mov    %esi,%esi
80102c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ca0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ca0:	a1 9c 2e 11 80       	mov    0x80112e9c,%eax
{
80102ca5:	55                   	push   %ebp
80102ca6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102ca8:	85 c0                	test   %eax,%eax
80102caa:	74 0d                	je     80102cb9 <lapiceoi+0x19>
  lapic[index] = value;
80102cac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102cb3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cb6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102cb9:	5d                   	pop    %ebp
80102cba:	c3                   	ret    
80102cbb:	90                   	nop
80102cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102cc0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
}
80102cc3:	5d                   	pop    %ebp
80102cc4:	c3                   	ret    
80102cc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cd0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102cd0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102cd6:	ba 70 00 00 00       	mov    $0x70,%edx
80102cdb:	89 e5                	mov    %esp,%ebp
80102cdd:	53                   	push   %ebx
80102cde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ce1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ce4:	ee                   	out    %al,(%dx)
80102ce5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102cea:	ba 71 00 00 00       	mov    $0x71,%edx
80102cef:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102cf0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102cf2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102cf5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102cfb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102cfd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102d00:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102d03:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102d05:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102d08:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102d0e:	a1 9c 2e 11 80       	mov    0x80112e9c,%eax
80102d13:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d19:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d1c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102d23:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d26:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d29:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102d30:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d33:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d36:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d3c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d3f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d45:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d48:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d4e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d51:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d57:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102d5a:	5b                   	pop    %ebx
80102d5b:	5d                   	pop    %ebp
80102d5c:	c3                   	ret    
80102d5d:	8d 76 00             	lea    0x0(%esi),%esi

80102d60 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102d60:	55                   	push   %ebp
80102d61:	b8 0b 00 00 00       	mov    $0xb,%eax
80102d66:	ba 70 00 00 00       	mov    $0x70,%edx
80102d6b:	89 e5                	mov    %esp,%ebp
80102d6d:	57                   	push   %edi
80102d6e:	56                   	push   %esi
80102d6f:	53                   	push   %ebx
80102d70:	83 ec 4c             	sub    $0x4c,%esp
80102d73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d74:	ba 71 00 00 00       	mov    $0x71,%edx
80102d79:	ec                   	in     (%dx),%al
80102d7a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d7d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102d82:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
80102d88:	31 c0                	xor    %eax,%eax
80102d8a:	89 da                	mov    %ebx,%edx
80102d8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d8d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102d92:	89 ca                	mov    %ecx,%edx
80102d94:	ec                   	in     (%dx),%al
80102d95:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d98:	89 da                	mov    %ebx,%edx
80102d9a:	b8 02 00 00 00       	mov    $0x2,%eax
80102d9f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102da0:	89 ca                	mov    %ecx,%edx
80102da2:	ec                   	in     (%dx),%al
80102da3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102da6:	89 da                	mov    %ebx,%edx
80102da8:	b8 04 00 00 00       	mov    $0x4,%eax
80102dad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dae:	89 ca                	mov    %ecx,%edx
80102db0:	ec                   	in     (%dx),%al
80102db1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db4:	89 da                	mov    %ebx,%edx
80102db6:	b8 07 00 00 00       	mov    $0x7,%eax
80102dbb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dbc:	89 ca                	mov    %ecx,%edx
80102dbe:	ec                   	in     (%dx),%al
80102dbf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc2:	89 da                	mov    %ebx,%edx
80102dc4:	b8 08 00 00 00       	mov    $0x8,%eax
80102dc9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dca:	89 ca                	mov    %ecx,%edx
80102dcc:	ec                   	in     (%dx),%al
80102dcd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dcf:	89 da                	mov    %ebx,%edx
80102dd1:	b8 09 00 00 00       	mov    $0x9,%eax
80102dd6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd7:	89 ca                	mov    %ecx,%edx
80102dd9:	ec                   	in     (%dx),%al
80102dda:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ddc:	89 da                	mov    %ebx,%edx
80102dde:	b8 0a 00 00 00       	mov    $0xa,%eax
80102de3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102de4:	89 ca                	mov    %ecx,%edx
80102de6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102de7:	84 c0                	test   %al,%al
80102de9:	78 9d                	js     80102d88 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102deb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102def:	89 fa                	mov    %edi,%edx
80102df1:	0f b6 fa             	movzbl %dl,%edi
80102df4:	89 f2                	mov    %esi,%edx
80102df6:	0f b6 f2             	movzbl %dl,%esi
80102df9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dfc:	89 da                	mov    %ebx,%edx
80102dfe:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102e01:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102e04:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102e08:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102e0b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102e0f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102e12:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102e16:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102e19:	31 c0                	xor    %eax,%eax
80102e1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e1c:	89 ca                	mov    %ecx,%edx
80102e1e:	ec                   	in     (%dx),%al
80102e1f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e22:	89 da                	mov    %ebx,%edx
80102e24:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102e27:	b8 02 00 00 00       	mov    $0x2,%eax
80102e2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e2d:	89 ca                	mov    %ecx,%edx
80102e2f:	ec                   	in     (%dx),%al
80102e30:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e33:	89 da                	mov    %ebx,%edx
80102e35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102e38:	b8 04 00 00 00       	mov    $0x4,%eax
80102e3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e3e:	89 ca                	mov    %ecx,%edx
80102e40:	ec                   	in     (%dx),%al
80102e41:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e44:	89 da                	mov    %ebx,%edx
80102e46:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102e49:	b8 07 00 00 00       	mov    $0x7,%eax
80102e4e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e4f:	89 ca                	mov    %ecx,%edx
80102e51:	ec                   	in     (%dx),%al
80102e52:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e55:	89 da                	mov    %ebx,%edx
80102e57:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102e5a:	b8 08 00 00 00       	mov    $0x8,%eax
80102e5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e60:	89 ca                	mov    %ecx,%edx
80102e62:	ec                   	in     (%dx),%al
80102e63:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e66:	89 da                	mov    %ebx,%edx
80102e68:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e6b:	b8 09 00 00 00       	mov    $0x9,%eax
80102e70:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e71:	89 ca                	mov    %ecx,%edx
80102e73:	ec                   	in     (%dx),%al
80102e74:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e77:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102e7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e7d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102e80:	6a 18                	push   $0x18
80102e82:	50                   	push   %eax
80102e83:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102e86:	50                   	push   %eax
80102e87:	e8 64 1b 00 00       	call   801049f0 <memcmp>
80102e8c:	83 c4 10             	add    $0x10,%esp
80102e8f:	85 c0                	test   %eax,%eax
80102e91:	0f 85 f1 fe ff ff    	jne    80102d88 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102e97:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102e9b:	75 78                	jne    80102f15 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e9d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ea0:	89 c2                	mov    %eax,%edx
80102ea2:	83 e0 0f             	and    $0xf,%eax
80102ea5:	c1 ea 04             	shr    $0x4,%edx
80102ea8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102eab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102eae:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102eb1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102eb4:	89 c2                	mov    %eax,%edx
80102eb6:	83 e0 0f             	and    $0xf,%eax
80102eb9:	c1 ea 04             	shr    $0x4,%edx
80102ebc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ebf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ec2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ec5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ec8:	89 c2                	mov    %eax,%edx
80102eca:	83 e0 0f             	and    $0xf,%eax
80102ecd:	c1 ea 04             	shr    $0x4,%edx
80102ed0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ed3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ed6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ed9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102edc:	89 c2                	mov    %eax,%edx
80102ede:	83 e0 0f             	and    $0xf,%eax
80102ee1:	c1 ea 04             	shr    $0x4,%edx
80102ee4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ee7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102eea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102eed:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ef0:	89 c2                	mov    %eax,%edx
80102ef2:	83 e0 0f             	and    $0xf,%eax
80102ef5:	c1 ea 04             	shr    $0x4,%edx
80102ef8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102efb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102efe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102f01:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102f04:	89 c2                	mov    %eax,%edx
80102f06:	83 e0 0f             	and    $0xf,%eax
80102f09:	c1 ea 04             	shr    $0x4,%edx
80102f0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f12:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102f15:	8b 75 08             	mov    0x8(%ebp),%esi
80102f18:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102f1b:	89 06                	mov    %eax,(%esi)
80102f1d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102f20:	89 46 04             	mov    %eax,0x4(%esi)
80102f23:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102f26:	89 46 08             	mov    %eax,0x8(%esi)
80102f29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102f2c:	89 46 0c             	mov    %eax,0xc(%esi)
80102f2f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102f32:	89 46 10             	mov    %eax,0x10(%esi)
80102f35:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102f38:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102f3b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102f42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f45:	5b                   	pop    %ebx
80102f46:	5e                   	pop    %esi
80102f47:	5f                   	pop    %edi
80102f48:	5d                   	pop    %ebp
80102f49:	c3                   	ret    
80102f4a:	66 90                	xchg   %ax,%ax
80102f4c:	66 90                	xchg   %ax,%ax
80102f4e:	66 90                	xchg   %ax,%ax

80102f50 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102f50:	8b 0d e8 2e 11 80    	mov    0x80112ee8,%ecx
80102f56:	85 c9                	test   %ecx,%ecx
80102f58:	0f 8e 8a 00 00 00    	jle    80102fe8 <install_trans+0x98>
{
80102f5e:	55                   	push   %ebp
80102f5f:	89 e5                	mov    %esp,%ebp
80102f61:	57                   	push   %edi
80102f62:	56                   	push   %esi
80102f63:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102f64:	31 db                	xor    %ebx,%ebx
{
80102f66:	83 ec 0c             	sub    $0xc,%esp
80102f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102f70:	a1 d4 2e 11 80       	mov    0x80112ed4,%eax
80102f75:	83 ec 08             	sub    $0x8,%esp
80102f78:	01 d8                	add    %ebx,%eax
80102f7a:	83 c0 01             	add    $0x1,%eax
80102f7d:	50                   	push   %eax
80102f7e:	ff 35 e4 2e 11 80    	pushl  0x80112ee4
80102f84:	e8 47 d1 ff ff       	call   801000d0 <bread>
80102f89:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f8b:	58                   	pop    %eax
80102f8c:	5a                   	pop    %edx
80102f8d:	ff 34 9d ec 2e 11 80 	pushl  -0x7feed114(,%ebx,4)
80102f94:	ff 35 e4 2e 11 80    	pushl  0x80112ee4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f9d:	e8 2e d1 ff ff       	call   801000d0 <bread>
80102fa2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102fa4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102fa7:	83 c4 0c             	add    $0xc,%esp
80102faa:	68 00 02 00 00       	push   $0x200
80102faf:	50                   	push   %eax
80102fb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fb3:	50                   	push   %eax
80102fb4:	e8 97 1a 00 00       	call   80104a50 <memmove>
    bwrite(dbuf);  // write dst to disk
80102fb9:	89 34 24             	mov    %esi,(%esp)
80102fbc:	e8 df d1 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102fc1:	89 3c 24             	mov    %edi,(%esp)
80102fc4:	e8 17 d2 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102fc9:	89 34 24             	mov    %esi,(%esp)
80102fcc:	e8 0f d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fd1:	83 c4 10             	add    $0x10,%esp
80102fd4:	39 1d e8 2e 11 80    	cmp    %ebx,0x80112ee8
80102fda:	7f 94                	jg     80102f70 <install_trans+0x20>
  }
}
80102fdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fdf:	5b                   	pop    %ebx
80102fe0:	5e                   	pop    %esi
80102fe1:	5f                   	pop    %edi
80102fe2:	5d                   	pop    %ebp
80102fe3:	c3                   	ret    
80102fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fe8:	f3 c3                	repz ret 
80102fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ff0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	56                   	push   %esi
80102ff4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ff5:	83 ec 08             	sub    $0x8,%esp
80102ff8:	ff 35 d4 2e 11 80    	pushl  0x80112ed4
80102ffe:	ff 35 e4 2e 11 80    	pushl  0x80112ee4
80103004:	e8 c7 d0 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103009:	8b 1d e8 2e 11 80    	mov    0x80112ee8,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010300f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103012:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103014:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103016:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103019:	7e 16                	jle    80103031 <write_head+0x41>
8010301b:	c1 e3 02             	shl    $0x2,%ebx
8010301e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103020:	8b 8a ec 2e 11 80    	mov    -0x7feed114(%edx),%ecx
80103026:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010302a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010302d:	39 da                	cmp    %ebx,%edx
8010302f:	75 ef                	jne    80103020 <write_head+0x30>
  }
  bwrite(buf);
80103031:	83 ec 0c             	sub    $0xc,%esp
80103034:	56                   	push   %esi
80103035:	e8 66 d1 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
8010303a:	89 34 24             	mov    %esi,(%esp)
8010303d:	e8 9e d1 ff ff       	call   801001e0 <brelse>
}
80103042:	83 c4 10             	add    $0x10,%esp
80103045:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103048:	5b                   	pop    %ebx
80103049:	5e                   	pop    %esi
8010304a:	5d                   	pop    %ebp
8010304b:	c3                   	ret    
8010304c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103050 <initlog>:
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	53                   	push   %ebx
80103054:	83 ec 2c             	sub    $0x2c,%esp
80103057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010305a:	68 a0 78 10 80       	push   $0x801078a0
8010305f:	68 a0 2e 11 80       	push   $0x80112ea0
80103064:	e8 e7 16 00 00       	call   80104750 <initlock>
  readsb(dev, &sb);
80103069:	58                   	pop    %eax
8010306a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010306d:	5a                   	pop    %edx
8010306e:	50                   	push   %eax
8010306f:	53                   	push   %ebx
80103070:	e8 1b e9 ff ff       	call   80101990 <readsb>
  log.size = sb.nlog;
80103075:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103078:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010307b:	59                   	pop    %ecx
  log.dev = dev;
8010307c:	89 1d e4 2e 11 80    	mov    %ebx,0x80112ee4
  log.size = sb.nlog;
80103082:	89 15 d8 2e 11 80    	mov    %edx,0x80112ed8
  log.start = sb.logstart;
80103088:	a3 d4 2e 11 80       	mov    %eax,0x80112ed4
  struct buf *buf = bread(log.dev, log.start);
8010308d:	5a                   	pop    %edx
8010308e:	50                   	push   %eax
8010308f:	53                   	push   %ebx
80103090:	e8 3b d0 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103095:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103098:	83 c4 10             	add    $0x10,%esp
8010309b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010309d:	89 1d e8 2e 11 80    	mov    %ebx,0x80112ee8
  for (i = 0; i < log.lh.n; i++) {
801030a3:	7e 1c                	jle    801030c1 <initlog+0x71>
801030a5:	c1 e3 02             	shl    $0x2,%ebx
801030a8:	31 d2                	xor    %edx,%edx
801030aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
801030b0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
801030b4:	83 c2 04             	add    $0x4,%edx
801030b7:	89 8a e8 2e 11 80    	mov    %ecx,-0x7feed118(%edx)
  for (i = 0; i < log.lh.n; i++) {
801030bd:	39 d3                	cmp    %edx,%ebx
801030bf:	75 ef                	jne    801030b0 <initlog+0x60>
  brelse(buf);
801030c1:	83 ec 0c             	sub    $0xc,%esp
801030c4:	50                   	push   %eax
801030c5:	e8 16 d1 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801030ca:	e8 81 fe ff ff       	call   80102f50 <install_trans>
  log.lh.n = 0;
801030cf:	c7 05 e8 2e 11 80 00 	movl   $0x0,0x80112ee8
801030d6:	00 00 00 
  write_head(); // clear the log
801030d9:	e8 12 ff ff ff       	call   80102ff0 <write_head>
}
801030de:	83 c4 10             	add    $0x10,%esp
801030e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801030e4:	c9                   	leave  
801030e5:	c3                   	ret    
801030e6:	8d 76 00             	lea    0x0(%esi),%esi
801030e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801030f6:	68 a0 2e 11 80       	push   $0x80112ea0
801030fb:	e8 90 17 00 00       	call   80104890 <acquire>
80103100:	83 c4 10             	add    $0x10,%esp
80103103:	eb 18                	jmp    8010311d <begin_op+0x2d>
80103105:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103108:	83 ec 08             	sub    $0x8,%esp
8010310b:	68 a0 2e 11 80       	push   $0x80112ea0
80103110:	68 a0 2e 11 80       	push   $0x80112ea0
80103115:	e8 b6 11 00 00       	call   801042d0 <sleep>
8010311a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010311d:	a1 e0 2e 11 80       	mov    0x80112ee0,%eax
80103122:	85 c0                	test   %eax,%eax
80103124:	75 e2                	jne    80103108 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103126:	a1 dc 2e 11 80       	mov    0x80112edc,%eax
8010312b:	8b 15 e8 2e 11 80    	mov    0x80112ee8,%edx
80103131:	83 c0 01             	add    $0x1,%eax
80103134:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103137:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010313a:	83 fa 1e             	cmp    $0x1e,%edx
8010313d:	7f c9                	jg     80103108 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010313f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103142:	a3 dc 2e 11 80       	mov    %eax,0x80112edc
      release(&log.lock);
80103147:	68 a0 2e 11 80       	push   $0x80112ea0
8010314c:	e8 ff 17 00 00       	call   80104950 <release>
      break;
    }
  }
}
80103151:	83 c4 10             	add    $0x10,%esp
80103154:	c9                   	leave  
80103155:	c3                   	ret    
80103156:	8d 76 00             	lea    0x0(%esi),%esi
80103159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103160 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
80103165:	53                   	push   %ebx
80103166:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103169:	68 a0 2e 11 80       	push   $0x80112ea0
8010316e:	e8 1d 17 00 00       	call   80104890 <acquire>
  log.outstanding -= 1;
80103173:	a1 dc 2e 11 80       	mov    0x80112edc,%eax
  if(log.committing)
80103178:	8b 35 e0 2e 11 80    	mov    0x80112ee0,%esi
8010317e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103181:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103184:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103186:	89 1d dc 2e 11 80    	mov    %ebx,0x80112edc
  if(log.committing)
8010318c:	0f 85 1a 01 00 00    	jne    801032ac <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103192:	85 db                	test   %ebx,%ebx
80103194:	0f 85 ee 00 00 00    	jne    80103288 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010319a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010319d:	c7 05 e0 2e 11 80 01 	movl   $0x1,0x80112ee0
801031a4:	00 00 00 
  release(&log.lock);
801031a7:	68 a0 2e 11 80       	push   $0x80112ea0
801031ac:	e8 9f 17 00 00       	call   80104950 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801031b1:	8b 0d e8 2e 11 80    	mov    0x80112ee8,%ecx
801031b7:	83 c4 10             	add    $0x10,%esp
801031ba:	85 c9                	test   %ecx,%ecx
801031bc:	0f 8e 85 00 00 00    	jle    80103247 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801031c2:	a1 d4 2e 11 80       	mov    0x80112ed4,%eax
801031c7:	83 ec 08             	sub    $0x8,%esp
801031ca:	01 d8                	add    %ebx,%eax
801031cc:	83 c0 01             	add    $0x1,%eax
801031cf:	50                   	push   %eax
801031d0:	ff 35 e4 2e 11 80    	pushl  0x80112ee4
801031d6:	e8 f5 ce ff ff       	call   801000d0 <bread>
801031db:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031dd:	58                   	pop    %eax
801031de:	5a                   	pop    %edx
801031df:	ff 34 9d ec 2e 11 80 	pushl  -0x7feed114(,%ebx,4)
801031e6:	ff 35 e4 2e 11 80    	pushl  0x80112ee4
  for (tail = 0; tail < log.lh.n; tail++) {
801031ec:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031ef:	e8 dc ce ff ff       	call   801000d0 <bread>
801031f4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801031f6:	8d 40 5c             	lea    0x5c(%eax),%eax
801031f9:	83 c4 0c             	add    $0xc,%esp
801031fc:	68 00 02 00 00       	push   $0x200
80103201:	50                   	push   %eax
80103202:	8d 46 5c             	lea    0x5c(%esi),%eax
80103205:	50                   	push   %eax
80103206:	e8 45 18 00 00       	call   80104a50 <memmove>
    bwrite(to);  // write the log
8010320b:	89 34 24             	mov    %esi,(%esp)
8010320e:	e8 8d cf ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103213:	89 3c 24             	mov    %edi,(%esp)
80103216:	e8 c5 cf ff ff       	call   801001e0 <brelse>
    brelse(to);
8010321b:	89 34 24             	mov    %esi,(%esp)
8010321e:	e8 bd cf ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103223:	83 c4 10             	add    $0x10,%esp
80103226:	3b 1d e8 2e 11 80    	cmp    0x80112ee8,%ebx
8010322c:	7c 94                	jl     801031c2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010322e:	e8 bd fd ff ff       	call   80102ff0 <write_head>
    install_trans(); // Now install writes to home locations
80103233:	e8 18 fd ff ff       	call   80102f50 <install_trans>
    log.lh.n = 0;
80103238:	c7 05 e8 2e 11 80 00 	movl   $0x0,0x80112ee8
8010323f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103242:	e8 a9 fd ff ff       	call   80102ff0 <write_head>
    acquire(&log.lock);
80103247:	83 ec 0c             	sub    $0xc,%esp
8010324a:	68 a0 2e 11 80       	push   $0x80112ea0
8010324f:	e8 3c 16 00 00       	call   80104890 <acquire>
    wakeup(&log);
80103254:	c7 04 24 a0 2e 11 80 	movl   $0x80112ea0,(%esp)
    log.committing = 0;
8010325b:	c7 05 e0 2e 11 80 00 	movl   $0x0,0x80112ee0
80103262:	00 00 00 
    wakeup(&log);
80103265:	e8 16 12 00 00       	call   80104480 <wakeup>
    release(&log.lock);
8010326a:	c7 04 24 a0 2e 11 80 	movl   $0x80112ea0,(%esp)
80103271:	e8 da 16 00 00       	call   80104950 <release>
80103276:	83 c4 10             	add    $0x10,%esp
}
80103279:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010327c:	5b                   	pop    %ebx
8010327d:	5e                   	pop    %esi
8010327e:	5f                   	pop    %edi
8010327f:	5d                   	pop    %ebp
80103280:	c3                   	ret    
80103281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103288:	83 ec 0c             	sub    $0xc,%esp
8010328b:	68 a0 2e 11 80       	push   $0x80112ea0
80103290:	e8 eb 11 00 00       	call   80104480 <wakeup>
  release(&log.lock);
80103295:	c7 04 24 a0 2e 11 80 	movl   $0x80112ea0,(%esp)
8010329c:	e8 af 16 00 00       	call   80104950 <release>
801032a1:	83 c4 10             	add    $0x10,%esp
}
801032a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032a7:	5b                   	pop    %ebx
801032a8:	5e                   	pop    %esi
801032a9:	5f                   	pop    %edi
801032aa:	5d                   	pop    %ebp
801032ab:	c3                   	ret    
    panic("log.committing");
801032ac:	83 ec 0c             	sub    $0xc,%esp
801032af:	68 a4 78 10 80       	push   $0x801078a4
801032b4:	e8 47 d2 ff ff       	call   80100500 <panic>
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801032c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	53                   	push   %ebx
801032c4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032c7:	8b 15 e8 2e 11 80    	mov    0x80112ee8,%edx
{
801032cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032d0:	83 fa 1d             	cmp    $0x1d,%edx
801032d3:	0f 8f 9d 00 00 00    	jg     80103376 <log_write+0xb6>
801032d9:	a1 d8 2e 11 80       	mov    0x80112ed8,%eax
801032de:	83 e8 01             	sub    $0x1,%eax
801032e1:	39 c2                	cmp    %eax,%edx
801032e3:	0f 8d 8d 00 00 00    	jge    80103376 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801032e9:	a1 dc 2e 11 80       	mov    0x80112edc,%eax
801032ee:	85 c0                	test   %eax,%eax
801032f0:	0f 8e 8d 00 00 00    	jle    80103383 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801032f6:	83 ec 0c             	sub    $0xc,%esp
801032f9:	68 a0 2e 11 80       	push   $0x80112ea0
801032fe:	e8 8d 15 00 00       	call   80104890 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103303:	8b 0d e8 2e 11 80    	mov    0x80112ee8,%ecx
80103309:	83 c4 10             	add    $0x10,%esp
8010330c:	83 f9 00             	cmp    $0x0,%ecx
8010330f:	7e 57                	jle    80103368 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103311:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103314:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103316:	3b 15 ec 2e 11 80    	cmp    0x80112eec,%edx
8010331c:	75 0b                	jne    80103329 <log_write+0x69>
8010331e:	eb 38                	jmp    80103358 <log_write+0x98>
80103320:	39 14 85 ec 2e 11 80 	cmp    %edx,-0x7feed114(,%eax,4)
80103327:	74 2f                	je     80103358 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103329:	83 c0 01             	add    $0x1,%eax
8010332c:	39 c1                	cmp    %eax,%ecx
8010332e:	75 f0                	jne    80103320 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103330:	89 14 85 ec 2e 11 80 	mov    %edx,-0x7feed114(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103337:	83 c0 01             	add    $0x1,%eax
8010333a:	a3 e8 2e 11 80       	mov    %eax,0x80112ee8
  b->flags |= B_DIRTY; // prevent eviction
8010333f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103342:	c7 45 08 a0 2e 11 80 	movl   $0x80112ea0,0x8(%ebp)
}
80103349:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010334c:	c9                   	leave  
  release(&log.lock);
8010334d:	e9 fe 15 00 00       	jmp    80104950 <release>
80103352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103358:	89 14 85 ec 2e 11 80 	mov    %edx,-0x7feed114(,%eax,4)
8010335f:	eb de                	jmp    8010333f <log_write+0x7f>
80103361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103368:	8b 43 08             	mov    0x8(%ebx),%eax
8010336b:	a3 ec 2e 11 80       	mov    %eax,0x80112eec
  if (i == log.lh.n)
80103370:	75 cd                	jne    8010333f <log_write+0x7f>
80103372:	31 c0                	xor    %eax,%eax
80103374:	eb c1                	jmp    80103337 <log_write+0x77>
    panic("too big a transaction");
80103376:	83 ec 0c             	sub    $0xc,%esp
80103379:	68 b3 78 10 80       	push   $0x801078b3
8010337e:	e8 7d d1 ff ff       	call   80100500 <panic>
    panic("log_write outside of trans");
80103383:	83 ec 0c             	sub    $0xc,%esp
80103386:	68 c9 78 10 80       	push   $0x801078c9
8010338b:	e8 70 d1 ff ff       	call   80100500 <panic>

80103390 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	53                   	push   %ebx
80103394:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103397:	e8 74 09 00 00       	call   80103d10 <cpuid>
8010339c:	89 c3                	mov    %eax,%ebx
8010339e:	e8 6d 09 00 00       	call   80103d10 <cpuid>
801033a3:	83 ec 04             	sub    $0x4,%esp
801033a6:	53                   	push   %ebx
801033a7:	50                   	push   %eax
801033a8:	68 e4 78 10 80       	push   $0x801078e4
801033ad:	e8 5e d4 ff ff       	call   80100810 <cprintf>
  idtinit();       // load idt register
801033b2:	e8 69 28 00 00       	call   80105c20 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801033b7:	e8 d4 08 00 00       	call   80103c90 <mycpu>
801033bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033be:	b8 01 00 00 00       	mov    $0x1,%eax
801033c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801033ca:	e8 21 0c 00 00       	call   80103ff0 <scheduler>
801033cf:	90                   	nop

801033d0 <mpenter>:
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801033d6:	e8 35 39 00 00       	call   80106d10 <switchkvm>
  seginit();
801033db:	e8 a0 38 00 00       	call   80106c80 <seginit>
  lapicinit();
801033e0:	e8 9b f7 ff ff       	call   80102b80 <lapicinit>
  mpmain();
801033e5:	e8 a6 ff ff ff       	call   80103390 <mpmain>
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <main>:
{
801033f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801033f4:	83 e4 f0             	and    $0xfffffff0,%esp
801033f7:	ff 71 fc             	pushl  -0x4(%ecx)
801033fa:	55                   	push   %ebp
801033fb:	89 e5                	mov    %esp,%ebp
801033fd:	53                   	push   %ebx
801033fe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033ff:	83 ec 08             	sub    $0x8,%esp
80103402:	68 00 00 40 80       	push   $0x80400000
80103407:	68 c8 5c 11 80       	push   $0x80115cc8
8010340c:	e8 2f f5 ff ff       	call   80102940 <kinit1>
  kvmalloc();      // kernel page table
80103411:	e8 ca 3d 00 00       	call   801071e0 <kvmalloc>
  mpinit();        // detect other processors
80103416:	e8 75 01 00 00       	call   80103590 <mpinit>
  lapicinit();     // interrupt controller
8010341b:	e8 60 f7 ff ff       	call   80102b80 <lapicinit>
  seginit();       // segment descriptors
80103420:	e8 5b 38 00 00       	call   80106c80 <seginit>
  picinit();       // disable pic
80103425:	e8 46 03 00 00       	call   80103770 <picinit>
  ioapicinit();    // another interrupt controller
8010342a:	e8 41 f3 ff ff       	call   80102770 <ioapicinit>
  consoleinit();   // console hardware
8010342f:	e8 dc da ff ff       	call   80100f10 <consoleinit>
  uartinit();      // serial port
80103434:	e8 17 2b 00 00       	call   80105f50 <uartinit>
  pinit();         // process table
80103439:	e8 32 08 00 00       	call   80103c70 <pinit>
  tvinit();        // trap vectors
8010343e:	e8 5d 27 00 00       	call   80105ba0 <tvinit>
  binit();         // buffer cache
80103443:	e8 f8 cb ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103448:	e8 63 de ff ff       	call   801012b0 <fileinit>
  ideinit();       // disk 
8010344d:	e8 fe f0 ff ff       	call   80102550 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103452:	83 c4 0c             	add    $0xc,%esp
80103455:	68 8a 00 00 00       	push   $0x8a
8010345a:	68 8c a4 10 80       	push   $0x8010a48c
8010345f:	68 00 70 00 80       	push   $0x80007000
80103464:	e8 e7 15 00 00       	call   80104a50 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103469:	69 05 20 35 11 80 b0 	imul   $0xb0,0x80113520,%eax
80103470:	00 00 00 
80103473:	83 c4 10             	add    $0x10,%esp
80103476:	05 a0 2f 11 80       	add    $0x80112fa0,%eax
8010347b:	3d a0 2f 11 80       	cmp    $0x80112fa0,%eax
80103480:	76 71                	jbe    801034f3 <main+0x103>
80103482:	bb a0 2f 11 80       	mov    $0x80112fa0,%ebx
80103487:	89 f6                	mov    %esi,%esi
80103489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103490:	e8 fb 07 00 00       	call   80103c90 <mycpu>
80103495:	39 d8                	cmp    %ebx,%eax
80103497:	74 41                	je     801034da <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103499:	e8 72 f5 ff ff       	call   80102a10 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010349e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801034a3:	c7 05 f8 6f 00 80 d0 	movl   $0x801033d0,0x80006ff8
801034aa:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801034ad:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801034b4:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801034b7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801034bc:	0f b6 03             	movzbl (%ebx),%eax
801034bf:	83 ec 08             	sub    $0x8,%esp
801034c2:	68 00 70 00 00       	push   $0x7000
801034c7:	50                   	push   %eax
801034c8:	e8 03 f8 ff ff       	call   80102cd0 <lapicstartap>
801034cd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801034d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801034d6:	85 c0                	test   %eax,%eax
801034d8:	74 f6                	je     801034d0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801034da:	69 05 20 35 11 80 b0 	imul   $0xb0,0x80113520,%eax
801034e1:	00 00 00 
801034e4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801034ea:	05 a0 2f 11 80       	add    $0x80112fa0,%eax
801034ef:	39 c3                	cmp    %eax,%ebx
801034f1:	72 9d                	jb     80103490 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034f3:	83 ec 08             	sub    $0x8,%esp
801034f6:	68 00 00 00 8e       	push   $0x8e000000
801034fb:	68 00 00 40 80       	push   $0x80400000
80103500:	e8 ab f4 ff ff       	call   801029b0 <kinit2>
  userinit();      // first user process
80103505:	e8 56 08 00 00       	call   80103d60 <userinit>
  mpmain();        // finish this processor's setup
8010350a:	e8 81 fe ff ff       	call   80103390 <mpmain>
8010350f:	90                   	nop

80103510 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	57                   	push   %edi
80103514:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103515:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010351b:	53                   	push   %ebx
  e = addr+len;
8010351c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010351f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103522:	39 de                	cmp    %ebx,%esi
80103524:	72 10                	jb     80103536 <mpsearch1+0x26>
80103526:	eb 50                	jmp    80103578 <mpsearch1+0x68>
80103528:	90                   	nop
80103529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103530:	39 fb                	cmp    %edi,%ebx
80103532:	89 fe                	mov    %edi,%esi
80103534:	76 42                	jbe    80103578 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103536:	83 ec 04             	sub    $0x4,%esp
80103539:	8d 7e 10             	lea    0x10(%esi),%edi
8010353c:	6a 04                	push   $0x4
8010353e:	68 f8 78 10 80       	push   $0x801078f8
80103543:	56                   	push   %esi
80103544:	e8 a7 14 00 00       	call   801049f0 <memcmp>
80103549:	83 c4 10             	add    $0x10,%esp
8010354c:	85 c0                	test   %eax,%eax
8010354e:	75 e0                	jne    80103530 <mpsearch1+0x20>
80103550:	89 f1                	mov    %esi,%ecx
80103552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103558:	0f b6 11             	movzbl (%ecx),%edx
8010355b:	83 c1 01             	add    $0x1,%ecx
8010355e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103560:	39 f9                	cmp    %edi,%ecx
80103562:	75 f4                	jne    80103558 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103564:	84 c0                	test   %al,%al
80103566:	75 c8                	jne    80103530 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103568:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010356b:	89 f0                	mov    %esi,%eax
8010356d:	5b                   	pop    %ebx
8010356e:	5e                   	pop    %esi
8010356f:	5f                   	pop    %edi
80103570:	5d                   	pop    %ebp
80103571:	c3                   	ret    
80103572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103578:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010357b:	31 f6                	xor    %esi,%esi
}
8010357d:	89 f0                	mov    %esi,%eax
8010357f:	5b                   	pop    %ebx
80103580:	5e                   	pop    %esi
80103581:	5f                   	pop    %edi
80103582:	5d                   	pop    %ebp
80103583:	c3                   	ret    
80103584:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010358a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103590 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	57                   	push   %edi
80103594:	56                   	push   %esi
80103595:	53                   	push   %ebx
80103596:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103599:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801035a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801035a7:	c1 e0 08             	shl    $0x8,%eax
801035aa:	09 d0                	or     %edx,%eax
801035ac:	c1 e0 04             	shl    $0x4,%eax
801035af:	85 c0                	test   %eax,%eax
801035b1:	75 1b                	jne    801035ce <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801035b3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801035ba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801035c1:	c1 e0 08             	shl    $0x8,%eax
801035c4:	09 d0                	or     %edx,%eax
801035c6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801035c9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801035ce:	ba 00 04 00 00       	mov    $0x400,%edx
801035d3:	e8 38 ff ff ff       	call   80103510 <mpsearch1>
801035d8:	85 c0                	test   %eax,%eax
801035da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035dd:	0f 84 3d 01 00 00    	je     80103720 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035e6:	8b 58 04             	mov    0x4(%eax),%ebx
801035e9:	85 db                	test   %ebx,%ebx
801035eb:	0f 84 4f 01 00 00    	je     80103740 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035f1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801035f7:	83 ec 04             	sub    $0x4,%esp
801035fa:	6a 04                	push   $0x4
801035fc:	68 15 79 10 80       	push   $0x80107915
80103601:	56                   	push   %esi
80103602:	e8 e9 13 00 00       	call   801049f0 <memcmp>
80103607:	83 c4 10             	add    $0x10,%esp
8010360a:	85 c0                	test   %eax,%eax
8010360c:	0f 85 2e 01 00 00    	jne    80103740 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103612:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103619:	3c 01                	cmp    $0x1,%al
8010361b:	0f 95 c2             	setne  %dl
8010361e:	3c 04                	cmp    $0x4,%al
80103620:	0f 95 c0             	setne  %al
80103623:	20 c2                	and    %al,%dl
80103625:	0f 85 15 01 00 00    	jne    80103740 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010362b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103632:	66 85 ff             	test   %di,%di
80103635:	74 1a                	je     80103651 <mpinit+0xc1>
80103637:	89 f0                	mov    %esi,%eax
80103639:	01 f7                	add    %esi,%edi
  sum = 0;
8010363b:	31 d2                	xor    %edx,%edx
8010363d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103640:	0f b6 08             	movzbl (%eax),%ecx
80103643:	83 c0 01             	add    $0x1,%eax
80103646:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103648:	39 c7                	cmp    %eax,%edi
8010364a:	75 f4                	jne    80103640 <mpinit+0xb0>
8010364c:	84 d2                	test   %dl,%dl
8010364e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103651:	85 f6                	test   %esi,%esi
80103653:	0f 84 e7 00 00 00    	je     80103740 <mpinit+0x1b0>
80103659:	84 d2                	test   %dl,%dl
8010365b:	0f 85 df 00 00 00    	jne    80103740 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103661:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103667:	a3 9c 2e 11 80       	mov    %eax,0x80112e9c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010366c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103673:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103679:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010367e:	01 d6                	add    %edx,%esi
80103680:	39 c6                	cmp    %eax,%esi
80103682:	76 23                	jbe    801036a7 <mpinit+0x117>
    switch(*p){
80103684:	0f b6 10             	movzbl (%eax),%edx
80103687:	80 fa 04             	cmp    $0x4,%dl
8010368a:	0f 87 ca 00 00 00    	ja     8010375a <mpinit+0x1ca>
80103690:	ff 24 95 3c 79 10 80 	jmp    *-0x7fef86c4(,%edx,4)
80103697:	89 f6                	mov    %esi,%esi
80103699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801036a0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801036a3:	39 c6                	cmp    %eax,%esi
801036a5:	77 dd                	ja     80103684 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801036a7:	85 db                	test   %ebx,%ebx
801036a9:	0f 84 9e 00 00 00    	je     8010374d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801036af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801036b2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801036b6:	74 15                	je     801036cd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801036b8:	b8 70 00 00 00       	mov    $0x70,%eax
801036bd:	ba 22 00 00 00       	mov    $0x22,%edx
801036c2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801036c3:	ba 23 00 00 00       	mov    $0x23,%edx
801036c8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801036c9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801036cc:	ee                   	out    %al,(%dx)
  }
}
801036cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036d0:	5b                   	pop    %ebx
801036d1:	5e                   	pop    %esi
801036d2:	5f                   	pop    %edi
801036d3:	5d                   	pop    %ebp
801036d4:	c3                   	ret    
801036d5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801036d8:	8b 0d 20 35 11 80    	mov    0x80113520,%ecx
801036de:	83 f9 07             	cmp    $0x7,%ecx
801036e1:	7f 19                	jg     801036fc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036e3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801036e7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801036ed:	83 c1 01             	add    $0x1,%ecx
801036f0:	89 0d 20 35 11 80    	mov    %ecx,0x80113520
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036f6:	88 97 a0 2f 11 80    	mov    %dl,-0x7feed060(%edi)
      p += sizeof(struct mpproc);
801036fc:	83 c0 14             	add    $0x14,%eax
      continue;
801036ff:	e9 7c ff ff ff       	jmp    80103680 <mpinit+0xf0>
80103704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103708:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010370c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010370f:	88 15 80 2f 11 80    	mov    %dl,0x80112f80
      continue;
80103715:	e9 66 ff ff ff       	jmp    80103680 <mpinit+0xf0>
8010371a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103720:	ba 00 00 01 00       	mov    $0x10000,%edx
80103725:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010372a:	e8 e1 fd ff ff       	call   80103510 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010372f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103734:	0f 85 a9 fe ff ff    	jne    801035e3 <mpinit+0x53>
8010373a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103740:	83 ec 0c             	sub    $0xc,%esp
80103743:	68 fd 78 10 80       	push   $0x801078fd
80103748:	e8 b3 cd ff ff       	call   80100500 <panic>
    panic("Didn't find a suitable machine");
8010374d:	83 ec 0c             	sub    $0xc,%esp
80103750:	68 1c 79 10 80       	push   $0x8010791c
80103755:	e8 a6 cd ff ff       	call   80100500 <panic>
      ismp = 0;
8010375a:	31 db                	xor    %ebx,%ebx
8010375c:	e9 26 ff ff ff       	jmp    80103687 <mpinit+0xf7>
80103761:	66 90                	xchg   %ax,%ax
80103763:	66 90                	xchg   %ax,%ax
80103765:	66 90                	xchg   %ax,%ax
80103767:	66 90                	xchg   %ax,%ax
80103769:	66 90                	xchg   %ax,%ax
8010376b:	66 90                	xchg   %ax,%ax
8010376d:	66 90                	xchg   %ax,%ax
8010376f:	90                   	nop

80103770 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103770:	55                   	push   %ebp
80103771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103776:	ba 21 00 00 00       	mov    $0x21,%edx
8010377b:	89 e5                	mov    %esp,%ebp
8010377d:	ee                   	out    %al,(%dx)
8010377e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103783:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103784:	5d                   	pop    %ebp
80103785:	c3                   	ret    
80103786:	66 90                	xchg   %ax,%ax
80103788:	66 90                	xchg   %ax,%ax
8010378a:	66 90                	xchg   %ax,%ax
8010378c:	66 90                	xchg   %ax,%ax
8010378e:	66 90                	xchg   %ax,%ax

80103790 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	57                   	push   %edi
80103794:	56                   	push   %esi
80103795:	53                   	push   %ebx
80103796:	83 ec 0c             	sub    $0xc,%esp
80103799:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010379c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010379f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801037a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801037ab:	e8 20 db ff ff       	call   801012d0 <filealloc>
801037b0:	85 c0                	test   %eax,%eax
801037b2:	89 03                	mov    %eax,(%ebx)
801037b4:	74 22                	je     801037d8 <pipealloc+0x48>
801037b6:	e8 15 db ff ff       	call   801012d0 <filealloc>
801037bb:	85 c0                	test   %eax,%eax
801037bd:	89 06                	mov    %eax,(%esi)
801037bf:	74 3f                	je     80103800 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801037c1:	e8 4a f2 ff ff       	call   80102a10 <kalloc>
801037c6:	85 c0                	test   %eax,%eax
801037c8:	89 c7                	mov    %eax,%edi
801037ca:	75 54                	jne    80103820 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801037cc:	8b 03                	mov    (%ebx),%eax
801037ce:	85 c0                	test   %eax,%eax
801037d0:	75 34                	jne    80103806 <pipealloc+0x76>
801037d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801037d8:	8b 06                	mov    (%esi),%eax
801037da:	85 c0                	test   %eax,%eax
801037dc:	74 0c                	je     801037ea <pipealloc+0x5a>
    fileclose(*f1);
801037de:	83 ec 0c             	sub    $0xc,%esp
801037e1:	50                   	push   %eax
801037e2:	e8 a9 db ff ff       	call   80101390 <fileclose>
801037e7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801037ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801037ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801037f2:	5b                   	pop    %ebx
801037f3:	5e                   	pop    %esi
801037f4:	5f                   	pop    %edi
801037f5:	5d                   	pop    %ebp
801037f6:	c3                   	ret    
801037f7:	89 f6                	mov    %esi,%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103800:	8b 03                	mov    (%ebx),%eax
80103802:	85 c0                	test   %eax,%eax
80103804:	74 e4                	je     801037ea <pipealloc+0x5a>
    fileclose(*f0);
80103806:	83 ec 0c             	sub    $0xc,%esp
80103809:	50                   	push   %eax
8010380a:	e8 81 db ff ff       	call   80101390 <fileclose>
  if(*f1)
8010380f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103811:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103814:	85 c0                	test   %eax,%eax
80103816:	75 c6                	jne    801037de <pipealloc+0x4e>
80103818:	eb d0                	jmp    801037ea <pipealloc+0x5a>
8010381a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103820:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103823:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010382a:	00 00 00 
  p->writeopen = 1;
8010382d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103834:	00 00 00 
  p->nwrite = 0;
80103837:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010383e:	00 00 00 
  p->nread = 0;
80103841:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103848:	00 00 00 
  initlock(&p->lock, "pipe");
8010384b:	68 50 79 10 80       	push   $0x80107950
80103850:	50                   	push   %eax
80103851:	e8 fa 0e 00 00       	call   80104750 <initlock>
  (*f0)->type = FD_PIPE;
80103856:	8b 03                	mov    (%ebx),%eax
  return 0;
80103858:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010385b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103861:	8b 03                	mov    (%ebx),%eax
80103863:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103867:	8b 03                	mov    (%ebx),%eax
80103869:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010386d:	8b 03                	mov    (%ebx),%eax
8010386f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103872:	8b 06                	mov    (%esi),%eax
80103874:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010387a:	8b 06                	mov    (%esi),%eax
8010387c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103880:	8b 06                	mov    (%esi),%eax
80103882:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103886:	8b 06                	mov    (%esi),%eax
80103888:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010388b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010388e:	31 c0                	xor    %eax,%eax
}
80103890:	5b                   	pop    %ebx
80103891:	5e                   	pop    %esi
80103892:	5f                   	pop    %edi
80103893:	5d                   	pop    %ebp
80103894:	c3                   	ret    
80103895:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038a0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	56                   	push   %esi
801038a4:	53                   	push   %ebx
801038a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801038ab:	83 ec 0c             	sub    $0xc,%esp
801038ae:	53                   	push   %ebx
801038af:	e8 dc 0f 00 00       	call   80104890 <acquire>
  if(writable){
801038b4:	83 c4 10             	add    $0x10,%esp
801038b7:	85 f6                	test   %esi,%esi
801038b9:	74 45                	je     80103900 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801038bb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038c1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801038c4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801038cb:	00 00 00 
    wakeup(&p->nread);
801038ce:	50                   	push   %eax
801038cf:	e8 ac 0b 00 00       	call   80104480 <wakeup>
801038d4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801038d7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801038dd:	85 d2                	test   %edx,%edx
801038df:	75 0a                	jne    801038eb <pipeclose+0x4b>
801038e1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801038e7:	85 c0                	test   %eax,%eax
801038e9:	74 35                	je     80103920 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801038eb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801038ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038f1:	5b                   	pop    %ebx
801038f2:	5e                   	pop    %esi
801038f3:	5d                   	pop    %ebp
    release(&p->lock);
801038f4:	e9 57 10 00 00       	jmp    80104950 <release>
801038f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103900:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103906:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103909:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103910:	00 00 00 
    wakeup(&p->nwrite);
80103913:	50                   	push   %eax
80103914:	e8 67 0b 00 00       	call   80104480 <wakeup>
80103919:	83 c4 10             	add    $0x10,%esp
8010391c:	eb b9                	jmp    801038d7 <pipeclose+0x37>
8010391e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103920:	83 ec 0c             	sub    $0xc,%esp
80103923:	53                   	push   %ebx
80103924:	e8 27 10 00 00       	call   80104950 <release>
    kfree((char*)p);
80103929:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010392c:	83 c4 10             	add    $0x10,%esp
}
8010392f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103932:	5b                   	pop    %ebx
80103933:	5e                   	pop    %esi
80103934:	5d                   	pop    %ebp
    kfree((char*)p);
80103935:	e9 26 ef ff ff       	jmp    80102860 <kfree>
8010393a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103940 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	57                   	push   %edi
80103944:	56                   	push   %esi
80103945:	53                   	push   %ebx
80103946:	83 ec 28             	sub    $0x28,%esp
80103949:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010394c:	53                   	push   %ebx
8010394d:	e8 3e 0f 00 00       	call   80104890 <acquire>
  for(i = 0; i < n; i++){
80103952:	8b 45 10             	mov    0x10(%ebp),%eax
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	85 c0                	test   %eax,%eax
8010395a:	0f 8e c9 00 00 00    	jle    80103a29 <pipewrite+0xe9>
80103960:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103963:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103969:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010396f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103972:	03 4d 10             	add    0x10(%ebp),%ecx
80103975:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103978:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010397e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103984:	39 d0                	cmp    %edx,%eax
80103986:	75 71                	jne    801039f9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103988:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010398e:	85 c0                	test   %eax,%eax
80103990:	74 4e                	je     801039e0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103992:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103998:	eb 3a                	jmp    801039d4 <pipewrite+0x94>
8010399a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801039a0:	83 ec 0c             	sub    $0xc,%esp
801039a3:	57                   	push   %edi
801039a4:	e8 d7 0a 00 00       	call   80104480 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801039a9:	5a                   	pop    %edx
801039aa:	59                   	pop    %ecx
801039ab:	53                   	push   %ebx
801039ac:	56                   	push   %esi
801039ad:	e8 1e 09 00 00       	call   801042d0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039b2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801039b8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801039be:	83 c4 10             	add    $0x10,%esp
801039c1:	05 00 02 00 00       	add    $0x200,%eax
801039c6:	39 c2                	cmp    %eax,%edx
801039c8:	75 36                	jne    80103a00 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801039ca:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801039d0:	85 c0                	test   %eax,%eax
801039d2:	74 0c                	je     801039e0 <pipewrite+0xa0>
801039d4:	e8 57 03 00 00       	call   80103d30 <myproc>
801039d9:	8b 40 24             	mov    0x24(%eax),%eax
801039dc:	85 c0                	test   %eax,%eax
801039de:	74 c0                	je     801039a0 <pipewrite+0x60>
        release(&p->lock);
801039e0:	83 ec 0c             	sub    $0xc,%esp
801039e3:	53                   	push   %ebx
801039e4:	e8 67 0f 00 00       	call   80104950 <release>
        return -1;
801039e9:	83 c4 10             	add    $0x10,%esp
801039ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801039f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039f4:	5b                   	pop    %ebx
801039f5:	5e                   	pop    %esi
801039f6:	5f                   	pop    %edi
801039f7:	5d                   	pop    %ebp
801039f8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039f9:	89 c2                	mov    %eax,%edx
801039fb:	90                   	nop
801039fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103a00:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103a03:	8d 42 01             	lea    0x1(%edx),%eax
80103a06:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103a0c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103a12:	83 c6 01             	add    $0x1,%esi
80103a15:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103a19:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103a1c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103a1f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103a23:	0f 85 4f ff ff ff    	jne    80103978 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103a29:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103a2f:	83 ec 0c             	sub    $0xc,%esp
80103a32:	50                   	push   %eax
80103a33:	e8 48 0a 00 00       	call   80104480 <wakeup>
  release(&p->lock);
80103a38:	89 1c 24             	mov    %ebx,(%esp)
80103a3b:	e8 10 0f 00 00       	call   80104950 <release>
  return n;
80103a40:	83 c4 10             	add    $0x10,%esp
80103a43:	8b 45 10             	mov    0x10(%ebp),%eax
80103a46:	eb a9                	jmp    801039f1 <pipewrite+0xb1>
80103a48:	90                   	nop
80103a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a50 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	57                   	push   %edi
80103a54:	56                   	push   %esi
80103a55:	53                   	push   %ebx
80103a56:	83 ec 18             	sub    $0x18,%esp
80103a59:	8b 75 08             	mov    0x8(%ebp),%esi
80103a5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a5f:	56                   	push   %esi
80103a60:	e8 2b 0e 00 00       	call   80104890 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a65:	83 c4 10             	add    $0x10,%esp
80103a68:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a6e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a74:	75 6a                	jne    80103ae0 <piperead+0x90>
80103a76:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103a7c:	85 db                	test   %ebx,%ebx
80103a7e:	0f 84 c4 00 00 00    	je     80103b48 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a84:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a8a:	eb 2d                	jmp    80103ab9 <piperead+0x69>
80103a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a90:	83 ec 08             	sub    $0x8,%esp
80103a93:	56                   	push   %esi
80103a94:	53                   	push   %ebx
80103a95:	e8 36 08 00 00       	call   801042d0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a9a:	83 c4 10             	add    $0x10,%esp
80103a9d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103aa3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103aa9:	75 35                	jne    80103ae0 <piperead+0x90>
80103aab:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103ab1:	85 d2                	test   %edx,%edx
80103ab3:	0f 84 8f 00 00 00    	je     80103b48 <piperead+0xf8>
    if(myproc()->killed){
80103ab9:	e8 72 02 00 00       	call   80103d30 <myproc>
80103abe:	8b 48 24             	mov    0x24(%eax),%ecx
80103ac1:	85 c9                	test   %ecx,%ecx
80103ac3:	74 cb                	je     80103a90 <piperead+0x40>
      release(&p->lock);
80103ac5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ac8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103acd:	56                   	push   %esi
80103ace:	e8 7d 0e 00 00       	call   80104950 <release>
      return -1;
80103ad3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103ad6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ad9:	89 d8                	mov    %ebx,%eax
80103adb:	5b                   	pop    %ebx
80103adc:	5e                   	pop    %esi
80103add:	5f                   	pop    %edi
80103ade:	5d                   	pop    %ebp
80103adf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ae0:	8b 45 10             	mov    0x10(%ebp),%eax
80103ae3:	85 c0                	test   %eax,%eax
80103ae5:	7e 61                	jle    80103b48 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103ae7:	31 db                	xor    %ebx,%ebx
80103ae9:	eb 13                	jmp    80103afe <piperead+0xae>
80103aeb:	90                   	nop
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103af0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103af6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103afc:	74 1f                	je     80103b1d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103afe:	8d 41 01             	lea    0x1(%ecx),%eax
80103b01:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103b07:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103b0d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103b12:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103b15:	83 c3 01             	add    $0x1,%ebx
80103b18:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103b1b:	75 d3                	jne    80103af0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103b1d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103b23:	83 ec 0c             	sub    $0xc,%esp
80103b26:	50                   	push   %eax
80103b27:	e8 54 09 00 00       	call   80104480 <wakeup>
  release(&p->lock);
80103b2c:	89 34 24             	mov    %esi,(%esp)
80103b2f:	e8 1c 0e 00 00       	call   80104950 <release>
  return i;
80103b34:	83 c4 10             	add    $0x10,%esp
}
80103b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b3a:	89 d8                	mov    %ebx,%eax
80103b3c:	5b                   	pop    %ebx
80103b3d:	5e                   	pop    %esi
80103b3e:	5f                   	pop    %edi
80103b3f:	5d                   	pop    %ebp
80103b40:	c3                   	ret    
80103b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b48:	31 db                	xor    %ebx,%ebx
80103b4a:	eb d1                	jmp    80103b1d <piperead+0xcd>
80103b4c:	66 90                	xchg   %ax,%ax
80103b4e:	66 90                	xchg   %ax,%ax

80103b50 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b54:	bb 74 35 11 80       	mov    $0x80113574,%ebx
{
80103b59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103b5c:	68 40 35 11 80       	push   $0x80113540
80103b61:	e8 2a 0d 00 00       	call   80104890 <acquire>
80103b66:	83 c4 10             	add    $0x10,%esp
80103b69:	eb 10                	jmp    80103b7b <allocproc+0x2b>
80103b6b:	90                   	nop
80103b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b70:	83 c3 7c             	add    $0x7c,%ebx
80103b73:	81 fb 74 54 11 80    	cmp    $0x80115474,%ebx
80103b79:	73 75                	jae    80103bf0 <allocproc+0xa0>
    if(p->state == UNUSED)
80103b7b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103b7e:	85 c0                	test   %eax,%eax
80103b80:	75 ee                	jne    80103b70 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103b82:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103b87:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103b8a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103b91:	8d 50 01             	lea    0x1(%eax),%edx
80103b94:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103b97:	68 40 35 11 80       	push   $0x80113540
  p->pid = nextpid++;
80103b9c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103ba2:	e8 a9 0d 00 00       	call   80104950 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103ba7:	e8 64 ee ff ff       	call   80102a10 <kalloc>
80103bac:	83 c4 10             	add    $0x10,%esp
80103baf:	85 c0                	test   %eax,%eax
80103bb1:	89 43 08             	mov    %eax,0x8(%ebx)
80103bb4:	74 53                	je     80103c09 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103bb6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103bbc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103bbf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103bc4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103bc7:	c7 40 14 92 5b 10 80 	movl   $0x80105b92,0x14(%eax)
  p->context = (struct context*)sp;
80103bce:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103bd1:	6a 14                	push   $0x14
80103bd3:	6a 00                	push   $0x0
80103bd5:	50                   	push   %eax
80103bd6:	e8 c5 0d 00 00       	call   801049a0 <memset>
  p->context->eip = (uint)forkret;
80103bdb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103bde:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103be1:	c7 40 10 20 3c 10 80 	movl   $0x80103c20,0x10(%eax)
}
80103be8:	89 d8                	mov    %ebx,%eax
80103bea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bed:	c9                   	leave  
80103bee:	c3                   	ret    
80103bef:	90                   	nop
  release(&ptable.lock);
80103bf0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103bf3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103bf5:	68 40 35 11 80       	push   $0x80113540
80103bfa:	e8 51 0d 00 00       	call   80104950 <release>
}
80103bff:	89 d8                	mov    %ebx,%eax
  return 0;
80103c01:	83 c4 10             	add    $0x10,%esp
}
80103c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c07:	c9                   	leave  
80103c08:	c3                   	ret    
    p->state = UNUSED;
80103c09:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103c10:	31 db                	xor    %ebx,%ebx
80103c12:	eb d4                	jmp    80103be8 <allocproc+0x98>
80103c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c20 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103c26:	68 40 35 11 80       	push   $0x80113540
80103c2b:	e8 20 0d 00 00       	call   80104950 <release>

  if (first) {
80103c30:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103c35:	83 c4 10             	add    $0x10,%esp
80103c38:	85 c0                	test   %eax,%eax
80103c3a:	75 04                	jne    80103c40 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103c3c:	c9                   	leave  
80103c3d:	c3                   	ret    
80103c3e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103c40:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103c43:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103c4a:	00 00 00 
    iinit(ROOTDEV);
80103c4d:	6a 01                	push   $0x1
80103c4f:	e8 7c dd ff ff       	call   801019d0 <iinit>
    initlog(ROOTDEV);
80103c54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103c5b:	e8 f0 f3 ff ff       	call   80103050 <initlog>
80103c60:	83 c4 10             	add    $0x10,%esp
}
80103c63:	c9                   	leave  
80103c64:	c3                   	ret    
80103c65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c70 <pinit>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103c76:	68 55 79 10 80       	push   $0x80107955
80103c7b:	68 40 35 11 80       	push   $0x80113540
80103c80:	e8 cb 0a 00 00       	call   80104750 <initlock>
}
80103c85:	83 c4 10             	add    $0x10,%esp
80103c88:	c9                   	leave  
80103c89:	c3                   	ret    
80103c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c90 <mycpu>:
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	56                   	push   %esi
80103c94:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c95:	9c                   	pushf  
80103c96:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c97:	f6 c4 02             	test   $0x2,%ah
80103c9a:	75 5e                	jne    80103cfa <mycpu+0x6a>
  apicid = lapicid();
80103c9c:	e8 df ef ff ff       	call   80102c80 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ca1:	8b 35 20 35 11 80    	mov    0x80113520,%esi
80103ca7:	85 f6                	test   %esi,%esi
80103ca9:	7e 42                	jle    80103ced <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103cab:	0f b6 15 a0 2f 11 80 	movzbl 0x80112fa0,%edx
80103cb2:	39 d0                	cmp    %edx,%eax
80103cb4:	74 30                	je     80103ce6 <mycpu+0x56>
80103cb6:	b9 50 30 11 80       	mov    $0x80113050,%ecx
  for (i = 0; i < ncpu; ++i) {
80103cbb:	31 d2                	xor    %edx,%edx
80103cbd:	8d 76 00             	lea    0x0(%esi),%esi
80103cc0:	83 c2 01             	add    $0x1,%edx
80103cc3:	39 f2                	cmp    %esi,%edx
80103cc5:	74 26                	je     80103ced <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103cc7:	0f b6 19             	movzbl (%ecx),%ebx
80103cca:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103cd0:	39 c3                	cmp    %eax,%ebx
80103cd2:	75 ec                	jne    80103cc0 <mycpu+0x30>
80103cd4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103cda:	05 a0 2f 11 80       	add    $0x80112fa0,%eax
}
80103cdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ce2:	5b                   	pop    %ebx
80103ce3:	5e                   	pop    %esi
80103ce4:	5d                   	pop    %ebp
80103ce5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103ce6:	b8 a0 2f 11 80       	mov    $0x80112fa0,%eax
      return &cpus[i];
80103ceb:	eb f2                	jmp    80103cdf <mycpu+0x4f>
  panic("unknown apicid\n");
80103ced:	83 ec 0c             	sub    $0xc,%esp
80103cf0:	68 5c 79 10 80       	push   $0x8010795c
80103cf5:	e8 06 c8 ff ff       	call   80100500 <panic>
    panic("mycpu called with interrupts enabled\n");
80103cfa:	83 ec 0c             	sub    $0xc,%esp
80103cfd:	68 38 7a 10 80       	push   $0x80107a38
80103d02:	e8 f9 c7 ff ff       	call   80100500 <panic>
80103d07:	89 f6                	mov    %esi,%esi
80103d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d10 <cpuid>:
cpuid() {
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103d16:	e8 75 ff ff ff       	call   80103c90 <mycpu>
80103d1b:	2d a0 2f 11 80       	sub    $0x80112fa0,%eax
}
80103d20:	c9                   	leave  
  return mycpu()-cpus;
80103d21:	c1 f8 04             	sar    $0x4,%eax
80103d24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103d2a:	c3                   	ret    
80103d2b:	90                   	nop
80103d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d30 <myproc>:
myproc(void) {
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	53                   	push   %ebx
80103d34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103d37:	e8 84 0a 00 00       	call   801047c0 <pushcli>
  c = mycpu();
80103d3c:	e8 4f ff ff ff       	call   80103c90 <mycpu>
  p = c->proc;
80103d41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d47:	e8 b4 0a 00 00       	call   80104800 <popcli>
}
80103d4c:	83 c4 04             	add    $0x4,%esp
80103d4f:	89 d8                	mov    %ebx,%eax
80103d51:	5b                   	pop    %ebx
80103d52:	5d                   	pop    %ebp
80103d53:	c3                   	ret    
80103d54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d60 <userinit>:
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	53                   	push   %ebx
80103d64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103d67:	e8 e4 fd ff ff       	call   80103b50 <allocproc>
80103d6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103d6e:	a3 d8 a5 10 80       	mov    %eax,0x8010a5d8
  if((p->pgdir = setupkvm()) == 0)
80103d73:	e8 e8 33 00 00       	call   80107160 <setupkvm>
80103d78:	85 c0                	test   %eax,%eax
80103d7a:	89 43 04             	mov    %eax,0x4(%ebx)
80103d7d:	0f 84 bd 00 00 00    	je     80103e40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d83:	83 ec 04             	sub    $0x4,%esp
80103d86:	68 2c 00 00 00       	push   $0x2c
80103d8b:	68 60 a4 10 80       	push   $0x8010a460
80103d90:	50                   	push   %eax
80103d91:	e8 aa 30 00 00       	call   80106e40 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103d96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103d99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103d9f:	6a 4c                	push   $0x4c
80103da1:	6a 00                	push   $0x0
80103da3:	ff 73 18             	pushl  0x18(%ebx)
80103da6:	e8 f5 0b 00 00       	call   801049a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103dab:	8b 43 18             	mov    0x18(%ebx),%eax
80103dae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103db3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103db8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103dbb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103dbf:	8b 43 18             	mov    0x18(%ebx),%eax
80103dc2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103dc6:	8b 43 18             	mov    0x18(%ebx),%eax
80103dc9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103dcd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103dd1:	8b 43 18             	mov    0x18(%ebx),%eax
80103dd4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103dd8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ddc:	8b 43 18             	mov    0x18(%ebx),%eax
80103ddf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103de6:	8b 43 18             	mov    0x18(%ebx),%eax
80103de9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103df0:	8b 43 18             	mov    0x18(%ebx),%eax
80103df3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103dfa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103dfd:	6a 10                	push   $0x10
80103dff:	68 85 79 10 80       	push   $0x80107985
80103e04:	50                   	push   %eax
80103e05:	e8 76 0d 00 00       	call   80104b80 <safestrcpy>
  p->cwd = namei("/");
80103e0a:	c7 04 24 8e 79 10 80 	movl   $0x8010798e,(%esp)
80103e11:	e8 1a e6 ff ff       	call   80102430 <namei>
80103e16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103e19:	c7 04 24 40 35 11 80 	movl   $0x80113540,(%esp)
80103e20:	e8 6b 0a 00 00       	call   80104890 <acquire>
  p->state = RUNNABLE;
80103e25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103e2c:	c7 04 24 40 35 11 80 	movl   $0x80113540,(%esp)
80103e33:	e8 18 0b 00 00       	call   80104950 <release>
}
80103e38:	83 c4 10             	add    $0x10,%esp
80103e3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e3e:	c9                   	leave  
80103e3f:	c3                   	ret    
    panic("userinit: out of memory?");
80103e40:	83 ec 0c             	sub    $0xc,%esp
80103e43:	68 6c 79 10 80       	push   $0x8010796c
80103e48:	e8 b3 c6 ff ff       	call   80100500 <panic>
80103e4d:	8d 76 00             	lea    0x0(%esi),%esi

80103e50 <growproc>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	56                   	push   %esi
80103e54:	53                   	push   %ebx
80103e55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103e58:	e8 63 09 00 00       	call   801047c0 <pushcli>
  c = mycpu();
80103e5d:	e8 2e fe ff ff       	call   80103c90 <mycpu>
  p = c->proc;
80103e62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e68:	e8 93 09 00 00       	call   80104800 <popcli>
  if(n > 0){
80103e6d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103e70:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103e72:	7f 1c                	jg     80103e90 <growproc+0x40>
  } else if(n < 0){
80103e74:	75 3a                	jne    80103eb0 <growproc+0x60>
  switchuvm(curproc);
80103e76:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103e79:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103e7b:	53                   	push   %ebx
80103e7c:	e8 af 2e 00 00       	call   80106d30 <switchuvm>
  return 0;
80103e81:	83 c4 10             	add    $0x10,%esp
80103e84:	31 c0                	xor    %eax,%eax
}
80103e86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e89:	5b                   	pop    %ebx
80103e8a:	5e                   	pop    %esi
80103e8b:	5d                   	pop    %ebp
80103e8c:	c3                   	ret    
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e90:	83 ec 04             	sub    $0x4,%esp
80103e93:	01 c6                	add    %eax,%esi
80103e95:	56                   	push   %esi
80103e96:	50                   	push   %eax
80103e97:	ff 73 04             	pushl  0x4(%ebx)
80103e9a:	e8 e1 30 00 00       	call   80106f80 <allocuvm>
80103e9f:	83 c4 10             	add    $0x10,%esp
80103ea2:	85 c0                	test   %eax,%eax
80103ea4:	75 d0                	jne    80103e76 <growproc+0x26>
      return -1;
80103ea6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103eab:	eb d9                	jmp    80103e86 <growproc+0x36>
80103ead:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103eb0:	83 ec 04             	sub    $0x4,%esp
80103eb3:	01 c6                	add    %eax,%esi
80103eb5:	56                   	push   %esi
80103eb6:	50                   	push   %eax
80103eb7:	ff 73 04             	pushl  0x4(%ebx)
80103eba:	e8 f1 31 00 00       	call   801070b0 <deallocuvm>
80103ebf:	83 c4 10             	add    $0x10,%esp
80103ec2:	85 c0                	test   %eax,%eax
80103ec4:	75 b0                	jne    80103e76 <growproc+0x26>
80103ec6:	eb de                	jmp    80103ea6 <growproc+0x56>
80103ec8:	90                   	nop
80103ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ed0 <fork>:
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	57                   	push   %edi
80103ed4:	56                   	push   %esi
80103ed5:	53                   	push   %ebx
80103ed6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ed9:	e8 e2 08 00 00       	call   801047c0 <pushcli>
  c = mycpu();
80103ede:	e8 ad fd ff ff       	call   80103c90 <mycpu>
  p = c->proc;
80103ee3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ee9:	e8 12 09 00 00       	call   80104800 <popcli>
  if((np = allocproc()) == 0){
80103eee:	e8 5d fc ff ff       	call   80103b50 <allocproc>
80103ef3:	85 c0                	test   %eax,%eax
80103ef5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ef8:	0f 84 b7 00 00 00    	je     80103fb5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103efe:	83 ec 08             	sub    $0x8,%esp
80103f01:	ff 33                	pushl  (%ebx)
80103f03:	ff 73 04             	pushl  0x4(%ebx)
80103f06:	89 c7                	mov    %eax,%edi
80103f08:	e8 23 33 00 00       	call   80107230 <copyuvm>
80103f0d:	83 c4 10             	add    $0x10,%esp
80103f10:	85 c0                	test   %eax,%eax
80103f12:	89 47 04             	mov    %eax,0x4(%edi)
80103f15:	0f 84 a1 00 00 00    	je     80103fbc <fork+0xec>
  np->sz = curproc->sz;
80103f1b:	8b 03                	mov    (%ebx),%eax
80103f1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103f20:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103f22:	89 59 14             	mov    %ebx,0x14(%ecx)
80103f25:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103f27:	8b 79 18             	mov    0x18(%ecx),%edi
80103f2a:	8b 73 18             	mov    0x18(%ebx),%esi
80103f2d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103f32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103f34:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103f36:	8b 40 18             	mov    0x18(%eax),%eax
80103f39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103f40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f44:	85 c0                	test   %eax,%eax
80103f46:	74 13                	je     80103f5b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f48:	83 ec 0c             	sub    $0xc,%esp
80103f4b:	50                   	push   %eax
80103f4c:	e8 ef d3 ff ff       	call   80101340 <filedup>
80103f51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f54:	83 c4 10             	add    $0x10,%esp
80103f57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103f5b:	83 c6 01             	add    $0x1,%esi
80103f5e:	83 fe 10             	cmp    $0x10,%esi
80103f61:	75 dd                	jne    80103f40 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103f63:	83 ec 0c             	sub    $0xc,%esp
80103f66:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f69:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103f6c:	e8 2f dc ff ff       	call   80101ba0 <idup>
80103f71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f74:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103f77:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f7d:	6a 10                	push   $0x10
80103f7f:	53                   	push   %ebx
80103f80:	50                   	push   %eax
80103f81:	e8 fa 0b 00 00       	call   80104b80 <safestrcpy>
  pid = np->pid;
80103f86:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103f89:	c7 04 24 40 35 11 80 	movl   $0x80113540,(%esp)
80103f90:	e8 fb 08 00 00       	call   80104890 <acquire>
  np->state = RUNNABLE;
80103f95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103f9c:	c7 04 24 40 35 11 80 	movl   $0x80113540,(%esp)
80103fa3:	e8 a8 09 00 00       	call   80104950 <release>
  return pid;
80103fa8:	83 c4 10             	add    $0x10,%esp
}
80103fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fae:	89 d8                	mov    %ebx,%eax
80103fb0:	5b                   	pop    %ebx
80103fb1:	5e                   	pop    %esi
80103fb2:	5f                   	pop    %edi
80103fb3:	5d                   	pop    %ebp
80103fb4:	c3                   	ret    
    return -1;
80103fb5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103fba:	eb ef                	jmp    80103fab <fork+0xdb>
    kfree(np->kstack);
80103fbc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103fbf:	83 ec 0c             	sub    $0xc,%esp
80103fc2:	ff 73 08             	pushl  0x8(%ebx)
80103fc5:	e8 96 e8 ff ff       	call   80102860 <kfree>
    np->kstack = 0;
80103fca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103fd1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103fd8:	83 c4 10             	add    $0x10,%esp
80103fdb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103fe0:	eb c9                	jmp    80103fab <fork+0xdb>
80103fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ff0 <scheduler>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	57                   	push   %edi
80103ff4:	56                   	push   %esi
80103ff5:	53                   	push   %ebx
80103ff6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ff9:	e8 92 fc ff ff       	call   80103c90 <mycpu>
80103ffe:	8d 78 04             	lea    0x4(%eax),%edi
80104001:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104003:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010400a:	00 00 00 
8010400d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104010:	fb                   	sti    
    acquire(&ptable.lock);
80104011:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104014:	bb 74 35 11 80       	mov    $0x80113574,%ebx
    acquire(&ptable.lock);
80104019:	68 40 35 11 80       	push   $0x80113540
8010401e:	e8 6d 08 00 00       	call   80104890 <acquire>
80104023:	83 c4 10             	add    $0x10,%esp
80104026:	8d 76 00             	lea    0x0(%esi),%esi
80104029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104030:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104034:	75 33                	jne    80104069 <scheduler+0x79>
      switchuvm(p);
80104036:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104039:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010403f:	53                   	push   %ebx
80104040:	e8 eb 2c 00 00       	call   80106d30 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104045:	58                   	pop    %eax
80104046:	5a                   	pop    %edx
80104047:	ff 73 1c             	pushl  0x1c(%ebx)
8010404a:	57                   	push   %edi
      p->state = RUNNING;
8010404b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104052:	e8 84 0b 00 00       	call   80104bdb <swtch>
      switchkvm();
80104057:	e8 b4 2c 00 00       	call   80106d10 <switchkvm>
      c->proc = 0;
8010405c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104063:	00 00 00 
80104066:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104069:	83 c3 7c             	add    $0x7c,%ebx
8010406c:	81 fb 74 54 11 80    	cmp    $0x80115474,%ebx
80104072:	72 bc                	jb     80104030 <scheduler+0x40>
    release(&ptable.lock);
80104074:	83 ec 0c             	sub    $0xc,%esp
80104077:	68 40 35 11 80       	push   $0x80113540
8010407c:	e8 cf 08 00 00       	call   80104950 <release>
    sti();
80104081:	83 c4 10             	add    $0x10,%esp
80104084:	eb 8a                	jmp    80104010 <scheduler+0x20>
80104086:	8d 76 00             	lea    0x0(%esi),%esi
80104089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104090 <sched>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	56                   	push   %esi
80104094:	53                   	push   %ebx
  pushcli();
80104095:	e8 26 07 00 00       	call   801047c0 <pushcli>
  c = mycpu();
8010409a:	e8 f1 fb ff ff       	call   80103c90 <mycpu>
  p = c->proc;
8010409f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040a5:	e8 56 07 00 00       	call   80104800 <popcli>
  if(!holding(&ptable.lock))
801040aa:	83 ec 0c             	sub    $0xc,%esp
801040ad:	68 40 35 11 80       	push   $0x80113540
801040b2:	e8 a9 07 00 00       	call   80104860 <holding>
801040b7:	83 c4 10             	add    $0x10,%esp
801040ba:	85 c0                	test   %eax,%eax
801040bc:	74 4f                	je     8010410d <sched+0x7d>
  if(mycpu()->ncli != 1)
801040be:	e8 cd fb ff ff       	call   80103c90 <mycpu>
801040c3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801040ca:	75 68                	jne    80104134 <sched+0xa4>
  if(p->state == RUNNING)
801040cc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801040d0:	74 55                	je     80104127 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040d2:	9c                   	pushf  
801040d3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801040d4:	f6 c4 02             	test   $0x2,%ah
801040d7:	75 41                	jne    8010411a <sched+0x8a>
  intena = mycpu()->intena;
801040d9:	e8 b2 fb ff ff       	call   80103c90 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801040de:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801040e1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801040e7:	e8 a4 fb ff ff       	call   80103c90 <mycpu>
801040ec:	83 ec 08             	sub    $0x8,%esp
801040ef:	ff 70 04             	pushl  0x4(%eax)
801040f2:	53                   	push   %ebx
801040f3:	e8 e3 0a 00 00       	call   80104bdb <swtch>
  mycpu()->intena = intena;
801040f8:	e8 93 fb ff ff       	call   80103c90 <mycpu>
}
801040fd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104100:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104106:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104109:	5b                   	pop    %ebx
8010410a:	5e                   	pop    %esi
8010410b:	5d                   	pop    %ebp
8010410c:	c3                   	ret    
    panic("sched ptable.lock");
8010410d:	83 ec 0c             	sub    $0xc,%esp
80104110:	68 90 79 10 80       	push   $0x80107990
80104115:	e8 e6 c3 ff ff       	call   80100500 <panic>
    panic("sched interruptible");
8010411a:	83 ec 0c             	sub    $0xc,%esp
8010411d:	68 bc 79 10 80       	push   $0x801079bc
80104122:	e8 d9 c3 ff ff       	call   80100500 <panic>
    panic("sched running");
80104127:	83 ec 0c             	sub    $0xc,%esp
8010412a:	68 ae 79 10 80       	push   $0x801079ae
8010412f:	e8 cc c3 ff ff       	call   80100500 <panic>
    panic("sched locks");
80104134:	83 ec 0c             	sub    $0xc,%esp
80104137:	68 a2 79 10 80       	push   $0x801079a2
8010413c:	e8 bf c3 ff ff       	call   80100500 <panic>
80104141:	eb 0d                	jmp    80104150 <exit>
80104143:	90                   	nop
80104144:	90                   	nop
80104145:	90                   	nop
80104146:	90                   	nop
80104147:	90                   	nop
80104148:	90                   	nop
80104149:	90                   	nop
8010414a:	90                   	nop
8010414b:	90                   	nop
8010414c:	90                   	nop
8010414d:	90                   	nop
8010414e:	90                   	nop
8010414f:	90                   	nop

80104150 <exit>:
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	57                   	push   %edi
80104154:	56                   	push   %esi
80104155:	53                   	push   %ebx
80104156:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104159:	e8 62 06 00 00       	call   801047c0 <pushcli>
  c = mycpu();
8010415e:	e8 2d fb ff ff       	call   80103c90 <mycpu>
  p = c->proc;
80104163:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104169:	e8 92 06 00 00       	call   80104800 <popcli>
  if(curproc == initproc)
8010416e:	39 35 d8 a5 10 80    	cmp    %esi,0x8010a5d8
80104174:	8d 5e 28             	lea    0x28(%esi),%ebx
80104177:	8d 7e 68             	lea    0x68(%esi),%edi
8010417a:	0f 84 e7 00 00 00    	je     80104267 <exit+0x117>
    if(curproc->ofile[fd]){
80104180:	8b 03                	mov    (%ebx),%eax
80104182:	85 c0                	test   %eax,%eax
80104184:	74 12                	je     80104198 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104186:	83 ec 0c             	sub    $0xc,%esp
80104189:	50                   	push   %eax
8010418a:	e8 01 d2 ff ff       	call   80101390 <fileclose>
      curproc->ofile[fd] = 0;
8010418f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104195:	83 c4 10             	add    $0x10,%esp
80104198:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010419b:	39 fb                	cmp    %edi,%ebx
8010419d:	75 e1                	jne    80104180 <exit+0x30>
  begin_op();
8010419f:	e8 4c ef ff ff       	call   801030f0 <begin_op>
  iput(curproc->cwd);
801041a4:	83 ec 0c             	sub    $0xc,%esp
801041a7:	ff 76 68             	pushl  0x68(%esi)
801041aa:	e8 51 db ff ff       	call   80101d00 <iput>
  end_op();
801041af:	e8 ac ef ff ff       	call   80103160 <end_op>
  curproc->cwd = 0;
801041b4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801041bb:	c7 04 24 40 35 11 80 	movl   $0x80113540,(%esp)
801041c2:	e8 c9 06 00 00       	call   80104890 <acquire>
  wakeup1(curproc->parent);
801041c7:	8b 56 14             	mov    0x14(%esi),%edx
801041ca:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041cd:	b8 74 35 11 80       	mov    $0x80113574,%eax
801041d2:	eb 0e                	jmp    801041e2 <exit+0x92>
801041d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041d8:	83 c0 7c             	add    $0x7c,%eax
801041db:	3d 74 54 11 80       	cmp    $0x80115474,%eax
801041e0:	73 1c                	jae    801041fe <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
801041e2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041e6:	75 f0                	jne    801041d8 <exit+0x88>
801041e8:	3b 50 20             	cmp    0x20(%eax),%edx
801041eb:	75 eb                	jne    801041d8 <exit+0x88>
      p->state = RUNNABLE;
801041ed:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041f4:	83 c0 7c             	add    $0x7c,%eax
801041f7:	3d 74 54 11 80       	cmp    $0x80115474,%eax
801041fc:	72 e4                	jb     801041e2 <exit+0x92>
      p->parent = initproc;
801041fe:	8b 0d d8 a5 10 80    	mov    0x8010a5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104204:	ba 74 35 11 80       	mov    $0x80113574,%edx
80104209:	eb 10                	jmp    8010421b <exit+0xcb>
8010420b:	90                   	nop
8010420c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104210:	83 c2 7c             	add    $0x7c,%edx
80104213:	81 fa 74 54 11 80    	cmp    $0x80115474,%edx
80104219:	73 33                	jae    8010424e <exit+0xfe>
    if(p->parent == curproc){
8010421b:	39 72 14             	cmp    %esi,0x14(%edx)
8010421e:	75 f0                	jne    80104210 <exit+0xc0>
      if(p->state == ZOMBIE)
80104220:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104224:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104227:	75 e7                	jne    80104210 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104229:	b8 74 35 11 80       	mov    $0x80113574,%eax
8010422e:	eb 0a                	jmp    8010423a <exit+0xea>
80104230:	83 c0 7c             	add    $0x7c,%eax
80104233:	3d 74 54 11 80       	cmp    $0x80115474,%eax
80104238:	73 d6                	jae    80104210 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
8010423a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010423e:	75 f0                	jne    80104230 <exit+0xe0>
80104240:	3b 48 20             	cmp    0x20(%eax),%ecx
80104243:	75 eb                	jne    80104230 <exit+0xe0>
      p->state = RUNNABLE;
80104245:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010424c:	eb e2                	jmp    80104230 <exit+0xe0>
  curproc->state = ZOMBIE;
8010424e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104255:	e8 36 fe ff ff       	call   80104090 <sched>
  panic("zombie exit");
8010425a:	83 ec 0c             	sub    $0xc,%esp
8010425d:	68 dd 79 10 80       	push   $0x801079dd
80104262:	e8 99 c2 ff ff       	call   80100500 <panic>
    panic("init exiting");
80104267:	83 ec 0c             	sub    $0xc,%esp
8010426a:	68 d0 79 10 80       	push   $0x801079d0
8010426f:	e8 8c c2 ff ff       	call   80100500 <panic>
80104274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010427a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104280 <yield>:
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	53                   	push   %ebx
80104284:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104287:	68 40 35 11 80       	push   $0x80113540
8010428c:	e8 ff 05 00 00       	call   80104890 <acquire>
  pushcli();
80104291:	e8 2a 05 00 00       	call   801047c0 <pushcli>
  c = mycpu();
80104296:	e8 f5 f9 ff ff       	call   80103c90 <mycpu>
  p = c->proc;
8010429b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042a1:	e8 5a 05 00 00       	call   80104800 <popcli>
  myproc()->state = RUNNABLE;
801042a6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801042ad:	e8 de fd ff ff       	call   80104090 <sched>
  release(&ptable.lock);
801042b2:	c7 04 24 40 35 11 80 	movl   $0x80113540,(%esp)
801042b9:	e8 92 06 00 00       	call   80104950 <release>
}
801042be:	83 c4 10             	add    $0x10,%esp
801042c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042c4:	c9                   	leave  
801042c5:	c3                   	ret    
801042c6:	8d 76 00             	lea    0x0(%esi),%esi
801042c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042d0 <sleep>:
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	57                   	push   %edi
801042d4:	56                   	push   %esi
801042d5:	53                   	push   %ebx
801042d6:	83 ec 0c             	sub    $0xc,%esp
801042d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801042dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801042df:	e8 dc 04 00 00       	call   801047c0 <pushcli>
  c = mycpu();
801042e4:	e8 a7 f9 ff ff       	call   80103c90 <mycpu>
  p = c->proc;
801042e9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042ef:	e8 0c 05 00 00       	call   80104800 <popcli>
  if(p == 0)
801042f4:	85 db                	test   %ebx,%ebx
801042f6:	0f 84 87 00 00 00    	je     80104383 <sleep+0xb3>
  if(lk == 0)
801042fc:	85 f6                	test   %esi,%esi
801042fe:	74 76                	je     80104376 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104300:	81 fe 40 35 11 80    	cmp    $0x80113540,%esi
80104306:	74 50                	je     80104358 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104308:	83 ec 0c             	sub    $0xc,%esp
8010430b:	68 40 35 11 80       	push   $0x80113540
80104310:	e8 7b 05 00 00       	call   80104890 <acquire>
    release(lk);
80104315:	89 34 24             	mov    %esi,(%esp)
80104318:	e8 33 06 00 00       	call   80104950 <release>
  p->chan = chan;
8010431d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104320:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104327:	e8 64 fd ff ff       	call   80104090 <sched>
  p->chan = 0;
8010432c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104333:	c7 04 24 40 35 11 80 	movl   $0x80113540,(%esp)
8010433a:	e8 11 06 00 00       	call   80104950 <release>
    acquire(lk);
8010433f:	89 75 08             	mov    %esi,0x8(%ebp)
80104342:	83 c4 10             	add    $0x10,%esp
}
80104345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104348:	5b                   	pop    %ebx
80104349:	5e                   	pop    %esi
8010434a:	5f                   	pop    %edi
8010434b:	5d                   	pop    %ebp
    acquire(lk);
8010434c:	e9 3f 05 00 00       	jmp    80104890 <acquire>
80104351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104358:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010435b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104362:	e8 29 fd ff ff       	call   80104090 <sched>
  p->chan = 0;
80104367:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010436e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104371:	5b                   	pop    %ebx
80104372:	5e                   	pop    %esi
80104373:	5f                   	pop    %edi
80104374:	5d                   	pop    %ebp
80104375:	c3                   	ret    
    panic("sleep without lk");
80104376:	83 ec 0c             	sub    $0xc,%esp
80104379:	68 ef 79 10 80       	push   $0x801079ef
8010437e:	e8 7d c1 ff ff       	call   80100500 <panic>
    panic("sleep");
80104383:	83 ec 0c             	sub    $0xc,%esp
80104386:	68 e9 79 10 80       	push   $0x801079e9
8010438b:	e8 70 c1 ff ff       	call   80100500 <panic>

80104390 <wait>:
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	56                   	push   %esi
80104394:	53                   	push   %ebx
  pushcli();
80104395:	e8 26 04 00 00       	call   801047c0 <pushcli>
  c = mycpu();
8010439a:	e8 f1 f8 ff ff       	call   80103c90 <mycpu>
  p = c->proc;
8010439f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801043a5:	e8 56 04 00 00       	call   80104800 <popcli>
  acquire(&ptable.lock);
801043aa:	83 ec 0c             	sub    $0xc,%esp
801043ad:	68 40 35 11 80       	push   $0x80113540
801043b2:	e8 d9 04 00 00       	call   80104890 <acquire>
801043b7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801043ba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043bc:	bb 74 35 11 80       	mov    $0x80113574,%ebx
801043c1:	eb 10                	jmp    801043d3 <wait+0x43>
801043c3:	90                   	nop
801043c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043c8:	83 c3 7c             	add    $0x7c,%ebx
801043cb:	81 fb 74 54 11 80    	cmp    $0x80115474,%ebx
801043d1:	73 1b                	jae    801043ee <wait+0x5e>
      if(p->parent != curproc)
801043d3:	39 73 14             	cmp    %esi,0x14(%ebx)
801043d6:	75 f0                	jne    801043c8 <wait+0x38>
      if(p->state == ZOMBIE){
801043d8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801043dc:	74 32                	je     80104410 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043de:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801043e1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043e6:	81 fb 74 54 11 80    	cmp    $0x80115474,%ebx
801043ec:	72 e5                	jb     801043d3 <wait+0x43>
    if(!havekids || curproc->killed){
801043ee:	85 c0                	test   %eax,%eax
801043f0:	74 74                	je     80104466 <wait+0xd6>
801043f2:	8b 46 24             	mov    0x24(%esi),%eax
801043f5:	85 c0                	test   %eax,%eax
801043f7:	75 6d                	jne    80104466 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801043f9:	83 ec 08             	sub    $0x8,%esp
801043fc:	68 40 35 11 80       	push   $0x80113540
80104401:	56                   	push   %esi
80104402:	e8 c9 fe ff ff       	call   801042d0 <sleep>
    havekids = 0;
80104407:	83 c4 10             	add    $0x10,%esp
8010440a:	eb ae                	jmp    801043ba <wait+0x2a>
8010440c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104410:	83 ec 0c             	sub    $0xc,%esp
80104413:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104416:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104419:	e8 42 e4 ff ff       	call   80102860 <kfree>
        freevm(p->pgdir);
8010441e:	5a                   	pop    %edx
8010441f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104422:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104429:	e8 b2 2c 00 00       	call   801070e0 <freevm>
        release(&ptable.lock);
8010442e:	c7 04 24 40 35 11 80 	movl   $0x80113540,(%esp)
        p->pid = 0;
80104435:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010443c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104443:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104447:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010444e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104455:	e8 f6 04 00 00       	call   80104950 <release>
        return pid;
8010445a:	83 c4 10             	add    $0x10,%esp
}
8010445d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104460:	89 f0                	mov    %esi,%eax
80104462:	5b                   	pop    %ebx
80104463:	5e                   	pop    %esi
80104464:	5d                   	pop    %ebp
80104465:	c3                   	ret    
      release(&ptable.lock);
80104466:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104469:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010446e:	68 40 35 11 80       	push   $0x80113540
80104473:	e8 d8 04 00 00       	call   80104950 <release>
      return -1;
80104478:	83 c4 10             	add    $0x10,%esp
8010447b:	eb e0                	jmp    8010445d <wait+0xcd>
8010447d:	8d 76 00             	lea    0x0(%esi),%esi

80104480 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 10             	sub    $0x10,%esp
80104487:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010448a:	68 40 35 11 80       	push   $0x80113540
8010448f:	e8 fc 03 00 00       	call   80104890 <acquire>
80104494:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104497:	b8 74 35 11 80       	mov    $0x80113574,%eax
8010449c:	eb 0c                	jmp    801044aa <wakeup+0x2a>
8010449e:	66 90                	xchg   %ax,%ax
801044a0:	83 c0 7c             	add    $0x7c,%eax
801044a3:	3d 74 54 11 80       	cmp    $0x80115474,%eax
801044a8:	73 1c                	jae    801044c6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801044aa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044ae:	75 f0                	jne    801044a0 <wakeup+0x20>
801044b0:	3b 58 20             	cmp    0x20(%eax),%ebx
801044b3:	75 eb                	jne    801044a0 <wakeup+0x20>
      p->state = RUNNABLE;
801044b5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044bc:	83 c0 7c             	add    $0x7c,%eax
801044bf:	3d 74 54 11 80       	cmp    $0x80115474,%eax
801044c4:	72 e4                	jb     801044aa <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801044c6:	c7 45 08 40 35 11 80 	movl   $0x80113540,0x8(%ebp)
}
801044cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044d0:	c9                   	leave  
  release(&ptable.lock);
801044d1:	e9 7a 04 00 00       	jmp    80104950 <release>
801044d6:	8d 76 00             	lea    0x0(%esi),%esi
801044d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044e0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	53                   	push   %ebx
801044e4:	83 ec 10             	sub    $0x10,%esp
801044e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801044ea:	68 40 35 11 80       	push   $0x80113540
801044ef:	e8 9c 03 00 00       	call   80104890 <acquire>
801044f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044f7:	b8 74 35 11 80       	mov    $0x80113574,%eax
801044fc:	eb 0c                	jmp    8010450a <kill+0x2a>
801044fe:	66 90                	xchg   %ax,%ax
80104500:	83 c0 7c             	add    $0x7c,%eax
80104503:	3d 74 54 11 80       	cmp    $0x80115474,%eax
80104508:	73 36                	jae    80104540 <kill+0x60>
    if(p->pid == pid){
8010450a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010450d:	75 f1                	jne    80104500 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010450f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104513:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010451a:	75 07                	jne    80104523 <kill+0x43>
        p->state = RUNNABLE;
8010451c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104523:	83 ec 0c             	sub    $0xc,%esp
80104526:	68 40 35 11 80       	push   $0x80113540
8010452b:	e8 20 04 00 00       	call   80104950 <release>
      return 0;
80104530:	83 c4 10             	add    $0x10,%esp
80104533:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104535:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104538:	c9                   	leave  
80104539:	c3                   	ret    
8010453a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104540:	83 ec 0c             	sub    $0xc,%esp
80104543:	68 40 35 11 80       	push   $0x80113540
80104548:	e8 03 04 00 00       	call   80104950 <release>
  return -1;
8010454d:	83 c4 10             	add    $0x10,%esp
80104550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104558:	c9                   	leave  
80104559:	c3                   	ret    
8010455a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104560 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	57                   	push   %edi
80104564:	56                   	push   %esi
80104565:	53                   	push   %ebx
80104566:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104569:	bb 74 35 11 80       	mov    $0x80113574,%ebx
{
8010456e:	83 ec 3c             	sub    $0x3c,%esp
80104571:	eb 24                	jmp    80104597 <procdump+0x37>
80104573:	90                   	nop
80104574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104578:	83 ec 0c             	sub    $0xc,%esp
8010457b:	68 77 7d 10 80       	push   $0x80107d77
80104580:	e8 8b c2 ff ff       	call   80100810 <cprintf>
80104585:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104588:	83 c3 7c             	add    $0x7c,%ebx
8010458b:	81 fb 74 54 11 80    	cmp    $0x80115474,%ebx
80104591:	0f 83 81 00 00 00    	jae    80104618 <procdump+0xb8>
    if(p->state == UNUSED)
80104597:	8b 43 0c             	mov    0xc(%ebx),%eax
8010459a:	85 c0                	test   %eax,%eax
8010459c:	74 ea                	je     80104588 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010459e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801045a1:	ba 00 7a 10 80       	mov    $0x80107a00,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045a6:	77 11                	ja     801045b9 <procdump+0x59>
801045a8:	8b 14 85 60 7a 10 80 	mov    -0x7fef85a0(,%eax,4),%edx
      state = "???";
801045af:	b8 00 7a 10 80       	mov    $0x80107a00,%eax
801045b4:	85 d2                	test   %edx,%edx
801045b6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801045b9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801045bc:	50                   	push   %eax
801045bd:	52                   	push   %edx
801045be:	ff 73 10             	pushl  0x10(%ebx)
801045c1:	68 04 7a 10 80       	push   $0x80107a04
801045c6:	e8 45 c2 ff ff       	call   80100810 <cprintf>
    if(p->state == SLEEPING){
801045cb:	83 c4 10             	add    $0x10,%esp
801045ce:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801045d2:	75 a4                	jne    80104578 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801045d4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801045d7:	83 ec 08             	sub    $0x8,%esp
801045da:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045dd:	50                   	push   %eax
801045de:	8b 43 1c             	mov    0x1c(%ebx),%eax
801045e1:	8b 40 0c             	mov    0xc(%eax),%eax
801045e4:	83 c0 08             	add    $0x8,%eax
801045e7:	50                   	push   %eax
801045e8:	e8 83 01 00 00       	call   80104770 <getcallerpcs>
801045ed:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801045f0:	8b 17                	mov    (%edi),%edx
801045f2:	85 d2                	test   %edx,%edx
801045f4:	74 82                	je     80104578 <procdump+0x18>
        cprintf(" %p", pc[i]);
801045f6:	83 ec 08             	sub    $0x8,%esp
801045f9:	83 c7 04             	add    $0x4,%edi
801045fc:	52                   	push   %edx
801045fd:	68 41 74 10 80       	push   $0x80107441
80104602:	e8 09 c2 ff ff       	call   80100810 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104607:	83 c4 10             	add    $0x10,%esp
8010460a:	39 fe                	cmp    %edi,%esi
8010460c:	75 e2                	jne    801045f0 <procdump+0x90>
8010460e:	e9 65 ff ff ff       	jmp    80104578 <procdump+0x18>
80104613:	90                   	nop
80104614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104618:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010461b:	5b                   	pop    %ebx
8010461c:	5e                   	pop    %esi
8010461d:	5f                   	pop    %edi
8010461e:	5d                   	pop    %ebp
8010461f:	c3                   	ret    

80104620 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 0c             	sub    $0xc,%esp
80104627:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010462a:	68 78 7a 10 80       	push   $0x80107a78
8010462f:	8d 43 04             	lea    0x4(%ebx),%eax
80104632:	50                   	push   %eax
80104633:	e8 18 01 00 00       	call   80104750 <initlock>
  lk->name = name;
80104638:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010463b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104641:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104644:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010464b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010464e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104651:	c9                   	leave  
80104652:	c3                   	ret    
80104653:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104660 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	56                   	push   %esi
80104664:	53                   	push   %ebx
80104665:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104668:	83 ec 0c             	sub    $0xc,%esp
8010466b:	8d 73 04             	lea    0x4(%ebx),%esi
8010466e:	56                   	push   %esi
8010466f:	e8 1c 02 00 00       	call   80104890 <acquire>
  while (lk->locked) {
80104674:	8b 13                	mov    (%ebx),%edx
80104676:	83 c4 10             	add    $0x10,%esp
80104679:	85 d2                	test   %edx,%edx
8010467b:	74 16                	je     80104693 <acquiresleep+0x33>
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104680:	83 ec 08             	sub    $0x8,%esp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	e8 46 fc ff ff       	call   801042d0 <sleep>
  while (lk->locked) {
8010468a:	8b 03                	mov    (%ebx),%eax
8010468c:	83 c4 10             	add    $0x10,%esp
8010468f:	85 c0                	test   %eax,%eax
80104691:	75 ed                	jne    80104680 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104693:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104699:	e8 92 f6 ff ff       	call   80103d30 <myproc>
8010469e:	8b 40 10             	mov    0x10(%eax),%eax
801046a1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801046a4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801046a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046aa:	5b                   	pop    %ebx
801046ab:	5e                   	pop    %esi
801046ac:	5d                   	pop    %ebp
  release(&lk->lk);
801046ad:	e9 9e 02 00 00       	jmp    80104950 <release>
801046b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046c0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046c8:	83 ec 0c             	sub    $0xc,%esp
801046cb:	8d 73 04             	lea    0x4(%ebx),%esi
801046ce:	56                   	push   %esi
801046cf:	e8 bc 01 00 00       	call   80104890 <acquire>
  lk->locked = 0;
801046d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801046da:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801046e1:	89 1c 24             	mov    %ebx,(%esp)
801046e4:	e8 97 fd ff ff       	call   80104480 <wakeup>
  release(&lk->lk);
801046e9:	89 75 08             	mov    %esi,0x8(%ebp)
801046ec:	83 c4 10             	add    $0x10,%esp
}
801046ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046f2:	5b                   	pop    %ebx
801046f3:	5e                   	pop    %esi
801046f4:	5d                   	pop    %ebp
  release(&lk->lk);
801046f5:	e9 56 02 00 00       	jmp    80104950 <release>
801046fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104700 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	56                   	push   %esi
80104705:	53                   	push   %ebx
80104706:	31 ff                	xor    %edi,%edi
80104708:	83 ec 18             	sub    $0x18,%esp
8010470b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010470e:	8d 73 04             	lea    0x4(%ebx),%esi
80104711:	56                   	push   %esi
80104712:	e8 79 01 00 00       	call   80104890 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104717:	8b 03                	mov    (%ebx),%eax
80104719:	83 c4 10             	add    $0x10,%esp
8010471c:	85 c0                	test   %eax,%eax
8010471e:	74 13                	je     80104733 <holdingsleep+0x33>
80104720:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104723:	e8 08 f6 ff ff       	call   80103d30 <myproc>
80104728:	39 58 10             	cmp    %ebx,0x10(%eax)
8010472b:	0f 94 c0             	sete   %al
8010472e:	0f b6 c0             	movzbl %al,%eax
80104731:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104733:	83 ec 0c             	sub    $0xc,%esp
80104736:	56                   	push   %esi
80104737:	e8 14 02 00 00       	call   80104950 <release>
  return r;
}
8010473c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010473f:	89 f8                	mov    %edi,%eax
80104741:	5b                   	pop    %ebx
80104742:	5e                   	pop    %esi
80104743:	5f                   	pop    %edi
80104744:	5d                   	pop    %ebp
80104745:	c3                   	ret    
80104746:	66 90                	xchg   %ax,%ax
80104748:	66 90                	xchg   %ax,%ax
8010474a:	66 90                	xchg   %ax,%ax
8010474c:	66 90                	xchg   %ax,%ax
8010474e:	66 90                	xchg   %ax,%ax

80104750 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104756:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104759:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010475f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104762:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104769:	5d                   	pop    %ebp
8010476a:	c3                   	ret    
8010476b:	90                   	nop
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104770 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104770:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104771:	31 d2                	xor    %edx,%edx
{
80104773:	89 e5                	mov    %esp,%ebp
80104775:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104776:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104779:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010477c:	83 e8 08             	sub    $0x8,%eax
8010477f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104780:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104786:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010478c:	77 1a                	ja     801047a8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010478e:	8b 58 04             	mov    0x4(%eax),%ebx
80104791:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104794:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104797:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104799:	83 fa 0a             	cmp    $0xa,%edx
8010479c:	75 e2                	jne    80104780 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010479e:	5b                   	pop    %ebx
8010479f:	5d                   	pop    %ebp
801047a0:	c3                   	ret    
801047a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047a8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801047ab:	83 c1 28             	add    $0x28,%ecx
801047ae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801047b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801047b6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801047b9:	39 c1                	cmp    %eax,%ecx
801047bb:	75 f3                	jne    801047b0 <getcallerpcs+0x40>
}
801047bd:	5b                   	pop    %ebx
801047be:	5d                   	pop    %ebp
801047bf:	c3                   	ret    

801047c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	53                   	push   %ebx
801047c4:	83 ec 04             	sub    $0x4,%esp
801047c7:	9c                   	pushf  
801047c8:	5b                   	pop    %ebx
  asm volatile("cli");
801047c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801047ca:	e8 c1 f4 ff ff       	call   80103c90 <mycpu>
801047cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801047d5:	85 c0                	test   %eax,%eax
801047d7:	75 11                	jne    801047ea <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801047d9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047df:	e8 ac f4 ff ff       	call   80103c90 <mycpu>
801047e4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801047ea:	e8 a1 f4 ff ff       	call   80103c90 <mycpu>
801047ef:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801047f6:	83 c4 04             	add    $0x4,%esp
801047f9:	5b                   	pop    %ebx
801047fa:	5d                   	pop    %ebp
801047fb:	c3                   	ret    
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104800 <popcli>:

void
popcli(void)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104806:	9c                   	pushf  
80104807:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104808:	f6 c4 02             	test   $0x2,%ah
8010480b:	75 35                	jne    80104842 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010480d:	e8 7e f4 ff ff       	call   80103c90 <mycpu>
80104812:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104819:	78 34                	js     8010484f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010481b:	e8 70 f4 ff ff       	call   80103c90 <mycpu>
80104820:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104826:	85 d2                	test   %edx,%edx
80104828:	74 06                	je     80104830 <popcli+0x30>
    sti();
}
8010482a:	c9                   	leave  
8010482b:	c3                   	ret    
8010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104830:	e8 5b f4 ff ff       	call   80103c90 <mycpu>
80104835:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010483b:	85 c0                	test   %eax,%eax
8010483d:	74 eb                	je     8010482a <popcli+0x2a>
  asm volatile("sti");
8010483f:	fb                   	sti    
}
80104840:	c9                   	leave  
80104841:	c3                   	ret    
    panic("popcli - interruptible");
80104842:	83 ec 0c             	sub    $0xc,%esp
80104845:	68 83 7a 10 80       	push   $0x80107a83
8010484a:	e8 b1 bc ff ff       	call   80100500 <panic>
    panic("popcli");
8010484f:	83 ec 0c             	sub    $0xc,%esp
80104852:	68 9a 7a 10 80       	push   $0x80107a9a
80104857:	e8 a4 bc ff ff       	call   80100500 <panic>
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104860 <holding>:
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
80104865:	8b 75 08             	mov    0x8(%ebp),%esi
80104868:	31 db                	xor    %ebx,%ebx
  pushcli();
8010486a:	e8 51 ff ff ff       	call   801047c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010486f:	8b 06                	mov    (%esi),%eax
80104871:	85 c0                	test   %eax,%eax
80104873:	74 10                	je     80104885 <holding+0x25>
80104875:	8b 5e 08             	mov    0x8(%esi),%ebx
80104878:	e8 13 f4 ff ff       	call   80103c90 <mycpu>
8010487d:	39 c3                	cmp    %eax,%ebx
8010487f:	0f 94 c3             	sete   %bl
80104882:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104885:	e8 76 ff ff ff       	call   80104800 <popcli>
}
8010488a:	89 d8                	mov    %ebx,%eax
8010488c:	5b                   	pop    %ebx
8010488d:	5e                   	pop    %esi
8010488e:	5d                   	pop    %ebp
8010488f:	c3                   	ret    

80104890 <acquire>:
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104895:	e8 26 ff ff ff       	call   801047c0 <pushcli>
  if(holding(lk))
8010489a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010489d:	83 ec 0c             	sub    $0xc,%esp
801048a0:	53                   	push   %ebx
801048a1:	e8 ba ff ff ff       	call   80104860 <holding>
801048a6:	83 c4 10             	add    $0x10,%esp
801048a9:	85 c0                	test   %eax,%eax
801048ab:	0f 85 83 00 00 00    	jne    80104934 <acquire+0xa4>
801048b1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801048b3:	ba 01 00 00 00       	mov    $0x1,%edx
801048b8:	eb 09                	jmp    801048c3 <acquire+0x33>
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048c3:	89 d0                	mov    %edx,%eax
801048c5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801048c8:	85 c0                	test   %eax,%eax
801048ca:	75 f4                	jne    801048c0 <acquire+0x30>
  __sync_synchronize();
801048cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801048d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048d4:	e8 b7 f3 ff ff       	call   80103c90 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801048d9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801048dc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801048df:	89 e8                	mov    %ebp,%eax
801048e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048e8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801048ee:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801048f4:	77 1a                	ja     80104910 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801048f6:	8b 48 04             	mov    0x4(%eax),%ecx
801048f9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801048fc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801048ff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104901:	83 fe 0a             	cmp    $0xa,%esi
80104904:	75 e2                	jne    801048e8 <acquire+0x58>
}
80104906:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104909:	5b                   	pop    %ebx
8010490a:	5e                   	pop    %esi
8010490b:	5d                   	pop    %ebp
8010490c:	c3                   	ret    
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
80104910:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104913:	83 c2 28             	add    $0x28,%edx
80104916:	8d 76 00             	lea    0x0(%esi),%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104926:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104929:	39 d0                	cmp    %edx,%eax
8010492b:	75 f3                	jne    80104920 <acquire+0x90>
}
8010492d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104930:	5b                   	pop    %ebx
80104931:	5e                   	pop    %esi
80104932:	5d                   	pop    %ebp
80104933:	c3                   	ret    
    panic("acquire");
80104934:	83 ec 0c             	sub    $0xc,%esp
80104937:	68 a1 7a 10 80       	push   $0x80107aa1
8010493c:	e8 bf bb ff ff       	call   80100500 <panic>
80104941:	eb 0d                	jmp    80104950 <release>
80104943:	90                   	nop
80104944:	90                   	nop
80104945:	90                   	nop
80104946:	90                   	nop
80104947:	90                   	nop
80104948:	90                   	nop
80104949:	90                   	nop
8010494a:	90                   	nop
8010494b:	90                   	nop
8010494c:	90                   	nop
8010494d:	90                   	nop
8010494e:	90                   	nop
8010494f:	90                   	nop

80104950 <release>:
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	53                   	push   %ebx
80104954:	83 ec 10             	sub    $0x10,%esp
80104957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010495a:	53                   	push   %ebx
8010495b:	e8 00 ff ff ff       	call   80104860 <holding>
80104960:	83 c4 10             	add    $0x10,%esp
80104963:	85 c0                	test   %eax,%eax
80104965:	74 22                	je     80104989 <release+0x39>
  lk->pcs[0] = 0;
80104967:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010496e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104975:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010497a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104980:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104983:	c9                   	leave  
  popcli();
80104984:	e9 77 fe ff ff       	jmp    80104800 <popcli>
    panic("release");
80104989:	83 ec 0c             	sub    $0xc,%esp
8010498c:	68 a9 7a 10 80       	push   $0x80107aa9
80104991:	e8 6a bb ff ff       	call   80100500 <panic>
80104996:	66 90                	xchg   %ax,%ax
80104998:	66 90                	xchg   %ax,%ax
8010499a:	66 90                	xchg   %ax,%ax
8010499c:	66 90                	xchg   %ax,%ax
8010499e:	66 90                	xchg   %ax,%ax

801049a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	57                   	push   %edi
801049a4:	53                   	push   %ebx
801049a5:	8b 55 08             	mov    0x8(%ebp),%edx
801049a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801049ab:	f6 c2 03             	test   $0x3,%dl
801049ae:	75 05                	jne    801049b5 <memset+0x15>
801049b0:	f6 c1 03             	test   $0x3,%cl
801049b3:	74 13                	je     801049c8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801049b5:	89 d7                	mov    %edx,%edi
801049b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ba:	fc                   	cld    
801049bb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801049bd:	5b                   	pop    %ebx
801049be:	89 d0                	mov    %edx,%eax
801049c0:	5f                   	pop    %edi
801049c1:	5d                   	pop    %ebp
801049c2:	c3                   	ret    
801049c3:	90                   	nop
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801049c8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801049cc:	c1 e9 02             	shr    $0x2,%ecx
801049cf:	89 f8                	mov    %edi,%eax
801049d1:	89 fb                	mov    %edi,%ebx
801049d3:	c1 e0 18             	shl    $0x18,%eax
801049d6:	c1 e3 10             	shl    $0x10,%ebx
801049d9:	09 d8                	or     %ebx,%eax
801049db:	09 f8                	or     %edi,%eax
801049dd:	c1 e7 08             	shl    $0x8,%edi
801049e0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801049e2:	89 d7                	mov    %edx,%edi
801049e4:	fc                   	cld    
801049e5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801049e7:	5b                   	pop    %ebx
801049e8:	89 d0                	mov    %edx,%eax
801049ea:	5f                   	pop    %edi
801049eb:	5d                   	pop    %ebp
801049ec:	c3                   	ret    
801049ed:	8d 76 00             	lea    0x0(%esi),%esi

801049f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	56                   	push   %esi
801049f5:	53                   	push   %ebx
801049f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801049f9:	8b 75 08             	mov    0x8(%ebp),%esi
801049fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049ff:	85 db                	test   %ebx,%ebx
80104a01:	74 29                	je     80104a2c <memcmp+0x3c>
    if(*s1 != *s2)
80104a03:	0f b6 16             	movzbl (%esi),%edx
80104a06:	0f b6 0f             	movzbl (%edi),%ecx
80104a09:	38 d1                	cmp    %dl,%cl
80104a0b:	75 2b                	jne    80104a38 <memcmp+0x48>
80104a0d:	b8 01 00 00 00       	mov    $0x1,%eax
80104a12:	eb 14                	jmp    80104a28 <memcmp+0x38>
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a18:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104a1c:	83 c0 01             	add    $0x1,%eax
80104a1f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104a24:	38 ca                	cmp    %cl,%dl
80104a26:	75 10                	jne    80104a38 <memcmp+0x48>
  while(n-- > 0){
80104a28:	39 d8                	cmp    %ebx,%eax
80104a2a:	75 ec                	jne    80104a18 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104a2c:	5b                   	pop    %ebx
  return 0;
80104a2d:	31 c0                	xor    %eax,%eax
}
80104a2f:	5e                   	pop    %esi
80104a30:	5f                   	pop    %edi
80104a31:	5d                   	pop    %ebp
80104a32:	c3                   	ret    
80104a33:	90                   	nop
80104a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104a38:	0f b6 c2             	movzbl %dl,%eax
}
80104a3b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104a3c:	29 c8                	sub    %ecx,%eax
}
80104a3e:	5e                   	pop    %esi
80104a3f:	5f                   	pop    %edi
80104a40:	5d                   	pop    %ebp
80104a41:	c3                   	ret    
80104a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a50 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
80104a55:	8b 45 08             	mov    0x8(%ebp),%eax
80104a58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104a5b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a5e:	39 c3                	cmp    %eax,%ebx
80104a60:	73 26                	jae    80104a88 <memmove+0x38>
80104a62:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104a65:	39 c8                	cmp    %ecx,%eax
80104a67:	73 1f                	jae    80104a88 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104a69:	85 f6                	test   %esi,%esi
80104a6b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104a6e:	74 0f                	je     80104a7f <memmove+0x2f>
      *--d = *--s;
80104a70:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104a77:	83 ea 01             	sub    $0x1,%edx
80104a7a:	83 fa ff             	cmp    $0xffffffff,%edx
80104a7d:	75 f1                	jne    80104a70 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a7f:	5b                   	pop    %ebx
80104a80:	5e                   	pop    %esi
80104a81:	5d                   	pop    %ebp
80104a82:	c3                   	ret    
80104a83:	90                   	nop
80104a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104a88:	31 d2                	xor    %edx,%edx
80104a8a:	85 f6                	test   %esi,%esi
80104a8c:	74 f1                	je     80104a7f <memmove+0x2f>
80104a8e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104a90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104a97:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104a9a:	39 d6                	cmp    %edx,%esi
80104a9c:	75 f2                	jne    80104a90 <memmove+0x40>
}
80104a9e:	5b                   	pop    %ebx
80104a9f:	5e                   	pop    %esi
80104aa0:	5d                   	pop    %ebp
80104aa1:	c3                   	ret    
80104aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ab0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104ab3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104ab4:	eb 9a                	jmp    80104a50 <memmove>
80104ab6:	8d 76 00             	lea    0x0(%esi),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ac0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104ac8:	53                   	push   %ebx
80104ac9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104acc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104acf:	85 ff                	test   %edi,%edi
80104ad1:	74 2f                	je     80104b02 <strncmp+0x42>
80104ad3:	0f b6 01             	movzbl (%ecx),%eax
80104ad6:	0f b6 1e             	movzbl (%esi),%ebx
80104ad9:	84 c0                	test   %al,%al
80104adb:	74 37                	je     80104b14 <strncmp+0x54>
80104add:	38 c3                	cmp    %al,%bl
80104adf:	75 33                	jne    80104b14 <strncmp+0x54>
80104ae1:	01 f7                	add    %esi,%edi
80104ae3:	eb 13                	jmp    80104af8 <strncmp+0x38>
80104ae5:	8d 76 00             	lea    0x0(%esi),%esi
80104ae8:	0f b6 01             	movzbl (%ecx),%eax
80104aeb:	84 c0                	test   %al,%al
80104aed:	74 21                	je     80104b10 <strncmp+0x50>
80104aef:	0f b6 1a             	movzbl (%edx),%ebx
80104af2:	89 d6                	mov    %edx,%esi
80104af4:	38 d8                	cmp    %bl,%al
80104af6:	75 1c                	jne    80104b14 <strncmp+0x54>
    n--, p++, q++;
80104af8:	8d 56 01             	lea    0x1(%esi),%edx
80104afb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104afe:	39 fa                	cmp    %edi,%edx
80104b00:	75 e6                	jne    80104ae8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104b02:	5b                   	pop    %ebx
    return 0;
80104b03:	31 c0                	xor    %eax,%eax
}
80104b05:	5e                   	pop    %esi
80104b06:	5f                   	pop    %edi
80104b07:	5d                   	pop    %ebp
80104b08:	c3                   	ret    
80104b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b10:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104b14:	29 d8                	sub    %ebx,%eax
}
80104b16:	5b                   	pop    %ebx
80104b17:	5e                   	pop    %esi
80104b18:	5f                   	pop    %edi
80104b19:	5d                   	pop    %ebp
80104b1a:	c3                   	ret    
80104b1b:	90                   	nop
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b20 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	8b 45 08             	mov    0x8(%ebp),%eax
80104b28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b2e:	89 c2                	mov    %eax,%edx
80104b30:	eb 19                	jmp    80104b4b <strncpy+0x2b>
80104b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b38:	83 c3 01             	add    $0x1,%ebx
80104b3b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104b3f:	83 c2 01             	add    $0x1,%edx
80104b42:	84 c9                	test   %cl,%cl
80104b44:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b47:	74 09                	je     80104b52 <strncpy+0x32>
80104b49:	89 f1                	mov    %esi,%ecx
80104b4b:	85 c9                	test   %ecx,%ecx
80104b4d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104b50:	7f e6                	jg     80104b38 <strncpy+0x18>
    ;
  while(n-- > 0)
80104b52:	31 c9                	xor    %ecx,%ecx
80104b54:	85 f6                	test   %esi,%esi
80104b56:	7e 17                	jle    80104b6f <strncpy+0x4f>
80104b58:	90                   	nop
80104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104b60:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104b64:	89 f3                	mov    %esi,%ebx
80104b66:	83 c1 01             	add    $0x1,%ecx
80104b69:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104b6b:	85 db                	test   %ebx,%ebx
80104b6d:	7f f1                	jg     80104b60 <strncpy+0x40>
  return os;
}
80104b6f:	5b                   	pop    %ebx
80104b70:	5e                   	pop    %esi
80104b71:	5d                   	pop    %ebp
80104b72:	c3                   	ret    
80104b73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
80104b85:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b88:	8b 45 08             	mov    0x8(%ebp),%eax
80104b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104b8e:	85 c9                	test   %ecx,%ecx
80104b90:	7e 26                	jle    80104bb8 <safestrcpy+0x38>
80104b92:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104b96:	89 c1                	mov    %eax,%ecx
80104b98:	eb 17                	jmp    80104bb1 <safestrcpy+0x31>
80104b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ba0:	83 c2 01             	add    $0x1,%edx
80104ba3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104ba7:	83 c1 01             	add    $0x1,%ecx
80104baa:	84 db                	test   %bl,%bl
80104bac:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104baf:	74 04                	je     80104bb5 <safestrcpy+0x35>
80104bb1:	39 f2                	cmp    %esi,%edx
80104bb3:	75 eb                	jne    80104ba0 <safestrcpy+0x20>
    ;
  *s = 0;
80104bb5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104bb8:	5b                   	pop    %ebx
80104bb9:	5e                   	pop    %esi
80104bba:	5d                   	pop    %ebp
80104bbb:	c3                   	ret    
80104bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bc0 <strlen>:

int
strlen(const char *s)
{
80104bc0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104bc1:	31 c0                	xor    %eax,%eax
{
80104bc3:	89 e5                	mov    %esp,%ebp
80104bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104bc8:	80 3a 00             	cmpb   $0x0,(%edx)
80104bcb:	74 0c                	je     80104bd9 <strlen+0x19>
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi
80104bd0:	83 c0 01             	add    $0x1,%eax
80104bd3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104bd7:	75 f7                	jne    80104bd0 <strlen+0x10>
    ;
  return n;
}
80104bd9:	5d                   	pop    %ebp
80104bda:	c3                   	ret    

80104bdb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104bdb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104bdf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104be3:	55                   	push   %ebp
  pushl %ebx
80104be4:	53                   	push   %ebx
  pushl %esi
80104be5:	56                   	push   %esi
  pushl %edi
80104be6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104be7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104be9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104beb:	5f                   	pop    %edi
  popl %esi
80104bec:	5e                   	pop    %esi
  popl %ebx
80104bed:	5b                   	pop    %ebx
  popl %ebp
80104bee:	5d                   	pop    %ebp
  ret
80104bef:	c3                   	ret    

80104bf0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	53                   	push   %ebx
80104bf4:	83 ec 04             	sub    $0x4,%esp
80104bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104bfa:	e8 31 f1 ff ff       	call   80103d30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bff:	8b 00                	mov    (%eax),%eax
80104c01:	39 d8                	cmp    %ebx,%eax
80104c03:	76 1b                	jbe    80104c20 <fetchint+0x30>
80104c05:	8d 53 04             	lea    0x4(%ebx),%edx
80104c08:	39 d0                	cmp    %edx,%eax
80104c0a:	72 14                	jb     80104c20 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c0f:	8b 13                	mov    (%ebx),%edx
80104c11:	89 10                	mov    %edx,(%eax)
  return 0;
80104c13:	31 c0                	xor    %eax,%eax
}
80104c15:	83 c4 04             	add    $0x4,%esp
80104c18:	5b                   	pop    %ebx
80104c19:	5d                   	pop    %ebp
80104c1a:	c3                   	ret    
80104c1b:	90                   	nop
80104c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c25:	eb ee                	jmp    80104c15 <fetchint+0x25>
80104c27:	89 f6                	mov    %esi,%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c30 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	83 ec 04             	sub    $0x4,%esp
80104c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c3a:	e8 f1 f0 ff ff       	call   80103d30 <myproc>

  if(addr >= curproc->sz)
80104c3f:	39 18                	cmp    %ebx,(%eax)
80104c41:	76 29                	jbe    80104c6c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104c43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104c46:	89 da                	mov    %ebx,%edx
80104c48:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104c4a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104c4c:	39 c3                	cmp    %eax,%ebx
80104c4e:	73 1c                	jae    80104c6c <fetchstr+0x3c>
    if(*s == 0)
80104c50:	80 3b 00             	cmpb   $0x0,(%ebx)
80104c53:	75 10                	jne    80104c65 <fetchstr+0x35>
80104c55:	eb 39                	jmp    80104c90 <fetchstr+0x60>
80104c57:	89 f6                	mov    %esi,%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c60:	80 3a 00             	cmpb   $0x0,(%edx)
80104c63:	74 1b                	je     80104c80 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104c65:	83 c2 01             	add    $0x1,%edx
80104c68:	39 d0                	cmp    %edx,%eax
80104c6a:	77 f4                	ja     80104c60 <fetchstr+0x30>
    return -1;
80104c6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104c71:	83 c4 04             	add    $0x4,%esp
80104c74:	5b                   	pop    %ebx
80104c75:	5d                   	pop    %ebp
80104c76:	c3                   	ret    
80104c77:	89 f6                	mov    %esi,%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c80:	83 c4 04             	add    $0x4,%esp
80104c83:	89 d0                	mov    %edx,%eax
80104c85:	29 d8                	sub    %ebx,%eax
80104c87:	5b                   	pop    %ebx
80104c88:	5d                   	pop    %ebp
80104c89:	c3                   	ret    
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104c90:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104c92:	eb dd                	jmp    80104c71 <fetchstr+0x41>
80104c94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ca0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	56                   	push   %esi
80104ca4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ca5:	e8 86 f0 ff ff       	call   80103d30 <myproc>
80104caa:	8b 40 18             	mov    0x18(%eax),%eax
80104cad:	8b 55 08             	mov    0x8(%ebp),%edx
80104cb0:	8b 40 44             	mov    0x44(%eax),%eax
80104cb3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cb6:	e8 75 f0 ff ff       	call   80103d30 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cbb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cbd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cc0:	39 c6                	cmp    %eax,%esi
80104cc2:	73 1c                	jae    80104ce0 <argint+0x40>
80104cc4:	8d 53 08             	lea    0x8(%ebx),%edx
80104cc7:	39 d0                	cmp    %edx,%eax
80104cc9:	72 15                	jb     80104ce0 <argint+0x40>
  *ip = *(int*)(addr);
80104ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cce:	8b 53 04             	mov    0x4(%ebx),%edx
80104cd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104cd3:	31 c0                	xor    %eax,%eax
}
80104cd5:	5b                   	pop    %ebx
80104cd6:	5e                   	pop    %esi
80104cd7:	5d                   	pop    %ebp
80104cd8:	c3                   	ret    
80104cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ce5:	eb ee                	jmp    80104cd5 <argint+0x35>
80104ce7:	89 f6                	mov    %esi,%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	56                   	push   %esi
80104cf4:	53                   	push   %ebx
80104cf5:	83 ec 10             	sub    $0x10,%esp
80104cf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104cfb:	e8 30 f0 ff ff       	call   80103d30 <myproc>
80104d00:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104d02:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d05:	83 ec 08             	sub    $0x8,%esp
80104d08:	50                   	push   %eax
80104d09:	ff 75 08             	pushl  0x8(%ebp)
80104d0c:	e8 8f ff ff ff       	call   80104ca0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d11:	83 c4 10             	add    $0x10,%esp
80104d14:	85 c0                	test   %eax,%eax
80104d16:	78 28                	js     80104d40 <argptr+0x50>
80104d18:	85 db                	test   %ebx,%ebx
80104d1a:	78 24                	js     80104d40 <argptr+0x50>
80104d1c:	8b 16                	mov    (%esi),%edx
80104d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d21:	39 c2                	cmp    %eax,%edx
80104d23:	76 1b                	jbe    80104d40 <argptr+0x50>
80104d25:	01 c3                	add    %eax,%ebx
80104d27:	39 da                	cmp    %ebx,%edx
80104d29:	72 15                	jb     80104d40 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d2e:	89 02                	mov    %eax,(%edx)
  return 0;
80104d30:	31 c0                	xor    %eax,%eax
}
80104d32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d35:	5b                   	pop    %ebx
80104d36:	5e                   	pop    %esi
80104d37:	5d                   	pop    %ebp
80104d38:	c3                   	ret    
80104d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d45:	eb eb                	jmp    80104d32 <argptr+0x42>
80104d47:	89 f6                	mov    %esi,%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104d56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d59:	50                   	push   %eax
80104d5a:	ff 75 08             	pushl  0x8(%ebp)
80104d5d:	e8 3e ff ff ff       	call   80104ca0 <argint>
80104d62:	83 c4 10             	add    $0x10,%esp
80104d65:	85 c0                	test   %eax,%eax
80104d67:	78 17                	js     80104d80 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104d69:	83 ec 08             	sub    $0x8,%esp
80104d6c:	ff 75 0c             	pushl  0xc(%ebp)
80104d6f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d72:	e8 b9 fe ff ff       	call   80104c30 <fetchstr>
80104d77:	83 c4 10             	add    $0x10,%esp
}
80104d7a:	c9                   	leave  
80104d7b:	c3                   	ret    
80104d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d85:	c9                   	leave  
80104d86:	c3                   	ret    
80104d87:	89 f6                	mov    %esi,%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d90 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	53                   	push   %ebx
80104d94:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d97:	e8 94 ef ff ff       	call   80103d30 <myproc>
80104d9c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d9e:	8b 40 18             	mov    0x18(%eax),%eax
80104da1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104da4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104da7:	83 fa 14             	cmp    $0x14,%edx
80104daa:	77 1c                	ja     80104dc8 <syscall+0x38>
80104dac:	8b 14 85 e0 7a 10 80 	mov    -0x7fef8520(,%eax,4),%edx
80104db3:	85 d2                	test   %edx,%edx
80104db5:	74 11                	je     80104dc8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104db7:	ff d2                	call   *%edx
80104db9:	8b 53 18             	mov    0x18(%ebx),%edx
80104dbc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104dbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc2:	c9                   	leave  
80104dc3:	c3                   	ret    
80104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104dc8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104dc9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104dcc:	50                   	push   %eax
80104dcd:	ff 73 10             	pushl  0x10(%ebx)
80104dd0:	68 b1 7a 10 80       	push   $0x80107ab1
80104dd5:	e8 36 ba ff ff       	call   80100810 <cprintf>
    curproc->tf->eax = -1;
80104dda:	8b 43 18             	mov    0x18(%ebx),%eax
80104ddd:	83 c4 10             	add    $0x10,%esp
80104de0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104de7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dea:	c9                   	leave  
80104deb:	c3                   	ret    
80104dec:	66 90                	xchg   %ax,%ax
80104dee:	66 90                	xchg   %ax,%ax

80104df0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	57                   	push   %edi
80104df4:	56                   	push   %esi
80104df5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104df6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104df9:	83 ec 34             	sub    $0x34,%esp
80104dfc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104dff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104e02:	56                   	push   %esi
80104e03:	50                   	push   %eax
{
80104e04:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104e07:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e0a:	e8 41 d6 ff ff       	call   80102450 <nameiparent>
80104e0f:	83 c4 10             	add    $0x10,%esp
80104e12:	85 c0                	test   %eax,%eax
80104e14:	0f 84 46 01 00 00    	je     80104f60 <create+0x170>
    return 0;
  ilock(dp);
80104e1a:	83 ec 0c             	sub    $0xc,%esp
80104e1d:	89 c3                	mov    %eax,%ebx
80104e1f:	50                   	push   %eax
80104e20:	e8 ab cd ff ff       	call   80101bd0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e25:	83 c4 0c             	add    $0xc,%esp
80104e28:	6a 00                	push   $0x0
80104e2a:	56                   	push   %esi
80104e2b:	53                   	push   %ebx
80104e2c:	e8 cf d2 ff ff       	call   80102100 <dirlookup>
80104e31:	83 c4 10             	add    $0x10,%esp
80104e34:	85 c0                	test   %eax,%eax
80104e36:	89 c7                	mov    %eax,%edi
80104e38:	74 36                	je     80104e70 <create+0x80>
    iunlockput(dp);
80104e3a:	83 ec 0c             	sub    $0xc,%esp
80104e3d:	53                   	push   %ebx
80104e3e:	e8 1d d0 ff ff       	call   80101e60 <iunlockput>
    ilock(ip);
80104e43:	89 3c 24             	mov    %edi,(%esp)
80104e46:	e8 85 cd ff ff       	call   80101bd0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e4b:	83 c4 10             	add    $0x10,%esp
80104e4e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e53:	0f 85 97 00 00 00    	jne    80104ef0 <create+0x100>
80104e59:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104e5e:	0f 85 8c 00 00 00    	jne    80104ef0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e67:	89 f8                	mov    %edi,%eax
80104e69:	5b                   	pop    %ebx
80104e6a:	5e                   	pop    %esi
80104e6b:	5f                   	pop    %edi
80104e6c:	5d                   	pop    %ebp
80104e6d:	c3                   	ret    
80104e6e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80104e70:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e74:	83 ec 08             	sub    $0x8,%esp
80104e77:	50                   	push   %eax
80104e78:	ff 33                	pushl  (%ebx)
80104e7a:	e8 e1 cb ff ff       	call   80101a60 <ialloc>
80104e7f:	83 c4 10             	add    $0x10,%esp
80104e82:	85 c0                	test   %eax,%eax
80104e84:	89 c7                	mov    %eax,%edi
80104e86:	0f 84 e8 00 00 00    	je     80104f74 <create+0x184>
  ilock(ip);
80104e8c:	83 ec 0c             	sub    $0xc,%esp
80104e8f:	50                   	push   %eax
80104e90:	e8 3b cd ff ff       	call   80101bd0 <ilock>
  ip->major = major;
80104e95:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e99:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104e9d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ea1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104ea5:	b8 01 00 00 00       	mov    $0x1,%eax
80104eaa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104eae:	89 3c 24             	mov    %edi,(%esp)
80104eb1:	e8 6a cc ff ff       	call   80101b20 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104eb6:	83 c4 10             	add    $0x10,%esp
80104eb9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104ebe:	74 50                	je     80104f10 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ec0:	83 ec 04             	sub    $0x4,%esp
80104ec3:	ff 77 04             	pushl  0x4(%edi)
80104ec6:	56                   	push   %esi
80104ec7:	53                   	push   %ebx
80104ec8:	e8 a3 d4 ff ff       	call   80102370 <dirlink>
80104ecd:	83 c4 10             	add    $0x10,%esp
80104ed0:	85 c0                	test   %eax,%eax
80104ed2:	0f 88 8f 00 00 00    	js     80104f67 <create+0x177>
  iunlockput(dp);
80104ed8:	83 ec 0c             	sub    $0xc,%esp
80104edb:	53                   	push   %ebx
80104edc:	e8 7f cf ff ff       	call   80101e60 <iunlockput>
  return ip;
80104ee1:	83 c4 10             	add    $0x10,%esp
}
80104ee4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ee7:	89 f8                	mov    %edi,%eax
80104ee9:	5b                   	pop    %ebx
80104eea:	5e                   	pop    %esi
80104eeb:	5f                   	pop    %edi
80104eec:	5d                   	pop    %ebp
80104eed:	c3                   	ret    
80104eee:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104ef0:	83 ec 0c             	sub    $0xc,%esp
80104ef3:	57                   	push   %edi
    return 0;
80104ef4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104ef6:	e8 65 cf ff ff       	call   80101e60 <iunlockput>
    return 0;
80104efb:	83 c4 10             	add    $0x10,%esp
}
80104efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f01:	89 f8                	mov    %edi,%eax
80104f03:	5b                   	pop    %ebx
80104f04:	5e                   	pop    %esi
80104f05:	5f                   	pop    %edi
80104f06:	5d                   	pop    %ebp
80104f07:	c3                   	ret    
80104f08:	90                   	nop
80104f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104f10:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104f15:	83 ec 0c             	sub    $0xc,%esp
80104f18:	53                   	push   %ebx
80104f19:	e8 02 cc ff ff       	call   80101b20 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f1e:	83 c4 0c             	add    $0xc,%esp
80104f21:	ff 77 04             	pushl  0x4(%edi)
80104f24:	68 54 7b 10 80       	push   $0x80107b54
80104f29:	57                   	push   %edi
80104f2a:	e8 41 d4 ff ff       	call   80102370 <dirlink>
80104f2f:	83 c4 10             	add    $0x10,%esp
80104f32:	85 c0                	test   %eax,%eax
80104f34:	78 1c                	js     80104f52 <create+0x162>
80104f36:	83 ec 04             	sub    $0x4,%esp
80104f39:	ff 73 04             	pushl  0x4(%ebx)
80104f3c:	68 53 7b 10 80       	push   $0x80107b53
80104f41:	57                   	push   %edi
80104f42:	e8 29 d4 ff ff       	call   80102370 <dirlink>
80104f47:	83 c4 10             	add    $0x10,%esp
80104f4a:	85 c0                	test   %eax,%eax
80104f4c:	0f 89 6e ff ff ff    	jns    80104ec0 <create+0xd0>
      panic("create dots");
80104f52:	83 ec 0c             	sub    $0xc,%esp
80104f55:	68 47 7b 10 80       	push   $0x80107b47
80104f5a:	e8 a1 b5 ff ff       	call   80100500 <panic>
80104f5f:	90                   	nop
    return 0;
80104f60:	31 ff                	xor    %edi,%edi
80104f62:	e9 fd fe ff ff       	jmp    80104e64 <create+0x74>
    panic("create: dirlink");
80104f67:	83 ec 0c             	sub    $0xc,%esp
80104f6a:	68 56 7b 10 80       	push   $0x80107b56
80104f6f:	e8 8c b5 ff ff       	call   80100500 <panic>
    panic("create: ialloc");
80104f74:	83 ec 0c             	sub    $0xc,%esp
80104f77:	68 38 7b 10 80       	push   $0x80107b38
80104f7c:	e8 7f b5 ff ff       	call   80100500 <panic>
80104f81:	eb 0d                	jmp    80104f90 <argfd.constprop.0>
80104f83:	90                   	nop
80104f84:	90                   	nop
80104f85:	90                   	nop
80104f86:	90                   	nop
80104f87:	90                   	nop
80104f88:	90                   	nop
80104f89:	90                   	nop
80104f8a:	90                   	nop
80104f8b:	90                   	nop
80104f8c:	90                   	nop
80104f8d:	90                   	nop
80104f8e:	90                   	nop
80104f8f:	90                   	nop

80104f90 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	56                   	push   %esi
80104f94:	53                   	push   %ebx
80104f95:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104f97:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104f9a:	89 d6                	mov    %edx,%esi
80104f9c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f9f:	50                   	push   %eax
80104fa0:	6a 00                	push   $0x0
80104fa2:	e8 f9 fc ff ff       	call   80104ca0 <argint>
80104fa7:	83 c4 10             	add    $0x10,%esp
80104faa:	85 c0                	test   %eax,%eax
80104fac:	78 2a                	js     80104fd8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fb2:	77 24                	ja     80104fd8 <argfd.constprop.0+0x48>
80104fb4:	e8 77 ed ff ff       	call   80103d30 <myproc>
80104fb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fbc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104fc0:	85 c0                	test   %eax,%eax
80104fc2:	74 14                	je     80104fd8 <argfd.constprop.0+0x48>
  if(pfd)
80104fc4:	85 db                	test   %ebx,%ebx
80104fc6:	74 02                	je     80104fca <argfd.constprop.0+0x3a>
    *pfd = fd;
80104fc8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104fca:	89 06                	mov    %eax,(%esi)
  return 0;
80104fcc:	31 c0                	xor    %eax,%eax
}
80104fce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fd1:	5b                   	pop    %ebx
80104fd2:	5e                   	pop    %esi
80104fd3:	5d                   	pop    %ebp
80104fd4:	c3                   	ret    
80104fd5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdd:	eb ef                	jmp    80104fce <argfd.constprop.0+0x3e>
80104fdf:	90                   	nop

80104fe0 <sys_dup>:
{
80104fe0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104fe1:	31 c0                	xor    %eax,%eax
{
80104fe3:	89 e5                	mov    %esp,%ebp
80104fe5:	56                   	push   %esi
80104fe6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104fe7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104fea:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104fed:	e8 9e ff ff ff       	call   80104f90 <argfd.constprop.0>
80104ff2:	85 c0                	test   %eax,%eax
80104ff4:	78 42                	js     80105038 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104ff6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104ff9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104ffb:	e8 30 ed ff ff       	call   80103d30 <myproc>
80105000:	eb 0e                	jmp    80105010 <sys_dup+0x30>
80105002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105008:	83 c3 01             	add    $0x1,%ebx
8010500b:	83 fb 10             	cmp    $0x10,%ebx
8010500e:	74 28                	je     80105038 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105010:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105014:	85 d2                	test   %edx,%edx
80105016:	75 f0                	jne    80105008 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105018:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010501c:	83 ec 0c             	sub    $0xc,%esp
8010501f:	ff 75 f4             	pushl  -0xc(%ebp)
80105022:	e8 19 c3 ff ff       	call   80101340 <filedup>
  return fd;
80105027:	83 c4 10             	add    $0x10,%esp
}
8010502a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010502d:	89 d8                	mov    %ebx,%eax
8010502f:	5b                   	pop    %ebx
80105030:	5e                   	pop    %esi
80105031:	5d                   	pop    %ebp
80105032:	c3                   	ret    
80105033:	90                   	nop
80105034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105038:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010503b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105040:	89 d8                	mov    %ebx,%eax
80105042:	5b                   	pop    %ebx
80105043:	5e                   	pop    %esi
80105044:	5d                   	pop    %ebp
80105045:	c3                   	ret    
80105046:	8d 76 00             	lea    0x0(%esi),%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <sys_read>:
{
80105050:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105051:	31 c0                	xor    %eax,%eax
{
80105053:	89 e5                	mov    %esp,%ebp
80105055:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105058:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010505b:	e8 30 ff ff ff       	call   80104f90 <argfd.constprop.0>
80105060:	85 c0                	test   %eax,%eax
80105062:	78 4c                	js     801050b0 <sys_read+0x60>
80105064:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105067:	83 ec 08             	sub    $0x8,%esp
8010506a:	50                   	push   %eax
8010506b:	6a 02                	push   $0x2
8010506d:	e8 2e fc ff ff       	call   80104ca0 <argint>
80105072:	83 c4 10             	add    $0x10,%esp
80105075:	85 c0                	test   %eax,%eax
80105077:	78 37                	js     801050b0 <sys_read+0x60>
80105079:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010507c:	83 ec 04             	sub    $0x4,%esp
8010507f:	ff 75 f0             	pushl  -0x10(%ebp)
80105082:	50                   	push   %eax
80105083:	6a 01                	push   $0x1
80105085:	e8 66 fc ff ff       	call   80104cf0 <argptr>
8010508a:	83 c4 10             	add    $0x10,%esp
8010508d:	85 c0                	test   %eax,%eax
8010508f:	78 1f                	js     801050b0 <sys_read+0x60>
  return fileread(f, p, n);
80105091:	83 ec 04             	sub    $0x4,%esp
80105094:	ff 75 f0             	pushl  -0x10(%ebp)
80105097:	ff 75 f4             	pushl  -0xc(%ebp)
8010509a:	ff 75 ec             	pushl  -0x14(%ebp)
8010509d:	e8 0e c4 ff ff       	call   801014b0 <fileread>
801050a2:	83 c4 10             	add    $0x10,%esp
}
801050a5:	c9                   	leave  
801050a6:	c3                   	ret    
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050b5:	c9                   	leave  
801050b6:	c3                   	ret    
801050b7:	89 f6                	mov    %esi,%esi
801050b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050c0 <sys_write>:
{
801050c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050c1:	31 c0                	xor    %eax,%eax
{
801050c3:	89 e5                	mov    %esp,%ebp
801050c5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050c8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050cb:	e8 c0 fe ff ff       	call   80104f90 <argfd.constprop.0>
801050d0:	85 c0                	test   %eax,%eax
801050d2:	78 4c                	js     80105120 <sys_write+0x60>
801050d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050d7:	83 ec 08             	sub    $0x8,%esp
801050da:	50                   	push   %eax
801050db:	6a 02                	push   $0x2
801050dd:	e8 be fb ff ff       	call   80104ca0 <argint>
801050e2:	83 c4 10             	add    $0x10,%esp
801050e5:	85 c0                	test   %eax,%eax
801050e7:	78 37                	js     80105120 <sys_write+0x60>
801050e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ec:	83 ec 04             	sub    $0x4,%esp
801050ef:	ff 75 f0             	pushl  -0x10(%ebp)
801050f2:	50                   	push   %eax
801050f3:	6a 01                	push   $0x1
801050f5:	e8 f6 fb ff ff       	call   80104cf0 <argptr>
801050fa:	83 c4 10             	add    $0x10,%esp
801050fd:	85 c0                	test   %eax,%eax
801050ff:	78 1f                	js     80105120 <sys_write+0x60>
  return filewrite(f, p, n);
80105101:	83 ec 04             	sub    $0x4,%esp
80105104:	ff 75 f0             	pushl  -0x10(%ebp)
80105107:	ff 75 f4             	pushl  -0xc(%ebp)
8010510a:	ff 75 ec             	pushl  -0x14(%ebp)
8010510d:	e8 2e c4 ff ff       	call   80101540 <filewrite>
80105112:	83 c4 10             	add    $0x10,%esp
}
80105115:	c9                   	leave  
80105116:	c3                   	ret    
80105117:	89 f6                	mov    %esi,%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105125:	c9                   	leave  
80105126:	c3                   	ret    
80105127:	89 f6                	mov    %esi,%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <sys_close>:
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105136:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105139:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010513c:	e8 4f fe ff ff       	call   80104f90 <argfd.constprop.0>
80105141:	85 c0                	test   %eax,%eax
80105143:	78 2b                	js     80105170 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105145:	e8 e6 eb ff ff       	call   80103d30 <myproc>
8010514a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010514d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105150:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105157:	00 
  fileclose(f);
80105158:	ff 75 f4             	pushl  -0xc(%ebp)
8010515b:	e8 30 c2 ff ff       	call   80101390 <fileclose>
  return 0;
80105160:	83 c4 10             	add    $0x10,%esp
80105163:	31 c0                	xor    %eax,%eax
}
80105165:	c9                   	leave  
80105166:	c3                   	ret    
80105167:	89 f6                	mov    %esi,%esi
80105169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105175:	c9                   	leave  
80105176:	c3                   	ret    
80105177:	89 f6                	mov    %esi,%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <sys_fstat>:
{
80105180:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105181:	31 c0                	xor    %eax,%eax
{
80105183:	89 e5                	mov    %esp,%ebp
80105185:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105188:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010518b:	e8 00 fe ff ff       	call   80104f90 <argfd.constprop.0>
80105190:	85 c0                	test   %eax,%eax
80105192:	78 2c                	js     801051c0 <sys_fstat+0x40>
80105194:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105197:	83 ec 04             	sub    $0x4,%esp
8010519a:	6a 14                	push   $0x14
8010519c:	50                   	push   %eax
8010519d:	6a 01                	push   $0x1
8010519f:	e8 4c fb ff ff       	call   80104cf0 <argptr>
801051a4:	83 c4 10             	add    $0x10,%esp
801051a7:	85 c0                	test   %eax,%eax
801051a9:	78 15                	js     801051c0 <sys_fstat+0x40>
  return filestat(f, st);
801051ab:	83 ec 08             	sub    $0x8,%esp
801051ae:	ff 75 f4             	pushl  -0xc(%ebp)
801051b1:	ff 75 f0             	pushl  -0x10(%ebp)
801051b4:	e8 a7 c2 ff ff       	call   80101460 <filestat>
801051b9:	83 c4 10             	add    $0x10,%esp
}
801051bc:	c9                   	leave  
801051bd:	c3                   	ret    
801051be:	66 90                	xchg   %ax,%ax
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051c5:	c9                   	leave  
801051c6:	c3                   	ret    
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051d0 <sys_link>:
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	57                   	push   %edi
801051d4:	56                   	push   %esi
801051d5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051d6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801051d9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051dc:	50                   	push   %eax
801051dd:	6a 00                	push   $0x0
801051df:	e8 6c fb ff ff       	call   80104d50 <argstr>
801051e4:	83 c4 10             	add    $0x10,%esp
801051e7:	85 c0                	test   %eax,%eax
801051e9:	0f 88 fb 00 00 00    	js     801052ea <sys_link+0x11a>
801051ef:	8d 45 d0             	lea    -0x30(%ebp),%eax
801051f2:	83 ec 08             	sub    $0x8,%esp
801051f5:	50                   	push   %eax
801051f6:	6a 01                	push   $0x1
801051f8:	e8 53 fb ff ff       	call   80104d50 <argstr>
801051fd:	83 c4 10             	add    $0x10,%esp
80105200:	85 c0                	test   %eax,%eax
80105202:	0f 88 e2 00 00 00    	js     801052ea <sys_link+0x11a>
  begin_op();
80105208:	e8 e3 de ff ff       	call   801030f0 <begin_op>
  if((ip = namei(old)) == 0){
8010520d:	83 ec 0c             	sub    $0xc,%esp
80105210:	ff 75 d4             	pushl  -0x2c(%ebp)
80105213:	e8 18 d2 ff ff       	call   80102430 <namei>
80105218:	83 c4 10             	add    $0x10,%esp
8010521b:	85 c0                	test   %eax,%eax
8010521d:	89 c3                	mov    %eax,%ebx
8010521f:	0f 84 ea 00 00 00    	je     8010530f <sys_link+0x13f>
  ilock(ip);
80105225:	83 ec 0c             	sub    $0xc,%esp
80105228:	50                   	push   %eax
80105229:	e8 a2 c9 ff ff       	call   80101bd0 <ilock>
  if(ip->type == T_DIR){
8010522e:	83 c4 10             	add    $0x10,%esp
80105231:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105236:	0f 84 bb 00 00 00    	je     801052f7 <sys_link+0x127>
  ip->nlink++;
8010523c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105241:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105244:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105247:	53                   	push   %ebx
80105248:	e8 d3 c8 ff ff       	call   80101b20 <iupdate>
  iunlock(ip);
8010524d:	89 1c 24             	mov    %ebx,(%esp)
80105250:	e8 5b ca ff ff       	call   80101cb0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105255:	58                   	pop    %eax
80105256:	5a                   	pop    %edx
80105257:	57                   	push   %edi
80105258:	ff 75 d0             	pushl  -0x30(%ebp)
8010525b:	e8 f0 d1 ff ff       	call   80102450 <nameiparent>
80105260:	83 c4 10             	add    $0x10,%esp
80105263:	85 c0                	test   %eax,%eax
80105265:	89 c6                	mov    %eax,%esi
80105267:	74 5b                	je     801052c4 <sys_link+0xf4>
  ilock(dp);
80105269:	83 ec 0c             	sub    $0xc,%esp
8010526c:	50                   	push   %eax
8010526d:	e8 5e c9 ff ff       	call   80101bd0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105272:	83 c4 10             	add    $0x10,%esp
80105275:	8b 03                	mov    (%ebx),%eax
80105277:	39 06                	cmp    %eax,(%esi)
80105279:	75 3d                	jne    801052b8 <sys_link+0xe8>
8010527b:	83 ec 04             	sub    $0x4,%esp
8010527e:	ff 73 04             	pushl  0x4(%ebx)
80105281:	57                   	push   %edi
80105282:	56                   	push   %esi
80105283:	e8 e8 d0 ff ff       	call   80102370 <dirlink>
80105288:	83 c4 10             	add    $0x10,%esp
8010528b:	85 c0                	test   %eax,%eax
8010528d:	78 29                	js     801052b8 <sys_link+0xe8>
  iunlockput(dp);
8010528f:	83 ec 0c             	sub    $0xc,%esp
80105292:	56                   	push   %esi
80105293:	e8 c8 cb ff ff       	call   80101e60 <iunlockput>
  iput(ip);
80105298:	89 1c 24             	mov    %ebx,(%esp)
8010529b:	e8 60 ca ff ff       	call   80101d00 <iput>
  end_op();
801052a0:	e8 bb de ff ff       	call   80103160 <end_op>
  return 0;
801052a5:	83 c4 10             	add    $0x10,%esp
801052a8:	31 c0                	xor    %eax,%eax
}
801052aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052ad:	5b                   	pop    %ebx
801052ae:	5e                   	pop    %esi
801052af:	5f                   	pop    %edi
801052b0:	5d                   	pop    %ebp
801052b1:	c3                   	ret    
801052b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801052b8:	83 ec 0c             	sub    $0xc,%esp
801052bb:	56                   	push   %esi
801052bc:	e8 9f cb ff ff       	call   80101e60 <iunlockput>
    goto bad;
801052c1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052c4:	83 ec 0c             	sub    $0xc,%esp
801052c7:	53                   	push   %ebx
801052c8:	e8 03 c9 ff ff       	call   80101bd0 <ilock>
  ip->nlink--;
801052cd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052d2:	89 1c 24             	mov    %ebx,(%esp)
801052d5:	e8 46 c8 ff ff       	call   80101b20 <iupdate>
  iunlockput(ip);
801052da:	89 1c 24             	mov    %ebx,(%esp)
801052dd:	e8 7e cb ff ff       	call   80101e60 <iunlockput>
  end_op();
801052e2:	e8 79 de ff ff       	call   80103160 <end_op>
  return -1;
801052e7:	83 c4 10             	add    $0x10,%esp
}
801052ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801052ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052f2:	5b                   	pop    %ebx
801052f3:	5e                   	pop    %esi
801052f4:	5f                   	pop    %edi
801052f5:	5d                   	pop    %ebp
801052f6:	c3                   	ret    
    iunlockput(ip);
801052f7:	83 ec 0c             	sub    $0xc,%esp
801052fa:	53                   	push   %ebx
801052fb:	e8 60 cb ff ff       	call   80101e60 <iunlockput>
    end_op();
80105300:	e8 5b de ff ff       	call   80103160 <end_op>
    return -1;
80105305:	83 c4 10             	add    $0x10,%esp
80105308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010530d:	eb 9b                	jmp    801052aa <sys_link+0xda>
    end_op();
8010530f:	e8 4c de ff ff       	call   80103160 <end_op>
    return -1;
80105314:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105319:	eb 8f                	jmp    801052aa <sys_link+0xda>
8010531b:	90                   	nop
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105320 <sys_unlink>:
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	57                   	push   %edi
80105324:	56                   	push   %esi
80105325:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105326:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105329:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010532c:	50                   	push   %eax
8010532d:	6a 00                	push   $0x0
8010532f:	e8 1c fa ff ff       	call   80104d50 <argstr>
80105334:	83 c4 10             	add    $0x10,%esp
80105337:	85 c0                	test   %eax,%eax
80105339:	0f 88 77 01 00 00    	js     801054b6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010533f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105342:	e8 a9 dd ff ff       	call   801030f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105347:	83 ec 08             	sub    $0x8,%esp
8010534a:	53                   	push   %ebx
8010534b:	ff 75 c0             	pushl  -0x40(%ebp)
8010534e:	e8 fd d0 ff ff       	call   80102450 <nameiparent>
80105353:	83 c4 10             	add    $0x10,%esp
80105356:	85 c0                	test   %eax,%eax
80105358:	89 c6                	mov    %eax,%esi
8010535a:	0f 84 60 01 00 00    	je     801054c0 <sys_unlink+0x1a0>
  ilock(dp);
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	50                   	push   %eax
80105364:	e8 67 c8 ff ff       	call   80101bd0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105369:	58                   	pop    %eax
8010536a:	5a                   	pop    %edx
8010536b:	68 54 7b 10 80       	push   $0x80107b54
80105370:	53                   	push   %ebx
80105371:	e8 6a cd ff ff       	call   801020e0 <namecmp>
80105376:	83 c4 10             	add    $0x10,%esp
80105379:	85 c0                	test   %eax,%eax
8010537b:	0f 84 03 01 00 00    	je     80105484 <sys_unlink+0x164>
80105381:	83 ec 08             	sub    $0x8,%esp
80105384:	68 53 7b 10 80       	push   $0x80107b53
80105389:	53                   	push   %ebx
8010538a:	e8 51 cd ff ff       	call   801020e0 <namecmp>
8010538f:	83 c4 10             	add    $0x10,%esp
80105392:	85 c0                	test   %eax,%eax
80105394:	0f 84 ea 00 00 00    	je     80105484 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010539a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010539d:	83 ec 04             	sub    $0x4,%esp
801053a0:	50                   	push   %eax
801053a1:	53                   	push   %ebx
801053a2:	56                   	push   %esi
801053a3:	e8 58 cd ff ff       	call   80102100 <dirlookup>
801053a8:	83 c4 10             	add    $0x10,%esp
801053ab:	85 c0                	test   %eax,%eax
801053ad:	89 c3                	mov    %eax,%ebx
801053af:	0f 84 cf 00 00 00    	je     80105484 <sys_unlink+0x164>
  ilock(ip);
801053b5:	83 ec 0c             	sub    $0xc,%esp
801053b8:	50                   	push   %eax
801053b9:	e8 12 c8 ff ff       	call   80101bd0 <ilock>
  if(ip->nlink < 1)
801053be:	83 c4 10             	add    $0x10,%esp
801053c1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801053c6:	0f 8e 10 01 00 00    	jle    801054dc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801053cc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053d1:	74 6d                	je     80105440 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801053d3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801053d6:	83 ec 04             	sub    $0x4,%esp
801053d9:	6a 10                	push   $0x10
801053db:	6a 00                	push   $0x0
801053dd:	50                   	push   %eax
801053de:	e8 bd f5 ff ff       	call   801049a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053e3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801053e6:	6a 10                	push   $0x10
801053e8:	ff 75 c4             	pushl  -0x3c(%ebp)
801053eb:	50                   	push   %eax
801053ec:	56                   	push   %esi
801053ed:	e8 be cb ff ff       	call   80101fb0 <writei>
801053f2:	83 c4 20             	add    $0x20,%esp
801053f5:	83 f8 10             	cmp    $0x10,%eax
801053f8:	0f 85 eb 00 00 00    	jne    801054e9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801053fe:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105403:	0f 84 97 00 00 00    	je     801054a0 <sys_unlink+0x180>
  iunlockput(dp);
80105409:	83 ec 0c             	sub    $0xc,%esp
8010540c:	56                   	push   %esi
8010540d:	e8 4e ca ff ff       	call   80101e60 <iunlockput>
  ip->nlink--;
80105412:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105417:	89 1c 24             	mov    %ebx,(%esp)
8010541a:	e8 01 c7 ff ff       	call   80101b20 <iupdate>
  iunlockput(ip);
8010541f:	89 1c 24             	mov    %ebx,(%esp)
80105422:	e8 39 ca ff ff       	call   80101e60 <iunlockput>
  end_op();
80105427:	e8 34 dd ff ff       	call   80103160 <end_op>
  return 0;
8010542c:	83 c4 10             	add    $0x10,%esp
8010542f:	31 c0                	xor    %eax,%eax
}
80105431:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105434:	5b                   	pop    %ebx
80105435:	5e                   	pop    %esi
80105436:	5f                   	pop    %edi
80105437:	5d                   	pop    %ebp
80105438:	c3                   	ret    
80105439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105440:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105444:	76 8d                	jbe    801053d3 <sys_unlink+0xb3>
80105446:	bf 20 00 00 00       	mov    $0x20,%edi
8010544b:	eb 0f                	jmp    8010545c <sys_unlink+0x13c>
8010544d:	8d 76 00             	lea    0x0(%esi),%esi
80105450:	83 c7 10             	add    $0x10,%edi
80105453:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105456:	0f 83 77 ff ff ff    	jae    801053d3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010545c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010545f:	6a 10                	push   $0x10
80105461:	57                   	push   %edi
80105462:	50                   	push   %eax
80105463:	53                   	push   %ebx
80105464:	e8 47 ca ff ff       	call   80101eb0 <readi>
80105469:	83 c4 10             	add    $0x10,%esp
8010546c:	83 f8 10             	cmp    $0x10,%eax
8010546f:	75 5e                	jne    801054cf <sys_unlink+0x1af>
    if(de.inum != 0)
80105471:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105476:	74 d8                	je     80105450 <sys_unlink+0x130>
    iunlockput(ip);
80105478:	83 ec 0c             	sub    $0xc,%esp
8010547b:	53                   	push   %ebx
8010547c:	e8 df c9 ff ff       	call   80101e60 <iunlockput>
    goto bad;
80105481:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105484:	83 ec 0c             	sub    $0xc,%esp
80105487:	56                   	push   %esi
80105488:	e8 d3 c9 ff ff       	call   80101e60 <iunlockput>
  end_op();
8010548d:	e8 ce dc ff ff       	call   80103160 <end_op>
  return -1;
80105492:	83 c4 10             	add    $0x10,%esp
80105495:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549a:	eb 95                	jmp    80105431 <sys_unlink+0x111>
8010549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801054a0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801054a5:	83 ec 0c             	sub    $0xc,%esp
801054a8:	56                   	push   %esi
801054a9:	e8 72 c6 ff ff       	call   80101b20 <iupdate>
801054ae:	83 c4 10             	add    $0x10,%esp
801054b1:	e9 53 ff ff ff       	jmp    80105409 <sys_unlink+0xe9>
    return -1;
801054b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054bb:	e9 71 ff ff ff       	jmp    80105431 <sys_unlink+0x111>
    end_op();
801054c0:	e8 9b dc ff ff       	call   80103160 <end_op>
    return -1;
801054c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ca:	e9 62 ff ff ff       	jmp    80105431 <sys_unlink+0x111>
      panic("isdirempty: readi");
801054cf:	83 ec 0c             	sub    $0xc,%esp
801054d2:	68 78 7b 10 80       	push   $0x80107b78
801054d7:	e8 24 b0 ff ff       	call   80100500 <panic>
    panic("unlink: nlink < 1");
801054dc:	83 ec 0c             	sub    $0xc,%esp
801054df:	68 66 7b 10 80       	push   $0x80107b66
801054e4:	e8 17 b0 ff ff       	call   80100500 <panic>
    panic("unlink: writei");
801054e9:	83 ec 0c             	sub    $0xc,%esp
801054ec:	68 8a 7b 10 80       	push   $0x80107b8a
801054f1:	e8 0a b0 ff ff       	call   80100500 <panic>
801054f6:	8d 76 00             	lea    0x0(%esi),%esi
801054f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105500 <sys_open>:

int
sys_open(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	57                   	push   %edi
80105504:	56                   	push   %esi
80105505:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105506:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105509:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010550c:	50                   	push   %eax
8010550d:	6a 00                	push   $0x0
8010550f:	e8 3c f8 ff ff       	call   80104d50 <argstr>
80105514:	83 c4 10             	add    $0x10,%esp
80105517:	85 c0                	test   %eax,%eax
80105519:	0f 88 1d 01 00 00    	js     8010563c <sys_open+0x13c>
8010551f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105522:	83 ec 08             	sub    $0x8,%esp
80105525:	50                   	push   %eax
80105526:	6a 01                	push   $0x1
80105528:	e8 73 f7 ff ff       	call   80104ca0 <argint>
8010552d:	83 c4 10             	add    $0x10,%esp
80105530:	85 c0                	test   %eax,%eax
80105532:	0f 88 04 01 00 00    	js     8010563c <sys_open+0x13c>
    return -1;

  begin_op();
80105538:	e8 b3 db ff ff       	call   801030f0 <begin_op>

  if(omode & O_CREATE){
8010553d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105541:	0f 85 a9 00 00 00    	jne    801055f0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105547:	83 ec 0c             	sub    $0xc,%esp
8010554a:	ff 75 e0             	pushl  -0x20(%ebp)
8010554d:	e8 de ce ff ff       	call   80102430 <namei>
80105552:	83 c4 10             	add    $0x10,%esp
80105555:	85 c0                	test   %eax,%eax
80105557:	89 c6                	mov    %eax,%esi
80105559:	0f 84 b2 00 00 00    	je     80105611 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010555f:	83 ec 0c             	sub    $0xc,%esp
80105562:	50                   	push   %eax
80105563:	e8 68 c6 ff ff       	call   80101bd0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105568:	83 c4 10             	add    $0x10,%esp
8010556b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105570:	0f 84 aa 00 00 00    	je     80105620 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105576:	e8 55 bd ff ff       	call   801012d0 <filealloc>
8010557b:	85 c0                	test   %eax,%eax
8010557d:	89 c7                	mov    %eax,%edi
8010557f:	0f 84 a6 00 00 00    	je     8010562b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105585:	e8 a6 e7 ff ff       	call   80103d30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010558a:	31 db                	xor    %ebx,%ebx
8010558c:	eb 0e                	jmp    8010559c <sys_open+0x9c>
8010558e:	66 90                	xchg   %ax,%ax
80105590:	83 c3 01             	add    $0x1,%ebx
80105593:	83 fb 10             	cmp    $0x10,%ebx
80105596:	0f 84 ac 00 00 00    	je     80105648 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010559c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055a0:	85 d2                	test   %edx,%edx
801055a2:	75 ec                	jne    80105590 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055a4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055a7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801055ab:	56                   	push   %esi
801055ac:	e8 ff c6 ff ff       	call   80101cb0 <iunlock>
  end_op();
801055b1:	e8 aa db ff ff       	call   80103160 <end_op>

  f->type = FD_INODE;
801055b6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055bf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055c2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801055c5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801055cc:	89 d0                	mov    %edx,%eax
801055ce:	f7 d0                	not    %eax
801055d0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055d3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055d6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055d9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801055dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055e0:	89 d8                	mov    %ebx,%eax
801055e2:	5b                   	pop    %ebx
801055e3:	5e                   	pop    %esi
801055e4:	5f                   	pop    %edi
801055e5:	5d                   	pop    %ebp
801055e6:	c3                   	ret    
801055e7:	89 f6                	mov    %esi,%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801055f0:	83 ec 0c             	sub    $0xc,%esp
801055f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055f6:	31 c9                	xor    %ecx,%ecx
801055f8:	6a 00                	push   $0x0
801055fa:	ba 02 00 00 00       	mov    $0x2,%edx
801055ff:	e8 ec f7 ff ff       	call   80104df0 <create>
    if(ip == 0){
80105604:	83 c4 10             	add    $0x10,%esp
80105607:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105609:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010560b:	0f 85 65 ff ff ff    	jne    80105576 <sys_open+0x76>
      end_op();
80105611:	e8 4a db ff ff       	call   80103160 <end_op>
      return -1;
80105616:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010561b:	eb c0                	jmp    801055dd <sys_open+0xdd>
8010561d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105620:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105623:	85 c9                	test   %ecx,%ecx
80105625:	0f 84 4b ff ff ff    	je     80105576 <sys_open+0x76>
    iunlockput(ip);
8010562b:	83 ec 0c             	sub    $0xc,%esp
8010562e:	56                   	push   %esi
8010562f:	e8 2c c8 ff ff       	call   80101e60 <iunlockput>
    end_op();
80105634:	e8 27 db ff ff       	call   80103160 <end_op>
    return -1;
80105639:	83 c4 10             	add    $0x10,%esp
8010563c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105641:	eb 9a                	jmp    801055dd <sys_open+0xdd>
80105643:	90                   	nop
80105644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	57                   	push   %edi
8010564c:	e8 3f bd ff ff       	call   80101390 <fileclose>
80105651:	83 c4 10             	add    $0x10,%esp
80105654:	eb d5                	jmp    8010562b <sys_open+0x12b>
80105656:	8d 76 00             	lea    0x0(%esi),%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105660 <sys_mkdir>:

int
sys_mkdir(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105666:	e8 85 da ff ff       	call   801030f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010566b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010566e:	83 ec 08             	sub    $0x8,%esp
80105671:	50                   	push   %eax
80105672:	6a 00                	push   $0x0
80105674:	e8 d7 f6 ff ff       	call   80104d50 <argstr>
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	85 c0                	test   %eax,%eax
8010567e:	78 30                	js     801056b0 <sys_mkdir+0x50>
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105686:	31 c9                	xor    %ecx,%ecx
80105688:	6a 00                	push   $0x0
8010568a:	ba 01 00 00 00       	mov    $0x1,%edx
8010568f:	e8 5c f7 ff ff       	call   80104df0 <create>
80105694:	83 c4 10             	add    $0x10,%esp
80105697:	85 c0                	test   %eax,%eax
80105699:	74 15                	je     801056b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010569b:	83 ec 0c             	sub    $0xc,%esp
8010569e:	50                   	push   %eax
8010569f:	e8 bc c7 ff ff       	call   80101e60 <iunlockput>
  end_op();
801056a4:	e8 b7 da ff ff       	call   80103160 <end_op>
  return 0;
801056a9:	83 c4 10             	add    $0x10,%esp
801056ac:	31 c0                	xor    %eax,%eax
}
801056ae:	c9                   	leave  
801056af:	c3                   	ret    
    end_op();
801056b0:	e8 ab da ff ff       	call   80103160 <end_op>
    return -1;
801056b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ba:	c9                   	leave  
801056bb:	c3                   	ret    
801056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056c0 <sys_mknod>:

int
sys_mknod(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801056c6:	e8 25 da ff ff       	call   801030f0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801056cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056ce:	83 ec 08             	sub    $0x8,%esp
801056d1:	50                   	push   %eax
801056d2:	6a 00                	push   $0x0
801056d4:	e8 77 f6 ff ff       	call   80104d50 <argstr>
801056d9:	83 c4 10             	add    $0x10,%esp
801056dc:	85 c0                	test   %eax,%eax
801056de:	78 60                	js     80105740 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056e3:	83 ec 08             	sub    $0x8,%esp
801056e6:	50                   	push   %eax
801056e7:	6a 01                	push   $0x1
801056e9:	e8 b2 f5 ff ff       	call   80104ca0 <argint>
  if((argstr(0, &path)) < 0 ||
801056ee:	83 c4 10             	add    $0x10,%esp
801056f1:	85 c0                	test   %eax,%eax
801056f3:	78 4b                	js     80105740 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801056f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056f8:	83 ec 08             	sub    $0x8,%esp
801056fb:	50                   	push   %eax
801056fc:	6a 02                	push   $0x2
801056fe:	e8 9d f5 ff ff       	call   80104ca0 <argint>
     argint(1, &major) < 0 ||
80105703:	83 c4 10             	add    $0x10,%esp
80105706:	85 c0                	test   %eax,%eax
80105708:	78 36                	js     80105740 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010570a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010570e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105711:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105715:	ba 03 00 00 00       	mov    $0x3,%edx
8010571a:	50                   	push   %eax
8010571b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010571e:	e8 cd f6 ff ff       	call   80104df0 <create>
80105723:	83 c4 10             	add    $0x10,%esp
80105726:	85 c0                	test   %eax,%eax
80105728:	74 16                	je     80105740 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010572a:	83 ec 0c             	sub    $0xc,%esp
8010572d:	50                   	push   %eax
8010572e:	e8 2d c7 ff ff       	call   80101e60 <iunlockput>
  end_op();
80105733:	e8 28 da ff ff       	call   80103160 <end_op>
  return 0;
80105738:	83 c4 10             	add    $0x10,%esp
8010573b:	31 c0                	xor    %eax,%eax
}
8010573d:	c9                   	leave  
8010573e:	c3                   	ret    
8010573f:	90                   	nop
    end_op();
80105740:	e8 1b da ff ff       	call   80103160 <end_op>
    return -1;
80105745:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010574a:	c9                   	leave  
8010574b:	c3                   	ret    
8010574c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105750 <sys_chdir>:

int
sys_chdir(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	56                   	push   %esi
80105754:	53                   	push   %ebx
80105755:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105758:	e8 d3 e5 ff ff       	call   80103d30 <myproc>
8010575d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010575f:	e8 8c d9 ff ff       	call   801030f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105764:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105767:	83 ec 08             	sub    $0x8,%esp
8010576a:	50                   	push   %eax
8010576b:	6a 00                	push   $0x0
8010576d:	e8 de f5 ff ff       	call   80104d50 <argstr>
80105772:	83 c4 10             	add    $0x10,%esp
80105775:	85 c0                	test   %eax,%eax
80105777:	78 77                	js     801057f0 <sys_chdir+0xa0>
80105779:	83 ec 0c             	sub    $0xc,%esp
8010577c:	ff 75 f4             	pushl  -0xc(%ebp)
8010577f:	e8 ac cc ff ff       	call   80102430 <namei>
80105784:	83 c4 10             	add    $0x10,%esp
80105787:	85 c0                	test   %eax,%eax
80105789:	89 c3                	mov    %eax,%ebx
8010578b:	74 63                	je     801057f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010578d:	83 ec 0c             	sub    $0xc,%esp
80105790:	50                   	push   %eax
80105791:	e8 3a c4 ff ff       	call   80101bd0 <ilock>
  if(ip->type != T_DIR){
80105796:	83 c4 10             	add    $0x10,%esp
80105799:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010579e:	75 30                	jne    801057d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057a0:	83 ec 0c             	sub    $0xc,%esp
801057a3:	53                   	push   %ebx
801057a4:	e8 07 c5 ff ff       	call   80101cb0 <iunlock>
  iput(curproc->cwd);
801057a9:	58                   	pop    %eax
801057aa:	ff 76 68             	pushl  0x68(%esi)
801057ad:	e8 4e c5 ff ff       	call   80101d00 <iput>
  end_op();
801057b2:	e8 a9 d9 ff ff       	call   80103160 <end_op>
  curproc->cwd = ip;
801057b7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801057ba:	83 c4 10             	add    $0x10,%esp
801057bd:	31 c0                	xor    %eax,%eax
}
801057bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057c2:	5b                   	pop    %ebx
801057c3:	5e                   	pop    %esi
801057c4:	5d                   	pop    %ebp
801057c5:	c3                   	ret    
801057c6:	8d 76 00             	lea    0x0(%esi),%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801057d0:	83 ec 0c             	sub    $0xc,%esp
801057d3:	53                   	push   %ebx
801057d4:	e8 87 c6 ff ff       	call   80101e60 <iunlockput>
    end_op();
801057d9:	e8 82 d9 ff ff       	call   80103160 <end_op>
    return -1;
801057de:	83 c4 10             	add    $0x10,%esp
801057e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e6:	eb d7                	jmp    801057bf <sys_chdir+0x6f>
801057e8:	90                   	nop
801057e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801057f0:	e8 6b d9 ff ff       	call   80103160 <end_op>
    return -1;
801057f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057fa:	eb c3                	jmp    801057bf <sys_chdir+0x6f>
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105800 <sys_exec>:

int
sys_exec(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	57                   	push   %edi
80105804:	56                   	push   %esi
80105805:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105806:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010580c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105812:	50                   	push   %eax
80105813:	6a 00                	push   $0x0
80105815:	e8 36 f5 ff ff       	call   80104d50 <argstr>
8010581a:	83 c4 10             	add    $0x10,%esp
8010581d:	85 c0                	test   %eax,%eax
8010581f:	0f 88 87 00 00 00    	js     801058ac <sys_exec+0xac>
80105825:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010582b:	83 ec 08             	sub    $0x8,%esp
8010582e:	50                   	push   %eax
8010582f:	6a 01                	push   $0x1
80105831:	e8 6a f4 ff ff       	call   80104ca0 <argint>
80105836:	83 c4 10             	add    $0x10,%esp
80105839:	85 c0                	test   %eax,%eax
8010583b:	78 6f                	js     801058ac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010583d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105843:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105846:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105848:	68 80 00 00 00       	push   $0x80
8010584d:	6a 00                	push   $0x0
8010584f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105855:	50                   	push   %eax
80105856:	e8 45 f1 ff ff       	call   801049a0 <memset>
8010585b:	83 c4 10             	add    $0x10,%esp
8010585e:	eb 2c                	jmp    8010588c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105860:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105866:	85 c0                	test   %eax,%eax
80105868:	74 56                	je     801058c0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010586a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105870:	83 ec 08             	sub    $0x8,%esp
80105873:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105876:	52                   	push   %edx
80105877:	50                   	push   %eax
80105878:	e8 b3 f3 ff ff       	call   80104c30 <fetchstr>
8010587d:	83 c4 10             	add    $0x10,%esp
80105880:	85 c0                	test   %eax,%eax
80105882:	78 28                	js     801058ac <sys_exec+0xac>
  for(i=0;; i++){
80105884:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105887:	83 fb 20             	cmp    $0x20,%ebx
8010588a:	74 20                	je     801058ac <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010588c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105892:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105899:	83 ec 08             	sub    $0x8,%esp
8010589c:	57                   	push   %edi
8010589d:	01 f0                	add    %esi,%eax
8010589f:	50                   	push   %eax
801058a0:	e8 4b f3 ff ff       	call   80104bf0 <fetchint>
801058a5:	83 c4 10             	add    $0x10,%esp
801058a8:	85 c0                	test   %eax,%eax
801058aa:	79 b4                	jns    80105860 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801058ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801058af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058b4:	5b                   	pop    %ebx
801058b5:	5e                   	pop    %esi
801058b6:	5f                   	pop    %edi
801058b7:	5d                   	pop    %ebp
801058b8:	c3                   	ret    
801058b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801058c0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801058c6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801058c9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801058d0:	00 00 00 00 
  return exec(path, argv);
801058d4:	50                   	push   %eax
801058d5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801058db:	e8 80 b6 ff ff       	call   80100f60 <exec>
801058e0:	83 c4 10             	add    $0x10,%esp
}
801058e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058e6:	5b                   	pop    %ebx
801058e7:	5e                   	pop    %esi
801058e8:	5f                   	pop    %edi
801058e9:	5d                   	pop    %ebp
801058ea:	c3                   	ret    
801058eb:	90                   	nop
801058ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058f0 <sys_pipe>:

int
sys_pipe(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	57                   	push   %edi
801058f4:	56                   	push   %esi
801058f5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058f6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058f9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058fc:	6a 08                	push   $0x8
801058fe:	50                   	push   %eax
801058ff:	6a 00                	push   $0x0
80105901:	e8 ea f3 ff ff       	call   80104cf0 <argptr>
80105906:	83 c4 10             	add    $0x10,%esp
80105909:	85 c0                	test   %eax,%eax
8010590b:	0f 88 ae 00 00 00    	js     801059bf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105911:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105914:	83 ec 08             	sub    $0x8,%esp
80105917:	50                   	push   %eax
80105918:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010591b:	50                   	push   %eax
8010591c:	e8 6f de ff ff       	call   80103790 <pipealloc>
80105921:	83 c4 10             	add    $0x10,%esp
80105924:	85 c0                	test   %eax,%eax
80105926:	0f 88 93 00 00 00    	js     801059bf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010592c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010592f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105931:	e8 fa e3 ff ff       	call   80103d30 <myproc>
80105936:	eb 10                	jmp    80105948 <sys_pipe+0x58>
80105938:	90                   	nop
80105939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105940:	83 c3 01             	add    $0x1,%ebx
80105943:	83 fb 10             	cmp    $0x10,%ebx
80105946:	74 60                	je     801059a8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105948:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010594c:	85 f6                	test   %esi,%esi
8010594e:	75 f0                	jne    80105940 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105950:	8d 73 08             	lea    0x8(%ebx),%esi
80105953:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105957:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010595a:	e8 d1 e3 ff ff       	call   80103d30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010595f:	31 d2                	xor    %edx,%edx
80105961:	eb 0d                	jmp    80105970 <sys_pipe+0x80>
80105963:	90                   	nop
80105964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105968:	83 c2 01             	add    $0x1,%edx
8010596b:	83 fa 10             	cmp    $0x10,%edx
8010596e:	74 28                	je     80105998 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105970:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105974:	85 c9                	test   %ecx,%ecx
80105976:	75 f0                	jne    80105968 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105978:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010597c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010597f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105981:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105984:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105987:	31 c0                	xor    %eax,%eax
}
80105989:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010598c:	5b                   	pop    %ebx
8010598d:	5e                   	pop    %esi
8010598e:	5f                   	pop    %edi
8010598f:	5d                   	pop    %ebp
80105990:	c3                   	ret    
80105991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105998:	e8 93 e3 ff ff       	call   80103d30 <myproc>
8010599d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801059a4:	00 
801059a5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801059a8:	83 ec 0c             	sub    $0xc,%esp
801059ab:	ff 75 e0             	pushl  -0x20(%ebp)
801059ae:	e8 dd b9 ff ff       	call   80101390 <fileclose>
    fileclose(wf);
801059b3:	58                   	pop    %eax
801059b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801059b7:	e8 d4 b9 ff ff       	call   80101390 <fileclose>
    return -1;
801059bc:	83 c4 10             	add    $0x10,%esp
801059bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c4:	eb c3                	jmp    80105989 <sys_pipe+0x99>
801059c6:	66 90                	xchg   %ax,%ax
801059c8:	66 90                	xchg   %ax,%ax
801059ca:	66 90                	xchg   %ax,%ax
801059cc:	66 90                	xchg   %ax,%ax
801059ce:	66 90                	xchg   %ax,%ax

801059d0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801059d3:	5d                   	pop    %ebp
  return fork();
801059d4:	e9 f7 e4 ff ff       	jmp    80103ed0 <fork>
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059e0 <sys_exit>:

int
sys_exit(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059e6:	e8 65 e7 ff ff       	call   80104150 <exit>
  return 0;  // not reached
}
801059eb:	31 c0                	xor    %eax,%eax
801059ed:	c9                   	leave  
801059ee:	c3                   	ret    
801059ef:	90                   	nop

801059f0 <sys_wait>:

int
sys_wait(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801059f3:	5d                   	pop    %ebp
  return wait();
801059f4:	e9 97 e9 ff ff       	jmp    80104390 <wait>
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a00 <sys_kill>:

int
sys_kill(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a09:	50                   	push   %eax
80105a0a:	6a 00                	push   $0x0
80105a0c:	e8 8f f2 ff ff       	call   80104ca0 <argint>
80105a11:	83 c4 10             	add    $0x10,%esp
80105a14:	85 c0                	test   %eax,%eax
80105a16:	78 18                	js     80105a30 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a18:	83 ec 0c             	sub    $0xc,%esp
80105a1b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a1e:	e8 bd ea ff ff       	call   801044e0 <kill>
80105a23:	83 c4 10             	add    $0x10,%esp
}
80105a26:	c9                   	leave  
80105a27:	c3                   	ret    
80105a28:	90                   	nop
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a35:	c9                   	leave  
80105a36:	c3                   	ret    
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a40 <sys_getpid>:

int
sys_getpid(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a46:	e8 e5 e2 ff ff       	call   80103d30 <myproc>
80105a4b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a4e:	c9                   	leave  
80105a4f:	c3                   	ret    

80105a50 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a5a:	50                   	push   %eax
80105a5b:	6a 00                	push   $0x0
80105a5d:	e8 3e f2 ff ff       	call   80104ca0 <argint>
80105a62:	83 c4 10             	add    $0x10,%esp
80105a65:	85 c0                	test   %eax,%eax
80105a67:	78 27                	js     80105a90 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a69:	e8 c2 e2 ff ff       	call   80103d30 <myproc>
  if(growproc(n) < 0)
80105a6e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a71:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a73:	ff 75 f4             	pushl  -0xc(%ebp)
80105a76:	e8 d5 e3 ff ff       	call   80103e50 <growproc>
80105a7b:	83 c4 10             	add    $0x10,%esp
80105a7e:	85 c0                	test   %eax,%eax
80105a80:	78 0e                	js     80105a90 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a82:	89 d8                	mov    %ebx,%eax
80105a84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a87:	c9                   	leave  
80105a88:	c3                   	ret    
80105a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a90:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a95:	eb eb                	jmp    80105a82 <sys_sbrk+0x32>
80105a97:	89 f6                	mov    %esi,%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105aa0 <sys_sleep>:

int
sys_sleep(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105aa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105aa7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105aaa:	50                   	push   %eax
80105aab:	6a 00                	push   $0x0
80105aad:	e8 ee f1 ff ff       	call   80104ca0 <argint>
80105ab2:	83 c4 10             	add    $0x10,%esp
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	0f 88 8a 00 00 00    	js     80105b47 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105abd:	83 ec 0c             	sub    $0xc,%esp
80105ac0:	68 80 54 11 80       	push   $0x80115480
80105ac5:	e8 c6 ed ff ff       	call   80104890 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105aca:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105acd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105ad0:	8b 1d c0 5c 11 80    	mov    0x80115cc0,%ebx
  while(ticks - ticks0 < n){
80105ad6:	85 d2                	test   %edx,%edx
80105ad8:	75 27                	jne    80105b01 <sys_sleep+0x61>
80105ada:	eb 54                	jmp    80105b30 <sys_sleep+0x90>
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ae0:	83 ec 08             	sub    $0x8,%esp
80105ae3:	68 80 54 11 80       	push   $0x80115480
80105ae8:	68 c0 5c 11 80       	push   $0x80115cc0
80105aed:	e8 de e7 ff ff       	call   801042d0 <sleep>
  while(ticks - ticks0 < n){
80105af2:	a1 c0 5c 11 80       	mov    0x80115cc0,%eax
80105af7:	83 c4 10             	add    $0x10,%esp
80105afa:	29 d8                	sub    %ebx,%eax
80105afc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105aff:	73 2f                	jae    80105b30 <sys_sleep+0x90>
    if(myproc()->killed){
80105b01:	e8 2a e2 ff ff       	call   80103d30 <myproc>
80105b06:	8b 40 24             	mov    0x24(%eax),%eax
80105b09:	85 c0                	test   %eax,%eax
80105b0b:	74 d3                	je     80105ae0 <sys_sleep+0x40>
      release(&tickslock);
80105b0d:	83 ec 0c             	sub    $0xc,%esp
80105b10:	68 80 54 11 80       	push   $0x80115480
80105b15:	e8 36 ee ff ff       	call   80104950 <release>
      return -1;
80105b1a:	83 c4 10             	add    $0x10,%esp
80105b1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105b22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b25:	c9                   	leave  
80105b26:	c3                   	ret    
80105b27:	89 f6                	mov    %esi,%esi
80105b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	68 80 54 11 80       	push   $0x80115480
80105b38:	e8 13 ee ff ff       	call   80104950 <release>
  return 0;
80105b3d:	83 c4 10             	add    $0x10,%esp
80105b40:	31 c0                	xor    %eax,%eax
}
80105b42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b45:	c9                   	leave  
80105b46:	c3                   	ret    
    return -1;
80105b47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b4c:	eb f4                	jmp    80105b42 <sys_sleep+0xa2>
80105b4e:	66 90                	xchg   %ax,%ax

80105b50 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	53                   	push   %ebx
80105b54:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b57:	68 80 54 11 80       	push   $0x80115480
80105b5c:	e8 2f ed ff ff       	call   80104890 <acquire>
  xticks = ticks;
80105b61:	8b 1d c0 5c 11 80    	mov    0x80115cc0,%ebx
  release(&tickslock);
80105b67:	c7 04 24 80 54 11 80 	movl   $0x80115480,(%esp)
80105b6e:	e8 dd ed ff ff       	call   80104950 <release>
  return xticks;
}
80105b73:	89 d8                	mov    %ebx,%eax
80105b75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b78:	c9                   	leave  
80105b79:	c3                   	ret    

80105b7a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b7a:	1e                   	push   %ds
  pushl %es
80105b7b:	06                   	push   %es
  pushl %fs
80105b7c:	0f a0                	push   %fs
  pushl %gs
80105b7e:	0f a8                	push   %gs
  pushal
80105b80:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b81:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b85:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b87:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b89:	54                   	push   %esp
  call trap
80105b8a:	e8 c1 00 00 00       	call   80105c50 <trap>
  addl $4, %esp
80105b8f:	83 c4 04             	add    $0x4,%esp

80105b92 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b92:	61                   	popa   
  popl %gs
80105b93:	0f a9                	pop    %gs
  popl %fs
80105b95:	0f a1                	pop    %fs
  popl %es
80105b97:	07                   	pop    %es
  popl %ds
80105b98:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b99:	83 c4 08             	add    $0x8,%esp
  iret
80105b9c:	cf                   	iret   
80105b9d:	66 90                	xchg   %ax,%ax
80105b9f:	90                   	nop

80105ba0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ba0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ba1:	31 c0                	xor    %eax,%eax
{
80105ba3:	89 e5                	mov    %esp,%ebp
80105ba5:	83 ec 08             	sub    $0x8,%esp
80105ba8:	90                   	nop
80105ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105bb0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105bb7:	c7 04 c5 c2 54 11 80 	movl   $0x8e000008,-0x7feeab3e(,%eax,8)
80105bbe:	08 00 00 8e 
80105bc2:	66 89 14 c5 c0 54 11 	mov    %dx,-0x7feeab40(,%eax,8)
80105bc9:	80 
80105bca:	c1 ea 10             	shr    $0x10,%edx
80105bcd:	66 89 14 c5 c6 54 11 	mov    %dx,-0x7feeab3a(,%eax,8)
80105bd4:	80 
  for(i = 0; i < 256; i++)
80105bd5:	83 c0 01             	add    $0x1,%eax
80105bd8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bdd:	75 d1                	jne    80105bb0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bdf:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105be4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105be7:	c7 05 c2 56 11 80 08 	movl   $0xef000008,0x801156c2
80105bee:	00 00 ef 
  initlock(&tickslock, "time");
80105bf1:	68 99 7b 10 80       	push   $0x80107b99
80105bf6:	68 80 54 11 80       	push   $0x80115480
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bfb:	66 a3 c0 56 11 80    	mov    %ax,0x801156c0
80105c01:	c1 e8 10             	shr    $0x10,%eax
80105c04:	66 a3 c6 56 11 80    	mov    %ax,0x801156c6
  initlock(&tickslock, "time");
80105c0a:	e8 41 eb ff ff       	call   80104750 <initlock>
}
80105c0f:	83 c4 10             	add    $0x10,%esp
80105c12:	c9                   	leave  
80105c13:	c3                   	ret    
80105c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105c20 <idtinit>:

void
idtinit(void)
{
80105c20:	55                   	push   %ebp
  pd[0] = size-1;
80105c21:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c26:	89 e5                	mov    %esp,%ebp
80105c28:	83 ec 10             	sub    $0x10,%esp
80105c2b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c2f:	b8 c0 54 11 80       	mov    $0x801154c0,%eax
80105c34:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c38:	c1 e8 10             	shr    $0x10,%eax
80105c3b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c3f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c42:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c45:	c9                   	leave  
80105c46:	c3                   	ret    
80105c47:	89 f6                	mov    %esi,%esi
80105c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c50 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	57                   	push   %edi
80105c54:	56                   	push   %esi
80105c55:	53                   	push   %ebx
80105c56:	83 ec 1c             	sub    $0x1c,%esp
80105c59:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105c5c:	8b 47 30             	mov    0x30(%edi),%eax
80105c5f:	83 f8 40             	cmp    $0x40,%eax
80105c62:	0f 84 f0 00 00 00    	je     80105d58 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c68:	83 e8 20             	sub    $0x20,%eax
80105c6b:	83 f8 1f             	cmp    $0x1f,%eax
80105c6e:	77 10                	ja     80105c80 <trap+0x30>
80105c70:	ff 24 85 40 7c 10 80 	jmp    *-0x7fef83c0(,%eax,4)
80105c77:	89 f6                	mov    %esi,%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c80:	e8 ab e0 ff ff       	call   80103d30 <myproc>
80105c85:	85 c0                	test   %eax,%eax
80105c87:	8b 5f 38             	mov    0x38(%edi),%ebx
80105c8a:	0f 84 14 02 00 00    	je     80105ea4 <trap+0x254>
80105c90:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105c94:	0f 84 0a 02 00 00    	je     80105ea4 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c9a:	0f 20 d1             	mov    %cr2,%ecx
80105c9d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ca0:	e8 6b e0 ff ff       	call   80103d10 <cpuid>
80105ca5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105ca8:	8b 47 34             	mov    0x34(%edi),%eax
80105cab:	8b 77 30             	mov    0x30(%edi),%esi
80105cae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105cb1:	e8 7a e0 ff ff       	call   80103d30 <myproc>
80105cb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105cb9:	e8 72 e0 ff ff       	call   80103d30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cbe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105cc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105cc4:	51                   	push   %ecx
80105cc5:	53                   	push   %ebx
80105cc6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105cc7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cca:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ccd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105cce:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cd1:	52                   	push   %edx
80105cd2:	ff 70 10             	pushl  0x10(%eax)
80105cd5:	68 fc 7b 10 80       	push   $0x80107bfc
80105cda:	e8 31 ab ff ff       	call   80100810 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105cdf:	83 c4 20             	add    $0x20,%esp
80105ce2:	e8 49 e0 ff ff       	call   80103d30 <myproc>
80105ce7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cee:	e8 3d e0 ff ff       	call   80103d30 <myproc>
80105cf3:	85 c0                	test   %eax,%eax
80105cf5:	74 1d                	je     80105d14 <trap+0xc4>
80105cf7:	e8 34 e0 ff ff       	call   80103d30 <myproc>
80105cfc:	8b 50 24             	mov    0x24(%eax),%edx
80105cff:	85 d2                	test   %edx,%edx
80105d01:	74 11                	je     80105d14 <trap+0xc4>
80105d03:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d07:	83 e0 03             	and    $0x3,%eax
80105d0a:	66 83 f8 03          	cmp    $0x3,%ax
80105d0e:	0f 84 4c 01 00 00    	je     80105e60 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d14:	e8 17 e0 ff ff       	call   80103d30 <myproc>
80105d19:	85 c0                	test   %eax,%eax
80105d1b:	74 0b                	je     80105d28 <trap+0xd8>
80105d1d:	e8 0e e0 ff ff       	call   80103d30 <myproc>
80105d22:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d26:	74 68                	je     80105d90 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d28:	e8 03 e0 ff ff       	call   80103d30 <myproc>
80105d2d:	85 c0                	test   %eax,%eax
80105d2f:	74 19                	je     80105d4a <trap+0xfa>
80105d31:	e8 fa df ff ff       	call   80103d30 <myproc>
80105d36:	8b 40 24             	mov    0x24(%eax),%eax
80105d39:	85 c0                	test   %eax,%eax
80105d3b:	74 0d                	je     80105d4a <trap+0xfa>
80105d3d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d41:	83 e0 03             	and    $0x3,%eax
80105d44:	66 83 f8 03          	cmp    $0x3,%ax
80105d48:	74 37                	je     80105d81 <trap+0x131>
    exit();
}
80105d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d4d:	5b                   	pop    %ebx
80105d4e:	5e                   	pop    %esi
80105d4f:	5f                   	pop    %edi
80105d50:	5d                   	pop    %ebp
80105d51:	c3                   	ret    
80105d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105d58:	e8 d3 df ff ff       	call   80103d30 <myproc>
80105d5d:	8b 58 24             	mov    0x24(%eax),%ebx
80105d60:	85 db                	test   %ebx,%ebx
80105d62:	0f 85 e8 00 00 00    	jne    80105e50 <trap+0x200>
    myproc()->tf = tf;
80105d68:	e8 c3 df ff ff       	call   80103d30 <myproc>
80105d6d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105d70:	e8 1b f0 ff ff       	call   80104d90 <syscall>
    if(myproc()->killed)
80105d75:	e8 b6 df ff ff       	call   80103d30 <myproc>
80105d7a:	8b 48 24             	mov    0x24(%eax),%ecx
80105d7d:	85 c9                	test   %ecx,%ecx
80105d7f:	74 c9                	je     80105d4a <trap+0xfa>
}
80105d81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d84:	5b                   	pop    %ebx
80105d85:	5e                   	pop    %esi
80105d86:	5f                   	pop    %edi
80105d87:	5d                   	pop    %ebp
      exit();
80105d88:	e9 c3 e3 ff ff       	jmp    80104150 <exit>
80105d8d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105d90:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105d94:	75 92                	jne    80105d28 <trap+0xd8>
    yield();
80105d96:	e8 e5 e4 ff ff       	call   80104280 <yield>
80105d9b:	eb 8b                	jmp    80105d28 <trap+0xd8>
80105d9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105da0:	e8 6b df ff ff       	call   80103d10 <cpuid>
80105da5:	85 c0                	test   %eax,%eax
80105da7:	0f 84 c3 00 00 00    	je     80105e70 <trap+0x220>
    lapiceoi();
80105dad:	e8 ee ce ff ff       	call   80102ca0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105db2:	e8 79 df ff ff       	call   80103d30 <myproc>
80105db7:	85 c0                	test   %eax,%eax
80105db9:	0f 85 38 ff ff ff    	jne    80105cf7 <trap+0xa7>
80105dbf:	e9 50 ff ff ff       	jmp    80105d14 <trap+0xc4>
80105dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105dc8:	e8 93 cd ff ff       	call   80102b60 <kbdintr>
    lapiceoi();
80105dcd:	e8 ce ce ff ff       	call   80102ca0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd2:	e8 59 df ff ff       	call   80103d30 <myproc>
80105dd7:	85 c0                	test   %eax,%eax
80105dd9:	0f 85 18 ff ff ff    	jne    80105cf7 <trap+0xa7>
80105ddf:	e9 30 ff ff ff       	jmp    80105d14 <trap+0xc4>
80105de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105de8:	e8 53 02 00 00       	call   80106040 <uartintr>
    lapiceoi();
80105ded:	e8 ae ce ff ff       	call   80102ca0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105df2:	e8 39 df ff ff       	call   80103d30 <myproc>
80105df7:	85 c0                	test   %eax,%eax
80105df9:	0f 85 f8 fe ff ff    	jne    80105cf7 <trap+0xa7>
80105dff:	e9 10 ff ff ff       	jmp    80105d14 <trap+0xc4>
80105e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e08:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105e0c:	8b 77 38             	mov    0x38(%edi),%esi
80105e0f:	e8 fc de ff ff       	call   80103d10 <cpuid>
80105e14:	56                   	push   %esi
80105e15:	53                   	push   %ebx
80105e16:	50                   	push   %eax
80105e17:	68 a4 7b 10 80       	push   $0x80107ba4
80105e1c:	e8 ef a9 ff ff       	call   80100810 <cprintf>
    lapiceoi();
80105e21:	e8 7a ce ff ff       	call   80102ca0 <lapiceoi>
    break;
80105e26:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e29:	e8 02 df ff ff       	call   80103d30 <myproc>
80105e2e:	85 c0                	test   %eax,%eax
80105e30:	0f 85 c1 fe ff ff    	jne    80105cf7 <trap+0xa7>
80105e36:	e9 d9 fe ff ff       	jmp    80105d14 <trap+0xc4>
80105e3b:	90                   	nop
80105e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105e40:	e8 8b c7 ff ff       	call   801025d0 <ideintr>
80105e45:	e9 63 ff ff ff       	jmp    80105dad <trap+0x15d>
80105e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e50:	e8 fb e2 ff ff       	call   80104150 <exit>
80105e55:	e9 0e ff ff ff       	jmp    80105d68 <trap+0x118>
80105e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105e60:	e8 eb e2 ff ff       	call   80104150 <exit>
80105e65:	e9 aa fe ff ff       	jmp    80105d14 <trap+0xc4>
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105e70:	83 ec 0c             	sub    $0xc,%esp
80105e73:	68 80 54 11 80       	push   $0x80115480
80105e78:	e8 13 ea ff ff       	call   80104890 <acquire>
      wakeup(&ticks);
80105e7d:	c7 04 24 c0 5c 11 80 	movl   $0x80115cc0,(%esp)
      ticks++;
80105e84:	83 05 c0 5c 11 80 01 	addl   $0x1,0x80115cc0
      wakeup(&ticks);
80105e8b:	e8 f0 e5 ff ff       	call   80104480 <wakeup>
      release(&tickslock);
80105e90:	c7 04 24 80 54 11 80 	movl   $0x80115480,(%esp)
80105e97:	e8 b4 ea ff ff       	call   80104950 <release>
80105e9c:	83 c4 10             	add    $0x10,%esp
80105e9f:	e9 09 ff ff ff       	jmp    80105dad <trap+0x15d>
80105ea4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ea7:	e8 64 de ff ff       	call   80103d10 <cpuid>
80105eac:	83 ec 0c             	sub    $0xc,%esp
80105eaf:	56                   	push   %esi
80105eb0:	53                   	push   %ebx
80105eb1:	50                   	push   %eax
80105eb2:	ff 77 30             	pushl  0x30(%edi)
80105eb5:	68 c8 7b 10 80       	push   $0x80107bc8
80105eba:	e8 51 a9 ff ff       	call   80100810 <cprintf>
      panic("trap");
80105ebf:	83 c4 14             	add    $0x14,%esp
80105ec2:	68 9e 7b 10 80       	push   $0x80107b9e
80105ec7:	e8 34 a6 ff ff       	call   80100500 <panic>
80105ecc:	66 90                	xchg   %ax,%ax
80105ece:	66 90                	xchg   %ax,%ax

80105ed0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ed0:	a1 dc a5 10 80       	mov    0x8010a5dc,%eax
{
80105ed5:	55                   	push   %ebp
80105ed6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105ed8:	85 c0                	test   %eax,%eax
80105eda:	74 1c                	je     80105ef8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105edc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ee1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ee2:	a8 01                	test   $0x1,%al
80105ee4:	74 12                	je     80105ef8 <uartgetc+0x28>
80105ee6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105eeb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105eec:	0f b6 c0             	movzbl %al,%eax
}
80105eef:	5d                   	pop    %ebp
80105ef0:	c3                   	ret    
80105ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105efd:	5d                   	pop    %ebp
80105efe:	c3                   	ret    
80105eff:	90                   	nop

80105f00 <uartputc.part.0>:
uartputc(int c)
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	57                   	push   %edi
80105f04:	56                   	push   %esi
80105f05:	53                   	push   %ebx
80105f06:	89 c7                	mov    %eax,%edi
80105f08:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f0d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f12:	83 ec 0c             	sub    $0xc,%esp
80105f15:	eb 1b                	jmp    80105f32 <uartputc.part.0+0x32>
80105f17:	89 f6                	mov    %esi,%esi
80105f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105f20:	83 ec 0c             	sub    $0xc,%esp
80105f23:	6a 0a                	push   $0xa
80105f25:	e8 96 cd ff ff       	call   80102cc0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f2a:	83 c4 10             	add    $0x10,%esp
80105f2d:	83 eb 01             	sub    $0x1,%ebx
80105f30:	74 07                	je     80105f39 <uartputc.part.0+0x39>
80105f32:	89 f2                	mov    %esi,%edx
80105f34:	ec                   	in     (%dx),%al
80105f35:	a8 20                	test   $0x20,%al
80105f37:	74 e7                	je     80105f20 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f39:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f3e:	89 f8                	mov    %edi,%eax
80105f40:	ee                   	out    %al,(%dx)
}
80105f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f44:	5b                   	pop    %ebx
80105f45:	5e                   	pop    %esi
80105f46:	5f                   	pop    %edi
80105f47:	5d                   	pop    %ebp
80105f48:	c3                   	ret    
80105f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f50 <uartinit>:
{
80105f50:	55                   	push   %ebp
80105f51:	31 c9                	xor    %ecx,%ecx
80105f53:	89 c8                	mov    %ecx,%eax
80105f55:	89 e5                	mov    %esp,%ebp
80105f57:	57                   	push   %edi
80105f58:	56                   	push   %esi
80105f59:	53                   	push   %ebx
80105f5a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f5f:	89 da                	mov    %ebx,%edx
80105f61:	83 ec 0c             	sub    $0xc,%esp
80105f64:	ee                   	out    %al,(%dx)
80105f65:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f6f:	89 fa                	mov    %edi,%edx
80105f71:	ee                   	out    %al,(%dx)
80105f72:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f77:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f7c:	ee                   	out    %al,(%dx)
80105f7d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f82:	89 c8                	mov    %ecx,%eax
80105f84:	89 f2                	mov    %esi,%edx
80105f86:	ee                   	out    %al,(%dx)
80105f87:	b8 03 00 00 00       	mov    $0x3,%eax
80105f8c:	89 fa                	mov    %edi,%edx
80105f8e:	ee                   	out    %al,(%dx)
80105f8f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f94:	89 c8                	mov    %ecx,%eax
80105f96:	ee                   	out    %al,(%dx)
80105f97:	b8 01 00 00 00       	mov    $0x1,%eax
80105f9c:	89 f2                	mov    %esi,%edx
80105f9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f9f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fa4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105fa5:	3c ff                	cmp    $0xff,%al
80105fa7:	74 5a                	je     80106003 <uartinit+0xb3>
  uart = 1;
80105fa9:	c7 05 dc a5 10 80 01 	movl   $0x1,0x8010a5dc
80105fb0:	00 00 00 
80105fb3:	89 da                	mov    %ebx,%edx
80105fb5:	ec                   	in     (%dx),%al
80105fb6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fbb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105fbc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105fbf:	bb c0 7c 10 80       	mov    $0x80107cc0,%ebx
  ioapicenable(IRQ_COM1, 0);
80105fc4:	6a 00                	push   $0x0
80105fc6:	6a 04                	push   $0x4
80105fc8:	e8 53 c8 ff ff       	call   80102820 <ioapicenable>
80105fcd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105fd0:	b8 78 00 00 00       	mov    $0x78,%eax
80105fd5:	eb 13                	jmp    80105fea <uartinit+0x9a>
80105fd7:	89 f6                	mov    %esi,%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105fe0:	83 c3 01             	add    $0x1,%ebx
80105fe3:	0f be 03             	movsbl (%ebx),%eax
80105fe6:	84 c0                	test   %al,%al
80105fe8:	74 19                	je     80106003 <uartinit+0xb3>
  if(!uart)
80105fea:	8b 15 dc a5 10 80    	mov    0x8010a5dc,%edx
80105ff0:	85 d2                	test   %edx,%edx
80105ff2:	74 ec                	je     80105fe0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105ff4:	83 c3 01             	add    $0x1,%ebx
80105ff7:	e8 04 ff ff ff       	call   80105f00 <uartputc.part.0>
80105ffc:	0f be 03             	movsbl (%ebx),%eax
80105fff:	84 c0                	test   %al,%al
80106001:	75 e7                	jne    80105fea <uartinit+0x9a>
}
80106003:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106006:	5b                   	pop    %ebx
80106007:	5e                   	pop    %esi
80106008:	5f                   	pop    %edi
80106009:	5d                   	pop    %ebp
8010600a:	c3                   	ret    
8010600b:	90                   	nop
8010600c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106010 <uartputc>:
  if(!uart)
80106010:	8b 15 dc a5 10 80    	mov    0x8010a5dc,%edx
{
80106016:	55                   	push   %ebp
80106017:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106019:	85 d2                	test   %edx,%edx
{
8010601b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010601e:	74 10                	je     80106030 <uartputc+0x20>
}
80106020:	5d                   	pop    %ebp
80106021:	e9 da fe ff ff       	jmp    80105f00 <uartputc.part.0>
80106026:	8d 76 00             	lea    0x0(%esi),%esi
80106029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106030:	5d                   	pop    %ebp
80106031:	c3                   	ret    
80106032:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106040 <uartintr>:

void
uartintr(void)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106046:	68 d0 5e 10 80       	push   $0x80105ed0
8010604b:	e8 d0 a9 ff ff       	call   80100a20 <consoleintr>
}
80106050:	83 c4 10             	add    $0x10,%esp
80106053:	c9                   	leave  
80106054:	c3                   	ret    

80106055 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106055:	6a 00                	push   $0x0
  pushl $0
80106057:	6a 00                	push   $0x0
  jmp alltraps
80106059:	e9 1c fb ff ff       	jmp    80105b7a <alltraps>

8010605e <vector1>:
.globl vector1
vector1:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $1
80106060:	6a 01                	push   $0x1
  jmp alltraps
80106062:	e9 13 fb ff ff       	jmp    80105b7a <alltraps>

80106067 <vector2>:
.globl vector2
vector2:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $2
80106069:	6a 02                	push   $0x2
  jmp alltraps
8010606b:	e9 0a fb ff ff       	jmp    80105b7a <alltraps>

80106070 <vector3>:
.globl vector3
vector3:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $3
80106072:	6a 03                	push   $0x3
  jmp alltraps
80106074:	e9 01 fb ff ff       	jmp    80105b7a <alltraps>

80106079 <vector4>:
.globl vector4
vector4:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $4
8010607b:	6a 04                	push   $0x4
  jmp alltraps
8010607d:	e9 f8 fa ff ff       	jmp    80105b7a <alltraps>

80106082 <vector5>:
.globl vector5
vector5:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $5
80106084:	6a 05                	push   $0x5
  jmp alltraps
80106086:	e9 ef fa ff ff       	jmp    80105b7a <alltraps>

8010608b <vector6>:
.globl vector6
vector6:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $6
8010608d:	6a 06                	push   $0x6
  jmp alltraps
8010608f:	e9 e6 fa ff ff       	jmp    80105b7a <alltraps>

80106094 <vector7>:
.globl vector7
vector7:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $7
80106096:	6a 07                	push   $0x7
  jmp alltraps
80106098:	e9 dd fa ff ff       	jmp    80105b7a <alltraps>

8010609d <vector8>:
.globl vector8
vector8:
  pushl $8
8010609d:	6a 08                	push   $0x8
  jmp alltraps
8010609f:	e9 d6 fa ff ff       	jmp    80105b7a <alltraps>

801060a4 <vector9>:
.globl vector9
vector9:
  pushl $0
801060a4:	6a 00                	push   $0x0
  pushl $9
801060a6:	6a 09                	push   $0x9
  jmp alltraps
801060a8:	e9 cd fa ff ff       	jmp    80105b7a <alltraps>

801060ad <vector10>:
.globl vector10
vector10:
  pushl $10
801060ad:	6a 0a                	push   $0xa
  jmp alltraps
801060af:	e9 c6 fa ff ff       	jmp    80105b7a <alltraps>

801060b4 <vector11>:
.globl vector11
vector11:
  pushl $11
801060b4:	6a 0b                	push   $0xb
  jmp alltraps
801060b6:	e9 bf fa ff ff       	jmp    80105b7a <alltraps>

801060bb <vector12>:
.globl vector12
vector12:
  pushl $12
801060bb:	6a 0c                	push   $0xc
  jmp alltraps
801060bd:	e9 b8 fa ff ff       	jmp    80105b7a <alltraps>

801060c2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060c2:	6a 0d                	push   $0xd
  jmp alltraps
801060c4:	e9 b1 fa ff ff       	jmp    80105b7a <alltraps>

801060c9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060c9:	6a 0e                	push   $0xe
  jmp alltraps
801060cb:	e9 aa fa ff ff       	jmp    80105b7a <alltraps>

801060d0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $15
801060d2:	6a 0f                	push   $0xf
  jmp alltraps
801060d4:	e9 a1 fa ff ff       	jmp    80105b7a <alltraps>

801060d9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $16
801060db:	6a 10                	push   $0x10
  jmp alltraps
801060dd:	e9 98 fa ff ff       	jmp    80105b7a <alltraps>

801060e2 <vector17>:
.globl vector17
vector17:
  pushl $17
801060e2:	6a 11                	push   $0x11
  jmp alltraps
801060e4:	e9 91 fa ff ff       	jmp    80105b7a <alltraps>

801060e9 <vector18>:
.globl vector18
vector18:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $18
801060eb:	6a 12                	push   $0x12
  jmp alltraps
801060ed:	e9 88 fa ff ff       	jmp    80105b7a <alltraps>

801060f2 <vector19>:
.globl vector19
vector19:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $19
801060f4:	6a 13                	push   $0x13
  jmp alltraps
801060f6:	e9 7f fa ff ff       	jmp    80105b7a <alltraps>

801060fb <vector20>:
.globl vector20
vector20:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $20
801060fd:	6a 14                	push   $0x14
  jmp alltraps
801060ff:	e9 76 fa ff ff       	jmp    80105b7a <alltraps>

80106104 <vector21>:
.globl vector21
vector21:
  pushl $0
80106104:	6a 00                	push   $0x0
  pushl $21
80106106:	6a 15                	push   $0x15
  jmp alltraps
80106108:	e9 6d fa ff ff       	jmp    80105b7a <alltraps>

8010610d <vector22>:
.globl vector22
vector22:
  pushl $0
8010610d:	6a 00                	push   $0x0
  pushl $22
8010610f:	6a 16                	push   $0x16
  jmp alltraps
80106111:	e9 64 fa ff ff       	jmp    80105b7a <alltraps>

80106116 <vector23>:
.globl vector23
vector23:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $23
80106118:	6a 17                	push   $0x17
  jmp alltraps
8010611a:	e9 5b fa ff ff       	jmp    80105b7a <alltraps>

8010611f <vector24>:
.globl vector24
vector24:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $24
80106121:	6a 18                	push   $0x18
  jmp alltraps
80106123:	e9 52 fa ff ff       	jmp    80105b7a <alltraps>

80106128 <vector25>:
.globl vector25
vector25:
  pushl $0
80106128:	6a 00                	push   $0x0
  pushl $25
8010612a:	6a 19                	push   $0x19
  jmp alltraps
8010612c:	e9 49 fa ff ff       	jmp    80105b7a <alltraps>

80106131 <vector26>:
.globl vector26
vector26:
  pushl $0
80106131:	6a 00                	push   $0x0
  pushl $26
80106133:	6a 1a                	push   $0x1a
  jmp alltraps
80106135:	e9 40 fa ff ff       	jmp    80105b7a <alltraps>

8010613a <vector27>:
.globl vector27
vector27:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $27
8010613c:	6a 1b                	push   $0x1b
  jmp alltraps
8010613e:	e9 37 fa ff ff       	jmp    80105b7a <alltraps>

80106143 <vector28>:
.globl vector28
vector28:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $28
80106145:	6a 1c                	push   $0x1c
  jmp alltraps
80106147:	e9 2e fa ff ff       	jmp    80105b7a <alltraps>

8010614c <vector29>:
.globl vector29
vector29:
  pushl $0
8010614c:	6a 00                	push   $0x0
  pushl $29
8010614e:	6a 1d                	push   $0x1d
  jmp alltraps
80106150:	e9 25 fa ff ff       	jmp    80105b7a <alltraps>

80106155 <vector30>:
.globl vector30
vector30:
  pushl $0
80106155:	6a 00                	push   $0x0
  pushl $30
80106157:	6a 1e                	push   $0x1e
  jmp alltraps
80106159:	e9 1c fa ff ff       	jmp    80105b7a <alltraps>

8010615e <vector31>:
.globl vector31
vector31:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $31
80106160:	6a 1f                	push   $0x1f
  jmp alltraps
80106162:	e9 13 fa ff ff       	jmp    80105b7a <alltraps>

80106167 <vector32>:
.globl vector32
vector32:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $32
80106169:	6a 20                	push   $0x20
  jmp alltraps
8010616b:	e9 0a fa ff ff       	jmp    80105b7a <alltraps>

80106170 <vector33>:
.globl vector33
vector33:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $33
80106172:	6a 21                	push   $0x21
  jmp alltraps
80106174:	e9 01 fa ff ff       	jmp    80105b7a <alltraps>

80106179 <vector34>:
.globl vector34
vector34:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $34
8010617b:	6a 22                	push   $0x22
  jmp alltraps
8010617d:	e9 f8 f9 ff ff       	jmp    80105b7a <alltraps>

80106182 <vector35>:
.globl vector35
vector35:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $35
80106184:	6a 23                	push   $0x23
  jmp alltraps
80106186:	e9 ef f9 ff ff       	jmp    80105b7a <alltraps>

8010618b <vector36>:
.globl vector36
vector36:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $36
8010618d:	6a 24                	push   $0x24
  jmp alltraps
8010618f:	e9 e6 f9 ff ff       	jmp    80105b7a <alltraps>

80106194 <vector37>:
.globl vector37
vector37:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $37
80106196:	6a 25                	push   $0x25
  jmp alltraps
80106198:	e9 dd f9 ff ff       	jmp    80105b7a <alltraps>

8010619d <vector38>:
.globl vector38
vector38:
  pushl $0
8010619d:	6a 00                	push   $0x0
  pushl $38
8010619f:	6a 26                	push   $0x26
  jmp alltraps
801061a1:	e9 d4 f9 ff ff       	jmp    80105b7a <alltraps>

801061a6 <vector39>:
.globl vector39
vector39:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $39
801061a8:	6a 27                	push   $0x27
  jmp alltraps
801061aa:	e9 cb f9 ff ff       	jmp    80105b7a <alltraps>

801061af <vector40>:
.globl vector40
vector40:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $40
801061b1:	6a 28                	push   $0x28
  jmp alltraps
801061b3:	e9 c2 f9 ff ff       	jmp    80105b7a <alltraps>

801061b8 <vector41>:
.globl vector41
vector41:
  pushl $0
801061b8:	6a 00                	push   $0x0
  pushl $41
801061ba:	6a 29                	push   $0x29
  jmp alltraps
801061bc:	e9 b9 f9 ff ff       	jmp    80105b7a <alltraps>

801061c1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061c1:	6a 00                	push   $0x0
  pushl $42
801061c3:	6a 2a                	push   $0x2a
  jmp alltraps
801061c5:	e9 b0 f9 ff ff       	jmp    80105b7a <alltraps>

801061ca <vector43>:
.globl vector43
vector43:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $43
801061cc:	6a 2b                	push   $0x2b
  jmp alltraps
801061ce:	e9 a7 f9 ff ff       	jmp    80105b7a <alltraps>

801061d3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $44
801061d5:	6a 2c                	push   $0x2c
  jmp alltraps
801061d7:	e9 9e f9 ff ff       	jmp    80105b7a <alltraps>

801061dc <vector45>:
.globl vector45
vector45:
  pushl $0
801061dc:	6a 00                	push   $0x0
  pushl $45
801061de:	6a 2d                	push   $0x2d
  jmp alltraps
801061e0:	e9 95 f9 ff ff       	jmp    80105b7a <alltraps>

801061e5 <vector46>:
.globl vector46
vector46:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $46
801061e7:	6a 2e                	push   $0x2e
  jmp alltraps
801061e9:	e9 8c f9 ff ff       	jmp    80105b7a <alltraps>

801061ee <vector47>:
.globl vector47
vector47:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $47
801061f0:	6a 2f                	push   $0x2f
  jmp alltraps
801061f2:	e9 83 f9 ff ff       	jmp    80105b7a <alltraps>

801061f7 <vector48>:
.globl vector48
vector48:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $48
801061f9:	6a 30                	push   $0x30
  jmp alltraps
801061fb:	e9 7a f9 ff ff       	jmp    80105b7a <alltraps>

80106200 <vector49>:
.globl vector49
vector49:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $49
80106202:	6a 31                	push   $0x31
  jmp alltraps
80106204:	e9 71 f9 ff ff       	jmp    80105b7a <alltraps>

80106209 <vector50>:
.globl vector50
vector50:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $50
8010620b:	6a 32                	push   $0x32
  jmp alltraps
8010620d:	e9 68 f9 ff ff       	jmp    80105b7a <alltraps>

80106212 <vector51>:
.globl vector51
vector51:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $51
80106214:	6a 33                	push   $0x33
  jmp alltraps
80106216:	e9 5f f9 ff ff       	jmp    80105b7a <alltraps>

8010621b <vector52>:
.globl vector52
vector52:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $52
8010621d:	6a 34                	push   $0x34
  jmp alltraps
8010621f:	e9 56 f9 ff ff       	jmp    80105b7a <alltraps>

80106224 <vector53>:
.globl vector53
vector53:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $53
80106226:	6a 35                	push   $0x35
  jmp alltraps
80106228:	e9 4d f9 ff ff       	jmp    80105b7a <alltraps>

8010622d <vector54>:
.globl vector54
vector54:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $54
8010622f:	6a 36                	push   $0x36
  jmp alltraps
80106231:	e9 44 f9 ff ff       	jmp    80105b7a <alltraps>

80106236 <vector55>:
.globl vector55
vector55:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $55
80106238:	6a 37                	push   $0x37
  jmp alltraps
8010623a:	e9 3b f9 ff ff       	jmp    80105b7a <alltraps>

8010623f <vector56>:
.globl vector56
vector56:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $56
80106241:	6a 38                	push   $0x38
  jmp alltraps
80106243:	e9 32 f9 ff ff       	jmp    80105b7a <alltraps>

80106248 <vector57>:
.globl vector57
vector57:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $57
8010624a:	6a 39                	push   $0x39
  jmp alltraps
8010624c:	e9 29 f9 ff ff       	jmp    80105b7a <alltraps>

80106251 <vector58>:
.globl vector58
vector58:
  pushl $0
80106251:	6a 00                	push   $0x0
  pushl $58
80106253:	6a 3a                	push   $0x3a
  jmp alltraps
80106255:	e9 20 f9 ff ff       	jmp    80105b7a <alltraps>

8010625a <vector59>:
.globl vector59
vector59:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $59
8010625c:	6a 3b                	push   $0x3b
  jmp alltraps
8010625e:	e9 17 f9 ff ff       	jmp    80105b7a <alltraps>

80106263 <vector60>:
.globl vector60
vector60:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $60
80106265:	6a 3c                	push   $0x3c
  jmp alltraps
80106267:	e9 0e f9 ff ff       	jmp    80105b7a <alltraps>

8010626c <vector61>:
.globl vector61
vector61:
  pushl $0
8010626c:	6a 00                	push   $0x0
  pushl $61
8010626e:	6a 3d                	push   $0x3d
  jmp alltraps
80106270:	e9 05 f9 ff ff       	jmp    80105b7a <alltraps>

80106275 <vector62>:
.globl vector62
vector62:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $62
80106277:	6a 3e                	push   $0x3e
  jmp alltraps
80106279:	e9 fc f8 ff ff       	jmp    80105b7a <alltraps>

8010627e <vector63>:
.globl vector63
vector63:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $63
80106280:	6a 3f                	push   $0x3f
  jmp alltraps
80106282:	e9 f3 f8 ff ff       	jmp    80105b7a <alltraps>

80106287 <vector64>:
.globl vector64
vector64:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $64
80106289:	6a 40                	push   $0x40
  jmp alltraps
8010628b:	e9 ea f8 ff ff       	jmp    80105b7a <alltraps>

80106290 <vector65>:
.globl vector65
vector65:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $65
80106292:	6a 41                	push   $0x41
  jmp alltraps
80106294:	e9 e1 f8 ff ff       	jmp    80105b7a <alltraps>

80106299 <vector66>:
.globl vector66
vector66:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $66
8010629b:	6a 42                	push   $0x42
  jmp alltraps
8010629d:	e9 d8 f8 ff ff       	jmp    80105b7a <alltraps>

801062a2 <vector67>:
.globl vector67
vector67:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $67
801062a4:	6a 43                	push   $0x43
  jmp alltraps
801062a6:	e9 cf f8 ff ff       	jmp    80105b7a <alltraps>

801062ab <vector68>:
.globl vector68
vector68:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $68
801062ad:	6a 44                	push   $0x44
  jmp alltraps
801062af:	e9 c6 f8 ff ff       	jmp    80105b7a <alltraps>

801062b4 <vector69>:
.globl vector69
vector69:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $69
801062b6:	6a 45                	push   $0x45
  jmp alltraps
801062b8:	e9 bd f8 ff ff       	jmp    80105b7a <alltraps>

801062bd <vector70>:
.globl vector70
vector70:
  pushl $0
801062bd:	6a 00                	push   $0x0
  pushl $70
801062bf:	6a 46                	push   $0x46
  jmp alltraps
801062c1:	e9 b4 f8 ff ff       	jmp    80105b7a <alltraps>

801062c6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $71
801062c8:	6a 47                	push   $0x47
  jmp alltraps
801062ca:	e9 ab f8 ff ff       	jmp    80105b7a <alltraps>

801062cf <vector72>:
.globl vector72
vector72:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $72
801062d1:	6a 48                	push   $0x48
  jmp alltraps
801062d3:	e9 a2 f8 ff ff       	jmp    80105b7a <alltraps>

801062d8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062d8:	6a 00                	push   $0x0
  pushl $73
801062da:	6a 49                	push   $0x49
  jmp alltraps
801062dc:	e9 99 f8 ff ff       	jmp    80105b7a <alltraps>

801062e1 <vector74>:
.globl vector74
vector74:
  pushl $0
801062e1:	6a 00                	push   $0x0
  pushl $74
801062e3:	6a 4a                	push   $0x4a
  jmp alltraps
801062e5:	e9 90 f8 ff ff       	jmp    80105b7a <alltraps>

801062ea <vector75>:
.globl vector75
vector75:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $75
801062ec:	6a 4b                	push   $0x4b
  jmp alltraps
801062ee:	e9 87 f8 ff ff       	jmp    80105b7a <alltraps>

801062f3 <vector76>:
.globl vector76
vector76:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $76
801062f5:	6a 4c                	push   $0x4c
  jmp alltraps
801062f7:	e9 7e f8 ff ff       	jmp    80105b7a <alltraps>

801062fc <vector77>:
.globl vector77
vector77:
  pushl $0
801062fc:	6a 00                	push   $0x0
  pushl $77
801062fe:	6a 4d                	push   $0x4d
  jmp alltraps
80106300:	e9 75 f8 ff ff       	jmp    80105b7a <alltraps>

80106305 <vector78>:
.globl vector78
vector78:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $78
80106307:	6a 4e                	push   $0x4e
  jmp alltraps
80106309:	e9 6c f8 ff ff       	jmp    80105b7a <alltraps>

8010630e <vector79>:
.globl vector79
vector79:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $79
80106310:	6a 4f                	push   $0x4f
  jmp alltraps
80106312:	e9 63 f8 ff ff       	jmp    80105b7a <alltraps>

80106317 <vector80>:
.globl vector80
vector80:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $80
80106319:	6a 50                	push   $0x50
  jmp alltraps
8010631b:	e9 5a f8 ff ff       	jmp    80105b7a <alltraps>

80106320 <vector81>:
.globl vector81
vector81:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $81
80106322:	6a 51                	push   $0x51
  jmp alltraps
80106324:	e9 51 f8 ff ff       	jmp    80105b7a <alltraps>

80106329 <vector82>:
.globl vector82
vector82:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $82
8010632b:	6a 52                	push   $0x52
  jmp alltraps
8010632d:	e9 48 f8 ff ff       	jmp    80105b7a <alltraps>

80106332 <vector83>:
.globl vector83
vector83:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $83
80106334:	6a 53                	push   $0x53
  jmp alltraps
80106336:	e9 3f f8 ff ff       	jmp    80105b7a <alltraps>

8010633b <vector84>:
.globl vector84
vector84:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $84
8010633d:	6a 54                	push   $0x54
  jmp alltraps
8010633f:	e9 36 f8 ff ff       	jmp    80105b7a <alltraps>

80106344 <vector85>:
.globl vector85
vector85:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $85
80106346:	6a 55                	push   $0x55
  jmp alltraps
80106348:	e9 2d f8 ff ff       	jmp    80105b7a <alltraps>

8010634d <vector86>:
.globl vector86
vector86:
  pushl $0
8010634d:	6a 00                	push   $0x0
  pushl $86
8010634f:	6a 56                	push   $0x56
  jmp alltraps
80106351:	e9 24 f8 ff ff       	jmp    80105b7a <alltraps>

80106356 <vector87>:
.globl vector87
vector87:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $87
80106358:	6a 57                	push   $0x57
  jmp alltraps
8010635a:	e9 1b f8 ff ff       	jmp    80105b7a <alltraps>

8010635f <vector88>:
.globl vector88
vector88:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $88
80106361:	6a 58                	push   $0x58
  jmp alltraps
80106363:	e9 12 f8 ff ff       	jmp    80105b7a <alltraps>

80106368 <vector89>:
.globl vector89
vector89:
  pushl $0
80106368:	6a 00                	push   $0x0
  pushl $89
8010636a:	6a 59                	push   $0x59
  jmp alltraps
8010636c:	e9 09 f8 ff ff       	jmp    80105b7a <alltraps>

80106371 <vector90>:
.globl vector90
vector90:
  pushl $0
80106371:	6a 00                	push   $0x0
  pushl $90
80106373:	6a 5a                	push   $0x5a
  jmp alltraps
80106375:	e9 00 f8 ff ff       	jmp    80105b7a <alltraps>

8010637a <vector91>:
.globl vector91
vector91:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $91
8010637c:	6a 5b                	push   $0x5b
  jmp alltraps
8010637e:	e9 f7 f7 ff ff       	jmp    80105b7a <alltraps>

80106383 <vector92>:
.globl vector92
vector92:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $92
80106385:	6a 5c                	push   $0x5c
  jmp alltraps
80106387:	e9 ee f7 ff ff       	jmp    80105b7a <alltraps>

8010638c <vector93>:
.globl vector93
vector93:
  pushl $0
8010638c:	6a 00                	push   $0x0
  pushl $93
8010638e:	6a 5d                	push   $0x5d
  jmp alltraps
80106390:	e9 e5 f7 ff ff       	jmp    80105b7a <alltraps>

80106395 <vector94>:
.globl vector94
vector94:
  pushl $0
80106395:	6a 00                	push   $0x0
  pushl $94
80106397:	6a 5e                	push   $0x5e
  jmp alltraps
80106399:	e9 dc f7 ff ff       	jmp    80105b7a <alltraps>

8010639e <vector95>:
.globl vector95
vector95:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $95
801063a0:	6a 5f                	push   $0x5f
  jmp alltraps
801063a2:	e9 d3 f7 ff ff       	jmp    80105b7a <alltraps>

801063a7 <vector96>:
.globl vector96
vector96:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $96
801063a9:	6a 60                	push   $0x60
  jmp alltraps
801063ab:	e9 ca f7 ff ff       	jmp    80105b7a <alltraps>

801063b0 <vector97>:
.globl vector97
vector97:
  pushl $0
801063b0:	6a 00                	push   $0x0
  pushl $97
801063b2:	6a 61                	push   $0x61
  jmp alltraps
801063b4:	e9 c1 f7 ff ff       	jmp    80105b7a <alltraps>

801063b9 <vector98>:
.globl vector98
vector98:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $98
801063bb:	6a 62                	push   $0x62
  jmp alltraps
801063bd:	e9 b8 f7 ff ff       	jmp    80105b7a <alltraps>

801063c2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $99
801063c4:	6a 63                	push   $0x63
  jmp alltraps
801063c6:	e9 af f7 ff ff       	jmp    80105b7a <alltraps>

801063cb <vector100>:
.globl vector100
vector100:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $100
801063cd:	6a 64                	push   $0x64
  jmp alltraps
801063cf:	e9 a6 f7 ff ff       	jmp    80105b7a <alltraps>

801063d4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $101
801063d6:	6a 65                	push   $0x65
  jmp alltraps
801063d8:	e9 9d f7 ff ff       	jmp    80105b7a <alltraps>

801063dd <vector102>:
.globl vector102
vector102:
  pushl $0
801063dd:	6a 00                	push   $0x0
  pushl $102
801063df:	6a 66                	push   $0x66
  jmp alltraps
801063e1:	e9 94 f7 ff ff       	jmp    80105b7a <alltraps>

801063e6 <vector103>:
.globl vector103
vector103:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $103
801063e8:	6a 67                	push   $0x67
  jmp alltraps
801063ea:	e9 8b f7 ff ff       	jmp    80105b7a <alltraps>

801063ef <vector104>:
.globl vector104
vector104:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $104
801063f1:	6a 68                	push   $0x68
  jmp alltraps
801063f3:	e9 82 f7 ff ff       	jmp    80105b7a <alltraps>

801063f8 <vector105>:
.globl vector105
vector105:
  pushl $0
801063f8:	6a 00                	push   $0x0
  pushl $105
801063fa:	6a 69                	push   $0x69
  jmp alltraps
801063fc:	e9 79 f7 ff ff       	jmp    80105b7a <alltraps>

80106401 <vector106>:
.globl vector106
vector106:
  pushl $0
80106401:	6a 00                	push   $0x0
  pushl $106
80106403:	6a 6a                	push   $0x6a
  jmp alltraps
80106405:	e9 70 f7 ff ff       	jmp    80105b7a <alltraps>

8010640a <vector107>:
.globl vector107
vector107:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $107
8010640c:	6a 6b                	push   $0x6b
  jmp alltraps
8010640e:	e9 67 f7 ff ff       	jmp    80105b7a <alltraps>

80106413 <vector108>:
.globl vector108
vector108:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $108
80106415:	6a 6c                	push   $0x6c
  jmp alltraps
80106417:	e9 5e f7 ff ff       	jmp    80105b7a <alltraps>

8010641c <vector109>:
.globl vector109
vector109:
  pushl $0
8010641c:	6a 00                	push   $0x0
  pushl $109
8010641e:	6a 6d                	push   $0x6d
  jmp alltraps
80106420:	e9 55 f7 ff ff       	jmp    80105b7a <alltraps>

80106425 <vector110>:
.globl vector110
vector110:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $110
80106427:	6a 6e                	push   $0x6e
  jmp alltraps
80106429:	e9 4c f7 ff ff       	jmp    80105b7a <alltraps>

8010642e <vector111>:
.globl vector111
vector111:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $111
80106430:	6a 6f                	push   $0x6f
  jmp alltraps
80106432:	e9 43 f7 ff ff       	jmp    80105b7a <alltraps>

80106437 <vector112>:
.globl vector112
vector112:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $112
80106439:	6a 70                	push   $0x70
  jmp alltraps
8010643b:	e9 3a f7 ff ff       	jmp    80105b7a <alltraps>

80106440 <vector113>:
.globl vector113
vector113:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $113
80106442:	6a 71                	push   $0x71
  jmp alltraps
80106444:	e9 31 f7 ff ff       	jmp    80105b7a <alltraps>

80106449 <vector114>:
.globl vector114
vector114:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $114
8010644b:	6a 72                	push   $0x72
  jmp alltraps
8010644d:	e9 28 f7 ff ff       	jmp    80105b7a <alltraps>

80106452 <vector115>:
.globl vector115
vector115:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $115
80106454:	6a 73                	push   $0x73
  jmp alltraps
80106456:	e9 1f f7 ff ff       	jmp    80105b7a <alltraps>

8010645b <vector116>:
.globl vector116
vector116:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $116
8010645d:	6a 74                	push   $0x74
  jmp alltraps
8010645f:	e9 16 f7 ff ff       	jmp    80105b7a <alltraps>

80106464 <vector117>:
.globl vector117
vector117:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $117
80106466:	6a 75                	push   $0x75
  jmp alltraps
80106468:	e9 0d f7 ff ff       	jmp    80105b7a <alltraps>

8010646d <vector118>:
.globl vector118
vector118:
  pushl $0
8010646d:	6a 00                	push   $0x0
  pushl $118
8010646f:	6a 76                	push   $0x76
  jmp alltraps
80106471:	e9 04 f7 ff ff       	jmp    80105b7a <alltraps>

80106476 <vector119>:
.globl vector119
vector119:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $119
80106478:	6a 77                	push   $0x77
  jmp alltraps
8010647a:	e9 fb f6 ff ff       	jmp    80105b7a <alltraps>

8010647f <vector120>:
.globl vector120
vector120:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $120
80106481:	6a 78                	push   $0x78
  jmp alltraps
80106483:	e9 f2 f6 ff ff       	jmp    80105b7a <alltraps>

80106488 <vector121>:
.globl vector121
vector121:
  pushl $0
80106488:	6a 00                	push   $0x0
  pushl $121
8010648a:	6a 79                	push   $0x79
  jmp alltraps
8010648c:	e9 e9 f6 ff ff       	jmp    80105b7a <alltraps>

80106491 <vector122>:
.globl vector122
vector122:
  pushl $0
80106491:	6a 00                	push   $0x0
  pushl $122
80106493:	6a 7a                	push   $0x7a
  jmp alltraps
80106495:	e9 e0 f6 ff ff       	jmp    80105b7a <alltraps>

8010649a <vector123>:
.globl vector123
vector123:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $123
8010649c:	6a 7b                	push   $0x7b
  jmp alltraps
8010649e:	e9 d7 f6 ff ff       	jmp    80105b7a <alltraps>

801064a3 <vector124>:
.globl vector124
vector124:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $124
801064a5:	6a 7c                	push   $0x7c
  jmp alltraps
801064a7:	e9 ce f6 ff ff       	jmp    80105b7a <alltraps>

801064ac <vector125>:
.globl vector125
vector125:
  pushl $0
801064ac:	6a 00                	push   $0x0
  pushl $125
801064ae:	6a 7d                	push   $0x7d
  jmp alltraps
801064b0:	e9 c5 f6 ff ff       	jmp    80105b7a <alltraps>

801064b5 <vector126>:
.globl vector126
vector126:
  pushl $0
801064b5:	6a 00                	push   $0x0
  pushl $126
801064b7:	6a 7e                	push   $0x7e
  jmp alltraps
801064b9:	e9 bc f6 ff ff       	jmp    80105b7a <alltraps>

801064be <vector127>:
.globl vector127
vector127:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $127
801064c0:	6a 7f                	push   $0x7f
  jmp alltraps
801064c2:	e9 b3 f6 ff ff       	jmp    80105b7a <alltraps>

801064c7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $128
801064c9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064ce:	e9 a7 f6 ff ff       	jmp    80105b7a <alltraps>

801064d3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $129
801064d5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064da:	e9 9b f6 ff ff       	jmp    80105b7a <alltraps>

801064df <vector130>:
.globl vector130
vector130:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $130
801064e1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064e6:	e9 8f f6 ff ff       	jmp    80105b7a <alltraps>

801064eb <vector131>:
.globl vector131
vector131:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $131
801064ed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801064f2:	e9 83 f6 ff ff       	jmp    80105b7a <alltraps>

801064f7 <vector132>:
.globl vector132
vector132:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $132
801064f9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801064fe:	e9 77 f6 ff ff       	jmp    80105b7a <alltraps>

80106503 <vector133>:
.globl vector133
vector133:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $133
80106505:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010650a:	e9 6b f6 ff ff       	jmp    80105b7a <alltraps>

8010650f <vector134>:
.globl vector134
vector134:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $134
80106511:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106516:	e9 5f f6 ff ff       	jmp    80105b7a <alltraps>

8010651b <vector135>:
.globl vector135
vector135:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $135
8010651d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106522:	e9 53 f6 ff ff       	jmp    80105b7a <alltraps>

80106527 <vector136>:
.globl vector136
vector136:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $136
80106529:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010652e:	e9 47 f6 ff ff       	jmp    80105b7a <alltraps>

80106533 <vector137>:
.globl vector137
vector137:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $137
80106535:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010653a:	e9 3b f6 ff ff       	jmp    80105b7a <alltraps>

8010653f <vector138>:
.globl vector138
vector138:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $138
80106541:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106546:	e9 2f f6 ff ff       	jmp    80105b7a <alltraps>

8010654b <vector139>:
.globl vector139
vector139:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $139
8010654d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106552:	e9 23 f6 ff ff       	jmp    80105b7a <alltraps>

80106557 <vector140>:
.globl vector140
vector140:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $140
80106559:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010655e:	e9 17 f6 ff ff       	jmp    80105b7a <alltraps>

80106563 <vector141>:
.globl vector141
vector141:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $141
80106565:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010656a:	e9 0b f6 ff ff       	jmp    80105b7a <alltraps>

8010656f <vector142>:
.globl vector142
vector142:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $142
80106571:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106576:	e9 ff f5 ff ff       	jmp    80105b7a <alltraps>

8010657b <vector143>:
.globl vector143
vector143:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $143
8010657d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106582:	e9 f3 f5 ff ff       	jmp    80105b7a <alltraps>

80106587 <vector144>:
.globl vector144
vector144:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $144
80106589:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010658e:	e9 e7 f5 ff ff       	jmp    80105b7a <alltraps>

80106593 <vector145>:
.globl vector145
vector145:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $145
80106595:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010659a:	e9 db f5 ff ff       	jmp    80105b7a <alltraps>

8010659f <vector146>:
.globl vector146
vector146:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $146
801065a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801065a6:	e9 cf f5 ff ff       	jmp    80105b7a <alltraps>

801065ab <vector147>:
.globl vector147
vector147:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $147
801065ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065b2:	e9 c3 f5 ff ff       	jmp    80105b7a <alltraps>

801065b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $148
801065b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065be:	e9 b7 f5 ff ff       	jmp    80105b7a <alltraps>

801065c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $149
801065c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065ca:	e9 ab f5 ff ff       	jmp    80105b7a <alltraps>

801065cf <vector150>:
.globl vector150
vector150:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $150
801065d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065d6:	e9 9f f5 ff ff       	jmp    80105b7a <alltraps>

801065db <vector151>:
.globl vector151
vector151:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $151
801065dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065e2:	e9 93 f5 ff ff       	jmp    80105b7a <alltraps>

801065e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $152
801065e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065ee:	e9 87 f5 ff ff       	jmp    80105b7a <alltraps>

801065f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $153
801065f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801065fa:	e9 7b f5 ff ff       	jmp    80105b7a <alltraps>

801065ff <vector154>:
.globl vector154
vector154:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $154
80106601:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106606:	e9 6f f5 ff ff       	jmp    80105b7a <alltraps>

8010660b <vector155>:
.globl vector155
vector155:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $155
8010660d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106612:	e9 63 f5 ff ff       	jmp    80105b7a <alltraps>

80106617 <vector156>:
.globl vector156
vector156:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $156
80106619:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010661e:	e9 57 f5 ff ff       	jmp    80105b7a <alltraps>

80106623 <vector157>:
.globl vector157
vector157:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $157
80106625:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010662a:	e9 4b f5 ff ff       	jmp    80105b7a <alltraps>

8010662f <vector158>:
.globl vector158
vector158:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $158
80106631:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106636:	e9 3f f5 ff ff       	jmp    80105b7a <alltraps>

8010663b <vector159>:
.globl vector159
vector159:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $159
8010663d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106642:	e9 33 f5 ff ff       	jmp    80105b7a <alltraps>

80106647 <vector160>:
.globl vector160
vector160:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $160
80106649:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010664e:	e9 27 f5 ff ff       	jmp    80105b7a <alltraps>

80106653 <vector161>:
.globl vector161
vector161:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $161
80106655:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010665a:	e9 1b f5 ff ff       	jmp    80105b7a <alltraps>

8010665f <vector162>:
.globl vector162
vector162:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $162
80106661:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106666:	e9 0f f5 ff ff       	jmp    80105b7a <alltraps>

8010666b <vector163>:
.globl vector163
vector163:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $163
8010666d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106672:	e9 03 f5 ff ff       	jmp    80105b7a <alltraps>

80106677 <vector164>:
.globl vector164
vector164:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $164
80106679:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010667e:	e9 f7 f4 ff ff       	jmp    80105b7a <alltraps>

80106683 <vector165>:
.globl vector165
vector165:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $165
80106685:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010668a:	e9 eb f4 ff ff       	jmp    80105b7a <alltraps>

8010668f <vector166>:
.globl vector166
vector166:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $166
80106691:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106696:	e9 df f4 ff ff       	jmp    80105b7a <alltraps>

8010669b <vector167>:
.globl vector167
vector167:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $167
8010669d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801066a2:	e9 d3 f4 ff ff       	jmp    80105b7a <alltraps>

801066a7 <vector168>:
.globl vector168
vector168:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $168
801066a9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801066ae:	e9 c7 f4 ff ff       	jmp    80105b7a <alltraps>

801066b3 <vector169>:
.globl vector169
vector169:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $169
801066b5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066ba:	e9 bb f4 ff ff       	jmp    80105b7a <alltraps>

801066bf <vector170>:
.globl vector170
vector170:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $170
801066c1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066c6:	e9 af f4 ff ff       	jmp    80105b7a <alltraps>

801066cb <vector171>:
.globl vector171
vector171:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $171
801066cd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066d2:	e9 a3 f4 ff ff       	jmp    80105b7a <alltraps>

801066d7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $172
801066d9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066de:	e9 97 f4 ff ff       	jmp    80105b7a <alltraps>

801066e3 <vector173>:
.globl vector173
vector173:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $173
801066e5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066ea:	e9 8b f4 ff ff       	jmp    80105b7a <alltraps>

801066ef <vector174>:
.globl vector174
vector174:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $174
801066f1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801066f6:	e9 7f f4 ff ff       	jmp    80105b7a <alltraps>

801066fb <vector175>:
.globl vector175
vector175:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $175
801066fd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106702:	e9 73 f4 ff ff       	jmp    80105b7a <alltraps>

80106707 <vector176>:
.globl vector176
vector176:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $176
80106709:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010670e:	e9 67 f4 ff ff       	jmp    80105b7a <alltraps>

80106713 <vector177>:
.globl vector177
vector177:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $177
80106715:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010671a:	e9 5b f4 ff ff       	jmp    80105b7a <alltraps>

8010671f <vector178>:
.globl vector178
vector178:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $178
80106721:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106726:	e9 4f f4 ff ff       	jmp    80105b7a <alltraps>

8010672b <vector179>:
.globl vector179
vector179:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $179
8010672d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106732:	e9 43 f4 ff ff       	jmp    80105b7a <alltraps>

80106737 <vector180>:
.globl vector180
vector180:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $180
80106739:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010673e:	e9 37 f4 ff ff       	jmp    80105b7a <alltraps>

80106743 <vector181>:
.globl vector181
vector181:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $181
80106745:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010674a:	e9 2b f4 ff ff       	jmp    80105b7a <alltraps>

8010674f <vector182>:
.globl vector182
vector182:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $182
80106751:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106756:	e9 1f f4 ff ff       	jmp    80105b7a <alltraps>

8010675b <vector183>:
.globl vector183
vector183:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $183
8010675d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106762:	e9 13 f4 ff ff       	jmp    80105b7a <alltraps>

80106767 <vector184>:
.globl vector184
vector184:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $184
80106769:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010676e:	e9 07 f4 ff ff       	jmp    80105b7a <alltraps>

80106773 <vector185>:
.globl vector185
vector185:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $185
80106775:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010677a:	e9 fb f3 ff ff       	jmp    80105b7a <alltraps>

8010677f <vector186>:
.globl vector186
vector186:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $186
80106781:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106786:	e9 ef f3 ff ff       	jmp    80105b7a <alltraps>

8010678b <vector187>:
.globl vector187
vector187:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $187
8010678d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106792:	e9 e3 f3 ff ff       	jmp    80105b7a <alltraps>

80106797 <vector188>:
.globl vector188
vector188:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $188
80106799:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010679e:	e9 d7 f3 ff ff       	jmp    80105b7a <alltraps>

801067a3 <vector189>:
.globl vector189
vector189:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $189
801067a5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801067aa:	e9 cb f3 ff ff       	jmp    80105b7a <alltraps>

801067af <vector190>:
.globl vector190
vector190:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $190
801067b1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067b6:	e9 bf f3 ff ff       	jmp    80105b7a <alltraps>

801067bb <vector191>:
.globl vector191
vector191:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $191
801067bd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067c2:	e9 b3 f3 ff ff       	jmp    80105b7a <alltraps>

801067c7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $192
801067c9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067ce:	e9 a7 f3 ff ff       	jmp    80105b7a <alltraps>

801067d3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $193
801067d5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067da:	e9 9b f3 ff ff       	jmp    80105b7a <alltraps>

801067df <vector194>:
.globl vector194
vector194:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $194
801067e1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067e6:	e9 8f f3 ff ff       	jmp    80105b7a <alltraps>

801067eb <vector195>:
.globl vector195
vector195:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $195
801067ed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801067f2:	e9 83 f3 ff ff       	jmp    80105b7a <alltraps>

801067f7 <vector196>:
.globl vector196
vector196:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $196
801067f9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801067fe:	e9 77 f3 ff ff       	jmp    80105b7a <alltraps>

80106803 <vector197>:
.globl vector197
vector197:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $197
80106805:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010680a:	e9 6b f3 ff ff       	jmp    80105b7a <alltraps>

8010680f <vector198>:
.globl vector198
vector198:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $198
80106811:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106816:	e9 5f f3 ff ff       	jmp    80105b7a <alltraps>

8010681b <vector199>:
.globl vector199
vector199:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $199
8010681d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106822:	e9 53 f3 ff ff       	jmp    80105b7a <alltraps>

80106827 <vector200>:
.globl vector200
vector200:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $200
80106829:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010682e:	e9 47 f3 ff ff       	jmp    80105b7a <alltraps>

80106833 <vector201>:
.globl vector201
vector201:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $201
80106835:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010683a:	e9 3b f3 ff ff       	jmp    80105b7a <alltraps>

8010683f <vector202>:
.globl vector202
vector202:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $202
80106841:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106846:	e9 2f f3 ff ff       	jmp    80105b7a <alltraps>

8010684b <vector203>:
.globl vector203
vector203:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $203
8010684d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106852:	e9 23 f3 ff ff       	jmp    80105b7a <alltraps>

80106857 <vector204>:
.globl vector204
vector204:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $204
80106859:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010685e:	e9 17 f3 ff ff       	jmp    80105b7a <alltraps>

80106863 <vector205>:
.globl vector205
vector205:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $205
80106865:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010686a:	e9 0b f3 ff ff       	jmp    80105b7a <alltraps>

8010686f <vector206>:
.globl vector206
vector206:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $206
80106871:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106876:	e9 ff f2 ff ff       	jmp    80105b7a <alltraps>

8010687b <vector207>:
.globl vector207
vector207:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $207
8010687d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106882:	e9 f3 f2 ff ff       	jmp    80105b7a <alltraps>

80106887 <vector208>:
.globl vector208
vector208:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $208
80106889:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010688e:	e9 e7 f2 ff ff       	jmp    80105b7a <alltraps>

80106893 <vector209>:
.globl vector209
vector209:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $209
80106895:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010689a:	e9 db f2 ff ff       	jmp    80105b7a <alltraps>

8010689f <vector210>:
.globl vector210
vector210:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $210
801068a1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801068a6:	e9 cf f2 ff ff       	jmp    80105b7a <alltraps>

801068ab <vector211>:
.globl vector211
vector211:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $211
801068ad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068b2:	e9 c3 f2 ff ff       	jmp    80105b7a <alltraps>

801068b7 <vector212>:
.globl vector212
vector212:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $212
801068b9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068be:	e9 b7 f2 ff ff       	jmp    80105b7a <alltraps>

801068c3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $213
801068c5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068ca:	e9 ab f2 ff ff       	jmp    80105b7a <alltraps>

801068cf <vector214>:
.globl vector214
vector214:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $214
801068d1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068d6:	e9 9f f2 ff ff       	jmp    80105b7a <alltraps>

801068db <vector215>:
.globl vector215
vector215:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $215
801068dd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068e2:	e9 93 f2 ff ff       	jmp    80105b7a <alltraps>

801068e7 <vector216>:
.globl vector216
vector216:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $216
801068e9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068ee:	e9 87 f2 ff ff       	jmp    80105b7a <alltraps>

801068f3 <vector217>:
.globl vector217
vector217:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $217
801068f5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801068fa:	e9 7b f2 ff ff       	jmp    80105b7a <alltraps>

801068ff <vector218>:
.globl vector218
vector218:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $218
80106901:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106906:	e9 6f f2 ff ff       	jmp    80105b7a <alltraps>

8010690b <vector219>:
.globl vector219
vector219:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $219
8010690d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106912:	e9 63 f2 ff ff       	jmp    80105b7a <alltraps>

80106917 <vector220>:
.globl vector220
vector220:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $220
80106919:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010691e:	e9 57 f2 ff ff       	jmp    80105b7a <alltraps>

80106923 <vector221>:
.globl vector221
vector221:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $221
80106925:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010692a:	e9 4b f2 ff ff       	jmp    80105b7a <alltraps>

8010692f <vector222>:
.globl vector222
vector222:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $222
80106931:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106936:	e9 3f f2 ff ff       	jmp    80105b7a <alltraps>

8010693b <vector223>:
.globl vector223
vector223:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $223
8010693d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106942:	e9 33 f2 ff ff       	jmp    80105b7a <alltraps>

80106947 <vector224>:
.globl vector224
vector224:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $224
80106949:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010694e:	e9 27 f2 ff ff       	jmp    80105b7a <alltraps>

80106953 <vector225>:
.globl vector225
vector225:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $225
80106955:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010695a:	e9 1b f2 ff ff       	jmp    80105b7a <alltraps>

8010695f <vector226>:
.globl vector226
vector226:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $226
80106961:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106966:	e9 0f f2 ff ff       	jmp    80105b7a <alltraps>

8010696b <vector227>:
.globl vector227
vector227:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $227
8010696d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106972:	e9 03 f2 ff ff       	jmp    80105b7a <alltraps>

80106977 <vector228>:
.globl vector228
vector228:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $228
80106979:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010697e:	e9 f7 f1 ff ff       	jmp    80105b7a <alltraps>

80106983 <vector229>:
.globl vector229
vector229:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $229
80106985:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010698a:	e9 eb f1 ff ff       	jmp    80105b7a <alltraps>

8010698f <vector230>:
.globl vector230
vector230:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $230
80106991:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106996:	e9 df f1 ff ff       	jmp    80105b7a <alltraps>

8010699b <vector231>:
.globl vector231
vector231:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $231
8010699d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801069a2:	e9 d3 f1 ff ff       	jmp    80105b7a <alltraps>

801069a7 <vector232>:
.globl vector232
vector232:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $232
801069a9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801069ae:	e9 c7 f1 ff ff       	jmp    80105b7a <alltraps>

801069b3 <vector233>:
.globl vector233
vector233:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $233
801069b5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069ba:	e9 bb f1 ff ff       	jmp    80105b7a <alltraps>

801069bf <vector234>:
.globl vector234
vector234:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $234
801069c1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069c6:	e9 af f1 ff ff       	jmp    80105b7a <alltraps>

801069cb <vector235>:
.globl vector235
vector235:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $235
801069cd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069d2:	e9 a3 f1 ff ff       	jmp    80105b7a <alltraps>

801069d7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $236
801069d9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069de:	e9 97 f1 ff ff       	jmp    80105b7a <alltraps>

801069e3 <vector237>:
.globl vector237
vector237:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $237
801069e5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069ea:	e9 8b f1 ff ff       	jmp    80105b7a <alltraps>

801069ef <vector238>:
.globl vector238
vector238:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $238
801069f1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801069f6:	e9 7f f1 ff ff       	jmp    80105b7a <alltraps>

801069fb <vector239>:
.globl vector239
vector239:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $239
801069fd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a02:	e9 73 f1 ff ff       	jmp    80105b7a <alltraps>

80106a07 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $240
80106a09:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a0e:	e9 67 f1 ff ff       	jmp    80105b7a <alltraps>

80106a13 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $241
80106a15:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a1a:	e9 5b f1 ff ff       	jmp    80105b7a <alltraps>

80106a1f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $242
80106a21:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a26:	e9 4f f1 ff ff       	jmp    80105b7a <alltraps>

80106a2b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $243
80106a2d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a32:	e9 43 f1 ff ff       	jmp    80105b7a <alltraps>

80106a37 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $244
80106a39:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a3e:	e9 37 f1 ff ff       	jmp    80105b7a <alltraps>

80106a43 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $245
80106a45:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a4a:	e9 2b f1 ff ff       	jmp    80105b7a <alltraps>

80106a4f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $246
80106a51:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a56:	e9 1f f1 ff ff       	jmp    80105b7a <alltraps>

80106a5b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $247
80106a5d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a62:	e9 13 f1 ff ff       	jmp    80105b7a <alltraps>

80106a67 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $248
80106a69:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a6e:	e9 07 f1 ff ff       	jmp    80105b7a <alltraps>

80106a73 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $249
80106a75:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a7a:	e9 fb f0 ff ff       	jmp    80105b7a <alltraps>

80106a7f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $250
80106a81:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a86:	e9 ef f0 ff ff       	jmp    80105b7a <alltraps>

80106a8b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $251
80106a8d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a92:	e9 e3 f0 ff ff       	jmp    80105b7a <alltraps>

80106a97 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $252
80106a99:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a9e:	e9 d7 f0 ff ff       	jmp    80105b7a <alltraps>

80106aa3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $253
80106aa5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106aaa:	e9 cb f0 ff ff       	jmp    80105b7a <alltraps>

80106aaf <vector254>:
.globl vector254
vector254:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $254
80106ab1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ab6:	e9 bf f0 ff ff       	jmp    80105b7a <alltraps>

80106abb <vector255>:
.globl vector255
vector255:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $255
80106abd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ac2:	e9 b3 f0 ff ff       	jmp    80105b7a <alltraps>
80106ac7:	66 90                	xchg   %ax,%ax
80106ac9:	66 90                	xchg   %ax,%ax
80106acb:	66 90                	xchg   %ax,%ax
80106acd:	66 90                	xchg   %ax,%ax
80106acf:	90                   	nop

80106ad0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	57                   	push   %edi
80106ad4:	56                   	push   %esi
80106ad5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ad6:	89 d3                	mov    %edx,%ebx
{
80106ad8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106ada:	c1 eb 16             	shr    $0x16,%ebx
80106add:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106ae0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ae3:	8b 06                	mov    (%esi),%eax
80106ae5:	a8 01                	test   $0x1,%al
80106ae7:	74 27                	je     80106b10 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ae9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106aee:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106af4:	c1 ef 0a             	shr    $0xa,%edi
}
80106af7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106afa:	89 fa                	mov    %edi,%edx
80106afc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b02:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106b05:	5b                   	pop    %ebx
80106b06:	5e                   	pop    %esi
80106b07:	5f                   	pop    %edi
80106b08:	5d                   	pop    %ebp
80106b09:	c3                   	ret    
80106b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b10:	85 c9                	test   %ecx,%ecx
80106b12:	74 2c                	je     80106b40 <walkpgdir+0x70>
80106b14:	e8 f7 be ff ff       	call   80102a10 <kalloc>
80106b19:	85 c0                	test   %eax,%eax
80106b1b:	89 c3                	mov    %eax,%ebx
80106b1d:	74 21                	je     80106b40 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106b1f:	83 ec 04             	sub    $0x4,%esp
80106b22:	68 00 10 00 00       	push   $0x1000
80106b27:	6a 00                	push   $0x0
80106b29:	50                   	push   %eax
80106b2a:	e8 71 de ff ff       	call   801049a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b2f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b35:	83 c4 10             	add    $0x10,%esp
80106b38:	83 c8 07             	or     $0x7,%eax
80106b3b:	89 06                	mov    %eax,(%esi)
80106b3d:	eb b5                	jmp    80106af4 <walkpgdir+0x24>
80106b3f:	90                   	nop
}
80106b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106b43:	31 c0                	xor    %eax,%eax
}
80106b45:	5b                   	pop    %ebx
80106b46:	5e                   	pop    %esi
80106b47:	5f                   	pop    %edi
80106b48:	5d                   	pop    %ebp
80106b49:	c3                   	ret    
80106b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b50 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
80106b55:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106b56:	89 d3                	mov    %edx,%ebx
80106b58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106b5e:	83 ec 1c             	sub    $0x1c,%esp
80106b61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b68:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b70:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b73:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b76:	29 df                	sub    %ebx,%edi
80106b78:	83 c8 01             	or     $0x1,%eax
80106b7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b7e:	eb 15                	jmp    80106b95 <mappages+0x45>
    if(*pte & PTE_P)
80106b80:	f6 00 01             	testb  $0x1,(%eax)
80106b83:	75 45                	jne    80106bca <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106b85:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106b88:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106b8b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b8d:	74 31                	je     80106bc0 <mappages+0x70>
      break;
    a += PGSIZE;
80106b8f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b98:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b9d:	89 da                	mov    %ebx,%edx
80106b9f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106ba2:	e8 29 ff ff ff       	call   80106ad0 <walkpgdir>
80106ba7:	85 c0                	test   %eax,%eax
80106ba9:	75 d5                	jne    80106b80 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106bab:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106bae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bb3:	5b                   	pop    %ebx
80106bb4:	5e                   	pop    %esi
80106bb5:	5f                   	pop    %edi
80106bb6:	5d                   	pop    %ebp
80106bb7:	c3                   	ret    
80106bb8:	90                   	nop
80106bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106bc3:	31 c0                	xor    %eax,%eax
}
80106bc5:	5b                   	pop    %ebx
80106bc6:	5e                   	pop    %esi
80106bc7:	5f                   	pop    %edi
80106bc8:	5d                   	pop    %ebp
80106bc9:	c3                   	ret    
      panic("remap");
80106bca:	83 ec 0c             	sub    $0xc,%esp
80106bcd:	68 c8 7c 10 80       	push   $0x80107cc8
80106bd2:	e8 29 99 ff ff       	call   80100500 <panic>
80106bd7:	89 f6                	mov    %esi,%esi
80106bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106be0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	57                   	push   %edi
80106be4:	56                   	push   %esi
80106be5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106be6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bec:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106bee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bf4:	83 ec 1c             	sub    $0x1c,%esp
80106bf7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106bfa:	39 d3                	cmp    %edx,%ebx
80106bfc:	73 66                	jae    80106c64 <deallocuvm.part.0+0x84>
80106bfe:	89 d6                	mov    %edx,%esi
80106c00:	eb 3d                	jmp    80106c3f <deallocuvm.part.0+0x5f>
80106c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106c08:	8b 10                	mov    (%eax),%edx
80106c0a:	f6 c2 01             	test   $0x1,%dl
80106c0d:	74 26                	je     80106c35 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106c0f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106c15:	74 58                	je     80106c6f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106c17:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c1a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106c23:	52                   	push   %edx
80106c24:	e8 37 bc ff ff       	call   80102860 <kfree>
      *pte = 0;
80106c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c2c:	83 c4 10             	add    $0x10,%esp
80106c2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106c35:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c3b:	39 f3                	cmp    %esi,%ebx
80106c3d:	73 25                	jae    80106c64 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106c3f:	31 c9                	xor    %ecx,%ecx
80106c41:	89 da                	mov    %ebx,%edx
80106c43:	89 f8                	mov    %edi,%eax
80106c45:	e8 86 fe ff ff       	call   80106ad0 <walkpgdir>
    if(!pte)
80106c4a:	85 c0                	test   %eax,%eax
80106c4c:	75 ba                	jne    80106c08 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c4e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106c54:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c5a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c60:	39 f3                	cmp    %esi,%ebx
80106c62:	72 db                	jb     80106c3f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106c64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c6a:	5b                   	pop    %ebx
80106c6b:	5e                   	pop    %esi
80106c6c:	5f                   	pop    %edi
80106c6d:	5d                   	pop    %ebp
80106c6e:	c3                   	ret    
        panic("kfree");
80106c6f:	83 ec 0c             	sub    $0xc,%esp
80106c72:	68 66 76 10 80       	push   $0x80107666
80106c77:	e8 84 98 ff ff       	call   80100500 <panic>
80106c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c80 <seginit>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c86:	e8 85 d0 ff ff       	call   80103d10 <cpuid>
80106c8b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106c91:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c96:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c9a:	c7 80 18 30 11 80 ff 	movl   $0xffff,-0x7feecfe8(%eax)
80106ca1:	ff 00 00 
80106ca4:	c7 80 1c 30 11 80 00 	movl   $0xcf9a00,-0x7feecfe4(%eax)
80106cab:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106cae:	c7 80 20 30 11 80 ff 	movl   $0xffff,-0x7feecfe0(%eax)
80106cb5:	ff 00 00 
80106cb8:	c7 80 24 30 11 80 00 	movl   $0xcf9200,-0x7feecfdc(%eax)
80106cbf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106cc2:	c7 80 28 30 11 80 ff 	movl   $0xffff,-0x7feecfd8(%eax)
80106cc9:	ff 00 00 
80106ccc:	c7 80 2c 30 11 80 00 	movl   $0xcffa00,-0x7feecfd4(%eax)
80106cd3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106cd6:	c7 80 30 30 11 80 ff 	movl   $0xffff,-0x7feecfd0(%eax)
80106cdd:	ff 00 00 
80106ce0:	c7 80 34 30 11 80 00 	movl   $0xcff200,-0x7feecfcc(%eax)
80106ce7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106cea:	05 10 30 11 80       	add    $0x80113010,%eax
  pd[1] = (uint)p;
80106cef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106cf3:	c1 e8 10             	shr    $0x10,%eax
80106cf6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106cfa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106cfd:	0f 01 10             	lgdtl  (%eax)
}
80106d00:	c9                   	leave  
80106d01:	c3                   	ret    
80106d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d10 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d10:	a1 c4 5c 11 80       	mov    0x80115cc4,%eax
{
80106d15:	55                   	push   %ebp
80106d16:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d18:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d1d:	0f 22 d8             	mov    %eax,%cr3
}
80106d20:	5d                   	pop    %ebp
80106d21:	c3                   	ret    
80106d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d30 <switchuvm>:
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	57                   	push   %edi
80106d34:	56                   	push   %esi
80106d35:	53                   	push   %ebx
80106d36:	83 ec 1c             	sub    $0x1c,%esp
80106d39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106d3c:	85 db                	test   %ebx,%ebx
80106d3e:	0f 84 cb 00 00 00    	je     80106e0f <switchuvm+0xdf>
  if(p->kstack == 0)
80106d44:	8b 43 08             	mov    0x8(%ebx),%eax
80106d47:	85 c0                	test   %eax,%eax
80106d49:	0f 84 da 00 00 00    	je     80106e29 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d4f:	8b 43 04             	mov    0x4(%ebx),%eax
80106d52:	85 c0                	test   %eax,%eax
80106d54:	0f 84 c2 00 00 00    	je     80106e1c <switchuvm+0xec>
  pushcli();
80106d5a:	e8 61 da ff ff       	call   801047c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d5f:	e8 2c cf ff ff       	call   80103c90 <mycpu>
80106d64:	89 c6                	mov    %eax,%esi
80106d66:	e8 25 cf ff ff       	call   80103c90 <mycpu>
80106d6b:	89 c7                	mov    %eax,%edi
80106d6d:	e8 1e cf ff ff       	call   80103c90 <mycpu>
80106d72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d75:	83 c7 08             	add    $0x8,%edi
80106d78:	e8 13 cf ff ff       	call   80103c90 <mycpu>
80106d7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d80:	83 c0 08             	add    $0x8,%eax
80106d83:	ba 67 00 00 00       	mov    $0x67,%edx
80106d88:	c1 e8 18             	shr    $0x18,%eax
80106d8b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106d92:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106d99:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d9f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106da4:	83 c1 08             	add    $0x8,%ecx
80106da7:	c1 e9 10             	shr    $0x10,%ecx
80106daa:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106db0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106db5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dbc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106dc1:	e8 ca ce ff ff       	call   80103c90 <mycpu>
80106dc6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dcd:	e8 be ce ff ff       	call   80103c90 <mycpu>
80106dd2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106dd6:	8b 73 08             	mov    0x8(%ebx),%esi
80106dd9:	e8 b2 ce ff ff       	call   80103c90 <mycpu>
80106dde:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106de4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106de7:	e8 a4 ce ff ff       	call   80103c90 <mycpu>
80106dec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106df0:	b8 28 00 00 00       	mov    $0x28,%eax
80106df5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106df8:	8b 43 04             	mov    0x4(%ebx),%eax
80106dfb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e00:	0f 22 d8             	mov    %eax,%cr3
}
80106e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e06:	5b                   	pop    %ebx
80106e07:	5e                   	pop    %esi
80106e08:	5f                   	pop    %edi
80106e09:	5d                   	pop    %ebp
  popcli();
80106e0a:	e9 f1 d9 ff ff       	jmp    80104800 <popcli>
    panic("switchuvm: no process");
80106e0f:	83 ec 0c             	sub    $0xc,%esp
80106e12:	68 ce 7c 10 80       	push   $0x80107cce
80106e17:	e8 e4 96 ff ff       	call   80100500 <panic>
    panic("switchuvm: no pgdir");
80106e1c:	83 ec 0c             	sub    $0xc,%esp
80106e1f:	68 f9 7c 10 80       	push   $0x80107cf9
80106e24:	e8 d7 96 ff ff       	call   80100500 <panic>
    panic("switchuvm: no kstack");
80106e29:	83 ec 0c             	sub    $0xc,%esp
80106e2c:	68 e4 7c 10 80       	push   $0x80107ce4
80106e31:	e8 ca 96 ff ff       	call   80100500 <panic>
80106e36:	8d 76 00             	lea    0x0(%esi),%esi
80106e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e40 <inituvm>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 1c             	sub    $0x1c,%esp
80106e49:	8b 75 10             	mov    0x10(%ebp),%esi
80106e4c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e4f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106e52:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106e58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e5b:	77 49                	ja     80106ea6 <inituvm+0x66>
  mem = kalloc();
80106e5d:	e8 ae bb ff ff       	call   80102a10 <kalloc>
  memset(mem, 0, PGSIZE);
80106e62:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106e65:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e67:	68 00 10 00 00       	push   $0x1000
80106e6c:	6a 00                	push   $0x0
80106e6e:	50                   	push   %eax
80106e6f:	e8 2c db ff ff       	call   801049a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e74:	58                   	pop    %eax
80106e75:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e7b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e80:	5a                   	pop    %edx
80106e81:	6a 06                	push   $0x6
80106e83:	50                   	push   %eax
80106e84:	31 d2                	xor    %edx,%edx
80106e86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e89:	e8 c2 fc ff ff       	call   80106b50 <mappages>
  memmove(mem, init, sz);
80106e8e:	89 75 10             	mov    %esi,0x10(%ebp)
80106e91:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e94:	83 c4 10             	add    $0x10,%esp
80106e97:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e9d:	5b                   	pop    %ebx
80106e9e:	5e                   	pop    %esi
80106e9f:	5f                   	pop    %edi
80106ea0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ea1:	e9 aa db ff ff       	jmp    80104a50 <memmove>
    panic("inituvm: more than a page");
80106ea6:	83 ec 0c             	sub    $0xc,%esp
80106ea9:	68 0d 7d 10 80       	push   $0x80107d0d
80106eae:	e8 4d 96 ff ff       	call   80100500 <panic>
80106eb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ec0 <loaduvm>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106ec9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106ed0:	0f 85 91 00 00 00    	jne    80106f67 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106ed6:	8b 75 18             	mov    0x18(%ebp),%esi
80106ed9:	31 db                	xor    %ebx,%ebx
80106edb:	85 f6                	test   %esi,%esi
80106edd:	75 1a                	jne    80106ef9 <loaduvm+0x39>
80106edf:	eb 6f                	jmp    80106f50 <loaduvm+0x90>
80106ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ee8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106eee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106ef4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106ef7:	76 57                	jbe    80106f50 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106efc:	8b 45 08             	mov    0x8(%ebp),%eax
80106eff:	31 c9                	xor    %ecx,%ecx
80106f01:	01 da                	add    %ebx,%edx
80106f03:	e8 c8 fb ff ff       	call   80106ad0 <walkpgdir>
80106f08:	85 c0                	test   %eax,%eax
80106f0a:	74 4e                	je     80106f5a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106f0c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f0e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f11:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f1b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f21:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f24:	01 d9                	add    %ebx,%ecx
80106f26:	05 00 00 00 80       	add    $0x80000000,%eax
80106f2b:	57                   	push   %edi
80106f2c:	51                   	push   %ecx
80106f2d:	50                   	push   %eax
80106f2e:	ff 75 10             	pushl  0x10(%ebp)
80106f31:	e8 7a af ff ff       	call   80101eb0 <readi>
80106f36:	83 c4 10             	add    $0x10,%esp
80106f39:	39 f8                	cmp    %edi,%eax
80106f3b:	74 ab                	je     80106ee8 <loaduvm+0x28>
}
80106f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f45:	5b                   	pop    %ebx
80106f46:	5e                   	pop    %esi
80106f47:	5f                   	pop    %edi
80106f48:	5d                   	pop    %ebp
80106f49:	c3                   	ret    
80106f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f53:	31 c0                	xor    %eax,%eax
}
80106f55:	5b                   	pop    %ebx
80106f56:	5e                   	pop    %esi
80106f57:	5f                   	pop    %edi
80106f58:	5d                   	pop    %ebp
80106f59:	c3                   	ret    
      panic("loaduvm: address should exist");
80106f5a:	83 ec 0c             	sub    $0xc,%esp
80106f5d:	68 27 7d 10 80       	push   $0x80107d27
80106f62:	e8 99 95 ff ff       	call   80100500 <panic>
    panic("loaduvm: addr must be page aligned");
80106f67:	83 ec 0c             	sub    $0xc,%esp
80106f6a:	68 c8 7d 10 80       	push   $0x80107dc8
80106f6f:	e8 8c 95 ff ff       	call   80100500 <panic>
80106f74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f80 <allocuvm>:
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	56                   	push   %esi
80106f85:	53                   	push   %ebx
80106f86:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f89:	8b 7d 10             	mov    0x10(%ebp),%edi
80106f8c:	85 ff                	test   %edi,%edi
80106f8e:	0f 88 8e 00 00 00    	js     80107022 <allocuvm+0xa2>
  if(newsz < oldsz)
80106f94:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f97:	0f 82 93 00 00 00    	jb     80107030 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fa0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106fa6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106fac:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106faf:	0f 86 7e 00 00 00    	jbe    80107033 <allocuvm+0xb3>
80106fb5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106fb8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106fbb:	eb 42                	jmp    80106fff <allocuvm+0x7f>
80106fbd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106fc0:	83 ec 04             	sub    $0x4,%esp
80106fc3:	68 00 10 00 00       	push   $0x1000
80106fc8:	6a 00                	push   $0x0
80106fca:	50                   	push   %eax
80106fcb:	e8 d0 d9 ff ff       	call   801049a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106fd0:	58                   	pop    %eax
80106fd1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106fd7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fdc:	5a                   	pop    %edx
80106fdd:	6a 06                	push   $0x6
80106fdf:	50                   	push   %eax
80106fe0:	89 da                	mov    %ebx,%edx
80106fe2:	89 f8                	mov    %edi,%eax
80106fe4:	e8 67 fb ff ff       	call   80106b50 <mappages>
80106fe9:	83 c4 10             	add    $0x10,%esp
80106fec:	85 c0                	test   %eax,%eax
80106fee:	78 50                	js     80107040 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106ff0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ff6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106ff9:	0f 86 81 00 00 00    	jbe    80107080 <allocuvm+0x100>
    mem = kalloc();
80106fff:	e8 0c ba ff ff       	call   80102a10 <kalloc>
    if(mem == 0){
80107004:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107006:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107008:	75 b6                	jne    80106fc0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010700a:	83 ec 0c             	sub    $0xc,%esp
8010700d:	68 45 7d 10 80       	push   $0x80107d45
80107012:	e8 f9 97 ff ff       	call   80100810 <cprintf>
  if(newsz >= oldsz)
80107017:	83 c4 10             	add    $0x10,%esp
8010701a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010701d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107020:	77 6e                	ja     80107090 <allocuvm+0x110>
}
80107022:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107025:	31 ff                	xor    %edi,%edi
}
80107027:	89 f8                	mov    %edi,%eax
80107029:	5b                   	pop    %ebx
8010702a:	5e                   	pop    %esi
8010702b:	5f                   	pop    %edi
8010702c:	5d                   	pop    %ebp
8010702d:	c3                   	ret    
8010702e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107030:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107033:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107036:	89 f8                	mov    %edi,%eax
80107038:	5b                   	pop    %ebx
80107039:	5e                   	pop    %esi
8010703a:	5f                   	pop    %edi
8010703b:	5d                   	pop    %ebp
8010703c:	c3                   	ret    
8010703d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107040:	83 ec 0c             	sub    $0xc,%esp
80107043:	68 5d 7d 10 80       	push   $0x80107d5d
80107048:	e8 c3 97 ff ff       	call   80100810 <cprintf>
  if(newsz >= oldsz)
8010704d:	83 c4 10             	add    $0x10,%esp
80107050:	8b 45 0c             	mov    0xc(%ebp),%eax
80107053:	39 45 10             	cmp    %eax,0x10(%ebp)
80107056:	76 0d                	jbe    80107065 <allocuvm+0xe5>
80107058:	89 c1                	mov    %eax,%ecx
8010705a:	8b 55 10             	mov    0x10(%ebp),%edx
8010705d:	8b 45 08             	mov    0x8(%ebp),%eax
80107060:	e8 7b fb ff ff       	call   80106be0 <deallocuvm.part.0>
      kfree(mem);
80107065:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107068:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010706a:	56                   	push   %esi
8010706b:	e8 f0 b7 ff ff       	call   80102860 <kfree>
      return 0;
80107070:	83 c4 10             	add    $0x10,%esp
}
80107073:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107076:	89 f8                	mov    %edi,%eax
80107078:	5b                   	pop    %ebx
80107079:	5e                   	pop    %esi
8010707a:	5f                   	pop    %edi
8010707b:	5d                   	pop    %ebp
8010707c:	c3                   	ret    
8010707d:	8d 76 00             	lea    0x0(%esi),%esi
80107080:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107083:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107086:	5b                   	pop    %ebx
80107087:	89 f8                	mov    %edi,%eax
80107089:	5e                   	pop    %esi
8010708a:	5f                   	pop    %edi
8010708b:	5d                   	pop    %ebp
8010708c:	c3                   	ret    
8010708d:	8d 76 00             	lea    0x0(%esi),%esi
80107090:	89 c1                	mov    %eax,%ecx
80107092:	8b 55 10             	mov    0x10(%ebp),%edx
80107095:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107098:	31 ff                	xor    %edi,%edi
8010709a:	e8 41 fb ff ff       	call   80106be0 <deallocuvm.part.0>
8010709f:	eb 92                	jmp    80107033 <allocuvm+0xb3>
801070a1:	eb 0d                	jmp    801070b0 <deallocuvm>
801070a3:	90                   	nop
801070a4:	90                   	nop
801070a5:	90                   	nop
801070a6:	90                   	nop
801070a7:	90                   	nop
801070a8:	90                   	nop
801070a9:	90                   	nop
801070aa:	90                   	nop
801070ab:	90                   	nop
801070ac:	90                   	nop
801070ad:	90                   	nop
801070ae:	90                   	nop
801070af:	90                   	nop

801070b0 <deallocuvm>:
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801070b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070bc:	39 d1                	cmp    %edx,%ecx
801070be:	73 10                	jae    801070d0 <deallocuvm+0x20>
}
801070c0:	5d                   	pop    %ebp
801070c1:	e9 1a fb ff ff       	jmp    80106be0 <deallocuvm.part.0>
801070c6:	8d 76 00             	lea    0x0(%esi),%esi
801070c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801070d0:	89 d0                	mov    %edx,%eax
801070d2:	5d                   	pop    %ebp
801070d3:	c3                   	ret    
801070d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801070e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 0c             	sub    $0xc,%esp
801070e9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801070ec:	85 f6                	test   %esi,%esi
801070ee:	74 59                	je     80107149 <freevm+0x69>
801070f0:	31 c9                	xor    %ecx,%ecx
801070f2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801070f7:	89 f0                	mov    %esi,%eax
801070f9:	e8 e2 fa ff ff       	call   80106be0 <deallocuvm.part.0>
801070fe:	89 f3                	mov    %esi,%ebx
80107100:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107106:	eb 0f                	jmp    80107117 <freevm+0x37>
80107108:	90                   	nop
80107109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107110:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107113:	39 fb                	cmp    %edi,%ebx
80107115:	74 23                	je     8010713a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107117:	8b 03                	mov    (%ebx),%eax
80107119:	a8 01                	test   $0x1,%al
8010711b:	74 f3                	je     80107110 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010711d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107122:	83 ec 0c             	sub    $0xc,%esp
80107125:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107128:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010712d:	50                   	push   %eax
8010712e:	e8 2d b7 ff ff       	call   80102860 <kfree>
80107133:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107136:	39 fb                	cmp    %edi,%ebx
80107138:	75 dd                	jne    80107117 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010713a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010713d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107140:	5b                   	pop    %ebx
80107141:	5e                   	pop    %esi
80107142:	5f                   	pop    %edi
80107143:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107144:	e9 17 b7 ff ff       	jmp    80102860 <kfree>
    panic("freevm: no pgdir");
80107149:	83 ec 0c             	sub    $0xc,%esp
8010714c:	68 79 7d 10 80       	push   $0x80107d79
80107151:	e8 aa 93 ff ff       	call   80100500 <panic>
80107156:	8d 76 00             	lea    0x0(%esi),%esi
80107159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107160 <setupkvm>:
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	56                   	push   %esi
80107164:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107165:	e8 a6 b8 ff ff       	call   80102a10 <kalloc>
8010716a:	85 c0                	test   %eax,%eax
8010716c:	89 c6                	mov    %eax,%esi
8010716e:	74 42                	je     801071b2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107170:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107173:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107178:	68 00 10 00 00       	push   $0x1000
8010717d:	6a 00                	push   $0x0
8010717f:	50                   	push   %eax
80107180:	e8 1b d8 ff ff       	call   801049a0 <memset>
80107185:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107188:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010718b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010718e:	83 ec 08             	sub    $0x8,%esp
80107191:	8b 13                	mov    (%ebx),%edx
80107193:	ff 73 0c             	pushl  0xc(%ebx)
80107196:	50                   	push   %eax
80107197:	29 c1                	sub    %eax,%ecx
80107199:	89 f0                	mov    %esi,%eax
8010719b:	e8 b0 f9 ff ff       	call   80106b50 <mappages>
801071a0:	83 c4 10             	add    $0x10,%esp
801071a3:	85 c0                	test   %eax,%eax
801071a5:	78 19                	js     801071c0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071a7:	83 c3 10             	add    $0x10,%ebx
801071aa:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801071b0:	75 d6                	jne    80107188 <setupkvm+0x28>
}
801071b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071b5:	89 f0                	mov    %esi,%eax
801071b7:	5b                   	pop    %ebx
801071b8:	5e                   	pop    %esi
801071b9:	5d                   	pop    %ebp
801071ba:	c3                   	ret    
801071bb:	90                   	nop
801071bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801071c0:	83 ec 0c             	sub    $0xc,%esp
801071c3:	56                   	push   %esi
      return 0;
801071c4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071c6:	e8 15 ff ff ff       	call   801070e0 <freevm>
      return 0;
801071cb:	83 c4 10             	add    $0x10,%esp
}
801071ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071d1:	89 f0                	mov    %esi,%eax
801071d3:	5b                   	pop    %ebx
801071d4:	5e                   	pop    %esi
801071d5:	5d                   	pop    %ebp
801071d6:	c3                   	ret    
801071d7:	89 f6                	mov    %esi,%esi
801071d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071e0 <kvmalloc>:
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801071e6:	e8 75 ff ff ff       	call   80107160 <setupkvm>
801071eb:	a3 c4 5c 11 80       	mov    %eax,0x80115cc4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801071f0:	05 00 00 00 80       	add    $0x80000000,%eax
801071f5:	0f 22 d8             	mov    %eax,%cr3
}
801071f8:	c9                   	leave  
801071f9:	c3                   	ret    
801071fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107200 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107200:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107201:	31 c9                	xor    %ecx,%ecx
{
80107203:	89 e5                	mov    %esp,%ebp
80107205:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107208:	8b 55 0c             	mov    0xc(%ebp),%edx
8010720b:	8b 45 08             	mov    0x8(%ebp),%eax
8010720e:	e8 bd f8 ff ff       	call   80106ad0 <walkpgdir>
  if(pte == 0)
80107213:	85 c0                	test   %eax,%eax
80107215:	74 05                	je     8010721c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107217:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010721a:	c9                   	leave  
8010721b:	c3                   	ret    
    panic("clearpteu");
8010721c:	83 ec 0c             	sub    $0xc,%esp
8010721f:	68 8a 7d 10 80       	push   $0x80107d8a
80107224:	e8 d7 92 ff ff       	call   80100500 <panic>
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107230 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
80107235:	53                   	push   %ebx
80107236:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107239:	e8 22 ff ff ff       	call   80107160 <setupkvm>
8010723e:	85 c0                	test   %eax,%eax
80107240:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107243:	0f 84 9f 00 00 00    	je     801072e8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107249:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010724c:	85 c9                	test   %ecx,%ecx
8010724e:	0f 84 94 00 00 00    	je     801072e8 <copyuvm+0xb8>
80107254:	31 ff                	xor    %edi,%edi
80107256:	eb 4a                	jmp    801072a2 <copyuvm+0x72>
80107258:	90                   	nop
80107259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107260:	83 ec 04             	sub    $0x4,%esp
80107263:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107269:	68 00 10 00 00       	push   $0x1000
8010726e:	53                   	push   %ebx
8010726f:	50                   	push   %eax
80107270:	e8 db d7 ff ff       	call   80104a50 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107275:	58                   	pop    %eax
80107276:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010727c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107281:	5a                   	pop    %edx
80107282:	ff 75 e4             	pushl  -0x1c(%ebp)
80107285:	50                   	push   %eax
80107286:	89 fa                	mov    %edi,%edx
80107288:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010728b:	e8 c0 f8 ff ff       	call   80106b50 <mappages>
80107290:	83 c4 10             	add    $0x10,%esp
80107293:	85 c0                	test   %eax,%eax
80107295:	78 61                	js     801072f8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107297:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010729d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801072a0:	76 46                	jbe    801072e8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072a2:	8b 45 08             	mov    0x8(%ebp),%eax
801072a5:	31 c9                	xor    %ecx,%ecx
801072a7:	89 fa                	mov    %edi,%edx
801072a9:	e8 22 f8 ff ff       	call   80106ad0 <walkpgdir>
801072ae:	85 c0                	test   %eax,%eax
801072b0:	74 61                	je     80107313 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801072b2:	8b 00                	mov    (%eax),%eax
801072b4:	a8 01                	test   $0x1,%al
801072b6:	74 4e                	je     80107306 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801072b8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801072ba:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801072bf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801072c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801072c8:	e8 43 b7 ff ff       	call   80102a10 <kalloc>
801072cd:	85 c0                	test   %eax,%eax
801072cf:	89 c6                	mov    %eax,%esi
801072d1:	75 8d                	jne    80107260 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801072d3:	83 ec 0c             	sub    $0xc,%esp
801072d6:	ff 75 e0             	pushl  -0x20(%ebp)
801072d9:	e8 02 fe ff ff       	call   801070e0 <freevm>
  return 0;
801072de:	83 c4 10             	add    $0x10,%esp
801072e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801072e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ee:	5b                   	pop    %ebx
801072ef:	5e                   	pop    %esi
801072f0:	5f                   	pop    %edi
801072f1:	5d                   	pop    %ebp
801072f2:	c3                   	ret    
801072f3:	90                   	nop
801072f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801072f8:	83 ec 0c             	sub    $0xc,%esp
801072fb:	56                   	push   %esi
801072fc:	e8 5f b5 ff ff       	call   80102860 <kfree>
      goto bad;
80107301:	83 c4 10             	add    $0x10,%esp
80107304:	eb cd                	jmp    801072d3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107306:	83 ec 0c             	sub    $0xc,%esp
80107309:	68 ae 7d 10 80       	push   $0x80107dae
8010730e:	e8 ed 91 ff ff       	call   80100500 <panic>
      panic("copyuvm: pte should exist");
80107313:	83 ec 0c             	sub    $0xc,%esp
80107316:	68 94 7d 10 80       	push   $0x80107d94
8010731b:	e8 e0 91 ff ff       	call   80100500 <panic>

80107320 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107320:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107321:	31 c9                	xor    %ecx,%ecx
{
80107323:	89 e5                	mov    %esp,%ebp
80107325:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107328:	8b 55 0c             	mov    0xc(%ebp),%edx
8010732b:	8b 45 08             	mov    0x8(%ebp),%eax
8010732e:	e8 9d f7 ff ff       	call   80106ad0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107333:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107335:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107336:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107338:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010733d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107340:	05 00 00 00 80       	add    $0x80000000,%eax
80107345:	83 fa 05             	cmp    $0x5,%edx
80107348:	ba 00 00 00 00       	mov    $0x0,%edx
8010734d:	0f 45 c2             	cmovne %edx,%eax
}
80107350:	c3                   	ret    
80107351:	eb 0d                	jmp    80107360 <copyout>
80107353:	90                   	nop
80107354:	90                   	nop
80107355:	90                   	nop
80107356:	90                   	nop
80107357:	90                   	nop
80107358:	90                   	nop
80107359:	90                   	nop
8010735a:	90                   	nop
8010735b:	90                   	nop
8010735c:	90                   	nop
8010735d:	90                   	nop
8010735e:	90                   	nop
8010735f:	90                   	nop

80107360 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
80107366:	83 ec 1c             	sub    $0x1c,%esp
80107369:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010736c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010736f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107372:	85 db                	test   %ebx,%ebx
80107374:	75 40                	jne    801073b6 <copyout+0x56>
80107376:	eb 70                	jmp    801073e8 <copyout+0x88>
80107378:	90                   	nop
80107379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107380:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107383:	89 f1                	mov    %esi,%ecx
80107385:	29 d1                	sub    %edx,%ecx
80107387:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010738d:	39 d9                	cmp    %ebx,%ecx
8010738f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107392:	29 f2                	sub    %esi,%edx
80107394:	83 ec 04             	sub    $0x4,%esp
80107397:	01 d0                	add    %edx,%eax
80107399:	51                   	push   %ecx
8010739a:	57                   	push   %edi
8010739b:	50                   	push   %eax
8010739c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010739f:	e8 ac d6 ff ff       	call   80104a50 <memmove>
    len -= n;
    buf += n;
801073a4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801073a7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801073aa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801073b0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801073b2:	29 cb                	sub    %ecx,%ebx
801073b4:	74 32                	je     801073e8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801073b6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801073b8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801073bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801073be:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801073c4:	56                   	push   %esi
801073c5:	ff 75 08             	pushl  0x8(%ebp)
801073c8:	e8 53 ff ff ff       	call   80107320 <uva2ka>
    if(pa0 == 0)
801073cd:	83 c4 10             	add    $0x10,%esp
801073d0:	85 c0                	test   %eax,%eax
801073d2:	75 ac                	jne    80107380 <copyout+0x20>
  }
  return 0;
}
801073d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073dc:	5b                   	pop    %ebx
801073dd:	5e                   	pop    %esi
801073de:	5f                   	pop    %edi
801073df:	5d                   	pop    %ebp
801073e0:	c3                   	ret    
801073e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073eb:	31 c0                	xor    %eax,%eax
}
801073ed:	5b                   	pop    %ebx
801073ee:	5e                   	pop    %esi
801073ef:	5f                   	pop    %edi
801073f0:	5d                   	pop    %ebp
801073f1:	c3                   	ret    
