codeunit 50017 "POI Data Conversion"
{
    procedure distributeContacts()
    var
        BasicCompany: Code[50];
        ContactExist: Boolean;
    begin
        BasicCompany := POICompany.GetBasicCompany();
        Contact.ChangeCompany(BasicCompany);
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        POICompany.SetRange("Basic Company", false);
        if POICompany.FindSet() then
            repeat
                ContactComp.ChangeCompany(POICompany.Mandant);
                ContactCheck.ChangeCompany(POICompany.Mandant);
                Contact.Reset();
                Contact.setrange(Type, Contact.Type::Company);
                if Contact.FindSet() then
                    repeat
                        ContactComp := Contact;
                        if ContactCheck.Get(Contact."No.") then
                            ContactExist := true
                        else
                            ContactExist := false;
                        if not ContactExist then
                            ContactComp.Insert();
                    until Contact.Next() = 0;
            until POICompany.Next() = 0;
    end;

    procedure setAccountSettingForAllContacts()
    var
        Accountsetting: Record "POI Account Company Setting";
        FilterString: code[20];
    begin
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        if POICompany.FindSet() then
            repeat
                if FilterString = '' then
                    FilterString := POICompany."Company System ID"
                else
                    FilterString := copystr(Filterstring + '|' + POICompany."Company System ID", 1, MaxStrLen(FilterString));
            until POICompany.Next() = 0;
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        if POICompany.FindSet() then
            repeat
                Contact.Reset();
                Contact.ChangeCompany(POICompany.Mandant);
                if Contact.FindSet() then
                    repeat
                        Contact."POI Company System Filter" := FilterString;
                        Contact.Modify();
                        Accountsetting."Account No." := Contact."No.";
                        Accountsetting."Account Type" := Accountsetting."Account Type"::Contact;
                        Accountsetting."Company Name" := POICompany.Mandant;
                        Accountsetting.Released := true;
                        if not Accountsetting.Get(Accountsetting."Account Type"::Contact, Contact."No.", POICompany.Mandant) then
                            Accountsetting.Insert();
                    until Contact.Next() = 0;
            until POICompany.Next() = 0;
    end;

    procedure CopyContactbusrelation()
    var
        BasicCompany: Code[50];
    begin
        BasicCompany := POICompany.GetBasicCompany();
        ContBusRel.ChangeCompany(BasicCompany);
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        POICompany.SetRange("Basic Company", false);
        if POICompany.FindSet() then
            repeat
                ContBusRelComp.ChangeCompany(POICompany.Mandant);
                ContBusRel.Reset();
                if ContBusRel.FindSet() then
                    repeat
                        if not ContBusRelComp.Get(ContBusRel."Contact No.", ContBusRel."Business Relation Code") then begin
                            ContBusRelComp := ContBusRel;
                            ContBusRelComp.Insert();
                        end;
                    until ContBusRel.Next() = 0;
            until POICompany.Next() = 0;
    end;

    var
        Contact: Record Contact;
        ContactComp: Record Contact;
        ContactCheck: Record Contact;
        POICompany: Record "POI Company";
        ContBusRel: Record "Contact Business Relation";
        ContBusRelComp: Record "Contact Business Relation";
}