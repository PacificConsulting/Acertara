pageextension 50114 GL_Account_Card_Ext extends "G/L Account Card"
{
    layout
    {
        addafter("Search Name")
        {
            field(Freight; Rec.Freight)
            {
                ApplicationArea = all;

            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}