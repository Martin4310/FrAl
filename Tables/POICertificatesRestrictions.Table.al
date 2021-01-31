table 50909 "POI Certificates Restrictions"
{

    Caption = 'Certificates Restrictions';
    DataPerCompany = false;
    DrillDownPageID = "POI Certificates Restrictions";
    LookupPageID = "POI Certificates Restrictions";

    fields
    {
        field(1; "Internal ID"; Integer)
        {
            Caption = 'Internal ID';
        }
        field(2; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;
        }
        field(4; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            TableRelation = "POI Trademark";
        }
        field(10; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(12; "Producer No."; Code[20])
        {
            Caption = 'Producer No.';
        }
        field(14; "Certificate Typ Code"; Code[10])
        {
            Caption = 'Certificate Typ Code';
            TableRelation = "POI Certificate Types";
        }
        field(16; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
        }
        field(50; "Product Group Description"; Text[50])
        {
            CalcFormula = Lookup ("POI Product Group".Description WHERE(Code = FIELD("Product Group Code")));
            Caption = 'Product Group Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Internal ID", "Product Group Code", "Trademark Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        lrc_CertificatesCustVend: Record "POI Certificates Cust./Vend.";
    begin

        lrc_CertificatesCustVend.GET("Internal ID");
        "Vendor No." := lrc_CertificatesCustVend."Source No.";
        //???"Producer No." := lrc_CertificatesCustVend."Producer No.";
        "Certificate Typ Code" := lrc_CertificatesCustVend."Certification Typ Code";
        "Country of Origin Code" := lrc_CertificatesCustVend."Country of Origin Code";
    end;
}

