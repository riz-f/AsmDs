        segment .text
global linkedList_initialize_list
global linkedList_insert
global linkedList_print
global linkedList_get_size
global linkedList_empty
global linkedList_value_at
global linkedList_push_front
global linkedList_pop_front
global linkedList_push_back
global linkedList_pop_back
global linkedList_erase
global linkedList_reverse
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

            
; head = initialize_list ( value )
linkedList_initialize_list:
.value  equ     0
.rax    equ     8
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     [rsp+.value], rdi      
        mov     rdi, node_size
        call    malloc wrt ..plt
        mov     r8, qword NULL
        mov     [rax+next_node], r8
        mov     rdi, [rsp+.value]      
        mov     [rax+node_value], rdi
        mov     [rsp+.rax], rax      
        mov     rdi, NODE_ADDR_SIZE      
        call    malloc wrt ..plt
        mov     r8, [rsp+.rax]
        mov     [rax], r8
        leave
        ret
        
        
; &list[index] = insert ( index, value, head ) ; inserts item before index. head and index must be legit
linkedList_insert:
.index  equ     0
.value  equ     8
.head   equ     16
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     [rsp+.index], rdi
        mov     [rsp+.value], rsi   
        mov     [rsp+.head], rdx   
        mov     rdi, node_size
        call    malloc wrt ..plt
        mov     rdi, [rsp+.index]
        mov     rsi, [rsp+.value]
        mov     [rax+node_value], rsi
        mov     r8, [rsp+.head]     
        mov     r9, [r8]       
        cmp     rdi, 0      ; Is node index before which to insert 0?
        jne     .more   
        mov     [r8], rax 
        jmp     .done
.more: 
        dec rdi   
        mov     r8, r9
        mov     r9, [r9+next_node]
        cmp     rdi, 0
        jne     .more 
        mov     [r8+next_node], rax 
.done: 
        mov     [rax+next_node], r9              
        leave
        ret


; size = get_size( head ) head must not be NULL       
linkedList_get_size:
        xor     eax, eax 
        cmp     qword [rdi], NULL   ; this kind of cmp doesn't assemble without qword
        je      .end
        mov     rdi, [rdi]
        inc     rax
        cmp     qword [rdi+next_node], NULL
        je      .end
.cmp:
        mov     rdi, [rdi+next_node]
        inc     rax
        cmp     qword [rdi+next_node], NULL
        jne     .cmp
.end:
        ret        

; bool = empty( head )
linkedList_empty:
        cmp     rdi, NULL
        je      .end
        cmp     qword [rdi], NULL
.end    sete    al
        ret
        
        
; print( head )
linkedList_print:
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

    
; value = value_at( head, index ) head and index must be valid
linkedList_value_at:
        mov     rdi, [rdi]
        xor     ecx, ecx
        cmp     rcx, rsi
        je      .end
.count:        
        mov     rdi, [rdi+next_node]
        inc     rcx
        cmp     rcx, rsi
        jl      .count
.end:
        mov     rax, [rdi+node_value]
        ret
        
        
; push_front( head, value )
linkedList_push_front:
.head   equ     0
.value  equ     8
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     [rsp+.head], rdi
        mov     [rsp+.value], rsi     
        mov     rdi, node_size
        call    malloc wrt ..plt
        mov     rsi, [rsp+.value]
        mov     [rax+node_value], rsi
        mov     rdx, [rsp+.head]
        mov     rcx, [rdx]
        mov     [rax+next_node], rcx
        mov     [rdx], rax
        xor     eax, eax
        leave
        ret
        
        
; value = pop_front( head )   
linkedList_pop_front:
.rbx    equ     0
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     [rsp+.rbx], rbx
        mov     rsi, [rdi]
        mov     rdx, [rsi+next_node]
        mov     [rdi], rdx
        mov     rdi, rsi
        mov     rbx, [rsi+node_value]
        call    free wrt ..plt
        mov     rax, rbx
        mov     rbx, [rsp+.rbx]
        leave
        ret
        
        
; push_back( head, value )         
linkedList_push_back:
.value  equ     0  
.rbx    equ     8
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     [rsp+.rbx], rbx
        mov     [rsp+.value], rsi
        mov     rbx, rdi
        mov     rdi, node_size
        call    malloc wrt ..plt
        mov     rdi, [rsp+.value]
        mov     [rax+node_value], rdi
        mov     qword [rax+next_node], dword NULL
        cmp     qword [rbx], NULL  
        je      .end
.more:
        mov     rbx, [rbx]
        add     rbx, next_node
        cmp     qword [rbx], NULL
        jne     .more
.end:
        mov     [rbx], rax 
        mov     rbx, [rsp+.rbx]
        leave
        ret
        
        
; value = pop_back( head )         
linkedList_pop_back:
.r12    equ     0
.value  equ     8
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        cmp     qword [rdi], NULL  
        je      .leave
        mov     [rsp+.r12], r12
        mov     r11, rdi
        mov     r12, [r11]
        cmp     qword [r12+next_node], NULL
        je      .last   
.more: 
        mov     r11, r12
        mov     r12, [r12+next_node]
        cmp     qword [r12+next_node], NULL
        jne     .more 
        mov     qword [r11+next_node], dword NULL
        jmp     .pop
.last:   
        mov     qword [r11], dword NULL
.pop:
        mov     rsi, [r12+node_value] 
        mov     [rsp+.value], rsi
        mov     rdi, r12
        call    free wrt ..plt
        mov     rax, [rsp+.value]
        mov     r12, [rsp+.r12]
.leave:
        leave
        ret      
    
    
; value = erase(head, index) 
linkedList_erase:
.value  equ     0
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        cmp     qword [rdi], NULL
        je      .leave
        mov     r8, rdi
        mov     r9, [rdi]
        cmp     qword [r9+next_node], NULL
        je      .last           
        cmp     rsi, 0
        je      .nlast
.more: 
        mov     r8, r9
        mov     r9, [r9+next_node]
        add     r8, next_node
        dec     rsi
        cmp     rsi, 0
        jne     .more 
.nlast:        
        mov     rdx, [r9+next_node]
        mov     qword [r8], rdx
        jmp     .pop
.last:   
        mov     qword [r8], dword NULL
.pop:
        mov     rsi, [r9+node_value] 
        mov     [rsp+.value], rsi
        mov     rdi, r9
        call    free wrt ..plt
        mov     rax, [rsp+.value]
.leave:        
        leave
        ret      
    
; reverse(head)
linkedList_reverse:
        cmp     qword [rdi], NULL
        je      .end
        mov     qword r8, dword NULL
        mov     r9, [rdi]
        mov     r10, [rdi]
        cmp     qword r10, NULL
        je      .end
.more:
        mov     r10, [r9+next_node]
        mov     [r9+next_node], r8
        mov     r8, r9
        mov     r9, r10
        cmp     r10, NULL
        jne     .more
        mov     [rdi], r8
.end:           
        ret


        
        
        
 
