; ==================
;       clear
; Clears the screen
;
; Blueberry Spryte
; Cerium 1.0 Core
; Dev:  @coppiq
; Date: 10 May 2026
; ==================


.include "cerium.s"

.text
.global _start

_start:
    mov r7, sys_write
    mov r0, stdout
    adr r1, clear_str
    mov r2, #1
    svc

    mov r7, sys_exit
    mov r0, exit_success
    svc

.data
    clear_str: .string "\e[2J"