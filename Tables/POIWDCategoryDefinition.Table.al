table 50922 "POI W.D. Category Definition"
{
    Caption = 'W.D. Category Definition';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            ValidateTableRelation = false;
        }
        field(2; "Category Code"; Code[10])
        {
            Caption = 'Category Code';
            TableRelation = "POI W.D. Category";

            trigger OnValidate()
            begin
                DSDLizenzentgeltliste.SETRANGE(DSDLizenzentgeltliste."Category Code", "Category Code");
                IF DSDLizenzentgeltliste.FIND('-') THEN;
                IF DSDLizenzentgeltliste."Charge Type" = DSDLizenzentgeltliste."Charge Type"::"Gewichtsentgelt (Kg)" THEN
                    "Category Type" := "Category Type"::Gewicht;
                IF DSDLizenzentgeltliste."Charge Type" = DSDLizenzentgeltliste."Charge Type"::"Stückentgelt Volumen (Stk.)" THEN
                    "Category Type" := "Category Type"::Volumen;
                IF DSDLizenzentgeltliste."Charge Type" = DSDLizenzentgeltliste."Charge Type"::"Stückentgelt Fläche (Stk.)" THEN
                    "Category Type" := "Category Type"::Fläche;
            end;
        }
        field(3; "Weight in Kg"; Decimal)
        {
            Caption = 'Weight in Kg';
        }
        field(4; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure" WHERE("POI Pack Unit of Measure (PU)" = FILTER(<> ''));

            trigger OnValidate()
            var
                UnitofMeasure: Record "Unit of Measure";
            begin
                IF UnitofMeasure.GET("Unit of Measure Code") THEN BEGIN
                    "Packing Unit of Measure (PU)" := UnitofMeasure."POI Pack Unit of Measure (PU)";
                    IF "Packing Unit of Measure (PU)" = '' THEN
                        "Quantity Refers To Pack. Unit" := FALSE
                    ELSE
                        "Quantity Refers To Pack. Unit" := TRUE;
                END ELSE BEGIN
                    "Packing Unit of Measure (PU)" := '';
                    "Quantity Refers To Pack. Unit" := FALSE;
                END;
            end;
        }
        field(5; "Category Type"; Option)
        {
            BlankNumbers = BlankZero;
            Caption = 'Category Type';
            Description = ',Gewicht,Volumen,Fläche';
            Editable = false;
            OptionCaption = ',Gewicht,Volumen,Fläche';
            OptionMembers = ,Gewicht,Volumen,"Fläche";
        }
        field(6; "Big Packing"; Boolean)
        {
            Caption = 'Big Packing';

            trigger OnValidate()
            begin
                DSDKategorienzuordnung.Reset();
                DSDKategorienzuordnung.SETRANGE(DSDKategorienzuordnung."Item No.", "Item No.");
                DSDKategorienzuordnung.SETRANGE(DSDKategorienzuordnung."Unit of Measure Code", "Unit of Measure Code");
                DSDKategorienzuordnung.SETFILTER(DSDKategorienzuordnung."Category Code", '<>%1', "Category Code");
                IF DSDKategorienzuordnung.FIND('-') THEN
                    REPEAT
                        DSDKategorienzuordnung."Big Packing" := "Big Packing";
                        DSDKategorienzuordnung.MODIFY();
                    UNTIL DSDKategorienzuordnung.NEXT() = 0;
            end;
        }
        field(7; "Reduction 1 Is Place-Related"; Code[5])
        {
            Caption = 'Reduction 1 Is Place-Related';
            //TableRelation = "POI W.D. Condition" WHERE(Code = FILTER('= AF*'));

            trigger OnValidate()
            begin
                DSDKategorienzuordnung.Reset();
                DSDKategorienzuordnung.SETRANGE(DSDKategorienzuordnung."Item No.", "Item No.");
                DSDKategorienzuordnung.SETRANGE(DSDKategorienzuordnung."Unit of Measure Code", "Unit of Measure Code");
                DSDKategorienzuordnung.SETFILTER(DSDKategorienzuordnung."Category Code", '<>%1', "Category Code");
                IF DSDKategorienzuordnung.FIND('-') THEN
                    REPEAT
                        DSDKategorienzuordnung."Reduction 1 Is Place-Related" := "Reduction 1 Is Place-Related";
                        DSDKategorienzuordnung.MODIFY();
                    UNTIL DSDKategorienzuordnung.NEXT() = 0;
            end;
        }
        field(8; "Reduction 1 Refers To Quantity"; Code[5])
        {
            Caption = 'Reduction 1 Refers To Quantity';
            //TableRelation = "POI W.D. Condition".Code;

            trigger OnValidate()
            begin
                DSDKategorienzuordnung.Reset();
                DSDKategorienzuordnung.SETRANGE(DSDKategorienzuordnung."Item No.", "Item No.");
                DSDKategorienzuordnung.SETRANGE(DSDKategorienzuordnung."Unit of Measure Code", "Unit of Measure Code");
                DSDKategorienzuordnung.SETFILTER(DSDKategorienzuordnung."Category Code", '<>%1', "Category Code");
                IF DSDKategorienzuordnung.FIND('-') THEN
                    REPEAT
                        DSDKategorienzuordnung."Reduction 1 Refers To Quantity" := "Reduction 1 Refers To Quantity";
                        DSDKategorienzuordnung.MODIFY();
                    UNTIL DSDKategorienzuordnung.NEXT() = 0;
            end;
        }
        field(9; "Reduction 2 Is Place-Related"; Code[5])
        {
            Caption = 'Reduction 2 Is Place-Related';

            trigger OnValidate()
            begin
                DSDKategorienzuordnung.Reset();
                DSDKategorienzuordnung.SETRANGE(DSDKategorienzuordnung."Item No.", "Item No.");
                DSDKategorienzuordnung.SETRANGE(DSDKategorienzuordnung."Unit of Measure Code", "Unit of Measure Code");
                DSDKategorienzuordnung.SETFILTER(DSDKategorienzuordnung."Category Code", '<>%1', "Category Code");
                IF DSDKategorienzuordnung.FIND('-') THEN
                    REPEAT
                        DSDKategorienzuordnung."Reduction 2 Is Place-Related" := "Reduction 2 Is Place-Related";
                        DSDKategorienzuordnung.MODIFY();
                    UNTIL DSDKategorienzuordnung.NEXT() = 0;
            end;
        }
        field(10; "Reduction 2 Refers To Quantity"; Code[5])
        {
            Caption = 'Reduction 2 Refers To Quantity';

            trigger OnValidate()

            begin
                DSDKategorienzuordnung.Reset();
                DSDKategorienzuordnung.SETRANGE(DSDKategorienzuordnung."Item No.", "Item No.");
                DSDKategorienzuordnung.SETRANGE(DSDKategorienzuordnung."Unit of Measure Code", "Unit of Measure Code");
                DSDKategorienzuordnung.SETFILTER(DSDKategorienzuordnung."Category Code", '<>%1', "Category Code");
                IF DSDKategorienzuordnung.FIND('-') THEN
                    REPEAT
                        DSDKategorienzuordnung."Reduction 2 Refers To Quantity" := "Reduction 2 Refers To Quantity";
                        DSDKategorienzuordnung.MODIFY();
                    UNTIL DSDKategorienzuordnung.NEXT() = 0;
            end;
        }
        field(11; PET; Boolean)
        {
            Caption = 'PET';

            trigger OnValidate()
            begin
                DSDKategorienzuordnung.Reset();
                DSDKategorienzuordnung.SETRANGE(DSDKategorienzuordnung."Item No.", "Item No.");
                DSDKategorienzuordnung.SETRANGE(DSDKategorienzuordnung."Unit of Measure Code", "Unit of Measure Code");
                DSDKategorienzuordnung.SETFILTER(DSDKategorienzuordnung."Category Code", '<>%1', "Category Code");
                IF DSDKategorienzuordnung.FIND('-') THEN
                    REPEAT
                        DSDKategorienzuordnung.PET := PET;
                        DSDKategorienzuordnung.MODIFY();
                    UNTIL DSDKategorienzuordnung.NEXT() = 0;
            end;
        }
        field(15; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;
        }
        field(20; "Packing Unit of Measure (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            Editable = false;
            TableRelation = "Unit of Measure".Code WHERE("POI Is Packing Unit of Measure" = CONST(true));
        }
        field(21; "Quantity Refers To Pack. Unit"; Boolean)
        {
            Caption = 'Quantity Refers To Packing Unit Of Measure';
        }
    }

    keys
    {
        key(Key1; "Product Group Code", "Item No.", "Unit of Measure Code", "Category Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        grc_DSDCategory.SETRANGE(grc_DSDCategory.Code, "Category Code");
        IF grc_DSDCategory.FIND('-') THEN
            IF NOT grc_DSDCategory."Weight Charge" THEN
                "Weight in Kg" := 0;

        // Prüfung ob Konditionen gefüllt werden müssen
        DSDKategorienzuordnung.Reset();
        DSDKategorienzuordnung.SETRANGE(DSDKategorienzuordnung."Item No.", "Item No.");
        DSDKategorienzuordnung.SETRANGE(DSDKategorienzuordnung."Unit of Measure Code", "Unit of Measure Code");
        DSDKategorienzuordnung.SETFILTER(DSDKategorienzuordnung."Category Code", '<>%1', "Category Code");
        IF DSDKategorienzuordnung.FIND('-') THEN BEGIN
            "Reduction 1 Refers To Quantity" := DSDKategorienzuordnung."Reduction 1 Refers To Quantity";
            "Reduction 2 Refers To Quantity" := DSDKategorienzuordnung."Reduction 2 Refers To Quantity";
            "Big Packing" := DSDKategorienzuordnung."Big Packing";
            "Reduction 1 Is Place-Related" := DSDKategorienzuordnung."Reduction 1 Is Place-Related";
            "Reduction 2 Is Place-Related" := DSDKategorienzuordnung."Reduction 2 Is Place-Related";
            PET := DSDKategorienzuordnung.PET;
        END;
    end;

    trigger OnModify()
    begin
        grc_DSDCategory.SETRANGE(grc_DSDCategory.Code, "Category Code");
        IF grc_DSDCategory.FIND('-') THEN
            IF NOT grc_DSDCategory."Weight Charge" THEN BEGIN
                "Weight in Kg" := 0;
                MODIFY();
            END;
    end;

    var
        grc_DSDCategory: Record "POI W.D. Category";
        DSDLizenzentgeltliste: Record "POI W.D. Licence Charge List";
        DSDKategorienzuordnung: Record "POI W.D. Category Definition";
}

