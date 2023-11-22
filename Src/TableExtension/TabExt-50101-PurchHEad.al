tableextension 50101 purchHeader extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Short Close"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50101; "Email Sent to Vendor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        myInt: Integer;

    trigger OnBeforeModify()
    begin
        Rec.TestField("Short Close", false);
    end;

    trigger OnBeforeDelete()
    begin
        Rec.TestField("Short Close", false);
    end;

}