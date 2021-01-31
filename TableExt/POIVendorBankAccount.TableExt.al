tableextension 50056 "POI Vendor BankAccount" extends "Vendor Bank Account"
{
    fields
    {
        field(50000; "POI Verifikationsanruf"; Option)
        {
            Caption = 'Verifikationsanruf';
            DataClassification = CustomerContent;
            OptionCaption = 'nicht erfolgt,erfolgt,verzichtet,Reaktivierung';
            OptionMembers = "nicht erfolgt",erfolgt,verzichtet,Reaktivierung;
        }
        Field(50001; "POI BankAccountChecked"; Boolean)
        {
            Caption = 'Bankkonto überprüft';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "POI BankAccountChecked" then begin
                    "POI AccCheckUser" := CopyStr(UserId, 1, 50);
                    "POI AccCheck DateTime" := CreateDateTime(Today(), Time());
                end;
            end;
        }
        field(50002; "POI Verifikationsanruf Name"; Text[100])
        {
            Caption = 'Verifikationsanruf Name';
            DataClassification = CustomerContent;
        }
        field(50003; "POI Verifikat. Anruf Tel. Nr."; Text[50])
        {
            Caption = 'Verifikationsanruf Tel. Nr.';
            DataClassification = CustomerContent;
        }
        field(50004; "POI Verifikationsanruf User"; Code[50])
        {
            Caption = 'Verifikationsanruf Benutzer';
            DataClassification = CustomerContent;
        }
        field(50005; "POI VerifikatsanrufDatZeit"; DateTime)
        {
            Caption = 'Verifikationsanruf Datum Uhrzeit';
            DataClassification = CustomerContent;
        }
        field(50006; "POI AccCheckUser"; Code[50])
        {
            Caption = 'geprüft von';
            DataClassification = CustomerContent;
            Editable = False;
        }
        field(50007; "POI AccCheck DateTime"; DateTime)
        {
            Caption = 'Prüfdatum Uhrzeit';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(50008; "POI Verianruf Quelle Tel."; Text[50])
        {
            Caption = 'Verifikationsanruf Quelle Tel.';
            DataClassification = CustomerContent;
        }
    }

}