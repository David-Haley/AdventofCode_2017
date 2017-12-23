with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Ordered_Sets;

procedure December_21 is

   subtype Rule_Sizes is Natural range 2 .. 3;

   type Rules is record
      Rule_In : Unbounded_String := Null_Unbounded_String;
      Rule_Out : Unbounded_String := Null_Unbounded_String;
   end record; -- Nodes

   function "=" (Left, Right : Rules) return Boolean is

   begin -- "="
      return Left.Rule_In = Right.Rule_In;
   end "=";

   function "<" (Left, Right : Rules) return Boolean is

   begin -- "<"
      return Left.Rule_In < Right.Rule_In;
   end "<";

   function Key (Rule : Rules) return Unbounded_String is

   begin -- Key
      return Rule.Rule_In;
   end Key;

   package Rule_Lists is new Ada.Containers.Ordered_Sets  (Rules);
   use Rule_Lists;

   package Rule_Keys is new Generic_Keys (Unbounded_String, Key);
   use Rule_Keys;

   Rule_List : Rule_Lists.Set := Rule_Lists.Empty_Set;
   Rule_Cursor : Rule_Lists.Cursor;

   Maximum_Grid_Size : constant Natural := 3000;
   subtype Grid_Sizes is Natural range 3 .. Maximum_Grid_Size;
   subtype Coordinates is Natural range 0 .. Maximum_Grid_Size - 1;
   subtype Block_Counts is Positive range 1 ..
     Maximum_Grid_Size / Rule_Sizes'First;
   type Square_Array is array (Coordinates, Coordinates) of Character;

   type Grids is record
      Grid : Square_Array := (others => (others => 'O')); -- initalise for debug
      Grid_Size : Grid_Sizes;
      Rule_Size : Rule_Sizes;
      Block_Count : Block_Counts;
   end record;

   Grid : Grids;
   Pixel_Count : Natural;

   procedure Read_Rules is

      Input_File : File_Type;
      Text : Unbounded_String := Null_Unbounded_String;

      Pixel_Set : constant Character_Set := To_Set (".#");
      Separator_Set : constant Character_Set := To_Set ("=>");
      First, Start_At : Positive;
      Last : Natural;
      Rule_Size : Rule_Sizes;

      Current_Rule : Rules;

   begin -- Read_Rules
      Open (Input_File, In_File, "20171221.txt");
      while not End_Of_File (Input_File) loop
         Start_At := 1;
         Text := To_Unbounded_String (Get_Line (Input_File));
         Find_Token (Text, Pixel_Set, Start_At, Inside, First, Last);
         Current_Rule.Rule_In := Unbounded_Slice (Text, First, Last);
         Rule_Size := Length (Current_Rule.Rule_In);
         Start_At := Last + 1;
         for I in Natural range 2 .. Rule_Size loop
            Find_Token (Text, Pixel_Set, Start_At, Inside, First, Last);
            Append (Current_Rule.Rule_In, Unbounded_Slice (Text, First, Last));
            Start_At := Last + 1;
         end loop;
         Find_Token (Text, Separator_Set, Start_At, Inside, First, Last);
         Start_At := Last + 1;
         Current_Rule.Rule_Out := Null_Unbounded_String;
         for I in Natural range 1 .. (Rule_Size + 1) ** 2 loop
            Find_Token (Text, Pixel_Set, Start_At, Inside, First, Last);
            Append (Current_Rule.Rule_Out, Unbounded_Slice (Text, First, Last));
            Start_At := Last + 1;
         end loop;
         Insert (Rule_List, Current_Rule);
      end loop;
      Close (Input_File);
   end Read_Rules;

   procedure Initialise_Grid (Grid : out Grids) is

   begin -- Initialise_Grid
      Grid.Grid (0, 0) := '.';
      Grid.Grid (1, 0) := '#';
      Grid.Grid (2, 0) := '.';
      Grid.Grid (0, 1) := '.';
      Grid.Grid (1, 1) := '.';
      Grid.Grid (2, 1) := '#';
      Grid.Grid (0, 2) := '#';
      Grid.Grid (1, 2) := '#';
      Grid.Grid (2, 2) := '#';
      Grid.Grid_size := 3;
      Grid.Rule_Size := 3;
      Grid.Block_Count := 1;
   end Initialise_Grid;

   procedure Put_Grid (Grid : in Grids) is

   begin -- Put_Grid
      for Y in Coordinates range 0 .. Grid.Grid_Size - 1 loop
         for X in Coordinates range  0 .. Grid.Grid_Size - 1 loop
            Put (Grid.Grid (X, Y));
         end loop; -- X in Coordinates
         New_line;
      end loop;
      New_line;
   end Put_Grid;

   function Find_Rule (X_In, Y_In : in Coordinates; Grid : in Grids)
                       return Unbounded_String is

      Search_String : Unbounded_String;
      Cursor : Rule_Lists.Cursor;

   begin -- Find_Rule
      -- Straight Search Y+ X+
      Search_String := Null_Unbounded_String;
      for Y in Coordinates range Y_In .. Y_In + Grid.Rule_Size - 1 loop
         for X in Coordinates range X_IN .. X_In + Grid.Rule_Size - 1 loop
            Append (Search_String, Grid.Grid (X, Y));
         end loop; -- X
      end loop; -- Y
      Cursor := Find (Rule_List, Search_String);
      if Cursor /= No_Element then
         return Rule_List (Cursor).Rule_Out;
      end if;
      -- Mirror about verticle axis Y+ X-
      Search_String := Null_Unbounded_String;
      for Y in Coordinates range Y_In .. Y_In + Grid.Rule_Size - 1 loop
         for X in reverse Coordinates range X_IN .. X_In + Grid.Rule_Size - 1  loop
            Append (Search_String, Grid.Grid (X, Y));
         end loop; -- X
      end loop; -- Y
      Cursor := Find (Rule_List, Search_String);
      if Cursor /= No_Element then
         return Rule_List (Cursor).Rule_Out;
      end if;
      -- Mirror about horizontal axis Y- X+
      Search_String := Null_Unbounded_String;
      for Y in reverse Coordinates range  Y_In .. Y_In + Grid.Rule_Size - 1  loop
         for X in Coordinates range X_IN .. X_In + Grid.Rule_Size - 1 loop
            Append (Search_String, Grid.Grid (X, Y));
         end loop; -- X
      end loop; -- Y
      Cursor := Find (Rule_List, Search_String);
      if Cursor /= No_Element then
         return Rule_List (Cursor).Rule_Out;
      end if;
      --  Y- X-
      Search_String := Null_Unbounded_String;
      for Y in reverse Coordinates range  Y_In .. Y_In + Grid.Rule_Size - 1  loop
         for X in reverse Coordinates range X_IN .. X_In + Grid.Rule_Size - 1 loop
            Append (Search_String, Grid.Grid (X, Y));
         end loop; -- X
      end loop; -- Y
      Cursor := Find (Rule_List, Search_String);
      if Cursor /= No_Element then
         return Rule_List (Cursor).Rule_Out;
      end if;
      -- X+ Y+
      Search_String := Null_Unbounded_String;
      for X in Coordinates range X_IN .. X_In + Grid.Rule_Size - 1 loop
         for Y in Coordinates range Y_In .. Y_In + Grid.Rule_Size - 1 loop
            Append (Search_String, Grid.Grid (X, Y));
         end loop; -- Y
      end loop; -- X
      Cursor := Find (Rule_List, Search_String);
      if Cursor /= No_Element then
         return Rule_List (Cursor).Rule_Out;
      end if;
      --- X- Y+
      Search_String := Null_Unbounded_String;
      for X in reverse Coordinates range X_IN .. X_In + Grid.Rule_Size - 1 loop
         for Y in Coordinates range Y_In .. Y_In + Grid.Rule_Size - 1 loop
            Append (Search_String, Grid.Grid (X, Y));
         end loop; -- X
      end loop; -- Y
      Cursor := Find (Rule_List, Search_String);
      if Cursor /= No_Element then
         return Rule_List (Cursor).Rule_Out;
      end if;
      -- X+ Y-
      Search_String := Null_Unbounded_String;
      for X in Coordinates range X_IN .. X_In + Grid.Rule_Size - 1 loop
         for Y in reverse Coordinates range Y_In .. Y_In + Grid.Rule_Size - 1 loop
            Append (Search_String, Grid.Grid (X, Y));
         end loop; -- Y
      end loop; -- X
      Cursor := Find (Rule_List, Search_String);
      if Cursor /= No_Element then
         return Rule_List (Cursor).Rule_Out;
      end if;
      -- X- Y-
      Search_String := Null_Unbounded_String;
      for X in reverse Coordinates range X_IN .. X_In + Grid.Rule_Size - 1 loop
         for Y in reverse Coordinates range Y_In .. Y_In + Grid.Rule_Size - 1 loop
            Append (Search_String, Grid.Grid (X, Y));
         end loop; -- Y
      end loop; -- X
      Cursor := Find (Rule_List, Search_String);
      if Cursor /= No_Element then
         return Rule_List (Cursor).Rule_Out;
      end if;
      return Null_Unbounded_String; -- failed
   end Find_Rule;

   function Update_Grid (Grid : in Grids) return Grids is

      subtype Block_Indices is Natural range 0 .. Coordinates'Last /
        Rule_Sizes'First;

      New_Grid : Grids;
      New_Output : Unbounded_String;
      Output_Index : Positive;
      Rule_Size : Rule_Sizes;
      Block_Count : Block_Counts;

   begin -- Update_Grid
      if Grid.Grid_Size mod Rule_Sizes'First = 0 then
         Rule_Size := Rule_Sizes'First;
      else
         Rule_Size := Rule_Sizes'Last;
      end if;
      Block_Count := Grid.Grid_Size / Rule_Size;
      New_Grid.Block_Count := Block_Count;
      New_Grid.Grid_Size := (Rule_Size + 1) * New_Grid.Block_Count;
      for Block_X in Block_Indices range 0 .. Block_Count - 1 loop
         for Block_Y in Block_Indices range 0 .. Block_Count - 1 loop
            New_Output := Find_Rule (Block_X * Rule_Size, Block_Y * Rule_Size,
                                     Grid);
            Output_Index := 1;
            for Y in Coordinates range Block_Y * (Rule_Size + 1) ..
              (Block_Y + 1) * (Rule_Size + 1) - 1 loop
               for X in Coordinates range Block_X * (Rule_Size + 1) ..
                 (Block_X + 1) * (Rule_Size + 1) - 1 loop
                  New_Grid.Grid (X, Y) := Element (New_Output, Output_Index);
                  Output_Index := Output_Index + 1;
               end loop; -- X
            end loop; -- Y
         end loop; -- Block_Y
      end loop; -- Block_X
      if New_Grid.Grid_Size mod Rule_Sizes'First = 0 then
         New_Grid.Rule_Size := Rule_Sizes'First;
      else
         New_Grid.Rule_Size := Rule_Sizes'Last;
      end if;
      return New_Grid;
   end Update_Grid;

