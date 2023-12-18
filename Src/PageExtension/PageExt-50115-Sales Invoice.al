pageextension 50115 Sales_Invoice_Ext extends "Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        addbefore(ShippingOptions)
        {
            field("Ship-to Code AEM"; Rec."Ship-to Code")
            {
                ApplicationArea = all;
            }
        }

        addbefore(BillToOptions)
        {
            field("Bill-to Code"; Rec."Bill-to Code")
            {
                ApplicationArea = all;
                /*
                trigger OnValidate()
                var
                    myInt: Integer;
                begin
                    if REC."Bill-to Code" <> '' then begin
                        BillToOptions := BillToOptions::"Custom Address";
                        //REC.CopySellToAddressToBillToAddress();
                    end
                    else begin
                        BillToOptions := BillToOptions::"Default (Customer)";
                        REC.Validate("Bill-to Customer No.", REC."Sell-to Customer No.");
                        REC.RecallModifyAddressNotification(REC.GetModifyBillToCustomerAddressNotificationId());
                    end;
                end;
                */
            }
        }
    }

    actions
    {
        addafter(Action9)
        {
            action("Proforma Invoice")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                Image = Print;
                Caption = 'Proforma Invoice';
                trigger OnAction()
                var
                    myInt: Integer;
                    SH: Record "Sales Header";
                begin
                    SH.Reset();
                    SH.SetRange("No.", Rec."No.");
                    if SH.FindFirst() then
                        Report.RunModal(50105, true, true, SH);
                end;
            }
            action("Packing Slip")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                Image = Print;
                trigger OnAction()
                var
                    myInt: Integer;
                    SH1: Record "Sales Header";
                begin
                    SH1.Reset();
                    SH1.SetRange("No.", Rec."No.");
                    if SH1.FindFirst() then
                        Report.RunModal(50103, true, true, SH1);
                end;
            }
        }
        // Add changes to page actions here
    }
    trigger OnAfterGetRecord()
    begin
        /*
        if REC."Bill-to Code" <> '' then begin
            BillToOptions := BillToOptions::"Custom Address";
            Commit();
            CurrPage.Update();
        end;
        */
    END;

    var
        myInt: Integer;
}