table 5110501 "POI Producer Statment Fees"
{
    Caption = 'Producer Statment Fees';

    fields
    {
        field(1; "Cost Category Code"; Code[20])
        {
            Caption = 'Cost Category Code';
            TableRelation = "POI Cost Category";
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(3; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;

            trigger OnValidate()
            begin
                IF "Product Group Code" <> '' THEN BEGIN
                    lrc_ProductGroup.RESET();
                    lrc_ProductGroup.SETRANGE(Code, "Product Group Code");
                    IF lrc_ProductGroup.FIND('-') THEN
                        "Item Category Code" := lrc_ProductGroup."Item Category Code";
                END;
            end;
        }
        field(4; "Member of Prod. Companionship"; Code[20])
        {
            Caption = 'Member of Prod. Companionship';
            //TableRelation = Vendor WHERE ("POI Is Producer Association"=CONST(true)); //TODO: vendor
        }
        field(5; "Member State Companionship"; Option)
        {
            Caption = 'Member State Companionship';
            OptionCaption = ' ,Ohne,,,Mitglied,Nicht Mitglied,,,Sonstiges';
            OptionMembers = " ",Ohne,,,Mitglied,"Nicht Mitglied",,,Sonstiges;
        }
        field(6; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(8; "From Turn Over"; Decimal)
        {
            Caption = 'From Turn Over';
        }
        field(15; Typ; Option)
        {
            Caption = 'Typ';
            OptionCaption = 'Percentage,Amount';
            OptionMembers = Percentage,Amount;
        }
        field(16; Value; Decimal)
        {
            Caption = 'Value';
        }
        field(20; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
    }

    keys
    {
        key(Key1; "Cost Category Code", "Product Group Code", "Item No.", "Vendor No.", "Member of Prod. Companionship", "Member State Companionship", "From Turn Over")
        {
        }
        key(Key2; "Item Category Code")
        {
        }
    }
    var
        lrc_ProductGroup: Record "POI Product Group";
}

