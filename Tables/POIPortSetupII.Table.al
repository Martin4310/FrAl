table 50020 "POI Port Setup II"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Purchase PostChoice"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; "GGN Import Folder"; Text[250])
        {
            Caption = 'GGN Import Pfad';
            DataClassification = CustomerContent;
        }

        field(501; "Freight-Korr Cost Category"; Code[20])
        {
            Caption = 'DSD Cost Category Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Cost Category";
        }
        field(3; "autom. BUIUpdate"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Differenzbuchhaltung aktiv"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Andruck GGN auf Belegen"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(6; Firmenlogo1; BLOB)
        {
            DataClassification = CustomerContent;
        }
        field(7; Firmenlogo2; BLOB)
        {
            DataClassification = CustomerContent;
        }
        field(8; "EORI-Nummer"; Code[17])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Mailadresse QS-Bericht"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(100000; "VK Kreditlimit Block"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "from zero","ignore zero";
        }
        field(100010; "VK CheckVAT"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(100020; "VK Gelangensbestaetigung"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(100021; "VK Gelangensbestaetigung Text"; Code[10])
        {
            Caption = 'Ausgabe Textbaustein';
            DataClassification = CustomerContent;
            TableRelation = "Standard Text";
        }
        field(200001; "Path Purchase Claim"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(200002; "Path Purchase Claim Capture"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(200010; "Path Sales Claim"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

