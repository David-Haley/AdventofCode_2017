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

   Type Branches is record
      Branch_Name : Unbounded_String;
      Branch_Weight : Natural := 0;
   end record;

   package Natural_IO is new Integer_IO (Natural); use Natural_IO;

   package Branch_Lists is new Ada.Containers.Doubly_Linked_Lists
     (Branches);
   use Branch_Lists;

   type Nodes is record
      Node_Name : Unbounded_String := Null_Unbounded_String;
      Weight : Natural := 0;
      Depth : Natural := 0;
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
   Current_Branch : Branches;
   Node_Cursor, Root_Node : Node_Lists.Cursor;
   Branch_Cursor, Top_Branch, Bottom_Branch : Branch_Lists.Cursor;
   Total_Weight : Natural :=  0; -- initialised to prevent a compiler warning
   -- not used variable parameter for Branch_Weight in first Traverse Tree call

   Top, Bottom, Majority : Natural;

   procedure Traverse_Tree ( Sub_Tree : in Node_Lists.Cursor;
                             Branch_Weight : in out Natural;
                             Depth : in Natural) is

      Disc_Weight : Natural:= Node_List(Sub_Tree).Weight;

   begin -- Traverse_Tree
      for Branch_Cursor in Node_List (Sub_Tree).Branch_List.Iterate loop
         Traverse_Tree (Find (Node_List, Node_List (Sub_Tree).
                          Branch_List(Branch_Cursor).Branch_Name),
                        Branch_Weight,
                        Depth + 1);
         Node_List (Sub_Tree).Branch_List (Branch_Cursor).Branch_Weight :=
           Branch_Weight;
         Disc_Weight := Disc_Weight + Branch_Weight;
      end loop;
      Branch_Weight := Disc_Weight;
      Node_List (Sub_Tree).Depth := Depth;
   end Traverse_Tree;

   procedure Check_Balance (Sub_Tree : in Node_Lists.Cursor;
                            Top, Bottom, Majority : out Natural;
                            Top_Branch, Bottom_Branch : out Branch_Lists.Cursor)
   is

      Top_Count, Bottom_Count : Natural;
      First_Branch : Boolean := True;

   begin -- Check_Balance
      Top := 0;
      Bottom := Top;
      Majority := Bottom;
      -- ensure valid return if there are no branches
      for Branch_Cursor in Node_List (Sub_Tree).Branch_List.Iterate loop
         if First_Branch then
            Top := Node_List (Sub_Tree).Branch_List (Branch_Cursor)
              .Branch_Weight;
            Bottom := Top;
            Top_Count := 1;
            Bottom_Count := 1;
            First_Branch := False;
            Top_Branch := Branch_Cursor;
            Bottom_Branch := Branch_Cursor;
         else
            if Node_List (Sub_Tree).Branch_List (Branch_Cursor).Branch_Weight
              >= Top then
              Top :=
                 Node_List (Sub_Tree).Branch_List (Branch_Cursor).Branch_Weight;
              Top_Count := Top_Count + 1;
              Top_Branch := Branch_Cursor;
            end if; -- new Bottom found
            if Node_List (Sub_Tree).Branch_List (Branch_Cursor).Branch_Weight
              <= Bottom then
               Bottom :=
                 Node_List (Sub_Tree).Branch_List (Branch_Cursor).Branch_Weight;
               Bottom_Count := Bottom_Count + 1;
               Bottom_Branch := Branch_Cursor;
            end if; -- New Top found
         end if; -- First_Branch
      end loop; -- iterate over branches
      if Top_count > Bottom_Count then
         Majority := Top;
      elsif Bottom_Count > Top_Count then
         Majority := Bottom;
      else
         Majority := Bottom; -- Bottom_Count = Top_Count assumed Top = Bottom
      end if; -- resolve majority
   end Check_Balance;

begin -- December_07
   Open (Input_File, In_File, "20171207.txt");
   while not End_Of_File (Input_File) loop
      Input_Line := To_Unbounded_String (Get_Line (Input_File));
      Current_Node.Branch_List := Branch_Lists.Empty_List;
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
            Current_Branch.Branch_Name :=
              Unbounded_Slice (Input_Line, First, Last);
            Append (Current_Node.Branch_List, Current_Branch);
            Start_From := Last + 1;
            Find_Token (Input_Line, Node_Name_Set, Start_From, Inside, First,
                        Last);
         end loop;
         Insert (Node_List, Current_Node);
      end loop; -- Process line
   end loop; -- process file
   for Node_Cursor in Node_List.Iterate loop
      for Branch_Cursor in Node_List (Node_Cursor).Branch_List.Iterate loop
         Node_List (Find (Node_List,
                    Node_List (Node_Cursor).
                      Branch_List(Branch_Cursor).Branch_Name)).
           Is_Child := True;
      end loop; -- traverse brabch list
   end loop;  -- traverse nodes
   for Node_Cursor in Node_List.Iterate loop
      if not Node_List(Node_Cursor).Is_Child then
         Put_Line ("Tree root:" &
                     To_String (Node_List (Node_Cursor).Node_Name));
         Root_Node := Node_Cursor;
      end if;
   end loop;
   Traverse_Tree (Root_Node, Total_Weight, 0);
   for Node_Cursor in Node_List.Iterate loop
      Check_Balance (Node_Cursor, Top, Bottom, Majority,
                     Top_Branch, Bottom_Branch);
      if Top /= Bottom then
         If Bottom /= Majority then
            Put_Line (To_String (Node_List (Node_Cursor).Branch_List
                      (Bottom_Branch).Branch_Name) & " Depth:" &
                        Natural'Image (Node_List (Find (Node_List,
                        Node_List (Node_Cursor).
                          Branch_List(Bottom_Branch).Branch_Name)).Depth));
            Put_Line ("Correct Weight:" &
                        Natural'Image (Node_List (Find (Node_List,
                        Node_List (Node_Cursor).
                          Branch_List(Bottom_Branch).Branch_Name)).Weight
                        + Majority -Bottom));
         elsif Top /= Majority then
            Put_Line (To_String (Node_List (Node_Cursor).Branch_List
                      (Top_Branch).Branch_Name) & " Depth:" &
                        Natural'Image (Node_List (Find (Node_List,
                        Node_List (Node_Cursor).
                          Branch_List(Top_Branch).Branch_Name)).Depth));
            Put_Line ("Correct Weight:" &
                        Natural'Image (Node_List (Find (Node_List,
                        Node_List (Node_Cursor).
                          Branch_List(Top_Branch).Branch_Name)).Weight
                        + Majority -Top));
         end if;
      end if; -- unbalanced disc
   end loop;  -- traverse nodes
end December_07;
