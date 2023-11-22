report 50100 "Purchase order Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'src/report layout/PurchaseOrder.rdl';
    DefaultLayout = RDLC;


    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Posting Date";
            column(Companyinfo; Companyinfo.Picture)
            {

            }
            column(Companyname; Companyinfo.Name)
            {

            }
            column(Companyinfo3; Companyinfo.Address + ' ' + Companyinfo."Address 2" + ' ' + Companyinfo.City + ' ' + Companyinfo."Post Code")
            {

            }
            column("No_1"; "No.")
            {

            }
            column(Order_Date; "Order Date")
            {

            }
            column(Buy_from_Address; "Buy-from Address")//+ "Buy-from Address 2" + "Buy-from City" + "Buy-from Post Code")
            {

            }
            column(Buy_from_Address_2; "Buy-from Address 2")
            {

            }
            column(Buy_from_City; "Buy-from City")
            {

            }
            column(Buy_from_Post_Code; "Buy-from Post Code")
            {

            }
            column(Payment_Terms_Code; "Payment Terms Code")
            {

            }
            column(Shipment_Method_Code; "Shipment Method Code")
            {

            }
            column(Expected_Receipt_Date; "Expected Receipt Date")
            {

            }
            column(PAYMENT; PAYMENT.Description)
            {

            }
            column(Shipping_methods; "Shipping methods".Description)
            {

            }
            column(Locationaddr; Locationaddr)
            {

            }
            column(Locationaddr2; Locationaddr2)
            {

            }
            column(Locationcity; Locationcity)
            {

            }
            column(Locationpostcode; Locationpostcode)
            {

            }
            column(PurchaserCode; PurchaserCode.Name)
            {

            }
            column(Invoice_Discount_Amount; "Invoice Discount Amount")
            {

            }
            column(UserSetup; RecUserSetup.Signature)
            {

            }
            column(Product_Verification_Sign; RecUserSetup1.Signature)
            {

            }
            column(Your_Reference; "Your Reference")
            {

            }
            column(Vendor_Our_Cust_Ac_No; RecVdedor."Our Customer A/C No.")
            {

            }

            column(Comments; Comments)
            {

            }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = "Purchase Header";
                DataItemTableView = WHERE(Type = FILTER(Item | "G/L Account"));

                column(Line_No_; "Line No.")
                {

                }
                column(SrNo; SrNo)
                {

                }
                column(ItemNo; "No.")
                {

                }

                column(Description; Description)
                {

                }
                column(Description_2; "Description 2")
                {

                }
                column(Unit_of_Measure; "Unit of Measure")
                {

                }
                column(Unit_Price__LCY_; "Unit Price (LCY)")
                {

                }
                column(Quantity; Quantity)
                {


                }
                column(Direct_Unit_Cost; "Direct Unit Cost")
                {

                }
                column(TotalValue; TotalValue)
                {

                }
                column(Line_Discount_Amount; "Line Discount Amount")
                {

                }
                column(PurchLine_Inv__Discount_Amount; "Inv. Discount Amount")
                {

                }
                column(FreightValue; FreightValue)
                {

                }
                column(Miscellaneous; Miscellaneous)
                {

                }
                column(TaxValue; '')// TaxValue) pcpl-065 21-nov-23
                {

                }
                column(UOMDesc; UOMDesc)
                {

                }
                column(FValue; FValue)
                {

                }
                column(CommentDesc; CommentDesc)
                {

                }

                trigger OnAfterGetRecord()//PL
                begin
                    SrNo += 1;


                    TotalValue := Quantity * "Direct Unit Cost";
                    Miscellaneous := 0;
                    //  TaxValue := 0;

                    RecUnitOfMeasure.Reset();
                    RecUnitOfMeasure.SetRange(code, "Purchase Line"."Unit of Measure Code");
                    if RecUnitOfMeasure.FindSet() then
                        UOMDesc := RecUnitOfMeasure.Description;




                    PL.Reset();
                    PL.SetRange("Document No.", "Purchase Header"."No.");
                    PL.SetRange(Type, pl.Type::"Charge (Item)");
                    //PL.SetRange(Type, pl.Type::"G/L Account");
                    if PL.FindSet() then
                        repeat
                            RecItemCharge.Reset();
                            RecItemCharge.SetRange("No.", PL."No.");
                            RecItemCharge.SetRange("Charge Type", RecItemCharge."Charge Type"::Freight);
                            if RecItemCharge.FindFirst() then
                                FValue += pl.Amount;

                        until PL.Next() = 0;

                    // PL1.Reset();// pcpl-065 21-nov-23
                    // PL1.SetRange("Document No.", "Purchase Header"."No.");
                    // PL1.SetRange(Type, PL1.Type::" ");
                    // if PL1.FindSet() then
                    //     repeat
                    //         CommentDesc += PL1.Description + ' ';
                    //     until PL1.Next() = 0;






                end;




            }
            trigger OnAfterGetRecord()//PH

            begin


                Clear(Locationaddr);
                Clear(Locationpostcode);
                Recloc.Reset();
                Recloc.SetRange(Code, "Location Code");
                if Recloc.FindFirst() then begin
                    Locationaddr := Recloc.Address;
                    Locationaddr2 := Recloc."Address 2";
                    Locationcity := Recloc.City;
                    Locationpostcode := Recloc."Post Code";

                end;

                IF PAYMENT.Get("Purchase Header"."Payment Terms Code") then;

                if "Shipping methods".Get("Purchase Header"."Shipment Method Code") then;

                if PurchaserCode.Get("Purchase Header"."Purchaser Code") then;

                if RecVdedor.Get("Purchase Header"."Buy-from Vendor No.") then;



                ////Authorized Signature 22/9/23
                RecApprovalEntries.Reset();
                RecApprovalEntries.SetRange("Table ID", 38);
                RecApprovalEntries.SetRange("Document Type", RecApprovalEntries."Document Type"::Order);
                RecApprovalEntries.SetRange("Document No.", "No.");
                RecApprovalEntries.SetRange(Status, RecApprovalEntries.Status::Approved);
                if RecApprovalEntries.FindFirst() then begin
                    RecUserSetup.Reset();
                    RecUserSetup.SetRange("User ID", RecApprovalEntries."Sender ID");
                    if RecUserSetup.FindFirst() then begin
                        RecUserSetup.CalcFields(Signature);
                    end;


                end;


                //Product Verification Signature 22/9/23
                RecApprovalEntries1.Reset();
                RecApprovalEntries1.SetRange("Table ID", 38);
                RecApprovalEntries1.SetRange("Document Type", RecApprovalEntries1."Document Type"::Order);
                RecApprovalEntries1.SetRange("Document No.", "No.");
                RecApprovalEntries1.SetRange(Status, RecApprovalEntries1.Status::Approved);
                if RecApprovalEntries1.FindLast() then begin
                    if RecApprovalEntries1."Sender ID" <> RecApprovalEntries1."Approver ID" then begin
                        RecUserSetup1.Get(RecApprovalEntries1."Approver ID");
                        RecUserSetup1.CalcFields(Signature);
                    end;

                end;



                //comments: pcpl-065 21-nov-23
                Recpurchline.Reset();
                Recpurchline.SetRange("Document No.", "No.");
                Recpurchline.SetRange(Type, Recpurchline.Type::" ");
                if Recpurchline.FindFirst() then
                    repeat
                        Comments += Recpurchline.Description + ' ';
                    until Recpurchline.Next() = 0;


                // PL1.Reset();// pcpl-065 21-nov-23
                // PL1.SetRange("Document No.", "Purchase Header"."No.");
                // PL1.SetRange(Type, PL1.Type::" ");
                // if PL1.FindSet() then
                //     repeat
                //         CommentDesc += PL1.Description + ' ';
                //     until PL1.Next() = 0;




            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                // group(GroupName)
                // {
                //     field(Name; SourceExpression)
                //     {
                //         ApplicationArea = All;

                //     }
                // }
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

    trigger OnInitReport();
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
        // FormatAddr.Company(CompanyAddr, CompanyInfo);

        //Authorized Signature 22/9/23 
        // UserSetup.Get(UserId);
        // UserSetup.CalcFields(Signature);




    end;



    var
        Companyinfo: Record "Company Information";
        Recloc: record "Location";
        PH: Record "Purchase Header";
        PAYMENT: Record "Payment Terms";
        "Shipping methods": Record "Shipment Method";
        PurchaserCode: Record "Salesperson/Purchaser";
        // PL: Record "Purchase Line";
        TotalValue: Decimal;
        Locationaddr: Text[100];
        Locationpostcode: Code[50];
        FreightValue: Decimal;
        RecUserSetup: Record "User Setup";
        Miscellaneous: Decimal;
        // TaxValue: Decimal;pcpl-065 21-nov-23
        RecUnitOfMeasure: Record "Unit of Measure";
        UOMDesc: text[100];
        // FreightCkeck: Boolean;
        RecItemCharge: Record "Item Charge";
        FValue: Decimal;
        PL: Record "Purchase Line";
        RecApprovalEntries: Record "Approval Entry";
        img: Text;
        RecApprovalEntries1: Record "Approval Entry";
        RecUserSetup1: Record "User Setup";
        RecVdedor: Record Vendor;
        PL1: Record "Purchase Line";
        SrNo: Integer;
        CommentDesc: Text[100];
        Comments: Text;
        Recpurchline: Record "Purchase Line";
        Locationaddr2: Text[100];
        Locationcity: Text[100];




    // TotalAmount: Decimal;
    // CGSTAmount: Decimal;
    // SGSTAmount: Decimal;
    // IGSTAmount: Decimal;
    // CGSTPer: Decimal;
    // SGSTPer: Decimal;
    // IGSTPer: Decimal;







}


