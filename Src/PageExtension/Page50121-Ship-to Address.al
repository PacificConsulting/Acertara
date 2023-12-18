pageextension 50121 "Ship-to AddressExtCstm" extends "Ship-to Address"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Address")
        {
            action("Ship/Bill To Email")
            {
                ApplicationArea = All;
                Image = Email;
                trigger OnAction()
                var
                    RecSHPBLAdd: Record ShipTo_BillTo_Deails;
                    PageShpBlAdd: page ShipTo_BillTo_Details;
                begin

                    RecSHPBLAdd.Reset();
                    RecSHPBLAdd.FilterGroup(2);
                    RecSHPBLAdd.SetRange("Customer No.", Rec."Customer No.");
                    RecSHPBLAdd.SetRange("Ship/Bill To Code", Rec.Code);
                    if RecSHPBLAdd.FindSet() then;

                    Clear(PageShpBlAdd);

                    //PageShpBlAdd.SetSelectionFilter(RecSHPBLAdd);
                    PageShpBlAdd.SetTableView(RecSHPBLAdd);
                    RecSHPBLAdd.FilterGroup(0);
                    PageShpBlAdd.Run();

                end;
            }
        }
    }

    var

}