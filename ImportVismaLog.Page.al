page 50049 "Import Visma Log"
{

    ApplicationArea = All;
    Caption = 'Import Visma Log';
    PageType = List;
    SourceTable = "Import Visma Log";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Register No."; "Register No.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Import DateTime"; "Import DateTime")
                {
                    ApplicationArea = All;
                }

                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                }
                field("User Id"; "User Id")
                {
                    ApplicationArea = All;
                }
                field("Journal Template Name"; "Journal Template Name")
                {
                    ApplicationArea = All;

                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Account Number"; "Account Number")
                {
                    ApplicationArea = All;
                }
                field("Entry Date"; "Entry Date")
                {
                    ApplicationArea = All;
                }
                field(Entry; Entry)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Fin. Company ID"; "Fin. Company ID")
                {
                    ApplicationArea = All;
                }
                field("Financial Year"; "Financial Year")
                {
                    ApplicationArea = All;
                }
                field("Entry Period"; "Entry Period")
                {
                    ApplicationArea = All;
                }
                field(Daybook; Daybook)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
                field("Cost Center"; "Cost Center")
                {
                    ApplicationArea = All;
                }
                field("Cost Unit"; "Cost Unit")
                {
                    ApplicationArea = All;
                }
                field("Row Data"; "Row Data")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
