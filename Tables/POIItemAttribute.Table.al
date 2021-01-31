table 50937 "POI Item Attribute"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Attribute Code"; Code[20])
        {
            Caption = 'Merkmals Code';
            DataClassification = CustomerContent;
            TableRelation = if ("Attribute Type" = const(Caliber)) "POI Caliber".Code
            else
            if ("Attribute Type" = const(Coding)) "POI Coding".Code
            else
            if ("Attribute Type" = const(Color)) "POI Item Attribute 2".Code
            else
            if ("Attribute Type" = const(Cultivation)) "POI Cultivation Association".Code
            else
            if ("Attribute Type" = const("Grade of Goods")) "POI Grade of Goods".Code
            else
            if ("Attribute Type" = const(Trademark)) "POI Trademark".Code
            else
            if ("Attribute Type" = const(Variety)) "POI Variety".Code;
            trigger OnValidate()
            begin
                case "Attribute Type" of
                    "Attribute Type"::Caliber:
                        begin
                            Caliber.Get("Attribute Code");
                            "Attribute Description" := Caliber.Description;
                        end;
                    "Attribute Type"::Trademark:
                        begin
                            Trademark.Get("Attribute Code");
                            "Attribute Description" := Trademark.Description;
                        end;
                    "Attribute Type"::"EAN Code":
                        "Attribute Description" := "Attribute Code";
                end;
            end;
        }
        field(2; "Attribute Description"; Text[50])
        {
            Caption = 'Merkmalsbeschreibung';
            DataClassification = CustomerContent;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Artikelnr.';
            DataClassification = CustomerContent;
            TableRelation = Item."No.";
        }
        field(4; "Item Description"; Text[50])
        {
            Caption = 'Artikelbeschreibung';
            FieldClass = FlowField;
            CalcFormula = lookup (Item.Description where("No." = field("Item No.")));
        }
        field(5; "CustAttribute"; Boolean)
        {
            Caption = 'Kundenmerkmal';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist ("POI Trademark" where(Code = field("Attribute Code"), "Belongs to Customer No." = filter(<> '')));
        }
        field(6; "VendAttribute"; Boolean)
        {
            Caption = 'Lieferantenmerkmal';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist ("POI Trademark" where(Code = field("Attribute Code"), "Belongs to Vendor No." = filter(<> '')));
        }
        field(7; "Attribute Type"; enum "POI Item Attribute")
        {
            Caption = 'Attribute Type';
            DataClassification = CustomerContent;
        }
        field(8; "Source Type"; enum "POI Source Type")
        {
            Caption = 'Herkunftsart';
            DataClassification = CustomerContent;
        }
        field(9; "Source No."; Code[20])
        {
            Caption = 'Herkunftsnr.';
            DataClassification = CustomerContent;
            TableRelation = if ("Source Type" = const(Customer)) Customer."No."
            else
            if ("source Type" = const(Vendor)) Vendor."No."
            else
            if ("Source Type" = const(Item)) Item."No.";
        }
    }
    keys
    {
        key(PK; "Attribute Type", "Attribute Code", "Item No.", "Source Type", "Source No.")
        {
            Clustered = true;
        }
    }

    procedure CreateItemAttributes(ItemNo: Code[20])
    AttributeType: Enum "POI Item Attribute";
    begin
        if ItemNo <> '' then begin
            Item.Get(ItemNo);
            ItemAttribute.Reset();
            ItemAttribute.SetRange("Item No.", ItemNo);
            ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::Trademark);
            if ItemAttribute.FindFirst() then
                Item."POI Trademarks" := CreateItemAttribute(ItemNo, ItemAttribute."Attribute Type");
            ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::Caliber);
            if ItemAttribute.FindFirst() then
                Item."POI Caliber Codes" := CreateItemAttribute(ItemNo, ItemAttribute."Attribute Type");
            ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::Color);
            if ItemAttribute.FindFirst() then
                Item."POI Color Codes" := CreateItemAttribute(ItemNo, ItemAttribute."Attribute Type");
            ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::"Grade of Goods");
            if ItemAttribute.FindFirst() then
                Item."POI Grade of Goods Codes" := CreateItemAttribute(ItemNo, ItemAttribute."Attribute Type");
            ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::Variety);
            if ItemAttribute.FindFirst() then
                Item."POI Variety Codes" := CreateItemAttribute(ItemNo, ItemAttribute."Attribute Type");
            ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::Coding);
            if ItemAttribute.FindFirst() then
                Item."POI Coding Codes" := CreateItemAttribute(ItemNo, ItemAttribute."Attribute Type");
            ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::Cultivation);
            if ItemAttribute.FindFirst() then
                Item."POI Cultivation Types" := CreateItemAttribute(ItemNo, ItemAttribute."Attribute Type");
            ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::"PLU-Code");
            if ItemAttribute.FindFirst() then
                Item."POI PLU-Codes" := CreateItemAttribute(ItemNo, ItemAttribute."Attribute Type");
            Item.Modify();
        end;
    end;

    procedure CreateItemAttribute(ItemNo: Code[20]; AttributeType: enum "POI Item Attribute"): Text[100]
    begin
        SpecialText := '';
        ItemAttribute.SetRange("Item No.", ItemNo);
        ItemAttribute.SetRange("Attribute Type", AttributeType);
        if ItemAttribute.FindSet() then
            repeat
                if SpecialText = '' then
                    SpecialText := ItemAttribute."Attribute Code"
                else
                    SpecialText += ';' + ItemAttribute."Attribute Code";
            until ItemAttribute.Next() = 0;
        exit(SpecialText);
    end;

    var
        Item: Record Item;
        ItemAttribute: Record "POI Item Attribute";
        Caliber: Record "POI Caliber";
        Trademark: Record "POI Trademark";
        SpecialText: Text[100];

}