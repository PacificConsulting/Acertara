tableextension 50107 recVendor extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(50100; Extension; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Our Customer A/C No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}