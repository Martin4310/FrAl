table 50015 "POI Phys. Inventory NL"
{
    Caption = 'Phys. Inventory NL';
    //DrillDownFormID = Form60030;
    //LookupFormID = Form60030;

    fields
    {
        field(1; "Lfd. Nr."; Integer)
        {
            Caption = 'Lfd. Nr.';
            DataClassification = CustomerContent;
        }
        field(2; "Artikel Nr."; Code[20])
        {
            Caption = 'Artikel Nr.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(3; Beschreibung; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; "Beschreibung erweitert"; Text[100])
        {
            Caption = 'Beschreibung erweitert';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; Einheit; Code[10])
        {
            Caption = 'Einheit';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; Verpackungscode; Code[20])
        {
            Caption = 'Verpackungscode';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; Position; Code[20])
        {
            Caption = 'Position';
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnLookup()
            var
                //     lr_BatchVariant: Record "5110366";
                //     lr_PurchHeader: Record "Purchase Header";
                POIFunction: Codeunit POIFunction;
            begin
                IF NOT POIFunction.CheckUserInRole('QSPHYSBESTAND', 0) THEN
                    ERROR(ERR_NoPermissionTxt);
                //     IF lr_BatchVariant.GET(Position) THEN
                //       IF lr_PurchHeader.GET(lr_PurchHeader."Document Type"::Order,lr_BatchVariant."Master Batch No.") THEN
                //         FORM.RUN(FORM::"ADF Purchase Order Fruit",lr_PurchHeader);

            end;
        }
        field(8; "Erzeugerland Code"; Code[10])
        {
            Caption = 'Erzeugerland Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; "Los. Nr."; Code[20])
        {
            Caption = 'Los. Nr.';
            DataClassification = CustomerContent;
        }
        field(10; "Lieferanten Nr."; Code[20])
        {
            Caption = 'Lieferanten Nr.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Vendor."No." WHERE("No." = FIELD("Lieferanten Nr."));
        }
        field(11; Lieferantenname; Text[50])
        {
            Caption = 'Lieferantenname';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "Erwartetes Wareneingangsdatum"; Date)
        {
            Caption = 'Erwartetes Wareneingangsdatum';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; Status; Code[20])
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(14; "Menge in Bestellung"; Decimal)
        {
            BlankZero = true;
            Caption = 'Menge in Bestellung';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(15; "Menge im Verkauf"; Decimal)
        {
            BlankZero = true;
            Caption = 'Menge im Verkauf';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(16; "Soll Bestand nach Ausgang"; Decimal)
        {
            BlankZero = true;
            Caption = 'Soll Bestand nach Ausgang';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(17; "Ist Bestand"; Decimal)
        {
            BlankZero = true;
            Caption = 'Ist Bestand';
            DataClassification = CustomerContent;
        }
        field(18; Beleg; Code[20])
        {
            Caption = 'Beleg';
            DataClassification = CustomerContent;
        }
        field(19; "Menge im Packauftrag"; Decimal)
        {
            BlankZero = true;
            Caption = 'Menge im Packauftrag';
            DataClassification = CustomerContent;
        }
        field(20; "Erzeugerland Code neu"; Code[10])
        {
            Caption = 'Erzeugerland Code neu';
            DataClassification = CustomerContent;
        }
        field(21; "Status neu"; Option)
        {
            Caption = 'Status neu';
            DataClassification = CustomerContent;
            OptionMembers = " ",erwartet,freigegeben,"eingeschränkt",gesperrt,"ungeprüft",Retoure;
        }
        field(22; "Menge in Umlagerung"; Decimal)
        {
            BlankZero = true;
            Caption = 'Menge in Umlagerung';
            DataClassification = CustomerContent;
        }
        field(23; "Location Code"; Code[10])
        {
            Caption = 'Location';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Location;
        }
        field(30; "Batch Variant No.Input Items"; Code[20])
        {
            Caption = 'Batch Variant No.Input Items';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50; Bemerkungen; Text[250])
        {
            Caption = 'Bemerkungen';
            DataClassification = CustomerContent;
        }
        field(51; "Soll und Ist ungleich"; Boolean)
        {
            Caption = 'Soll und Ist ungleich';
            DataClassification = CustomerContent;
        }
        field(52; "Beschriftung Ordner"; Text[250])
        {
            Caption = 'Beschriftung Ordner';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Lfd. Nr.")
        {
        }
        key(Key2; "Beschreibung erweitert")
        {
        }
        key(Key3; "Beschreibung erweitert", "Artikel Nr.")
        {
        }
        key(Key4; "Beschreibung erweitert", Einheit, "Erwartetes Wareneingangsdatum")
        {
        }
        key(Key5; "Beschreibung erweitert", "Erwartetes Wareneingangsdatum")
        {
        }
        key(Key6; "Beschreibung erweitert", Einheit)
        {
        }
    }

    fieldgroups
    {
    }

    var
        ERR_NoPermissionTxt: Label 'Sie haben keine Berechtigung zum Ausführen der Funktion.';
}

