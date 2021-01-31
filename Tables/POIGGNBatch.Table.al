table 50019 "POI GGN - Batch"
{
    //DrillDownFormID = Form50093;
    //LookupFormID = Form50093;

    fields
    {
        field(1; "Batch No."; Code[20])
        {
            Caption = 'Batch no.';
            DataClassification = CustomerContent;
            Editable = true;
            //TableRelation = Batch;
        }
        field(2; GGN; Code[20])
        {
            Caption = 'GGN';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Weight: Text[12];
                CheckSum: Integer;
                lint_GGN: BigInteger;
            begin
                Weight := '131313131313';
                CheckSum := STRCHECKSUM(DELSTR(GGN, 13), Weight);
                EVALUATE(lint_GGN, GGN);
                IF (lint_GGN MOD 10 - CheckSum) <> 0 THEN
                    ERROR('Der GGN - Eintrag ist formal falsch, bitte überprüfen sie die Eingabe');

                "Last Date Time Modified" := CurrentDateTime();
                "Last Modify By User" := CopyStr(UserId(), 1, 100);
            end;
        }
        field(12; "Created Date Time"; DateTime)
        {
            Caption = 'Created date time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; "Created By User"; Code[20])
        {
            Caption = 'Created by user';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Last Date Time Modified"; DateTime)
        {
            Caption = 'Last date time modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(15; "Last Modify By User"; Text[100])
        {
            Caption = 'Last modify by user';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(100; "Document Path"; Text[250])
        {
            Caption = 'Document path';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(101; Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            Enabled = false;
            OptionCaption = ' ,Closed';
            OptionMembers = " ",Closed;
        }
        field(102; "Document Path BLOB"; BLOB)
        {
            Caption = 'Document path BLOB';
            DataClassification = CustomerContent;
            Enabled = false;
        }
        field(103; Filename; Text[250])
        {
            Caption = 'Filename';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(120; "Vendor Name"; Text[50])
        {
            Caption = 'Vendor name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(121; "Vendor No."; Code[20])
        {
            Caption = 'Vendor no.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(122; "Item Description"; Text[50])
        {
            Caption = 'Item description';
            DataClassification = CustomerContent;
        }
        field(123; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(124; "Unit Of Measure Code"; Code[10])
        {
            Caption = 'Unit of measure code';
            DataClassification = CustomerContent;
        }
        field(125; "Departure Date"; Date)
        {
            Caption = 'Departure date';
            DataClassification = CustomerContent;
        }
        field(126; "Your Reference"; Text[70])
        {
            Caption = 'Your reference';
            DataClassification = CustomerContent;
        }
        field(127; "Lot No."; Code[20])
        {
            CaptionClass = '5110300,1,3';
            Caption = 'Lot no.';
            DataClassification = CustomerContent;
        }
        field(128; Blocked; Option)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Erzeuger,Erzeugergruppe';
            OptionMembers = " ",Erzeuger,Erzeugergruppe;
        }
        field(129; "Date Of GGN Blocking"; Date)
        {
            Caption = 'Datum der GGN Sperrung';
            DataClassification = CustomerContent;
        }
        field(200; "No. Of Packages"; Integer)
        {
            Caption = 'No. of packages';
            DataClassification = CustomerContent;
        }
        field(201; "Departure Location Code"; Code[10])
        {
            Caption = 'Abgangslager';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(202; "Location Code"; Code[10])
        {
            Caption = 'Lagerortcode';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1; "Batch No.", GGN)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Created Date Time" := CurrentDateTime();
        "Created By User" := CopyStr(UserId(), 1, 20);
    end;

    trigger OnModify()
    begin
        "Last Date Time Modified" := CurrentDateTime();
        "Last Modify By User" := CopyStr(UserId(), 1, 20);
    end;

    procedure SetUpNewLine(PosVarNr: Code[20])
    var
        GGNBatch: Record "POI GGN - Batch";
    //lfm_GGNBatch: Form "50094";
    begin
        GGNBatch.FILTERGROUP(2);
        GGNBatch.SETRANGE("Batch No.", PosVarNr);
        IF NOT GGNBatch.FIND('-') THEN BEGIN
            GGNBatch."Batch No." := PosVarNr;
            GGNBatch."Created Date Time" := CurrentDateTime();
            GGNBatch."Created By User" := CopyStr(UserId(), 1, 20);
        END;
        GGNBatch.FILTERGROUP(0);
        //lfm_GGNBatch.SETTABLEVIEW(GGNBatch);
        //lfm_GGNBatch.RUNMODAL;
    end;
}

