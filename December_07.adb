with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Doubly_Linked_Lists;
with Ada.Containers.Ordered_Sets;

procedure December_07 is


   Input_File : File_Type;
   Input_Line : Unbounded_String := Null_Unbounded_String;

   Node_Name_Range : Character_Range :=  ('a', 'z');
   Node_Name_Set : Character_Set := To_Set (Node_Name_Range);
   First, Start_From : Positive;
   Last : Natural;

   Weight_Range : Character_Range := ('0', '9');
   Weight_Set : Character_Set := To_Set (Weight_Range);

   package Natural_IO is new Integer_IO (Natural); use Natural_IO;

   package Branch_Lists is new Ada.Containers.Doubly_Linked_Lists
     (Unbounded_String);
   use Branch_Lists;

   type Nodes is record
      Node_Name : Unbounded_String := Null_Unbounded_String;
      Weight : Natural := 0;
      Is_Child : Boolean := False;
      Is_Leaf : Boolean := True;
      Branch_List : Branch_Lists.List := Branch_Lists.Empty_List;
   end record; -- Nodes

   function "=" (Left, Right : Nodes) return Boolean is

   begin -- "="
      return Left.Node_Name = Right.Node_Name;
   end "=";

   function "<" (Left, Right : Nodes) return Boolean is

   begin -- "<"
      return Left.Node_Name < Right.Node_Name;
   end "<";

   function Key (Node : Nodes) return Unbounded_String is

   begin -- Key
      return Node.Node_Name;
   end Key;

   procedure Set_Child (Node : in out Nodes) is

   begin -- Set_Child
      Node.Is_Child := True;
   end Set_Child;

   package Node_Lists is new Ada.Containers.Ordered_Sets  (Nodes);
   use Node_Lists;

   package Node_Keys is new Generic_Keys (Unbounded_String, Key);
   use Node_Keys;

   Node_List : Node_Lists.Set;
   Current_Node, Search_Node : Nodes;
   Node_Cursor, Found_Node : Node_Lists.Cursor;
   Branch_Cursor : Branch_Lists.Cursor;

begin -- December_07
   Open (Input_File, In_File, "20171207.txt");
   while not End_Of_File (Input_File) loop
      Input_Line := To_Unbounded_String (Get_Line (Input_File));
      Find_Token (Input_Line, Node_Name_Set, Inside, First, Last);
      while Last > 0 loop
         Current_Node.Node_Name := Unbounded_Slice (Input_Line, First, Last);
         Start_From := Last + 1;
         Find_Token (Input_Line, Weight_Set, Start_From, Inside, First,
                     Last);
         Current_Node.Weight :=
           Natural'Value (To_String (Unbounded_Slice (Input_Line, First, Last)));
         Start_From := Last + 1;
         Find_Token (Input_Line, Node_Name_Set, Start_From, Inside, First,
                     Last);
         while Last /= 0 loop
            Current_Node.Is_Leaf := False;
            Append (Current_Node.Branch_List, Unbounded_Slice (Input_Line,
                    First, Last));
            Start_From := Last + 1;
            Find_Token (Input_Line, Node_Name_Set, Start_From, Inside, First,
                        Last);
         end loop;
         Insert (Node_List, Current_Node);
      end loop; -- Process line
   end loop; -- process file
   Node_Cursor := Node_Lists.First (Node_List);
   while Node_Cursor /= Node_Lists.No_Element loop
      Current_Node := Element (Node_Cursor);
      Branch_Cursor := Branch_Lists.First (Current_Node.Branch_List);
      while Branch_Cursor /= Branch_Lists.No_Element loop
         Search_Node.Node_Name := Element (Branch_Cursor);
         Update_Element_Preserving_Key (Node_List,
                                        Find (Node_List, Search_Node),
                                        Set_Child'Access);
         Branch_Cursor := Next (Branch_Cursor);
      end loop; -- traverse brabch list
      Node_Cursor := Next (Node_Cursor);
   end loop;  -- traverse nodes
   Node_Cursor := Node_Lists.First (Node_List);
   while Node_Cursor /= Node_Lists.No_Element loop
      Current_Node := Element (Node_Cursor);
      -- Put_Line (To_String (Current_Node.Node_Name));
      if not Current_Node.Is_Child then
         Put_Line ("Tree root:" & To_String (Current_Node.Node_Name));
      end if;
      Node_Cursor := Next (Node_Cursor);
   end loop;
end December_07;
