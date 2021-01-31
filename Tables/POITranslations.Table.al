table 50012 "POI Translations"
{
    fields
    {
        field(1; "Table ID"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(3; "Code 2"; Code[20])
        {
            Caption = 'Code 2';
            DataClassification = CustomerContent;
        }
        field(4; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            DataClassification = CustomerContent;
            TableRelation = Language.Code;
        }
        field(5; "Description"; Text[400])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(7; "Description 3"; Text[100])
        {
            Caption = 'Description 3';
            DataClassification = CustomerContent;
        }
        field(8; "Description 4"; Text[100])
        {
            Caption = 'Description 4';
            DataClassification = CustomerContent;
        }
        field(9; "Line No."; Integer)
        {
            Caption = 'Zeilennr.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(key1; "Table ID", Code, "Code 2", "Language Code", "Line No.") { }
    }
    procedure GetTranslationDescription(TableID: Integer; GroupCode: Code[20]; SubGroupCode: Code[20]; LanguageCode: Code[10]; DescriptionNo: Integer; LineNo: Integer): Text[400]
    begin
        // case true of
        //     LanguageCode = '':
        //         LanguageCode := 'DEU';
        //     not (LanguageCode in ['DEU', 'ENU', 'ESP', 'PTG']):
        //         LanguageCode := 'ENU';
        // end;

        if LanguageCode = '' then LanguageCode := 'DEU';

        if not Get(TableID, GroupCode, SubGroupCode, LanguageCode, LineNo) then
            if not Get(TableID, GroupCode, SubGroupCode, 'ENU') then exit('');
        case DescriptionNo of
            1:
                exit(Description);
            2:
                exit("Description 2");
            3:
                exit("Description 3");
            4:
                exit("Description 4");
            else
                exit('');
        end;
    end;

    procedure GetTranslationDescription(TableID: Integer; GroupCode: Code[20]; SubGroupCode: Code[20]; LanguageCode: Code[10]; DescriptionNo: Integer): Text

    var
        OutText: Text;

    begin
        if LanguageCode = '' then LanguageCode := 'DEU';

        SetRange("Table ID", TableID);
        SetRange(Code, GroupCode);
        SetRange("Code 2", SubGroupCode);
        SetRange("Language Code", LanguageCode);
        if Count = 0 then
            SetRange("Language Code", 'ENU');
        if FindSet() then
            repeat
                case DescriptionNo of
                    1:
                        OutText += Description;
                    2:
                        OutText += "Description 2";
                    3:
                        OutText += "Description 3";
                    4:
                        OutText += "Description 4";
                end;
            until Next() = 0;
        exit(OutText);
    end;
}