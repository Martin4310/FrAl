table 50907 "POI Certificates Cust./Vend."
{
    Caption = 'Certificates Cust./Vend.';
    DataPerCompany = false;
    DrillDownPageID = "POI Certificates Cust./Vend.";
    LookupPageID = "POI Certificates Cust./Vend.";

    fields
    {
        field(1; Source; Option)
        {
            Caption = 'Source';
            DataClassification = CustomerContent;
            OptionCaption = 'Kunde,Lieferant';
            OptionMembers = Customer,Vendor;
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
            TableRelation = IF (Source = CONST(Vendor)) Vendor
            ELSE
            IF (Source = CONST(Customer)) Customer;

            trigger OnValidate()
            var
                lrc_Customer: Record Customer;
                lrc_Vendor: Record Vendor;
            begin
                IF "Source No." <> '' THEN
                    CASE Source OF
                        Source::Customer:
                            BEGIN
                                lrc_Customer.GET("Source No.");
                                "Source No. 2" := lrc_Customer."POI No. 2";
                                "Source Name" := lrc_Customer.Name;
                                "Source Name 2" := lrc_Customer."Name 2";
                            END;
                        Source::Vendor:
                            BEGIN
                                lrc_Vendor.GET("Source No.");
                                "Source No. 2" := lrc_Vendor."No. 2";
                                "Source Name" := lrc_Vendor.Name;
                                "Source Name 2" := lrc_Vendor."Name 2";
                            END;
                    END
                ELSE
                    "Source No. 2" := '';
            end;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(5; "Internal ID"; Integer)
        {
            Caption = 'Internal ID';
            DataClassification = CustomerContent;
        }
        field(10; "Certification Typ Code"; Code[10])
        {
            Caption = 'Certification Typ Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Certificate Types".Code;
            trigger OnValidate()
            var
                ConfTrue: Boolean;
            begin
                CertificateCustVendChapter.SetRange("Entry No.", "Entry No.");
                if CertificateCustVendChapter.Count() > 0 then
                    ConfTrue := Confirm('Alle Kapitel werden gelöscht', false)
                else
                    ConfTrue := true;
                if ConfTrue then begin
                    CertificateCustVendChapter.DeleteAll();
                    CertificateChapter.Reset();
                    CertificateChapter.SetRange("Certification No.", "Certification Typ Code");
                    if CertificateChapter.FindSet() then
                        repeat
                            CertificateCustVendChapter.Init();
                            CertificateCustVendChapter."Entry No." := "Entry No.";
                            CertificateCustVendChapter."Certificate Type" := CertificateChapter."Certification No.";
                            CertificateCustVendChapter."Certificate Chapter No." := CertificateChapter."Certificate Chapter No.";
                            CertificateCustVendChapter.Insert()
                        until certificateChapter.Next() = 0;
                end;
            end;
        }
        field(11; "Certification No."; Code[20])
        {
            Caption = 'Certification No.';
            DataClassification = CustomerContent;
        }
        field(12; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Product Group".Code;
        }
        field(13; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(14; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(15; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            DataClassification = CustomerContent;
        }

        field(17; "Producer Name"; Text[50])
        {
            Caption = 'Producer Name';
            DataClassification = CustomerContent;
        }
        field(18; "Producer Name 2"; Text[50])
        {
            Caption = 'Producer Name 2';
            DataClassification = CustomerContent;
        }
        field(20; "Date of Receiving"; Date)
        {
            Caption = 'Date of Receiving';
            DataClassification = CustomerContent;
        }
        field(21; "Valid Untill"; Date)
        {
            Caption = 'Valid Until';
            DataClassification = CustomerContent;
        }
        field(22; "Valid From"; Date)
        {
            Caption = 'Valid From';
            DataClassification = CustomerContent;
        }
        field(40; "Contact Name"; Text[30])
        {
            Caption = 'Contact Name';
            DataClassification = CustomerContent;
        }
        field(50; Comment; Text[250])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(51; "Print on Label"; Boolean)
        {
            Caption = 'Print on Label';
            DataClassification = CustomerContent;
        }
        field(52; "External Archive No."; Code[20])
        {
            Caption = 'External Archive No.';
            DataClassification = CustomerContent;
        }
        field(100; Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionCaption = 'Offen,,Freigegeben,,Abgelaufen,,Gesperrt,,Nachfolgezertifikat';
            OptionMembers = Offen,,Freigegeben,,Abgelaufen,,Gesperrt,,Nachfolgezertifikat;

            trigger OnValidate()
            var
                CertType: Record "POI Certificate Types";
            begin
                if (Status = Status::Freigegeben) or (Status = Status::Nachfolgezertifikat) then begin
                    CertType.Get("Certification No.");
                    if CertType."Check Valid" and ("Valid Untill" = 0D) then
                        Error('Gültogkeit fehlt.');
                    if not CertType.Activ then
                        Error('Zertifikatstyp nicht freigegeben (aktiv).');
                end;
            end;
        }
        field(150; "Print Priority"; Integer)
        {
            Caption = 'Print Priority';
            DataClassification = CustomerContent;
            MaxValue = 10;
            MinValue = 0;
        }
        field(200; "Source No. 2"; Code[20])
        {
            Caption = 'Source No. 2';
            DataClassification = CustomerContent;
        }
        field(201; "Attached Source No."; Code[20])
        {
            Caption = 'Attached Source No.';
            DataClassification = CustomerContent;
            TableRelation = IF (Source = CONST(Vendor)) Vendor
            ELSE
            IF (Source = CONST(Customer)) Customer;

            trigger OnValidate()
            var
                lrc_Customer: Record Customer;
                lrc_Vendor: Record Vendor;
            begin
                IF "Attached Source No." <> '' THEN
                    CASE Source OF
                        Source::Customer:
                            BEGIN
                                lrc_Customer.GET("Attached Source No.");
                                "Attached Source Name" := lrc_Customer.Name;
                            END;
                        Source::Vendor:
                            BEGIN
                                lrc_Vendor.GET("Attached Source No.");
                                "Attached Source Name" := lrc_Vendor.Name;
                            END;
                    END

                ELSE
                    "Attached Source Name" := '';
            end;
        }
        field(202; "Attached Source Name"; Text[100])
        {
            Caption = 'Attached Source Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(210; "Source Name"; Text[100])
        {
            Caption = 'Source Name';
            DataClassification = CustomerContent;
        }
        field(211; "Source Name 2"; Text[100])
        {
            Caption = 'Source Name 2';
            DataClassification = CustomerContent;
        }
        field(250; "Filter Product Groups"; Code[100])
        {
            Caption = 'Filter Product Groups';
            DataClassification = CustomerContent;
        }
        field(260; "Product Group Filter"; Code[10])
        {
            Caption = 'Product Group Filter';
            FieldClass = FlowFilter;
            TableRelation = "POI Product Group".Code;
            ValidateTableRelation = false;
        }
        field(300; "No. of Prod.-Grp Restrictions"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("POI Certificates Restrictions" WHERE("Internal ID" = FIELD("Internal ID"),
                                                                   "Product Group Code" = FIELD("Product Group Filter")));
            Caption = 'No. of Prod.-Grp Restrictions';
            Editable = false;
        }
        field(50001; "Manufacturer No."; Code[10])
        {
            Caption = 'Hersteller No.';
            DataClassification = CustomerContent;
        }
        field(50002; "Manufacturer Name"; Text[50])
        {
            Caption = 'Hersteller Name';
            DataClassification = CustomerContent;
        }
        field(50003; Archiv; Boolean)
        {
            Caption = 'abgelaufen';
            DataClassification = CustomerContent;
        }
        field(50004; "Entry No."; Integer)
        {
            Caption = 'lfd. Nr.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(key1; Source, "Source No.", "Certification Typ Code", "Valid From", "Valid Untill")
        {
        }
        key(Key5; Source, "Source No.", "Manufacturer No.", "Certification Typ Code", "Line No.")
        {
        }
        key(Key2; Source, "Source No.", "Line No.")
        {
        }
        key(Key3; "Certification Typ Code", "Country of Origin Code", "Product Group Code")
        {
        }
        key(Key4; Source, "Source No.", "Print Priority", "Valid From", "Valid Untill")
        {
        }
    }

    trigger OnDelete()
    var
        lrc_CertificatesRestrictions: Record "POI Certificates Restrictions";
    begin
        // Verknüpfte Eingrenzungen löschen
        lrc_CertificatesRestrictions.RESET();
        lrc_CertificatesRestrictions.SETRANGE("Internal ID", "Internal ID");
        lrc_CertificatesRestrictions.DELETEALL();
    end;

    trigger OnInsert()
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_Customer: Record Customer;
        lrc_Vendor: Record Vendor;
        NextNo: Integer;
    begin
        lrc_CertificatesCustVend.Reset();
        if lrc_CertificatesCustVend.FindLast() then
            NextNo := lrc_CertificatesCustVend."Entry No." + 1
        else
            NextNo := 1;
        "Entry No." := NextNo;

        IF "Internal ID" = 0 THEN BEGIN
            lrc_FruitVisionSetup.LOCKTABLE();
            lrc_FruitVisionSetup.GET();
            lrc_FruitVisionSetup."No. Series Certificate Entries" := lrc_FruitVisionSetup."No. Series Certificate Entries" + 1;
            lrc_FruitVisionSetup.MODIFY();
            "Internal ID" := lrc_FruitVisionSetup."No. Series Certificate Entries";
        END;

        IF "Line No." = 0 THEN BEGIN
            lrc_CertificatesCustVend.SETRANGE(Source, Source);
            lrc_CertificatesCustVend.SETRANGE("Source No.", "Source No.");
            IF lrc_CertificatesCustVend.FINDLAST() THEN
                "Line No." := lrc_CertificatesCustVend."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;

        IF "Source No." <> '' THEN
            CASE Source OF
                Source::Customer:
                    BEGIN
                        lrc_Customer.GET("Source No.");
                        "Source No. 2" := lrc_Customer."POI No. 2";
                        "Source Name" := lrc_Customer.Name;
                        "Source Name 2" := lrc_Customer."Name 2";
                    END;
                Source::Vendor:
                    BEGIN
                        lrc_Vendor.GET("Source No.");
                        "Source No. 2" := lrc_Vendor."No. 2";
                        "Source Name" := lrc_Vendor.Name;
                        "Source Name 2" := lrc_Vendor."Name 2";
                    END;
            END
        ELSE
            "Source No. 2" := '';


    end;

    var
        lrc_CertificatesCustVend: Record "POI Certificates Cust./Vend.";
        CertificateCustVendChapter: Record "POI Certif. Cust/Vend Chapter";
        CertificateChapter: Record "POI Certification Chapter";
}

