table 5110729 "POI Item Stat. Base Data"
{
    Caption = 'Item Stat. Base Data';

    fields
    {
        field(1; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Prod.Grp,Item,Item+Country,Item+Country+Variety,,,Item+Country+Variety+Unit,,,All Attributes';
            OptionMembers = "Prod.Grp",Item,"Item+Country","Item+Country+Variety",,,"Item+Country+Variety+Unit",,,"All Attributes";
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(11; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
        }
        field(12; "Item Description"; Code[100])
        {
            Caption = 'Item Description';
        }
        field(13; "Item Description 2"; Code[100])
        {
            Caption = 'Item Description 2';
        }
        field(14; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(16; "Product Group Code"; Code[20])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;
        }
        field(17; "Product Group Search Desc."; Code[50])
        {
            Caption = 'Product Group Search Desc.';
        }
        field(19; "Vendor. No."; Code[20])
        {
            Caption = 'Vendor. No.';
        }
        field(20; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            TableRelation = "Country/Region";
        }
        field(21; "Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            TableRelation = "POI Variety";
        }
        field(22; "Variety Description"; Code[30])
        {
            Caption = 'Variety Description';
            Editable = false;
        }
        field(23; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
        }
        field(25; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(30; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
        }
        field(40; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            TableRelation = "POI Caliber".Code;
            ValidateTableRelation = false;
        }
        field(41; "Quality Code"; Code[10])
        {
            Caption = 'Quality Code';
            TableRelation = "POI Item Attribute 3".Code;
        }
        field(42; "Color Code"; Code[10])
        {
            Caption = 'Color Code';
            TableRelation = "POI Item Attribute 2";
        }
        field(44; "Conservation Code"; Code[10])
        {
            Caption = 'Conservation Code';
            TableRelation = "POI Item Attribute 7";
        }
        field(45; "Packing Code"; Code[10])
        {
            Caption = 'Packing Code';
            TableRelation = "POI Item Attribute 4";
        }
        field(46; "Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            TableRelation = "POI Coding";
        }
        field(47; "Treatment Code"; Code[10])
        {
            Caption = 'Treatment Code';
            TableRelation = "POI Item Attribute 5";
        }
        field(48; "Proper Name Code"; Code[20])
        {
            Caption = 'Proper Name Code';
            TableRelation = "POI Proper Name";
            ValidateTableRelation = false;
        }
        field(59; "Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            OptionCaption = ' ,Transission,Organic';
            OptionMembers = " ",Transission,Organic;
        }
        field(80; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
        }
        field(81; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            NotBlank = true;
            TableRelation = "POI Master Batch";
        }
        field(82; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            NotBlank = true;
            TableRelation = "POI Batch";
        }
        field(83; "Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            TableRelation = "POI Grade of Goods";
        }
        field(84; "Entry Location Code"; Code[10])
        {
            Caption = 'Entry Location Code';
            TableRelation = Location;
        }
        field(85; "Info 1"; Code[30])
        {
            CaptionClass = '5110300,1,1';
            Caption = 'Info 1';
        }
        field(86; "Info 2"; Code[50])
        {
            CaptionClass = '5110300,1,2';
            Caption = 'Info 2';
        }
        field(87; "Info 3"; Code[20])
        {
            CaptionClass = '5110300,1,3';
            Caption = 'Info 3';
        }
        field(88; "Info 4"; Code[20])
        {
            CaptionClass = '5110300,1,4';
            Caption = 'Info 4';
        }
        field(89; "Container No."; Code[20])
        {
            Caption = 'Container No.';
        }
        field(110; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(111; "Vendor Filter"; Code[20])
        {
            Caption = 'Vendor Filter';
            FieldClass = FlowFilter;
            TableRelation = Vendor;
            ValidateTableRelation = false;
        }
        field(112; "Country Filter"; Code[10])
        {
            Caption = 'Country Filter';
            FieldClass = FlowFilter;
            TableRelation = "Country/Region";
            ValidateTableRelation = false;
        }
        field(115; "Status Filter"; Option)
        {
            Caption = 'Status Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'Neuanlage,Offen,Geschlossen,Abgerechnet,Gesperrt,Manuell Gesperrt,Löschung';
            OptionMembers = Neuanlage,Offen,Geschlossen,Abgerechnet,Gesperrt,"Manuell Gesperrt","Löschung";
        }
        field(200; "Prd.-Grp"; Boolean)
        {
            CalcFormula = Exist ("POI Batch Variant" WHERE(State = FIELD("Status Filter"),
                                                       "Product Group Code" = FIELD("Product Group Code"),
                                                       "Vendor No." = FIELD("Vendor Filter"),
                                                       "Date of Delivery" = FIELD("Date Filter")));
            Caption = 'Prd.-Grp';
            Editable = false;
            FieldClass = FlowField;
        }
        field(204; Item; Boolean)
        {
            CalcFormula = Exist ("POI Batch Variant" WHERE("Item No." = FIELD("Item No."),
                                                       "Vendor No." = FIELD("Vendor Filter"),
                                                       State = FIELD("Status Filter"),
                                                       "Date of Delivery" = FIELD("Date Filter")));
            Caption = 'Item';
            Editable = false;
            FieldClass = FlowField;
        }
        field(206; "Item Country"; Boolean)
        {
            CalcFormula = Exist ("POI Batch Variant" WHERE(State = FIELD("Status Filter"),
                                                       "Item No." = FIELD("Item No."),
                                                       "Vendor No." = FIELD("Vendor Filter"),
                                                       "Country of Origin Code" = FIELD("Country of Origin Code"),
                                                       "Date of Delivery" = FIELD("Date Filter")));
            Caption = 'Item Country';
            Editable = false;
            FieldClass = FlowField;
        }
        field(210; "Item Country Variety"; Boolean)
        {
            CalcFormula = Exist ("POI Batch Variant" WHERE(State = FIELD("Status Filter"),
                                                       "Vendor No." = FIELD("Vendor Filter"),
                                                       "Item No." = FIELD("Item No."),
                                                       "Country of Origin Code" = FIELD("Country of Origin Code"),
                                                       "Variety Code" = FIELD("Variety Code"),
                                                       "Date of Delivery" = FIELD("Date Filter")));
            Caption = 'Item Country Variety';
            Editable = false;
            FieldClass = FlowField;
        }
        field(212; "Item Country Variety Unit"; Boolean)
        {
            CalcFormula = Exist ("POI Batch Variant" WHERE(State = FIELD("Status Filter"),
                                                       "Vendor No." = FIELD("Vendor Filter"),
                                                       "Item No." = FIELD("Item No."),
                                                       "Country of Origin Code" = FIELD("Country of Origin Code"),
                                                       "Variety Code" = FIELD("Variety Code"),
                                                       "Unit of Measure Code" = FIELD("Unit of Measure Code"),
                                                       "Date of Delivery" = FIELD("Date Filter")));
            Caption = 'Item Country Variety Unit';
            Editable = false;
            FieldClass = FlowField;
        }
        field(502; "CV Line No."; Integer)
        {
            Description = 'Colum Value';
        }
        field(505; "CV Colum Code"; Code[20])
        {
            Description = 'Colum Value';
        }
    }

    keys
    {
        key(Key1; "Entry Type", "Entry No.")
        {
        }
        key(Key2; "Item No.", "Variant Code", "Country of Origin Code", "Variety Code", "Trademark Code", "Unit of Measure Code")
        {
        }
        key(Key3; "Item No.", "Variant Code", "Variety Code", "Country of Origin Code", "Trademark Code", "Unit of Measure Code")
        {
        }
        key(Key4; "Item No.", "Variety Code", "Unit of Measure Code", "Country of Origin Code")
        {
        }
        key(Key5; "Item Description", "Variety Code", "Unit of Measure Code", "Country of Origin Code")
        {
        }
        key(Key6; "Search Description", "Variety Code", "Unit of Measure Code", "Country of Origin Code")
        {
        }
        key(Key7; "Product Group Search Desc.", "Item Description")
        {
        }
    }


    trigger OnInsert()
    begin
        IF "Entry No." = 0 THEN BEGIN
            lrc_ItemStatisticBaseData.SETRANGE("Entry Type", "Entry Type");
            IF lrc_ItemStatisticBaseData.FIND('+') THEN
                "Entry No." := lrc_ItemStatisticBaseData."Entry No." + 1
            ELSE
                "Entry No." := 1;
        END;
    end;

    var
        lrc_ItemStatisticBaseData: Record "POI Item Stat. Base Data";
}

