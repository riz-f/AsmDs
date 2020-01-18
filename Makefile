SHELL = /bin/sh

MKDIR_P = mkdir -p
DIR_LIB = lib
DIR_OUT = out

RM_LOG = rm -r -f ${DIR_LIB}/* ${DIR_OUT}/*

.PHONY: directories

all : directories test


directories : ${DIR_LIB} ${DIR_OUT}

${DIR_LIB} :
	${MKDIR_P} ${DIR_LIB}

${DIR_OUT} :
	${MKDIR_P} ${DIR_OUT}

${DIR_OUT}/dynamicArray.o : dynamicArray.asm
	yasm -f elf64 -g dwarf2 -o ${DIR_OUT}/dynamicArray.o dynamicArray.asm

${DIR_LIB}/libdynamicArray.so : ${DIR_OUT}/dynamicArray.o
	gcc -shared -o ${DIR_LIB}/libdynamicArray.so ${DIR_OUT}/dynamicArray.o

${DIR_OUT}/linkedList.o : linkedList.asm
	yasm -f elf64 -g dwarf2 -o ${DIR_OUT}/linkedList.o linkedList.asm

${DIR_LIB}/liblinkedList.so : ${DIR_OUT}/linkedList.o
	gcc -shared -o ${DIR_LIB}/liblinkedList.so ${DIR_OUT}/linkedList.o
	
${DIR_OUT}/queueLinkedList.o : queueLinkedList.asm
	yasm -f elf64 -g dwarf2 -o ${DIR_OUT}/queueLinkedList.o queueLinkedList.asm

${DIR_LIB}/libqueueLinkedList.so : ${DIR_OUT}/queueLinkedList.o
	gcc -shared -o ${DIR_LIB}/libqueueLinkedList.so ${DIR_OUT}/queueLinkedList.o

${DIR_OUT}/queueArray.o : queueArray.asm
	yasm -f elf64 -g dwarf2 -o ${DIR_OUT}/queueArray.o queueArray.asm

${DIR_LIB}/libqueueArray.so : ${DIR_OUT}/queueArray.o
	gcc -shared -o ${DIR_LIB}/libqueueArray.so ${DIR_OUT}/queueArray.o

${DIR_OUT}/hashTable.o : hashTable.asm
	yasm -f elf64 -g dwarf2 -o ${DIR_OUT}/hashTable.o hashTable.asm

${DIR_LIB}/libhashTable.so : ${DIR_OUT}/hashTable.o
	gcc -shared -o ${DIR_LIB}/libhashTable.so ${DIR_OUT}/hashTable.o	
	
test : 	${DIR_LIB}/libdynamicArray.so ${DIR_LIB}/liblinkedList.so ${DIR_LIB}/libqueueLinkedList.so ${DIR_LIB}/libqueueArray.so ${DIR_LIB}/libhashTable.so test.c
	gcc -g -L${DIR_LIB}/ -Wl,-rpath=${DIR_LIB}/ -Wall -o test test.c -ldynamicArray -llinkedList -lqueueLinkedList -lqueueArray -lhashTable



	
	
	
	
	

clean :
	rm -f test ; rm -r -f ${DIR_LIB} ${DIR_OUT}
