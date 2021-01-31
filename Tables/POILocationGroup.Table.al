table 50018 "POI Location Group"
{
    Caption = 'Location Group';
    //DrillDownFormID = Form5110687;
    //LookupFormID = Form5110687;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(10; Name; Text[30])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(11; "Name 2"; Text[30])
        {
            Caption = 'Name 2';
            DataClassification = CustomerContent;
        }
        field(14; Address; Text[30])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(15; "Address 2"; Text[30])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(17; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            DataClassification = CustomerContent;
        }
        field(18; "Contact Name"; Text[30])
        {
            Caption = 'Contact Name';
            DataClassification = CustomerContent;
        }
        field(20; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";

        }
        field(21; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
            TableRelation = "Post Code".Code;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookUpPostCode(City, "Post Code", "County Code", "Country Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", "County Code", "Country Code", true);
            end;
        }
        field(22; City; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City, "Post Code", "County Code", "Country Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", "County Code", "Country Code", true);
            end;
        }
        field(23; "County Code"; Text[30])
        {
            Caption = 'County Code';
            DataClassification = CustomerContent;
        }
        field(25; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(26; "Phone No. 2"; Text[30])
        {
            Caption = 'Phone No. 2';
            DataClassification = CustomerContent;
        }
        field(28; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            DataClassification = CustomerContent;
        }
        field(29; "Telex No."; Text[30])
        {
            Caption = 'Telex No.';
            DataClassification = CustomerContent;
        }
        field(30; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
        }
        field(31; "Home Page"; Text[90])
        {
            Caption = 'Home Page';
            DataClassification = CustomerContent;
        }
        field(50; "Phys. Inventory Location Code"; Code[10])
        {
            Caption = 'Phys. Inventory Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        field(51; "Sales Claim Location Code"; Code[10])
        {
            Caption = 'Sales Claim Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lrc_PrintDocumentSourceDetail: Record "POI Print Doc. Source Detail";
    begin
        lrc_PrintDocumentSourceDetail.RESET();
        lrc_PrintDocumentSourceDetail.SETCURRENTKEY("Source Type", "Source No.", "Report ID");
        lrc_PrintDocumentSourceDetail.SETRANGE("Source Type", lrc_PrintDocumentSourceDetail."Source Type"::"Location Group");
        lrc_PrintDocumentSourceDetail.SETRANGE("Source No.", Code);
        IF lrc_PrintDocumentSourceDetail.FIND('-') THEN
            lrc_PrintDocumentSourceDetail.DELETEALL(TRUE);
    end;

    var
        PostCode: Record "Post Code";
}

