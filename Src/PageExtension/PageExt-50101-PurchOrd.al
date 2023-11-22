pageextension 50101 PurchOrd extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Short Close"; Rec."Short Close")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Archive Document")
        {
            action("Short CLosure")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PL: Record "Purchase Line";
                    totqty: Decimal;
                    ReceivedQty: Decimal;
                    cnt: Integer;
                    UserSet: Record "User Setup";
                    WhsercptLine: Record "Warehouse Receipt Line";
                    WhseReciptH: Record "Warehouse Receipt Header";
                begin
                    Rec.TestField("Short Close", false);
                    IF UserSet.get(UserId) then;
                    UserSet.TestField("Short Close");
                    if Confirm('Do you want to Short close this order', true) then begin
                        Rec.Validate(Status, Rec.Status::Open);
                        Rec.Modify();
                        Clear(ReceivedQty);
                        Clear(totqty);
                        Clear(cnt);
                        ArchiveManagement.StorePurchDocument(Rec, false);
                        PL.Reset();
                        PL.SetRange("Document No.", Rec."No.");
                        if PL.FindFirst() then
                            repeat
                                cnt += 1;
                                if PL.Quantity <> PL."Quantity Received" then begin
                                    //PL.Validate(Quantity, PL."Quantity Received");
                                    PL.Quantity := PL."Quantity Received";
                                    PL.Modify();
                                end;
                                totqty += PL.Quantity;
                                ReceivedQty += PL."Quantity Received";
                            until PL.Next() = 0;
                        if (totqty = ReceivedQty) And (cnt <> 0) then begin
                            WhsercptLine.Reset();
                            WhsercptLine.SetRange("Source No.", Rec."No.");
                            if WhsercptLine.FindSet() then
                                repeat
                                    WhseReciptH.Reset();
                                    WhseReciptH.SetRange("No.", WhsercptLine."No.");
                                    if WhseReciptH.FindFirst() then begin
                                        WhseReciptH.Delete();
                                    end;
                                    WhsercptLine.Delete();
                                until WhsercptLine.Next() = 0;

                            Rec.Validate("Short Close", true);
                            Rec.Modify();
                            ArchiveManagement.StorePurchDocument(Rec, false);
                            Message('This order is short close successfully');
                        end;
                    end;
                end;
            }

        }
        addafter("&Print")
        {
            action("Purchase Order")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Image = Print;

                trigger OnAction()
                var
                    PurchaseHeader: Record 38;
                begin
                    //PBTL-AM 061218
                    PurchaseHeader.RESET;
                    PurchaseHeader.SETRANGE("No.", Rec."No.");
                    IF PurchaseHeader.FINDFIRST THEN
                        REPORT.RUN(50100, true, true, PurchaseHeader);
                    //PBTL-AM 061218                
                end;
            }

            /*action("Send E-mail")
            {
                ApplicationArea = all;
                Image = Email;
                trigger OnAction()
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
                begin
                    Clear(BodyText);
                    Clear(VarReceiptNew);
                    VarReceiptNew.RemoveRange(1, VarReceiptNew.Count);
                    VarReceiptNew.add('monali.patil@pacificconsulting.in');
                    Varsubject := 'Signed PO : ';
                    BodyText.AddText('Dear Sir/Madam');
                    BodyText.AddText('<br><Br>');
                    BodyText.AddText('Please check attachment');
                    BodyText.AddText('<br><Br>');
                    /*BodyText.AddText('<table border="0">');
                    BodyText.AddText('<tr style= "color:#507CD1">');
                    BodyText.AddText('<td style="text-align:center" colspan=8><b> ' + CompanyName + '</b></td>');
                    BodyText.AddText('</tr>');
                    BodyText.AddText('<br><Br>');
                    BodyText.AddText('<tr style="background-color:#507CD1; color:#fff">');
                    BodyText.AddText('<th> Date           </th>');
                    BodyText.AddText('<th> Indent No.     </th>');
                    BodyText.AddText('</tr>');

                    BodyText.AddText('<tr style="background-color:#EFF3FB; color:black">');
                    BodyText.AddText('<td>' + FORMAT(IndentLine.Date) + '</td>');
                    BodyText.AddText('<td>' + FORMAT(IndentLine."Document No.") + '</td>');
                    BodyText.AddText('</tr>');
                    BodyText.AddText('<tr>');
                    BodyText.AddText('<td colspan=8 >');
                    BodyText.AddText('</td>');
                    BodyText.AddText('</tr>');
                    BodyText.AddText('</table>'); */
            /*   Message(Format(VarReceiptNew));
               Emailmessage.Create(VarReceiptNew, Varsubject, Format(BodyText), true);
               Recref.GetTable(Rec);
               TempBlob.CreateOutStream(OutStr);
               Report.SaveAs(Report::"Purchase order Report", '', ReportFormat::Pdf, OutStr, Recref);
               TempBlob.CreateInStream(InStr);
               Emailmessage.AddAttachment('Purchase Order.pdf', '.pdf', InStr);
               Email.Send(Emailmessage, Enum::"Email Scenario"::Default);
               Message('Emial Sent');
           END;
       }*/

        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TestField("Short Close", false);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TestField("Short Close", false);
    end;


    var
        myInt: Integer;
        ArchiveManagement: Codeunit ArchiveManagement;

}