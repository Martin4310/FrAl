table 50017 "POI Departure Region"
{
    Caption = 'Departure/Arrival Region';
    DrillDownPageID = "POI Departure/Arrival Region";
    LookupPageID = "POI Departure/Arrival Region";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; RegionType; option)
        {
            Caption = 'RegionType';
            DataClassification = CustomerContent;
            OptionMembers = Departure,Arrival,Transfer;
            OptionCaption = 'Abfahrtsregion,Ankunftsregion,Transferregion';
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; "Description 2"; Text[30])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(5720; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
    }

    keys
    {
        key(Key1; "Code", RegionType)
        {
        }
    }

    trigger OnDelete()
    var
        lrc_PrintDocumentSourceDetail: Record "POI Print Doc. Source Detail";
    begin
        lrc_PrintDocumentSourceDetail.RESET();
        lrc_PrintDocumentSourceDetail.SETCURRENTKEY("Source Type", "Source No.", "Report ID");
        lrc_PrintDocumentSourceDetail.SETRANGE("Source Type", lrc_PrintDocumentSourceDetail."Source Type"::"Departure Region");
        lrc_PrintDocumentSourceDetail.SETRANGE("Source No.", Code);
        IF lrc_PrintDocumentSourceDetail.FIND('-') THEN
            lrc_PrintDocumentSourceDetail.DELETEALL(TRUE);
    end;
}

