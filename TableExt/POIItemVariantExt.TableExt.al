tableextension 50053 "POI Item Variant Ext" extends "Item Variant"
{
    fields
    {
        field(5110340; "Country of Origin Code (Fruit)"; Code[10])
        {
            Caption = 'Erzeugerland Code';
            TableRelation = "Country/Region";
        }
        field(5110341; "POI Variety Code"; Code[10])
        {
            Caption = 'Sortencode';
            TableRelation = "POI Variety";
        }
        field(5110342; "POI Trademark Code"; Code[20])
        {
            Caption = 'Markencode';
            TableRelation = "POI Item Attribute 5";
        }
        field(5110343; "POI Caliber Code"; Code[10])
        {
            Caption = 'Kalibercode';
            TableRelation = "POI Caliber";
        }
        field(5110344; "POI Vendor Caliber Code"; Code[10])
        {
            Caption = 'Kreditor Kalibercode';
        }
        field(5110347; "POI Grade of Goods Code"; Code[10])
        {
            Caption = 'Handelsklassencode';
            TableRelation = "POI Grade of Goods";
        }
        field(5110349; "POI Packing Code"; Code[10])
        {
            Caption = 'Abpackungscode';
            TableRelation = "POI Item Attribute 4";
        }
        field(5110350; "POI Coding Code"; Code[10])
        {
            Caption = 'Kodierungscode';
            TableRelation = "POI Coding";
        }
        field(5110353; "POI Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            OptionCaption = ' ,Transmission,Organic';
            OptionMembers = " ",Transmission,Organic;
        }
        field(5110355; "POI Cultivation Process Code"; Code[10])
        {
            Caption = 'Cultivation Process Code';
            TableRelation = "POI Item Attribute 1";
        }
        field(5110360; "POI Item Attribute 1"; Code[10])
        {
            CaptionClass = '5110310,1,1';
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 1";
        }
        field(5110361; "POI Item Attribute 2"; Code[10])
        {
            CaptionClass = '5110310,1,2';
            Caption = 'Color Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 2";
        }
        field(5110362; "POI Item Attribute 3"; Code[10])
        {
            CaptionClass = '5110310,1,3';
            Caption = 'Quality Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 3".Code;
        }
        field(5110363; "POI Item Attribute 4"; Code[10])
        {
            CaptionClass = '5110310,1,4';
            Caption = 'Packing Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 4";
        }
        field(5110364; "POI Item Attribute 5"; Code[10])
        {
            CaptionClass = '5110310,1,5';
            Caption = 'Treatment Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 5";
        }
        field(5110365; "POI Item Attribute 6"; Code[20])
        {
            CaptionClass = '5110310,1,6';
            Caption = 'Proper Name Code';
            Description = 'EIA';
            TableRelation = "POI Proper Name";
            ValidateTableRelation = false;
        }
        field(5110366; "POI Item Attribute 7"; Code[10])
        {
            CaptionClass = '5110310,1,7';
            Caption = 'Conservation Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 7";
        }
        field(5110370; "POI Sales Unit of Measure"; Code[10])
        {
            Caption = 'Sales Unit of Measure';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(5110390; "POI MHD Variant"; Boolean)
        {
            Caption = 'MHD Variant';
        }
        field(5110391; "POI MHD 1"; Date)
        {
        }
        field(5110392; "POI MHD 2"; Date)
        {
        }
    }

    trigger OnDelete()
    var
        ItemTranslation: Record "Item Translation";
        SKU: Record "Stockkeeping Unit";
        ItemIdent: Record "Item Identifier";
    begin
        ItemTranslation.SETRANGE("Item No.", "Item No.");
        ItemTranslation.SETRANGE("Variant Code", Code);
        ItemTranslation.DELETEALL();

        SKU.SETRANGE("Item No.", "Item No.");
        SKU.SETRANGE("Variant Code", Code);
        SKU.DELETEALL(TRUE);

        ItemIdent.RESET();
        ItemIdent.SETCURRENTKEY("Item No.");
        ItemIdent.SETRANGE("Item No.", "Item No.");
        ItemIdent.SETRANGE("Variant Code", Code);
        ItemIdent.DELETEALL();
    end;
}