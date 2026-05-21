.define sys_exit 1
.define sys_fork 2
.define sys_read 3
.define sys_write 4
.define sys_open 5
.define sys_close 6
.define sys_creat 8
.define sys_execve 11
.define sys_chdir 12
.define sys_chmod 15
.define sys_getpid 20
.define sys_wait 35
.define sys_mkdir 39
.define sys_rmdir 40
.define sys_pipe 42
.define sys_syslog 103
.define sys_stat 106
.define sys_getdents 141
.define sys_getcwd 183
.define sys_sleep 500

.define stdin 0
.define stdout 1
.define stderr 2

.define fork_is_child 0

.define execve_failed -1

.define syslog_log 0
.define syslog_warn 1
.define syslog_error 2

.define exit_success 0
.define exit_failure 1

.define stat_success 0

.define fg_black "\e[30m"
.define fg_red "\e[31m"
.define fg_green "\e[32m"
.define fg_yellow "\e[33m"
.define fg_blue "\e[34m"
.define fg_magenta "\e[35m"
.define fg_cyan "\e[36m"
.define fg_white "\e[37m"
.define fg_default "\e[39m"

.define bg_black "\e[40m"
.define bg_red "\e[41m"
.define bg_green "\e[42m"
.define bg_yellow "\e[43m"
.define bg_blue "\e[44m"
.define bg_magenta "\e[45m"
.define bg_cyan "\e[46m"
.define bg_white "\e[47m"
.define bg_default "\e[49m"