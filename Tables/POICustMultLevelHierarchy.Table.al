table 5110545 "POI Cust. Mult Level Hierarchy"
{
    Caption = 'Cust. Multiple Level Hierarchy';
    DataCaptionFields = "Code", Description;
    // DrillDownFormID = Form5088035;
    // LookupFormID = Form5088035;

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
            TableRelation = "POI Cust. Mult Level Hierarchy";

            trigger OnLookup()
            var
                CustomerHierarchyCode: Code[13];
            begin
                // Aufruf der Übersichtsform "Customer Hierarchy List Arrow"

                CustomerHierarchyCode := "Reference to";
                IF LookupWithArrows(CustomerHierarchyCode, TRUE) THEN
                    VALIDATE("Reference to", CustomerHierarchyCode);
            end;

            trigger OnValidate()
            var
                CustomerHierarchyParent: Record "POI Cust. Mult Level Hierarchy";
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
                    CustomerHierarchyParent.GET("Reference to");

                    VALIDATE(Level, CustomerHierarchyParent.Level + 1);
                    "Sort Term" := copystr(CustomerHierarchyParent."Sort Term" + STRSUBSTNO('#1###########', Code) + ',', 1, 112);
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
        field(50; "Temp Actual Expansion Status"; Option)
        {
            Caption = 'Temp Actual Expansion Status';
            Description = 'Nur temporär in Form::"Customer Hierarchy List Arrow" benötigt';
            Editable = false;
            OptionCaption = 'Closed,Open,Not to open';
            OptionMembers = Closed,Open,"Not to open";
        }
        field(51; "Temp Record"; Boolean)
        {
            Caption = 'Temp Record';
            Description = 'Nur temporär in Form::"Customer Hierarchy List Arrow" benötigt';
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
        CustomerHierarchyChield.RESET();
        CustomerHierarchyChield.SETRANGE("Reference to", Code);
        IF not CustomerHierarchyChield.IsEmpty() THEN
            ERROR(Text0002Txt, Code);

        DelCustomerHierarchy();
    end;

    trigger OnInsert()
    begin
        IF "Reference to" = '' THEN BEGIN
            VALIDATE(Level, 1);
            "Sort Term" := copystr(STRSUBSTNO('#1###########', Code) + ',', 1, 112);
        END;
    end;

    trigger OnRename()
    begin
        UpdateChieldHierarchyRename();
    end;

    var
        Text0001Txt: Label 'The item group %1 can not be a subgroup of itself.', Comment = '%1';
        Text0002Txt: Label 'It is not possible to delete superior groups.%1', Comment = '%1';
        Text0003Txt: Label 'must not be greater than %1', Comment = '%1';
        //Text0004Txt: Label 'Maximum length of the sorting term becomes overtaken.\''%1''\+ '' %2 '' not possible.';
        Text0007Txt: Label 'Do you want to change %1?', Comment = '%1';
        // Text1000Txt: Label '%1 : %2 %3        State : %4        %5 : %6';
        // Text1001Txt: Label 'There are Blanket Orders.\\Show Blanket Orders ?';
        // Text1002Txt: Label 'Do you want to change %1 anywhere ?';
        // Text1003Txt: Label 'In Blanket Orders will develop a Deployment, that is not valid.';
        // Text2001Txt: Label 'Do you want to set the EDI Sign to all customers of this Hierarchy ?';
        // Text2002Txt: Label 'Do you want to delete the EDI Sign from all customers of this Hierarchy ?';
        // Text3000Txt: Label 'No %1 found.';
        HideValidationDialog: Boolean;

    procedure ReferenceCheck()
    var
        CustomerHierarchyParent: Record "POI Cust. Mult Level Hierarchy";
    begin
        //Prüfen, ob eine der übergeordneten Gruppen, die Gruppe selbst ist
        // Wenn keine übergeordnete Gruppe vorhanden
        IF "Reference to" = '' THEN
            EXIT;
        CustomerHierarchyParent.GET("Reference to");
        WHILE CustomerHierarchyParent."Reference to" <> '' DO BEGIN
            IF (CustomerHierarchyParent.Code = Code) AND (CustomerHierarchyParent."Reference to" <> '') THEN
                ERROR(Text0001Txt, Code);
            IF NOT CustomerHierarchyParent.GET(CustomerHierarchyParent."Reference to") THEN
                CLEAR(CustomerHierarchyParent);
        END;
    end;

    procedure UpdateChieldHierarchy()
    begin
        // HierarchieLevel und Sort in allen untergeordneten Gruppen aktualisieren

        CustomerHierarchyChield.RESET();
        CustomerHierarchyChield.SETRANGE("Reference to", Code);

        IF CustomerHierarchyChield.FIND('-') THEN
            REPEAT
                CustomerHierarchyChield.SetHideValidationDialog(HideValidationDialog);
                CustomerHierarchyChield.VALIDATE("Reference to");
                CustomerHierarchyChield.MODIFY();
            UNTIL CustomerHierarchyChield.NEXT() = 0;
    end;

    procedure UpdateChieldHierarchyRename()
    var
        CustomerHierarchyParent: Record "POI Cust. Mult Level Hierarchy";
    begin
        // Sortbegriff in allen untergeordneten Gruppen aktualisieren bei Rename

        // zunächst den eigenen Sortierbegriff aktualisieren
        IF "Reference to" = '' THEN
            "Sort Term" := STRSUBSTNO('#1###########', Code) + ','
        ELSE BEGIN
            CustomerHierarchyParent.GET("Reference to");
            "Sort Term" := copystr(CustomerHierarchyParent."Sort Term" + STRSUBSTNO('#1###########', Code) + ',', 1, 112);
        END;


        // Da der neue Satz noch nicht weggeschrieben ist und die Kinder nur den alten Elternnamen kennen
        // ist hier die Vorgehensweise etwas anders als beim ändern des 'Reference to' Eintrages

        CustomerHierarchyChield.RESET();
        CustomerHierarchyChield.SETRANGE("Reference to", xRec.Code);

        IF CustomerHierarchyChield.FIND('-') THEN
            REPEAT
                // Elternname in den Kinder ändern
                CustomerHierarchyChield."Reference to" := Code;
                CustomerHierarchyChield."Sort Term" := copystr("Sort Term" + STRSUBSTNO('#1###########', CustomerHierarchyChield.Code) + ',', 1, 112);
                CustomerHierarchyChield.MODIFY();
                //Kinderskinder auf 'normalen Weg' aktualisieren
                CustomerHierarchyChield.UpdateChieldHierarchy();
            UNTIL CustomerHierarchyChield.NEXT() = 0;
    end;

    procedure DelCustomerHierarchy()
    var
        lrc_CustVendHierarchyChronol: Record "POI Cust/Vend Hiera Chronology";
    begin

        //Ändern der Debitoreinträge auf die nächst übergeordnete Gruppe
        lrc_CustVendHierarchyChronol.RESET();
        lrc_CustVendHierarchyChronol.SETCURRENTKEY("Source No.", "Starting Date", Source);
        lrc_CustVendHierarchyChronol.SETRANGE(Source, lrc_CustVendHierarchyChronol.Source::Customer);
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

    local procedure GetCustomerHierarchy(var MyCustVendHierarchyChronology: Record "POI Cust/Vend Hiera Chronology"; var MyHierarchySortTerm: Text[250]): Boolean
    var
        Pos: Integer;
        MyHierarchy: Text[250];
    begin
        // Für einen HierarchyLevel den Customer ermitteln und dann den HierarchyLevel umbauen
        // Return TRUE -> Customer gefunden

        Pos := STRPOS(MyHierarchySortTerm, ',');
        IF Pos = 0 THEN BEGIN
            MyHierarchySortTerm := '';
            EXIT(FALSE)
        END;

        MyHierarchy := copystr(COPYSTR(MyHierarchySortTerm, 1, Pos - 1), 1, 250);
        MyHierarchySortTerm := copystr(COPYSTR(MyHierarchySortTerm, Pos + 1), 1, 250);

        Pos := STRPOS(MyHierarchy, ' ');
        IF Pos <> 0 THEN
            MyHierarchy := copystr(COPYSTR(MyHierarchy, 1, Pos - 1), 1, 250);

        MyCustVendHierarchyChronology.RESET();
        MyCustVendHierarchyChronology.SETCURRENTKEY("Source No.", "Starting Date", Source);
        MyCustVendHierarchyChronology.SETRANGE(Source, MyCustVendHierarchyChronology.Source::Customer);
        MyCustVendHierarchyChronology.SETRANGE("Hierarchy Code", MyHierarchy);
        EXIT(MyCustVendHierarchyChronology.FIND('-'));
    end;

    procedure LookupWithArrows(var CustomerHierarchyCodeRef: Code[13]; SetLookupMode: Boolean) LookupAktionOK: Boolean
    var
        CustomerHierarchy: Record "POI Cust. Mult Level Hierarchy";
    begin
        // Ausprogrammierter Lookup für die Übersichtsform mit Pfeilen zum Auf- und Zuklappen der Hierarchieebenen
        // Die entsprechende Form muß auf einer temporären Tabelle arbeiten

        // Laden der temporären Tabelle
        CustomerHierarchy.RESET();
        IF CustomerHierarchy.FIND('-') THEN
            REPEAT
                CustomerHierarchyTemp.TRANSFERFIELDS(CustomerHierarchy);
                CustomerHierarchyTemp."Temp Record" := TRUE;
                CustomerHierarchyTemp.INSERT(FALSE);
            UNTIL CustomerHierarchy.NEXT() = 0;

        // Statusermittlung.
        CustomerHierarchyTemp.RESET();
        IF CustomerHierarchyTemp.FIND('-') THEN
            REPEAT
                CustomerHierarchy.RESET();
                CustomerHierarchy.SETCURRENTKEY("Reference to");
                CustomerHierarchy.SETRANGE("Reference to", CustomerHierarchyTemp.Code);
                IF not CustomerHierarchy.IsEmpty() THEN
                    CustomerHierarchyTemp."Temp Actual Expansion Status" := CustomerHierarchyTemp."Temp Actual Expansion Status"::Open
                ELSE
                    CustomerHierarchyTemp."Temp Actual Expansion Status" := CustomerHierarchyTemp."Temp Actual Expansion Status"::"Not to open";
                CustomerHierarchyTemp.MODIFY(FALSE);
            UNTIL CustomerHierarchyTemp.NEXT() = 0;

        // IF NOT SetLookupMode THEN BEGIN //TODO: page
        //   FORM.RUNMODAL(FORM::Form5088062,CustomerHierarchyTemp);
        //   EXIT(FALSE);
        // END;

        // Pointer auf der temporären Tabelle einstellen
        IF CustomerHierarchyTemp.GET(CustomerHierarchyCodeRef) THEN;

        // IF FORM.RUNMODAL(FORM::Form5088062,CustomerHierarchyTemp) = ACTION::LookupOK THEN BEGIN //TODO: page
        //   CustomerHierarchyCodeRef := CustomerHierarchyTemp.Code;
        //   EXIT(TRUE);
        // END ELSE
        //   EXIT(FALSE);
    end;

    procedure SetExpansionStatus(var CustomerHierarchyTempRef: Record "POI Cust. Mult Level Hierarchy")
    var
        CustomerHierarchy: Record "POI Cust. Mult Level Hierarchy";
    begin
        // Statusermittlung Open/"Not to open"

        CustomerHierarchy.RESET();
        CustomerHierarchy.SETCURRENTKEY("Reference to");
        CustomerHierarchy.SETRANGE("Reference to", CustomerHierarchyTempRef.Code);
        IF not CustomerHierarchy.IsEmpty() THEN
            CustomerHierarchyTempRef."Temp Actual Expansion Status" := CustomerHierarchyTempRef."Temp Actual Expansion Status"::Open
        ELSE
            CustomerHierarchyTempRef."Temp Actual Expansion Status" := CustomerHierarchyTempRef."Temp Actual Expansion Status"::"Not to open";

    end;

    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    var
        CustomerHierarchyChield: Record "POI Cust. Mult Level Hierarchy";
        CustomerHierarchyTemp: Record "POI Cust. Mult Level Hierarchy" temporary;
}

