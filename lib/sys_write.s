.section .data
newln: .ascii "\n"
.macro newline fd
    movq \fd, %rdi
    leaq newln(%rip), %rsi
    movq $1, %rdx
    movq $1, %rax
    syscall
.endm

.macro write fd, str, len
    movq \fd, %rdi
    leaq \str, %rsi
    movq \len, %rdx
    movq $1, %rax
    syscall
.endm

.macro writeln fd, str, len
    write \fd, \str, \len
    newline \fd
.endm

.macro print str
    leaq \str, %rdi
    call strlen
    write $1, \str, %rax
.endm

.macro println str
    leaq \str, %rdi
    call strlen
    writeln $1, \str, %rax
.endm


.section .text

# rdi holds the string pointer
.type strlen, @function
strlen:
    pushq %rbp
    movq %rsp, %rbp

continueSL0:
    pushq %rbx
    movq $0, %rbx

    movq %rdi, %rsi
.LPSL0:
    lodsb
    cmpb $0, %al
    je continueSL1
    incq %rbx
    jmp .LPSL0

continueSL1:
    movq %rbx, %rax
    popq %rbx

    leave
    ret
