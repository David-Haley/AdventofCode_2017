with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Ordered_Sets;

procedure December_08 is


   Input_File : File_Type;
   Input_Line : Unbounded_String := Null_Unbounded_String;

   Register_Name_Range : Character_Range :=  ('a', 'z');
   Register_Name_Set : Character_Set := To_Set (Register_Name_Range);
   Operation_Set : Character_Set := To_Set ("incdec");
   Operand_Set : Character_Set := To_Set ("-0123456789");
   If_Set : Character_Set := To_Set ("if");
   Relational_Set : Character_Set := To_Set ("!<>=");
   First, Start_From : Positive;
   Last : Natural;

   type Registers is record
      Register_Name : Unbounded_String := Null_Unbounded_String;
      Contents : Integer := 0;
      Maximum : Integer := Integer'First;
   end record; -- Registers

   Global_Maximum, Current_Maximum : Integer := Integer'First;

   function "=" (Left, Right : Registers) return Boolean is

   begin -- "="
      return Left.Register_Name = Right.Register_Name;
   end "=";

   function "<" (Left, Right : Registers) return Boolean is

   begin -- "<"
      return Left.Register_Name < Right.Register_Name;
   end "<";

   function Key (Reg : Registers) return Unbounded_String is

   begin -- Key
      return Reg.Register_Name;
   end Key;

   package Register_Sets is new Ada.Containers.Ordered_Sets  (Registers);
   use Register_Sets;

   package Register_Keys is new Generic_Keys (Unbounded_String, Key);
   use Register_Keys;

   Register_Set : Register_Sets.Set;
   Register_Cursor : Register_Sets.Cursor;

   Current_Register : Registers;
   Dest_Reg, Test_Reg : Cursor;

   Inc_Operation : Boolean; -- true increment false
   Operand, Test_Value: Integer;
   Test_String : Unbounded_String;

   function Get_Register return Cursor is

   begin -- Get_Regiester
      Find_Token (Input_Line, Register_Name_Set, Start_From, Inside, First,
                  Last);
      if not Contains (Register_Set,
                       Unbounded_Slice (Input_Line, First, Last)) then
         Current_Register.Register_Name :=
           Unbounded_Slice (Input_Line, First, Last);
         Insert (Register_Set, Current_Register);
      end if; -- register did not exist
      return Find (Register_Set, Unbounded_Slice (Input_Line, First, Last));
   end Get_Register;

   function Get_Operand return integer is

   begin -- Get_Operand
      Find_Token (Input_Line, Operand_Set, Start_From, Inside, First, Last);
      return Integer'Value
        (To_String (Unbounded_Slice (Input_Line, First, Last)));
   end Get_Operand;

   procedure Perform_Operation (Inc : in Boolean; Test : in String) is

      procedure Inc_Op is

      begin -- Inc_op
         if Inc then
            Register_Set (Dest_Reg).Contents :=
              Register_Set (Dest_Reg).Contents + Operand;
         else
            Register_Set (Dest_Reg).Contents :=
              Register_Set (Dest_Reg).Contents - Operand;
         end if;
         if Register_Set (Dest_Reg).Contents >
           Register_Set (Dest_Reg).Maximum then
            Register_Set (Dest_Reg).Maximum := Register_Set (Dest_Reg).Contents;
            if Register_Set (Dest_Reg).Maximum > Global_Maximum then
               Global_Maximum := Register_Set (Dest_Reg).Maximum;
            end if;
         end if;
      end Inc_OP;

   begin -- Perform_Operation
      if Test = "<" then
         if Register_Set(Test_Reg).Contents < Test_Value then
            Inc_Op;
         end if;
      elsif Test = "<=" then
         if Register_Set(Test_Reg).Contents <= Test_Value then
            Inc_Op;
         end if;
      elsif Test = "==" then
         if Register_Set(Test_Reg).Contents = Test_Value then
            Inc_Op;
         end if;
      elsif Test = "!=" then
         if Register_Set(Test_Reg).Contents /= Test_Value then
            Inc_Op;
         end if;
      elsif Test = ">=" then
         if Register_Set(Test_Reg).Contents >= Test_Value then
            Inc_Op;
         end if;
      elsif Test = ">" then
         if Register_Set(Test_Reg).Contents > Test_Value then
            Inc_Op;
         end if;
      else
         Put_Line ("Unknown Operation" & Test);
      end if;
   end Perform_Operation;

begin -- December_08
   Open (Input_File, In_File, "20171208.txt");
   while not End_Of_File (Input_File) loop
      Input_Line := To_Unbounded_String (Get_Line (Input_File));

      Start_From := 1;
      Dest_Reg := Get_Register;

      -- get operation inc or dec
      Start_From := Last + 1;
      Find_Token (Input_Line, Operation_Set, Start_From, Inside, First,
                  Last);
      Inc_Operation := "inc" =
        To_String (Unbounded_Slice (Input_Line, First, Last));

      -- Get operand
      Start_From := Last + 1;
      Operand := Get_Operand;

      -- Remove "if" token
      Start_From := Last + 1;
      Find_Token (Input_Line, if_Set, Start_From, Inside, First, Last);

      -- Get test register
      Start_from := Last + 1;
      Test_Reg := Get_Register;

      -- Get test type
      Start_from := Last + 1;
      Find_Token (Input_Line, Relational_Set, Start_From, Inside, First, Last);
      Test_String := Unbounded_Slice (Input_Line, First, Last);

      -- Get test operand
      Start_From := Last + 1;
      Test_Value := Get_Operand;

      Perform_Operation (Inc_Operation, To_String (Test_String));
   end loop; -- process file

   For Current in Register_Set.Iterate loop
      if Register_Set (Current).Contents > Current_Maximum then
         Current_Maximum :=  Register_Set (Current).Contents;
      end if;
   end loop;
   Put_Line ("Largest Current Register Value:" &
               Integer'Image (Current_Maximum));
   Put_Line ("Largest Register Value:" & Integer'Image (Global_Maximum));
end December_08;
