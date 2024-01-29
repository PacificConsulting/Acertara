report 50102 "Tax Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'src/report layout/Tax Invoice -5.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Posting Date";
            column(SIH_No_; "Sales Invoice Header"."No.")
            {

            }
            column(CompName; Compinfo.Name)
            {

            }
            column(Compinfo_Picture; Compinfo.Picture)
            {

            }

            column(CompName2; Compinfo.Name + '' + Compinfo."Name 2")
            {

            }
            column(CompAddress; Compinfo.Address + ' ' + Compinfo."Address 2" + ' ' + Compinfo.City + ', ' + PState + ' ' + Compinfo."Post Code" + ' ' + Compinfo."Country/Region Code")
            {
            }
            column(Compinfo_email; 'Email :' + Compinfo."E-Mail")
            {

            }
            column(Compinfo_phone; 'Phone :' + Compinfo."Phone No.")
            {

            }
            column(Due_Date; "Due Date")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Order_Date; "Order Date")
            {

            }
            column(Order_No_; "Order No.")
            {

            }
            column(Bill_to_Name; Billtoname)
            {

            }
            column(Bill_to_Address; BilltoAdd)
            {

            }
            column(billcity; billcity)
            {

            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }
            column(Payment_Terms_Code; "Payment Terms Code")
            {

            }
            column(Shipment_Method_Code; "Shipment Method Code")
            {

            }
            column(ShiptoName; ShiptoName)
            {

            }
            column(ShiptoAdd; ShiptoAdd)
            {

            }
            column(Shiptocity; Shiptocity)
            {

            }
            column(pay; pay.Description)
            {

            }
            column(External_Document_No_; "External Document No.")
            {

            }
            column(Shipping; Shipping.Description)
            {

            }
            column(TaxAmount; TaxAmount)
            {

            }
            column(freightAmt; freightAmt)
            {

            }
            column(TradeDisAmt; TradeDisAmt)
            {

            }
            column(TotalAmt; TotalAmt)
            {

            }
            column(subtotal; subtotal)
            {

            }
            column(Comments; Comments)
            {

            }
            column(recpostcode; recpostcode.County)
            {

            }
            column(Salesperson_Code; "Salesperson Code")
            {

            }


            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = "Sales Invoice Header";


                column(SrNo; SrNo)
                {

                }
                column(Line_No_; "Line No.")
                {

                }
                column(Item_No_; "Sales Invoice Line"."No.")
                {

                }
                column(Document_No_; "Document No.")
                {

                }
                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Unit_Price; "Unit Price")
                {

                }
                column(Amount; Amount)
                {

                }
                column(Line_Discount_Amount; "Line Discount Amount")
                {

                }
                column(Type; Type)
                {

                }
                column(SerialCaption; SerialCaption)
                {

                }
                column(SrNo1; SrNo1) //serial no.
                {

                }
                trigger OnAfterGetRecord() //SIL
                begin
                    //skip those lines where type gl account and freight is true
                    if "Sales Invoice Line".Type = "Sales Invoice Line".Type::"G/L Account" then begin //pcpl-064 13oct2023
                        if RecGLAccount.Get("No.") then begin
                            if RecGLAccount.Freight = true then
                                CurrReport.Skip();
                        end;
                    end;
                    SrNo += 1;
                    if "Sales Invoice Line".Type = "Sales Invoice Line".Type::"Charge (Item)" then begin
                        TotalAmt += (subtotal + TradeDisAmt) - freightAmt;
                    end;

                    TaxAmount := SGST + CGST + IGST;

                    //Freight Amount
                    Clear(freightAmt);
                    if "Sales Invoice Line".Type = "Sales Invoice Line".Type::"G/L Account" then begin //pcpl-064 12oct2023
                        if RecGLAccount.Get("No.") then begin
                            if RecGLAccount.Freight = true then begin
                                repeat
                                    freightAmt += "Sales Invoice Line".Amount;
                                until "Sales Invoice Line".Next() = 0;
                            end;
                        end;
                        /* Clear(freightAmt);
                        SIL1.Reset();
                        SIL1.SetRange("Document No.", "No.");
                        SIL1.SetRange(Type, SIL1.Type::"G/L Account");
                        if SIL1.FindSet() THEN
                            REPEAT
                                if RecGLAccount.Get(SIL1."No.") AND (RecGLAccount.Freight = true) then begin
                                    freightAmt += SIL1.Amount;
                                END;
                            until SIL1.Next() = 0; */
                    end;
                    Clear(SerialCaption);
                    if "Sales Invoice Line".Type = "Sales Invoice Line".Type::Item then begin
                        VE.Reset();
                        VE.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                        VE.SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
                        IF VE.FindFirst() then begin
                            ILE.Reset();
                            ILE.SetRange("Entry No.", VE."Item Ledger Entry No.");
                            ILE.SetFilter("Serial No.", '<>%1', '');
                            if ILE.FindFirst() then
                                SerialCaption := 'Serial No.:'
                            else
                                SerialCaption := '';
                        end;
                    end;

                    Clear(SrNo1);
                    if "Sales Invoice Line".Type = "Sales Invoice Line".Type::Item then begin
                        VE.Reset();
                        VE.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                        VE.SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
                        IF VE.FindSet() then begin
                            repeat
                                ILE.Reset();
                                ILE.SetRange("Entry No.", VE."Item Ledger Entry No.");
                                ILE.SetFilter("Serial No.", '<>%1', '');
                                if ILE.FindFirst() then
                                    SrNo1 += ILE."Serial No." + ',';
                            until ILE.Next() = 0;
                            IF SrNo1 <> '' then
                                SrNo1 := DelStr(SrNo1, StrLen(SrNo1), 1);
                            //end;
                        end;

                    end;

                end;


            }
            trigger OnAfterGetRecord() //SIH
            var
                myInt: Integer;
            begin
                if recominfo.get() then
                    recpostcode.Reset();
                recpostcode.SetRange(Code, compinfo."Post Code");
                if recpostcode.FindFirst() then begin
                    PState := recpostcode.County;
                end;


                subtotal += "Sales Invoice Line"."Unit Price" * "Sales Invoice Line".Quantity;
                if Shipping.Get("Shipment Method Code") then;
                if pay.Get("Payment Terms Code") then;

                if RecCust.get("Sales Invoice Header"."Sell-to Customer No.") then;
                /*   Mail := RecCust."E-Mail";
                  PhoneNo := RecCust."Phone No.";
                  CustGSTIN := RecCust."GST Registration No.";
   */
                if recpostcode.Get(CompInfo."Post Code") then;

                if "Bill-to Code" <> '' then begin
                    Billtoname := "Bill-to Name";
                    BilltoAdd := "Bill-to Address" + ' ' + "Bill-to Address 2";
                    billcity := "Bill-to City" + ', ' + "Bill-to County" + ' ' + "Bill-to Post Code" + ' ' + "Bill-to Country/Region Code";
                end
                else begin
                    Billtoname := "Sell-to Customer Name";
                    BilltoAdd := "Sell-to Address" + ' ' + "Sell-to Address 2";
                    billcity := "Sell-to City" + ', ' + "Sell-to County" + ' ' + "Sell-to Post Code" + ' ' + "Sell-to Country/Region Code";

                end;

                IF "Ship-to Code" <> '' then begin
                    ShiptoName := "Ship-to Name";
                    ShiptoAdd := "Ship-to Address" + ' ' + "Ship-to Address 2";
                    Shiptocity := "Ship-to City" + ', ' + "Ship-to County" + ' ' + "Ship-to Post Code" + ' ' + "Ship-to Country/Region Code";

                end
                ELSE begin
                    ShiptoName := Billtoname;
                    ShiptoAdd := BilltoAdd;
                    Shiptocity := billcity;
                end;

                Clear(freightAmt);
                SIL.Reset();
                SIL.SetRange("Document No.", "No.");
                SIL.SetRange(Type, SIL.Type::"Charge (Item)");
                if SIL.FindSet() then begin
                    repeat
                        freightAmt += SIL.Amount;
                    until SIL.Next() = 0;
                end;

                //Trade Amount
                RecSIL.Reset();
                RecSIL.SetRange("Document No.", "No.");
                //  RecSL.SetRange();
                if RecSIL.FindSet() then begin
                    repeat
                        TradeDisAmt += RecSIL."Line Discount Amount" + "Invoice Discount Amount";
                    until RecSIL.Next() = 0;
                end;

                //comments:
                RSIL.Reset();
                RSIL.SetRange("Document No.", "No.");
                RSIL.SetRange(Type, RSIL.Type::" ");
                if RSIL.FindFirst() then
                    repeat
                        Comments += RSIL.Description + ' ';
                    until RSIL.Next() = 0;

            end;

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                CompInfo.GET;
                CompInfo.CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    /*  field(Name; SourceExpression)
                     {
                         ApplicationArea = All;

                     } */
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    /*  rendering
     {
         layout(LayoutName)
         {
             Type = RDLC;
             LayoutFile = 'mylayout.rdl';
         }
     } */

    var
        myInt: Integer;
        recominfo: Record "Company Information";
        billcity: text[30];
        pay: Record "Payment Terms";
        Shipping: record "Shipment Method";
        Compinfo: record "Company Information";
        SrNo: Integer;
        ShiptoAdd: Text[100];
        ShiptoName: Text[50];
        Shiptocity: Text[30];
        ShiptoGSTIN: Code[20];
        RecCust: Record Customer;
        Mail: Text[80];
        PhoneNo: Code[30];
        CustGSTIN: code[20];
        CGST: Decimal;
        IGST: Decimal;
        SGST: Decimal;
        CGSTPer: Decimal;
        SGSTPer: Decimal;
        IGSTPer: Decimal;
        TaxAmount: Decimal;
        BilltoAdd: Text[200];
        Billtoname: text[100];
        freightAmt: Decimal;
        SIL: record "Sales Invoice Line";
        RecSIL: record "Sales Invoice Line";
        TradeDisAmt: Decimal;
        subtotal: Decimal;
        TotalAmt: Decimal;
        RecGLAccount: Record "G/L Account";
        RSIL: Record "Sales Invoice Line";
        Comments: Text;
        SIL1: Record "Sales Invoice Line";
        ILE: Record "Item Ledger Entry";
        SrNo1: Text;
        VE: Record "Value Entry";
        SerialCaption: Text;
        recpostcode: Record "Post Code";
        //  DGLE: Record "Detailed GST Ledger Entry";
        PState: Text[30];
}