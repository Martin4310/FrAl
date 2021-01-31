table 5110325 "POI Voyage"
{
    Caption = 'Voyage';
    // DrillDownFormID = Form5110396;
    // LookupFormID = Form5110396;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(11; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
        }
        field(12; "Company Season Code"; Code[10])
        {
            Caption = 'Company Season Code';
            //TableRelation = "Company Season";
        }
        field(19; "Means of Transp. Type Arrival"; Option)
        {
            Caption = 'Means of Transp. Type Arrival';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;
        }
        field(20; "Means of Transp. Code Arrival"; Code[20])
        {
            Caption = 'Means of Transp. Code Arrival';
            TableRelation = IF ("Means of Transp. Type Arrival" = CONST(" ")) "POI Means of Transport".Code
            ELSE
            IF ("Means of Transp. Type Arrival" = FILTER(<> ' ')) "POI Means of Transport".Code WHERE(Type = FIELD("Means of Transp. Type Arrival"));

            trigger OnValidate()
            var

            begin
                IF ("Means of Transp. Code Arrival" <> '') AND
                   ("Means of Transp. Type Arrival" = "Means of Transp. Type Arrival"::" ") THEN BEGIN
                    lrc_MeansOfTransport.SETRANGE(Code, "Means of Transp. Code Arrival");
                    lrc_MeansOfTransport.FINDFIRST();
                    "Means of Transp. Type Arrival" := lrc_MeansOfTransport.Type;
                END;

                CreateSearchDescription();

                IF "Means of Transp. Code Arrival" <> '' THEN
                    IF lrc_MeansOfTransport.GET("Means of Transp. Type Arrival", "Means of Transp. Code Arrival") THEN BEGIN
                        "Means of Transp. Name Arrival" := lrc_MeansOfTransport.Name;
                        "Shipping Agent Code" := lrc_MeansOfTransport."Shipping Agent Code";
                    end;
            end;
        }
        field(21; "Means of Transp. Name Arrival"; Text[50])
        {
            Caption = 'Means of Transp. Name Arrival';
            Editable = false;
        }
        field(22; "Means of Transp. Info Arrival"; Code[30])
        {
            Caption = 'Means of Transp. Info Arrival';
        }
        field(25; "Kind of Loading"; Option)
        {
            Caption = 'Kind of Loading';
            Description = ' ,Container,Reefer Vessel,,,Konventionell';
            OptionCaption = ' ,Container,Reefer Vessel,,,Konventionell';
            OptionMembers = " ",Container,"Reefer Vessel",,,Konventionell;
        }
        field(27; "Means of Transp. Type Depart."; Option)
        {
            Caption = 'Means of Transp. Type Depart.';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;
        }
        field(28; "Means of Transp. Code Depart."; Code[20])
        {
            Caption = 'Means of Transp. Code Depart.';
            TableRelation = IF ("Means of Transp. Type Depart." = CONST(" ")) "POI Means of Transport".Code
            ELSE
            IF ("Means of Transp. Type Depart." = FILTER(<> ' ')) "POI Means of Transport".Code WHERE(Type = FIELD("Means of Transp. Type Depart."));

            trigger OnValidate()
            begin
                lrc_MeansOfTransport.Reset();
                IF ("Means of Transp. Code Depart." <> '') AND
                   ("Means of Transp. Type Depart." = "Means of Transp. Type Depart."::" ") THEN BEGIN
                    lrc_MeansOfTransport.SETRANGE(Code, "Means of Transp. Code Depart.");
                    lrc_MeansOfTransport.FIND('-');
                    "Means of Transp. Type Depart." := lrc_MeansOfTransport.Type;
                END;
            end;
        }
        field(29; "Entry Point Country Code"; Code[10])
        {
            Caption = 'Abgangshafen Ländercode';
            TableRelation = "Country/Region";
        }
        field(30; "Entry Point Code"; Code[10])
        {
            Caption = 'Entry Point Code';
            TableRelation = "Entry/Exit Point".Code;

            // trigger OnValidate()
            // var
            //     lrc_EntryExitPoint: Record "282"; //TODO: exit points
            // begin
            //     IF lrc_EntryExitPoint.GET("Entry Point Code") THEN
            //       "Entry Point Country Code" := lrc_EntryExitPoint."Country Code";
            //     ELSE
            //       "Entry Point Country Code" := '';
            // end;
        }
        field(31; "Port of Discharge Code (UDE)"; Code[10])
        {
            Caption = 'Port of Discharge Code (UDE)';
            TableRelation = "Entry/Exit Point".Code;
        }
        field(32; "Date of Discharge"; Date)
        {
            Caption = 'Date of Discharge';
        }
        field(33; "Time of Discharge"; Time)
        {
            Caption = 'Time of Discharge';
        }
        field(34; ETD; Date)
        {
            Caption = 'ETD';

            trigger OnLookup()
            var
                lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
            begin
                IF lcu_GlobalFunctions.SelectDateByCalendar(ETD) THEN
                    VALIDATE(ETD);
            end;

            trigger OnValidate()
            var

            begin

                // Einkäufe aktualisieren
                PurchaseHeader.SETRANGE("POI Voyage No.", "No.");
                IF PurchaseHeader.FIND('-') THEN BEGIN
                    PurchaseHeader.VALIDATE("POI Departure Date", ETD);
                    PurchaseHeader.MODIFY(TRUE);
                END;
            end;
        }
        field(35; ETA; Date)
        {
            Caption = 'ETA';

            trigger OnLookup()
            var
                lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
            begin
                IF lcu_GlobalFunctions.SelectDateByCalendar(ETA) THEN
                    VALIDATE(ETA);
            end;

            trigger OnValidate()
            begin
                CreateSearchDescription();
            end;
        }
        field(37; "Date of Departure"; Date)
        {
            Caption = 'Date of Departure';

            trigger OnLookup()
            var
                lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
            begin
                IF lcu_GlobalFunctions.SelectDateByCalendar("Date of Departure") THEN
                    VALIDATE("Date of Departure");
            end;
        }
        field(38; "Date of Arrival"; Date)
        {
            Caption = 'Date of Arrival';

            trigger OnLookup()
            var
                lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
            begin
                IF lcu_GlobalFunctions.SelectDateByCalendar("Date of Arrival") THEN
                    VALIDATE("Date of Arrival");
            end;
        }
        field(40; "Voyage State"; Option)
        {
            Caption = 'Voyage State';
            OptionCaption = ' ,Plan,On the Way,Arrived,,,,,Closed';
            OptionMembers = " ",Plan,"On the Way",Arrived,,,,,Closed;
        }
        field(41; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent".Code;
        }
        field(43; "Ship. Comp. Vendor No."; Code[20])
        {
            Caption = 'Ship. Comp. Vendor No.';
            TableRelation = Vendor;
        }
        field(45; "Ship. Comp. Voyage No. Arrival"; Code[20])
        {
            Caption = 'Ship. Comp. Voyage No. Arrival';
        }
        field(46; "Ship. Comp. Voyage No. Depart."; Code[20])
        {
            Caption = 'Ship. Comp. Voyage No. Depart.';
        }
        field(48; "Connection Voyage No."; Code[20])
        {
            Caption = 'Connection Voyage No.';
            TableRelation = "POI Voyage"."No.";
        }
        field(50; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(52; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series".Code;
        }
        field(55; "Quality Report received"; Boolean)
        {
            Caption = 'Discharge Report received';
        }
        field(60; "Safety Days"; DateFormula)
        {
            Caption = 'Safety Days';
        }
        field(70; "Country Group Code"; Code[10])
        {
            Caption = 'Country Group Code';
            TableRelation = "POI Country Group";
        }
        field(80; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            var
                lrc_CurrencyExchangeRate: Record "Currency Exchange Rate";
            begin
                "Currency Factor" := lrc_CurrencyExchangeRate.ExchangeRate(ETD, "Currency Code");
            end;
        }
        field(81; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(82; "Starting Day Planning Week"; Option)
        {
            Caption = 'Starting Day Of The Planningweek';
            InitValue = Monday;
            //MaxValue = 7;
            //MinValue = 1;
            OptionCaption = ',Monday,Thuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = ,Monday,Thuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(83; "Starting Day Planning Activ"; Boolean)
        {
            Caption = 'Starting Day Planning Activ';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Country Group Code", "Date of Arrival")
        {
        }
        key(Key3; "Entry Point Country Code")
        {
        }
        key(Key4; "Voyage State")
        {
        }
    }

    trigger OnDelete()
    var
        lrc_PurchaseHeader: Record "Purchase Header";
        lrc_PurchaseLine: Record "Purchase Line";
        lrc_BatchVariant: Record "POI Batch Variant";
    begin
        lrc_PurchaseHeader.SETRANGE("POI Voyage No.", "No.");
        IF NOT lrc_PurchaseHeader.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT002Txt);

        lrc_PurchaseLine.SETRANGE("POI Voyage No.", "No.");
        IF NOT lrc_PurchaseLine.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT002Txt);

        lrc_BatchVariant.SETRANGE("Voyage No.", "No.");
        IF NOT lrc_BatchVariant.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT001Txt);
    end;

    trigger OnInsert()
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lcu_NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        // Holen der Nummer aus der Nummernserie für Reisen
        IF "No." = '' THEN BEGIN
            lrc_FruitVisionSetup.GET();
            lrc_FruitVisionSetup.TESTFIELD("No. Series Voyage");
            lcu_NoSeriesMgt.InitSeries(lrc_FruitVisionSetup."No. Series Voyage", xRec."No. Series", TODAY(), "No.", "No. Series");
        END;
    end;

    trigger OnModify()
    begin
        CreateSearchDescription();
    end;

    var
        PurchaseHeader: Record "Purchase Header";
        lrc_MeansOfTransport: Record "POI Means of Transport";
        ADF_GT_TEXT001Txt: Label 'Löschung nicht zulässig. Reisenr. in Pos.-Var. vorhanden!';
        ADF_GT_TEXT002Txt: Label 'Löschung nicht zulässig, es sind noch offene Einkäufe vorhanden!';

    procedure AssistEdit(OldVoyage: Record "POI Voyage"): Boolean
    var
        lrc_Voyage: Record "POI Voyage";
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lcu_NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        WITH lrc_Voyage DO BEGIN
            lrc_Voyage := Rec;
            lrc_FruitVisionSetup.GET();
            lrc_FruitVisionSetup.TESTFIELD("No. Series Voyage");
            IF lcu_NoSeriesMgt.SelectSeries(lrc_FruitVisionSetup."No. Series Voyage", OldVoyage."No. Series", "No. Series") THEN BEGIN
                lrc_FruitVisionSetup.GET();
                lrc_FruitVisionSetup.TESTFIELD("No. Series Voyage");
                lcu_NoSeriesMgt.SetSeries("No.");
                Rec := lrc_Voyage;
                EXIT(TRUE);
            END;
        END;
    end;

    procedure CreateSearchDescription()
    begin
        // --------------------------------------------------------------------------------------------------------
        // Funktion zur Erstellung des Suchbegriffes für den Reisecode
        // --------------------------------------------------------------------------------------------------------

        "Search Description" := "Means of Transp. Name Arrival";
        IF ETA <> 0D THEN
            "Search Description" := copystr("Search Description" + ' ' + 'KW' + FORMAT(DATE2DMY(ETA, 2)) + FORMAT(DATE2DMY(ETA, 3)), 1, 100);
        "Search Description" := copystr("Search Description" + ' ' + "Entry Point Code", 1, 100);
        "Search Description" := copystr("Search Description" + ' ' + "Port of Discharge Code (UDE)", 1, 100);
    end;
}

