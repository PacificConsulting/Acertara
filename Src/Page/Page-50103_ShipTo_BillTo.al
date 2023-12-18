page 50103 ShipTo_BillTo_Details
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ShipTo_BillTo_Deails;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Ship/Bill To Code"; Rec."Ship/Bill To Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Email Type"; Rec."Email Type")
                {
                    ApplicationArea = all;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        // area(Processing)
        // {
        //     action(ActionName)
        //     {
        //         ApplicationArea = All;

        //         trigger OnAction();
        //         begin

        //         end;
        //     }
        // }
    }
}