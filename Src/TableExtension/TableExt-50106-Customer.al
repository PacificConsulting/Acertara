tableextension 50106 recCustomer extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(50100; Extension; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}