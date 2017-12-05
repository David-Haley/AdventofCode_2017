with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Ordered_Sets;

procedure December_04a is

   Valid_Count : Natural := 0;
   Input_File : File_Type;
   Input_Line : Unbounded_String := Null_Unbounded_String;
   Passphrase_Range : Character_Range :=  ('a', 'z');
   Passphrase_Set : Character_Set := To_Set (Passphrase_Range);
   First, Start_From : Positive;
   Last : Natural;
   Current_Token : Unbounded_String;
   Is_Valid : Boolean;

   package Natural_IO is new Integer_IO (Natural); use Natural_IO;

   package Word_Stores is new Ada.Containers.Ordered_Sets (Unbounded_String);
   use Word_Stores;

   Word_Store : Set;
   Word_Cursor : Cursor;

   function Is_Anagram (Left, Right : in Unbounded_String) return Boolean is

      Result : Boolean := True;

   begin -- Is_Anagram
      if Length (Left) = Length (Right) then
         return To_Set (To_String (Left)) = To_Set (To_String (Right));
      else
         -- not the same length
         return False;
      end if;
   end is_Anagram;

begin -- December_04a
   Open (Input_File, In_File, "20171204.txt");
   while not End_Of_File (Input_File) loop
      Input_Line := To_Unbounded_String (Get_Line (Input_File));
      Clear (Word_Store);
      Is_Valid := True;
      Find_Token (Input_Line, Passphrase_Set, Inside, First, Last);
      while Last > 0 and Is_Valid loop
         Current_Token := Unbounded_Slice (Input_Line, First, Last);
         Is_Valid := Is_Valid and not Contains (Word_Store, Current_Token);
         Word_Cursor := Word_Stores.First (Word_Store);
         while Word_Cursor /= No_Element loop
            Is_Valid := Is_Valid and not Is_Anagram (Current_Token,
                                                     Element (Word_Cursor));
            Next (Word_Cursor);
         end loop;
         if Is_Valid then
            Insert (Word_Store, Current_Token);
         end if; -- no duplicates allowed
         Start_From := Last + 1;
         Find_Token (Input_Line, Passphrase_Set, Start_From, Inside, First,
                     Last);
      end loop; -- Process one word
      if Is_Valid then
         Valid_Count := Valid_Count + 1;
      end if;
   end loop; -- process one line
   Put ("Valid Passphrases: ");
   Put (Valid_Count);
   New_Line;
end December_04a;
