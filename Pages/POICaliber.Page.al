page 5110421 "POI Caliber"
{
    Caption = 'Caliber';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Caliber";

    layout
    {
        area(Content)
        {
            repeater(Group)
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
                field("Search Description"; "Search Description")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Internal Code in Item No."; "Internal Code in Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Is Caliber Group"; "Is Caliber Group")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Is Caliber Mix"; "Is Caliber Mix")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Sort Sequence"; "Sort Sequence")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Detail)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                RunObject = Page "POI Caliber Details";
                RunPageLink = "Caliber Code" = field(Code);
            }
        }
    }
}