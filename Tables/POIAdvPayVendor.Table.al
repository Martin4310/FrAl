table 50902 "POI Adv. Pay. Vendor"
{
    Caption = 'Adv. Pay. Vendor';
    // DrillDownFormID = Form5110467;
    // LookupFormID = Form5110467;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Adv. Payment,Realizing';
            OptionMembers = "Adv. Payment",Realizing;
        }
        field(11; "Doc. No. Adv. Payment"; Code[20])
        {
            Caption = 'Document No. Adv. Payment';
        }
        field(12; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(13; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(14; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(15; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
        }
        field(16; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(17; "Vendor Country Code"; Code[10])
        {
            Caption = 'Vendor Country Code';
        }
        field(18; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(20; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(21; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(24; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
        }
        field(25; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(26; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
        }
        field(27; "Remaining Amount (LCY)"; Decimal)
        {
            Caption = 'Remaining Amount (LCY)';
        }
        field(29; "Date of Adv. Payment"; Date)
        {
            Caption = 'Date of Adv. Payment';
        }
        field(30; "Origin Document No."; Code[20])
        {
            Caption = 'Origin Document No.';
        }
        field(31; "Origin External Document No."; Code[20])
        {
            Caption = 'Origin External Document No.';
        }
        field(33; "General Ledger Document No."; Code[20])
        {
            Caption = 'General Ledger Document No.';
        }
        field(35; "Vendor Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Caption = 'Vendor Name';
            Editable = false;

        }
        field(40; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(45; "Reference Entry No."; Integer)
        {
            Caption = 'Reference Entry No.';
        }
        field(47; "Closed On"; Date)
        {
            Caption = 'Closed On';
        }
        field(48; "Closed From Entry No."; Integer)
        {
            Caption = 'Closed From Entry No.';
        }
        field(50; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(51; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = "POI Batch"."No." WHERE("Vendor No." = FIELD("Vendor No."));

            trigger OnValidate()
            var
                lrc_Batch: Record "POI Batch";
            begin
                IF "Batch No." = '' THEN
                    "Master Batch No." := ''
                ELSE BEGIN
                    lrc_Batch.GET("Batch No.");
                    "Master Batch No." := lrc_Batch."Master Batch No.";
                END;
            end;
        }
        field(52; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            //???TableRelation = "Master Batch"."No." WHERE ("Vendor No."=FIELD("Vendor No."));
        }
        field(60; Canceled; Boolean)
        {
            Caption = 'Canceled';
        }
        field(61; "Canceled From"; Code[20])
        {
            Caption = 'Canceled From';
        }
        field(62; "Canceled On"; Date)
        {
            Caption = 'Canceled On';
        }
        field(63; "Canceled At"; Time)
        {
            Caption = 'Canceled At';
        }
        field(70; "Adv. Payment Type"; Option)
        {
            Caption = 'Adv. Payment Type';
            OptionCaption = ' ,Season';
            OptionMembers = " ",Season;

            trigger OnValidate()
            begin
                TESTFIELD(Type, Type::"Adv. Payment");
            end;
        }
        field(99; "Dissolving Currencycode"; Code[10])
        {
            Caption = 'Dissolving Currencycode';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                VALIDATE("Dissolving Amount");
            end;
        }
        field(100; "Dissolving Amount"; Decimal)
        {
            Caption = 'Dissolving Amount';

            trigger OnValidate()
            begin
                case "Dissolving Currencycode" of
                    '':
                        IF "Currency Code" = '' THEN BEGIN
                            "Dissolving Amount (LCY)" := "Dissolving Amount";
                            "Dissolving Amount (Currency)" := "Dissolving Amount";
                        END ELSE BEGIN
                            "Dissolving Amount (LCY)" := "Dissolving Amount";
                            "Dissolving Amount (Currency)" := ROUND("Dissolving Amount" * "Currency Factor", 0.01);
                        END;
                    "Currency Code":
                        BEGIN
                            "Dissolving Amount (LCY)" := ROUND("Dissolving Amount" / "Currency Factor", 0.01);
                            "Dissolving Amount (Currency)" := "Dissolving Amount";
                        end;
                    ELSE
                        ERROR('Währung nicht zulässig!');
                end;
            end;
        }
        field(101; "Dissolving Posting Date"; Date)
        {
            Caption = 'Dissolving Posting Date';
        }
        field(102; "Dissolving Ref. Led. Entry No."; Integer)
        {
            Caption = 'Dissolving Ref. Ledger Entry No.';
            TableRelation = "Vendor Ledger Entry" WHERE("Vendor No." = FIELD("Vendor No."),
                                                         "Document Type" = CONST(Invoice),
                                                         Open = CONST(true));

            trigger OnValidate()
            var
                lrc_VendLedgerEntry: Record "Vendor Ledger Entry";
            begin
                "Dissolving Ref. Invoice No." := '';
                IF lrc_VendLedgerEntry.GET("Dissolving Ref. Led. Entry No.") THEN
                    "Dissolving Ref. Invoice No." := lrc_VendLedgerEntry."Document No.";
            end;
        }
        field(103; "Dissolving Ref. Invoice No."; Code[20])
        {
            Caption = 'Dissolving Ref. Invoice No.';
            Editable = false;
        }
        field(104; "Dissolving Ref. Currency Code"; Code[10])
        {
            Caption = 'Dissolving Ref. Currency Code';
        }
        field(105; "Dissolving Ref. Remain. Amount"; Decimal)
        {
            Caption = 'Dissolving Ref. Remaining Amount';
            Editable = false;
        }
        field(106; "Dissolving Ref. Rem. Amt (LCY)"; Decimal)
        {
            Caption = 'Dissolving Ref. Remaining Amount (LCY)';
            Editable = false;
        }
        field(107; "Dissolving Amount (LCY)"; Decimal)
        {
            Caption = 'Dissolving Amount (LCY)';
        }
        field(108; "Dissolving Amount (Currency)"; Decimal)
        {
            Caption = 'Dissolving Amount (Currency)';
        }
        field(120; "Currency Code Posting Doc."; Code[10])
        {
            Caption = 'Currency Code Posting Doc.';
            TableRelation = Currency;
        }
        field(121; "Amount Posting Document"; Decimal)
        {
            Caption = 'Amount Posting Document';
        }
        field(122; "Currency Factor Posting Doc."; Decimal)
        {
            Caption = 'Currency Factor Posting Doc.';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
        }
        field(123; "Amount (LCY) Posting Document"; Decimal)
        {
            Caption = 'Amount (LCY) Posting Document';
        }
        field(150; "Splitting Amount"; Decimal)
        {
            Caption = 'Splitting Amount';

            trigger OnValidate()
            begin
                IF "Splitting Amount" > "Remaining Amount" THEN
                    ERROR('Splittbetrag darf Restbetrag nicht übersteigen');

                IF "Splitting Amount" <= 0 THEN BEGIN
                    "Splitting Amount" := 0;
                    "Splitting Amount (LCY)" := 0;
                END;

                // "Splittbetrag (MW)" := Splittbetrag / Währungsfaktor;
                GLSetup.Get();
                "Splitting Amount (LCY)" := ROUND("Splitting Amount" / "Currency Factor", GLSetup."Amount Rounding Precision");
            end;
        }
        field(151; "Splitting Amount (LCY)"; Decimal)
        {
            Caption = 'Splitting Amount (LCY)';

            trigger OnValidate()
            begin
                IF "Splitting Amount (LCY)" > "Remaining Amount (LCY)" THEN
                    ERROR('Splittbetrag (MW) darf Restbetrag (MW) nicht übersteigen!');

                IF "Splitting Amount (LCY)" <= 0 THEN BEGIN
                    "Splitting Amount (LCY)" := 0;
                    "Splitting Amount" := 0;
                END;

                // Splittbetrag := "Splittbetrag (MW)" * Währungsfaktor;
                GLSetup.Get();
                "Splitting Amount" := ROUND("Splitting Amount (LCY)" * "Currency Factor", GLSetup."Amount Rounding Precision");
            end;
        }
        field(152; "Splitt Batch No."; Code[20])
        {
            Caption = 'Splitt Batch No.';
            // TableRelation = "POI Batch"."No." WHERE("Vendor No." = FIELD("Vendor No."),
            //                                  Master Batch No.=FIELD(Splitt Master Batch No.));

            trigger OnValidate()
            var
                lrc_Batch: Record "POI Batch";
            begin
                IF lrc_Batch.GET("Splitt Batch No.") THEN
                    "Splitt Master Batch No." := lrc_Batch."Master Batch No."
                ELSE BEGIN
                    "Splitt Batch No." := '';
                    "Splitt Master Batch No." := '';
                END;
            end;
        }
        field(153; "Splitt Master Batch No."; Code[20])
        {
            Caption = 'Splitt Master Batch No.';
            ///???TableRelation = "Master Batch"."No." WHERE ("Vendor No."=FIELD("Vendor No."));
        }
        field(155; "Splitted from Entry No."; Integer)
        {
            Caption = 'Splitted from Entry No.';
        }
        field(160; "New Vendor No."; Code[20])
        {
            Caption = 'New Vendor No.';
            TableRelation = Vendor;
        }
        field(161; "Vendor was Changed"; Boolean)
        {
            Caption = 'Vendor was Changed';
        }
        field(170; "Belegsplittung der Kopf Nr."; Code[20])
        {
            // TableRelation = "Adv. Pay. Header".No. WHERE (Adv. Pay. to Vendor No.=FIELD(Vendor No.),
            //                                               Confirmed=CONST(Yes),
            //                                               Currency Code=FIELD(Currency Code));
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            SumIndexFields = Amount, "Remaining Amount", "Amount (LCY)", "Remaining Amount (LCY)";
        }
        key(Key2; Type, "Vendor No.")
        {
            SumIndexFields = Amount, "Remaining Amount", "Amount (LCY)", "Remaining Amount (LCY)";
        }
        key(Key3; Type, "G/L Account No.")
        {
            SumIndexFields = Amount, "Remaining Amount", "Amount (LCY)", "Remaining Amount (LCY)";
        }
        key(Key4; "Vendor No.", "Posting Date")
        {
            SumIndexFields = "Remaining Amount (LCY)";
        }
        key(Key5; Type, "Adv. Payment Type", "Vendor No.", "Currency Code", Open)
        {
        }
        key(Key6; "Posting Date")
        {
        }
        key(Key7; "Currency Code")
        {
        }
        key(Key8; Open)
        {
        }
        key(Key9; "G/L Account No.", "Vendor No.", "Posting Date")
        {
            SumIndexFields = Amount, "Remaining Amount", "Amount (LCY)", "Remaining Amount (LCY)";
        }
        key(Key10; "Vendor No.", "Master Batch No.")
        {
            SumIndexFields = Amount, "Remaining Amount", "Amount (LCY)", "Remaining Amount (LCY)";
        }
    }


    trigger OnInsert()
    var
        lrc_SSPKreditorAnzahlungen: Record "POI Adv. Pay. Vendor";
    begin
        IF "Entry No." <= 0 THEN
            IF lrc_SSPKreditorAnzahlungen.FIND('+') THEN
                "Entry No." := lrc_SSPKreditorAnzahlungen."Entry No." + 1
            ELSE
                "Entry No." := 1;
    end;

    var
        GLSetup: Record "General Ledger Setup";
}

