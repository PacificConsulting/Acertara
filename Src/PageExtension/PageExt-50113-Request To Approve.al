pageextension 50113 Requesttoaprove extends "Requests to Approve"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify(Approve)
        {
            trigger OnAfterAction()
            var
                TempBlob: Codeunit "Temp Blob";
                Emailmessage: Codeunit "Email Message";
                Email: Codeunit Email;
                BodyText: BigText;
                VarReceiptNew: list of [text];
                TempVarReceipt: Text;
                OutStr: OutStream;
                InStr: InStream;
                recV: Record Vendor;
                Varsubject: Text;
                Recref: RecordRef;
                PurchHead: Record "Purchase Header";
            begin
                if Rec."Table ID" = 38 then begin
                    PurchHead.Reset();
                    PurchHead.SetRange("No.", Rec."Document No.");
                    PurchHead.SetRange(Status, PurchHead.Status::Released);
                    PurchHead.SetRange("Email Sent to Vendor", false);
                    if PurchHead.FindFirst() then begin
                        if Confirm('Do you want to Sent Email to vendor', true) then begin
                            Clear(BodyText);
                            Clear(VarReceiptNew);
                            VarReceiptNew.RemoveRange(1, VarReceiptNew.Count);
                            VarReceiptNew.add('monali.patil@pacificconsulting.in');
                            Varsubject := 'Signed PO : ';
                            BodyText.AddText('Dear Sir/Madam');
                            BodyText.AddText('<br><Br>');
                            BodyText.AddText('Please check attachment');
                            BodyText.AddText('<br><Br>');
                            Message(Format(VarReceiptNew));
                            Emailmessage.Create(VarReceiptNew, Varsubject, Format(BodyText), true);
                            Recref.GetTable(Rec);
                            TempBlob.CreateOutStream(OutStr);
                            Report.SaveAs(Report::"Purchase order Report", '', ReportFormat::Pdf, OutStr, Recref);
                            TempBlob.CreateInStream(InStr);
                            Emailmessage.AddAttachment('Purchase Order.pdf', '.pdf', InStr);
                            Email.Send(Emailmessage, Enum::"Email Scenario"::Default);
                            Message('Emial Sent');
                        end;
                    end;
                end;
            END;
        }
    }
    var
        myInt: Integer;
}