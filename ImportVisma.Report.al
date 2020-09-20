report 50049 "VOS Import Visma"
{
    ProcessingOnly = true;
    Caption = 'Import Visma Salaries';
    ApplicationArea = All;
    UsageCategory = Administration;

    dataset
    {

    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FileName; FileName)
                    {
                        ApplicationArea = Suite;
                        Caption = 'File Name';
                        ToolTip = 'Specifies the name of the file to import.';
                        AssistEdit=true;
                        trigger OnAssistEdit()
                        BEGIN
                            SelectFileName;
                        END;

                    }
                    field(GenJournalTemplate; GenJnlLine."Journal Template Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gen. Journal Template';
                        ToolTip = 'Specifies the general journal template that is used by the batch job.';
                        TableRelation = "Gen. Journal Template";
                        trigger OnValidate()
                        begin
                            GenJnlLine."Journal Batch Name" := '';
                        end;
                    }
                    field(GenJournalBatch; GenJnlLine."Journal Batch Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gen. Journal Batch';
                        Lookup = true;
                        ToolTip = 'Specifies the general journal batch that is used by the batch job.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            GenJnlLine.TestField("Journal Template Name");
                            GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
                            GenJnlBatch.FilterGroup(2);
                            GenJnlBatch.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlBatch.FilterGroup(0);
                            GenJnlBatch."Journal Template Name" := GenJnlLine."Journal Template Name";
                            GenJnlBatch.Name := GenJnlLine."Journal Batch Name";
                            if PAGE.RunModal(0, GenJnlBatch) = ACTION::LookupOK then begin
                                Text := GenJnlBatch.Name;
                                exit(true);
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            if GenJnlLine."Journal Batch Name" <> '' then begin
                                GenJnlLine.TestField("Journal Template Name");
                                GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                            end;

                        end;
                    }
                    field(DocumentNo; DocNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies the number of the document that is processed by the report or batch job.';
                    }

                }
            }
        }
        trigger onopenpage()
        begin
            DocNo := 'SALARY';
            clear(FileName);
        end;

    }

    trigger OnInitReport()
    begin
        DocNo := 'SALARY';
        clear(FileName);
    end;

    trigger OnPreReport()
    BEGIN
        TestMandatoryFields;
        //clear(FileName);
    END;

    trigger OnPostReport()
    BEGIN
        StartProcess;
    END;

    procedure SelectFileName()
    BEGIN
        UploadIntoStream(WindowTitle, '', '', FileName, InStr);
    END;

    procedure StartProcess()
    VAR
        ImportBuffer: Record "Import Visma Log" TEMPORARY;
    BEGIN
        
        ReadFileIntoBuffer(ImportBuffer);
        MapBufferToGenJnlLn(ImportBuffer);
        SaveLog(ImportBuffer);
    END;

    procedure ReadFileIntoBuffer(VAR ImportBuffer: Record "Import Visma Log")
    VAR
        ImportFile: File;
        Line: Text[1024];
        i: Integer;
        Int: integer;
        r: Report "Close Income Statement";
        Curdt: DateTime;
    BEGIN
        Curdt := CurrentDateTime;
        while not (InStr.EOS) do begin
            Int := InStr.READTEXT(Line);
            i := i + 1;
            ImportBuffer."Entry No." := i;
            ImportBuffer."Fin. Company ID" := RemoveTrailingZeroes(COPYSTR(Line, 1, 5));
            ImportBuffer."Financial Year" := Text2Int(COPYSTR(Line, 6, 4));
            ImportBuffer.Daybook := RemoveTrailingZeroes(COPYSTR(Line, 10, 3));
            ImportBuffer.Entry := RemoveTrailingZeroes(COPYSTR(Line, 35, 6));
            ImportBuffer."Entry Period" := RemoveTrailingZeroes(COPYSTR(Line, 41, 2));
            ImportBuffer."Entry Date" := Text2Date(COPYSTR(Line, 43, 8));
            ImportBuffer.description := delchr(COPYSTR(Line, 51, 30), '>', ' ');
            ImportBuffer."Account Number" := ReplaceGLAccount(RemoveTrailingZeroes(COPYSTR(Line, 81, 11)));
            ImportBuffer.Amount := Text2Decimal(COPYSTR(Line, 92, 11));
            ImportBuffer.Quantity := Text2Decimal(COPYSTR(Line, 133, 9));
            ImportBuffer."Cost Center" := RemoveTrailingZeroes(COPYSTR(Line, 269, 7));
            ImportBuffer."Cost Unit" := RemoveTrailingZeroes(COPYSTR(Line, 276, 7));
            ImportBuffer."File Name" := FileName;
            ImportBuffer."User Id" := UserId;
            ImportBuffer."Row Data" := copystr(Line, 1, 250);
            ImportBuffer."Row Data 2" := copystr(Line, 251);
            ImportBuffer."Journal Batch Name" := GenJnlLine."Journal Batch Name";
            ImportBuffer."Journal Template Name" := GenJnlLine."Journal Template Name";
            ImportBuffer."Import DateTime" := Curdt;
            if ImportBuffer."Account Number" <> '' then
                ImportBuffer.INSERT;
        END;

    END;

    procedure MapBufferToGenJnlLn(VAR ImportBuffer: Record "Import Visma Log")
    VAR
        GenJnlLn: Record "Gen. Journal Line";
    BEGIN
        WITH GenJnlLn DO BEGIN
            IF ImportBuffer.FINDSET THEN
                REPEAT
                    VALIDATE("Journal Template Name", GenJnlLine."Journal Template Name");
                    VALIDATE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                    VALIDATE("Line No.", ImportBuffer."Entry No." * 10000);
                    VALIDATE("Document No.", DocNo + ImportBuffer.Entry);
                    VALIDATE("Posting Date", ImportBuffer."Entry Date");
                    VALIDATE("Account Type", "Account Type"::"G/L Account");
                    VALIDATE("Account No.", ImportBuffer."Account Number");
                    VALIDATE("Gen. Posting Type", "Gen. Posting Type"::" ");
                    VALIDATE("Gen. Bus. Posting Group", '');
                    VALIDATE("Gen. Prod. Posting Group", '');
                    VALIDATE("VAT Bus. Posting Group", '');
                    VALIDATE("VAT Prod. Posting Group", '');
                    VALIDATE("Amount", ImportBuffer."Amount");
                    Description := ImportBuffer.Description;
                    INSERT(TRUE);
                    VALIDATE("Shortcut Dimension 1 Code", ImportBuffer."Cost Center");
                    MODIFY(TRUE);
                UNTIL ImportBuffer.NEXT = 0;
        END;
    END;

    procedure SaveLog(VAR ImportBuffer: Record "Import Visma Log")
    VAR
        ImportLog: Record "Import Visma Log";
        RegNo: Integer;
        b: record TempBlob;
    BEGIN

        if ImportLog.FindLast() then
            RegNo := ImportLog."Register No." + 1
        else
            RegNo := 1;
        IF ImportBuffer.FINDSET then
            repeat
                ImportLog.TransferFields(ImportBuffer);
                ImportLog."Register No." := RegNo;
                ImportLog.INSERT(TRUE);
            UNTIL ImportBuffer.NEXT = 0;

    END;

    procedure Text2Date(Value: Text[30]): Date
    VAR
        Year: Integer;
        Month: Integer;
        Day: Integer;
    BEGIN
        EVALUATE(Day, COPYSTR(Value, 1, 2));
        EVALUATE(Month, COPYSTR(Value, 3, 2));
        EVALUATE(Year, COPYSTR(Value, 5, 4));
        EXIT(DMY2DATE(Day, Month, Year));
    END;

    procedure Text2Decimal(Value: Code[30]): Decimal
    VAR
        Amount: Decimal;
        Negative: Boolean;
    BEGIN
        Negative := false;
        Value := RemoveTrailingZeroes(Value);

        IF Value = '' THEN
            EXIT(0);
        if CopyStr(Value, StrLen(Value)) = '-' then begin
            Negative := true;
            Value := CopyStr(Value, 1, StrLen(Value) - 1);
        end;
        EVALUATE(Amount, Value);
        Amount := Amount / 100;
        if Negative then
            exit(-1 * Amount);
        EXIT(Amount);
    END;

    procedure Text2Int(Value: Code[30]): Integer
    VAR
        Amount: Integer;
    BEGIN
        IF Value = '' THEN
            EXIT(0);

        EVALUATE(Amount, Value);
        EXIT(Amount);
    END;

    procedure RemoveTrailingZeroes(Value: Text[30]): Text[30]
    BEGIN
        EXIT(DELCHR(Value, '<', '0'));
    END;

    procedure TestMandatoryFields()
    VAR
    BEGIN
        IF (GenJnlLine."Journal Batch Name" = '') OR (GenJnlLine."Journal Template Name" = '') OR (FileName = '') or (DocNo = '') THEN
            ERROR(PleaseFillOutReqForm);
        GenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", genJnlLine."Journal Batch Name");
        IF NOT GenJnlLine.ISEMPTY THEN
            ERROR(JournalNotEmpty);
    END;

    procedure ReplaceGLAccount(Value: Code[20]): Code[20]
    VAR
        GLAcc: Record 15;
        GLAccList: page "G/L Account List";
    BEGIN
        IF GLAcc.GET(Value) THEN
            EXIT(Value);

        IF NOT CONFIRM(ReplaceText, TRUE, Value) THEN
            ERROR('');
        if PAGE.RUNMODAL(0, GLAcc) = Action::LookupOK then
            EXIT(GLAcc."No.");
        error('');
    END;

    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        FileName: Text[250];
        DocNo: code[10];
        InStr: instream;
        WindowTitle: Label 'Selecteer Bestand';
        ReplaceText: Label 'Grootboek %1 is niet gevonden, welk nummer wilt u in plaats daarvan gebruiken?';
        PleaseFillOutReqForm: Label 'De opties zijn niet compleet.';
        JournalNotEmpty: Label 'Het dagboek is niet leeg.';

}
