table 50014 "POI Attachement Setup"
{
    DataClassification = CustomerContent;
    DrillDownPageId = 50009;
    DataPerCompany = false;

    fields
    {
        field(1; "Group Code"; Integer)
        {
            Caption = 'Group Code';
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(3; "Path"; Text[250])
        {
            Caption = 'Path';
            DataClassification = CustomerContent;
        }
        field(4; "Document Type"; Code[50])
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            TableRelation = "POI Documenttype Attachments"."Document type Code";
        }
        field(5; "Document No"; Code[20])
        {
            Caption = 'Document No';
            DataClassification = CustomerContent;
        }
        field(6; "Language"; Code[10])
        {
            Caption = 'Language';
            DataClassification = CustomerContent;
            TableRelation = Language.Code;
        }
        field(7; Mandant; Code[59])
        {
            Caption = 'Mandant';
            DataClassification = CustomerContent;
            TableRelation = "POI Company".Mandant;
        }

    }

    keys
    {
        key(PK; "Group Code", "Document Type", "Document No", Language)
        {
            Clustered = true;
        }
    }

}