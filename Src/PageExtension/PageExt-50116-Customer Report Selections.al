pageextension 50116 CustomerReportSelectionsExt extends "Customer Report Selections"
{
    layout
    {
        addafter(ReportID)
        {
            field("Email Type "; Rec."Email Type")
            {
                ApplicationArea = ALL;
            }
        }
        // Add changes to page layout here
        modify("Custom Report Description")
        {
            Visible = false;
        }
        modify("Use for Email Body")
        {
            Visible = false;
        }
        modify("Email Body Layout Description")
        {
            Visible = false;
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}