with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Interfaces; use Interfaces;

procedure December_10 is
   Input_File : File_Type;
   Stream_Length : Natural;
   Text : Unbounded_String;
   Operand_Set : Character_Set := To_Set ("0123456789");
   First, Start_From : Positive;
   Last : Natural;

   Hash_Table_Size : constant Positive := 256;
   subtype Length_Counts is Natural range 0 .. Hash_Table_Size;
   type Hash_Table_Indices is mod Hash_Table_size;
   type Hash_Tables is array (Hash_Table_Indices) of Unsigned_8;
   Hash_Table :Hash_Tables;

   Current_Position, Skip_Size : Hash_Table_Indices;
   Length : Length_Counts;

   procedure Initialise (Hash_Table : in out Hash_Tables) is

   begin -- Initialise
      for I in Hash_Table_Indices loop
         Hash_Table (I) := Unsigned_8 (I);
      end loop;
   end Initialise;

   procedure Reverse_Slice (Hash_Table : in out Hash_Tables;
                            Start_At : in Hash_Table_Indices;
                           Length_Count : in Length_Counts) is

      Old_Table : Hash_Tables;

      Forwards, Backwards : Hash_Table_indices;

   begin -- Reverse_Slice
      Old_Table := Hash_Table;
      for I in Length_Counts range 1 .. Length_Count loop
         Forwards := Start_At + Hash_Table_Indices ((I - 1)
                                                    mod Hash_Table_Size);
         Backwards := Start_At + Hash_Table_Indices (Length_Count - 1) -
           Hash_Table_Indices ((I - 1) mod Hash_Table_Size);
         Hash_Table (Backwards) := Old_Table (Forwards);
      end loop;
   end Reverse_Slice;

   function Get_Operand return Length_Counts is

      Result : Natural;

   begin -- Get_Operand
      Find_Token (text, Operand_Set, Start_From, Inside, First, Last);
      Result := Length_Counts'Value
        (To_String (Unbounded_Slice (Text, First, Last)));
      Start_From := Last + 1;
      return Result;
   end Get_Operand;

begin -- December_10
   Open (Input_File, In_File, "20171210.txt");
   Text := To_Unbounded_String (Get_line (Input_File));
   Close (Input_File);
   Stream_Length := Ada.Strings.Unbounded.Length (Text);
   Start_From := 1;
   Initialise (Hash_Table);
   Current_Position := Hash_Table_Indices'First;
   Skip_Size := 0;
   while Start_From < Stream_Length loop
      Length := Get_Operand;
      Reverse_Slice (Hash_Table, Current_Position, Length);
      Current_Position := Current_Position +
        Hash_Table_Indices ((Length)  mod  Hash_Table_Size) + Skip_Size;
      Skip_Size := Skip_Size + 1;
   end loop; -- process one item
   Put_Line ("Product:" & Natural'Image (Natural(Hash_Table (0)) *
               Natural(Hash_Table (1))));
end December_10;
