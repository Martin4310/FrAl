tableextension 50041 "POI Item Category Ext" extends "Item Category"
{
    fields
    {
        field(50004; "POI Def. Gen. Prod. Post Group"; Code[10])
        {
            Caption = 'Def. Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(50005; "POI Def. Inventory Post Group"; Code[10])
        {
            Caption = 'Def. Inventory Posting Group';
            TableRelation = "Inventory Posting Group".Code;
        }
        field(50006; "POI Def. Tax Group Code"; Code[10])
        {
            Caption = 'Def. Tax Group Code';
            TableRelation = "Tax Group".Code;
        }
        field(50007; "POI Def. Costing Method"; Option)
        {
            Caption = 'Def. Costing Method';
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
            OptionMembers = FIFO,LIFO,Specific,"Average",Standard;
        }
        field(50008; "POI Def. VAT Prod. Post Group"; Code[10])
        {
            Caption = 'Def. VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(5110305; "POI Sorting in Price List"; Integer)
        {
            Caption = 'Sorting in Price List';
        }
        field(5110310; "POI Item Main Category Code"; Code[10])
        {
            Caption = 'Item Main Category Code';
            TableRelation = "POI Item Main Category";
        }
        field(5110311; "POI Def. Base Unit of Measure"; Code[10])
        {
            Caption = 'Def. Base Unit of Measure';
            TableRelation = "Unit of Measure" WHERE("POI Is Base Unit of Measure" = CONST(true));
        }
    }

}