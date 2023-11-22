pageextension 50110 CustomerCard extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Phone No.")
        {
            field(Extension; Rec.Extension)
            {
                ApplicationArea = all;
            }
        }
    }

    // actions
    // {
    //     // Add changes to page actions here
    // }

    var
        myInt: Integer;
}