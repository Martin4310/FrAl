table 5110338 "POI Assortment"
{

    Caption = 'Assortment';
    // DrillDownFormID = Form5088160;
    // LookupFormID = Form5088160;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(20; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(22; "Ref. Date Validation"; Option)
        {
            Caption = 'Ref. Date Validation';
            OptionCaption = 'Order Date,Shipment Date,Requested Delivery Date,Promised Delivery Date';
            OptionMembers = "Order Date","Shipment Date","Requested Delivery Date","Promised Delivery Date";
        }
        field(28; "Assortment Content"; Option)
        {
            Caption = 'Assortment Content';
            OptionCaption = 'Item,,,,,,Batch Variant';
            OptionMembers = Item,,,,,,"Batch Variant";
        }
        field(30; "Assortment Source"; Option)
        {
            Caption = 'Assortment Source';
            OptionCaption = 'Company Assortment,Customer Assortment,,,,,Base Assortment,,,,,,,,,,Planing Assortment';
            OptionMembers = "Company Assortment","Customer Assortment",,,,,"Base Assortment",,,,,,,,,,"Planing Assortment";
        }
        field(32; "Assortment Type"; Option)
        {
            Caption = 'Sortimentsart';
            OptionCaption = 'Periodical Assortment,Repeating Assortment';
            OptionMembers = "Periodical Assortment","Repeating Assortment";
        }
        field(35; "Assortment Export per EDI"; Option)
        {
            Caption = 'Assortment Export per EDI';
            OptionCaption = ' ,Export';
            OptionMembers = " ",Export;
        }
        field(50; "No. Series Assortment Version"; Code[10])
        {
            Caption = 'No. Series Assortment Version';
            TableRelation = "No. Series";
        }
        field(60; "No. of Assortment Versions"; Integer)
        {
            CalcFormula = Count ("POI Assortment Version" WHERE("Assortment Code" = FIELD(Code)));
            Caption = 'No. of Assortment Versions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "No. of Customers"; Integer)
        {
            CalcFormula = Count ("POI Customer - Assortment" WHERE("Assortment Code" = FIELD(Code),
                                                               Source = CONST(Customer)));
            Caption = 'No. of Customers';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "No. of Company Chains"; Integer)
        {
            CalcFormula = Count ("POI Customer - Assortment" WHERE("Assortment Code" = FIELD(Code),
                                                               Source = CONST("Company Chain")));
            Caption = 'No. of Company Chains';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Allocation Price Group"; Option)
        {
            Caption = 'Allocation Price Group';
            OptionCaption = 'Customer,Assortment';
            OptionMembers = Customer,Assortment;
        }
        field(71; "Customer Price Group Code"; Code[10])
        {
            Caption = 'Customer Price Group Code';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            var
                AGILES_LT_Txt: Label 'Änderung nicht zulässig!';
            begin
                IF ("Customer Price Group Code" <> '') AND ("Allocation Price Group" = "Allocation Price Group"::Customer) THEN
                    // Änderung nicht zulässig!
                    ERROR(AGILES_LT_Txt);
            end;
        }
        field(80; "Form ID Assortment Card"; Integer)
        {
            Caption = 'Form ID Assortment Card';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(85; "Sort Order in Sales"; Option)
        {
            Caption = 'Sort Order in Sales';
            OptionCaption = 'Prod.Grp-Artikelsuchbegriff,Sortierfolge,Artikelnr. 2,Artikelbeschreibung,Artikelnr.';
            OptionMembers = "Prod.Grp-Artikelsuchbegriff",Sortierfolge,"Artikelnr. 2",Artikelbeschreibung,"Artikelnr.";
        }
        field(86; "Sort Order in Assortment"; Option)
        {
            Caption = 'Sort Order in Assortment';
            OptionCaption = 'Prod.Grp-Item Search,Sort Sequence,Item No. 2,Item Description,Item No.';
            OptionMembers = "Prod.Grp-Item Search","Sort Sequence","Item No. 2","Item Description","Item No.";
        }
        field(90; "Sales Price Necessary"; Boolean)
        {
            Caption = 'Sales Price Necessary';
        }
        field(100; "Assort. for Sales Doc. Subtype"; Code[10])
        {
            Caption = 'Assort. for Sales Doc. Subtype';
            TableRelation = "POI Sales Doc. Subtype".Code;
        }
        field(110; "Report ID Price List"; Integer)
        {
            Caption = 'Report ID Price List';
        }
        field(120; "Header Standard Text Code"; Code[10])
        {
            Caption = 'Header Standard Text Code';
            TableRelation = "Standard Text";
        }
        field(121; "Footer Standard Text Code"; Code[10])
        {
            Caption = 'Footer Standard Text Code';
            TableRelation = "Standard Text";
        }
        field(5110311; "Arrival Region Code"; Code[20])
        {
            Caption = 'Arrival Region Code';
            TableRelation = "POI Departure Region" where(RegionType = const(Arrival));
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lrc_AssortmentVersion: Record "POI Assortment Version";
        lrc_AssortmentVersionLine: Record "POI Assortment Version Line";
    begin
        lrc_AssortmentVersion.SETRANGE("Assortment Code", Code);
        lrc_AssortmentVersion.DELETEALL();

        lrc_AssortmentVersionLine.SETRANGE("Assortment Code", Code);
        lrc_AssortmentVersionLine.DELETEALL(TRUE);
    end;
}

