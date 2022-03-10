.orig x3000
;this stack lab computes the polish notation of a set of calls

			 	 LD     R4, Base
			 	 LD     R5, MAX
                 LD     R6, TOS
                 
                 LD     R1, OFFSET
                 
                 LD     R2, ADD_VAL_PTR
                 LD     R3, PUSH_VAL_PTR
;push_val(4) pushes the value 4 onto the stack [4]
    AND R0, R0, #0
    ADD R0, R0, #4
    JSRR    R3

;push_val(3) pushes the value 3 onto the stack [4,3]
    AND R0, R0, #0
    ADD R0, R0, #3
    JSRR    R3

;push_val(2) pushes the value 2 onto the stack [4,3,2]
    AND R0, R0, #0
    ADD R0, R0, #2
    JSRR    R3

;add_val() pop 3,2 and push the result of 3+2 onto the stack [4,5]
    JSRR    R2


;add_val() pop 4,5 and push the result of 4+5 onto the stack[9]
    JSRR    R2



;move the top value of the stack into r4
ADD R4, R6, #0


HALT


;;DATA
val             .FILL   #6
Base            .FILL   x4000
MAX             .FILL   x4004
TOS             .FILL   x4000
ADD_VAL_PTR     .FILL   x3800
PUSH_VAL_PTR    .FILL   x3400
OFFSET          .FILL   #-48
INVOFFSET       .FILL   #48

.end

;------------------------------------------------------------------------------------------
; Subroutine: push_val
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1). 
;		    If the stack was already full (TOS = MAX), the subroutine has printed an
;		    overflow error message and terminated.
; Return Value: R6 ← updated TOS
;------------------------------------------------------------------------------------------
.orig x3400
    st  r0, BACKUP_R0_3200
	st  R1, BACKUP_R1_3200
	st  R2, BACKUP_R2_3200
	st  R3, BACKUP_R3_3200
	st  R4, BACKUP_R4_3200
	st  R5, BACKUP_R5_3200
	    ;st  R6, BACKUP_R6_3200
    st  r7, BACKUP_R7_3200
    ;--------------------------------------------------------------------------------------
				;Imagine accidently overcomplicating and writing programs 3 times in a row i made another queue KMS
				;If MAX-TOS=0 skip, else
				 NOT    R1, R6 
				 ADD    R1, R1, #1
				 ADD    R1, R1, R5
				 BRz TOS_IS_MAX
				    ;Increment TOS
                    ADD R6, R6, #1
                    ;Store Value to TOP of STACK
                    STR R0, R6, #0
				 BR error_SKIP
				 TOS_IS_MAX
				    LEA R0, error_Message 
				    PUTS
				 error_SKIP
				
	;--------------------------------------------------------------------------------------- 
    ld  r0, BACKUP_R0_3200
	ld  R1, BACKUP_R1_3200
	ld  R2, BACKUP_R2_3200
	ld  R3, BACKUP_R3_3200
	ld  R4, BACKUP_R4_3200
	ld  R5, BACKUP_R5_3200
	    ;ld  R6, BACKUP_R6_3200
    ld  r7, BACKUP_R7_3200
ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_PUSH local data

BACKUP_R0_3200 .BLKW #1 
BACKUP_R1_3200 .BLKW #1
BACKUP_R2_3200 .BLKW #1
BACKUP_R3_3200 .BLKW #1
BACKUP_R4_3200 .BLKW #1
BACKUP_R5_3200 .BLKW #1
    ;BACKUP_R6_3200 .BLKW #1
BACKUP_R7_3200 .BLKW #1 
error_Message   .STRINGZ    "--------------------------------------\n error: subroutine_PUSH_has_OVERFLOW\n--------------------------------------\n"

;===============================================================================================
.end




;------------------------------------------------------------------------------------------
; Subroutine: add_val
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		    added them together, and pushed the resulting value back
;		    onto the stack.
; Return Value: R6 ← updated TOS address
;------------------------------------------------------------------------------------------

