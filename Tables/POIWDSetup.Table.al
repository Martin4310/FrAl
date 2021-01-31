table 50923 "POI W.D. Setup"
{
    Caption = 'W.D. Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Customer No. DSD"; Text[7])
        {
            Caption = 'Customer No. DSD';
        }
        field(11; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(12; "Export Path DSD"; Text[250])
        {
            Caption = 'Export Path DSD';
        }
        field(13; "Registration No. DSD AG"; Text[30])
        {
            Caption = 'Registration No. DSD AG';
        }
        field(14; "DSD Active"; Boolean)
        {
            Caption = 'DSD Active';

            trigger OnValidate()
            var
                "DebitorenVerkaufEinr.": Record "Sales & Receivables Setup";
            begin
                IF "DSD Active" THEN BEGIN
                    "DebitorenVerkaufEinr.".GET();
                    "DebitorenVerkaufEinr."."Shipment on Invoice" := TRUE;
                    "DebitorenVerkaufEinr.".MODIFY();
                END;
            end;
        }
        field(15; "Navision Version"; Text[10])
        {
            Caption = 'Navision Version';
        }
        field(16; "VAT Percent"; Decimal)
        {
            Caption = 'VAT Percent';
        }
        field(30; "DSD G/L Acc. No"; Code[20])
        {
            Caption = 'DSD G/L Acc. No';
            TableRelation = "G/L Account";
        }
        field(32; "DSD Amout Deb./Cred."; Option)
        {
            Caption = 'DSD Amout Deb./Cred.';
            OptionCaption = 'Soll,Haben';
            OptionMembers = Soll,Haben;
        }
        field(33; "DSD Change Sign"; Boolean)
        {
            Caption = 'DSD Change Sign';
        }
        field(35; "DSD Bal. G/L Acc. No"; Code[20])
        {
            Caption = 'DSD Bal. G/L Acc. No';
            TableRelation = "G/L Account";
        }
        field(37; "DSD Description"; Text[50])
        {
            Caption = 'DSD Description';
        }
        field(39; "DSD Vendor No."; Code[20])
        {
            Caption = 'DSD Vendor No.';
            TableRelation = Vendor;
        }
        field(40; "DSD Cost Category Code"; Code[20])
        {
            Caption = 'DSD Cost Category Code';
        }
        field(50; "DSD BellandVision No."; Code[10])
        {
            Caption = 'DSD BellandVision No.';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }
}

