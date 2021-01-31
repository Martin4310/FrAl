table 5110560 "POI Location Bins"
{

    Caption = 'Location Bins';
    // DrillDownFormID = Form5087958;
    // LookupFormID = Form5087958;

    fields
    {
        field(1; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(16; "Maximum Number Of Pallets"; Integer)
        {
            Caption = 'Maximum Number Of Pallets';
        }
        field(20; "Filled Number Of Pallets"; Integer)
        {
            CalcFormula = Count ("POI Location Bin - Pallet No." WHERE("Location Code" = FIELD("Location Code"),
                                                                    "Location Bin Code" = FIELD(Code)));
            Caption = 'Filled Number Of Pallets';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(40; Corridor; Code[10])
        {
            Caption = 'Corridor';
        }
        field(42; Cell; Code[10])
        {
            Caption = 'Cell';
        }
        field(46; Level; Code[10])
        {
            Caption = 'Level';
        }
        field(48; Deep; Code[10])
        {
            Caption = 'Deep';
        }
    }

    keys
    {
        key(Key1; "Location Code", "Code")
        {
        }
        key(Key2; "Location Code", Corridor, Cell, "Code")
        {
        }
        key(Key3; "Location Code", Corridor, Cell, Level, Deep, "Code")
        {
        }
    }


    trigger OnDelete()
    var
        lrc_LocationBinPalletNo: Record "POI Location Bin - Pallet No.";
    begin
        CALCFIELDS("Filled Number Of Pallets");
        TESTFIELD("Filled Number Of Pallets", 0);

        lrc_LocationBinPalletNo.RESET();
        lrc_LocationBinPalletNo.SETRANGE("Location Code", "Location Code");
        lrc_LocationBinPalletNo.SETRANGE("Location Bin Code", Code);
        IF lrc_LocationBinPalletNo.FIND('-') THEN
            lrc_LocationBinPalletNo.DELETEALL(TRUE);
    end;
}

