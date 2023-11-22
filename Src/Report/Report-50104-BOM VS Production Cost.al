report 50104 "BOM Vs Production Cost"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'src/report layout/BOMvsProductionCost -1.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            RequestFilterFields = "No.", "Source No.";

            column(No_; "No.") { }
            column(Source_No_; "Source No.") { }
            column(Description; Description) { }
            column(Quantity; Quantity) { }
            column(Starting_Date_Time; "Starting Date-Time") { }
            column(Ending_Date_Time; "Ending Date-Time") { }
            column(Planned_Order_No_; "Planned Order No.") { }
            column(Due_Date; "Due Date") { }

            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = "Prod. Order No." = field("No.");
                DataItemLinkReference = "Production Order";

                column(Item_No_; "Item No.") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }

                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = "Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Line No.");
                    DataItemLinkReference = "Prod. Order Line";
                    DataItemTableView = WHERE(Status = FILTER(Released));

                    column(Item_No_comp; "Item No.")
                    {

                    }
                    column(Unit_of_Measure_Code_comp; "Unit of Measure Code")
                    { }
                    column(Quantity_per; "Quantity per")
                    { }
                    column(Description_Comp; Description)
                    { }
                    column(Scrap__; "Scrap %")
                    { }
                    column(Expected_Quantity; "Expected Quantity")
                    { }
                    column(Unitcost; RecItem."Unit Cost")
                    { }
                    column(ActPrdTotCost; ActPrdTotCost)
                    { }
                    column(PrdqtyVar; PrdqtyVar)
                    { }
                    column(PrdqtyVarAtt; PrdqtyVarAtt)
                    { }
                    column(ActPrdQty; ActPrdQty)
                    { }
                    column(PrdQtyprice; PrdQtyprice)
                    { }
                    column(ExptotCost; ExptotCost)
                    { }
                    column(VarAttprice; VarAttprice)
                    { }

                    trigger OnAfterGetRecord()
                    begin
                        if RecItem.Get("Prod. Order Component"."Item No.") then;

                        Clear(ActPrdQty);
                        ILE.Reset();
                        ILE.SetRange("Item No.", "Item No.");
                        ILE.SetRange("Entry Type", ILE."Entry Type"::Consumption);
                        ILE.SetRange("Order No.", "Prod. Order Line"."Prod. Order No.");
                        if ILE.FindSet() then
                            repeat
                                ActPrdQty += ILE.Quantity;
                            until ILE.Next() = 0;

                        Clear(PrdQtyprice);
                        VLE.Reset();
                        VLE.SetRange("Item No.", "Item No.");
                        VLE.SetRange("Order No.", "Prod. Order Line"."Prod. Order No.");
                        if VLE.FindSet() then
                            repeat
                                PrdQtyprice += VLE."Cost per Unit";
                            until VLE.Next() = 0;

                        Clear(ActPrdTotCost);
                        Clear(PrdqtyVar);
                        Clear(PrdqtyVarAtt);
                        Clear(VarAttprice);
                        ActPrdTotCost := ActPrdQty * PrdQtyprice;
                        PrdqtyVar := ABS("Prod. Order Component"."Expected Quantity" - ActPrdQty);
                        PrdqtyVarAtt := RecItem."Unit Cost" * ActPrdQty;
                        ExptotCost := "Prod. Order Component"."Expected Quantity" * RecItem."Unit Cost";
                        VarAttprice := (ABS(PrdQtyprice - RecItem."Unit Cost") * ActPrdQty);

                    end;
                }
            }
        }
    }


    var
        myInt: Integer;
        RecItem: Record 27;
        ILE: Record 32;
        ExptotCost: Decimal;
        ActPrdQty: Decimal;
        PrdQtyprice: Decimal;
        VLE: Record "Value Entry";
        ActPrdTotCost: Decimal;
        PrdqtyVar: Decimal;
        PrdqtyVarAtt: Decimal;
        VarAttprice: Decimal;

}