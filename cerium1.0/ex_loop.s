; ==================
;      ex_loop
; Made to test jumps,
; pointer manipulation,
; and the write() syscall
; in Cerium 1.0
;
; Blueberry Spryte
; Dev:  @coppiq
; Date: 05 May 2026
; ==================


.include "cerium.s"

.text
.global _start

_start:
    mov r7, sys_write
    mov r0, stdout
    mov r2, #1
    
    mov r8, #0
:
    str r8, [pc + num]
    adr r1, num
    svc
    adr r1, sep
    svc
    adr r1, loopstr
    add r1, r1, r8
    svc
    adr r1, newline
    svc
    add r8, r8, #1
    cmp r8, #22
    blt :-

    mov r7, #1
    mov r0, #0
    svc

.data
loopstr: .chars "String to iterate over"
num:     .chars "0"
sep:     .chars " "
newline: .chars "\n"