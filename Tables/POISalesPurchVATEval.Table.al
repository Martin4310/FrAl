table 5087926 "POI Sales/Purch. VAT Eval"
{
    Caption = 'Sales/Purch. VAT Evaluation';

    fields
    {
        field(1; "Cust/Vend Country Code"; Code[80])
        {
            Caption = 'Customer Country Code';
            Description = 'k - 30 < 80';
            TableRelation = "Country/Region";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                OnChangePrimaryKeyFields();
            end;
        }
        field(2; "Cust/Vend Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            Description = 'k - 30 > 20';
            trigger OnValidate()
            begin
                OnChangePrimaryKeyFields();
            end;
        }
        field(3; Source; Option)
        {
            Caption = 'Source';
            Description = 'k - Sales,Purchase';
            OptionCaption = 'Sales,Purchase,Transfer';
            OptionMembers = Sales,Purchase,Transfer;
        }
        field(4; "Shipment Type"; Option)
        {
            Caption = 'Shipment Type';
            Description = 'k -';
            OptionCaption = 'Franco,Selbstabholer';
            OptionMembers = Franco,Selbstabholer;

            trigger OnValidate()
            begin
                OnChangePrimaryKeyFields();
            end;
        }
        field(5; "State Customer Duty"; Option)
        {
            Caption = 'State Customer Duty';
            Description = 'k -';
            OptionCaption = ' ,Duty Paid,Duty unpaid';
            OptionMembers = " ","Duty Paid","Duty unpaid";
        }
        field(6; "Departure Country Code"; Code[10])
        {
            Caption = 'Departure Country Code';
            Description = 'k -';
            TableRelation = "Country/Region";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                OnChangePrimaryKeyFields();
            end;
        }
        field(7; "Arrival Country Code"; Code[40])
        {
            Caption = 'Arrival Country Code';
            Description = 'k - 40 > 10';
            TableRelation = "Country/Region";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                OnChangePrimaryKeyFields();
            end;
        }
        field(8; "Line Type"; Option)
        {
            Caption = 'Line Type';
            Description = 'k -';
            OptionCaption = 'Item,G/L Account,Item Charge,,,,Subtype VVE';
            OptionMembers = Item,"G/L Account","Item Charge",,,,"Subtype VVE";

            trigger OnValidate()
            begin
                OnChangePrimaryKeyFields();
            end;
        }
        field(9; "Line No."; Code[20])
        {
            Caption = 'Line No.';
            TableRelation = IF ("Line Type" = CONST(Item)) Item
            ELSE
            IF ("Line Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Line Type" = CONST("Subtype VVE")) "G/L Account"
            ELSE
            IF ("Line Type" = CONST("Item Charge")) "Item Charge";

            trigger OnValidate()
            begin
                OnChangePrimaryKeyFields();
            end;
        }
        field(10; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(11; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(14; "Sales/Purch Doc. Type"; Option)
        {
            Caption = 'Sales/Purch Doc. Type';
            OptionCaption = ' ,Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,,,,,,,,Picking Order';
            OptionMembers = " ",Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,,,,,,,,"Picking Order";
        }
        field(15; "Sales/Purch Doc. Subtype Code"; Code[10])
        {
            Caption = 'Sales/Purch Doc. Subtype Code';
            TableRelation = IF (Source = CONST(Sales)) "POI Sales Doc. Subtype".Code
            ELSE
            IF (Source = CONST(Purchase)) "POI Purch. Doc. Subtype".Code;
        }
        field(16; "Fiscal Agent"; Code[10])
        {
            Caption = 'Fiscal Agent';
            Description = 'k -';
            TableRelation = "POI Fiscal Agent";
        }
        field(18; "Valid From"; Date)
        {
            Caption = 'Valid From';
            Description = 'k -';
        }
        field(19; "Valid To"; Date)
        {
            Caption = 'Valid To';
        }
        field(20; "Additional Inv. Text 1"; Text[100])
        {
            Caption = 'Additional Inv. Text 1';
        }
        field(21; "Additional Inv. Text 2"; Text[100])
        {
            Caption = 'Additional Inv. Text 2';
        }
        field(22; "Additional Inv. Text 3"; Text[100])
        {
            Caption = 'Additional Inv. Text 3';
        }
        field(23; "Additional Inv. Text 4"; Text[100])
        {
            Caption = 'Additional Inv. Text 4';
        }
        field(27; "Translations Exist"; Boolean)
        {
            CalcFormula = Exist ("POI Language Translation 2");
            Caption = 'Translations Exist';
            Description = 'Exist("Language Translation 2" WHERE (Table ID=CONST(5087926),Cust/Vend Posting Group=FIELD(Customer Posting Group),Customer Country Code=FIELD(Customer Country Code),Departure Country Code=FIELD(Departure Country Code),Arrival Country Code=FIELD(Arrival Country Code),Shipment Type=FIELD(Shipment Type),"Line Type"=FIELD(Line Type),Line Code=FIELD(Line No.)))';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Print Fiscal Agent"; Boolean)
        {
            Caption = 'Print Fiscal Agent';
        }
        field(30; "VAT Tax Rate"; Decimal)
        {
            Caption = 'VAT Tax Rate';
        }
        field(31; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(32; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
        }
        field(40; "Departure Location Code"; Code[10])
        {
            Caption = 'Departure Location Code';
            Description = 'k -';
            TableRelation = Location;
        }
        field(50; "Posted Invoice Nos."; Code[10])
        {
            Caption = 'Posted Invoice Nos.';
            TableRelation = "No. Series";
        }
        field(51; "Posted Credit Memo Nos."; Code[10])
        {
            Caption = 'Posted Credit Memo Nos.';
            TableRelation = "No. Series";
        }
        field(50001; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(50002; "Not Arrival Country Code"; Code[10])
        {
            Caption = 'Arrival Country Code';
            Description = 'k -';

            trigger OnValidate()
            begin
                OnChangePrimaryKeyFields();
            end;
        }
        field(50003; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(50004; "Print Documents Code"; Code[10])
        {
            Caption = 'Print Documents Code';
            TableRelation = "POI Print Documents".Code;
            ValidateTableRelation = false;
        }
        field(50005; "Condition No."; Integer)
        {
            Caption = 'Condition No.';
        }
        field(50006; "Print Sorting Series"; Code[10])
        {
            Caption = 'Print Sorting Series';
            TableRelation = "No. Series";
        }
        field(50007; "Not Cust/Vend Country Code"; Code[100])
        {
            Caption = 'Not Cust/Vend Country Code';
            TableRelation = "Country/Region";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin

                OnChangePrimaryKeyFields();
            end;
        }
        field(50008; "Not Departure Country Code"; Code[10])
        {
            Caption = 'Not Departure Country Code';
            Description = 'k -';

            trigger OnValidate()
            begin

                OnChangePrimaryKeyFields();
            end;
        }
        field(50009; "VAT-Reg Departure Country Code"; Option)
        {
            Caption = 'VAT-Reg Departure Country Code';
            OptionCaption = 'Keine,direkt,Fiscal';
            OptionMembers = No,direkt,fiscal;

            trigger OnValidate()
            begin

                OnChangePrimaryKeyFields();
            end;
        }
        field(50010; "Print Vat-Reg Dep Country"; Boolean)
        {
            Caption = 'Print Vat-Reg Dep Country';
        }
        field(50011; "Not Departure Location Code"; Text[100])
        {
            Caption = 'Not Departure Location Code';
        }
        field(50012; Intrastat; Boolean)
        {
            Caption = 'Intrastat';
        }
        field(50013; "Not Arrival Location Code"; Text[100])
        {
            Caption = 'Not Arrival Location Code';
        }
        field(50014; "Arrival Location Code"; Code[10])
        {
            Caption = 'Arrival Location Code';
            TableRelation = Location;
        }
        field(50015; "Not Shipment Method Code"; Text[250])
        {
            Caption = 'Not Shipment Method Code';
        }
        field(50016; "Not Fiscal Agent"; Text[250])
        {
            Caption = 'Not Fiscal Agent';
        }
        field(50017; "Fiscal Reg."; Boolean)
        {
            Caption = 'steuerliche Registrierung';
            Description = 'k -';
        }
        field(50018; "EU 3rd Party Trade"; Boolean)
        {
            Caption = 'innergemeinschaftliches Dreiecksgeschäft';
        }
        field(60000; "autom. created"; Date)
        {
        }
        field(60001; "date created"; Date)
        {
        }
    }

    keys
    {
        key(Key1; Source, "Cust/Vend Posting Group", "Cust/Vend Country Code", "Departure Country Code", "Departure Location Code", "Arrival Country Code", "Not Arrival Country Code", "Shipment Type", "Shipment Method Code", "State Customer Duty", "Line Type", "Fiscal Agent", "Fiscal Reg.", "Not Departure Country Code", "Valid From")
        {
        }
        key(Key2; "Condition No.")
        {
        }
    }

    trigger OnDelete()
    begin
        Check_User();
    end;

    trigger OnInsert()
    begin
        Check_User();
        "date created" := TODAY();
    end;

    trigger OnModify()
    begin
        Check_User();
    end;

    trigger OnRename()
    begin
        Check_User();
    end;

    procedure OnChangePrimaryKeyFields()
    var
        AGILES_LT_TEXT001Txt: Label 'Cann''t be rename. The Translations exist.';
    begin

        IF "Translations Exist" = TRUE THEN
            IF ("Cust/Vend Posting Group" <> xRec."Cust/Vend Posting Group") OR
               ("Cust/Vend Country Code" <> xRec."Cust/Vend Country Code") OR
               ("Departure Country Code" <> xRec."Departure Country Code") OR
               ("Arrival Country Code" <> xRec."Arrival Country Code") OR
               ("Shipment Type" <> xRec."Shipment Type") OR
               ("Shipment Method Code" <> xRec."Shipment Method Code") OR
               ("Line Type" <> xRec."Line Type") OR
               ("Line No." <> xRec."Line No.") THEN
                // Der Datensatz kann nicht umbenannt werden, da bereits Übersetzungen vorhanden sind!
                ERROR(AGILES_LT_TEXT001Txt);
    end;

    procedure Check_User()
    begin
        IF (UPPERCASE(USERID()) <> ('WESSEL')) AND (UPPERCASE(USERID()) <> ('LESS')) THEN
            ERROR('Bitte an Admin wenden !');
    end;
}

