        segment .text
global dynamicArray_create
global dynamicArray_fill
global dynamicArray_print
global dynamicArray_min
global dynamicArray_get_value_at
global dynamicArray_put_value_at
global dynamicArray_insert_at

extern malloc
extern printf
extern random
extern free

ARRAY_ELEMENT_SIZE equ 8


;   array = create ( size );
dynamicArray_create:
        push    rbp
        mov     rbp, rsp
        imul    rdi, ARRAY_ELEMENT_SIZE
        call    malloc wrt ..plt
        leave
        ret

        
;   fill ( array, size );
dynamicArray_fill:
.array  equ     0
.size   equ     8
.i      equ     16
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     [rsp+.array], rdi
        mov     [rsp+.size], rsi
        xor     ecx, ecx
.more   mov     [rsp+.i], rcx
        call    random wrt ..plt
        mov     rcx, [rsp+.i]
        mov     rdi, [rsp+.array]
        mov     [rdi+rcx*ARRAY_ELEMENT_SIZE], rax
        inc     rcx
        cmp     rcx, [rsp+.size]
        jl      .more
        leave
        ret

        
;   print ( array, size );
dynamicArray_print:
.array  equ     0
.size   equ     8
.i      equ     16
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     [rsp+.array], rdi
        mov     [rsp+.size], rsi
        xor     ecx, ecx
        mov     [rsp+.i], rcx
        segment .data
.format db      "%10d",0x0a,0
        segment .text
.more:
        lea     rdi, [rel .format]
        mov     rdx, [rsp+.array]
        mov     rcx, [rsp+.i]
        mov     rsi, [rdx+rcx*ARRAY_ELEMENT_SIZE]
        mov     [rsp+.i], rcx
        call    printf wrt ..plt
        mov     rcx, [rsp+.i]
        inc     rcx
        mov     [rsp+.i], rcx
        cmp     rcx, [rsp+.size]
        jl      .more
        leave
        ret

        
;   value = min ( array, size );
dynamicArray_min:
        mov     rax, [rdi]
        mov     rcx, 1
.more:
        mov     r8, [rdi+rcx*ARRAY_ELEMENT_SIZE]
        cmp     r8, rax
        cmovl   rax, r8
        inc     rcx 
        cmp     rcx, rsi
        jl      .more
        ret
        
        
;   value =  get_value_at ( array, index );         
dynamicArray_get_value_at:
        mov     rax, [rdi+rsi*ARRAY_ELEMENT_SIZE]
        ret
        
        
;   put_value_at ( array, index, val );         
dynamicArray_put_value_at:
        mov     [rdi+rsi*ARRAY_ELEMENT_SIZE], rdx
        ret
        
        
        
;  array = insert_at ( array, index, value, &size, &capacity) inserts at index and shifts thats index value and trailing elements to the right
dynamicArray_insert_at:
.array      equ     0
.index      equ     8
.value      equ     16
.size       equ     24
.capacity   equ     32
.rax        equ     40
        push    rbp
        mov     rbp, rsp
        sub     rsp, 48
        mov     [rsp+.array], rdi
        mov     [rsp+.index], rsi
        mov     [rsp+.value], rdx
        mov     [rsp+.size], rcx
        mov     [rsp+.capacity], r8
        mov     r10, [r8]
        cmp     r10, [rcx]
        jg      .hold
        imul    rdi, [r8], 2  ; test overflow
        mov     [r8], rdi
        imul    rdi, ARRAY_ELEMENT_SIZE
        call    malloc wrt ..plt
        jmp     .changed
.hold:
        mov     rax, [rsp+.array]
.changed:
        mov     rdi, [rsp+.array]
        mov     r9, [rsp+.size]
        mov     r8, [rsp+.size]
        mov     r8, [r8]
        mov     r9, [r9]
        mov     rsi, [rsp+.index]
.more_up:
        dec     r8
        mov     rdx, [rdi+r8*ARRAY_ELEMENT_SIZE]
        mov     [rax+r9*ARRAY_ELEMENT_SIZE], rdx
        mov     r9, r8
        cmp     r9, rsi
        jne     .more_up
        mov     rdx, [rsp+.value]
        mov     [rax+r9*ARRAY_ELEMENT_SIZE], rdx
        cmp     rsi, 0
        je      .zero
        cmp     rax, rdi
        je      .zero
.more_down:
        dec     rsi
        mov     rdx, [rdi+rsi*ARRAY_ELEMENT_SIZE]
        mov     [rax+rsi*ARRAY_ELEMENT_SIZE], rdx
        cmp     rsi, 0
        jne     .more_down     
.zero:
        mov     rdx, [rsp+.size]
        inc     qword [rdx]
        cmp     rax, rdi
        je      .end
        mov     [rsp+.rax], rax
        call    free wrt ..plt
        mov     rax, [rsp+.rax]
.end:
        leave
        ret


















































