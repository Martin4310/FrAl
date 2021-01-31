tableextension 50047 "POI Purch./Payables Ext" extends "Purchases & Payables Setup" //MyTargetTableId
{
    fields
    {
        field(5110300; "POI Ext. Vend. Ship. No. Mand"; Boolean)
        {
            Caption = 'Ext. Vend. Ship. No. Mandatory';
            InitValue = true;
        }
        field(5110302; "POI Period Check Ext. Doc. No."; DateFormula)
        {
            Caption = 'Period Check Ext. Doc. No.';
        }
        field(5110309; "POI Inv. Ledger Entry"; Option)
        {
            Caption = 'Inv. Ledger Entry';
            OptionCaption = ' ,Activ,Activ with Posting No.';
            OptionMembers = " ",Activ,"Activ with Posting No.";
        }
        field(5110310; "POI Inv. Ledger Entry Nos."; Code[10])
        {
            Caption = 'Inv. Ledger Entry Nos.';
            Description = 'REB';
            TableRelation = "No. Series";
        }
        field(5110311; "POI Inv. Ledger Int. Entry No."; Option)
        {
            Caption = 'Inv. Ledger Internal Entry No.';
            OptionCaption = ' ,Internal Entry No. equal No.Series';
            OptionMembers = " ","Internal Entry No. equal No.Series";
        }
        field(5110320; "POI Auto Upd. Exp.Rec. Date Li"; Boolean)
        {
            Caption = 'Auto. Upd. Exp.Rec. Date Lines';
        }
    }

}