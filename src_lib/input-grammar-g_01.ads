with OpenToken.Token.Enumerated.String;

with Input.Lexer;

package Input.Grammar.G_01 is

   package String_Token is new Lexer.Master_Token.String;

   Feeder : aliased OpenToken.Text_Feeder.String.Instance;

   Analyzer : constant Lexer.Tokenizer.Handle :=
   Lexer.Tokenizer.Initialize (Lexer.Syntax, Feeder'Access);

   procedure Build_Project
   (Match : in out OpenToken.Token.Selection.Instance;
    From  : in     OpenToken.Token.Class);

   Project_Start_Token : constant Master_Token.Handle := Syntax (Project_Start_ID).Token_Handle;
   Project_Stop_Token  : constant Master_Token.Handle := Syntax (Project_Stop_ID).Token_Handle;

   Package_Start_Token : constant Master_Token.Handle := Syntax (Package_Start_ID).Token_Handle;
   Package_Stop_Token  : constant Master_Token.Handle := Syntax (Package_Stop_ID).Token_Handle;


   function Root return OpenToken.Token.Handle;

   function Project_Def return OpenToken.Token.Handle;

   function Output_Directory_Def return OpenToken.Token.Handle;

   --
   --  Project:          P
   --  Output_Directory: OD
   --  package_list:     PL
   --
   --  P  -> PROJECT_START OD PL PROJECT_STOP
   --  OD -> OUTPUT_DIRECTORY STRING
   --  PL -> PL1 P | PL1
   --  PL1 ->  | PL

end Input.Grammar.G_01;
