table 50946 "POI Mail Setup"
{
    DrillDownPageId = "POI Mail Setup";
    LookupPageId = "POI Mail Setup";
    DataClassification = CustomerContent;

    fields
    {
        field(1; Type; option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Sender,Empfänger';
            OptionMembers = Sender,Receipient;
        }
        field(2; "Department Code"; Code[20])
        {
            Caption = 'Bereichscode';
            DataClassification = CustomerContent;
        }
        field(3; "Type Code"; Code[20])
        {
            Caption = 'Typcode';
            DataClassification = CustomerContent;
        }
        field(5; "E-Mail"; Text[100])
        {
            Caption = 'E-Mail';
            DataClassification = CustomerContent;
        }
        field(6; Description; Text[100])
        {
            Caption = 'Beschreibung';
            DataClassification = CustomerContent;
        }
        field(7; Source; enum "POI E-Mail Source")
        {
            Caption = 'E-Mail Herkunft';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Type", "Department Code", "Type Code", "E-Mail")
        {
            Clustered = true;
        }
    }

    procedure GetMailSenderReceiver(DepartmentCode: code[20]; TypeCode: code[20]; var lSender: Text[100]; var lReceipients: list of [text]; Mandant: Code[50])
    begin
        clear(lReceipients);
        Clear(lSender);
        MailSetup.ChangeCompany(Mandant);
        MailSetup.Reset();
        MailSetup.SetRange("Department Code", DepartmentCode);
        MailSetup.SetRange("Type Code", TypeCode);
        MailSetup.SetRange(Type, MailSetup.Type::Receipient);
        if MailSetup.FindSet() then
            repeat
                lReceipients.Add(MailSetup."E-Mail");
            until MailSetup.Next() = 0;
        MailSetup.SetRange(Type, MailSetup.Type::Sender);
        if MailSetup.FindFirst() then
            lSender := MailSetup."E-Mail";
    end;

    var
        MailSetup: Record "POI Mail Setup";


}