pageextension 50104 Posted_Sales_Inv_Ext extends "Posted Sales Invoice"
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        addafter(Print)
        {
            action("Tax Invoice")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                Image = Print;
                Caption = 'Sales Invoice';
                trigger OnAction()
                var
                    myInt: Integer;
                    SIH: Record "Sales Invoice Header";
                begin
                    SIH.Reset();
                    SIH.SetRange("No.", Rec."No.");
                    if SIH.FindFirst() then
                        Report.RunModal(50102, true, true, SIH);
                end;
            }
            action("Email Tax Invoice")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                Image = SendMail;
                Caption = 'Email Sales Invoice';
                trigger OnAction()
                var
                    CUEvent: Codeunit Events;
                begin
                    //CUEvent.sendinginvoices(Rec."No.");
                    CUEvent.sendinginvoicesShipto(Rec."No.");
                    CUEvent.sendinginvoicesBillto(Rec."No.");
                end;
            }
        }
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}