tableextension 50111 CustomReportExt extends "Custom Report Selection"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Email Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = TO,CC;

        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}