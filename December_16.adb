with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Assertions; use Ada.Assertions;
with Interfaces; use Interfaces;

procedure December_16 is
   Input_File : File_Type;

   Array_Size : constant Natural := 16; -- Final
   -- Array_Size : constant Natural := 5;  -- Example

   subtype Keys is Character range 'a' ..
     Character'Val (Character'Pos ('a') + Array_Size - 1);

   type Positions is mod Array_Size;

   type Key_Arrays is array (Keys) of Positions;

   type Position_Arrays is array (Positions) of Keys;

   type Dancers is record
      Position : Position_Arrays;
      Key : Key_Arrays;
   end record;

   Dance, Dance_Start : Dancers;
   Op_Code, Delimiter : Character;
   Key_A, Key_B : Keys;
   Position_A, Position_B : Positions;
   Spin_Size : Natural;
   Cycle_Length : Positive := 1;

   package Position_IO is new Ada.Text_IO.Modular_IO (Positions);
   use Position_IO;
   package Natural_IO is new Ada.Text_IO.Integer_IO (Natural);
   use Natural_IO;

   procedure Initialise (Dance : in out Dancers) is

   begin -- Initialise
      for I in Positions loop
         Dance.Position (I) := Keys'Val (Natural (I) + Keys'Pos (Keys'First));
      end loop;
      for I in Keys loop
         Dance.Key (I) := Positions (Keys'Pos(I) - Keys'Pos (Keys'First));
      end loop;
   end Initialise;

   procedure Put_State (Dance : in Dancers) is

   begin -- Put_State
      for I in Positions loop
         Put (Dance.Position (I));
      end loop;
      New_Line;
      for I in Keys loop
         Put (Dance.Key (I));
      end loop;
      New_Line;
   end Put_State;

   procedure Spin (Dance : in out Dancers; Spin_Size : in Natural) is

      Old_Position : Position_Arrays;

   begin -- Spin
      Old_Position := Dance.Position;
      for I in Positions loop
         Dance.Position (I + Positions (Spin_Size mod Array_Size)) :=
           Old_Position (I);
         Dance.Key (Dance.Position (I + Positions (Spin_Size mod Array_Size)))
           := I + Positions (Spin_Size mod Array_Size);
      end loop;
   end Spin;

   procedure Swap_Position (Dance : in out Dancers;
                   Position_A, Position_B : in Positions) is

      Key_A, Key_B :Keys ;

   begin -- Swap_Position
      Key_A := Dance.Position (Position_A);
      Key_B := Dance.Position (Position_B);
      Dance.Key (Key_A) := Position_B;
      Dance.Key (Key_B) := Position_A;
      Dance.Position (Position_A) := Key_B;
      Dance.Position (Position_B) := Key_A;
   end Swap_Position;

   procedure Swap_Keys (Dance : in out Dancers; Key_A, Key_B : in Keys) is

      Position_A, Position_B : Positions;

   begin -- Swap_Keys
      Position_A := Dance.Key (Key_A);
      Position_B := Dance.Key (Key_B);
      Dance.Key (Key_A) := Position_B;
      Dance.Key (Key_B) := Position_A;
      Dance.Position (Position_A) := Key_B;
      Dance.Position (Position_B) := Key_A;
   end Swap_Keys;

   procedure Process_file is

   begin -- Process_File
      Reset (Input_File);
      while not End_Of_Line (Input_File) loop
         Get (Input_File, Op_code);
         case Op_Code is
         when 's' =>
            Get (Input_File, Spin_Size);
            Spin (Dance, Spin_Size);
         when 'x' =>
            Get (Input_File, Position_A);
            Get (Input_File, Delimiter);
            Assert (Delimiter = '/');
            Get (Input_File, Position_B);
            Swap_Position (Dance, Position_A, Position_B);
         when 'p' =>
            Get (input_File, Key_A);
            Get (Input_File, Delimiter);
            Assert (Delimiter = '/');
            Get (input_File, Key_B);
            Swap_Keys (Dance, Key_A, Key_B);
         when others =>
            Put_Line ("Bad Operation Code: '" & Op_Code & "'");
         end case;
         if not End_Of_Line (Input_File) then
            Get (Input_File, Delimiter);
            Assert (Delimiter = ',');
         end if;
      end loop; -- process one item
   end Process_File;

begin -- December_16
   Initialise (Dance);
   Open (Input_File, In_File, "20171216.txt");
   Process_File;
   Put_Line ("After 1 repition");
   Put_State (Dance);
   Initialise (Dance);
   Dance_Start := Dance;
   loop
      Process_File;
      if Dance = Dance_Start then
         Put_Line ("Cycle_Length:" & Positive'Image (Cycle_Length));
         exit;
      end if;
      Cycle_Length := Cycle_Length + 1;
   end loop; -- find cycle length
   Initialise (Dance);
   for I in Positive range 1 .. 1000000000 mod Cycle_Length loop
      Process_File;
   end loop;
   Put_Line ("After 1000000000 repitions");
   Put_State (Dance);
   Close (Input_File);
end December_16;
