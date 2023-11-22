pageextension 50102 Warehousereceipt extends "Warehouse Receipt"
{
    layout
    {
        // Add changes to page layout here

        addafter(Control1901796907)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(7316),
                              "No." = FIELD("No.");
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