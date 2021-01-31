table 50938 "POI Certification Chapter"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;
    fields
    {
        field(1; "Certification No."; Code[20])
        {
            Caption = 'Certification No.';
            DataClassification = CustomerContent;
        }
        field(2; "Certificate Chapter No."; Code[10])
        {
            Caption = 'Kapitelnr.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckChapterNo();
            end;

        }
        field(3; "Chapter Description"; Text[100])
        {
            Caption = 'Beschreibung';
            DataClassification = CustomerContent;
        }
        field(4; Activ; Boolean)
        {
            Caption = 'Aktiv';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Certification No.", "Certificate Chapter No.")
        {
            Clustered = true;
        }
    }
    procedure CheckChapterNo()
    var
        i: Integer;
    begin
        for i := 1 to StrLen("Certificate Chapter No.") do
            if not ("Certification No." IN ['.', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0']) then
                Error('Nur Zahlen und Punkt erlaubt.');
    end;

}