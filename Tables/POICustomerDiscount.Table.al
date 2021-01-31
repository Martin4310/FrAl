table 5110386 "POI Customer Discount"
{
    Caption = 'Customer Discount';
    // DrillDownFormID = Form5110386;
    // LookupFormID = Form5110386;

    fields
    {
        field(1; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = 'Customer,Customer Group,Customer Main Group,Customer Hierarchy';
            OptionMembers = Customer,"Customer Group","Customer Main Group","Customer Hierarchy";

            trigger OnValidate()
            begin
                IF Source = Source::"Customer Hierarchy" THEN
                    // Herkunft nicht zulässig!
                    ERROR(ADF_GT_TEXT001Txt);
            end;
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST(Customer)) Customer
            ELSE
            IF (Source = CONST("Customer Group")) "POI Customer Group"
            ELSE
            IF (Source = CONST("Customer Main Group")) "POI Customer Main Group"
            ELSE
            IF (Source = CONST("Customer Hierarchy")) "POI Cust. Mult Level Hierarchy";
        }
        field(3; "Ship-to Address Code"; Code[10])
        {
            Caption = 'Ship-to Address Code';
            TableRelation = IF (Source = CONST(Customer)) "Ship-to Address".Code WHERE("Customer No." = FIELD("Source No."));
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
                    "Basis %-Value incl. VAT" := FALSE;
                    "Currency Code" := '';
                END;
            end;
        }
        field(17; "Discount Type"; Option)
        {
            Caption = 'Discount Type';
            Description = 'Warenrechnungsrabatt,Rechnungsrabatt';
            OptionCaption = 'Warenrechnungsrabatt,Rechnungsrabatt,Artikelrabatt';
            OptionMembers = Warenrechnungsrabatt,Rechnungsrabatt,Artikelrabatt;
        }
        field(18; "Base Discount Value"; Option)
        {
            Caption = 'Base Discount Value';
            Description = 'Prozentsatz,Absoluter Betrag,Betrag Pro Kolli,Kolloeinheit,Proz. auf Einheit gerundet,Betrag Pro Frachteinheit';
            OptionCaption = 'Prozentsatz,Absoluter Betrag auf Zeilenbasis,Betrag Pro Kolli,Kolloeinheit,Proz. auf Einheit gerundet,Betrag Pro Frachteinheit,Betrag pro Kilo,Gew.-Abhängiger Betrag,Betrag pro Transporteinheit,Betrag pro Netto Kilo,Betrag pro Brutto Kilo,Absoluter Betrag auf Kollobasis,VK-Preis abhängiger Betrag';
            OptionMembers = Prozentsatz,"Absoluter Betrag auf Zeilenbasis","Betrag Pro Kolli",Kolloeinheit,"Proz. auf Einheit gerundet","Betrag Pro Frachteinheit","Betrag pro Kilo","Gew.-Abhängiger Betrag","Betrag pro Transporteinheit","Betrag pro Netto Kilo","Betrag pro Brutto Kilo","Absoluter Betrag auf Kollobasis","VK-Preis abhängiger Betrag";

            trigger OnValidate()
            begin
                IF "Base Discount Value" IN ["Base Discount Value"::"Betrag pro Kilo", "Base Discount Value"::"Proz. auf Einheit gerundet"] THEN
                    ERROR(AGILESTEXT0001Txt, "Base Discount Value");
            end;
        }
        field(19; "Discount Value"; Decimal)
        {
            Caption = 'Discount Value';
        }
        field(20; "Basis %-Value incl. VAT"; Boolean)
        {
            Caption = 'Basis %-Value incl. VAT';
        }
        field(22; "Payment Timing"; Option)
        {
            Caption = 'Payment Timing';
            Description = 'Rechnung,Monat,Quartal,Halbjahr,Jahr,Rückstellung,Separate Gutschrift,Zahlung';
            OptionCaption = 'Invoice,Month,Quarter,Half Year,Year,Rückstellung,Separate Credit Memo';
            OptionMembers = Invoice,Month,Quarter,"Half Year",Year,"Rückstellung","Separate Credit Memo";
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
            OptionMembers = " ","Item Category","Product Group","Item No.",Trademark,"Proper Name";
        }
        field(63; "Not Valid for Filter"; Code[250])
        {
            Caption = 'Not Valid for Filter';
            TableRelation = IF ("Not Valid for" = CONST("Item Category")) "Item Category"
            ELSE
            IF ("Not Valid for" = CONST("Product Group")) "POI Product Group".Code
            ELSE
            IF ("Not Valid for" = CONST("Item No.")) Item
            ELSE
            IF ("Not Valid for" = CONST(Trademark)) "POI Trademark"
            ELSE
            IF ("Not Valid for" = CONST("Proper Name")) "POI Proper Name".Code;
            ValidateTableRelation = false;
        }
        field(68; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(69; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
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
        field(74; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            TableRelation = "POI Trademark";
        }
        field(75; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(76; "Vendor Country Group"; Code[10])
        {
            Caption = 'Vendor Country Group';
            TableRelation = "POI Country Group";
        }
        field(77; "Person in Charge Code"; Code[10])
        {
            Caption = 'Person in Charge Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(78; "Service Invoice Customer No."; Code[20])
        {
            Caption = 'Service Invoice Customer No.';
            TableRelation = Customer."No.";
        }
        field(79; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(80; "Not Relevant in next Level"; Boolean)
        {
            Caption = 'Not Relevant in next Level';
        }
        field(85; "Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            OptionCaption = ' ,Payed,Not Payed';
            OptionMembers = " ",Payed,"Not Payed";
        }
        field(90; "Posting to Sell-to Customer"; Boolean)
        {
            Caption = 'Posting to Sell-to Customer';

            trigger OnValidate()
            begin
                TESTFIELD("Payment Timing", "Payment Timing"::Rückstellung);
            end;
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
        key(Key1; Source, "Source No.", "Ship-to Address Code", "Calculation Level", "Entry No.")
        {
        }
    }

    trigger OnInsert()
    begin
        IF "Entry No." = 0 THEN BEGIN
            lrc_CustDiscount.SETRANGE("Source No.", "Source No.");
            lrc_CustDiscount.SETRANGE("Ship-to Address Code", "Ship-to Address Code");
            IF lrc_CustDiscount.FIND('+') THEN
                "Entry No." := lrc_CustDiscount."Entry No." + 10000
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
        lrc_CustDiscount: Record "POI Customer Discount";
        //grc_User: Record user;
        AGILESTEXT0001Txt: Label 'Bezugsgröße Rabatt "%1" für Verkauf nicht zugelassen!', Comment = '%1';
        ADF_GT_TEXT001Txt: Label 'Herkunft nicht zulässig!';
}

