tableextension 50109 SNinfoormation extends "Serial No. Information"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "QC Remark"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Approved ON"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Approved By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}