with Ada.Assertions; use Ada.Assertions;

Package body CPU_18 is

   Input_File, Trace_File : File_Type;
   Text : Unbounded_String;
   Start_At, First : Positive;
   Last : Natural;
   Op_Set : constant Character_Set := To_Set ("sndsetaddmulmodrcvjgz");
   Reg_Range : constant Character_Range := ('a', 'z');
   Reg_Set : constant Character_Set := To_Set (Reg_Range);
   Int_Set : constant Character_set := To_Set ("-0123456789");

   type Op_Codes is (snd, set, add, mul, mod_op, rcv, jgz);
   -- mod is a reserved word
   subtype Registers is Character range 'a' .. 'z';

   type instructions is record
      Op_Code : Op_Codes;
      Dst_Imm : Boolean; -- selects between destination and immediate
      Destination : Registers := 'z';
      Dst_Num : Long_Long_Integer := 0;
      Src_Imm : Boolean; -- selects between source and immediate
      Source : Registers := 'z';
      Src_Num : Long_Long_Integer := 0;
   end record;

   subtype Addresses is Long_Long_Integer range 0 .. 100;
   Type Register_Files is array (Registers) of Long_Long_Integer;
   type Program_Stores is array (Addresses) of Instructions;

   Register_File : Register_Files := ('p' => CPU_ID, others => 0);
   Program_Store : Program_Stores;
   Last_Instruction : Addresses := 0;
   Send_Count : Natural := 0;

   procedure Process_file is
      Load_At : Addresses := 0;

      function Get_Op_Code return Op_Codes is

         Op_String : String (1 ..3);

      begin -- Get_Op_Code
         Find_Token (Text, Op_Set, Start_At, Inside, First, Last);
         Op_String := Slice (Text, First, Last);
         Start_At := Last + 1;
         if Op_String = "snd" then
            return snd;
         elsif Op_String = "set" then
            return set;
         elsif Op_String = "add" then
            return add;
         elsif Op_String = "mul" then
            return mul;
         elsif Op_String = "mod" then
            return mod_op;
         elsif Op_String = "rcv" then
            return rcv;
         elsif Op_String = "jgz" then
            return jgz;
         else
            Put_Line (Trace_File, "Unknown Op Code: " & Op_String);
            assert (False);
            return snd; -- this is unnreachable code
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
         case Program_Store (Load_At).Op_Code is
            when snd | rcv =>
               null;
            when  set | add | mul | mod_op | jgz =>
               Find_Token (Text, Int_Set, Start_At, Inside, First, Last);
               Program_Store (Load_At).Src_Imm := Last > 0;
               if Program_Store (Load_At).Src_Imm then
                  Program_Store (Load_At).Src_Num :=
                    Long_Long_Integer'Value (Slice (Text, First, Last));
               else
                  Program_Store (Load_At).Source := Get_Register;
               end if;
         end case;
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
            when snd =>
               Send_Count := Send_Count + 1;
               Put_Line ("CPU (" & Long_Long_Integer'Image (CPU_ID) & "):" &
                         Natural'Image (Send_Count));
               if Program_Store (Instruction_Pointer).Dst_Imm then
                  Send (CPU_ID, Program_Store (Instruction_Pointer).Dst_Num);
               else
                  Send (CPU_ID, Register_File
                    (Program_Store (Instruction_Pointer).Destination));
               end if;
               Instruction_Pointer := Instruction_Pointer + 1;
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
            when add =>
               if Program_Store (Instruction_Pointer).Src_Imm then
                  Register_File
                    (Program_Store (Instruction_Pointer).Destination) :=
                      Register_File
                        (Program_Store (Instruction_Pointer).Destination) +
                          Program_Store (Instruction_Pointer).Src_Num;
               else
                  Register_File
                    (Program_Store (Instruction_Pointer).Destination) :=
                      Register_File
                        (Program_Store (Instruction_Pointer).Destination) +
                          Register_File
                            (Program_Store (Instruction_Pointer).Source);
               end if;
               Instruction_Pointer := Instruction_Pointer + 1;
            when mul =>
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
            when mod_op =>
               if Program_Store (Instruction_Pointer).Src_Imm then
                  Register_File
                    (Program_Store (Instruction_Pointer).Destination) :=
                      Register_File
                        (Program_Store (Instruction_Pointer).Destination) mod
                          Program_Store (Instruction_Pointer).Src_Num;
               else
                  Register_File
                    (Program_Store (Instruction_Pointer).Destination) :=
                      Register_File
                        (Program_Store (Instruction_Pointer).Destination) mod
                          Register_File
                            (Program_Store (Instruction_Pointer).Source);
               end if;
               Instruction_Pointer := Instruction_Pointer + 1;
            when rcv =>
               Register_File (Program_Store (Instruction_Pointer).Destination)
                 := Receive (CPU_ID);
               Instruction_Pointer := Instruction_Pointer + 1;
            when jgz =>
               if Program_Store (Instruction_Pointer).Dst_Imm then
                  if Program_Store (Instruction_Pointer).Dst_Num > 0 then
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
                    (Program_Store (Instruction_Pointer).Destination) > 0 then
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

   task body Run_CPU is

   begin -- Run_CPU
      accept Start_CPU;
      Execute;
   end;

begin -- CPU_18
   Create (Trace_File, Out_File, Trace_File_Name);
   Open (Input_File, In_File, Source_File_Name);
   Process_File;
   Close (Input_File);
end CPU_18;
