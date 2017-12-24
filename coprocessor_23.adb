with Ada.Assertions; use Ada.Assertions;

Package body Coprocessor_23 is

   Input_File, Trace_File : File_Type;
   Text : Unbounded_String;
   Start_At, First : Positive;
   Last : Natural;
   Op_Set : constant Character_Set := To_Set ("setsubmuljnz");
   Reg_Range : constant Character_Range := ('a', 'h');
   Reg_Set : constant Character_Set := To_Set (Reg_Range);
   Int_Set : constant Character_set := To_Set ("-0123456789");

   type Op_Codes is (set, sub, mul, jnz);
   Mul_Count : Natural := 0;

   type instructions is record
      Op_Code : Op_Codes;
      Dst_Imm : Boolean; -- selects between destination and immediate
      Destination : Registers := Registers'Last;
      Dst_Num : Long_Long_Integer := 0;
      Src_Imm : Boolean; -- selects between source and immediate
      Source : Registers := Registers'Last;
      Src_Num : Long_Long_Integer := 0;
   end record;

   subtype Addresses is Long_Long_Integer range 0 .. 100;
   Type Register_Files is array (Registers) of Long_Long_Integer;
   type Program_Stores is array (Addresses) of Instructions;

   Register_File : Register_Files := (others => 0);
   Program_Store : Program_Stores;
   Last_Instruction : Addresses := 0;

   procedure Process_file is
      Load_At : Addresses := 0;

      function Get_Op_Code return Op_Codes is

         Op_String : String (1 ..3);

      begin -- Get_Op_Code
         Find_Token (Text, Op_Set, Start_At, Inside, First, Last);
         Op_String := Slice (Text, First, Last);
         Start_At := Last + 1;
         if Op_String = "set" then
            return set;
         elsif Op_String = "sub" then
            return sub;
         elsif Op_String = "mul" then
            return mul;
         elsif Op_String = "jnz" then
            return jnz;
         else
            Put_Line (Trace_File, "Unknown Op Code: " & Op_String);
            assert (False);
            return jnz; -- this is unnreachable code
         end if;
      end Get_Op_Code;

      function Get_Register return Registers is

      begin -- Get_Register
         Find_Token (Text, Reg_Set, Start_At, Inside, First, Last);
         Start_at := Last + 1;
         return Element (Text, First);
      end Get_Register;

   begin -- Process_File
      while not End_Of_File (Input_File) loop
         Text := To_Unbounded_String (Get_Line (Input_File));
         Put_Line (Trace_File, To_String (Text) & " -> ");
         Flush;
         Start_At := 1;
         Program_Store (Load_At).Op_Code := Get_Op_Code;
         Find_Token (Text, Int_Set, Start_At, Inside, First, Last);
         Program_Store (Load_At).Dst_Imm := First = 5;
         if Program_Store (Load_At).Dst_Imm then
            Program_Store (Load_At).Dst_Num :=
              Long_Long_Integer'Value (Slice (Text, First, Last));
            Start_At := Last + 1;
         else
            Program_Store (Load_At).Destination := Get_Register;
         end if;
         Find_Token (Text, Int_Set, Start_At, Inside, First, Last);
         Program_Store (Load_At).Src_Imm := Last > 0;
         if Program_Store (Load_At).Src_Imm then
            Program_Store (Load_At).Src_Num :=
              Long_Long_Integer'Value (Slice (Text, First, Last));
         else
            Program_Store (Load_At).Source := Get_Register;
         end if;
         Put_Line (Trace_File, Addresses'Image (Load_At) & ": "
           & Op_Codes'Image (Program_Store (Load_At).Op_Code) & " " &
           Boolean'Image (Program_Store (Load_At).Dst_Imm) & " " &
           Program_Store (Load_At).Destination & " " &
           Long_Long_Integer'Image (Program_Store (Load_At).Dst_Num) & " " &
           Boolean'Image (Program_Store (Load_At).Src_Imm) & " " &
           Program_Store (Load_At).Source & " " &
           Long_Long_Integer'Image (Program_Store (Load_At).Src_Num));
         Flush (Trace_file);
         Last_Instruction := Load_At;
         Load_At := Load_At + 1;
      end loop; -- process one Instruction
   end Process_File;

   procedure Execute is

      Instruction_Pointer : Long_Long_Integer := 0;

      procedure Put_State is

      begin -- Put_State
         Put (Trace_File, Long_Long_Integer'Image (Instruction_Pointer) &
                ": " );
         Put (Trace_File, Op_Codes'Image (Program_Store (Instruction_Pointer).
                Op_Code) & " ");
         if Program_Store (Instruction_Pointer).Dst_Imm then
            Put (Trace_File, Long_Long_Integer'Image
                 (Program_Store (Instruction_Pointer).Dst_Num) & " ");
         else
            Put (Trace_File, Program_Store (Instruction_Pointer).Destination
                 & " ");
         end if;
         if Program_Store (Instruction_Pointer).Src_Imm then
            Put_Line (Trace_File, Long_Long_Integer'Image
                      (Program_Store (Instruction_Pointer).Src_Num));
         else
            Put_Line (Trace_File, Program_Store (Instruction_Pointer).Source
                      & "");
         end if;
         for I in Registers loop
            Put (Trace_File, " (" & I & ")" & Long_Long_Integer'Image
                 (Register_File (I)));
         end loop;
         New_Line (Trace_File);
         Flush (Trace_File);
      end Put_State;

   begin -- Execute
      while (Instruction_Pointer >= 0) and
        (Instruction_Pointer <= Last_Instruction) loop
         Put_State;
         case Program_Store (Instruction_Pointer).Op_Code is
            when set =>
               if Program_Store (Instruction_Pointer).Src_Imm then
                  Register_File
                    (Program_Store (Instruction_Pointer).Destination) :=
                      Program_Store (Instruction_Pointer).Src_Num;
               else
                  Register_File
                    (Program_Store (Instruction_Pointer).Destination) :=
                      Register_File
                        (Program_Store (Instruction_Pointer).Source);
               end if; -- Src_Imm
               Instruction_Pointer := Instruction_Pointer + 1;
            when sub =>
               if Program_Store (Instruction_Pointer).Src_Imm then
                  Register_File
                    (Program_Store (Instruction_Pointer).Destination) :=
                      Register_File
                        (Program_Store (Instruction_Pointer).Destination) -
                          Program_Store (Instruction_Pointer).Src_Num;
               else
                  Register_File
                    (Program_Store (Instruction_Pointer).Destination) :=
                      Register_File
                        (Program_Store (Instruction_Pointer).Destination) -
                          Register_File
                            (Program_Store (Instruction_Pointer).Source);
               end if;
               Instruction_Pointer := Instruction_Pointer + 1;
            when mul =>
               Mul_Count := Mul_Count + 1;
               if Program_Store (Instruction_Pointer).Src_Imm then
                  Register_File
                    (Program_Store (Instruction_Pointer).Destination) :=
                      Register_File
                        (Program_Store (Instruction_Pointer).Destination) *
                          Program_Store (Instruction_Pointer).Src_Num;
               else
                  Register_File
                    (Program_Store (Instruction_Pointer).Destination) :=
                      Register_File
                        (Program_Store (Instruction_Pointer).Destination) *
                          Register_File
                            (Program_Store (Instruction_Pointer).Source);
               end if;
               Instruction_Pointer := Instruction_Pointer + 1;
            when jnz =>
               if Program_Store (Instruction_Pointer).Dst_Imm then
                  if Program_Store (Instruction_Pointer).Dst_Num /= 0 then
                     if Program_Store (Instruction_Pointer).Src_Imm then
                        Instruction_Pointer := Instruction_Pointer +
                          Program_Store (Instruction_Pointer).Src_Num;
                     else
                        Instruction_Pointer := Instruction_Pointer +
                          Register_File
                            (Program_Store (Instruction_Pointer).Source);
                     end if; -- Src_Imm
                  else
                     Instruction_Pointer := Instruction_Pointer + 1;
                  end if; -- test value is an immediate
               else
                  if Register_File
                    (Program_Store (Instruction_Pointer).Destination) /= 0 then
                     if Program_Store (Instruction_Pointer).Src_Imm then
                        Instruction_Pointer := Instruction_Pointer +
                          Program_Store (Instruction_Pointer).Src_Num;
                     else
                        Instruction_Pointer := Instruction_Pointer +
                          Register_File
                            (Program_Store (Instruction_Pointer).Source);
                     end if; -- Src_Imm
                  else
                     Instruction_Pointer := Instruction_Pointer + 1;
                  end if; -- register test value
               end if;
         end case; -- Op_Code
      end loop; -- while termination consitions not met
   end Execute;

   function Multiply_Count return Natural is

   begin --  Multiply_Count
      return Mul_Count;
   end  Multiply_Count;

   function Read_Register (Register: in Registers) return Long_Long_Integer is

   begin -- Read_Register
      return Register_File (Register);
   end Read_Register;

begin -- Coprocessor_23
   Create (Trace_File, Out_File, Trace_File_Name);
   Open (Input_File, In_File, Source_File_Name);
   Process_File;
   Close (Input_File);
   if Debug_Switch then
      Register_File ('a') := 1;
   end if;
end Coprocessor_23;
