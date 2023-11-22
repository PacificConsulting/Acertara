pageextension 50112 purchaseOderList extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Short Close"; Rec."Short Close")
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