table 50954 "POI Account Refunds"
{
    DataClassification = CustomerContent;
    Caption = 'Rückvergütungen';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = if ("Source Type" = const(Vendor)) Vendor."No."
            else
            if ("Source Type" = const(Customer)) Customer."No.";
        }
        field(2; "Source Type"; enum "POI Source Type")
        {
            Caption = 'Herkunftsart';
        }
        field(3; "Refund Source Type"; enum "POI Refund Types")
        {
            Caption = 'Rabatttyp';
        }
        Field(4; Periode; DateFormula)
        {
            Caption = 'Periode';
        }
        field(5; Percentage; Decimal)
        {
            Caption = 'Prozentsatz';
        }
    }

    keys
    {
        key(PK; "No.", "Source Type", "Refund Source Type")
        {
            Clustered = true;
        }
    }

    procedure GetRefundsToText(AccountNo: Code[20]; AccountType: enum "POI Source Type")

    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        OutText: Text[100];
    begin
        Clear(OutText);
        Reset();
        SetRange("Source Type", AccountType);
        SetRange("No.", AccountNo);
        if FindSet() then
            repeat
                if OutText <> '' then
                    OutText += ';';
                if StrLen(Outtext + Format("Refund Source Type") + '/' + Format(Percentage)) <= MaxStrLen(OutText) then
                    Outtext += Format("Refund Source Type") + '/' + Format(Percentage);
            until Next() = 0;
        case AccountType of
            AccountType::Vendor:
                Begin
                    Vendor.get(AccountNo);
                    Vendor."POI RefundSet" := OutText;
                    Vendor.Modify();
                End;
            AccountType::Customer:
                begin
                    Customer.get(AccountNo);
                    Customer.Modify();
                end;
        end;

    end;

}