tableextension 50007 "POI ValueEntryExt" extends "Value Entry" //MyTargetTableId
{
    fields
    {
        field(50322; "POI Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }
        field(50350; "POI Inv. Disc. (Act)"; Decimal)
        {
            Caption = 'Inv. Disc. (Act)';
            DataClassification = CustomerContent;
        }
        field(50351; "POI Inv.Disc.not Relat.toGoods"; Decimal)
        {
            Caption = 'Inv. Disc. not Relat. to Goods';
            DataClassification = CustomerContent;
        }
        field(50352; "POI AccruelInv.Disc.(External)"; Decimal)
        {
            Caption = 'Accruel Inv. Disc. (External)';
            DataClassification = CustomerContent;
        }
        field(50353; "POI AccruelInv.Disc.(Internal)"; Decimal)
        {
            Caption = 'Accruel Inv. Disc. (Internal)';
            DataClassification = CustomerContent;
        }
        field(50355; "POI Green Point Costs"; Decimal)
        {
            Caption = 'Green Point Costs';
            DataClassification = CustomerContent;
        }
        field(50357; "POI Freight Costs"; Decimal)
        {
            Caption = 'Freight Costs';
            DataClassification = CustomerContent;
        }



    }

}