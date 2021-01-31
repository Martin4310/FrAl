tableextension 50005 "POI GLEntryExt" extends "G/L Entry"
{
    fields
    {
        field(50000; "POI Fiscal ASgent Code"; Code[10])
        {
            Caption = 'Fiscal ASgent Code';
            DataClassification = CustomerContent;
        }
        field(5110300; "POI Global Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,1,3';
            Caption = 'Global Dimension 3 Code';
            Description = 'EDM';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(5110301; "POI Global Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,1,4';
            Caption = 'Global Dimension 4 Code';
            Description = 'EDM';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(50310; "POI Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }
        field(50306; "POI Income/Balance"; Option)
        {
            Caption = 'Income/Balance';
            DataClassification = CustomerContent;
            OptionMembers = "Income Statement","Balance Statement";
            OptionCaption = 'Income Statement,Balance Statement';
        }
        field(50311; "POI Cost Allocation"; Option)
        {
            Caption = 'Cost Allocation';
            DataClassification = CustomerContent;
            OptionMembers = ,"Direct Purchase Cost",,,,,"Indirect Purchase Cost";
            OptionCaption = ' ,Direct Purchase Cost,,,,,Indirect Purchase Cost';
        }
        field(50307; "POI Batch Cost Account"; Option)
        {
            Caption = 'Batch Cost Account';
            DataClassification = CustomerContent;
            OptionMembers = ,Cost,"Turnover deducted Cost";
            OptionCaption = ',Cost,"Turnover deducted Cost"';

        }


    }

}