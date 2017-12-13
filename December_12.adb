with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Doubly_Linked_Lists;

procedure December_12 is

   Input_File : File_Type;
   Input_Line : Unbounded_String := Null_Unbounded_String;
   First, Start_From : Positive;
   Last : Natural;
   Program_Count, Group_Count : Natural := 0;

   ID_Set : Character_Set := To_Set ("0123456789");
   Pipe_Set : Character_Set := To_Set ("<->");

   subtype Program_IDs is Natural range 0 .. 1999;

   package ID_IO is new Integer_IO (Program_IDs); use ID_IO;

   package Pipe_Lists is new Ada.Containers.Doubly_Linked_Lists (Program_IDs);
   use Pipe_Lists;

   type Programs is record
      Pipe_List : Pipe_Lists.List := Pipe_Lists.Empty_List;
      Been_Here : Boolean := False;
   end record; -- Nodes


   Program_Table : array (Program_IDs) of Programs;
   Table_Index, Current_Pipe : Program_IDs;

   Pipe_Cursor : pipe_Lists.Cursor;

   procedure Traverse_Table ( Sub_Table : in Program_IDs) is

   begin -- Traverse_Table
      if not Program_Table (Sub_Table).Been_Here then
         Program_Table (Sub_Table).Been_Here := True;
         for Pipe_Cursor in Program_Table (Sub_Table).Pipe_List.Iterate loop
            Traverse_Table (Program_Table (Sub_Table).Pipe_List (Pipe_Cursor));
         end loop;
      end if; -- not been here
      Program_Table (Sub_Table).Been_Here := True;
      -- all pipes explored to end
   end Traverse_Table;

   function Get_ID return Program_IDs is

      Result : Program_IDs;

   begin -- Get_ID
      Find_Token (Input_Line, ID_Set, Start_From, Inside, First, Last);
      if Last > 0 then
         Result := Program_IDs'Value
           (To_String (Unbounded_Slice (Input_Line, First, Last)));
         Start_From := Last + 1;
         return Result;
      else
         return 0;
      end if;
      end Get_ID;

begin -- December_12
   Open (Input_File, In_File, "20171212.txt");
   while not End_Of_File (Input_File) loop
      Input_Line := To_Unbounded_String (Get_Line (Input_File));
      Start_From := 1;
      Table_Index := Get_ID;
      Find_Token (Input_Line, Pipe_Set, Start_From, Inside, First, Last);
      Start_From := Last + 1;
      -- advance past <->
      while Last > 0 loop
         Current_Pipe := Get_ID;
         while Last /= 0 loop
            Append (Program_Table (Table_Index).Pipe_List, Current_Pipe);
            Current_Pipe := Get_ID;
         end loop;
      end loop; -- Process line
   end loop; -- process file
   Traverse_Table (0);
   for Table_Index in Program_IDs loop
      if Program_Table (Table_Index).Been_Here then
         Program_Count := Program_Count + 1;
      end if;
   end loop;
   Put_Line ("Program linled to (0):" & Natural'Image (Program_Count));
   Group_Count := 1; -- Already found group 0
   for Table_Index in Program_IDs loop
      if not Program_Table (Table_Index).Been_Here then
         Group_Count := Group_Count + 1;
         Traverse_Table (Table_Index); -- mark other members of group
      end if;
   end loop;
   Put_Line ("Group_Count:" & Natural'Image (Group_Count));
end December_12;
