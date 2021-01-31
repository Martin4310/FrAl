page 50047 "POI Item Country"
{
    Caption = 'Item Country';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Item Country";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Country Code"; "Country Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Country Name"; "Country Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Visible = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ActItemNo := "Item No.";
    end;

    trigger OnClosePage()
    begin
        CreateCountryForItem(ActItemNo);
    end;

    var
        ActItemNo: Code[20];
}