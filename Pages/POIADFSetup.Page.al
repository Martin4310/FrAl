page 50016 "POI ADF Setup"
{
    Caption = 'ADF Setup';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "POI ADF Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Internal Customer Code"; "Internal Customer Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Dim. Code Cost Category"; "Dim. Code Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Dim. No. Cost Category"; "Dim. No. Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }


            }
            group(Stammdaten)
            {
                field("Feature Level"; "Feature Level")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            group(Purchase)
            {
                field("No. Series Certificate Entries"; "No. Series Certificate Entries")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Purch. Claim No. Series"; "Purch. Claim No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }

            group(Sales)
            {

            }
            group(Transfer)
            {

            }
            group(Freight)
            {

            }
            group(Empties)
            {

            }
            group(Planing)
            {

            }
            group(Erzeugerabrechnung)
            {

            }
            group(Financials)
            {

            }
            group(Sonstiges)
            {

            }
        }
    }
}