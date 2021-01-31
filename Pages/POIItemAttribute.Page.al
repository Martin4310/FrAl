page 50040 "POI Item Attribute"
{
    Caption = 'Artikelmerkmale';
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
                field("Attribute Type"; "Attribute Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Merkmalstyp';
                }
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
                field(CustAttribute; CustAttribute)
                {
                    ApplicationArea = All;
                    ToolTip = 'Kunden Merkmal';
                }
                field(VendAttribute; VendAttribute)
                {
                    ApplicationArea = All;
                    ToolTip = 'Lieferanten Merkmal';
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
    // trigger OnAfterGetRecord()
    // begin
    //     ActItemNo := "Item No.";
    // end;

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