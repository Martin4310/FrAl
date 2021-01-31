tableextension 50046 "POI Item Vendor Ext" extends "Item Vendor"
{
    fields
    {
        field(5110300; "POI Decl. of no Objection"; Boolean)
        {
            Caption = 'Declaration of no Objection';

            trigger OnValidate()
            begin
                IF "POI Decl. of no Objection" = FALSE THEN BEGIN
                    "POI Decl. of no Obj Recei Date" := 0D;
                    "POI Decl. of no Obj Valid Unt." := 0D;
                END;
            end;
        }
        field(5110301; "POI Decl. of no Obj Recei Date"; Date)
        {
            Caption = 'Decl. of no Obj Receiving Date';
        }
        field(5110302; "POI Decl. of no Obj Valid Unt."; Date)
        {
            Caption = 'Decl. of no Obj Valid Untill';
        }
        field(5110309; "POI Main Vendor"; Boolean)
        {
            Caption = 'Main Vendor';
        }
        field(5110310; "POI Vendor Name"; Text[50])
        {
            CalcFormula = Lookup (Vendor.Name WHERE("No. 2" = FIELD("Vendor No.")));
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110311; "POI Item Search Description"; Code[70])
        {
            CalcFormula = Lookup (Item."Search Description" WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Search Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110312; "POI Item Description"; Text[100])
        {
            CalcFormula = Lookup (Item.Description WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110313; "POI Item Description 2"; Text[50])
        {
            CalcFormula = Lookup (Item."Description 2" WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Description 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110315; "POI Purchaser Code"; Code[10])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(5110440; "POI Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            TableRelation = "Country/Region".Code;
        }
        field(5110441; "POI Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            TableRelation = "POI Variety".Code;
        }
        field(5110442; "POI Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            TableRelation = "POI Caliber";
        }
        field(5110443; "POI Color Code"; Code[10])
        {
            Caption = 'Color Code';
            TableRelation = "POI Item Attribute 2";
        }
        field(5110444; "POI Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            TableRelation = "POI Trademark";
        }
        field(5110445; "POI Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            TableRelation = "POI Grade of Goods";
        }
        field(5110446; "POI Treatment Code"; Code[10])
        {
            Caption = 'Treatment Code';
            TableRelation = "POI Item Attribute 5";
        }
        field(5110448; "POI Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            OptionCaption = ' ,Transmission,Organic';
            OptionMembers = " ",Transmission,Organic;
        }
        field(5110459; "POI Packing Code"; Code[10])
        {
            Caption = 'Packing Code';
            TableRelation = "POI Item Attribute 4";
        }
        field(5110460; "POI Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
    }

}