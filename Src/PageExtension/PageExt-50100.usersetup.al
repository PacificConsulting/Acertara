pageextension 50100 Usersetup extends "User Setup"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {
            field("Short Close"; Rec."Short Close")
            {
                ApplicationArea = all;
            }
            field("QC Authorization"; Rec."QC Authorization")
            {
                ApplicationArea = all;
            }
            field(Signature; Rec.Signature)
            {
                ApplicationArea = All;
                ToolTip = 'Upload Signature';
            }
        }

        // modify(PhoneNo)
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         Rec.ImportFile();
        //     end;
        // }
    }

    actions
    {
        // Add changes to page actions here

        addfirst(Processing)
        {
            action("Signature Update")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Rec.ImportFile();
                end;
            }
        }
    }

    var
        myInt: Integer;
}