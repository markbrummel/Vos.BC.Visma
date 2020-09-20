table 50049 "Import Visma Log"
{
    Caption = 'Import Visma Log';
    fields
    {
        field(1; "Register No."; Integer) { Caption = 'Register No.'; }
        field(2; "Entry No."; Integer) { Caption = 'Entry No.'; }
        field(3; "Fin. Company ID"; Code[10]) { Caption = 'Fin. Company ID'; }
        field(4; "Financial Year"; Integer) { Caption = 'Financial Year'; }
        field(5; "Daybook"; Code[10]) { Caption = 'Daybook'; }
        field(6; "Entry"; Code[10]) { Caption = 'Entry'; }
        field(7; "Entry Period"; Code[10]) { Caption = 'Entry Period'; }
        field(8; "Entry Date"; Date) { Caption = 'Entry Date'; }
        field(9; "Description"; Text[250]) { Caption = 'Description'; }
        field(10; "Account Number"; Code[20]) { Caption = 'Account Number'; }
        field(11; "Amount"; Decimal) { Caption = 'Amount'; }
        field(12; "Quantity"; Decimal) { Caption = 'Quantity'; }
        field(13; "Cost Center"; Code[10]) { Caption = 'Cost Center'; }
        field(14; "Cost Unit"; Code[10]) { Caption = 'Cost Unit'; }
        field(15; "File Name"; Text[250]) { Caption = 'File Name'; }
        field(16; "User Id"; code[50]) { Caption = 'User Id'; }
        field(17; "Import DateTime"; DateTime) { Caption = 'Import DateTime'; }
        field(19; "Journal Template Name"; Code[10]) { Caption = 'Journal Template Name'; }
        field(20; "Journal Batch Name"; Code[10]) { Caption = 'Journal Batch Name'; }
        field(18; "Row Data"; Text[250]) { Caption = 'Row Data'; }
        field(22; "Row Data 2"; Text[250]) { Caption = 'Row Data'; }
    }
    keys
    {
        key(PK; "Register No.", "Entry No.") { Clustered = true; }
    }

}
