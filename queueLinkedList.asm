        segment .text
global queueLinkedList_enqueue
global queueLinkedList_dequeue
global queueLinkedList_print

extern malloc
extern printf
extern free


NULL            equ 0
NODE_ADDR_SIZE  equ 8
        
            struc   node
node_value  resq    1
next_node   resq    1
            align   8
            endstruc

 
;   enqueue(rear, value, head) ; adds value at position at tail  
queueLinkedList_enqueue:
.rear   equ     0
.value  equ     8
.head   equ     16
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32 
        mov     [rsp+.rear], rdi
        mov     [rsp+.value], rsi
        mov     [rsp+.head], rdx
        mov     rdi, node_size
        call    malloc wrt ..plt
        mov     rsi, [rsp+.value]
        mov     [rax+node_value], rsi        
        mov     rdi, [rsp+.rear]
        cmp     qword [rdi], NULL
        je      .init
        mov     r8, [rdi]
        mov     [r8+next_node], rax
        jmp     .end
.init:
        mov     rsi, [rsp+.head] 
        mov     [rsi], rax
.end:
        mov     [rdi], rax
        mov     qword [rax+next_node], dword NULL
        xor     eax, eax
        leave
        ret        
        
        
;   value = dequeue(rear, head) ; returns value and removes least recently added element (front)
queueLinkedList_dequeue:
.rax    equ     0
        push    rbp
        mov     rbp, rsp
        cmp     qword [rsi], NULL
        je      .end
        mov     r8, [rsi]
        cmp     qword r8, [rdi]
        jne      .cont
        mov     qword [rdi], dword NULL
.cont:        
        sub     rsp, 16
        mov     rax, [r8+node_value]
        mov     r9, [r8+next_node]
        mov     [rsi], r9
        mov     [rsp+.rax], rax
        mov     rdi, r8
        call    free wrt ..plt
        mov     rax, [rsp+.rax]
.end:
        leave
        ret


; print( head )
queueLinkedList_print:
        segment .data
.print_fmt:
        db      "%ld ", 0
.newline:
        db      0x0a, 0
        segment .text
.rbx    equ     0
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     [rsp+.rbx], rbx
        cmp     rdi, NULL
        je      .done
        cmp     qword [rdi], NULL
        je      .done
        mov     rbx, [rdi]
.more:
        lea     rdi, [rel .print_fmt] 
        mov     rsi, [rbx+node_value]
        call    printf wrt ..plt
        mov     rbx, [rbx+next_node]
        cmp     rbx, NULL
        jne     .more
.done:
        lea     rdi, [rel .newline]
        call    printf wrt ..plt
        mov     rbx, [rsp+.rbx]
        leave
        ret

