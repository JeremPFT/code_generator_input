with OpenToken.Production;
with OpenToken.Production.List;
with OpenToken.Production.List.LALR;
with OpenToken.Token.Enumerated;
with OpenToken.Token.Enumerated.Analyzer;
with OpenToken.Token.Enumerated.List;
with OpenToken.Token.Enumerated.Nonterminal;

package Input.Opentok.Grammar_01 is

   package Lexical_Parser is

      type Token_IDs_T is
        (
         -- begin keywords
         Project_Start_ID,
         Project_End_ID,
         -- end keywords
         Filename_ID,
         Whitespace_ID,
         ID_ID,

         -- nonterminals
         Prj_ID,

         Root_ID
        );

      package Master_Token is new OpenToken.Token.Enumerated (Token_IDs);

      package Tokenizer is new Master_Token.Analyzer (Whitespace_ID);

      package Token_List is new Master_Token.List;

      package Nonterminal is new Master_Token.Nonterminal (Token_List);

   end Lexical_Parser;

   use Lexical_Parser;

   --  package Grammar is

   --  S' -> Prj
   --  Prj -> Project_Start Id Project_Stop

   package Production is
     new OpenToken.Production (Token       => Master_Token,
                               Token_List  => Token_List,
                               Nonterminal => Nonterminal);

   package Production_List is new Production.List;

   package Parser is new Production.Parser (Production_List, Tokenizer);

   package LALR_Parser is new Parser.LALR;

   package Symbols is

      Project_Start : aliased Master_Token.Class := Master_Token.Get (Project_Start_ID);
      Project_Stop  : aliased Master_Token.Class := Master_Token.Get (Project_Stop_ID);
      ID            : aliased Master_Token.Class := Master_Token.Get (ID_ID);
      EOF           : aliased Master_Token.Class := Master_Token.Get (EOF_ID);
      Whitespace    : aliased Master_Token.Class := Master_Token.Get (Whitespace_ID);

      Prj     : aliased Nonterminal.Class := Nonterminal.Get (Prj_ID);
      S_Prime : aliased Nonterminal.Class := Nonterminal.Get (S_Prime_ID);

   end Symbols;



   package Recognizers is

      Project_Start : OpenToken.Recognizable.Keyword.Get
        (Keyword_Literal => "project",
         Case_Sensitive  => True,
         Reportable      => True);

      Project_Start : OpenToken.Recognizable.Keyword.Get
        (Keyword_Literal => "end_project",
         Case_Sensitive  => True,
         Reportable      => True);

      ID : OpenToken.Recognizable.Identifier.Get
        (Start_Chars => Ada.Strings.Maps.Constants.Letter_Set,
         Body_Chars  => Ada.Strings.Maps.Constants.Alphanumeric_Set);

      EOF : OpenToken.Recognizable.End_Of_File.Get
        (Reportable => True);

      Whitespace : OpenToken.Recognizer.Character_Set.Get
        (Set        => OpenToken.Recognizer.Character_Set.Standard_Whitespace,
         Reportable => False);

   end Recognizers;

   Syntax : constant Tokenizer.Syntax :=
     (Project_Start_ID => Tokenizer.Get (Recognizers.Project_Start,
                                         Symbols.Project_Start),
      Project_Stop_ID  => Tokenizer.Get (Recognizers.Project_Stop,
                                         Symbols.Project_Stop),
      ID               => Tokenizer.Get (Recognizers.ID,
                                         Symbols.ID)
     );

   --  Project_Start_Map : constant Tokenizer.Recognizable_Token :=
   --  Tokenizer.Get (Recognizer => Project_Start_Reco,
   --  New_Token  => Project_Start);

   --  Project_Stop_Map : constant Tokenizer.Recognizable_Token :=
   --  Tokenizer.Get (Recognizer => OpenToken.Recognizer.Keyword.Get ("end_project"),
   --  New_Token  => Project_Stop);

   --  use Ada.Strings.Maps.Constants; -- letter_set, alphanumeric_set

   --  ID : constant Tokenizer.Recognizable_Token :=
   --  Tokenizer.Get (Recognizer => OpenToken.Recognizer.Identifier.Get (Start_Chars => Letter_Set,
   --  Body_Chars => Alphanumeric_Set),
   --  New_Token  => Project_Stop);
   --  end Map;

   --  Syntax : constant Tokenizer.Syntax :=

   --  (Asterix_ID => Tokenizer.Get (Recognizer => OpenToken.Recognizer.Keyword.Get ("*"),
   --  New_Token => Asterix),

   --  ID_ID                             => Tokenizer.Get (Recognizer => OpenToken.Recognizer.Keyword.Get ("id"),
   --  New_Token => ID),

   --  Equals_ID                             => Tokenizer.Get (Recognizer => OpenToken.Recognizer.Keyword.Get ("="),
   --  New_Token => Equals),

   --  EOF_ID                             => Tokenizer.Get (Recognizer => OpenToken.Recognizer.End_Of_File.Get,
   --  New_Token => EOF),

   --  Whitespace_ID                                                                                     => Tokenizer.Get
   --  (OpenToken.Recognizer.Character_Set.Get
   --  (OpenToken.Recognizer.Character_Set.Standard_Whitespace))
   --  );

   --  end Grammar;

end Input.Opentok.Grammar_01;
