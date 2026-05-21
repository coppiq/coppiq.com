; ==================
;       cesh
; CeriumShell - Cerium
; 1.0's official shell
;
; Blueberry Spryte
; Cerium 1.0 Core
; Dev:  @coppiq
; Date: 18 May 2026
; ==================

.include "cerium.s"

.text
.global _start


write_prompt:
    push "coppiq@cerium~$ "

    mov r7, sys_write
    mov r0, stdout
    mov r1, sp
    mov r2, #1
    svc
    br


move_token_to_tokens:
    ; r8,  index
    ; r9,  character
    ; r10, output token
    ; r11, token index
    cmp r10, ""
    bne :+
    mov pc, lr
:
    ; r9 becomes used as
    ; the memory address
    ; of the new location
    add r9, sp, r11
    str r10, [r9]
    add r11, r11, #1
    mov r10, ""

    mov pc, lr


err_file_doesnt_exist:
    push "\n"
    push r0
    push "cesh: command not found: "
    
    mov r7, sys_write
    mov r0, stderr
    mov r1, sp
    mov r2, #3
    svc
    br


err_permission_denied:
    push "\n"
    push r0
    push "cesh: permission denied: "
    
    mov r7, sys_write
    mov r0, stderr
    mov r1, sp
    mov r2, #3
    svc
    br


clear:
    push "\e[2J"
    mov r7, sys_write
    mov r0, stdout
    mov r1, sp
    mov r2, #1
    svc
    br


cd:
    cmp r11, #1
    bgt :+
    br
:
    mov r7, sys_chdir
    br


check_internal_commands:
    ; r8,  index
    ; r9,  character
    ; r10, output token
    ; r11, token index
    ldr r0, [sp + 2]
    
    cmp r0, "clear"
    bne :+
    
    bs clear
    mov r0, #0
    br
:
    cmp r0, "cd"
    bne :+

    bs clear
    mov r0, #0
    br
:
    cmp r0, "exit"
    bne :+

    b exit
:
    mov r0, #1
    br


parse_line:
    sub sp, sp, #512

    mov r7, sys_read
    mov r0, stdin
    add r1, sp, #256
    mov r2, #256
    svc

    cmp r0, #1
    bgt :+
    ; empty prompt
    br
:

    mov r8, #0
    mov r10, ""
    mov r11, #0
    ; r8,  index
    ; r9,  character
    ; r10, output token
    ; r11, token index
parse_char:
    cmp r8, r0
    bge parse_end

    add r9, sp, #256
    add r9, r9, r8
    ldr r9, [r9]

    cmp r9, "\n"
    beq parse_end

    cmp r9, " "
    bne char_is_normal
    
    bl move_token_to_tokens
    add r8, r8, #1
    b parse_char

char_is_normal:
    join r10, r10, r9

    add r8, r8, #1
    b parse_char

parse_end:
    bl move_token_to_tokens

    ; check amount of tokens
    cmp r11, #0
    bgt :+
    br ; no tokens
:
    mov r8, "\0"
    str r8, [sp + r11]

    bs check_internal_commands
    cmp r0, #0
    bne :+
    br
:

    mov r7, sys_stat
    mov r0, sp
    mov r1, #-1
    svc

    cmp r0, stat_success
    beq file_exists

    ; file 
    ldr r0, [sp]

    ; check if file is absolute
    ; or relative
    ltr r5, r0, #0
    cmp r5, "/"
    bne :+
    ; if absolute, return error
    bs err_file_doesnt_exist
    br
:
    ; check hard coded PATH
    mov r6, "/bin/"
    join r0, r6, r0
    
    push r0
    mov r0, sp
    svc
    
    cmp r0, stat_success
    beq :+
    add sp, sp, #1
    ldr r0, [sp]
    bs err_file_doesnt_exist
    br
:
    ; PATH file exists
    pop r0
    str r0, [sp]
file_exists:
    ; create child to run executable
    mov r7, sys_fork
    svc

    cmp r0, #0
    beq child

parent:
    ; wait for child to return
    mov r7, sys_wait
    ; r0 has child name
    mov r1, #-1
    svc

    br

child:
    ; setup arguments
    mov r7, sys_execve
    mov r0, sp
    add r1, sp, #1
    mov r2, #-1
    svc

    ldr r0, [sp]
    bs err_permission_denied

    mov r7, sys_exit
    mov r0, exit_failure
    svc


exit:
    mov r7, sys_exit
    mov r0, exit_success
    svc


_start:
:
    bs write_prompt
    bs parse_line
    b :-