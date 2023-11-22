tableextension 50102 SalesHeader extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Bill-to Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));

            trigger OnValidate()
            var
                shipadd: Record "Ship-to Address";
            begin
                shipadd.Reset();
                shipadd.SetRange(Code, "Bill-to Code");
                if shipadd.FindFirst() then;
                "Bill-to Name" := shipadd.Name;
                "Bill-to Name 2" := shipadd."Name 2";
                "Bill-to Address" := shipadd.Address;
                "Bill-to Address 2" := shipadd."Address 2";
                "Bill-to City" := shipadd.City;
                "Bill-to Post Code" := shipadd."Post Code";
                "Bill-to County" := shipadd.County;
                "Bill-to Country/Region Code" := shipadd."Country/Region Code";
            end;
        }
    }

    var
        myInt: Integer;
}