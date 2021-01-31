table 5110452 "POI V/C Ship.AgentEmpties"
{
    Caption = 'Vend. Cust. Ship.Agent Empties';

    fields
    {
        field(1; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = 'Vendor,Customer,Shipping Agent,,Company Chain,Transfer,Sales Global,Purchase Global';
            OptionMembers = Vendor,Customer,"Shipping Agent",,"Company Chain",Transfer,"Sales Global","Purchase Global";
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST(Customer)) Customer."No."
            ELSE
            IF (Source = CONST(Vendor)) Vendor."No."
            ELSE
            IF (Source = CONST("Shipping Agent")) "Shipping Agent".Code
            ELSE
            IF (Source = CONST("Company Chain")) "POI Company Chain".Code;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item WHERE("POI Item Typ" = FILTER("Transport Item" | "Empties Item"));

            trigger OnValidate()
            var
                lrc_FruitVisionSetup: Record "POI ADF Setup";
                lrc_Item: Record Item;
                SSPText01Txt: Label 'Zur Zeit werden nur Artikel mit dem Artikeltyp Transportartikel unterstützt !';
            begin
                IF "Item No." <> '' THEN BEGIN
                    lrc_Item.GET("Item No.");

                    lrc_FruitVisionSetup.GET();
                    IF lrc_FruitVisionSetup."Empties/Transport Type" = lrc_FruitVisionSetup."Empties/Transport Type"::"Systematik 1" THEN
                        IF lrc_Item."POI Item Typ" = lrc_Item."POI Item Typ"::"Empties Item" THEN
                            ERROR(SSPText01Txt);

                    "Unit of Measure Code" := lrc_Item."Sales Unit of Measure";
                    "Item Description" := lrc_Item.Description;
                    "Item Description 2" := lrc_Item."Description 2";
                    "Item Typ" := lrc_Item."POI Item Typ";

                END ELSE BEGIN
                    "Unit of Measure Code" := '';
                    "Item Description" := '';
                    "Item Description 2" := '';
                END;
            end;
        }
        field(10; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(11; "Item Description 2"; Text[50])
        {
            Caption = 'Item Description 2';
        }
        field(12; "Item Typ"; Option)
        {
            Caption = 'Item Typ';
            OptionCaption = 'Trade Item,,Empties Item,Transport Item,,Packing Material,,,Spare Parts';
            OptionMembers = "Trade Item",,"Empties Item","Transport Item",,"Packing Material",,,"Spare Parts";
        }
        field(15; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
    }

    keys
    {
        key(Key1; Source, "Source No.", "Item No.")
        {
        }
    }
}

