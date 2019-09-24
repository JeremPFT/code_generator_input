with Model.Project;
with Model.Types.Package_Def; use Model.Types.Package_Def;

package body Input.Opentok.Project_Synt is

   function Get
     (Id    : in Token.Token_Id;
      Value : in Project_Class_T := null)
     return Instance'Class
   is
   begin
      return Instance'Class
        (Instance'(Nonterminal.Instance (Nonterminal.Get (Id))
                   with Value => Value));
   end Get;

   function Value
     (Subject : in Instance)
     return Project_Class_T
   is
   begin
      return Subject.Value;
   end Value;

   procedure Synthesize_Build
     (New_Token :    out Nonterminal.Class;
      Source    : in     Token_List.Instance'Class;
      To_Id     : in     Token.Token_Id)
   is

      Project_Id_Token  : Token_List.List_Iterator
        := Token_List.Initial_Iterator (Source);


      Pkg_List : Package_Def_Vector_T := Package_Def_Vectors.Empty_Vector;


      Project : Project_Class_T :=
        Model.Project.Create (Name             => Id.Value,
                              Output_Directory => ".",
                              Package_List     => Pkg_Lst);

      Token_Instance : Token.Instance
        renames Token.Instance (Token.Get (To_Id));

      Project_Id : String renames
        Terminal_Id.Class (Project_Id_Token).Identifier.To_String;
   begin
      Token_List.Next_Token (Project_Id_Token);

      New_Token := Class (Instance' (Token_Instance with
                                     Value => Project_Id));
   exception
     when Constraint_Error =>
        Ada.Exceptions.Raise_Exception
          (Nonterminal.Invalid_Synth_Argument'Identity,
           "Token " & To_Id'Img & " cannot be synthesized "
             &
             "from a "
             &
             Token.Id (Token_List.Token_Handle(Left).all)'Img
             &
             " and a "
             &
             Token.Id (Token_List.Token_Handle(Right).all)'Img
             &
             "."
          );
   end Synthesize_Build;

end Input.Opentok.Project_Synt;
