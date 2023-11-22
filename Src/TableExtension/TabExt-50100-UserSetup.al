tableextension 50100 UserSetup extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50100; Signature; Blob)
        {
            Subtype = Bitmap;
        }
        field(50101; Picture; Blob)
        {

        }
        field(50102; "Short Close"; Boolean)
        {
            Caption = 'PO Short Close';
            DataClassification = ToBeClassified;
        }
        field(50103; "QC Authorization"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    procedure SetPictureFromBlob(TempBlob: Codeunit "Temp Blob")
    var
        RecordRef: RecordRef;
    begin
        RecordRef.GetTable(Rec);
        TempBlob.ToRecordRef(RecordRef, FieldNo(Signature));
        RecordRef.SetTable(Rec);
    end;

    procedure ImportFile()
    var
        InfileStream: InStream;
        FIlePath: Text;
        RecordRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        OutStremfile: OutStream;
        FileMgt: Codeunit "File Management";
    begin
        if UploadIntoStream('Select File...', '', '', FIlePath, InfileStream) then begin
            Rec.Signature.CreateOutStream(OutStremfile);
            CopyStream(OutStremfile, InfileStream);
            Rec.Modify();
        end;
    end;

    var
        myInt: Integer;
        TBlob: Codeunit "Temp Blob";
        PictureUpdated: Boolean;
}