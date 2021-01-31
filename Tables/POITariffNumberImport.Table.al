table 50926 "POI TariffNumber Import"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Warennummer"; Code[11])
        {
            Caption = 'Warennummer';
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[110])
        {
            DataClassification = CustomerContent;
            Caption = 'Text1';
        }
        field(4; Description2; Text[120])
        {
            DataClassification = CustomerContent;
            Caption = 'Text1';
        }
        field(5; Description3; Text[18])
        {
            DataClassification = CustomerContent;
            Caption = 'Text1';
        }
        field(6; "Unit Code"; Code[16])
        {
            Caption = 'Einheit';
            DataClassification = CustomerContent;
        }
        field(7; "Unit Code numeric"; Integer)
        {
            Caption = 'Einheit numerisch';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Warennummer")
        {
            Clustered = true;
        }
    }

    procedure ReadTariffNumbers(Filename: Text[250])
    var
        ImportFile: File;
        TextLine: Text[300];
    begin
        DeleteAll();
        ImportFile.TextMode(true);
        ImportFile.WRITEMODE(FALSE);
        ImportFile.OPEN(Filename, TextEncoding::Windows);
        while ImportFile.Read(TextLine) > 0 do
            ImportLine(TextLine);
        ImportFile.CLOSE();
    end;

    procedure ImportLine(Linetext: Text[300])
    var
        TariffImport: Record "POI TariffNumber Import";
        FeldArray: array[10] of Integer;
        Positon: Integer;
        ActValue: Text;
    begin
        FeldArray[1] := 10;
        FeldArray[2] := 110;
        FeldArray[3] := 120;
        FeldArray[4] := 18;
        FeldArray[5] := 16;
        FeldArray[6] := 2;

        TariffImport.Warennummer := copystr(copystr(Linetext, 1, FeldArray[1]), 1, MaxStrLen(TariffImport.Warennummer));
        Positon := FeldArray[1] + 1;
        TariffImport.Description := copystr(copystr(Linetext, Positon, FeldArray[2]), 1, MaxStrLen(TariffImport.Description));
        Positon += FeldArray[2];
        TariffImport.Description2 := copystr(copystr(Linetext, Positon, FeldArray[3]), 1, MaxStrLen(TariffImport.Description2));
        Positon += FeldArray[3];
        TariffImport.Description3 := copystr(copystr(Linetext, Positon, FeldArray[4]), 1, MaxStrLen(TariffImport.Description3));
        Positon += FeldArray[4];
        TariffImport."Unit Code" := copystr(copystr(Linetext, Positon, FeldArray[5]), 1, MaxStrLen(TariffImport."Unit Code"));
        Positon += FeldArray[5];
        ActValue := copystr(Linetext, Positon, FeldArray[6]);
        if ActValue <> '' then
            Evaluate(TariffImport."Unit Code numeric", ActValue);
        TariffImport.Insert();
    end;

    procedure CompareTariffdescription()
    var
        TariffNumberSova: Record "POI TariffNumber Import";
    begin
        TariffNumbers.Reset();
        TariffNumbers.ModifyAll("POI Data changed", TariffNumbers."POI Data changed"::" ");
        if TariffNumbers.FindSet() then
            repeat
                if TariffNumberSova.Get(TariffNumbers."No.") then begin
                    if (TariffNumbers.Description <> TariffNumberSova.Description) then begin
                        TariffNumbers."SOVA Description" := TariffNumberSova.Description;
                        TariffNumbers."POI Data changed" := TariffNumbers."POI Data changed"::Beschreibung;
                        TariffNumbers.Modify();
                    end;
                end else begin
                    TariffNumbers."POI Data changed" := TariffNumbers."POI Data changed"::"nicht vorhanden";
                    TariffNumbers.Modify();
                end;
            until TariffNumbers.next() = 0;
    end;

    procedure ItemsWithoutTariffNumber()
    var
        Item: Record Item;
        TariffNumber: Record "Tariff Number";
        NumberEmpty: Integer;
        NumberFalse: Integer;
    begin
        Item.Reset();
        if Item.FindSet() then
            repeat
                if Item."Tariff No." <> '' then begin
                    if not TariffNumber.Get(Item."Tariff No.") then
                        NumberFalse += 1;
                end else
                    NumberEmpty += 1;
            until Item.Next() = 0;
        Message('Leere Zollnr.: %1 / nicht vorhandene: %2', NumberEmpty, NumberFalse)

    end;

    var
        TariffNumbers: Record "Tariff Number";
}