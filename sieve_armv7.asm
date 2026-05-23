/*

Sieve of Eratosthenes in ARMv7 Assembly

Calculates all prime numbers up to 10,000.

Strictly compatible with CPUlator (ARMv7 generic / DE1-SoC).

To verify execution in CPUlator:

Compile and Run.

When the processor halts at 'end', check register r8.

It should contain 1229 (0x4CD) - the number of primes up to 10,000.

Open the "Memory" tab and jump to the 'primes' symbol to view the list.
*/

.syntax unified
.global _start

.text
_start:
/* STREAMING_CHUNK:Initializing the flags array... */
@ Load the base address of the flags array into r6.
@ The flags array acts as our boolean map for numbers 0 to 10000.
ldr r6, =flags

@ We need to initialize the array to 1 (Assuming all are prime initially)
mov r1, #1          @ Value to write (1 = true)
mov r2, #0          @ Loop counter (index)
ldr r3, =10001      @ Array size (MAX_NUM + 1)


init_loop:
cmp r2, r3
bge init_done       @ If index >= 10001, we're done initializing
strb r1, [r6, r2]   @ Store 1 byte (1) into flags[r2]
add r2, r2, #1      @ Increment index
b init_loop

init_done:
/* STREAMING_CHUNK:Setting base cases for 0 and 1... */
@ 0 and 1 are not prime. Set flags[0] = 0 and flags[1] = 0.
mov r1, #0
strb r1, [r6, #0]
strb r1, [r6, #1]

@ Load the upper limit (10000) into r9
ldr r9, =10000

@ Initialize our current test number 'p' to 2 (the first prime)
mov r4, #2

/* STREAMING_CHUNK:Executing the main Sieve algorithm... */


outer_loop:
@ Calculate p * p to see if we've exceeded sqrt(10000)
@ If p * p > 10000, we can stop sieving.
mul r5, r4, r4
cmp r5, r9
bgt sieve_done

@ Check if flags[p] is still 1 (meaning 'p' is prime)
ldrb r1, [r6, r4]
cmp r1, #0
beq next_p          @ If flags[p] == 0, 'p' is composite; skip to next

@ Inner loop: cross out all multiples of 'p' starting from p*p
@ r5 currently holds p*p. It will serve as our inner loop index 'i'


inner_loop:
cmp r5, r9
bgt next_p          @ If i > 10000, we've crossed out all multiples for this 'p'

@ flags[i] = 0 (Mark as composite)
mov r1, #0
strb r1, [r6, r5]

@ i = i + p (Move to the next multiple)
add r5, r5, r4
b inner_loop


next_p:
@ Increment p (p = p + 1) and repeat
add r4, r4, #1
b outer_loop

sieve_done:
/* STREAMING_CHUNK:Collecting the calculated primes into memory... */
@ Now that the sieve is complete, we'll collect all numbers 'p'
@ where flags[p] == 1 into the 'primes' array.
ldr r7, =primes
mov r8, #0          @ r8 will act as our prime counter
mov r4, #2          @ Start checking from 2 again

collect_loop:
cmp r4, r9
bgt done            @ If we've checked up to 10000, we're completely finished

@ Load flags[p]
ldrb r1, [r6, r4]
cmp r1, #1
bne skip_collect    @ If it's not 1, it's not a prime, so skip

@ It is a prime. Store 'p' (r4) into primes[r8].
@ Since each prime is stored as a 4-byte word, we use LSL #2 to 
@ multiply the counter index by 4 to get the correct memory offset.
str r4, [r7, r8, lsl #2]

@ Increment the total prime counter
add r8, r8, #1


skip_collect:
add r4, r4, #1      @ Check the next number
b collect_loop

done:
/* STREAMING_CHUNK:Halting CPU execution safely... */
@ Execution complete.
@ The primes array now contains every prime up to 10000.
@ r8 holds the total count: 1229 (0x4CD).
@ CPUlator will recognize this tight loop as a halt and pause execution safely.
end:
b end

.data
/* STREAMING_CHUNK:Defining initialized memory and data sections... */
@ Align memory on 4-byte boundaries
.align 2

flags:

@ Allocate 10,001 bytes to act as our boolean sieve array.
@ Indexes 0 through 10000 are used.
.space 10001

.align 2


primes:
@ Allocate space to store the final list of prime numbers.
@ There are 1229 primes up to 10,000.
@ 1229 words * 4 bytes/word = 4916 bytes.
@ We allocate 5000 bytes to ensure plenty of room.
.space 5000