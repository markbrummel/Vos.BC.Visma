table 50349 "Import Visma Log"
{
    Caption = 'Import Visma Log';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Register No."; Integer)
        {
            Caption = 'Register No.';
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Fin. Company ID"; Code[10])
        {
            Caption = 'Fin. Company ID';
            DataClassification = ToBeClassified;
        }
        field(4; "Financial Year"; Integer)
        {
            Caption = 'Financial Year';
            DataClassification = ToBeClassified;
        }
        field(5; "Daybook"; Code[10])
        {
            Caption = 'Daybook';
            DataClassification = ToBeClassified;
        }
        field(6; "Entry"; Code[10])
        {
            Caption = 'Entry';
            DataClassification = ToBeClassified;
        }
        field(7; "Entry Period"; Code[10])
        {
            Caption = 'Entry Period';
            DataClassification = ToBeClassified;
        }
        field(8; "Entry Date"; Date)
        {
            Caption = 'Entry Date';
            DataClassification = ToBeClassified;
        }
        field(9; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(10; "Account Number"; Code[20])
        {
            Caption = 'Account Number';
            DataClassification = ToBeClassified;
        }
        field(11; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(12; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(13; "Cost Center"; Code[10])
        {
            Caption = 'Cost Center';
            DataClassification = ToBeClassified;
        }
        field(14; "Cost Unit"; Code[10])
        {
            Caption = 'Cost Unit';
            DataClassification = ToBeClassified;
        }
        field(15; "File Name"; Text[250])
        {
            Caption = 'File Name';
            DataClassification = ToBeClassified;
        }
        field(16; "User Id"; code[50])
        {
            Caption = 'User Id';
            DataClassification = ToBeClassified;
        }
        field(17; "Import DateTime"; DateTime)
        {
            Caption = 'Import DateTime';
            DataClassification = ToBeClassified;
        }
        field(18; "Row Data"; Text[500])
        {
            Caption = 'Row Data';
            DataClassification = ToBeClassified;
        }
        field(19; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
        }
        field(20; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }

    }
    keys
    {
        key(PK; "Register No.", "Entry No.")
        {
            Clustered = true;
        }
    }

}
