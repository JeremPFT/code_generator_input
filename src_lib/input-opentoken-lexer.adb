with Ada.Strings.Maps.Constants;

--  with Opentoken.Recognizer.Based_Integer_Ada_Style;
--  with Opentoken.Recognizer.Based_Real_Ada_Style;
with OpenToken.Recognizer.Character_Set;
with OpenToken.Recognizer.End_Of_File;
--  with OpenToken.Recognizer.Graphic_Character;
with OpenToken.Recognizer.Identifier;
--  with Opentoken.Recognizer.Integer;
with OpenToken.Recognizer.Keyword;
with OpenToken.Recognizer.Line_Comment;
with OpenToken.Recognizer.Nothing;
--  with Opentoken.Recognizer.Real;
with OpenToken.Recognizer.Separator;
with OpenToken.Recognizer.String;
with OpenToken.Text_Feeder.Text_IO;

package body Input.OpenToken.Lexer is

   procedure Initialize_Syntax;

   procedure Initialize_Analyzer;

   Full_Syntax : aliased Tokenizer.Syntax;
   function Syntax return Tokenizer.Syntax is (Full_Syntax);

   Analyzer : aliased Tokenizer.Handle;

   ------------------------
   --  Initialize_Lexer  --
   ------------------------

   procedure Initialize
   is
   begin
      Initialize_Syntax;
      Initialize_Analyzer;
   end Initialize;

   --------------
   --  Syntax  --
   --------------

   procedure Initialize_Syntax
   is
      package Reco renames Standard.OpenToken.Recognizer;

      Letter_Set : Ada.Strings.Maps.Character_Set
      renames Ada.Strings.Maps.Constants.Letter_Set;

      Alphanumeric_Set : Ada.Strings.Maps.Character_Set
      renames Ada.Strings.Maps.Constants.Alphanumeric_Set;

      Standard_Whitespace : Ada.Strings.Maps.Character_Set
      renames Reco.Character_Set.Standard_Whitespace;

   begin
      for Token_Index in Token_ID_T loop
         case Token_Index is

         when First_Keyword_Token .. Last_Keyword_Token =>

            Full_Syntax (Token_Index) := Tokenizer.Get
            (Reco.Keyword.Get
             (Keyword_Literal => Keywords (Token_Index).all,
              Case_Sensitive  => True,
              Reportable      => True));

         when First_Separator_Token .. Last_Separator_Token =>

            Full_Syntax (Token_Index) := Tokenizer.Get
            (Reco.Separator.Get
             (Separator_Literal => Separators (Token_Index).all,
              Reportable        => True));

         when Comment_ID =>

            Full_Syntax (Token_Index) := Tokenizer.Get
            (Reco.Line_Comment.Get
             (Comment_Introducer => "--",
              Reportable         => False));

         when Whitespace_ID =>

            Full_Syntax (Token_Index) := Tokenizer.Get
            (Reco.Character_Set.Get
             (Set        => Standard_Whitespace,
              Reportable => False));

         when Identifier_ID =>

            Full_Syntax (Token_Index) := Tokenizer.Get
            (Reco.Identifier.Get
             (Start_Chars   => Letter_Set,
              Body_Chars    => Alphanumeric_Set,
              Has_Separator => True));

         when String_ID =>

            Full_Syntax (Token_Index) := Tokenizer.Get
            (Reco.String.Get);

         when EOF_ID =>

            Full_Syntax (Token_Index) := Tokenizer.Get
            (Reco.End_Of_File.Get (Reportable => True));

         when Bad_Token_ID =>

            Full_Syntax (Token_Index) := Tokenizer.Get
            (Reco.Nothing.Get (Reportable => True));

         end case;
      end loop;
   end Initialize_Syntax;

   ----------------
   --  Analyzer  --
   ----------------

   procedure Initialize_Analyzer
   is
   begin
      Analyzer := Tokenizer.Initialize (Syntax);
   end Initialize_Analyzer;

   ------------------------
   --  Set_Input_Feeder  --
   ------------------------

   procedure Set_Input_Feeder
   (File : in Ada.Text_IO.File_Type)
   is
   begin
      Dbg.Put_Line ("Set_Input_Feeder");

      T_IO.Set_Input (File);
      Analyzer.Set_Text_Feeder
      (Standard.OpenToken.Text_Feeder.Text_IO.Create (T_IO.Current_Input));
   end Set_Input_Feeder;

   ---------------------------
   --  Set_Action_On_Error  --
   ---------------------------

   procedure Set_Action_On_Error
   (Action: in On_Error_Action_T)
   is
   begin
      case Action is
      when Raise_Exception => Analyzer.Unset_Default;

      when Return_Bad_Token => Analyzer.Set_Default (Bad_Token_ID);
      end case;
   end Set_Action_On_Error;

   -------------------------------
   --  Set_Comments_Reportable  --
   -------------------------------

   procedure Set_Comments_Reportable
   (To : in Boolean)
   is
      pragma Unreferenced (To);
   begin
      null;
   end Set_Comments_Reportable;

   -----------------
   --  Find_Next  --
   -----------------

   --  Exclusion : constant array (Boolean) of Ada.Strings.Maps.Character_Set :=
   --    (False => Ada.Strings.Maps.Null_Set,                -- character literal enabled
   --     True  => Ada.Strings.Maps.Constants.Graphic_Set);  --                   disabled

   procedure Find_Next
   is
   begin
      Analyzer.Find_Next (Look_Ahead => False);

      --  OpenToken.Recognizer.Graphic_Character.Redefine
      --    (OpenToken.Recognizer.Graphic_Character.Instance
      --       (Syntax (Character_Id).Recognizer.all),
      --     Exclusion (Token_Id = Identifier_Id));
   end Find_Next;

   ------------
   --  Line  --
   ------------

   function Line return Natural
   is
   begin
      return Analyzer.Line;
   end Line;

   --------------
   --  Column  --
   --------------

   function Column return Natural
   is
   begin
      return Analyzer.Column;
   end Column;

   ----------------
   --  Token_Id  --
   ----------------

   function Token_ID return Token_ID_T
   is
   begin
      return Analyzer.ID;
   end Token_ID;

   --------------
   --  Lexeme  --
   --------------

   function Lexeme return String
   is
   begin
      return Analyzer.Lexeme;
   end Lexeme;

begin
   Initialize;
end Input.OpenToken.Lexer;
