table 5110369 "POI Batch Temp"
{
    Caption = 'Batch Temp';

    fields
    {
        field(1; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            Description = 'SBN=Select Batch No., COC=Cost Calculation, MCS=Master Batch Cost Splitt,SBV=Select Batch Variant';
            OptionCaption = ' ,SBN,COC,MCS,SBV';
            OptionMembers = " ",SBN,COC,MCS,SBV;
        }
        field(2; "Userid Code"; Code[50])
        {
            Caption = 'Userid Code';
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(9; "-- SBN --"; Integer)
        {
            Caption = '-- SBN --';
        }
        field(10; "SBN Batch No."; Code[20])
        {
            Caption = 'SBN Batch No.';
        }
        field(19; "-- COC --"; Integer)
        {
            Caption = '-- COC --';
        }
        field(20; "COC Batch No."; Code[20])
        {
            Caption = 'COC Batch No.';
        }
        field(21; "COC Total Amount"; Decimal)
        {
            Caption = 'COC Total Amount';
        }
        field(23; "COC Qty. Colli"; Decimal)
        {
            Caption = 'COC Qty. Colli';
        }
        field(24; "COC Qty. Pallets"; Decimal)
        {
            Caption = 'COC Qty. Pallets';
        }
        field(26; "COC Gross Weight"; Decimal)
        {
            Caption = 'COC Gross Weight';
        }
        field(27; "COC Net Weight"; Decimal)
        {
            Caption = 'COC Net Weight';
        }
        field(29; "COC No. of Lines"; Decimal)
        {
            Caption = 'COC No. of Lines';
        }
        field(49; "-- MCS --"; Integer)
        {
            Caption = '-- MCS --';
        }
        field(50; "MCS Batch No."; Code[20])
        {
            Caption = 'Batch No.';
        }
        field(51; "MCS Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
        }
        field(52; "MCS Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
        }
        field(53; "MCS Quantity Colli"; Decimal)
        {
            Caption = 'Quantity Colli';
        }
        field(54; "MCS Quantity Pallets"; Decimal)
        {
            Caption = 'Quantity Pallets';
        }
        field(55; "MCS Quantity Packings"; Decimal)
        {
            Caption = 'Quantity Packings';
        }
        field(56; "MCS Gross Weight"; Decimal)
        {
            Caption = 'MCS Gross Weight';
        }
        field(57; "MCS Net Weight"; Decimal)
        {
            Caption = 'MCS Net Weight';
        }
        field(59; "MCS No. of Lines"; Decimal)
        {
            Caption = 'No. of Lines';
        }
        field(60; "MCS Qty. (Cost Inv.)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'MCS Qty. (Cost Inv.)';
            DecimalPlaces = 0 : 2;
        }
        field(61; "MCS Posted Qty. (Cost Inv.)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'MCS Posted Qty. (Cost Inv.)';
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(62; "MCS Posted Amount"; Decimal)
        {
            Caption = 'MCS Posted Amount';
        }
        field(63; "MCS Qty. (Cost Inv) Refered To"; Option)
        {
            Caption = 'MCS Qty. (Cost Inv) Refered To';
            OptionCaption = ' ,Pallet,Collo,Net Weight,Gross Weight';
            OptionMembers = " ",Pallet,Collo,"Net Weight","Gross Weight";
        }
        field(64; "MCS Qty. Colly Sold Duty paid"; Decimal)
        {
            Caption = 'MCS Qty. Colly Sold Duty paid';
        }
        field(65; "MCS Without Allocation"; Boolean)
        {
            Caption = 'Without Allocation';

            trigger OnValidate()
            begin
                IF "MCS Without Allocation" = TRUE THEN
                    "MCS Qty. (Cost Inv.)" := 0;
            end;
        }
        field(66; "MCS Allocation Key"; Option)
        {
            Caption = 'Allocation Key';
            OptionCaption = ' ,Pallets,Kolli,Net Weight,Gross Weight,Lines,Amount,Qty. Cost Inv. - Cr.Memo';
            OptionMembers = " ",Pallets,Kolli,"Net Weight","Gross Weight",Lines,Amount,"Qty. Cost Inv. - Cr.Memo";

            trigger OnValidate()
            var
                lrc_BatchTemp: Record "POI Batch Temp";
            begin
                lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::MCS);
                lrc_BatchTemp.SETRANGE("Userid Code", USERID());
                lrc_BatchTemp.SETFILTER("Entry No.", '<>%1', "Entry No.");
                lrc_BatchTemp.MODIFYALL("MCS Allocation Key", "MCS Allocation Key");
            end;
        }
        field(67; "MCS System"; Boolean)
        {
            Caption = 'System';
        }
        field(68; "MCS Voyage No."; Code[20])
        {
            Caption = 'Voyage No.';
            TableRelation = "POI Voyage";
        }
        field(70; "MCS Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(71; "MCS Item Searchname"; Code[100])
        {
            Caption = 'Item Searchname';
        }
        field(72; "MCS Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
        }
        field(73; "MCS Producer No."; Code[20])
        {
            Caption = 'Producer No.';
        }
        field(74; "MCS Producer Search Name"; Code[50])
        {
            Caption = 'Producer Search Name';
        }
        field(75; "MCS Container No."; Code[20])
        {
            Caption = 'Container No.';
        }
        field(76; "MCS Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(77; "MCS Unit of Measure Desc."; Text[50])
        {
            Caption = 'Unit of Measure Desc.';
        }
        field(78; "MCS Trademark"; Code[20])
        {
            Caption = 'Trademark';
        }
        field(79; "MCS Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
        }
        field(80; "MCS Vendor Search Name"; Code[50])
        {
            Caption = 'Vendor Search Name';
        }
        field(81; "MCS Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            TableRelation = "POI Variety";
        }
        field(82; "MCS Info 4"; Code[20])
        {
            Caption = 'Info 4';
        }
        field(83; "MCS Info 1"; Code[50])
        {
            Caption = 'Info 1';
        }
        field(84; "MCS Info 2"; Code[50])
        {
            Caption = 'Info 2';
        }
        field(85; "MCS Info 3"; Code[20])
        {
            Caption = 'Info 3';
        }
        field(90; "MCS Empties Item No."; Code[20])
        {
            Caption = 'Empties Item No.';
        }
        field(101; "SBV Batch Variant No."; Code[20])
        {
            Caption = 'SBV Batch Variant No.';
        }
        field(102; "SBV Batch No."; Code[20])
        {
            Caption = 'SBV Batch No.';
        }
        field(103; "SBV Master Batch No."; Code[20])
        {
            Caption = 'SBV Master Batch No.';
        }
        field(120; "SBV Location Code"; Code[10])
        {
            Caption = 'Lagerort Code';
        }
        field(121; "SBV Unit of Measure Code"; Code[10])
        {
            Caption = 'SBV Unit of Measure Code';
        }
        field(125; "SBV Quantity"; Decimal)
        {
            Caption = 'SBV Quantity';
        }
    }

    keys
    {
        key(Key1; "Entry Type", "Userid Code", "Entry No.")
        {
        }
        key(Key2; "SBN Batch No.")
        {
        }
    }

    trigger OnInsert()

    begin
        IF "Entry No." = 0 THEN BEGIN
            lrc_BatchTemp.LOCKTABLE();
            lrc_BatchTemp.SETRANGE("Entry Type", "Entry Type");
            lrc_BatchTemp.SETRANGE("Userid Code", "Userid Code");
            IF lrc_BatchTemp.FINDLAST() THEN
                "Entry No." := lrc_BatchTemp."Entry No." + 1
            ELSE
                "Entry No." := 1;
        END;
    end;

    var
        lrc_BatchTemp: Record "POI Batch Temp";
}

