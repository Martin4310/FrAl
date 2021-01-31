table 5110385 "POI Vendor Discount"
{
    Caption = 'Vendor Discount';
    // DrillDownFormID = Form5110385;
    // LookupFormID = Form5110385;

    fields
    {
        field(1; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = 'Vendor,Vendor Group,Vendor Main Group,Vendor Hierarchy';
            OptionMembers = Vendor,"Vendor Group","Vendor Main Group","Vendor Hierarchy";
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST(Vendor)) Vendor
            ELSE
            IF (Source = CONST("Vendor Group")) "POI Vendor Group"
            ELSE
            IF (Source = CONST("Vendor Main Group")) "POI Vendor Main Group"
            ELSE
            IF (Source = CONST("Vendor Hierarchy")) "POI Vend. Mult Level Hierarchy";
        }
        field(3; "Order Address Code"; Code[10])
        {
            Caption = 'Ship-to Address Code';
            TableRelation = "Order Address".Code WHERE("Vendor No." = FIELD("Source No."));
        }
        field(4; "Calculation Level"; Integer)
        {
            Caption = 'Calculation Level';
            MaxValue = 9;
            MinValue = 1;

            trigger OnValidate()
            begin
                IF "Calculation Level" < 1 THEN
                    ERROR('Berechnungsreihenfolge beginnt mit 1!');
            end;
        }
        field(5; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "Valid from Date"; Date)
        {
            Caption = 'Valid from Date';
        }
        field(11; "Valid to Date"; Date)
        {
            Caption = 'Valid to Date';
        }
        field(16; "Discount Code"; Code[10])
        {
            Caption = 'Discount Code';
            NotBlank = true;
            TableRelation = "POI Discount";

            trigger OnValidate()
            var
                lrc_Discount: Record "POI Discount";
            begin
                IF "Discount Code" <> '' THEN BEGIN
                    lrc_Discount.GET("Discount Code");
                    "Discount Type" := lrc_Discount."Discount Type";
                    "Payment Timing" := lrc_Discount."Payment Timing";
                    "Base Discount Value" := "Base Discount Value"::Prozentsatz;
                    "Discount Value" := 0;
                    "Basis %-Satz inkl. Ums.-St." := FALSE;
                    "Currency Code" := '';
                END;
            end;
        }
        field(17; "Discount Type"; Option)
        {
            Caption = 'Type of Discount';
            Description = 'Warenrechnungsrabatt,Rechnungsrabatt';
            OptionCaption = 'Warenrechnungsrabatt,Rechnungsrabatt,Artikelrabatt';
            OptionMembers = Warenrechnungsrabatt,Rechnungsrabatt,Artikelrabatt;
        }
        field(18; "Base Discount Value"; Option)
        {
            Caption = 'Type of Discount Value';
            Description = 'Prozentsatz,Absoluter Betrag,Betrag Pro Kolli,Kolloeinheit,Proz. auf Einheit gerundet,Betrag Pro Frachteinheit,Betrag pro Kilo';
            OptionCaption = 'Prozentsatz,Absoluter Betrag auf Zeilenbasis,Betrag Pro Kolli,Kolloeinheit,Proz. auf Einheit gerundet,Betrag Pro Frachteinheit,Betrag pro Kilo,Gew.-Abhängiger Betrag';
            OptionMembers = Prozentsatz,"Absoluter Betrag auf Zeilenbasis","Betrag Pro Kolli",Kolloeinheit,"Proz. auf Einheit gerundet","Betrag Pro Frachteinheit","Betrag pro Kilo","Gew.-Abhängiger Betrag","Betrag pro Transporteinheit";
        }
        field(19; "Discount Value"; Decimal)
        {
            Caption = 'Discount Value';
        }
        field(20; "Basis %-Satz inkl. Ums.-St."; Boolean)
        {
            Caption = 'Basis %-Satz inkl. Ums.-St.';
        }
        field(22; "Payment Timing"; Option)
        {
            Caption = 'Payment Timing';
            Description = 'Rechnung,Monat,Quartal,Halbjahr,Jahr,Rückstellung,Separate Gutschrift,Zahlung';
            OptionCaption = 'Invoice,Month,Quarter,Half Year,Year,Rückstellung,Separate Credit Memo';
            OptionMembers = Invoice,Month,Quarter,"Half Year",Year,"Rückstellung","Separate Credit Memo";
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
        field(50; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(60; "Restrict. Freight Unit"; Code[10])
        {
            Caption = 'Restrict. Freight Unit';
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));
        }
        field(61; "Restrict. Transport Unit"; Code[10])
        {
            Caption = 'Restrict. Transport Unit';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));
        }
        field(62; "Not Valid for"; Option)
        {
            Caption = 'Not Valid for';
            OptionCaption = ' ,Item Category,Product Group,Item No.,Trademark';
            OptionMembers = " ","Item Category","Product Group","Item No.",Trademark;
        }
        field(63; "Not Valid for Filter"; Code[80])
        {
            Caption = 'Not Valid for Filter';
        }
        field(68; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(70; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
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
        field(75; "Add Discount to Unit Cost"; Boolean)
        {
            Caption = 'Add Discount to Unit Cost';
        }
        field(100; Comment; Text[30])
        {
            Caption = 'Comment';
        }
        field(101; "Last User Modified"; Code[50])
        {
            Caption = 'Last User Modified';
            Editable = false;
        }
        field(102; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; Source, "Source No.", "Order Address Code", "Calculation Level", "Entry No.")
        {
        }
    }

    trigger OnInsert()
    begin
        IF "Entry No." = 0 THEN BEGIN
            lrc_VendorDiscount.SETRANGE("Source No.", "Source No.");
            lrc_VendorDiscount.SETRANGE("Order Address Code", "Order Address Code");
            IF lrc_VendorDiscount.FIND('+') THEN
                "Entry No." := lrc_VendorDiscount."Entry No." + 10000
            ELSE
                "Entry No." := 10000;
        END;
        "Calculation Level" := 1;
        "Last User Modified" := copystr(USERID(), 1, 50);
        "Last Date Modified" := TODAY();
    end;

    trigger OnModify()
    begin
        "Last User Modified" := copystr(USERID(), 1, 50);
        "Last Date Modified" := TODAY();
    end;

    var
        lrc_VendorDiscount: Record "POI Vendor Discount";
}

