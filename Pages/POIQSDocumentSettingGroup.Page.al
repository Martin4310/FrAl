
page 50012 "POI QS DocumentSetting Group"
{
    Caption = 'QS DocumentSetting Group';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "POI QS Document Setting";

    layout
    {
        area(Content)
        {
            repeater("POI QS Document Setting Group")
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}