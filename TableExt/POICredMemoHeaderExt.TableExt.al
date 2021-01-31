tableextension 50049 "POI Cred. Memo Header Ext" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(5110330; "POI Sales Claim No."; Code[20])
        {
            Caption = 'Sales Claim No.';
            Description = 'VKR';
            TableRelation = "POI Sales Claim Notify Header"."No.";
        }
    }

}