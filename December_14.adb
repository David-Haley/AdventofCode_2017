with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Interfaces; use Interfaces;
with Knot_Hash; use Knot_Hash;

procedure December_14 is

   subtype Rows is Natural range 0 .. 127;
   subtype Columns is Natural range 0 .. 127;

   -- My_Input : constant String := "flqrgnkx-"; -- flqrgnkx with example
   My_Input : constant String := "hwlqcszp-"; -- hwlqcszp with '-' appended
   Input_String, Hashed_Output : Unbounded_String;
   Blank_Index : Natural;
   Hash_Result : Hash_Results;
   Used_Count, Group_Count : Natural := 0;

   type Cells is record
      Used : Boolean;
      Been_Here : Boolean := False;
   end record;

   Type Grids is array (Columns, Rows) of Cells;

   Grid : Grids;

   Procedure Mark_Used (Grid : in out Grids; Hash_Result : in Hash_Results;
                         Row : in Rows) is

      Block_Index : Block_Indices;

   begin -- Mark_Used
      for Column in Columns loop
         Block_Index := Column / 8;
         Grid (Column, Row).Used := (Hash_Result (Block_Index) and
           2 ** (7 - (Column mod 8))) /= 0;
      end loop;
   end Mark_Used;

   procedure Mark_Adjacent (Grid : in out Grids; Column : in Columns;
                            Row : in Rows) is

   begin
      if Grid (Column, Row).Used then
         Grid (Column, Row).Been_Here := True;
         if Column > Columns'First and then
           (Grid (Column - 1, Row).Used and
                not Grid (Column - 1, Row).Been_Here) then
            Mark_Adjacent (Grid, Column - 1, Row);
         end if; -- test left
         if Column < Columns'Last and then
           (Grid (Column + 1, Row).Used and                                              not Grid (Column + 1, Row).Been_Here) then
            Mark_Adjacent (Grid, Column + 1, Row);
         end if; -- test right
         if Row > Rows'First and then
           (Grid (Column, Row - 1).Used and
                not Grid (Column, Row - 1).Been_Here) then
            Mark_Adjacent (Grid, Column, Row - 1);
         end if; -- test above
         if Row < Rows'Last and then
           (Grid (Column, Row + 1).Used and
                not Grid (Column, Row + 1).Been_Here) then
            Mark_Adjacent (Grid, Column, Row + 1);
         end if; -- test below
      end if; -- Grid (Column, Row).Used
   end Mark_Adjacent;

begin -- December_14
   for Row in Rows loop
      Input_String := To_Unbounded_String (My_Input & Rows'Image (Row));
      Blank_Index := Index (Input_string , " ");
      Delete (Input_String, Blank_Index, Blank_Index);
      -- remove ' ' between '-' and the number
      Hash_Result := Hash (Input_String);
      Mark_Used (Grid, Hash_Result, Row);
   end loop;
   for Row in Rows loop
      for Column in Columns loop
         if Grid (Column, Row).Used then
            Used_Count := Used_Count + 1;
         end if;
      end loop; -- Column in Columns
   end loop; -- Row in Rows
   Put_Line ("Used:" & Natural'Image (Used_Count));
   for Row in Rows loop
      for Column in Columns loop
         if Grid (Column, Row).Used and not Grid (Column, Row).Been_Here then
            Group_Count := Group_Count + 1;
            Mark_Adjacent (Grid, Column, Row);
         end if;
      end loop; -- Column in Columns
   end loop; -- Row in Rows
   Put_Line ("Groups:" & Natural'Image (Group_Count));
end December_14;
