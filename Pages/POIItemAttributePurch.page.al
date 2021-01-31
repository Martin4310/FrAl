page 50052 "POI Item Attribute Purch"
{
    Caption = 'Artikelmerkmale Einkauf';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Item Attribute";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Attribute Code"; "Attribute Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Merkmalscode';
                }
                field("Attribute Description"; "Attribute Description")
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

    trigger OnClosePage()
    begin
        CreateItemAttributes(ActItemNo);
    end;

    procedure setItemNo(ItemNo: Code[20])
    begin
        ActItemNo := ItemNo;
    end;

    var
        ActItemNo: Code[20];
}