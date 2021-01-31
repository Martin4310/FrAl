table 50934 "POI Certificate Types"
{
    DataPerCompany = false;
    Caption = 'Certificate Typs';
    DrillDownPageID = "POI Certificate Typs";
    LookupPageID = "POI Certificate Typs";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[30])
        {
            Caption = 'Beschreibung';
            DataClassification = CustomerContent;
        }
        field(20; Comment; Text[50])
        {
            Caption = 'Bemerkung';
            DataClassification = CustomerContent;
        }
        field(30; Activ; Boolean)
        {
            Caption = 'Aktiv';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Activ and not "Customer Certificate" and not "Vendor Certificate" then
                    Error('Kundenseitiges oder Lieferantenseitiges Zertifikat muss abgegeben sein.');
            end;
        }
        field(40; "Check Valid"; Boolean)
        {
            Caption = 'Gültigkeit erforderlich';
            DataClassification = CustomerContent;
        }
        field(50; "Validation Action"; enum "POI Validation Action")
        {
            Caption = 'Aktion bei Ablauf';
            DataClassification = CustomerContent;
        }
        Field(60; "Certification of Product"; Boolean)
        {
            Caption = 'Produktzertifizierung';
            DataClassification = CustomerContent;
        }
        Field(61; "Certification of Account"; Boolean)
        {
            Caption = 'Geschäftspartnerzertifizierung';
            DataClassification = CustomerContent;
        }
        Field(62; "Certification of Packing"; Boolean)
        {
            Caption = 'Verpackungszertifizierung';
            DataClassification = CustomerContent;
        }
        field(70; "Subject to Licence"; Boolean)
        {
            Caption = 'Lizenzgebührenpflichtig';
            DataClassification = CustomerContent;
        }
        field(80; "Certificate Control Board"; Code[20])
        {
            Caption = 'Certificate Control Board';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(81; "Certificate Control Board Name"; Text[50])
        {
            CalcFormula = Lookup (Vendor.Name WHERE("No." = FIELD("Certificate Control Board")));
            Caption = 'Certificate Control Board Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "Customer Certificate"; Boolean)
        {
            caption = 'Kundenseitiges Zertifikat';
            DataClassification = CustomerContent;
        }
        field(91; "Vendor Certificate"; Boolean)
        {
            caption = 'Lieferantenseitiges Zertifikat';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Code)
        {
        }
    }
}

