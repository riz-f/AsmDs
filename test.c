#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

void* dynamicArray_create(long);
void dynamicArray_fill(void*, long);
void dynamicArray_print(void*, long);
long dynamicArray_min(void*, long);
long dynamicArray_get_value_at(void*, long);         
void dynamicArray_put_value_at(void*, long, long);         
void* dynamicArray_insert_at(void*, long, long, long*, long*);

void array_test()
{
    printf("\n\n\t\tDynamic array test\n\n\n");

    static void* arr_head = NULL;
    static long sz = -1, capacity;
    if (sz==-1)
    {
        printf("\nArray size: \n");
        scanf("%ld", &sz);
        capacity = sz;
        arr_head = dynamicArray_create(capacity);
    }
        
    long ch, val, ind;
    
    for (;1;)
    {
        printf("\n\nArray: \n");
        dynamicArray_print(arr_head, sz);
        printf("\n0:Fill\n1:Find min\n2:Get capacity\n3:Get size\n4:Get value at index\n5:Put value at index\n6:Insert value at index\n7:Back\n");
        scanf("%ld", &ch);
        printf("\n");
        switch(ch)
        {
            case 0: 
                dynamicArray_fill(arr_head, sz);
            break;
            
            case 1:
                val = dynamicArray_min(arr_head, sz);
                printf("Min value: %ld", val);
            break;
            
            case 2:
                printf("Array capacity: %ld", capacity);
            break;
            
                        
            case 3:
                printf("Array size: %ld", sz);
            break;
            
            case 4:
                printf("Index: ");
                scanf("%ld", &ind);
                if (ind < sz)
                {
                    val =  dynamicArray_get_value_at(arr_head, ind);         
                    printf("Value at index %ld: %ld", ind, val);
                }
                else
                    printf("Wrong ind");
            break;
            
            case 5:
                printf("Index: ");
                scanf("%ld", &ind);
                printf("Value: ");
                scanf("%ld", &val);
                if (ind < sz)
                {
                    dynamicArray_put_value_at(arr_head, ind, val);         
                    printf("Value put");
                }
                else
                    printf("Wrong ind");
            break;
            
            
            case 6:
                printf("Index: ");
                scanf("%ld", &ind);
                printf("Value: ");
                scanf("%ld", &val);
                if (ind < sz)
                {
                    arr_head = dynamicArray_insert_at(arr_head, ind, val, &sz, &capacity);
                    printf("Value inserted");
                }
                else
                    printf("Wrong ind");
            break;
            
            
            case 7:
                return;
            break;
        }
    } 
}


void* linkedList_initialize_list (long);
void* linkedList_insert (long, long, void*);
long linkedList_get_size(void*);
bool linkedList_empty(void*);
void* linkedList_print (void*);
long linkedList_value_at(void*, long);
void linkedList_push_front(void*, long);
long linkedList_pop_front(void*);
void linkedList_push_back(void*, long);
long linkedList_pop_back(void*);
long linkedList_erase(void*, long);
void linkedList_reverse(void*);

void linked_list_test()
{
    printf("\n\n\t\tLinked list test\n\n\n");

    static void* list_head = NULL;
    if (!list_head)
        list_head = linkedList_initialize_list(5);
    
    long ch, val, ind, sz;
    bool isEmpty;

    for (;1;)
    {
        printf("\nLinked list: ");
        linkedList_print(list_head);
        printf("\n0:Insert\n1:Print size\n2:Check if empty\n3:Get value at index\n4:Push value front\n5:Pop value front\n6:Push value back\n7:Pop value back\n8:Erase at index\n9:Reverse\n10:Back\n");
        scanf("%ld", &ch);
        printf("\n");
        switch(ch)
        {
            case 0: 
                printf("Value: ");
                scanf("%ld", &val);
                printf("Index: ");
                scanf("%ld", &ind);
                linkedList_insert(ind, val, list_head); 
            break;
            
            
            case 1:
                sz = linkedList_get_size(list_head);
                printf("Linked list size: %ld\n", sz);
            break;
            
            case 2:
                isEmpty = linkedList_empty(list_head);
                printf(isEmpty ? "true" : "false");
            break;        
                
            case 3:
                printf("Index: ");
                scanf("%ld", &ind);
                val = linkedList_value_at(list_head, ind);
                printf("Value at index %ld: %ld\n", ind, val);
            break;
            
            case 4:
                printf("Value: ");
                scanf("%ld", &val);
                linkedList_push_front(list_head, val);
            break;
            
            case 5:
                val = linkedList_pop_front(list_head);
                printf("Value popped: %ld\n", val);
            break;
            
            case 6:
                printf("Value: ");
                scanf("%ld", &val);
                linkedList_push_back(list_head, val);
            break;
            
            case 7:
                val = linkedList_pop_back(list_head);
                printf("Value popped: %ld\n", val);
            break;
            
            case 8:
                printf("Index: ");
                scanf("%ld", &ind);
                val = linkedList_erase(list_head, ind);
                printf("Value erased at index %ld: %ld\n", ind, val);
            break;
            
            case 9:
                linkedList_reverse(list_head);
            break;
            
            case 10:
                return;
            break;
        }
    } 
}

