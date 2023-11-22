tableextension 50110 MyExtension extends "G/L Account"
{
    fields
    {
        field(50000; "Freight"; boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL-064 12Oct2023';


        }
        // Add changes to table fields here
    }

    var
        myInt: Integer;
}