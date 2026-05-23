/*
 * Sieve of Eratosthenes - x86-64 Assembly
 * Finds all primes up to 10,000
 * Runs barebones on QEMU
 *
 * Build: as x64/sieve.s -o x64/sieve.o
 *        ld -Ttext 0x400000 x64/sieve.o -o x64/sieve
 * Run:   qemu-system-x86_64 -kernel x64/sieve -nographic
 */

.globl _start
.text

_start:
    /* rdi = limit (10000) */
    movq    $10000, %rdi
    
    /* Allocate sieve array on stack */
    subq    %rdi, %rsp       /* Allocate rdi bytes on stack */
    movq    %rsp, %r8        /* r8 = pointer to sieve array */
    
    /* Initialize array to all 1s (all marked as prime) */
    xorq    %rcx, %rcx       /* rcx = 0 */
    movq    $1, %al          /* al = 1 (prime marker) */
    movq    %rdi, %rcx       /* rcx = limit */
    movq    %r8, %rdi        /* rdi = array pointer */
    rep     stosb            /* Fill array with 1s (rdi += ecx) */
    
    /* Mark 0 and 1 as not prime */
    movq    %r8, %r9         /* r9 = array pointer */
    movb    $0, (%r9)        /* sieve[0] = 0 */
    movb    $0, 1(%r9)       /* sieve[1] = 0 */
    
    /* Main sieve loop: for i = 2 to limit */
    movq    $2, %r10         /* r10 = i */
    
sieve_loop:
    cmpq    $10000, %r10     /* Compare i with 10000 */
    jge     count_primes     /* If i >= 10000, go count */
    
    /* Check if sieve[i] is marked as prime */
    movq    %r8, %r11        /* r11 = array pointer */
    movzbl  (%r11, %r10, 1), %eax  /* al = sieve[i] */
    testb   %al, %al         /* Test if zero */
    jz      next_i           /* If zero, skip marking multiples */
    
    /* Mark multiples of i as not prime (0) */
    movq    %r10, %r12       /* r12 = i */
    addq    %r10, %r12       /* r12 = 2*i (first multiple) */
    
mark_multiples:
    cmpq    $10000, %r12     /* Compare 2*i with limit */
    jge     next_i           /* If 2*i >= limit, done */
    
    movq    %r8, %r11        /* r11 = array pointer */
    movb    $0, (%r11, %r12, 1)  /* Mark sieve[2*i] as not prime */
    addq    %r10, %r12       /* r12 += i (next multiple) */
    jmp     mark_multiples
    
next_i:
    incq    %r10             /* i++ */
    jmp     sieve_loop
    
count_primes:
    /* Count primes in array */
    xorq    %r13, %r13       /* r13 = prime counter */
    xorq    %r14, %r14       /* r14 = index */
    
count_loop:
    cmpq    $10000, %r14     /* Compare index with limit */
    jge     do_exit          /* If index >= limit, exit */
    
    movq    %r8, %r11        /* r11 = array pointer */
    movzbl  (%r11, %r14, 1), %eax  /* al = sieve[index] */
    testb   %al, %al         /* Test if prime */
    jz      skip_count       /* If zero (not prime), skip */
    
    incq    %r13             /* Increment prime counter */
    
skip_count:
    incq    %r14             /* index++ */
    jmp     count_loop
    
do_exit:
    /* Exit with prime count */
    movq    %r13, %rax       /* rax = prime count */
    movq    $60, %rax        /* rax = exit syscall number */
    movq    %r13, %rdi       /* rdi = exit code (prime count) */
    syscall
    
    jmp     do_exit          /* Infinite loop (safety) */
