tableextension 50016 "POI Item Charge" extends "Item Charge"
{
    fields
    {
        field(5110300; "POI Global Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,1,3';
            Caption = 'Global Dimension 3 Code';
            Description = 'EDM';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "POI Global Dimension 3 Code");
            end;
        }
        field(5110301; "POI Global Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,1,4';
            Caption = 'Global Dimension 4 Code';
            Description = 'EDM';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "POI Global Dimension 4 Code");
            end;
        }
        field(5110302; "POI Batch Item Charge"; Boolean)
        {
            Caption = 'Batch Item Charge';

        }
        field(5110303; "POI Not Relev for Sales Claim"; Boolean)
        {
            Caption = 'Not Relevant for Sales Claim';
        }
        field(5110310; "POI Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(5110311; "POI Item Charge Assignment"; Option)
        {
            Caption = 'Item Charge Assignment';
            OptionCaption = ' ,One to One';
            OptionMembers = " ","Eins zu Eins";
        }
        field(5110620; "POI MOS Item Charge Type"; Option)
        {
            Caption = 'MOS Item Charge Type';
            Description = 'EDI';
            OptionCaption = ' ,Freight,Packaging,Insurance';
            OptionMembers = " ",Freight,Packaging,Insurance;

            // trigger OnValidate()
            // var
            //     EDISetup: Record "5087915";
            // begin
            //     EDISetup.GET;
            //     EDISetup.TESTFIELD("Allow Charge (Item)",TRUE);
            // end;
        }
    }
}