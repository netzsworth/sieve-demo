; Sieve of Eratosthenes — all primes up to 10000
; Target: emu8086 (8086, .model small, DOS INT 21h)
;
; Build: open in emu8086, Assemble, Run
; Expect: 1229 primes; last prime = 9973

.model small
.stack 100h

.data
    LIMIT       equ 10000
    SQRT_LIMIT  equ 100          ; floor(sqrt(10000))

    msg_title   db 'Primes from 2 to 10000 (Sieve of Eratosthenes):', 13, 10, '$'
    msg_count   db 13, 10, 'Total primes: ', '$'
    msg_done    db 13, 10, 'Done.', 13, 10, '$'
    space       db ' ', '$'
    newline     db 13, 10, '$'

    ; 1 = candidate prime, 0 = composite (uninit; filled at startup)
    ; emu8086: each DUP expansion must be <= 1020 chars — split the buffer
    sieve       db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 300 dup (?)
                db 101 dup (?)

.code
start:
    mov     ax, @data
    mov     ds, ax
    mov     es, ax

    ; All candidates start as 1 (avoid huge DUP literal expansion)
    lea     di, sieve
    mov     cx, LIMIT + 1
    mov     al, 1
    cld
    rep     stosb

    ; 0 and 1 are not prime
    mov     byte ptr sieve[0], 0
    mov     byte ptr sieve[1], 0

    call    run_sieve

    lea     dx, msg_title
    mov     ah, 09h
    int     21h

    call    print_primes

    lea     dx, msg_done
    mov     ah, 09h
    int     21h

    mov     ah, 4Ch
    int     21h

; ---------------------------------------------------------------------------
; Mark composites using the classic sieve.
; Outer: p = 2 .. SQRT_LIMIT
; Inner: mark p*p, p*p+p, ... while <= LIMIT
; ---------------------------------------------------------------------------
run_sieve proc
    mov     cx, 2                    ; p

outer_loop:
    cmp     cx, SQRT_LIMIT
    jg      outer_done

    mov     bx, cx
    mov     al, sieve[bx]
    cmp     al, 0
    je      next_p

    ; si = p * p
    mov     ax, cx
    mul     cx                       ; DX:AX = p*p (DX=0 for p<=100)
    mov     si, ax

inner_loop:
    cmp     si, LIMIT
    jg      next_p

    mov     sieve[si], 0

    add     si, cx
    jmp     inner_loop

next_p:
    inc     cx
    jmp     outer_loop

outer_done:
    ret
run_sieve endp

; ---------------------------------------------------------------------------
; Print every prime; newline every 20 numbers; print total count at end.
; ---------------------------------------------------------------------------
print_primes proc
    mov     cx, 2                    ; current n
    mov     di, 0                    ; primes printed on this line
    mov     bp, 0                    ; total prime count

print_loop:
    cmp     cx, LIMIT + 1
    jge     print_summary

    mov     bx, cx
    mov     al, sieve[bx]
    cmp     al, 0
    je      skip_n

    mov     ax, cx
    call    print_u16

    lea     dx, space
    mov     ah, 09h
    int     21h

    inc     bp
    inc     di
    cmp     di, 20
    jl      skip_n

    lea     dx, newline
    mov     ah, 09h
    int     21h
    mov     di, 0

skip_n:
    inc     cx
    jmp     print_loop

print_summary:
    lea     dx, newline
    mov     ah, 09h
    int     21h

    lea     dx, msg_count
    mov     ah, 09h
    int     21h

    mov     ax, bp
    call    print_u16

    lea     dx, newline
    mov     ah, 09h
    int     21h
    ret
print_primes endp

; ---------------------------------------------------------------------------
; Print unsigned 16-bit value in AX (decimal) via INT 21h AH=02h
; ---------------------------------------------------------------------------
print_u16 proc
    push    ax
    push    bx
    push    cx
    push    dx

    mov     bx, 10
    xor     cx, cx

div_loop:
    xor     dx, dx
    div     bx
    push    dx
    inc     cx
    cmp     ax, 0
    jne     div_loop

out_loop:
    pop     dx
    add     dl, '0'
    mov     ah, 02h
    int     21h
    loop    out_loop

    pop     dx
    pop     cx
    pop     bx
    pop     ax
    ret
print_u16 endp

end start