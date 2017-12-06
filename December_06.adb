with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Doubly_Linked_Lists;

procedure December_06 is

   Step_Count, Element_Count : Natural := 0;
   Input_File : File_Type;
   Memory_Size : constant := 16;
   type Bank_Indices is mod Memory_Size;
   type Memory_Banks is array (Bank_Indices) of Natural;

   package State_Stores is new Ada.Containers.Doubly_Linked_Lists
     (Memory_Banks);
   use State_Stores;

   State_Store : List := empty_List;
   Current_Bank : Memory_Banks;
   Maximum : Natural;
   Maximum_Index, Index : Bank_Indices;

   package Nat_IO is new Integer_IO (Natural); use Nat_IO;

begin -- December_06
   Open (Input_File, In_File, "20171206.txt");
   Maximum := 0;
   for Index in Bank_Indices loop
      Get (input_File, Current_Bank (Index));
      if Current_Bank (Index) > Maximum then
         Maximum := Current_Bank (Index);
         Maximum_Index := Index;
      end if; -- Current_Bank (Index) > Maximum
   end loop;
   Append (State_Store, Current_Bank);
   loop
      Step_Count := Step_Count + 1;
      Current_Bank (Maximum_Index) := 0;
      Index := Maximum_Index + 1;
      while Maximum > 0 loop
         Current_Bank (Index) := Current_Bank (Index) + 1;
         Maximum := Maximum - 1;
         Index := Index + 1;
      end loop; -- level memory
      if Contains (State_Store, Current_Bank) then
         exit;
      end if;
         Append (State_Store, Current_Bank);
         Maximum := 0;
         for Index in Bank_Indices loop
            if Current_Bank (Index) > Maximum then
               Maximum := Current_Bank (Index);
               Maximum_Index := Index;
            end if; -- Current_Bank (Index) > Maximum
         end loop;
   end loop; -- until a repeat occurs
   Put_Line ("Step Count:" & Natural'Image (Step_Count));
end December_06;
