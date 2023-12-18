pageextension 50109 VendorCard extends "Vendor Card"
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
        addafter("Company Size Code")
        {
            field("Our Customer A/C No."; Rec."Our Customer A/C No.")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("Our Customer A/C No.")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
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