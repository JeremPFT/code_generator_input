with Ada.Strings.Maps.Constants;

with Opentoken.Recognizer.Keyword;
with Opentoken.Recognizer.Identifier;
with Opentoken.Recognizer.Character_Set;
--  with Opentoken.Recognizer.End_Of_File;

with Model.Types.Project; use Model.Types.Project;

package body Input.Opentok.Grammar.G_01 is

   function Symbols return Symbol_Array_T
   is
      Result : Symbol_Array_T := (others => null);
      Symbol : Master_Token.Handle := null;
   begin

      for Index in First_Terminal .. Last_Terminal loop
         Symbol := new Master_Token.Instance;
         Symbol.all := Master_Token.Get (Index);
         Result (Index) := Symbol;
      end loop;

      for Index in Token_Ids_T'Succ (Last_Terminal) .. Token_Ids_T'Last loop
         Symbol := new Nonterminal.Instance;
         Symbol.all := Nonterminal.Get (Index);
         Result (Index) := Symbol;
      end loop;

      return Result;
   end Symbols;

   function Recognizers return Recognizer_Array_T
   is
      Result : Recognizer_Array_T := (others => null);

      package Reco_Keyword renames Opentoken.Recognizer.Keyword;
      package Reco_Identifier renames Opentoken.Recognizer.Identifier;
      package Reco_Whitespace renames Opentoken.Recognizer.Character_Set;

   begin
      Result (Project_Start_Id) := new Reco_Keyword.Instance;

      Reco_Keyword.Instance (Result (Project_Start_Id).all)
        := Reco_Keyword.Get
          (Keyword_Literal => "project",
           Case_Sensitive  => True,
           Reportable      => True);

      Result (Project_Stop_Id) := new Reco_Keyword.Instance;

      Reco_Keyword.Instance (Result (Project_Start_Id).all)
        := Reco_Keyword.Get
          (Keyword_Literal => "end_project",
           Case_Sensitive  => True,
           Reportable      => True);

      Result (Id_Id) := new Reco_Identifier.Instance;

      Reco_Identifier.Instance (Result (Id_Id).all) :=
        Reco_Identifier.Get
          (Start_Chars => Ada.Strings.Maps.Constants.Letter_Set,
           Body_Chars  => Ada.Strings.Maps.Constants.Alphanumeric_Set);


      Result (Whitespace_Id) := new Reco_Whitespace.Instance;

      Reco_Whitespace.Instance (Result (Whitespace_Id).all) :=
        Reco_Whitespace.Get
          (Set        => Reco_Whitespace.Standard_Whitespace,
           Reportable => False);

      for J in Recognizer_Array_T'Range loop
         if Opentoken.Recognizer."=" (Result (J), null) then
            raise Constraint_Error with "in Recognizers: missing " & J'Img;
         end if;
      end loop;

      return Result;
   end Recognizers;

   procedure Print_Project
     (New_Token :    out Nonterminal.Class;
      Source    : in     Token_List.Instance'Class;
      To_Id     : in     Token_Ids_T)
   is

      Project_Token : Token_List.List_Iterator
        := Token_List.Initial_Iterator (Source);

      Project_Instance : Project_Class_T := null;

   begin

      Project_Instance := Project_Op.Value (Subject => Source);

      T_IO.Put_Line ("project name: "
                       & Project_Instance.Get_Name);
      T_IO.Put_Line ("project directory: "
                       & Project_Instance.Get_Output_Directory);
      T_IO.Put_Line ("number of packages: "
                       & Project_Instance.Number_Of_Packages'Img);

   end Print_Project;

end Input.Opentok.Grammar.G_01;
