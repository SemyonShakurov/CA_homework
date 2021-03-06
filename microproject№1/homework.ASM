format PE console

entry start

include 'win32a.inc'

section '.data' data readable writeable

        maxNumberLabel db 'Input max number (>= 3 & <= 65535): ', 0
        inputFormat db '%u', 0
        maxNumError db 'Max number is incorrect', 0xD, 0xA, 0
        maxNumberOutputFormat db 'Max number = %u', 0xD, 0xA, 0
        mallocError db 'Can not allocate memory', 0xD, 0xA, 0
        primesLabel db 'Primes numbers:', 0xD, 0xA, 0
        primeOutput db '%u', 0x9, 0
        startPrint db 0x9, 0
        crIf db 0xD, 0xA, 0

        maxNumber dd 0
        primesPointer dd 0

        NULL = 0

section '.code' code readable executable

        start:
                enter 0, 0

                ;���� ������������� �����
                call inputMaxNumber
                cmp edx, 0
                jne customExit
                mov [maxNumber], eax

                ;�������� ������ ��� ������� ������
                mov eax, [maxNumber]
                call allocateFlagsMemory
                cmp edx, 0
                jne customExit
                mov [primesPointer], eax

                ;������� ��������� �����
                mov eax, [primesPointer]
                mov ebx, [maxNumber]
                call findPrimes

                ;������� ������� �����
                mov eax, [primesPointer]
                mov ebx, [maxNumber]
                call output

                ;���������� ������ �� ������� ������
                mov eax, [primesPointer]
                call freeFlagsMemory

                ;���������� ���������
                call Exit
;-------------------------------------------------
        ; ���������: EAX - ��������� �� ������ ������, EBX - ������������ �����
        output:
                enter 12, 1
                mov [ebp-4], eax
                mov [ebp-8], ebx

                push primesLabel
                call [printf]
                add esp, 4

                push startPrint
                call[printf]
                add esp, 4

                cld
                mov esi, [ebp-4]
                mov edx, esi
                add edx, [ebp-8]
                inc edx

                mov [ebp-12], edx
                mov ecx, 0
        ;���� ��� ������
        outputCicle:
                lodsb
                cmp al, 0
                jne print
                jmp isFinish

        print:
                cmp ecx, 1
                je isFinish
                push esi
                push ecx
                push primeOutput
                call [printf]
                add esp, 4

                pop ecx
                pop esi
                mov edx, [ebp-12]

        isFinish:
                inc ecx
                cmp esi, edx
                jb outputCicle

                push crIf
                call [printf]
                add esp, 4

                leave
                ret
;--------------------------------------------------
        ;���������: EAX - ��������� �� ������ ������, EBX - ������������ �����
        findPrimes:
                enter 8, 1

                mov [ebp-4], eax
                add eax, ebx
                inc eax
                mov [ebp-8], eax

                ;����������� ��������� �����
                cld
                ;p=2
                mov edx, 2
                ;��������� � = 2
                mov ecx, 2
       Cicle:
                ;x = c*p
                mov eax, edx
                push edx
                mul ecx
                pop edx

                cmp eax, ebx
                jbe strikeNumber
                jmp increase

       strikeNumber:
                mov edi, [ebp-4]
                add edi, eax
                mov byte [edi], 0
                ;c++
                inc ecx
                jmp Cicle

       increase:
                mov esi, [ebp-4]
                add esi, edx
                inc esi

                mov ecx, edx
                inc ecx

        checkNum:
                mov eax, ecx
                mul eax
                cmp eax, ebx
                ja returnPrimes

                lodsb
                inc ecx
                cmp al, 0
                jne newFound
                jmp checkNum

        newFound:
                mov edx, ecx
                dec edx
                mov ecx, 2
                jmp Cicle

        returnPrimes:
                leave
                ret

;--------------------------------------------------
        ; ��������: EAX - ��������� �� ������
        freeFlagsMemory:
                enter 0, 1

                push eax
                call [free]
                add esp, 4

                leave
                ret
;--------------------------------------------------
        ; ��������: EAX - ������������ �����
        ; ���������: EAX - ��������� �� ������
        allocateFlagsMemory:
                enter 8, 1
                ;�������� eax+1 ����
                inc eax
                mov [ebp-4], eax

                push eax
                call [malloc]
                add esp, 4

                ;��������
                cmp eax, 0
                je fail
                mov [ebp-8], eax

                ;�������������
                mov byte [eax], 0

                cld
                mov edi, eax
                inc edi
                mov edx, [ebp-4]
                add edx, eax

                mov al, 1

       writeTrue:
                stosb
                cmp edi, edx
                jb writeTrue

                mov eax, [ebp-8]
                jmp success

        fail:
                mov edx, mallocError
                jmp return

        success:
                mov edx, 0

        return:
                leave
                ret

;--------------------------------------------------
        ; ���������: EAX - ������������ �����
        inputMaxNumber:

                enter 4, 1

                push maxNumberLabel
                call [printf]
                add esp, 4

                mov eax, ebp
                sub eax, 4

                push eax
                push inputFormat
                call [scanf]
                add esp, 8

                mov eax, [ebp - 4]

                ;��������
                cmp eax, 3
                jb numberError
                cmp eax, 65535
                ja numberError
                jmp successInput

        ;�����
        numberError:
                mov edx, maxNumError
                jmp returnInput

        successInput:
                push eax
                push maxNumberOutputFormat
                call [printf]
                add esp, 4
                pop eax
                mov edx, 0

        returnInput:
                leave
                ret
;---------------------------------------------------------
        ;����� ��� ������
        customExit:
                push edx
                call [printf]

        ;�����
        Exit:
                call [getch]
                push NULL
                call [ExitProcess]

;----------------------------------------------------------
section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf',\
               malloc, 'malloc',\
               free, 'free'