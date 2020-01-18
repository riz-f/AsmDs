        segment .text
global hashTable_insert
global hashTable_print
global hashTable_find
global hashTable_remove

extern malloc
extern printf
extern free

NULL        equ 0
QWORD_SIZE  equ 8

            struc   node
node_key    resq    1
node_value  resq    1
next_node   resq    1
            align   8
            endstruc

        segment .data
table   times 256 dq    NULL
        
        segment .text
        
;   index = hash ( key )
hash:
        mov     rax, rdi
        and     rax, 0xff
        ret

        

;   pointer = find ( key )
hashTable_find:
.key    equ     0
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     [rsp+.key], rdi
        call    hash
        lea     rdx, [rel table]
        mov     rax, [rdx+rax*QWORD_SIZE]
        mov     rdi, [rsp+.key]
        cmp     rax, NULL
        je      .done
.more:
        cmp     rdi, [rax+node_key]
        je      .done
        mov     rax, [rax+next_node]
        cmp     rax, NULL
        jne     .more
.done:
        leave
        ret

        
;   insert ( key, value )   if key already exists - value updated
hashTable_insert:
.key    equ     0
.index  equ     8
.value  equ     16
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     [rsp+.key], rdi
        mov     [rsp+.value], rsi
        call    hashTable_find
        cmp     rax, NULL
        jne     .found
        mov     rdi, [rsp+.key]
        call    hash
        mov     [rsp+.index], rax
        mov     rdi, node_size
        call    malloc wrt ..plt
        lea     rdx, [rel table]
        mov     r9, [rsp+.index]
        mov     r8, [rdx+r9*QWORD_SIZE]
        mov     [rax+next_node], r8
        mov     r8, [rsp+.key]
        mov     [rax+node_key], r8
        mov     [rdx+r9*QWORD_SIZE], rax
.found:
        mov     r8, [rsp+.value]
        mov     [rax+node_value], r8
        leave
        ret
 
 
 
;       print ( )
hashTable_print:
        push    rbp
        mov     rbp, rsp
        push    r12 
        push    r13
        xor     r12, r12
.more_table:
        lea     rdx, [rel table]
        mov     r13, [rdx+r12*QWORD_SIZE]
        cmp     r13, NULL
        je      .empty
        segment .data
.print1 db      "list %3d : ", 0x09, 0
        segment .text
        lea     rdi, [rel .print1]
        mov     rsi, r12
        call    printf wrt ..plt
.more_list:
        segment .data
.print2 db  "(%ld : %ld) ", 0
        segment .text
        lea     rdi, [rel .print2]
        mov     rsi, [r13+node_key]
        mov     rdx, [r13+node_value]
        call    printf wrt ..plt
        mov     r13, [r13+next_node]
        cmp     qword r13, NULL
        jne     .more_list
        segment .data
.print3 db      0x0a, 0
        segment .text
        lea     rdi, [rel .print3]
        call    printf wrt ..plt
.empty:
        inc     r12
        cmp     r12, 256
        jl      .more_table
        pop     r13
        pop     r12
        leave
        ret

        
;   bool = hashTable_remove ( key )        
hashTable_remove:
.key    equ     0
.rax    equ     8
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     [rsp+.key], rdi
        call    hash
        lea     rdx, [rel table]
        mov     r9, rax
        xor     eax, eax
        lea     r8, [rdx+r9*QWORD_SIZE]
        mov     r9, [rdx+r9*QWORD_SIZE]
        mov     rdi, [rsp+.key]
        cmp     r9, NULL
        setne   al
        je      .done
.more:
        cmp     rdi, [r9+node_key]
        jne     .next
        sete    al
        mov     r10, [r9+next_node]
        mov     [r8], r10
        mov     rdi, r9
        mov     [rsp+.rax], rax
        call    free wrt ..plt 
        mov     rax, [rsp+.rax]
        jmp     .done
.next:
        mov     r8, r9
        mov     r9, [r9+next_node]
        lea     r8, [r8+next_node]
        cmp     r9, NULL
        jne     .more
.done:
        leave
        ret        
        
        
        
        
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        
 
