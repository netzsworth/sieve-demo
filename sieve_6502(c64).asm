* = $C000

main
    lda #$32        
    jsr ERATOS
    jsr PRINT_RESULTS
    rts

ERATOS
    sta $D0
    lda #$00
    ldx #$00

SETUP
    sta $1000,x
    adc #$01
    inx
    cpx $D0
    bpl SETLBL
    jmp SETUP
SETLBL
    ldx #$02
SIEVE
    lda $1000,x
    inx
    cpx $D0
    bpl SIEVED
    cmp #$00
    beq SIEVE
    sta $D1
MARK
    clc
    adc $D1
    tay
    lda #$00
    sta $1000,y
    tya
    cmp $D0
    bpl SIEVE
    jmp MARK
SIEVED
    ldx #$01
    ldy #$00
COPY
    inx
    cpx $D0
    bpl COPIED
    lda $1000,x
    cmp #$00
    beq COPY
    sta $2000,y
    iny
    jmp COPY
COPIED
    tya
    rts
PRINT_RESULTS
    cld
    ldy #$00        ; This is your "Main" index
PRINT_LOOP
    lda $2000,y
    beq PRINT_DONE
    
    tya             ; Move Y to Accumulator
    pha             ; Push it to the Stack to keep it safe
    
    lda $2000,y     ; Get the prime again
    jsr PRINT_BYTE
    
    lda #$20        ; Space
    jsr $FFD2
    
    pla             ; Pull the original Y back from the Stack
    tay             ; Put it back into the Y register
    
    iny
    cpy #$15        ; Limit to 21 primes
    bne PRINT_LOOP
PRINT_DONE
    rts
PRINT_BYTE
    ldx #$00        ; Hundreds
    ldy #$00        ; Tens
    
HUNDREDS
    cmp #100
    bcc TENS
    sec
    sbc #100
    inx
    jmp HUNDREDS
    
TENS
    cmp #10
    bcc ONES
    sec
    sbc #10
    iny
    jmp TENS
    
ONES
    sta $FB         ; Temporary storage for ones digit
    
    ; --- Print Hundreds ---
    txa
    beq SKIP_H
    clc
    adc #$30
    jsr $FFD2
SKIP_H

    ; --- Print Tens ---
    tya
    bne DO_T        ; If tens > 0, always print
    txa             ; If we had hundreds (e.g., 101), we MUST print the 0
    beq SKIP_T
DO_T
    tya
    clc
    adc #$30
    jsr $FFD2
SKIP_T

    ; --- Print Ones ---
    lda $FB
    clc
    adc #$30
    jsr $FFD2
    rts