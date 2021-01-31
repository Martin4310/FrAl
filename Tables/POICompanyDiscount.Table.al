table 5110387 "POI Company Discount"
{
    Caption = 'Company Discount';
    // DrillDownFormID = Form5110387;
    // LookupFormID = Form5110387;

    fields
    {
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Vendor,,,Customer';
            OptionMembers = Vendor,,,Customer;
        }
        field(4; "Calculation Level"; Integer)
        {
            Caption = 'Calculation Level';
            MaxValue = 9;
            MinValue = 0;
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
            Caption = 'Type of Discount Value';
            Description = 'Prozentsatz,Absoluter Betrag,Betrag Pro Kolli,Kolloeinheit,Proz. auf Einheit gerundet,Betrag Pro Frachteinheit,Betrag pro Kilo';
            OptionCaption = 'Prozentsatz,Absoluter Betrag auf Zeilenbasis,Betrag Pro Kolli,Kolloeinheit,Proz. auf Einheit gerundet,Betrag Pro Frachteinheit,Betrag pro Kilo,Gew.-Abhängiger Betrag,Betrag pro Transporteinheit,Betrag pro Netto Kilo,Betrag pro Brutto Kilo,Absoluter Betrag auf Kollobasis,VK-Preis abhängiger Betrag';
            OptionMembers = Prozentsatz,"Absoluter Betrag auf Zeilenbasis","Betrag Pro Kolli",Kolloeinheit,"Proz. auf Einheit gerundet","Betrag Pro Frachteinheit","Betrag pro Kilo","Gew.-Abhängiger Betrag","Betrag pro Transporteinheit","Betrag pro Netto Kilo","Betrag pro Brutto Kilo","Absoluter Betrag auf Kollobasis","VK-Preis abhängiger Betrag";
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
        field(79; "Shipment Method"; Code[10])
        {
            Caption = 'Shipment Method';
            TableRelation = "Shipment Method";
        }
        field(85; "Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            OptionCaption = ' ,Payed,Not Payed';
            OptionMembers = " ",Payed,"Not Payed";
        }
        field(100; Comment; Text[30])
        {
            Caption = 'Comment';
        }
        field(101; "Last User Modified"; Code[20])
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
        key(Key1; Type, "Calculation Level", "Entry No.")
        {
        }
    }
}

