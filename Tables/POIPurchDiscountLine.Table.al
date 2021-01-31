table 5110382 "POI Purch. Discount Line"
{
    Caption = 'Purch. Discount Line';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'No.';
        }
        field(4; "Purch. Disc. Entry No."; Integer)
        {
            Caption = 'Purch. Disc. Entry No.';
        }
        field(5; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(10; "Discount Code"; Code[10])
        {
            Caption = 'Discount Code';
            TableRelation = "POI Discount";
        }
        field(12; "Discount Type"; Option)
        {
            Caption = 'Discount Type';
            OptionCaption = 'Warenrechnungsrabatt,Rechnungsrabatt,Artikelrabatt';
            OptionMembers = Warenrechnungsrabatt,Rechnungsrabatt,Artikelrabatt;
        }
        field(14; "Base Discount Value"; Option)
        {
            Caption = 'Base Discount Value';
            OptionCaption = 'Prozentsatz,Absoluter Betrag auf Zeilenbasis,Betrag Pro Kolli,Kolloeinheit,Proz. auf Einheit gerundet,Betrag Pro Frachteinheit,Betrag pro Kilo,Gew.-Abhängiger Betrag';
            OptionMembers = Prozentsatz,"Absoluter Betrag auf Zeilenbasis","Betrag Pro Kolli",Kolloeinheit,"Proz. auf Einheit gerundet","Betrag Pro Frachteinheit","Betrag pro Kilo","Gew.-Abhängiger Betrag";
        }
        field(15; "Discount Value"; Decimal)
        {
            Caption = 'Discount Value';
        }
        field(18; "Basis %-Satz inkl. Ums.-St."; Boolean)
        {
            Caption = 'Basis %-Satz inkl. Ums.-St.';
        }
        field(20; "Payment Timing"; Option)
        {
            Caption = 'Payment Timing';
            OptionCaption = 'Invoice,Month,Quarter,Half Year,Year,Rückstellung,Separate Credit Memo';
            OptionMembers = Invoice,Month,Quarter,"Half Year",Year,"Rückstellung","Separate Credit Memo";
        }
        field(21; "Calculation Level"; Integer)
        {
            Caption = 'Calculation Level';
            InitValue = 1;
            MaxValue = 9;
            MinValue = 1;
        }
        field(22; "Discount Source"; Option)
        {
            Caption = 'Discount Source';
            Description = 'Extern,,,,Intern';
            OptionCaption = 'Extern,,,,,,,,,,,Intern';
            OptionMembers = Extern,,,,,,,,,,,Intern;
        }
        field(25; "Discount Depend on Weight"; Boolean)
        {
            Caption = 'Discount Depend on Weight';
        }
        field(26; "Ref. Disc. Depend on Weight"; Option)
        {
            Caption = 'Ref. Disc. Depend on Weight';
            OptionCaption = ' ,Net Weight Collo,Gross Weight Collo';
            OptionMembers = " ","Net Weight Collo","Gross Weight Collo";
        }
        field(28; "Discount not on Customer Duty"; Boolean)
        {
            Caption = 'Discount not on Customer Duty';
        }
        field(30; "Disc. Amount"; Decimal)
        {
            Caption = 'Discount Amount';
            Editable = false;
        }
        field(31; "Disc. Amount to Invoice"; Decimal)
        {
            Caption = 'Disc. Amount to Invoice';
            Editable = false;
        }
        field(32; "Disc. Amount to Ship"; Decimal)
        {
            Caption = 'Disc. Amount to Ship';
        }
        field(40; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(41; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
        }
        field(42; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(43; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            NotBlank = true;
            TableRelation = "Gen. Product Posting Group";
        }
        field(45; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
        }
        field(50; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(51; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(52; "Disc. Amount (LCY)"; Decimal)
        {
            Caption = 'Disc. Amount (LCY)';
            Editable = false;
        }
        field(53; "Disc. Amount to Invoice (LCY)"; Decimal)
        {
            Caption = 'Disc. Amount to Invoice (LCY)';
            Editable = false;
        }
        field(54; "Disc. Amount to Ship (LCY)"; Decimal)
        {
            Caption = 'Disc. Amount to Ship (LCY)';
        }
        field(58; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            TableRelation = Vendor;
        }
        field(59; "Document Posting Date"; Date)
        {
            Caption = 'Document Posting Date';
        }
        field(65; "Eingrenzung Frachteinheit"; Code[10])
        {
            Caption = 'Eingrenzung Frachteinheit';
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));
        }
        field(68; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(71; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;
        }
        field(72; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(130; "Base Disc. Amount"; Decimal)
        {
            Caption = 'Base Discount Amount';
            Editable = false;
        }
        field(131; "Base Disc. Amount to Invoice"; Decimal)
        {
            Caption = 'Base Disc. Amount to Invoice';
            Editable = false;
        }
        field(132; "Base Disc. Amount to Ship"; Decimal)
        {
            Caption = 'Base Disc. Amount to Ship';
        }
        field(152; "Base Disc. Amount (LCY)"; Decimal)
        {
            Caption = 'Base Disc. Amount (LCY)';
            Editable = false;
        }
        field(153; "Base Disc. Amount to Inv (LCY)"; Decimal)
        {
            Caption = 'Base Disc. Amount to Invoice (LCY)';
            Editable = false;
        }
        field(154; "Base Disc. Amount to Shi (LCY)"; Decimal)
        {
            Caption = 'Base Disc. Amount to Ship (LCY)';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Purch. Disc. Entry No.", "Document Line No.")
        {
        }
    }
}

