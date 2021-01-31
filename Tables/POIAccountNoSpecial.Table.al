table 50915 "POI Account No. Special"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Account No."; code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(50915, 1, 2) then
                    ERROR(ERR_NoPermissionTxt);
            end;
        }
        field(2; AccountType; Option)
        {
            OptionMembers = Contact,Customer,Vendor;
            OptionCaption = 'Contact,Customer,Vendor';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(50915, 2, 2) then
                    ERROR(ERR_NoPermissionTxt);
            end;
        }
        field(3; "Special No. Type"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "POI Special Nos Type"."Special Code" where("Special Type" = const('VENDORNOS'));
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(50915, 3, 2) then
                    ERROR(ERR_NoPermissionTxt);
            end;
        }
        field(4; "Special No. Code"; Text[30])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(50915, 4, 2) then
                    ERROR(ERR_NoPermissionTxt);
            end;
        }
    }

    keys
    {
        key(PK; "Account No.", AccountType, "Special No. Type")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        SynchLineOnDelete();
    end;

    trigger OnModify()
    begin
        SynchLineOnInsert();
    end;

    trigger OnInsert()
    begin
        SynchLineOnInsert();
    end;

    procedure SetAccountSpecialNos()
    var
        SpecialText: Text[100];
    begin
        if AccountSpecialNos.FindSet() then
            repeat
                AccountSpecialNos2.SetRange("Account No.", AccountSpecialNos."Account No.");
                AccountSpecialNos2.SetRange(AccountType, AccountSpecialNos.AccountType);
                if AccountSpecialNos2.FindFirst() then
                    case AccountSpecialNos2.AccountType of
                        AccountSpecialNos2.AccountType::Vendor:
                            begin
                                Vendor.Get(AccountSpecialNos2."Account No.");
                                SpecialText := '';
                                AccountSpecialNos2.Reset();
                                AccountSpecialNos2.SetRange("Account No.", Vendor."No.");
                                AccountSpecialNos2.SetRange(AccountType, AccountSpecialNos2.AccountType::Vendor);
                                if AccountSpecialNos2.FindSet() then
                                    repeat
                                        if (strlen(SpecialText) + StrLen(Format(AccountSpecialNos2."Special No. Type") + ':' + AccountSpecialNos2."Special No. Code")) <= (MaxStrLen(SpecialText) - 3) then begin
                                            if SpecialText <> '' then
                                                SpecialText += ' | ';
                                            SpecialText += Format(AccountSpecialNos2."Special No. Type") + ':' + AccountSpecialNos2."Special No. Code";
                                        end;
                                    until AccountSpecialNos2.Next() = 0;
                                Vendor.Validate("POI Special Vendor Nos.", SpecialText);
                                Vendor.Modify();
                                if Vendor."POI Is Customer" <> '' then begin
                                    Customer.Get(Vendor."POI Is Customer");
                                    Customer."POI Special Cust. Nos." := Vendor."POI Special Vendor Nos.";
                                    Customer.Modify();
                                end;
                                AccountSpecialNos := AccountSpecialNos2;
                            end;
                        AccountSpecialNos.AccountType::Customer:
                            begin
                                Customer.Get(AccountSpecialNos2."Account No.");
                                SpecialText := '';
                                AccountSpecialNos2.Reset();
                                AccountSpecialNos2.SetRange("Account No.", Customer."No.");
                                AccountSpecialNos2.SetRange(AccountType, AccountSpecialNos2.AccountType::Customer);
                                if AccountSpecialNos2.FindSet() then
                                    repeat
                                        if strlen(SpecialText) + StrLen(Format(AccountSpecialNos2."Special No. Type") + ':' + AccountSpecialNos2."Special No. Code") <= (MaxStrLen(SpecialText) - 3) then begin
                                            if SpecialText <> '' then
                                                SpecialText += ' | ';
                                            SpecialText += Format(AccountSpecialNos2."Special No. Type") + ':' + AccountSpecialNos2."Special No. Code";
                                        end;
                                    until AccountSpecialNos2.Next() = 0;
                                Customer.validate("POI Special Cust. Nos.", SpecialText);
                                Customer.Modify();
                                if Customer."POI Is Vendor" <> '' then begin
                                    Vendor.Get(Customer."POI Is Vendor");
                                    Vendor."POI Special Vendor Nos." := Customer."POI Special Cust. Nos.";
                                    Vendor.Modify();
                                end;
                                AccountSpecialNos := AccountSpecialNos2;
                            end;
                    end;
            until AccountSpecialNos.Next() = 0;
    end;

    procedure SynchLineOnInsert()
    var
        AccountNo: Code[20];
        AccounType1: Option Contact,Customer,Vendor;
    begin
        case AccountType of
            AccountType::Customer:
                begin
                    Customer.Get("Account No.");
                    AccountNo := Customer."POI Is Vendor";
                    AccounType1 := AccounType1::Vendor;
                end;
            AccountType::Vendor:
                begin
                    Vendor.Get("Account No.");
                    AccountNo := Vendor."POI Is Customer";
                    AccounType1 := AccounType1::Customer;
                end;
        end;
        if AccountSpecialNos.Get(AccountNo, 1, "Special No. Type") then begin
            AccountSpecialNos."Special No. Code" := "Special No. Code";
            AccountSpecialNos.AccountType := AccounType1;
            AccountSpecialNos.Modify();
        end else begin
            AccountSpecialNos := Rec;
            AccountSpecialNos."Account No." := AccountNo;
            AccountSpecialNos.AccountType := AccounType1;
            AccountSpecialNos.Insert();
        end;
    end;

    procedure SynchLineOnDelete()
    var
        AccountNo: Code[20];
        AccounType1: Option Contact,Customer,Vendor;
    begin
        case AccountType of
            AccountType::Customer:
                begin
                    Customer.Get("Account No.");
                    AccountNo := Customer."POI Is Vendor";
                    AccounType1 := AccounType1::Vendor;
                end;
            AccountType::Vendor:
                begin
                    Vendor.Get("Account No.");
                    AccountNo := Vendor."POI Is Customer";
                    AccounType1 := AccounType1::Customer;
                end;
        end;
        if AccountSpecialNos.Get(AccountNo, 1, "Special No. Type") then
            AccountSpecialNos.Delete();
    end;

    var
        AccountSpecialNos2: Record "POI Account No. Special";
        Customer: Record Customer;
        Vendor: Record Vendor;
        AccountSpecialNos: Record "POI Account No. Special";
        POIFunction: Codeunit POIFunction;
        ERR_NoPermissionTxt: Label 'Keine Berechtigung für Änderungen';
}