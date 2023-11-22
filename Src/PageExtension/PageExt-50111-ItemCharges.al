pageextension 50111 ItemChargesExt extends "Item Charges"
{
    layout
    {
        // Add changes to page layout here
        addafter("Search Description")
        {
            field("charge Type"; Rec."charge Type")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}