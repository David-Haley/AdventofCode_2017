package body Knot_Hash is

   function Hash (Text : in Unbounded_String) return Hash_Results is

   subtype Length_Counts is Natural range 0 .. Hash_Table_Size;
   type Hash_Table_Indices is mod Hash_Table_size;
      type Hash_Tables is array (Hash_Table_Indices) of Unsigned_8;

   Hash_Table :Hash_Tables;

   Hash_Result : Hash_Results;

   Current_Position, Skip_Size : Hash_Table_Indices;
   Stream_Length : Natural;
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

begin -- Hash
   Stream_Length := Ada.Strings.Unbounded.Length (Text);
   Initialise (Hash_Table);
   Current_Position := Hash_Table_Indices'First;
   Skip_Size := 0;
   declare -- Length_List
      subtype Length_Indices is Positive range 1 .. Stream_Length + 5;
      Length_Table : array (Length_Indices) of Unsigned_8;
   begin -- Length_List
      for I in Positive range 1 .. Stream_Length loop
         Length_Table (I) := Character'Pos (Element (Text, I));
      end loop; -- I in Positive range 1 .. Unbounded_String.Length (Text)
      -- appen d17, 31, 73, 47, 23
      Length_Table (Length_Table'Last) := 23;
      Length_Table (Length_Table'Last - 1) := 47;
      Length_Table (Length_Table'Last - 2) := 73;
      Length_Table (Length_Table'Last - 3) := 31;
      Length_Table (Length_Table'Last - 4) := 17;
      for Hash_Round in Positive range 1 .. 64 loop
         for Length_Index in Length_Indices loop
            Length := Length_Counts (Length_Table (Length_Index));
            Reverse_Slice (Hash_Table, Current_Position, Length);
            Current_Position := Current_Position +
              Hash_Table_Indices ((Length)  mod  Hash_Table_Size) + Skip_Size;
            Skip_Size := Skip_Size + 1;
         end loop; -- Length_Table_Index in Length_Table_Indices
      end loop; -- Hash_Round
   end; -- Length_List
   Hash_Result := (others => 0);
   for Block_index in Block_Indices loop
      for Byte_index in Byte_indices loop
         Hash_Result (Block_index) := Hash_Result (Block_index) xor
           Hash_Table (Hash_Table_Indices (Block_index * Block_Size +
                           Byte_Index));
      end loop; -- Byte_index in Result in  Byte_indices;
   end loop; -- Block_Indices
   return Hash_Result;
end Hash;

end Knot_Hash;
