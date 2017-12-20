with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Assertions; use Ada.Assertions;

procedure December_20 is

   Number_Of_Particles : constant Natural := 1000;
   subtype Particle_Indices is Natural range 0 .. Number_Of_Particles - 1;

   type Cardinals is (X, Y, Z);

   type Positions is array (Cardinals) of Integer;
   type Velocities is array (Cardinals) of Integer;
   type Accelerations is array (Cardinals) of Integer;

   type Particles is record
      Position : Positions;
      Velocity : Velocities;
      Acceleration : Accelerations;
      Exists : Boolean := True;
   end record;

   type Particle_Arrays is array (Particle_Indices) of Particles;

   Particle_Array : Particle_Arrays;

   package Int_IO is new Ada.Text_IO.Integer_IO (Integer); use Int_IO;

   procedure Read_Particles (Particle_Array : out Particle_Arrays) is

      Input_File : File_Type;
      Pos_String : constant String := "p=<";
      Vel_String : constant String := ">, v=<";
      Acc_String : constant String := ">, a=<";
      String_3 : String (1 .. 3);
      String_6 : String (1 .. 6);
      Delimiter : constant Character := ',';
      Char : Character;

      procedure Remove_Comma (Cardinal : in Cardinals) is

      begin -- Remove_Comma
         if Cardinal /= Cardinals'Last then
            Get (Input_File, Char);
            Assert (Char = Delimiter, "Expected " & Delimiter & " found " &
                      Char);
         end if;
      end Remove_Comma;

   begin -- Read_Particles
      Open (Input_File, In_File, "20171220.txt");
      for Particle_Index in Particle_Indices loop
         Get (Input_File, String_3);
         Assert (String_3 = Pos_String, "Expected " & Pos_String & " found " &
                   String_3);
         for I in Cardinals loop
            Get ( Input_File, Particle_Array (Particle_Index).Position (I));
            Remove_Comma (I);
         end loop;
         Get (Input_File, String_6);
         Assert (String_6 = Vel_String, "Expected " & Vel_String & " found " &
                   String_6);
         for I in Cardinals loop
            Get ( Input_File, Particle_Array (Particle_Index).Velocity (I));
            Remove_Comma (I);
         end loop;
         Get (Input_File, String_6);
         Assert (String_6 = Acc_String, "Expected " & Acc_String & " found " &
                   String_6);
         for I in Cardinals loop
            Get ( Input_File, Particle_Array (Particle_Index).Acceleration (I));
            Remove_Comma (I);
         end loop;
         Skip_Line (Input_File);
      end loop; -- loop on Particle
      Close (Input_File);
   end Read_Particles;

   procedure Update_Particles (Particle_Array : in out Particle_Arrays) is

   begin -- Update_Particles
      for Particle_Index in Particle_Indices loop
         if Particle_Array (Particle_Index).Exists then
            for I in Cardinals loop
               Particle_Array (Particle_Index).Velocity (I) :=
                 Particle_Array (Particle_Index).Velocity (I) +
                 Particle_Array (Particle_Index).Acceleration (I);
               Particle_Array (Particle_Index).Position (I) :=
                 Particle_Array (Particle_Index).Position (I) +
                 Particle_Array (Particle_Index).Velocity (I);
            end loop;  -- I in Cardinals
         end if; -- Particle_Array (Particle_Index).exists
      end loop; --  Particle_Index in Particle_Indices
   end Update_Particles;

   procedure Put_Minimum (Particle_Array : in Particle_Arrays) is

      Distance : Natural;
      Particle : Particle_Indices;

      function Dist (Particle_Index : in Particle_Indices) return Natural is

      begin -- Dist
         return abs (Particle_Array (Particle_Index).Position (X)) +
         abs (Particle_Array (Particle_Index).Position (Y)) +
         abs (Particle_Array (Particle_Index).Position (Z));
      end Dist;

   begin -- Put_Minimum
      for Particle_Index in Particle_Indices loop
         if Particle_Index = Particle_Indices'First then
            Particle := Particle_Index;
            Distance := Dist (Particle_Index);
         elsif Dist (Particle_Index) < Distance then
            Particle := Particle_Index;
            Distance := Dist (Particle_Index);
         end if;
      end loop; -- Particle_Index in Particle_Indices
      Put_Line (Particle_Indices'Image (Particle) & Natural'Image (Distance));
   end Put_Minimum;

   procedure Collide (Particle_Array : in out Particle_Arrays) is

   begin -- Collide
      for Part_1 in Particle_Indices range Particle_Indices'First ..
        Particle_Indices'Last - 1 loop
         for Part_2 in Particle_Indices range Part_1 + 1 ..
           Particle_Indices'Last loop
            if Particle_Array (Part_1).Position (X) =
              Particle_Array (Part_2).Position (X) and then
              Particle_Array (Part_1).Position (Y) =
              Particle_Array (Part_2).Position (Y) and then
              Particle_Array (Part_1).Position (Z) =
              Particle_Array (Part_2).Position (Z) then
               Particle_Array (Part_1).Exists := False;
               Particle_Array (Part_2).Exists := False;
            end if; -- coordinates exactly match
         end loop; -- iterate Part_2
      end loop; -- iterate Part
   end Collide;

   procedure Put_Remaining (Particle_Array : in out Particle_Arrays) is

      Count : Natural := 0;

   begin -- Put_Remaining
      for Particle_Index in Particle_Indices loop
         if Particle_Array (Particle_Index).Exists then
            Count := Count + 1;
         end if; -- Particle_Array (Particle_Index).Exists
      end loop; -- Particle_Index in Particle_Indices
      Put_Line ("Remaining Particles:" & Natural'Image (Count));
   end Put_Remaining;

begin -- December_20
   -- Part 1
   Read_Particles (Particle_Array);
   for I in Natural range 1 .. 393 loop -- iterations reduced after first run
      Update_Particles (Particle_Array);
      Put_Minimum (Particle_Array);
   end loop; -- I in Natural range 1 .. 393 loop
   -- Part 2
   Read_Particles (Particle_Array);
   for I in Natural range 1 .. 39 loop -- iterations reduced after first run
      Update_Particles (Particle_Array);
      Collide (Particle_Array);
      Put_Remaining (Particle_Array);
   end loop;  -- I in Natural range 1 .. 39 loop
end December_20;
