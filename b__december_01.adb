pragma Ada_95;
pragma Warnings (Off);
pragma Source_File_Name (ada_main, Spec_File_Name => "b__december_01.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__december_01.adb");
pragma Suppress (Overflow_Check);
with Ada.Exceptions;

package body ada_main is

   E125 : Short_Integer; pragma Import (Ada, E125, "system__os_lib_E");
   E011 : Short_Integer; pragma Import (Ada, E011, "system__soft_links_E");
   E021 : Short_Integer; pragma Import (Ada, E021, "system__exception_table_E");
   E108 : Short_Integer; pragma Import (Ada, E108, "ada__io_exceptions_E");
   E044 : Short_Integer; pragma Import (Ada, E044, "ada__strings_E");
   E046 : Short_Integer; pragma Import (Ada, E046, "ada__strings__maps_E");
   E050 : Short_Integer; pragma Import (Ada, E050, "ada__strings__maps__constants_E");
   E088 : Short_Integer; pragma Import (Ada, E088, "ada__tags_E");
   E107 : Short_Integer; pragma Import (Ada, E107, "ada__streams_E");
   E061 : Short_Integer; pragma Import (Ada, E061, "interfaces__c_E");
   E023 : Short_Integer; pragma Import (Ada, E023, "system__exceptions_E");
   E128 : Short_Integer; pragma Import (Ada, E128, "system__file_control_block_E");
   E123 : Short_Integer; pragma Import (Ada, E123, "system__file_io_E");
   E110 : Short_Integer; pragma Import (Ada, E110, "system__finalization_root_E");
   E105 : Short_Integer; pragma Import (Ada, E105, "ada__finalization_E");
   E112 : Short_Integer; pragma Import (Ada, E112, "system__storage_pools_E");
   E102 : Short_Integer; pragma Import (Ada, E102, "system__finalization_masters_E");
   E100 : Short_Integer; pragma Import (Ada, E100, "system__storage_pools__subpools_E");
   E059 : Short_Integer; pragma Import (Ada, E059, "system__object_reader_E");
   E039 : Short_Integer; pragma Import (Ada, E039, "system__dwarf_lines_E");
   E015 : Short_Integer; pragma Import (Ada, E015, "system__secondary_stack_E");
   E084 : Short_Integer; pragma Import (Ada, E084, "ada__strings__unbounded_E");
   E034 : Short_Integer; pragma Import (Ada, E034, "system__traceback__symbolic_E");
   E121 : Short_Integer; pragma Import (Ada, E121, "ada__text_io_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E121 := E121 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "ada__text_io__finalize_spec");
      begin
         F1;
      end;
      E084 := E084 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "ada__strings__unbounded__finalize_spec");
      begin
         F2;
      end;
      declare
         procedure F3;
         pragma Import (Ada, F3, "system__file_io__finalize_body");
      begin
         E123 := E123 - 1;
         F3;
      end;
      E102 := E102 - 1;
      E100 := E100 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "system__storage_pools__subpools__finalize_spec");
      begin
         F4;
      end;
      declare
         procedure F5;
         pragma Import (Ada, F5, "system__finalization_masters__finalize_spec");
      begin
         F5;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      System.Soft_Links'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E021 := E021 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E108 := E108 + 1;
      Ada.Strings'Elab_Spec;
      E044 := E044 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E050 := E050 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E107 := E107 + 1;
      Interfaces.C'Elab_Spec;
      System.Exceptions'Elab_Spec;
      E023 := E023 + 1;
      System.File_Control_Block'Elab_Spec;
      E128 := E128 + 1;
      System.Finalization_Root'Elab_Spec;
      E110 := E110 + 1;
      Ada.Finalization'Elab_Spec;
      E105 := E105 + 1;
      System.Storage_Pools'Elab_Spec;
      E112 := E112 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Storage_Pools.Subpools'Elab_Spec;
      System.Object_Reader'Elab_Spec;
      System.Dwarf_Lines'Elab_Spec;
      E100 := E100 + 1;
      System.Finalization_Masters'Elab_Body;
      E102 := E102 + 1;
      System.File_Io'Elab_Body;
      E123 := E123 + 1;
      E061 := E061 + 1;
      Ada.Tags'Elab_Body;
      E088 := E088 + 1;
      E046 := E046 + 1;
      System.Soft_Links'Elab_Body;
      E011 := E011 + 1;
      System.Os_Lib'Elab_Body;
      E125 := E125 + 1;
      System.Secondary_Stack'Elab_Body;
      E015 := E015 + 1;
      E039 := E039 + 1;
      E059 := E059 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E084 := E084 + 1;
      System.Traceback.Symbolic'Elab_Body;
      E034 := E034 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E121 := E121 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_december_01");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   C:\Users\David\Documents\Advent_of_code\Source\December_01.o
   --   -LC:\Users\David\Documents\Advent_of_code\Source\
   --   -LC:\Users\David\Documents\Advent_of_code\Source\
   --   -LC:/gnat/2016/lib/gcc/i686-pc-mingw32/4.9.4/adalib/
   --   -static
   --   -lgnat
   --   -Wl,--stack=0x2000000
--  END Object file/option list   

end ada_main;
