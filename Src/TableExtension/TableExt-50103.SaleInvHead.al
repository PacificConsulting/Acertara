tableextension 50103 SalesInvHead extends "Sales Invoice Header"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Bill-to Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}