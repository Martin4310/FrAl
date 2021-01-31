table 5110524 "POI Transfer Empties"
{

    Caption = 'Transfer Empties';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(8; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item WHERE("POI Item Typ" = FILTER("Empties Item" | "Transport Item"));

            trigger OnValidate()
            var
                lrc_Item: Record Item;
            begin
                IF xRec."Item No." <> Rec."Item No." THEN BEGIN
                    TESTFIELD("Ship. Qty. to Ship", 0);
                    TESTFIELD("Ship. Qty. Invoiced", 0);
                END;

                IF "Item No." <> '' THEN BEGIN
                    lrc_Item.GET("Item No.");
                    "Unit of Measure Code" := lrc_Item."Sales Unit of Measure";
                    "Item Description" := lrc_Item.Description;
                    "Item Description 2" := lrc_Item."Description 2";
                    "Item Typ" := lrc_Item."POI Item Typ";
                END ELSE BEGIN
                    "Unit of Measure Code" := '';
                    "Item Description" := '';
                    "Item Description 2" := '';
                END;
            end;
        }
        field(9; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

            trigger OnValidate()
            begin
                IF xRec."Location Code" <> Rec."Location Code" THEN BEGIN
                    TESTFIELD("Ship. Qty. to Ship", 0);
                    TESTFIELD("Ship. Qty. Invoiced", 0);
                END;
            end;
        }
        field(10; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(11; "Item Description 2"; Text[50])
        {
            Caption = 'Item Description 2';
        }
        field(14; "Item Typ"; Option)
        {
            Caption = 'Item Typ';
            OptionCaption = 'Trade Item,,Empties Item,Transport Item,,Packing Material,,,Spare Parts';
            OptionMembers = "Trade Item",,"Empties Item","Transport Item",,"Packing Material",,,"Spare Parts";
        }
        field(15; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(19; "Ship. Calc. Quantity"; Decimal)
        {
            Caption = 'Ship. Calc. Quantity';
        }
        field(20; "Ship. Quantity"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(22; "Ship. Refund Price"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Refund Price';

            trigger OnValidate()
            begin
                "Ship. Refund Amount" := "Ship. Refund Price" * "Ship. Quantity";
            end;
        }
        field(24; "Ship. Refund Amount"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Refund Amount';
        }
        field(30; "Ship. Qty. to Ship"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Qty. to Ship';
            DecimalPlaces = 0 : 5;
        }
        field(31; "Ship. Qty. Shipped"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Qty. Shipped';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(33; "Ship. Qty. to Invoice"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Qty. to Invoice';
            DecimalPlaces = 0 : 5;
        }
        field(34; "Ship. Qty. Invoiced"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Qty. Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(35; "Ship. Qty. to Transfer"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Qty. to Transfer';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(36; "Ship. Qty. Transfered"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Qty. Transfered';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(80; "Empties Allocation"; Option)
        {
            Caption = 'Empties Allocation';
            Description = 'LVW';
            OptionCaption = 'Without Stock-Keeping Without Invoice,With Stock-Keeping Without Invoice,With Stock-Keeping With Invoice';
            OptionMembers = "Without Stock-Keeping Without Invoice","With Stock-Keeping Without Invoice","With Stock-Keeping With Invoice";
        }
        field(81; "Empties Calculation"; Option)
        {
            Caption = 'Empties Calculation';
            Description = 'LVW';
            OptionCaption = ' ,Same Document,Separat Document,Combine Document';
            OptionMembers = " ","Same Document","Separat Document","Combine Document";
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
        key(Key2; "Item No.", "Location Code")
        {
        }
    }

    trigger OnInsert()

    begin
        IF "Line No." = 0 THEN BEGIN
            lrc_TransferEmpties.RESET();
            lrc_TransferEmpties.SETRANGE("Document No.", "Document No.");
            IF lrc_TransferEmpties.FIND('+') THEN
                "Line No." := lrc_TransferEmpties."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;
    end;

    var
        lrc_TransferEmpties: Record "POI Transfer Empties";
}

