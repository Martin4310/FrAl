page 50009 "POI Attachement Setup"
{
    Caption = 'Attachement Setup';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "POI Attachement Setup";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Name; "Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Document No"; "Document No")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Language Code"; Language)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Path; Path)
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