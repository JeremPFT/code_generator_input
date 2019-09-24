with Opentoken.Recognizer;
with Opentoken.Production;
with Opentoken.Production.List;
with Opentoken.Production.Parser;
with Opentoken.Production.Parser.Lalr;
with Opentoken.Token.Enumerated;
with Opentoken.Token.Enumerated.Analyzer;
with Opentoken.Token.Enumerated.List;
with Opentoken.Token.Enumerated.Nonterminal;

package Input.Opentok.Grammar.G_01 is

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

   function "+"
     (Token_Id : in Token_Ids_T)
     return Master_Token.Handle
     is (Symbols (Token_Id));

   function "-"
     (Token_Id : in Token_Ids_T)
     return Nonterminal.Handle
     is (Nonterminal.Handle (Symbols (Token_Id)));

   pragma Precondition (Token_Id > Last_Terminal);

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

   procedure Print_Project
     (New_Token :    out Nonterminal.Class;
      Source    : in     Token_List.Instance'Class;
      To_Id     : in     Master_Token.Token_Id);

   use type Token_List.Instance;
   use type Production.Right_Hand_Side;
   use type Production.Instance;
   use type Production_List.Instance;

   Grammar : constant Production_List.Instance :=
     (-S_Prime_Id) <= (+Prj_Id) & (+Eof_Id) + Print_Project'Access
     and
     (-Prj_Id)     <= (+Project_Start_Id) & (+Id_Id) & (+Project_Stop_Id)
   ;

end Input.Opentok.Grammar.G_01;
