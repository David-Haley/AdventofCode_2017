with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Interfaces; use Interfaces;

package Knot_Hash is

   Hash_Table_Size : constant Positive := 256;
   Block_Size : constant Positive := 16;
   subtype Block_Indices is Natural range 0 .. Hash_Table_Size / Block_Size - 1;
   type Hash_Results is array (Block_Indices) of Unsigned_8;

   function Hash (Text : in Unbounded_String) return Hash_Results;

private
   subtype Byte_Indices is Natural range 0 .. Block_Size - 1;
end Knot_Hash;
