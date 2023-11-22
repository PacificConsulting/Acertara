pageextension 50107 ReleasedProdorde extends "Released Production Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify(RefreshProductionOrder)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("Location Code");
            end;
        }
    }

    var
        myInt: Integer;
}