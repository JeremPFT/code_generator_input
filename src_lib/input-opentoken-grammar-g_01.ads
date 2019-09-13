with OpenToken.Text_Feeder.Text_IO;
with OpenToken.Token.Enumerated.String;
with OpenToken.Token.Linked_List;
with OpenToken.Token.Sequence_Mixin;

with Input.OpenToken.Lexer;

package Input.OpenToken.Grammar.G_01 is

   pragma Warnings (Off, "anonymous access type allocator");
   package String_Token is new Input.OpenToken.Lexer.Master_Token.String;
   pragma Warnings (On, "anonymous access type allocator");

   Input_File : aliased T_IO.File_Type;
   Feeder : aliased Standard.OpenToken.Text_Feeder.Text_IO.Instance
   := Standard.OpenToken.Text_Feeder.Text_IO.Create (Input_File'Unchecked_Access);

   Analyzer : constant Lexer.Tokenizer.Handle :=
   Lexer.Tokenizer.Initialize (Input.OpenToken.Lexer.Syntax, Feeder'Access);

   ----------------------------------------------------------------------
   --
   --  S   -> PRJ EOF                                                           print (Project)
   --  PRJ -> PRJ_START name OD PRJ_STOP                                        Project = name + output_directory
   --  OD  -> OUTPUT String                                                     set output_directory
   --
   -- with:
   --
   --  S         = start
   --  PRJ       = project
   --  PRJ-N     = project name
   --  OD        = output directory
   --  PRJ_START = terminal "project"
   --  PRJ_STOP  = terminal "end_project"
   --  OUTPUT    = terminal "output"
   ----------------------------------------------------------------------

   package Master_Token renames Lexer.Master_Token;

   package String_Sequence is
   new Standard.OpenToken.Token.Sequence_Mixin (String_Token.Instance);

   procedure Print_Project
   (Match : in out String_Sequence.Instance;
    Using : in     Standard.OpenToken.Token.Linked_List.Instance);

   procedure Read_Project
   (Match : in out String_Sequence.Instance;
    Using : in     Standard.OpenToken.Token.Linked_List.Instance);

   procedure Read_Output_Directory
   (Match : in out String_Sequence.Instance;
    Using : in     Standard.OpenToken.Token.Linked_List.Instance);

   --  terminals
   Project_Start : constant Master_Token.Handle := Lexer.Syntax (Lexer.Project_Start_ID).Token_Handle;
   Project_Stop  : constant Master_Token.Handle := Lexer.Syntax (Lexer.Project_Stop_ID).Token_Handle;
   Output_Dir    : constant Master_Token.Handle := Lexer.Syntax (Lexer.Output_Directory_ID).Token_Handle;
   EOF           : constant Master_Token.Handle := Lexer.Syntax (Lexer.EOF_ID).Token_Handle;
   ID            : constant Master_Token.Handle := Lexer.Syntax (Lexer.Identifier_ID).Token_Handle;
   Str           : constant String_Token.Handle := new String_Token.Class'(String_Token.Get (Lexer.String_ID));

   --  non terminals
   use type String_Sequence.Instance;
   --  use type String_Token.Instance;

   --  Od  : constant String_Sequence.Handle := Output_Dir & Str + Read_Output_Directory'Access;
   --  Prj : constant String_Sequence.Handle := Project_Start & ID & Od + Read_Project'Access;

   --  Prj : constant String_Sequence.Handle := Project_Start & ID & Project_Stop + Read_Project'Access;
   Prj : constant String_Sequence.Handle := Project_Start & ID & Project_Stop + Read_Project'Access;
   S   : constant String_Sequence.Handle := Prj & EOF + Print_Project'Access;

end Input.OpenToken.Grammar.G_01;
