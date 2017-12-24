with Ada.Text_IO; use Ada.Text_IO;

procedure December_23a is

   A : Long_Long_Integer := 1;
   B, C, D, E, F, G, H : Long_Long_Integer := 0;

begin -- December_23a is
   -- 01: set b 65
   B := 65;
   -- 02: set c b
   C := B;
   -- 03: jnz a 2
   if A /= 0 then
      goto Label_5;
   end if;
   -- 04: jnz 1 5
   goto Label_9;
   -- 05: mul b 100
   <<Label_5>>
   B := B * 100;
   -- 06: sub b -100000
   B := B + 100000;
   -- 07: set c b
   C := B;
   -- 08: sub c -17000
   C := C + 17000;
   -- 09: set f 1
   <<Label_9>>
   F := 1;
   -- 10: set d 2
   D := 2;
   -- 11: set e 2
   <<Label_11>>
   E := 2;
   -- 12: set g d
   <<Label_12>>
   G := D;
   -- 13: mul g e
   G := G * E;
   -- 14: sub g b
   G := G - B;
   -- 15: jnz g 2
   if G /= 0 then
      goto Label_17;
   end if;
   -- 16: set f 0
   F := 0;
   -- 17: sub e -1
   <<Label_17>>
   E := E + 1;
   -- 18: set g e
   G := E;
   -- 19: sub g b
   G := G - B;
   -- 20: jnz g -8
   if G /= 0 then
      goto Label_12;
   end if;
   -- 21: sub d -1
   D := D + 1;
   -- 22: set g d
   G := D;
   -- 23: sub g b
   G := G - B;
   -- 24: jnz g -13
   if G /= 0 then
      goto Label_11;
   end if;
   -- 25: jnz f 2
   if F /= 0 then
      goto Label_27;
   end if;
   -- 26: sub h -1
   H := H + 1;
   Put_Line ("H:" & Long_Long_Integer'Image (H));
   -- 27: set g b
   <<Label_27>>
   G := B;
   -- 28: sub g c
   G := G - C;
   -- 29: jnz g 2
   if G /= 0 then
      goto Label_31;
   end if;
   -- 30: jnz 1 3
   goto Label_33;
   -- 31: sub b -17
   <<Label_31>>
   B := B + 17;
   -- 32 jnz 1 -23
   goto Label_9;
   <<Label_33>>
   Put_Line ("Normal Termination, H:" & Long_Long_Integer'Image (H));
end December_23a;
