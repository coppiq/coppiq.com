; ==================
;       init
; Starts CeriumShell
; and reaps any orphan
; processes
;
; The first task the
; kernel runs, and
; continues running
; until shutting down
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
    mov r7, sys_syslog
    mov r0, syslog_log
    adr r1, welcome_msg
    mov r2, #1
    svc

restart:
    mov r7, sys_fork
    svc
    
    cmp r0, fork_is_child
    beq child

:
    mov r7, sys_wait
    mov r0, #-1
    mov r1, #-1
    svc ; wait(-1, -1)

    cmp r0, #0
    ble restart ; no children left, restart

    b :-

child:
    mov r7, sys_execve
    adr r0, bash_path
    adr r1, null_arg
    mov r2, r1
    svc

    mov r7, sys_syslog
    mov r0, syslog_error
    adr r1, failed_to_load
    mov r2, #1
    svc

exit:
    mov r7, sys_exit
    mov r0, #0
    svc

.data
    welcome_msg: .string "init: Welcome to Cerium"
    failed_to_load: .string "init: failed to load Cesh"

    bash_path: .string "/bin/cesh"
    null_arg: .string "\0"