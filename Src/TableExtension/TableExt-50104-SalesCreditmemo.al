tableextension 50104 Salescreditmemo extends "Sales Cr.Memo Header"
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