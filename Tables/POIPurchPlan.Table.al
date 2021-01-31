table 5110558 "POI Purch. Plan"
{
    Caption = 'Purch. Plan';
    // DrillDownFormID = Form5088180;
    // LookupFormID = Form5088180;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Planing Type"; Option)
        {
            Caption = 'Planing Type';
            OptionCaption = 'Vendor Assortment,Global Assortment,,,,,Quotes by Item';
            OptionMembers = "Vendor Assortment","Global Assortment",,,,,"Quotes by Item";

            trigger OnValidate()
            begin
                IF "Planing Type" <> xRec."Planing Type" THEN BEGIN
                    IF TestIfLinesExist() = TRUE THEN
                        ERROR('Es sind bereits Zeilen vorhanden! Änderung nicht möglich!');
                    IF "Planing Starting Date" <> 0D THEN
                        VALIDATE("Planing Starting Date");
                END;

                IF "Planing Type" = "Planing Type"::"Global Assortment" THEN BEGIN
                    "Vendor No." := '';
                    "Vend. Name" := '';
                    "Producer No." := '';
                    "Prod. Name" := '';
                END;
            end;
        }
        field(8; "Planing Description"; Text[80])
        {
            Caption = 'Planing Description';
        }
        field(10; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No." WHERE(Blocked = FILTER(' '));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_Vendor: Record Vendor;
                lcu_BaseData: Codeunit "POI Base Data Mgt";
                AGILES_TEXT002Txt: Label 'Vendor %1 don''t exist !', Comment = '%1';

            begin
                IF NOT lcu_BaseData.VendorValidate("Vendor No.") THEN
                    ERROR(AGILES_TEXT002Txt, "Vendor No.");

                IF TestIfLinesExist() = TRUE THEN
                    // Es sind bereits Zeilen vorhanden!
                    ERROR(AgilesText01Txt);

                IF "Vendor No." <> '' THEN BEGIN
                    lrc_Vendor.GET("Vendor No.");
                    "Vend. Name" := lrc_Vendor.Name;
                    "Territory Code" := lrc_Vendor."Territory Code";
                END ELSE BEGIN
                    "Vend. Name" := '';
                    "Territory Code" := '';
                END;
            end;
        }
        field(12; "Vend. Name"; Text[100])
        {
            Caption = 'Vend. Name';
        }
        field(13; "Vend. Name 2"; Text[50])
        {
            Caption = 'Vend. Name 2';
        }
        field(19; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(20; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;

            trigger OnValidate()
            var
                lrc_Item: Record Item;
            begin
                IF "Item No." <> '' THEN BEGIN
                    lrc_Item.GET("Item No.");
                    "Item Description" := lrc_Item.Description;
                    "Item Description 2" := lrc_Item."Description 2";
                    "Country of Origin Code" := lrc_Item."POI Countr of Ori Code (Fruit)";
                    "Variety Code" := lrc_Item."POI Variety Code";
                    "Trademark Code" := lrc_Item."POI Trademark Code";
                    "Caliber Code" := lrc_Item."POI Caliber Code";
                    "Quality Code" := lrc_Item."POI Item Attribute 3";
                    "Color Code" := lrc_Item."POI Item Attribute 2";
                    "Grade of Goods Code" := lrc_Item."POI Grade of Goods Code";
                    "Conservation Code" := lrc_Item."POI Item Attribute 7";
                    "Packing Code" := lrc_Item."POI Item Attribute 4";
                    "Coding Code" := lrc_Item."POI Coding Code";
                    "Treatment Code" := lrc_Item."POI Item Attribute 5";
                    "Proper Name Code" := lrc_Item."POI Item Attribute 6";
                    "Cultivation Type" := lrc_Item."POI Cultivation Type";
                    VALIDATE("Unit of Measure Code", lrc_Item."Sales Unit of Measure");
                END ELSE BEGIN
                    "Item Description" := '';
                    "Item Description 2" := '';
                    "Country of Origin Code" := '';
                    "Variety Code" := '';
                    "Trademark Code" := '';
                    "Caliber Code" := '';
                    "Vendor Caliber Code" := '';
                    "Quality Code" := '';
                    "Color Code" := '';
                    "Grade of Goods Code" := '';
                    "Conservation Code" := '';
                    "Packing Code" := '';
                    "Coding Code" := '';
                    "Treatment Code" := '';
                    "Proper Name Code" := '';
                    "Cultivation Type" := "Cultivation Type"::" ";
                    "Unit of Measure Code" := '';
                END;
            end;
        }
        field(22; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(23; "Item Description 2"; Text[50])
        {
            Caption = 'Item Description 2';
        }
        field(25; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            TableRelation = "Country/Region";
        }
        field(26; "Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            TableRelation = "POI Variety".Code;
        }
        field(27; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            TableRelation = "POI Trademark";
        }
        field(28; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            TableRelation = "POI Caliber".Code;
            ValidateTableRelation = false;
        }
        field(29; "Vendor Caliber Code"; Code[10])
        {
            Caption = 'Vendor Caliber Code';
            TableRelation = "POI Caliber - Vendor Caliber"."Vendor No." WHERE("Caliber Code" = FIELD("Caliber Code"));
            ValidateTableRelation = false;
        }
        field(30; "Quality Code"; Code[10])
        {
            Caption = 'Quality Code';
            TableRelation = "POI Item Attribute 3".Code;
        }
        field(31; "Color Code"; Code[10])
        {
            Caption = 'Color Code';
            TableRelation = "POI Item Attribute 2";
        }
        field(32; "Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            TableRelation = "POI Grade of Goods";
        }
        field(33; "Conservation Code"; Code[10])
        {
            Caption = 'Conservation Code';
            TableRelation = "POI Item Attribute 7";
        }
        field(34; "Packing Code"; Code[10])
        {
            Caption = 'Packing Code';
            TableRelation = "POI Item Attribute 4";
        }
        field(35; "Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            TableRelation = "POI Coding";
        }
        field(36; "Treatment Code"; Code[10])
        {
            Caption = 'Treatment Code';
            TableRelation = "POI Item Attribute 5";
        }
        field(37; "Proper Name Code"; Code[20])
        {
            Caption = 'Proper Name Code';
            TableRelation = "POI Proper Name";
            ValidateTableRelation = false;
        }
        field(38; "Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;
        }
        field(39; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(40; "Producer No."; Code[20])
        {
            Caption = 'Producer No.';
            TableRelation = Vendor."No." WHERE("POI Is Manufacturer" = CONST(true),
                                              Blocked = FILTER(' '));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                IF TestIfLinesExist() = TRUE THEN
                    // Es sind bereits Zeilen vorhanden!
                    ERROR(AgilesText01Txt);
            end;

            trigger OnValidate()
            var
                lrc_Vendor: Record Vendor;
                lcu_BaseData: Codeunit "POI Base Data Mgt";
                AGILES_TEXT002Txt: Label 'Vendor %1 don''t exist !', Comment = '%1';

            begin
                IF NOT lcu_BaseData.VendorValidate("Producer No.") THEN
                    ERROR(AGILES_TEXT002Txt, "Producer No.");
                IF "Producer No." <> '' THEN BEGIN
                    lrc_Vendor.GET("Producer No.");
                    "Prod. Name" := lrc_Vendor.Name;
                END ELSE
                    "Prod. Name" := '';
            end;
        }
        field(42; "Prod. Name"; Text[100])
        {
            Caption = 'Prod. Name';
        }
        field(59; "Territory Code"; Code[10])
        {
            Caption = 'Gebietscode';
            TableRelation = Territory;

            trigger OnValidate()
            begin
                IF TestIfLinesExist() = TRUE THEN
                    // Es sind bereits Zeilen vorhanden!
                    ERROR(AgilesText01Txt);
            end;
        }
        field(60; "Your Reference"; Text[70])
        {
            Caption = 'Your Reference';
        }
        field(70; "Planing Starting Date"; Date)
        {
            Caption = 'Planing Starting Date';

            trigger OnLookup()
            var
                lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
            begin
                // ## ADF.s ##
                IF lcu_GlobalFunctions.SelectDateByCalendar("Planing Starting Date") THEN
                    VALIDATE("Planing Starting Date");
                // ## ADF.e ##
            end;

            trigger OnValidate()
            var
                Errorlabel: Text;
            begin
                IF TestIfLinesExist() = TRUE THEN
                    // Es sind bereits Zeilen vorhanden!
                    ERROR(AgilesText01Txt);

                IF "Planing Type" = "Planing Type"::"Global Assortment" THEN BEGIN
                    lrc_PurchPlanHeader.SETFILTER("No.", '<>%1', "No.");
                    lrc_PurchPlanHeader.SETRANGE("Planing Type", "Planing Type");
                    lrc_PurchPlanHeader.SETRANGE("Planing Starting Date", lrc_PurchPlanHeader."Planing Starting Date");
                    IF lrc_PurchPlanHeader.FIND('-') THEN begin
                        Errorlabel := 'Es ist bereits eine globale Planung ' + lrc_PurchPlanHeader."No." + ' für das Planungsdatum vorhanden!';
                        ERROR(Errorlabel);
                    end;
                END;
            end;
        }
        field(71; "Planing Ending Date"; Date)
        {
            Caption = 'Planing Ending Date';

            trigger OnLookup()
            var
                lcu_GlobalFunctionsMgt: Codeunit "POI GlobalFunctionsMgt";
            begin
                IF lcu_GlobalFunctionsMgt.SelectDateByCalendar("Planing Ending Date") THEN
                    VALIDATE("Planing Starting Date");
            end;
        }
        field(80; "Shipping Date Vendor"; Date)
        {
            Caption = 'Shipping Date Vendor';

            trigger OnLookup()
            var
                lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
            begin
                IF lcu_GlobalFunctions.SelectDateByCalendar("Shipping Date Vendor") THEN
                    VALIDATE("Shipping Date Vendor");
            end;

            trigger OnValidate()
            begin
                IF TestIfLinesExist() = TRUE THEN
                    // Es sind bereits Zeilen vorhanden!
                    ERROR(AgilesText01Txt);
            end;
        }
        field(81; "Expected Receipt Date Location"; Date)
        {
            Caption = 'Delivery Date Location';

            trigger OnLookup()
            var
                lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
            begin
                IF lcu_GlobalFunctions.SelectDateByCalendar("Expected Receipt Date Location") THEN
                    VALIDATE("Expected Receipt Date Location");
            end;

            trigger OnValidate()
            begin
                IF TestIfLinesExist() = TRUE THEN
                    // Es sind bereits Zeilen vorhanden!
                    ERROR(AgilesText01Txt);
            end;
        }
        field(83; "Shipping Date"; Date)
        {
            Caption = 'Shipping Date';

            trigger OnLookup()
            var
                lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
            begin
                IF lcu_GlobalFunctions.SelectDateByCalendar("Shipping Date") THEN
                    VALIDATE("Shipping Date");
            end;

            trigger OnValidate()
            begin
                IF TestIfLinesExist() = TRUE THEN
                    // Es sind bereits Zeilen vorhanden!
                    ERROR(AgilesText01Txt);
            end;
        }
        field(90; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(100; Comment; Text[80])
        {
            Caption = 'Comment';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Planing Starting Date")
        {
        }
        key(Key3; "Shipping Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lrc_PurchPlanLines: Record "POI Purch. Plan Lines";
    begin
        lrc_PurchPlanLines.SETRANGE("Planing No.", "No.");
        lrc_PurchPlanLines.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lcu_NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        IF "No." = '' THEN BEGIN
            lrc_FruitVisionSetup.GET();
            lrc_FruitVisionSetup.TESTFIELD("No. Series Planing");
            "No." := lcu_NoSeriesManagement.GetNextNo(lrc_FruitVisionSetup."No. Series Planing", TODAY(), TRUE);
        END;
    end;

    var
        AgilesText01Txt: Label 'Es sind bereits Zeilen vorhanden !';

    procedure TestIfLinesExist(): Boolean
    var
        lrc_PurchPlanLines: Record "POI Purch. Plan Lines";
    begin
        // -----------------------------------------------------------------------------------
        // Funktion zur Kontrolle ob bereits Zeilen vorhanden sind
        // -----------------------------------------------------------------------------------

        lrc_PurchPlanLines.SETRANGE("Planing No.", "No.");
        IF lrc_PurchPlanLines.ISEMPTY() THEN
            EXIT(FALSE)
        ELSE
            EXIT(TRUE);

    end;

    var
        lrc_PurchPlanHeader: Record "POI Purch. Plan";
}

