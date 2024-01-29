report 50101 "Sales Order Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'src/report layout/Sales Order -7.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Posting Date";
            column(SH_No_; "Sales Header"."No.")
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
            column(Due_Date; "Due Date")
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Order_Date; "Order Date")
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
            column(Shipment_Date; "Shipment Date")
            {

            }
            column(Salesperson_Code; "Salesperson Code")
            {

            }
            column(freightAmt; freightAmt)
            {

            }
            column(Invoice_Discount_Amount; "Invoice Discount Amount")
            {

            }
            column(TradeDisAmt; TradeDisAmt)
            {

            }
            column(subtotal; subtotal)
            {

            }
            column(TotalAmt; TotalAmt)
            {

            }
            column(TaxAmount; TaxAmount)
            {

            }
            column(Comments; Comments)
            {

            }
            column(recpostcode; recpostcode.County)
            {

            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = "Sales Header";

                column(SrNo; SrNo)
                {

                }

                column(Line_No_; "Line No.")
                {

                }
                column(Item_No_; "Sales Line"."No.")
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
                    if "Sales Line".Type = "Sales Line".Type::"G/L Account" then begin //pcpl-064 13oct2023
                        if RecGLAccount.Get("No.") then begin
                            if RecGLAccount.Freight = true then
                                CurrReport.Skip();
                        end;
                    end;


                    //SrNo += 1;

                    if "Sales Line".Type = "Sales Line".Type::"Charge (Item)" then begin
                        TotalAmt += (subtotal + TradeDisAmt) - freightAmt;
                    end;

                    subtotal += Quantity * "Unit Price";

                    //Freight Amount
                    // Clear(freightAmt);
                    // //  if "Sales Line".Type = "Sales Line".Type::"G/L Account" then begin //pcpl-064 12oct2023
                    // if RecGLAccount.Get("No.") then begin
                    //     if RecGLAccount.Freight = true then begin
                    //         repeat
                    //             freightAmt += "Sales Line".Amount;
                    //         until "Sales Line".Next() = 0;
                    //     end;
                    // end

                    Clear(SerialCaption);
                    if "Sales Line".Type = "Sales Line".Type::Item then begin
                        recitemtrac.Reset();
                        recitemtrac.SetRange("Source Type", 37);
                        recitemtrac.SetRange("Source Subtype", 1);
                        recitemtrac.SetRange("Source ID", "Sales Line"."Document No.");
                        recitemtrac.SetRange("Item No.", "Sales Line"."No.");
                        recitemtrac.SetRange("Source Ref. No.", "Sales Line"."Line No.");
                        recitemtrac.SetRange("Location Code", "Sales Line"."Location Code");
                        recitemtrac.SetFilter("Serial No.", '<>%1', '');
                        if recitemtrac.FindFirst() then
                            SerialCaption := 'Serial No.:'
                        else
                            SerialCaption := '';
                    end;


                    Clear(SrNo1);
                    if "Sales Line".Type = "Sales Line".Type::Item then begin
                        ItemTrac.Reset();
                        ItemTrac.SetRange("Source Type", 37);
                        ItemTrac.SetRange("Source Subtype", ItemTrac."Source Subtype"::"1");
                        ItemTrac.SetRange("Source ID", "Sales Line"."Document No.");
                        ItemTrac.SetRange("Item No.", "Sales Line"."No.");
                        ItemTrac.SetRange("Source Ref. No.", "Sales Line"."Line No.");
                        ItemTrac.SetRange("Location Code", "Sales Line"."Location Code");
                        if ItemTrac.FindSet() then begin
                            repeat
                                SrNo1 += ItemTrac."Serial No." + ',';
                            until ItemTrac.Next() = 0;
                            IF SrNo1 <> '' then
                                SrNo1 := DelStr(SrNo1, StrLen(SrNo1), 1);
                        end;
                    end;


                end;

            }
            trigger OnAfterGetRecord() //SIH
            var
                myInt: Integer;
            begin

                if Shipping.Get("Shipment Method Code") then;
                if pay.Get("Payment Terms Code") then;

                if RecCust.get("Sales Header"."Sell-to Customer No.") then;
                /*   Mail := RecCust."E-Mail";
                  PhoneNo := RecCust."Phone No.";
                  CustGSTIN := RecCust."GST Registration No.";
   */
                if reccominfo.get() then
                    recpostcode.Reset();
                recpostcode.SetRange(Code, compinfo."Post Code");
                if recpostcode.FindFirst() then begin
                    PState := recpostcode.County;
                end;

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

                //Freight Amount

                /*  sl.Reset(); //PCPL-064 13oct2023
                 SL.SetRange("Document No.", "No.");
                 SL.SetRange(Type, SL.Type::"Charge (Item)");
                 if SL.FindSet() then begin
                     repeat
                         freightAmt += SL.Amount;
                     until SL.Next() = 0;
                 end; */

                //PCPL-25/291123
                Clear(freightAmt);
                SL.Reset();
                SL.SetRange("Document No.", "No.");
                SL.SetRange(Type, SL.Type::"G/L Account");
                if SL.FindSet() THEN
                    REPEAT
                        if RecGLAccount.Get(SL."No.") AND (RecGLAccount.Freight = true) then begin
                            freightAmt += SL.Amount;
                        END;
                    until SL.Next() = 0;
                //PCPL-25/291123

                //Trade Amount
                RecSL.Reset();
                RecSL.SetRange("Document No.", "No.");
                //  RecSL.SetRange();
                if RecSL.FindSet() then begin
                    repeat
                        TradeDisAmt += RecSL."Line Discount Amount" + "Invoice Discount Amount";
                    until RecSL.Next() = 0;
                end;
                //totalAmt
                /*  SalLine.Reset();
                 SalLine.SetRange("Document No.", "No.");
                 SalLine.SetRange(Type, SalLine.Type::Item);
                 if SalLine.FindSet() then begin
                     TotalAmt += SalLine.Amount;
                 end; */

                //comments:
                salesline.Reset();
                salesline.SetRange("Document No.", "No.");
                salesline.SetRange(Type, salesline.Type::" ");
                if salesline.FindFirst() then
                    repeat
                        Comments += salesline.Description + ' ';
                    until salesline.Next() = 0;

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



    var
        myInt: Integer;
        // recitemtrac: Record 337;
        billcity: text[30];
        reccominfo: Record "Company Information";
        pay: Record "Payment Terms";
        Shipping: record "Shipment Method";
        Compinfo: record "Company Information";
        SrNo: Integer;
        ShiptoAdd: Text[100];
        ShiptoName: Text[50];
        Shiptocity: Text[30];
        ShiptoGSTIN: Code[30];
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
        SL: Record "Sales Line";
        BilltoAdd: Text[200];
        Billtoname: text[100];
        freightAmt: Decimal;
        TradeDisAmt: Decimal;
        RecSL: Record "Sales Line";
        TotalAmt: Decimal;
        SalLine: Record "Sales Line";
        subtotal: Decimal;
        RecGLAccount: Record "G/L Account";
        salesline: Record "Sales Line";
        Comments: Text;
        ILE: Record "Item Ledger Entry";
        SrNo1: Text;
        VE: Record "Value Entry";
        SerialCaption: Text;
        ItemTrac: Record "Reservation Entry";
        recitemtrac: Record 337;

        //reservaEntry: Record "Reservation Entry";
        recpostcode: Record "Post Code";
        //  DGLE: Record "Detailed GST Ledger Entry";
        PState: Text[30];



}