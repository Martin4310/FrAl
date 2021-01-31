page 50004 "POI AllObjects"
{
    Caption = 'All Objects';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = AllObj;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Object Name"; "Object Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Object ID"; "Object ID")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}