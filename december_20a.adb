with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Assertions; use Ada.Assertions;

procedure December_20a is
   -- Alternative solution tp part 1 only

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

   Least_Acceleration : Natural;
   Closest_Particle : Particle_Indices;

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

begin -- December_20a
   -- Part 1
   Read_Particles (Particle_Array);
   for I in Particle_Indices loop
      if I = Particle_Indices'First then
         Least_Acceleration := abs (Particle_Array (I).Acceleration (X)) +
         abs (Particle_Array (I).Acceleration (Y)) +
         abs (Particle_Array (I).Acceleration (Z));
         Closest_Particle := I;
      elsif abs (Particle_Array (I).Acceleration (X)) +
      abs (Particle_Array (I).Acceleration (Y)) +
      abs (Particle_Array (I).Acceleration (Z)) < Least_Acceleration then
         Least_Acceleration := abs (Particle_Array (I).Acceleration (X)) +
         abs (Particle_Array (I).Acceleration (Y)) +
         abs (Particle_Array (I).Acceleration (Z));
         Closest_Particle := I;
      end if;
   end loop;
   Put_Line ("Closest particle:" & Particle_Indices'Image (Closest_Particle));
end December_20a;
