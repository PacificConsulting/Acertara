codeunit 50100 Events
{
    //CU 90 Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptHeaderInsert', '', false, false)]
    local procedure OnBeforePurchRcptHeaderInsert(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WhseReceive: Boolean; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; WhseShip: Boolean)
    var
        DocAttchment: Record "Document Attachment";
        DocAttch: Record "Document Attachment";
    begin
        DocAttch.Reset();
        DocAttch.SetRange("Table ID", 7316);
        DocAttch.SetRange("No.", WarehouseReceiptHeader."No.");
        if DocAttch.FindFirst() then
            repeat
                DocAttchment.Reset();
                DocAttchment.SetRange("Table ID", 120);
                DocAttchment.SetRange(ID, DocAttch.ID);
                DocAttchment.SetRange("No.", PurchRcptHeader."No.");
                if not DocAttchment.FindFirst() then begin
                    DocAttchment.init;
                    DocAttchment.Validate(ID, DocAttch.ID);
                    DocAttchment.Validate("Table ID", 120);
                    DocAttchment.Validate("No.", PurchRcptHeader."No.");
                    //DocAttchment."Document Type" := PurchRcptHeader."Document Type";
                    DocAttchment.Validate("Attached Date", DocAttch."Attached Date");
                    DocAttchment.Validate("Attached By", DocAttch."Attached By");
                    DocAttchment.Validate("File Name", DocAttch."File Name");
                    DocAttchment.Validate("File Type", DocAttch."File Type");
                    DocAttchment.Validate("File Extension", DocAttch."File Extension");
                    DocAttchment.Validate("Document Reference ID", DocAttch."Document Reference ID");
                    DocAttchment.User := DocAttch.User;
                    DocAttchment.Validate("Document Flow Purchase", DocAttch."Document Flow Purchase");
                    DocAttchment.Validate("Document Flow Sales", DocAttch."Document Flow Sales");
                    Commit();
                    DocAttchment.Insert();
                    Commit();
                end;
            until DocAttch.Next() = 0;
    end;
    //CU 90 End

    //CU 22 start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInsertItemLedgEntry', '', false, false)]
    local procedure OnAfterInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer; var ValueEntryNo: Integer; var ItemApplnEntryNo: Integer; GlobalValueEntry: Record "Value Entry"; TransferItem: Boolean; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L"; var OldItemLedgerEntry: Record "Item Ledger Entry")
    var
        sninfo: Record "Serial No. Information";
    begin
        if ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::Output then begin
            sninfo.Reset();
            sninfo.SetRange("Serial No.", ItemLedgerEntry."Serial No.");
            sninfo.SetRange("Variant Code", ItemLedgerEntry."Variant Code");
            sninfo.SetRange("Item No.", ItemLedgerEntry."Item No.");
            if sninfo.FindFirst() then begin
                sninfo.Blocked := true;
                sninfo.Modify();
            end;
        end;
    end;
    //CU 22 end

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        WhseRcptH: Record "Warehouse Receipt Header";
        PUrchRCPTH: Record "Purch. Rcpt. Header";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Warehouse Receipt Header":
                begin
                    RecRef.Open(DATABASE::"Warehouse Receipt Header");
                    if WhseRcptH.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(WhseRcptH);
                end;
            DATABASE::"Purch. Rcpt. Header":
                begin
                    RecRef.Open(DATABASE::"Purch. Rcpt. Header");
                    if PUrchRCPTH.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(PUrchRCPTH);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Warehouse Receipt Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            DATABASE::"Purch. Rcpt. Header":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Warehouse Receipt Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            DATABASE::"Purch. Rcpt. Header":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;
    //Azhar sending mail after invoiceing++
    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    procedure sendinginvoices(SalesInvHdrNo: Code[20])
    //procedure sendinginvoices(customer: Code[50])
    var
        RecCustumReportSel: Record "Custom Report Selection";
        SendTO: Text[250];
        SendTOMultiple: Text[250];
        SendCC: Text[250];
        i: Integer;
        j: Integer;
        EmailMsg: Codeunit "Email Message";
        EmailObj: Codeunit Email;
        //repcustnew: Report 60036;
        Body: Text;
        EOuts: OutStream;
        EIns: InStream;
        EmailBlob: Codeunit "Temp Blob";
        RecipientType: Enum "Email Recipient Type";
        VarRecipient: list of [Text];
        VarRecipientCC: list of [Text];
        VarRecipientBCC: list of [Text];
        FileName: Text[250];
        Recref: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        Instr: InStream;
        SIHNEW: Record 112;
        TaxInv: Report "Tax Invoice";
        SentmailBool: Boolean;
        Char: Char;
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        Clear(SendCC);
        Clear(SendTO);
        Clear(SendTOMultiple);
        Clear(i);
        Clear(j);
        Clear(SentmailBool);
        Clear(FileName);
        Clear(Instr);
        Clear(OutStr);
        SalesInvHeader.Reset();
        SalesInvHeader.SetRange("No.", SalesInvHdrNo);
        if SalesInvHeader.FindFirst() then begin
            VarRecipient.RemoveRange(1, VarRecipient.Count);
            VarRecipientCC.RemoveRange(1, VarRecipientCC.Count);
            RecCustumReportSel.Reset();
            RecCustumReportSel.SetRange("Source No.", SalesInvHeader."Sell-to Customer No.");
            //RecCustumReportSel.SetRange("Source No.", customer);
            RecCustumReportSel.SetRange(Usage, RecCustumReportSel.Usage::"S.Invoice");
            RecCustumReportSel.SetFilter("Send To Email", '<>%1', '');
            if RecCustumReportSel.FindSet() then begin
                repeat
                    if RecCustumReportSel."Email Type" = RecCustumReportSel."Email Type"::CC then begin
                        VarRecipientCC.Add(RecCustumReportSel."Send To Email");
                    end else begin
                        VarRecipient.Add(RecCustumReportSel."Send To Email");
                    end;
                until RecCustumReportSel.Next = 0;
                EmailMsg.Create(VarRecipient, 'Acertara Invoice: ' + SalesInvHeader."No.", '', true, VarRecipientCC, VarRecipientBCC);
                //*****SAVE As PDF Code*****
                Clear(FileName);
                Clear(Instr);
                Clear(OutStr);
                Clear(Recref);
                SIHNEW.Reset();
                SIHNEW.SetRange("No.", SalesInvHeader."No.");
                IF SIHNEW.FindFirst() then begin
                    //Message(SIHNEW."No." + SIHNEW."Store No.");
                    Recref.GetTable(SIHNEW);
                    Clear(TempBlob);
                    TempBlob.CreateOutStream(OutStr);
                    //Report.SaveAs(Report::"Tax Invoice", '', ReportFormat::Pdf, OutStr);
                    Clear(TaxInv);
                    TaxInv.SetTableView(SIHNEW);
                    TaxInv.SaveAs('', ReportFormat::Pdf, OutStr);
                    TempBlob.CreateInStream(InStr);
                    FileName := SIHNEW."No." + '_' + FORMAT(Today) + '.pdf';
                    EmailMsg.AddAttachment(FileName, '.pdf', InStr);
                    SentmailBool := true;
                end;
                //**** Email Body Creation *****
                /*
                EmailMsg.AppendToBody('<p><font face="Georgia">Dear <B>Sir,</B></font></p>');
                Char := 13;
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody('<p><font face="Georgia"> <B>!!!Greetings!!!</B></font></p>');
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody('<p><font face="Georgia"><BR>Please find enclosed Tax Invoice.</BR></font></p>');
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody('<p><font face="Georgia"><BR>Thanking you,</BR></font></p>');
                EmailMsg.AppendToBody('<p><font face="Georgia"><BR>Warm Regards,</BR></font></p>');
                EmailMsg.AppendToBody('<p><font face="Georgia"><BR><B>For Acertara</B></BR></font></p>');
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody(FORMAT(Char));
                */
                EmailMsg.AppendToBody('<p><font face="Georgia">Hello,</font></p>');
                Char := 13;
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody('<p><font face="Georgia">Thank you for your business! Please find attached a new invoice from Acertara; ' + SalesInvHeader."No." + ' is dated ' + Format(SalesInvHeader."Posting Date") + ', and is due ' + Format(SalesInvHeader."Due Date") + '.</font></p>');
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody('<p><font face="Georgia">As a small business, we depend on our customers to pay these invoices on time. Please note that the terms and conditions of this purchase include a finance charge of 1.5% for invoices that are not paid on time.</font></p>');
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody('<p><font face="Georgia">Now pay with a credit card online: Email accounting@acertaralabs.com to request an online CC payment invoice. American Express credit card payments will incur a 4% processing fee, and all other credit card types will incur a 3% processing fee.</font></p>');
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody('<p><font face="Georgia">If there is anything we can do to improve our billing process to ensure on-time payment, please contact Acertara_Cares@acertaralabs.com and let us know.</font></p>');
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody('</BR></BR><font face="Georgia">Acertara Acoustic Laboratories</font>');
                EmailMsg.AppendToBody('</BR><font face="Georgia">Accounting Department</font>');
                EmailMsg.AppendToBody('</BR><font face="Georgia">accounting@acertaralabs.com</font>');
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody(FORMAT(Char));
                EmailMsg.AppendToBody('</BR></BR><font face="Georgia">1950 Lefthand Creek Lane</font>');
                EmailMsg.AppendToBody('</BR><font face="Georgia">Longmont, CO 80501</font>');
                EmailMsg.AppendToBody('</BR><font face="Georgia">(303) 834-8413 - main</font>');

                //**** Email Send Function **** 
                if SentmailBool = true then
                    EmailObj.Send(EmailMsg, Enum::"Email Scenario"::Default);
            end;
        end;
    end;
    //Azhar sending mail after invoiceing--
}