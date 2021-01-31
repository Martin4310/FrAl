page 5087941 "POI Cost Category Accounts"
{
    Caption = 'Cost Category Accounts';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Cost Category Accounts";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Cost Schema Code"; "Cost Schema Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Cost Category Code"; "Cost Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("G/L Account No."; "G/L Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("G/L Account Name"; "G/L Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Kostenart; Kostenart)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Kostenartenbez; gtx_Kostenartenbezeichnung)
                {
                    Caption = 'Kostenartenbezeichnung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Dimension Code"; "Dimension Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Dimension Value"; "Dimension Value")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }
                field(blocked; blocked)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    VAR
        lrc_DimValue: Record "Dimension Value";
    begin
        gtx_Kostenartenbezeichnung := '';
        IF lrc_DimValue.GET('KOSTENART', Kostenart) THEN
            gtx_Kostenartenbezeichnung := lrc_DimValue.Name;
    end;

    var
        gtx_Kostenartenbezeichnung: Text[50];
}