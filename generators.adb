package body Generators is

   Previous_Sample : Unsigned_64;

   function Sample return Unsigned_32 is

      Divisor : constant Unsigned_32 := 2147483647;

   begin -- Sample
      Previous_Sample := Previous_Sample * Unsigned_64 (Factor);
      Previous_Sample := Previous_Sample mod Unsigned_64 (Divisor);
      return Unsigned_32 (Previous_Sample);
   end Sample;

   procedure Reset is
      -- reloads Seed

   begin -- Reset
      Previous_Sample := Unsigned_64 (Seed);
   end Reset;

begin -- Generators
   Previous_Sample := Unsigned_64 (Seed);
end Generators;
