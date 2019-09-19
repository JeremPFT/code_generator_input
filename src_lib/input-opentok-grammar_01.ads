with Opentoken.Recognizer;
with Opentoken.Production;
with Opentoken.Production.List;
with Opentoken.Production.Parser;
with Opentoken.Production.Parser.Lalr;
with Opentoken.Token.Enumerated;
with Opentoken.Token.Enumerated.Analyzer;
with Opentoken.Token.Enumerated.List;
with Opentoken.Token.Enumerated.Nonterminal;

package Input.Opentok.Grammar_01 is

   package Lexical_Parser is

      type Token_Ids_T is
        (
         -- begin keywords
         Project_Start_Id,
         Project_Stop_Id,
         -- end keywords
         Id_Id,
         Whitespace_Id,

         Eof_Id,
         -- nonterminals
         Prj_Id,

         S_Prime_Id
        );

      First_Terminal : constant Token_Ids_T := Project_Start_Id;
      Last_Terminal  : constant Token_Ids_T := Eof_Id;

      pragma Warnings (Off, "use of an anonymous access type allocator");
      package Master_Token is new Opentoken.Token.Enumerated
        (Token_Id       => Token_Ids_T,
         First_Terminal => First_Terminal,
         Last_Terminal  => Last_Terminal,
         Token_Image    => Token_Ids_T'Image);

      package Tokenizer is new Master_Token.Analyzer;

      package Token_List is new Master_Token.List;


      package Nonterminal is new Master_Token.Nonterminal (Token_List);

      pragma Warnings (On, "use of an anonymous access type allocator");

   end Lexical_Parser;

   use Lexical_Parser;

   package Production is
     new Opentoken.Production (Token       => Master_Token,
                               Token_List  => Token_List,
                               Nonterminal => Nonterminal);

   package Production_List is new Production.List;

   package Parser is new Production.Parser (Tokenizer);

   package Lalr_Parser is new Parser.Lalr (First_State_Index => 0);

   type Symbol_Array_T is
     array (Lexical_Parser.Token_Ids_T) of Master_Token.Handle;

   function Symbols return Symbol_Array_T;

   type Recognizer_Array_T is
     array (Lexical_Parser.Token_Ids_T range First_Terminal .. Last_Terminal)
     of Opentoken.Recognizer.Handle;

   function Recognizers return Recognizer_Array_T;

   ----------------------------------------------------------------------
   --
   --  S' -> Prj
   --  Prj -> Project_Start Id Project_Stop
   --
   ----------------------------------------------------------------------

   Grammar : constant Production_List.Instance :=
     Symbols (S_Prime_Id) <= Symbols (Prj_Id) & Symbols (Eof_Id)
     and
     Symbols (Prj_Id)     <= Symbols (Project_Start_Id) & Symbols (Id_Id) & Symbols (Project_Stop_Id)
   ;

end Input.Opentok.Grammar_01;
