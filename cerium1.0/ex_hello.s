; ==================
;      ex_hello
; Hello World using
; the write() system
; call in Cerium 1.0
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
    adr r1, hello
    mov r2, #1
    svc

    mov r7, sys_exit
    mov r0, exit_success
    svc

.data
hello: .string "Hello, World!\n"