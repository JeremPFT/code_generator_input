with Opentoken.Token.Enumerated.List;
with Opentoken.Token.Enumerated.Nonterminal;
with Opentoken.Token.Enumerated;

with Model.Types.Project; use Model.Types.Project;

generic
   with package Token       is new Opentoken.Token.Enumerated (<>);
   with package Token_List  is new Opentoken.Token.List;
   with package Nonterminal is new Token.Enumerated.Nonterminal (Token_List);
   with package Terminal_Id is new Token.Identifier;
package Input.Opentok.Project_Synt is

   type Instance is new Nonterminal.Instance with private;

   subtype Class is Instance'Class;

   type Handle is access all Class;

   function Get
     (Id    : in Token.Token_Id;
      Value : in Project_Class_T := null)
     return Instance'Class;

   function Value
     (Subject : in Instance)
     return Project_Class_T;

   Build_Project : constant Nonterminal.Synthesize;

private

   type Instance is new Nonterminal.Instance with record
      Value : Project_Class_T := null;
   end record;

   procedure Synthesize_Build
     (New_Token :    out Nonterminal.Class;
      Source    : in     Token_List.Instance'Class;
      To_Id     : in     Token.Token_Id);

   Build_Project : constant Nonterminal.Synthesize
     := Synthesize_Build'Access;

end Input.Opentok.Project_Synt;
