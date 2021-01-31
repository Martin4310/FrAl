page 50039 "POI Tariffnumbers Import"
{
    Caption = 'Tariffnumbers Import';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Tariffnumber Import";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Warennummer; Warennummer)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description2; Description2)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description3; Description3)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Unit Code"; "Unit Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Unit Code numeric"; "Unit Code numeric")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(Import)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    TariffNumbers: Record "POI TariffNumber Import";
                begin
                    TariffNumbers.ReadTariffNumbers('\\port-ts-test\c$\Zolltarifnummern\18_SOVA2020.txt');
                end;
            }
            action(Compare)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    TariffNumbers: Record "POI TariffNumber Import";
                begin
                    TariffNumbers.CompareTariffdescription();
                end;
            }
            action(CheckItems)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    TariffNumbers: Record "POI TariffNumber Import";
                begin
                    TariffNumbers.ItemsWithoutTariffNumber();
                end;
            }
        }
    }
}