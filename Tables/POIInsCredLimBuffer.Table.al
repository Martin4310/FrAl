table 50913 "POI Ins. Cred. lim. Buffer"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Easy No."; Code[20])
        {
            Caption = 'Easy No.';
            Description = 'Enterprise Access System Nummer';
            DataClassification = CustomerContent;
        }
        field(2; "Account Name"; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; Address; Text[50])
        {
            Caption = 'Adresse';
            DataClassification = CustomerContent;
        }
        field(4; City; Text[30])
        {
            Caption = 'Ort';
            DataClassification = CustomerContent;
        }
        field(5; "Post Code"; Text[50])
        {
            Caption = 'PLZ';
            DataClassification = CustomerContent;
        }
        field(6; "Credit Insurance No."; Code[20])
        {
            Caption = 'Kreditversicherungsnr.';
            DataClassification = CustomerContent;
        }
        field(7; "Handelsregisternr."; Code[20])
        {
            Caption = 'Handelsregisternr.';
            DataClassification = CustomerContent;
        }
        field(8; "Product"; Code[30])
        {
            Caption = 'Produkt';
            DataClassification = CustomerContent;
            TableRelation = "POI Insurance Contract Type"."Contract Type Code" where(Type = const(0));
        }
        field(9; "Company Name"; Text[100])
        {
            Caption = 'Mandant';
            DataClassification = CustomerContent;
        }
        field(10; "Decision Date"; Date)
        {
            Caption = 'Entscheidungsdatum';
            DataClassification = CustomerContent;
        }
        field(11; "Status"; Text[50])
        {
            //OptionMembers = gestrichen,gültig,"Weitere Lieferungen",Abgelehnt,"Streichung Coface","in Bearbeitung","Manuelle Entscheidung mit Bemerkungen";
            //OptionCaption = 'gestrichen,gültig,Weitere Lieferungen,Abgelehnt,Streichung Coface,in Bearbeitung,Manuelle Entscheidung mit Bemerkungen';
            Caption = 'Status';
            DataClassification = CustomerContent;
            TableRelation = "POI Insurance Contract Type"."Contract Type Code" where(Type = const(1));
        }
        field(12; "Key Field1"; Text[50])
        {
            Caption = 'Entscheidungsschlüssel Coface Paris 1';
            DataClassification = CustomerContent;
        }
        field(13; "Key Field2"; Text[50])
        {
            Caption = 'Entscheidungsschlüssel Coface Paris 2';
            DataClassification = CustomerContent;
        }
        field(14; "Key Field3"; Text[50])
        {
            Caption = 'Entscheidungsschlüssel Coface Paris 3';
            DataClassification = CustomerContent;
        }
        field(15; "valid from"; Date)
        {
            Caption = 'gültig ab';
            DataClassification = CustomerContent;
        }
        field(16; "valid to"; Date)
        {
            Caption = 'gültig bis';
            DataClassification = CustomerContent;
        }
        field(17; Amount; Decimal)
        {
            Caption = 'Entscheidungsbetrag';
            DataClassification = CustomerContent;
        }
        field(18; DRA; Text[50])
        {
            Caption = 'Debtor Risk Assessment';
            Description = 'Debtor Risk Assessment';
            DataClassification = CustomerContent;
        }
        field(19; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(20; "Insurance Company Code"; Code[20])
        {
            Caption = 'Kreditornr. Versicherung';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(21; "Contract No."; Code[50])
        {
            Caption = 'Vertragsnr.';
            DataClassification = CustomerContent;
        }
        field(22; Rating; Code[10])
        {
            Caption = 'Rating';
            DataClassification = CustomerContent;
            TableRelation = "POI Insurance Contract Type"."Contract Type Code" where(Type = const(2));
        }
        field(23; "Date of Request"; Date)
        {
            Caption = 'Antragsdatum';
            DataClassification = CustomerContent;
        }
        field(24; "Account No. Customer"; Code[20])
        {
            Caption = 'Nr. des Debitors';
            DataClassification = CustomerContent;
        }
        field(25; "Account No. Vendor"; Code[20])
        {
            Caption = 'Nr. des Kreditors';
            DataClassification = CustomerContent;
        }
        field(26; "Error Text"; Text[100])
        {
            Caption = 'Fehler Text';
            DataClassification = CustomerContent;
        }
        field(27; "Additional Insurance"; Boolean)
        {
            Caption = 'Zusatzversicherung';
            DataClassification = CustomerContent;
        }
        Field(29; "International Account Name"; Text[100])
        {
            Caption = 'Internationaler Name';
            DataClassification = CustomerContent;
        }
        Field(30; Country; Text[30])
        {
            Caption = 'Land';
            DataClassification = CustomerContent;
        }
        Field(31; "Coface No."; Code[20])
        {
            Caption = 'Coface Nr.';
            DataClassification = CustomerContent;
        }
        Field(32; "ID Name 1"; Text[50])
        {
            Caption = 'öfftl. Ident. Name 1';
            DataClassification = CustomerContent;
        }
        Field(33; "ID No 1"; Text[50])
        {
            Caption = 'öfftl. Ident. Nr.1';
            DataClassification = CustomerContent;
        }
        Field(34; "ID Name 2"; Text[50])
        {
            Caption = 'öfftl. Ident. Name 2';
            DataClassification = CustomerContent;
        }
        Field(35; "ID No. 2"; Text[50])
        {
            Caption = 'öfftl. Ident. Nr.2';
            DataClassification = CustomerContent;
        }
        Field(36; "ID Name 3"; Text[50])
        {
            Caption = 'öfftl. Ident. Name 3';
            DataClassification = CustomerContent;
        }
        Field(37; "ID No. 3"; Text[50])
        {
            Caption = 'öfftl. Ident. Name';
            DataClassification = CustomerContent;
        }
        Field(38; "User ID"; Code[50])
        {
            Caption = 'Nutzerkennung';
        }
        field(39; "Contract Type"; Text[20])
        {
            Caption = 'Vertragsart';
            DataClassification = CustomerContent;
        }
        Field(40; "NZM Reference"; Code[20])
        {
            Caption = 'NMZ Referenz';
            DataClassification = CustomerContent;
        }
        Field(41; "Request Amount"; Decimal)
        {
            Caption = 'Antragsbetrag';
            DataClassification = CustomerContent;
        }
        Field(42; "Request Currency"; Code[10])
        {
            Caption = 'Antragswährung';
            DataClassification = CustomerContent;
        }
        Field(43; "Credit Goal"; Text[50])
        {
            Caption = 'Kreditziel';
            DataClassification = CustomerContent;
        }
        Field(44; "Decision Type"; Text[50])
        {
            Caption = 'Entscheidungsart';
            DataClassification = CustomerContent;
        }
        Field(45; "Currency Decision Amount"; Code[10])
        {
            Caption = 'Währung (Entscheidungsbetrag)';
            DataClassification = CustomerContent;
        }
        Field(46; "Comment Credit Auditor"; Text[250])
        {
            Caption = 'Kommentar des Kreditprüfers';
            DataClassification = CustomerContent;
        }
        Field(47; "insured share"; Text[50])
        {
            Caption = 'versicherter Anteil';
            DataClassification = CustomerContent;
        }
        Field(48; "Account Reference"; Text[50])
        {
            Caption = 'Kundenreferenz';
            DataClassification = CustomerContent;
        }
        Field(49; "Outstanding balance"; Text[30])
        {
            Caption = 'Außenstand';
            DataClassification = CustomerContent;
        }
        field(50; IntCreditlimit; Decimal)
        {
            Caption = 'IntCreditlimit';
            DataClassification = CustomerContent;
        }
        Field(51; "Country Code"; Code[10])
        {
            Caption = 'Land';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Easy No.", "Contract No.", Product, "Company Name", "valid from", "date of Request", Status)
        {
            Clustered = true;
        }
    }

}