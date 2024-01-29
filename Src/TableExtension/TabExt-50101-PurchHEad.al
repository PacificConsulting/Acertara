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
        field(50102; "Product Verification ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL-064 28dec2023';
        }
        field(50103; "Product Verification Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL-064 28dec2023';
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