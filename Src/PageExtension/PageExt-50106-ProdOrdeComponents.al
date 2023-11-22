pageextension 50106 Prodordeecomponent extends "Prod. Order Components"
{
    layout
    {
        // Add changes to page layout here
        addafter("Remaining Quantity")
        {
            field("Available Quantity"; Rec."Available Quantity")
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