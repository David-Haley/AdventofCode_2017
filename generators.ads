with Interfaces; use Interfaces;

generic

Seed : Unsigned_32;
Factor : Unsigned_32;

package Generators is

   function Sample return Unsigned_32;

   procedure Reset; -- reloads Seed

end Generators;
