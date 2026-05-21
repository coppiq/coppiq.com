; ==================
;      ex_color
; Shows off the colour
; capabilities of the
; CeTerminal and a
; funny little message
;
; Blueberry Spryte
; Dev:  @coppiq
; Date: 12 May 2026
; ==================

.include "cerium.s"

.text

.global _start
_start:
    mov r7, sys_write
    mov r0, stdout
    adr r1, test_str
    mov r2, #1
    svc

    adr r1, unix
    svc

    mov r7, sys_exit
    mov r0, exit_success
    svc

.data
    test_str: .string bg_black "  0" bg_red "  1" bg_green "  2" \
            bg_yellow "  3" bg_blue "  4" bg_magenta "  5" bg_cyan \
            "  6" bg_white fg_black "  7" fg_default bg_default "\n" \
            bg_white fg_black "  0" bg_default fg_red "  1" fg_green \
            "  2" fg_yellow "  3" fg_blue "  4" fg_magenta "  5" fg_cyan \
            "  6" fg_white "  7" fg_default "\n" \

    unix: .string "\nSends other " fg_red "U" fg_green "N" fg_yellow "I" \
            fg_blue "X" fg_default " boxes to " fg_magenta "/dev/null" \
            fg_default "\n"