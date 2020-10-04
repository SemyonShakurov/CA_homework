;Вариант 9
;Разработать программу, которая вводит одномерный массив A[N], формирует из элементов
;массива А новый массив B из нечётных элементов A и выводит его.

format PE console

entry start

include 'win32a.inc'

section '.data' data readable writeable

        formatElem db '%d', 0
        inputElem db '%d: ', 0
        formatOut db '%d ', 0

        inputNStr db 'Enter the number of elements in the array: ', 0
        incorrectStr db 'Incorrect data entered', 0
        firstArrStr db 'Input array:',10 , 0
        secondArrStr db 10, 'Array with odd elements:', 10, 0

        len dd 0
        newLen dd 0
        vector rd 100
        newVector rd 100
        tmpStack dd ?
        tmp dd ?
        i dd ?

        NULL = 0

section '.code' code readable executable

        start:
                call InputArray

                call OddElements

                push firstArrStr
                call [printf]

                call OutputOldArr

                push secondArrStr
                call [printf]

                call OutputNewArr

                call Exit
;---------------------------------------------------------------
        InputArray:
                push inputNStr
                call [printf]
                add esp, 4

                push len
                push formatElem
                call [scanf]
                add esp, 8

                mov eax, [len]
                cmp eax, 0
                jle InputArray
                cmp eax, 100
                jge InputArray

       Vector:
                xor ecx, ecx
                mov ebx, vector
       ArrLoop:
                mov [tmp], ebx
                cmp ecx, [len]
                jge inputEnd

                mov [i], ecx
                push ecx
                push inputElem
                call [printf]
                add esp, 8

                push ebx
                push formatElem
                call [scanf]
                add esp, 8

                mov ecx, [i]
                inc ecx
                mov ebx, [tmp]
                add ebx, 4
                jmp ArrLoop

        inputEnd:
                ret
;---------------------------------------------------------------
        OddElements:
                xor ecx, ecx
                xor eax, eax
                mov ebx, vector
                mov edx, newVector
        OddArrLoop:
                cmp ecx, [len]
                je  EndLoop

                mov [i], eax
                mov eax, [ebx]
                and eax, 1b
                cmp eax, 1
                je AddElem
                mov eax, [i]
        Continue:

                inc ecx
                add ebx, 4
                jmp OddArrLoop

        AddElem:
                mov eax, [i]
                inc eax
                mov [i], eax
                mov eax, [ebx]
                mov [edx], eax
                mov eax, [i]
                add edx, 4
                jmp Continue

        EndLoop:
                mov [newLen], eax
                ret
;----------------------------------------------------------------------
        OutputOldArr:
                mov [tmpStack], esp
                xor ecx, ecx
                mov ebx, vector
        putVecLoop:
                mov [tmp], ebx
                cmp ecx, [len]
                je endOutputVector
                mov [i], ecx

                push dword [ebx]
                push formatOut
                call [printf]

                mov ecx, [i]
                inc ecx
                mov ebx, [tmp]
                add ebx, 4
                jmp putVecLoop
        endOutputVector:
                mov esp, [tmpStack]
                ret
;----------------------------------------------------------------------
        OutputNewArr:
                mov [tmpStack], esp
                xor eax, eax
                mov edx, newVector
        putVectorLoop:
                mov [tmp], edx
                cmp eax, [newLen]
                je EndOutput
                mov [i], eax

                push dword [edx]
                push formatOut
                call [printf]

                mov eax, [i]
                inc eax
                mov edx, [tmp]
                add edx, 4
                jmp putVectorLoop
        EndOutput:
                mov esp, [tmpStack]
                call [getch]

                push NULL
                call [ExitProcess]
;----------------------------------------------------------------------
        Exit:
                call [getch]

                push NULL
                call [ExitProcess]
;------------------------------------------------------------------
section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'