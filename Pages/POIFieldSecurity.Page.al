page 50001 "POI Field Security"
{
    Caption = 'Field Security';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Field Security";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(TableID; TableID)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(FieldID; FieldID)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnDrillDown()
                    var
                        AllFields: Record Field;
                    begin
                        AllFields.RESET();
                        AllFields.SETRANGE(TableNo, TableID);
                        IF Page.RUNMODAL(50032, AllFields) = ACTION::LookupOK THEN
                            FieldID := AllFields."No.";
                    end;
                }
                field("User Group"; "User Group")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Accesstype; Accesstype)
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
}