void queueLinkedList_enqueue(void*, long, void*);
long queueLinkedList_dequeue(void*, void*);
void queueLinkedList_print(void*);

void queue_linked_list()
{
    printf("\n\n\t\tQueue using linked list test\n\n\n");

    static void* list_head = NULL;
    static void* list_tail = NULL;
    
    long ch, val;
    
    for (;1;)
    {
        printf("\nQueue: ");
        queueLinkedList_print(&list_head);
        printf("\n0:Enqueue\n1:Dequeue\n2:Back\n");
        scanf("%ld", &ch);
        printf("\n");
        switch(ch)
        {
            case 0: 
                printf("Value: ");
                scanf("%ld", &val);
                queueLinkedList_enqueue(&list_tail, val, &list_head); 
            break;
            
            case 1:
                if (list_head)
                {
                    val = queueLinkedList_dequeue(&list_tail, &list_head);
                    printf("Value dequeued: %ld\n", val);
                }
            break;
            
            case 2:
                return;
            break;
        }
    } 
}

void queueArray_enqueue(void*, long*, long*, long, long);
long queueArray_dequeue(void*, long*, long*, long);
void queueArray_print(void*, long, long, long);

void queue_array()
{
    printf("\n\n\t\tQueue using fixed size array test\n\n\n");
    
    static void* array = NULL;
    static long sz;
    static long head = -1, rear = -1;
    static bool inited = false;
    long ch, val;
    
    if (head==-1 && !inited)
    {
        printf("Queue size: ");
        scanf("%ld", &sz);
        array = malloc(sz*sizeof(long));
        inited = true;
    }
        
    for (;1;)
    {
        printf("\nQueue: \n");
        if (head!=-1) queueArray_print(array, head, rear, sz);
        printf("\n0:Enqueue\n1:Dequeue\n2:Back\n");
        scanf("%ld", &ch);
        printf("\n");
        switch(ch)
        {
            case 0: 
                printf("Value: ");
                scanf("%ld", &val);
                queueArray_enqueue(array, &head, &rear, sz, val); // array, head, rear, size
            break;
            
            case 1:
                if (head!= -1) 
                {
                    val = queueArray_dequeue(array, &head, &rear, sz);
                    printf("Value dequeued: %ld\n", val);
                }
            break;
              
            case 2:
                return;
            break;
        }
    } 
        
}

void hashTable_insert ( long, long );
void hashTable_print ( );
bool hashTable_remove ( long );

void hash_table()
{
    
    struct node {
        long node_key, node_value, next_node;
    };
    
    struct node* hashTable_find ( long );
    
    struct node *s_p;
    
    printf("\n\n\t\tHash table test\n\n\n");

    long ch, val, key;
    bool f;
    
    for (;1;)
    {
        printf("\nHash table: \n");
        hashTable_print();
        printf("\n0:Insert\n1:Exists\n2:Get by key\n3:Remove\n4:Back\n");
        scanf("%ld", &ch);
        printf("\n");
        switch(ch)
        {
            case 0: 
                printf("Key: ");
                scanf("%ld", &key);
                printf("Value: ");
                scanf("%ld", &val);
                hashTable_insert(key, val); 
            break;
            
            case 1:
                printf("Key: ");
                scanf("%ld", &key);
                s_p = hashTable_find(key);
                if (s_p!=NULL)
                    printf("Key exists");
                else
                    printf("Key does not exists");
            break;
            
            case 2:
                printf("Key: ");
                scanf("%ld", &key);
                s_p = hashTable_find(key);
                if (s_p!=NULL)
                {
                    
                    printf("Key: %ld Value: %ld", s_p->node_key, s_p->node_value);
                }
                else
                    printf("Key does not exists");
            break;
                
            case 3:
                printf("Key: ");
                scanf("%ld", &key);
                f = hashTable_remove(key);
                if (f)
                    printf("Removed\n");
                else
                    printf("Not removed\n");
            break;   
            
            case 4:
                return;
            break;
        }
    } 
    
}

int main()
{
    long ch;
    for (;1;)
    {
        printf("\n\nChoose data structure to test: \n");
        printf("\n0:Array\n1:Linked list\n2:Queue using linked list\n3:Queue using array\n4:Hash table\n5:Exit\n");
        scanf("%ld", &ch);
        printf("\n");
        switch(ch)
        {
            case 0: 
                array_test();
            break;
            
            case 1:
                linked_list_test();
            break;
            
            case 2:
                queue_linked_list();
            break;
            
                        
            case 3:
                queue_array();
            break;
            
            case 4:
                hash_table();
            break;
            
            case 5:
                return 0;
            break;
        }
    }
    
    return 0;
}
