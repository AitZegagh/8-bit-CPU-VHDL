

        NOP
        LDI   1          
        ADDI  2          
LOOP: OUT              
        SUBI  1         
        JZ    END        
        JMP   LOOP   
END:    OUT              
        HLT