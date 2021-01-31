table 50912 "POI Fiscal Agent"
{
    Caption = 'Fiscal Agent';
    DrillDownPageID = "POI Fiscal Agent";
    LookupPageID = "POI Fiscal Agent";

    fields
    {
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(3; Name; Text[30])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(4; "Name 2"; Text[30])
        {
            Caption = 'Name 2';
            DataClassification = CustomerContent;
        }
        field(5; Address; Text[30])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(6; "Address 2"; Text[30])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(7; City; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country Code", true);
            end;
        }
        field(8; Contact; Text[30])
        {
            Caption = 'Contact';
            DataClassification = CustomerContent;
        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(10; "Telex No."; Text[30])
        {
            Caption = 'Telex No.';
            DataClassification = CustomerContent;
        }
        field(35; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(54; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(84; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            DataClassification = CustomerContent;
        }
        field(86; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                VATRegNoFormat.Test("VAT Registration No.", "Country Code", Code, DATABASE::Vendor);
            end;
        }
        field(91; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
            TableRelation = "Post Code";
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookUpPostCode(City, "Post Code", County, "Country Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country Code", true);
            end;
        }
        field(92; "County"; Text[30])
        {
            Caption = 'County';
            DataClassification = CustomerContent;
        }
        field(102; "E-Mail"; Text[250])
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
        }
        field(103; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            DataClassification = CustomerContent;
        }
        field(104; "Invoice Text 1"; Text[100])
        {
            Caption = 'Rechnungstext 1';
            DataClassification = CustomerContent;
        }
        field(105; "Invoice Text 2"; Text[100])
        {
            Caption = 'Rechnungstext 2';
            DataClassification = CustomerContent;
        }
        field(106; "Invoice Text 3"; Text[100])
        {
            Caption = 'Rechnungstext 3';
            DataClassification = CustomerContent;
        }
        field(107; "Invoice Text 4"; Text[100])
        {
            Caption = 'Rechnungstext 4';
            DataClassification = CustomerContent;
        }
        field(108; "Shipment Method Code 1/2"; Code[10])
        {
            Caption = 'Lieferbedingung 1/2';
            DataClassification = CustomerContent;
            TableRelation = "Shipment Method".Code;
        }
        field(109; "Shipment Method Code 3/4"; Code[10])
        {
            Caption = 'Lieferbedingung 3/4';
            DataClassification = CustomerContent;
            TableRelation = "Shipment Method".Code;
        }
        field(110; "Print Sorting Series"; Code[10])
        {
            Caption = 'Druckfolge Nummernserie';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Code") { }
    }

    trigger OnDelete()
    var
        LanguageTranslation: Record "POI Translations";
    begin
        LanguageTranslation.RESET();
        LanguageTranslation.SETRANGE("Table ID", DATABASE::"POI Fiscal Agent");
        LanguageTranslation.SETRANGE(Code, Code);
        LanguageTranslation.DELETEALL();

        if LanguageTranslation.FIND('-') then
            LanguageTranslation.DELETEALL();
    end;

    var
        PostCode: Record "Post Code";
}

