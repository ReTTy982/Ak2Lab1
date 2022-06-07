SYSEXIT = 1
SYSREAD = 3
SYSWRITE =4
STDIN = 0
STDOUT = 1
SYSCALL = 0x80

tekst_lenght = 254

.bss

bajt: .space 1
tekst: .space tekst_lenght

.text
.global _start

_start:

mov $SYSREAD, %eax
mov $STDIN, %ebx
mov $tekst, %ecx
mov $tekst_lenght, %edx
int $SYSCALL

xor %esi, %esi


petla_byte:
movb tekst(,%esi,1), %bl
mov %bl, bajt
cmp $65, %bl # x>= 65 x<=90
jge litera_check
cmp $253, %esi   
je koniec
inc %esi


jmp petla_byte


wypisz:
inc %esi

jmp petla_byte


litera_check:
cmp $90 ,%bl
jle wielka
cmp $122, %bl
jle mala

wielka:
addb $32, %bl
movb %bl, bajt
mov %bl, tekst(,%esi,1)

jmp wypisz


mala:
subb $32, %bl
mov %bl, tekst(,%esi,1)
jmp wypisz

koniec:

mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $tekst, %ecx
mov $tekst_lenght, %edx
int $SYSCALL

mov $1, %eax
mov $0, %ebx
int $SYSCALL

