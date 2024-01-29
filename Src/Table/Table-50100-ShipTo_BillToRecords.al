table 50100 ShipTo_BillTo_Deails
{
    DataClassification = ToBeClassified;
    DrillDownPageId = 50103;
    LookupPageId = 50103;
    
    fields
    {
        field(1; "Customer No."; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(2; "Ship/Bill To Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));
        }

        field(4; "E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                ValidateEmail()
            end;
        }
        field(5; "Email Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = TO,CC;

        }

    }

    keys
    {
        key(Key1; "Customer No.", "Ship/Bill To Code", "E-Mail", "Email Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    local procedure ValidateEmail()
    var
        MailManagement: Codeunit "Mail Management";
        IsHandled: Boolean;
    begin
        MailManagement.ValidateEmailAddressField("E-Mail");
    end;

}