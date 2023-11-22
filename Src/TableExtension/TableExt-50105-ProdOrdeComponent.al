tableextension 50105 ProdordeComponent extends "Prod. Order Component"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Available Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry"."Remaining Quantity" where("Item No." = field("Item No."),
                                                                "Location Code" = field("Location Code")));
        }
    }

    var
        myInt: Integer;
}