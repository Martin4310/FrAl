tableextension 50006 "POI ItemLedgerEntryExt" extends "Item Ledger Entry"
{
    fields
    {
        field(5110307; "POI Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            Description = ' ,Payed,Not Payed';
            OptionCaption = ' ,Payed,Not Payed';
            OptionMembers = " ",Payed,"Not Payed";
        }
        field(50322; "POI Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }
        field(5110321; "POI Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(5110323; "POI Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = "POI Batch Variant";
        }
        field(5110324; "POI Batch Var. Detail ID"; Integer)
        {
            Caption = 'Batch Var. Detail ID';
        }
        field(5110330; "POI Total Gross Weight"; Decimal)
        {
            Caption = 'Total Gross Weight';
        }
        field(5110331; "POI Total Net Weight"; Decimal)
        {
            Caption = 'Total Net Weight';
        }
        field(5110334; "POI Item Attribute 1"; Code[10])
        {
            CaptionClass = '5110310,1,1';
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 1";
        }
        field(5110337; "POI Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            Description = 'EIA';
            TableRelation = "POI Trademark";
        }
        field(5110338; "POI Caliber"; Code[20])
        {
            Caption = 'Caliber';
            DataClassification = CustomerContent;
        }
        field(5110340; "POI Item Attribute 3"; Code[10])
        {
            CaptionClass = '5110310,1,3';
            Caption = 'Quality Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 3".Code;
        }
        field(5110341; "POI Item Attribute 2"; Code[10])
        {
            CaptionClass = '5110310,1,2';
            Caption = 'Color Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 2";
        }
        field(5110342; "POI Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            Description = 'EIA';
            TableRelation = "POI Grade of Goods";
        }
        field(5110343; "POI Item Attribute 7"; Code[10])
        {
            CaptionClass = '5110310,1,7';
            Caption = 'Conservation Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 7";
        }
        field(5110344; "POI Item Attribute 4"; Code[10])
        {
            CaptionClass = '5110310,1,4';
            Caption = 'Packing Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 4";
        }
        field(5110345; "POI Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            Description = 'EIA';
            TableRelation = "POI Coding";
        }
        field(5110346; "POI Item Attribute 5"; Code[10])
        {
            CaptionClass = '5110310,1,5';
            Caption = 'Treatment Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 5";
        }
        field(5110347; "POI Item Attribute 6"; Code[20])
        {
            CaptionClass = '5110310,1,6';
            Caption = 'Proper Name Code';
            Description = 'EIA';
            TableRelation = "POI Proper Name";
        }
        field(5110370; "POI Source Doc. Type"; Option)
        {
            Caption = 'Source Doc. Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,Input Packing Order,Output Packing Order,,,Transfer,Ship Transfer,Receive Transfer,,,Item Journal';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,"Input Packing Order","Output Packing Order",,,Transfer,"Ship Transfer","Receive Transfer",,,"Item Journal";
        }
        field(5110371; "POI Source Doc. No."; Code[20])
        {
            Caption = 'Source Doc. No.';
        }
        field(5110372; "POI Source Doc. Line No."; Integer)
        {
            Caption = 'Source Doc. Line No.';
        }
        field(5110408; "POI Market Purch. Amount"; Decimal)
        {
            Caption = 'Market Purch. Amount';
            Description = 'MEK';
        }
        field(5110409; "POI Market Purch. Price"; Decimal)
        {
            Caption = 'Market Purch. Price';
            Description = 'MEK';
        }
    }

}