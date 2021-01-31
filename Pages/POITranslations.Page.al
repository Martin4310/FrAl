page 50010 "POI Translations"
{
    Caption = 'Translations';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "POI Translations";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Table ID"; "Table ID")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Name; Code)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Code 2"; "Code 2")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Language Code"; "Language Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Description 3"; "Description 3")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Description 4"; "Description 4")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
    }
}