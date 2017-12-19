with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Assertions; use Ada.Assertions;

procedure December_18 is
   Input_File : File_Type;
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

   Register_File : Register_Files := (others => 0);
   Program_Store : Program_Stores;
   Last_Instruction : Addresses := 0;
   Last_Sound : Long_Long_Integer := 0; -- for compatibility with register file

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
            Put_Line ("Unknown Op Code: " & Op_String);
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
         Put_Line (To_String (Text) & " -> ");
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
         Put_Line (Addresses'Image (Load_At) & ": "
                   & Op_Codes'Image (Program_Store (Load_At).Op_Code) & " " &
                     Boolean'Image (Program_Store (Load_At).Dst_Imm) & " " &
                     Program_Store (Load_At).Destination & " " &
                     Long_Long_Integer'Image (Program_Store (Load_At).Dst_Num) & " " &
                     Boolean'Image (Program_Store (Load_At).Src_Imm) & " " &
                     Program_Store (Load_At).Source & " " &
                     Long_Long_Integer'Image (Program_Store (Load_At).Src_Num));
         Flush;
         Last_Instruction := Load_At;
         Load_At := Load_At + 1;
      end loop; -- process one Instruction
   end Process_File;

   procedure Execute is

      Instruction_Pointer : Long_Long_Integer := 0;

      procedure Put_State is

      begin -- Put_State
         Put (Long_Long_Integer'Image (Instruction_Pointer) & ": " );
         Put (Op_Codes'Image (Program_Store (Instruction_Pointer).Op_Code)
              & " ");
         if Program_Store (Instruction_Pointer).Dst_Imm then
            Put (Long_Long_Integer'Image (Program_Store (Instruction_Pointer).Dst_Num)
                 & " ");
         else
            Put (Program_Store (Instruction_Pointer).Destination & " ");
         end if;
         if Program_Store (Instruction_Pointer).Src_Imm then
            Put_Line (Long_Long_Integer'Image (Program_Store (Instruction_Pointer).
                        Src_Num));
         else
            Put_Line (Program_Store (Instruction_Pointer).Source & "");
         end if;
         for I in Registers loop
            Put (" (" & I & ")" & Long_Long_Integer'Image (Register_File (I)));
         end loop;
         New_Line;
      end Put_State;

   begin -- Execute
      while (Instruction_Pointer >= 0) and
        (Instruction_Pointer <= Last_Instruction) loop
         Put_State;
         case Program_Store (Instruction_Pointer).Op_Code is
            when snd =>
               if Program_Store (Instruction_Pointer).Dst_Imm then
                  Last_Sound := Program_Store (Instruction_Pointer).Dst_Num;
               else
                  Last_Sound := Register_File
                    (Program_Store (Instruction_Pointer).Destination);
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
               if Program_Store (Instruction_Pointer).Dst_Imm then
                  if Program_Store (Instruction_Pointer).Dst_num /= 0 then
                     exit;
                  end if;
               else
                  if Register_File
                    (Program_Store (Instruction_Pointer).Destination) /= 0 then
                     Register_File
                       (Program_Store (Instruction_Pointer).Destination) :=
                         Last_Sound;
                     exit;
                  end if;
               end if;
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

begin -- December_18
   Open (Input_File, In_File, "20171218.txt");
   Process_File;
   Close (Input_File);
   Execute;
   Put_Line ("Last Sound:" & Long_Long_Integer'Image (Last_Sound));
end December_18;
