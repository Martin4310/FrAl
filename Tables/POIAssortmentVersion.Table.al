table 5110339 "POI Assortment Version"
{
    Caption = 'Assortment Version';
    // DrillDownFormID = Form5088161;
    // LookupFormID = Form5088161;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(12; "Assortment Code"; Code[10])
        {
            Caption = 'Assortment Code';
            TableRelation = "POI Assortment";

            trigger OnValidate()
            var
                lrc_Assortment: Record "POI Assortment";
                Text001Txt: Label 'Es sind bereits Zeilen vorhanden!';
            begin
                IF TestLines() = TRUE THEN
                    // Es sind bereits Zeilen vorhanden!
                    ERROR(Text001Txt);

                IF "Assortment Code" = '' THEN BEGIN
                    "Currency Code" := '';
                    "Starting Date Assortment" := 0D;
                    "Ending Date Assortment" := 0D;
                    "Assortment Type" := 0;
                    "Ref. Date Validation" := "Ref. Date Validation"::"Shipment Date";
                END ELSE BEGIN
                    lrc_Assortment.GET("Assortment Code");
                    Description := lrc_Assortment.Description;
                    "Currency Code" := lrc_Assortment."Currency Code";
                    "Assortment Type" := lrc_Assortment."Assortment Source";
                    "Ref. Date Validation" := lrc_Assortment."Ref. Date Validation";
                END;
            end;
        }
        field(15; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(20; "Starting Date Assortment"; Date)
        {
            Caption = 'Starting Date Assortment';

            trigger OnValidate()
            var
                Text001Txt: Label 'Es sind bereits Zeilen vorhanden!';
            begin
                TESTFIELD("Assortment Code");

                IF ("Ending Date Assortment" <> 0D) AND
                   ("Starting Date Assortment" > "Ending Date Assortment") THEN
                    ERROR('Startdatum kann nicht nach dem Enddatum liegen!');

                IF TestLines() = TRUE THEN
                    // Es sind bereits Zeilen vorhanden!
                    ERROR(Text001Txt);

                // Kontrolle ob es eine Sortimentsversion mit Enddatum größer dem Startdatum gibt
                lrc_AssortVersion.SETFILTER("No.", '<>%1', "No.");
                lrc_AssortVersion.SETRANGE("Assortment Code", "Assortment Code");
                lrc_AssortVersion.SETFILTER("Ending Date Assortment", '>=%1', "Starting Date Assortment");
                IF lrc_AssortVersion.FIND('-') THEN begin
                    ErrorLabel := 'Startdatum nicht zulässig, da es eine Sortimentsversion mit Enddatum bis zum ' +
                           FORMAT(lrc_AssortVersion."Ending Date Assortment") + ' gibt!';
                    ERROR(ErrorLabel);
                end;

                IF "Starting Date Assortment" >= TODAY() THEN
                    "Starting Date Price" := "Starting Date Assortment";

                IF "Starting Date Assortment" < TODAY() THEN
                    "Starting Date Price" := TODAY();
            end;
        }
        field(21; "Ending Date Assortment"; Date)
        {
            Caption = 'Ending Date Assortment';

            trigger OnValidate()
            var
                TEXT001Txt: Label 'Es sind bereits Zeilen vorhanden! Möchten Sie das Datum ändern?';
            begin
                TESTFIELD("Assortment Code");

                IF "Ending Date Assortment" < "Starting Date Assortment" THEN
                    ERROR('Enddatum kann nicht vor dem Startdatum liegen!');

                IF TestLines() = TRUE THEN
                    // Es sind bereits Zeilen vorhanden!
                    //ERROR(TEXT002);
                    // Es sind bereits Zeilen vorhanden! Möchten Sie das Datum ändern?
                    IF NOT CONFIRM(TEXT001Txt) THEN
                        ERROR('');

                // Kontrolle ob das Enddatum nach dem nächsten Startdatum liegt
                lrc_AssortVersion.SETFILTER("No.", '<>%1', "No.");
                lrc_AssortVersion.SETRANGE("Assortment Code", "Assortment Code");
                lrc_AssortVersion.SETFILTER("Starting Date Assortment", '>=%1', "Ending Date Assortment");
                IF lrc_AssortVersion.FIND('-') THEN begin
                    ErrorLabel := 'Enddatum nicht zulässig, da es eine Sortimentsversion mit Startdatum ab dem ' +
                           FORMAT(lrc_AssortVersion."Starting Date Assortment") + ' gibt!';
                    ERROR(ErrorLabel);
                end;
                "Ending Date Price" := "Ending Date Assortment";

                // Sortimentszeilen aktualisieren
                lrc_AssortmentVersionLine.RESET();
                lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.", "No.");
                IF lrc_AssortmentVersionLine.FIND('-') THEN
                    REPEAT
                        lrc_AssortmentVersionLine."Ending Date Assortment" := "Ending Date Assortment";
                        lrc_AssortmentVersionLine.MODIFY();
                    UNTIL lrc_AssortmentVersionLine.NEXT() = 0;
            end;
        }
        field(22; Inactive; Boolean)
        {
            Caption = 'Inactive';

            trigger OnValidate()
            var
                lrc_AssortmentVersionLine: Record "POI Assortment Version Line";
            begin
                // Kennzeichen in Zeilen übertragen
                lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.", "No.");
                lrc_AssortmentVersionLine.MODIFYALL(Inactive, Inactive);
            end;
        }
        field(23; "Ref. Date Validation"; Option)
        {
            Caption = 'Ref. Date Validation';
            OptionCaption = 'Order Date,Shipment Date,Requested Delivery Date,Promised Delivery Date';
            OptionMembers = "Order Date","Shipment Date","Requested Delivery Date","Promised Delivery Date";
        }
        field(25; "Starting Date Price"; Date)
        {
            Caption = 'Starting Date Price';

            trigger OnValidate()
            var
                TEXT001Txt: Label 'Startdatum darf nicht kleiner als aktuelles Datum sein!';
            begin

                IF "Starting Date Assortment" = 0D THEN
                    ERROR('Bitte geben Sie zuerst das Startdatum Sortiment ein!');
                IF "Ending Date Assortment" = 0D THEN
                    ERROR('Bitte geben Sie zuerst das Enddatum Sortiment ein!');

                IF "Starting Date Price" < TODAY() THEN
                    // Startdatum darf nicht kleiner als aktuelles Datum sein!
                    ERROR(TEXT001Txt);
                IF "Starting Date Price" < "Starting Date Assortment" THEN
                    ERROR('Startdatum Preis darf nicht vor dem Startdatum Sortiment liegen!');
                IF "Starting Date Price" > "Ending Date Assortment" THEN
                    ERROR('Startdatum Preis darf nicht hinter dem Enddatum Sortiment liegen!');
            end;
        }
        field(26; "Ending Date Price"; Date)
        {
            Caption = 'Ending Date Price';

            trigger OnValidate()
            begin

                IF "Ending Date Price" < "Starting Date Price" THEN
                    ERROR('Enddatum kann nicht vor dem Startdatum liegen!');

                IF ("Ending Date Assortment" <> 0D) AND
                   ("Ending Date Price" > "Ending Date Assortment") THEN
                    ERROR('Enddatum Preis kann nicht hinter dem enddatum Sortiment liegen!');
            end;
        }
        field(30; "Assortment Type"; Option)
        {
            Caption = 'Assortment Type';
            OptionCaption = 'Company Assortment,Customer Assortment,,,,,Base Assortment,,,,,,,,,,Planing Assortment';
            OptionMembers = "Company Assortment","Customer Assortment",,,,,"Base Assortment",,,,,,,,,,"Planing Assortment";
        }
        field(35; "Assortment Export per EDI"; Option)
        {
            Caption = 'Assortment Export per EDI';
            OptionCaption = ' ,Export';
            OptionMembers = " ",Export;
        }
        field(36; "Assortment Released for EDI"; Option)
        {
            Caption = 'Assortment Released for EDI';
            OptionCaption = ' ,Freigegeben';
            OptionMembers = " ",Released;
        }
        field(40; "Planing Date"; Date)
        {
            Caption = 'Planing Date';
        }
        field(41; "Planing Date Purchase"; Date)
        {
            Caption = 'Planing Date Purchase';
        }
        field(42; "Planing Date Sales"; Date)
        {
            Caption = 'Planing Date Sales';
        }
        field(45; "Update Date Item"; Date)
        {
            Caption = 'Aktualisierungsdatum Artikel';
        }
        field(48; "Header Standard Text Code"; Code[10])
        {
            Caption = 'Header Standard Text Code';
            TableRelation = "Standard Text";
        }
        field(49; "Footer Standard Text Code"; Code[10])
        {
            Caption = 'Footer Standard Text Code';
            TableRelation = "Standard Text";
        }
        field(50; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(100; "Created User ID"; Code[20])
        {
            Caption = 'Created User ID';
        }
        field(101; "Created Date"; Date)
        {
            Caption = 'Created Date';
        }
        field(102; "Created Time"; Time)
        {
            Caption = 'Created Time';
        }
        field(105; "Last Modified User ID"; Code[20])
        {
            Caption = 'Last Modified User ID';
        }
        field(106; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
        }
        field(107; "Last Modified Time"; Time)
        {
            Caption = 'Last Modified Time';
        }
        field(200; "Assort. for Sales Doc. Subtype"; Code[10])
        {
            CalcFormula = Lookup ("POI Assortment"."Assort. for Sales Doc. Subtype" WHERE(Code = FIELD("Assortment Code")));
            Caption = 'Assort. for Sales Doc. Subtype';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "POI Sales Doc. Subtype".Code;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Assortment Code", "Starting Date Assortment", "Ending Date Assortment")
        {
        }
    }

    trigger OnDelete()
    begin
        lrc_AssortmentVersionLine.Reset();
        lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.", "No.");
        lrc_AssortmentVersionLine.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_Assortment: Record "POI Assortment";
        lcu_NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        IF "No." = '' THEN
            IF "Assortment Code" <> '' THEN BEGIN
                lrc_Assortment.GET("Assortment Code");
                lrc_Assortment.TESTFIELD("No. Series Assortment Version");
                lcu_NoSeriesMgt.InitSeries(lrc_Assortment."No. Series Assortment Version", xRec."No. Series", TODAY(), "No.", "No. Series");
            END ELSE BEGIN
                lrc_FruitVisionSetup.GET();
                lrc_FruitVisionSetup.TESTFIELD("No. Series Assortment Version");
                lcu_NoSeriesMgt.InitSeries(lrc_FruitVisionSetup."No. Series Assortment Version", xRec."No. Series", TODAY(), "No.", "No. Series");
            END;


        "Created User ID" := copystr(UserID(), 1, 20);
        "Created Date" := TODAY();
        "Created Time" := TIME();
    end;

    trigger OnModify()
    begin

        "Last Modified User ID" := copystr(UserID(), 1, 20);
        "Last Modified Date" := TODAY();
        "Last Modified Time" := TIME();
    end;

    procedure TestMultipleEntry()
    var
        lrc_AssortmentVersion: Record "POI Assortment Version";
    begin
        // Kontrolle ob es bereits eine Version mit gleichen Gültig ab Datum gibt
        lrc_AssortmentVersion.SETRANGE("Assortment Code", "Assortment Code");
        lrc_AssortmentVersion.SETRANGE("Currency Code", "Currency Code");
        lrc_AssortmentVersion.SETRANGE("Starting Date Assortment", "Starting Date Assortment");
        lrc_AssortmentVersion.SETFILTER("No.", '<>%1', "No.");
        IF not lrc_AssortmentVersion.IsEmpty() THEN
            ERROR('Es ist bereits eine Version mit dem Startdatum vorhanden!');
    end;

    procedure TestLines(): Boolean
    var
        lrc_AssortVersionLine: Record "POI Assortment Version Line";
    begin
        // -----------------------------------------------------------------------------------
        // Funktion zur Kontrolle ob bereits Zeilen vorhanden sind
        // -----------------------------------------------------------------------------------

        lrc_AssortVersionLine.SETRANGE("Assortment Version No.", "No.");
        IF not lrc_AssortVersionLine.IsEmpty() THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    procedure ChangeEndingDate()
    var
        lrc_SalesPrice: Record "Sales Price";
    begin
        // -----------------------------------------------------------------------------------
        // Funktion zum Ändern Enddatum bei vorhandenen Zeilen
        // -----------------------------------------------------------------------------------

        lrc_SalesPrice.SETRANGE("POI Assort. Version No.", "No.");
        lrc_SalesPrice.MODIFYALL("Ending Date", "Ending Date Assortment");
    end;

    var
        lrc_AssortVersion: Record "POI Assortment Version";
        lrc_AssortmentVersionLine: Record "POI Assortment Version Line";
        ErrorLabel: Text;
}

