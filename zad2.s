SYSEXIT = 1
SYSREAD = 3
SYSWRITE =4
STDIN = 0
STDOUT = 1
SYSCALL = 0x80

buff_length = 32
wynik_length = 128

.bss

symbol:  .space 1
bufor: .space buff_length
wynik: .space buff_length*4
text_size: .long 0
zmienna: .long 0


.data 


.text
.global _start



_start:

mov $SYSREAD, %eax
mov $STDIN, %ebx
mov $bufor, %ecx
mov $buff_length, %edx
int $SYSCALL

mov %eax, text_size
subl $2, text_size
xor %esi, %esi # esi bedzie iteratorem
xor %edi, %edi
xor %eax, %eax

get_byte:
cmp $2, %esi
je wypisz
movb bufor(,%esi,1), %bl
cmp $'9', %bl
jbe liczba

litera:
subb $55, %bl
jmp dalej_0


liczba:
subb $48, %bl
jmp dalej_0

dalej_0:
inc %eax
movb %bl, %al # kopiowanie bo nie mozna andowac 2 pamieci 
AND $0b1000, %al  # 0b1000
cmp $0, %al
je zero
jmp jeden

dalej_1:
movb %bl, %al # kopiowanie bo nie mozna andowac 2 pamieci 
AND $0b0100, %al  # 0b1000
cmp $0, %al
je zero
jmp jeden
dalej_2:
movb %bl, %al # kopiowanie bo nie mozna andowac 2 pamieci 
AND $0b0010, %al  # 0b1000
cmp $0, %al
je zero
jmp jeden
dalej_3:
movb %bl, %al # kopiowanie bo nie mozna andowac 2 pamieci 
AND $0b0001, %al  # 0b1000
cmp $0, %al
je zero
jmp jeden


zero:
mul %edi
movb $'0', wynik(,%edi,1)
div %edi
inc %edi
cmp $1, %edi
je dalej_1
cmp $2, %edi
je dalej_2
cmp $3, %edi
je dalej_3
inc %esi
jmp get_byte  # koniec szukania bitow 


jeden:
mul %edi
movb $'1', wynik(,%edi,1)
div %edi
inc %edi
cmp $1, %edi
je dalej_1
cmp $2, %edi
je dalej_2
cmp $3, %edi
je dalej_3
inc %esi
jmp get_byte  # koniec szukania bitow  





wypisz:

mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $wynik, %ecx
mov $wynik_length, %edx
int $SYSCALL



mov $1, %eax
mov $0, %ebx
int $SYSCALL
