pageextension 50108 ReleasedProdorderLInes extends "Released Prod. Order Lines"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify(ProductionJournal)
        {
            trigger OnBeforeAction()
            var
                ProdOrdComp: Record "Prod. Order Component";
                recItem: Record Item;
            begin
                ProdOrdComp.Reset();
                ProdOrdComp.SetRange("Prod. Order Line No.", Rec."Line No.");
                ProdOrdComp.SetRange("Prod. Order No.", Rec."Prod. Order No.");
                ProdOrdComp.SetRange(Status, ProdOrdComp.Status::Released);
                if ProdOrdComp.FindSet() then
                    repeat
                        recItem.GET(ProdOrdComp."Item No.");
                        ProdOrdComp.CalcFields("Available Quantity");
                        IF recItem."Inventory Value Zero" = false then
                            if ProdOrdComp."Expected Quantity" > ProdOrdComp."Available Quantity" then begin
                                Error('To Fulfil this Production Order, Components are insufficient in Inventory. Please check Production Order components for detailed view, available %1 but expected %2 for item %3', ProdOrdComp."Available Quantity", ProdOrdComp."Expected Quantity", ProdOrdComp."Item No.");
                            end;

                    until ProdOrdComp.Next() = 0;
            end;
        }
    }

    var
        myInt: Integer;
}