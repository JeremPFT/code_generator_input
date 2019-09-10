package body Input.Grammar.G_01 is

   subtype Selection_T is OpenToken.Token.Selection.Instance;

   subtype Selection_Class_T is OpenToken.Token.Selection.Class;

   subtype Sequence_T is OpenToken.Token.Sequence.Handle;

   function Sequence (Old_Instance : in Instance;
                      Name         : in String   := "";
                      Lookahead    : in Integer  := Default_Lookahead;
                      Build        : in Action   := null)
                     return Handle
     renames OpenToken.Token.Sequence.New_Instance;

   ------------
   --  Root  --
   ------------

   function Root
   return OpenToken.Token.Handle
   is
      Result : OpenToken.Token.Handle;
   begin
      Result := Project_Def;
      return Result;
   end Root;

   -------------------
   --  Project_Def  --
   -------------------

   function Project_Def
   return OpenToken.Token.Handle
   is
      Result : OpenToken.Token.Handle := new Selection_T;

      Sel_1 : OpenToken.Token.Handle := new OpenToken.Token.Selection.Instance;
      Sel_2 : OpenToken.Token.Handle := new OpenToken.Token.Selection.Instance;
   begin
      Sel_1.all := Sequence
      (Project_Start_ID & Identifier_ID
       & Output_Directory_Def
       & Project_Stop_ID);

      Sel_2.all := Sequence
      (Project_Start_ID & Identifier_ID
       & Project_Stop_ID);

      Result.all := Selection (Sel_1 or Sel_2);

      return Result;
   end Project_Def;

   ----------------------------
   --  Output_Directory_Def  --
   ----------------------------

   function Output_Directory_Def
   return OpenToken.Token.Handle
   is
      Result : OpenToken.Token.Handle := new OpenToken.Token.Selection.Instance;
   begin
      Result := Project_Def;
      return Result;
   end Output_Directory_Def;

end Input.Grammar.G_01;