begin -- December_12
   Read_Rules;
   Initialise_Grid (Grid);
   Put_Grid (Grid);
   for I in Positive range 1 .. 5 loop
      Put_Line ("Update:" & Natural'Image (I));
      Grid := Update_Grid (Grid);
      Put_Grid (Grid);
   end loop; -- I in range 1 to 5
   Pixel_Count := 0;
   for Y in Coordinates range 0 .. Grid.Grid_Size - 1 loop
      for X in Coordinates range 0 .. Grid.Grid_Size - 1 loop
         if Grid.Grid (X, Y) = '#' then
            Pixel_Count := Pixel_Count + 1;
         end if; -- Grid.Grid (X, Y) = '#'
      end loop; -- X in Coordinates range 0 .. Grid.Grid_Size - 1
   end loop; -- Y in Coordinates range 0 .. Grid.Grid_Size - 1
   Put_Line ("Pixel Count:" & Natural'Image (Pixel_Count));
   Put_Line ("Part 2");
   Initialise_Grid (Grid);
   Put_Grid (Grid);
   for I in Positive range 1 .. 18 loop
      Put ("Update:" & Natural'Image (I));
      Grid := Update_Grid (Grid);
      Put_Line (" Grid Size:" & Natural'Image (Grid.Grid_Size));
   end loop; -- I in range 1 to 5
   Pixel_Count := 0;
   for Y in Coordinates range 0 .. Grid.Grid_Size - 1 loop
      for X in Coordinates range 0 .. Grid.Grid_Size - 1 loop
         if Grid.Grid (X, Y) = '#' then
            Pixel_Count := Pixel_Count + 1;
         end if; -- Grid.Grid (X, Y) = '#'
      end loop; -- X in Coordinates range 0 .. Grid.Grid_Size - 1
   end loop; -- Y in Coordinates range 0 .. Grid.Grid_Size - 1
   Put_Line ("Pixel Count:" & Natural'Image (Pixel_Count));
end December_21;
