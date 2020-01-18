        segment .text
global queueArray_enqueue
global queueArray_dequeue
global queueArray_print

extern malloc
extern printf
extern free


ARRAY_ELEMENT_SIZE equ 8

        
            struc   node
node_value  resq    1
next_node   resq    1
            align   8
            endstruc

 
;   enqueue(array, head, rear, size, value) ; adds value at position at tail  
queueArray_enqueue:
        cmp     qword [rdx], -1
        jne     .nempty
        mov     qword [rsi], dword 0
        mov     qword [rdx], dword 0
        mov     [rdi], r8
        jmp     .ret
.nempty:        
        dec     rcx
        cmp     qword [rdx], rcx
        sete    r9b
        cmp     qword [rsi], 0
        sete    r10b
        and     r9, r10
        mov     r11, [rsi]
        sub     r11, 1
        cmp     [rdx], r11
        sete    r10b
        or      r9, r10
        jnz     .ret
        
        cmp     qword [rdx], rcx
        jne     .inc
        mov     qword [rdx], dword 0
        jmp     .end
.inc:        
        inc     qword [rdx]
.end:
        mov     rcx, [rdx]
        mov     [rdi+rcx*ARRAY_ELEMENT_SIZE], r8
.ret:
        ret        
        
        
;   value = dequeue(array, head, rear, size) ; returns value and removes least recently added element (front)
queueArray_dequeue:
        cmp     qword [rsi], -1
        je      .ret
        mov     r8, [rsi]
        cmp     qword [rdx], r8
        jne     .noteq
        mov     qword [rsi], dword -1
        mov     qword [rdx], dword -1
        jmp     .assign
.noteq:
        dec     rcx
        cmp     qword [rsi], rcx
        jne     .nlast
        mov     qword [rsi], dword 0
        jmp     .assign
.nlast:
        inc     qword [rsi]
.assign:
        mov     rax, [rdi+r8*ARRAY_ELEMENT_SIZE]
.ret:
        ret


;   print ( array, head, tail, size);
queueArray_print:
.array  equ     0
.tail   equ     8
.i      equ     16
.size   equ     24
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     [rsp+.array], rdi
        mov     [rsp+.tail], rdx
        mov     [rsp+.size], rcx
        mov     rcx, rsi
        mov     [rsp+.i], rcx
        segment .data
.format db      "%10d",0x0a,0
        segment .text
        cmp     rcx, rdx   
        jne     .more
        lea     rdi, [rel .format]
        mov     rdx, [rsp+.array]
        mov     rcx, [rsp+.i]
        mov     rsi, [rdx+rcx*ARRAY_ELEMENT_SIZE]
        call    printf wrt ..plt
        jmp     .end
.more:
        lea     rdi, [rel .format]
        mov     rdx, [rsp+.array]
        mov     rcx, [rsp+.i]
        mov     rsi, [rdx+rcx*ARRAY_ELEMENT_SIZE]
        mov     [rsp+.i], rcx
        call    printf wrt ..plt
        mov     rcx, [rsp+.i]
        inc     rcx
        cmp     rcx, [rsp+.size]
        jne      .cont
        mov     rcx, 0
.cont:
        mov     [rsp+.i], rcx
        cmp     rcx, [rsp+.tail]
        jne     .more
        lea     rdi, [rel .format]
        mov     rdx, [rsp+.array]
        mov     rcx, [rsp+.i]
        mov     rsi, [rdx+rcx*ARRAY_ELEMENT_SIZE]
        call    printf wrt ..plt
.end:   
        leave
        ret