.orig x3800
    st  r0, BACKUP_R0_3500
	st  R1, BACKUP_R1_3500
	st  R2, BACKUP_R2_3500
	st  R3, BACKUP_R3_3500
	st  R4, BACKUP_R4_3500
	st  R5, BACKUP_R5_3500
	    ;st  R6, BACKUP_R6_3500
    st  r7, BACKUP_R7_3500
    ;----------------------------------------------------------------------------------------------
    LD  R3, SUB_POP_RPN
    ;Pop 1
    JSRR    R3
    ;Clear and Transfer
    AND R1, R1, #0
    ADD R1, R1, R0
    ;Pop 2
    JSRR    R3
    ;Add to R0
    ADD R0, R1, R0
    ;Push
    LD  R3, SUB_Push_RPN
    JSRR    R3
    
    ;----------------------------------------------------------------------------------------------
    ld  r0, BACKUP_R0_3500
	ld  R1, BACKUP_R1_3500
	ld  R2, BACKUP_R2_3500
	ld  R3, BACKUP_R3_3500
	ld  R4, BACKUP_R4_3500
	ld  R5, BACKUP_R5_3500
	    ;ld  R6, BACKUP_R6_3500
    ld  r7, BACKUP_R7_3500
ret
;-----------------------------------------------------------------------------------------------
; SUB_RPN_ADDITION local data
BACKUP_R0_3500  .BLKW   #1
BACKUP_R1_3500  .BLKW   #1
BACKUP_R2_3500  .BLKW   #1
BACKUP_R3_3500  .BLKW   #1
BACKUP_R4_3500  .BLKW   #1
BACKUP_R5_3500  .BLKW   #1
    ;BACKUP_R6_3500 .BLKW #1
BACKUP_R7_3500  .BLKW   #1 
SUB_PUSH_RPN    .FILL   x3400
SUB_POP_RPN     .FILL   x3900
;===============================================================================================
.end

;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available                      
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;		    If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Value: R0 ← value popped off the stack
;		   R6 ← updated TOS
;------------------------------------------------------------------------------------------
.orig x3900
        st  r0, BACKUP_R0_3400
	st  R1, BACKUP_R1_3400
	st  R2, BACKUP_R2_3400
	st  R3, BACKUP_R3_3400
	st  R4, BACKUP_R4_3400
	st  R5, BACKUP_R5_3400
	    ;st  R6, BACKUP_R6_3400
    st  r7, BACKUP_R7_3400
	;--------------------------------------------------------------------------------------
				;If Base-TOS=0 skip, else
				 NOT    R1, R6 
				 ADD    R1, R1, #1
				 ADD    R1, R1, R4
				 BRz TOS_IS_EMPTY
                    ;Gurantee Nothing on R1
                    AND R1, R1, #0
                    AND R0, R0, #0
                    ;Store Value from R6
                    LDR R0, R6, #0 
                    ;Store Nothing to TOP of STACK
                    STR R1, R6, #0
				    ;Decrement TOS
                    ADD R6, R6, #-1
				 BR error_SKIP_2
				 TOS_IS_EMPTY
				    LEA R0, error_Message_Low 
				    PUTS
				    ;clear error message
				    ld  r0, BACKUP_R0_3400
				 error_SKIP_2
				
	;--------------------------------------------------------------------------------------- 	 
        ;ld  r0, BACKUP_R0_3400
	ld  R1, BACKUP_R1_3400
	ld  R2, BACKUP_R2_3400
	ld  R3, BACKUP_R3_3400
	ld  R4, BACKUP_R4_3400
	ld  R5, BACKUP_R5_3400
	    ;ld  R6, BACKUP_R6_3400
    ld  r7, BACKUP_R7_3400
ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_POP local data

BACKUP_R0_3400 .BLKW #1
BACKUP_R1_3400 .BLKW #1
BACKUP_R2_3400 .BLKW #1
BACKUP_R3_3400 .BLKW #1
BACKUP_R4_3400 .BLKW #1
BACKUP_R5_3400 .BLKW #1
    ;BACKUP_R6_3400 .BLKW #1
BACKUP_R7_3400 .BLKW #1 
error_Message_Low   .STRINGZ    "--------------------------------------\n error: subroutine_PUSH_has_UNDERFLOW\n--------------------------------------\n"

;===============================================================================================
.end



;.orig x4000 ;;data you might need

;.end


