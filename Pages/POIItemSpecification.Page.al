page 50045 "POI Item Specification"
{
    Caption = 'Item Specification';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Item Specification";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Visible = false;
                }
                field("Attribut No."; "Attribut Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    TableRelation = "Item Attribute".Name;
                }
                field("Attribut Value"; "Attribut Value")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    TableRelation = "Item Attribute Value".Value where("Attribute Name" = field("Attribut Name"));
                }
                field(Mandatory; Mandatory)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Dependency; Dependency)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
    }
}