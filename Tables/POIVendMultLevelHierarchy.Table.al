table 5110546 "POI Vend. Mult Level Hierarchy"
{
    Caption = 'Vend. Multiple Level Hierarchy';
    DataCaptionFields = "Code", Description;
    // DrillDownFormID = Form5088037;
    // LookupFormID = Form5088037;

    fields
    {
        field(1; "Code"; Code[13])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(8; "Sort Term"; Code[112])
        {
            Caption = 'Sort Term';
            Description = 'Für 8 x (13+1) Stellen Hierarchy Code mit Trennzeichen';
            Editable = false;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
                    "Search Description" := Description;
            end;
        }
        field(11; "Search Description"; Code[50])
        {
            Caption = 'Search Description';
        }
        field(15; "Reference to"; Code[13])
        {
            Caption = 'Reference to';
            TableRelation = "POI Vend. Mult Level Hierarchy";

            trigger OnLookup()
            var
                VendorHierarchyCode: Code[13];
            begin
                // Aufruf der Übersichtsform "Vendor Hierarchy List Arrow"
                VendorHierarchyCode := "Reference to";
                IF LookupWithArrows(VendorHierarchyCode, TRUE) THEN
                    VALIDATE("Reference to", VendorHierarchyCode);
            end;

            trigger OnValidate()
            var
                VendorHierarchyParent: Record "POI Vend. Mult Level Hierarchy";
            begin

                //Möchten Sie %1 ändern?
                IF ((CurrFieldNo = FIELDNO("Reference to")) AND
                  (xRec."Reference to" <> "Reference to") AND
                  (xRec."Reference to" <> ''))
                THEN
                    IF (NOT CONFIRM(Text0007Txt, FALSE, FIELDCAPTION("Reference to"))) THEN BEGIN
                        "Reference to" := xRec."Reference to";
                        EXIT;
                    END;

                //Prüfen, ob eine der übergeordneten Gruppen, die Gruppe selbst ist
                ReferenceCheck();


                IF "Reference to" = '' THEN BEGIN
                    VALIDATE(Level, 1);
                    "Sort Term" := STRSUBSTNO('#1###########', Code) + ',';
                END ELSE BEGIN
                    VendorHierarchyParent.GET("Reference to");
                    VALIDATE(Level, VendorHierarchyParent.Level + 1);
                    "Sort Term" := copystr(VendorHierarchyParent."Sort Term" + STRSUBSTNO('#1###########', Code) + ',', 1, 112);
                END;

                MODIFY();
                UpdateChieldHierarchy();
            end;
        }
        field(16; "Reference to Since"; Date)
        {
            Caption = 'Reference to Since';
        }
        field(20; Level; Integer)
        {
            Caption = 'Level';
            Editable = false;

            trigger OnValidate()
            begin
                CheckMaxLevel();
            end;
        }
        field(40; "Temp Actual Expansion Status"; Option)
        {
            Caption = 'Temp Actual Expansion Status';
            Description = 'Nur temporär in Form::"Vendor Hierarchy List Arrow" benötigt';
            Editable = false;
            OptionCaption = 'Closed,Open,Not to open';
            OptionMembers = Closed,Open,"Not to open";
        }
        field(41; "Temp Record"; Boolean)
        {
            Caption = 'Temp Record';
            Description = 'Nur temporär in Form::"Vendor Hierarchy List Arrow" benötigt';
            Editable = false;
        }
        field(100; "Starting Date Filter"; Date)
        {
            Caption = 'Starting Date Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; "Sort Term")
        {
        }
        key(Key3; "Reference to")
        {
        }
        key(Key4; Level)
        {
        }
    }

    trigger OnDelete()
    begin
        //Löschen von übergeordneten Gruppen ist nicht möglich!
        VendorHierarchyChield.RESET();
        VendorHierarchyChield.SETRANGE("Reference to", Code);
        IF not VendorHierarchyChield.IsEmpty() THEN
            ERROR(Text0002Txt, Code);

        DelVendorHierarchy();
    end;

    trigger OnInsert()
    begin
        IF "Reference to" = '' THEN BEGIN
            VALIDATE(Level, 1);
            "Sort Term" := STRSUBSTNO('#1###########', Code) + ',';
        END;
    end;

    trigger OnRename()
    begin
        UpdateChieldHierarchyRename();
    end;

    var
        Text0001Txt: Label 'The item group %1 can not be a subgroup of itself.', Comment = '%1';
        Text0002Txt: Label 'It is not possible to delete superior groups %1.', Comment = '%1';
        Text0003Txt: Label 'must not be greater than %1', Comment = '%1';
        Text0007Txt: Label 'Do you want to change %1?', Comment = '%1';

    procedure ReferenceCheck()
    var
        VendorHierarchyParent: Record "POI Vend. Mult Level Hierarchy";
    begin
        //Prüfen, ob eine der übergeordneten Gruppen, die Gruppe selbst ist
        // Wenn keine übergeordnete Gruppe vorhanden
        IF "Reference to" = '' THEN
            EXIT;
        VendorHierarchyParent.GET("Reference to");
        WHILE VendorHierarchyParent."Reference to" <> '' DO BEGIN
            IF (VendorHierarchyParent.Code = Code) AND (VendorHierarchyParent."Reference to" <> '') THEN
                ERROR(Text0001Txt, Code);
            IF NOT VendorHierarchyParent.GET(VendorHierarchyParent."Reference to") THEN
                CLEAR(VendorHierarchyParent);
        END;
    end;

    procedure UpdateChieldHierarchy()
    begin
        // HierarchieLevel und Sort in allen untergeordneten Gruppen aktualisieren
        VendorHierarchyChield.RESET();
        VendorHierarchyChield.SETRANGE("Reference to", Code);
        IF VendorHierarchyChield.FIND('-') THEN
            REPEAT
                VendorHierarchyChield.VALIDATE("Reference to");
                VendorHierarchyChield.MODIFY();
            UNTIL VendorHierarchyChield.NEXT() = 0;
    end;

    procedure UpdateChieldHierarchyRename()
    var
        VendorHierarchyParent: Record "POI Vend. Mult Level Hierarchy";
    begin
        // Sortbegriff in allen untergeordneten Gruppen aktualisieren bei Rename

        // zunächst den eigenen Sortierbegriff aktualisieren
        IF "Reference to" = '' THEN
            "Sort Term" := STRSUBSTNO('#1###########', Code) + ','
        ELSE BEGIN
            VendorHierarchyParent.GET("Reference to");
            "Sort Term" := copystr(VendorHierarchyParent."Sort Term" + STRSUBSTNO('#1###########', Code) + ',', 1, 112);
        END;


        // Da der neue Satz noch nicht weggeschrieben ist und die Kinder nur den alten Elternnamen kennen
        // ist hier die Vorgehensweise etwas anders als beim ändern des 'Reference to' Eintrages

        VendorHierarchyChield.RESET();
        VendorHierarchyChield.SETRANGE("Reference to", xRec.Code);

        IF VendorHierarchyChield.FIND('-') THEN
            REPEAT
                // Elternname in den Kinder ändern
                VendorHierarchyChield."Reference to" := Code;
                VendorHierarchyChield."Sort Term" := copystr("Sort Term" + STRSUBSTNO('#1###########', VendorHierarchyChield.Code) + ',', 1, 112);
                VendorHierarchyChield.MODIFY();
                //Kinderskinder auf 'normalen Weg' aktualisieren
                VendorHierarchyChield.UpdateChieldHierarchy();
            UNTIL VendorHierarchyChield.NEXT() = 0;
    end;

    procedure DelVendorHierarchy()
    var
        lrc_CustVendHierarchyChronol: Record "POI Cust/Vend Hiera Chronology";
    begin

        //Ändern der Artikeleinträge auf die nächst übergeordnete Gruppe
        lrc_CustVendHierarchyChronol.RESET();
        lrc_CustVendHierarchyChronol.SETCURRENTKEY("Source No.", "Starting Date", Source);
        lrc_CustVendHierarchyChronol.SETRANGE(Source, lrc_CustVendHierarchyChronol.Source::Vendor);
        lrc_CustVendHierarchyChronol.SETRANGE("Hierarchy Code", Code);
        lrc_CustVendHierarchyChronol.MODIFYALL("Hierarchy Code", "Reference to", TRUE);
    end;

    procedure CheckMaxLevel()
    var
        MaxLevel: Integer;
    begin
        // 8 ist auf Grund der Größe des HierarchySort Feldes (8x(13+1) das Maximale
        // Damit die Sortierung bei verschieden langen Codes verschiebt, muss mit fester Länge
        // von 13 plus Komma geschrieben werden.
        // kleiner ist natürlich jederzeit möglich
        MaxLevel := 8;

        IF (Level > MaxLevel) THEN
            FIELDERROR(Level, STRSUBSTNO(Text0003Txt, MaxLevel));
    end;

    procedure LookupWithArrows(var VendorHierarchyCodeRef: Code[13]; SetLookupMode: Boolean) LookupAktionOK: Boolean
    var
        VendorHierarchy: Record "POI Vend. Mult Level Hierarchy";
    begin
        // Ausprogrammierter Lookup für die Übersichtsform mit Pfeilen zum Auf- und Zuklappen der Hierarchieebenen
        // Die entsprechende Form muß auf einer temporären Tabelle arbeiten
        // Laden der temporären Tabelle
        VendorHierarchy.RESET();
        IF VendorHierarchy.FIND('-') THEN
            REPEAT
                VendorHierarchyTemp.TRANSFERFIELDS(VendorHierarchy);
                VendorHierarchyTemp."Temp Record" := TRUE;
                VendorHierarchyTemp.INSERT(FALSE);
            UNTIL VendorHierarchy.NEXT() = 0;

        // Statusermittlung.
        VendorHierarchyTemp.RESET();
        IF VendorHierarchyTemp.FIND('-') THEN
            REPEAT
                VendorHierarchy.RESET();
                VendorHierarchy.SETCURRENTKEY("Reference to");
                VendorHierarchy.SETRANGE("Reference to", VendorHierarchyTemp.Code);
                IF not VendorHierarchy.IsEmpty() THEN
                    VendorHierarchyTemp."Temp Actual Expansion Status" := VendorHierarchyTemp."Temp Actual Expansion Status"::Open
                ELSE
                    VendorHierarchyTemp."Temp Actual Expansion Status" := VendorHierarchyTemp."Temp Actual Expansion Status"::"Not to open";
                VendorHierarchyTemp.MODIFY(FALSE);
            UNTIL VendorHierarchyTemp.NEXT() = 0;

        // IF NOT SetLookupMode THEN BEGIN//TODO: page
        //   Page.RUNMODAL(Page::"QlikView Setup",VendorHierarchyTemp);
        //   EXIT(FALSE);
        // END;

        // Pointer auf der temporären Tabelle einstellen
        IF VendorHierarchyTemp.GET(VendorHierarchyCodeRef) THEN;

        // IF Page.RUNMODAL(Page::"QlikView Setup",VendorHierarchyTemp) = ACTION::LookupOK THEN BEGIN //TODO: page
        //   VendorHierarchyCodeRef := VendorHierarchyTemp.Code;
        //   EXIT(TRUE);
        // END ELSE
        //   EXIT(FALSE);
    end;

    procedure SetExpansionStatus(var VendorHierarchyTempRef: Record "POI Vend. Mult Level Hierarchy")
    var
        VendorHierarchy: Record "POI Vend. Mult Level Hierarchy";
    begin
        // Statusermittlung Open/"Not to open"

        VendorHierarchy.RESET();
        VendorHierarchy.SETCURRENTKEY("Reference to");
        VendorHierarchy.SETRANGE("Reference to", VendorHierarchyTempRef.Code);
        IF not VendorHierarchy.IsEmpty() THEN
            VendorHierarchyTempRef."Temp Actual Expansion Status" := VendorHierarchyTempRef."Temp Actual Expansion Status"::Open
        ELSE
            VendorHierarchyTempRef."Temp Actual Expansion Status" := VendorHierarchyTempRef."Temp Actual Expansion Status"::"Not to open";
    end;

    var
        VendorHierarchyChield: Record "POI Vend. Mult Level Hierarchy";
        VendorHierarchyTemp: Record "POI Vend. Mult Level Hierarchy" temporary;
}

