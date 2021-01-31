table 5087978 "POI Incoming Invoice Ledger"
{
    Caption = 'Incoming Invoice Ledger';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; "Internal Entry No."; Code[20])
        {
            Caption = 'Internal Entry No.';
        }
        field(11; "Date of Receipt"; Date)
        {
            Caption = 'Date of Receipt';
        }
        field(12; "Entry Date"; Date)
        {
            Caption = 'Entry Date';
        }
        field(13; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Invoice,Credit Memo';
            OptionMembers = " ",Invoice,"Credit Memo";
        }
        field(20; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                lrc_Vendor: Record Vendor;
            begin

                "Vendor Name" := '';
                "Vendor Name 2" := '';
                "Vendor Address" := '';
                "Vendor Address 2" := '';
                "Vendor Country Code" := '';
                "Vendor Post Code" := '';
                "Vendor City" := '';
                "Purchaser Code" := '';
                IF lrc_Vendor.GET("Vendor No.") THEN BEGIN
                    "Vendor Name" := lrc_Vendor.Name;
                    "Vendor Name 2" := lrc_Vendor."Name 2";
                    "Vendor Address" := lrc_Vendor.Address;
                    "Vendor Address 2" := lrc_Vendor."Address 2";
                    "Vendor Country Code" := lrc_Vendor."Country/Region Code";
                    "Vendor Post Code" := lrc_Vendor."Post Code";
                    "Vendor City" := lrc_Vendor.City;
                    "Purchaser Code" := lrc_Vendor."Purchaser Code";
                END;
            end;
        }
        field(21; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(22; "Vendor Name 2"; Text[50])
        {
            Caption = 'Vendor Name 2';
        }
        field(23; "Vendor Country Code"; Code[10])
        {
            Caption = 'Vendor Country Code';
        }
        field(24; "Vendor Post Code"; Code[20])
        {
            Caption = 'Vendor Post Code';
        }
        field(25; "Vendor City"; Text[30])
        {
            Caption = 'Vendor City';
        }
        field(26; "Vendor Address"; Text[100])
        {
            Caption = 'Vendor Address';
        }
        field(27; "Vendor Address 2"; Text[50])
        {
            Caption = 'Vendor Address 2';
        }
        field(30; "Vendor Invoice No."; Code[20])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(31; "Vendor Invoice Posting Date"; Date)
        {
            Caption = 'Vendor Invoice Posting Date';
        }
        field(40; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(41; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(42; Amount; Decimal)
        {
            Caption = 'Betrag';

            trigger OnValidate()
            begin
                IF Amount > 0 THEN
                    "Document Type" := "Document Type"::Invoice
                ELSE
                    IF Amount < 0 THEN
                        "Document Type" := "Document Type"::"Credit Memo"
                    ELSE
                        "Document Type" := "Document Type"::" ";

                IF "Currency Code" = '' THEN
                    "Currency Factor" := 1;
                "Amount (LCY)" := Amount * "Currency Factor";
            end;
        }
        field(43; "Amount (LCY)"; Decimal)
        {
            Caption = 'Betrag (MW)';
            Editable = false;
        }
        field(70; "Transfer Responsibility Center"; Code[10])
        {
            Caption = 'Transfer Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(71; "Transfer Person in Charge"; Code[20])
        {
            Caption = 'Transfer Person in Charge';
            TableRelation = "Salesperson/Purchaser" WHERE("POI Is Person in Charge" = CONST(true));
        }
        field(72; "Purchaser Code"; Code[20])
        {
            Caption = 'Einkäufer/in';
            TableRelation = "Salesperson/Purchaser" WHERE("POI Is Purchaser" = CONST(true));
        }
        field(75; "Check Comment"; Text[80])
        {
            Caption = 'Check Comment';
        }
        field(77; "Checked by User ID"; Code[20])
        {
            Caption = 'Checked by User ID';
            TableRelation = "User Setup";
        }
        field(78; "Check Ready at Date - Time"; DateTime)
        {
            Caption = 'Check Ready at Date - Time';
        }
        field(80; "Purch. Doc. Type"; Option)
        {
            Caption = 'Purch. Doc. Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(81; "Purch. Doc. No."; Code[20])
        {
            Caption = 'Purch. Doc. No.';
        }
        field(82; "Purch. Doc. Date Time"; DateTime)
        {
            Caption = 'Purch. Doc. Date Time';
        }
        field(83; "Purch. Posted Doc. No."; Code[20])
        {
            Caption = 'Purch. Posted Doc. No.';
        }
        field(99; State; Option)
        {
            Caption = 'State';
            OptionCaption = 'Erfasst,,,,,Freigabe zur Prüfung,,,,,Abwarten,,,,,Abgelehnt,,,,,,Freigegeben,,,,,Gebucht,,,,,Ungebucht erledigt,Gelöscht';
            OptionMembers = Erfasst,,,,,"Freigabe zur Prüfung",,,,,Abwarten,,,,,Abgelehnt,,,,,,Freigegeben,,,,,Gebucht,,,,,"Ungebucht erledigt","Gelöscht";
        }
        field(100; "Last State Change by"; Code[50])
        {
            Caption = 'Last State Change by';
        }
        field(101; "Last State Change Date"; Date)
        {
            Caption = 'Last State Change Date';
        }
        field(102; "Last State Change Time"; Time)
        {
            Caption = 'Last State Change Time';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    trigger OnInsert()
    var

        lrc_PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        lcu_NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        // Vergabe der Nummer aus Nummernserie
        lrc_PurchasesPayablesSetup.GET();
        IF "No." = '' THEN BEGIN
            lrc_PurchasesPayablesSetup.TESTFIELD("POI Inv. Ledger Entry Nos.");
            "No." := lcu_NoSeriesMgt.GetNextNo(lrc_PurchasesPayablesSetup."POI Inv. Ledger Entry Nos.", WORKDATE(), TRUE);
        END;

        CASE lrc_PurchasesPayablesSetup."POI Inv. Ledger Int. Entry No." OF
            lrc_PurchasesPayablesSetup."POI Inv. Ledger Int. Entry No."::"Internal Entry No. equal No.Series":
                "Internal Entry No." := "No.";
        END;

        "Currency Factor" := 1;
        "Entry Date" := TODAY();
        "Date of Receipt" := TODAY();
    end;

    trigger OnModify()
    begin
        IF State > State::Erfasst THEN BEGIN
            TESTFIELD("Vendor Invoice No.");
            TESTFIELD("Vendor Invoice Posting Date");
            TESTFIELD(Amount);
            TESTFIELD("Date of Receipt");
            TESTFIELD("Transfer Responsibility Center");
        END;
    end;

    trigger OnRename()
    begin
        ERROR(POI_TEXT001Txt);
    end;

    var
        POI_TEXT001Txt: Label 'Rename not allowed!';
}

