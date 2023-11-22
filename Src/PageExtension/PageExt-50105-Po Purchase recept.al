pageextension 50105 PostedWarehousereceipt extends "Posted Purchase Receipt"
{
    layout
    {
        // Add changes to page layout here

        addafter(Control1905767507)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(120), "No." = field("No.");
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