package body Input.OpenToken.Grammar.G_01 is

   ---------------------
   --  Print_Project  --
   ---------------------

   procedure Print_Project
   (Match : in out String_Sequence.Instance;
    Using : in     Standard.OpenToken.Token.Linked_List.Instance)
   is
   begin
      T_IO.Put_Line ("print_project");
   end Print_Project;

   --------------------
   --  Read_Project  --
   --------------------

   procedure Read_Project
   (Match : in out String_Sequence.Instance;
    Using : in     Standard.OpenToken.Token.Linked_List.Instance)
   is
   begin
      T_IO.Put_Line ("read_project");
      null;
   end Read_Project;

   -----------------------------
   --  Read_Output_Directory  --
   -----------------------------

   procedure Read_Output_Directory
   (Match : in out String_Sequence.Instance;
    Using : in     Standard.OpenToken.Token.Linked_List.Instance)
   is
   begin
      T_IO.Put_Line ("read_output_directory");
      null;
   end Read_Output_Directory;

end Input.OpenToken.Grammar.G_01;
