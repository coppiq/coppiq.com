; ==================
;      ex_fork
; Tests the fork()
; and sleep() system
; calls in Cerium 1.0
;
; Blueberry Spryte
; Dev:  @coppiq
; Date: 05 May 2026
; ==================

.include "cerium.s"

.text
.global _start

_start:
    mov r7, sys_fork
    svc

    cmp r0, fork_is_child

    mov r7, sys_write
    mov r0, stdout
    mov r2, #1
    
    beq child

parent:
    mov r7, sys_wait
    mov r0, #-1
    mov r1, #-1
    svc

    mov r7, sys_sleep
    mov r0, #1
    svc

    mov r7, sys_write
    mov r0, stdout
    adr r1, parent_str
    svc

    mov r7, sys_getpid
    svc

    str r0, [pid]
    mov r7, sys_write
    mov r0, stdout
    adr r1, pid
    svc

    adr r1, str_end
    svc

    mov r7, sys_sleep
    mov r0, #1
    svc

    b end

child:
    mov r7, sys_sleep
    mov r0, #2
    svc

    mov r7, sys_write
    mov r0, stdout
    adr r1, child_str
    svc

    mov r7, sys_getpid
    svc

    str r0, [pid]
    mov r7, sys_write
    mov r0, stdout
    adr r1, pid
    svc

    adr r1, str_end
    svc

end:
    mov r7, sys_exit
    mov r0, exit_success
    svc

.data
child_str: .string "Hello from child " fg_black bg_white "pid " 
parent_str: .string "Hello from parent " fg_black bg_green "pid "
str_end: .string fg_default bg_default "\n"
pid: .chars ""