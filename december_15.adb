with Ada.Text_IO; use Ada.Text_IO;
with Interfaces; use Interfaces;
with Generators;

procedure December_15 is

   -- package Generator_A is new Generators (65, 16807); -- Example
   package Generator_A is new Generators (703, 16807);

   -- package Generator_B is new Generators (8921, 48271); -- Example
   package Generator_B is new Generators (516, 48271);

   Mask_16 : constant Unsigned_32 := 16#FFFF#;

   Generator_A_Result, Generator_B_Result : Unsigned_32;

   Count : Natural := 0;
   Count_Part_2 : Natural := 0;

begin -- December_15
   for I in Natural range 1 .. 40000000 loop
      if (Generator_A.Sample and Mask_16) =
        (Generator_B.Sample and Mask_16) then
         Count := Count + 1;
      end if;
   end loop;
   Put_Line ("Count:" & Natural'Image (Count));
   Generator_A.Reset;
   Generator_B.Reset;
   for I in Natural range 1 .. 5000000 loop
      Generator_A_Result := Generator_A.Sample;
      while Generator_A_Result mod 4 /= 0 loop
         Generator_A_Result := Generator_A.Sample;
      end loop;
      Generator_B_Result := Generator_B.Sample;
      while Generator_B_Result mod 8 /= 0 loop
         Generator_B_Result := Generator_B.Sample;
      end loop;
      if (Generator_A_Result and Mask_16) =
        (Generator_B_Result and Mask_16) then
         Count_Part_2 := Count_Part_2 + 1;
      end if;
   end loop;
   Put_Line ("Count Part 2:" & Natural'Image (Count_Part_2));
end December_15;
