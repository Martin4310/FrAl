table 50941 "POI Item Country"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
        field(3; "Country Code"; Code[10])
        {
            Caption = 'Land';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region".Code where("POI Relevant" = const(true));
        }
        field(4; "Country Name"; Text[50])
        {
            Caption = 'Ländername';
            FieldClass = FlowField;
            CalcFormula = lookup ("Country/Region".Name where(Code = field("Country Code")));
        }
    }

    keys
    {
        key(PK; "Item No.", "Country Code")
        {
            Clustered = true;
        }
    }

    procedure CreateCountryForItem(ItemNo: Code[20]);
    begin
        SpecialText := '';
        ItemCountry.SetRange("Item No.", ItemNo);
        if ItemCountry.FindSet() then
            repeat
                if SpecialText <> '' then
                    SpecialText += ';';
                SpecialText += ItemCountry."Country Code";
            until ItemCountry.Next() = 0;
        Item.Get(ItemNo);
        Item."POI Country of Origin" := copystr(SpecialText, 1, MaxStrLen(Item."POI Country of Origin"));
        Item.Modify();
    end;

    var
        Item: Record Item;
        ItemCountry: Record "POI Item Country";
        SpecialText: Text[100];



}