table 5110726 "POI PaOrder Rev. per Inp.Batch"
{

    Caption = 'Pack. Order Rev. per Inp.Batch';
    // DrillDownFormID = Form5110724;
    // LookupFormID = Form5110724;

    fields
    {
        field(1; "Doc. No."; Code[20])
        {
            Caption = 'Doc. No.';
        }
        field(2; "Doc. Line No. Output"; Integer)
        {
            Caption = 'Doc. Line No. Output';
            TableRelation = "POI Pack. Order Output Items"."Line No." WHERE("Doc. No." = FIELD("Doc. No."));
        }
        field(4; "Doc. Line No. Input"; Integer)
        {
            Caption = 'Doc. Line No. Input';
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No." WHERE("POI Item Typ" = CONST("Trade Item"));
        }
        field(11; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(12; "Input Master Batch No."; Code[20])
        {
            Caption = 'Input Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(13; "Input Batch No."; Code[20])
        {
            Caption = 'Input Batch No.';
            TableRelation = "POI Batch";
        }
        field(14; "Input Batch Variant No."; Code[20])
        {
            Caption = 'Input Batch Variant No.';
            TableRelation = "POI Batch Variant";
        }
        field(16; "Output Master Batch No."; Code[20])
        {
            Caption = 'Output Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(17; "Output Batch No."; Code[20])
        {
            Caption = 'Output Batch No.';
            TableRelation = "POI Batch";
        }
        field(18; "Output Batch Variant No."; Code[20])
        {
            Caption = 'Output Batch Variant No.';
            TableRelation = "POI Batch Variant";
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(21; "Posting Doc. No."; Code[20])
        {
            Caption = 'Posting Document No.';
        }
        field(22; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(23; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(24; "Posting Doc. Line No."; Integer)
        {
            Caption = 'Posting Document Line No.';
        }
        field(25; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(26; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(27; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
        }
        field(28; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
        }
        field(29; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Basiseinheitencode';
            TableRelation = "Unit of Measure";
        }
        field(32; "Input Location Code"; Code[10])
        {
            Caption = 'Input Lagerortcode';
            TableRelation = Location;
        }
        field(33; "Output Location Code"; Code[10])
        {
            Caption = 'Output Lagerortcode';
            TableRelation = Location;
        }
        field(40; "Gross Amount (LCY)"; Decimal)
        {
            Caption = 'Gross Amount (LCY)';
        }
        field(41; "DSD/ARA Amount (LCY)"; Decimal)
        {
            Caption = 'DSD/ARA Amount (LCY)';
        }
        field(42; "Freight Costs Amount (LCY)"; Decimal)
        {
            Caption = 'Freight Costs Amount (LCY)';
        }
        field(43; "Inv. Disc. (Actual)"; Decimal)
        {
            Caption = 'Rechnungsrabatt (Actual)';
        }
        field(44; "Rg.-Rab. ohne Wbz. (Act)"; Decimal)
        {
            Caption = 'Rg.-Rab. ohne Wbz. (Act)';
        }
        field(45; "Accruel Inv. Disc. (Internal)"; Decimal)
        {
            Caption = 'Rückst. Rg.-Rab. Betrag (Intern)';
        }
        field(46; "Accruel Inv. Disc. (External)"; Decimal)
        {
            Caption = 'Rückst. Rg.-Rab. Betrag (Extern)';
        }
        field(49; "Net Amount (LCY)"; Decimal)
        {
            Caption = 'Net Amount (LCY)';
        }
        field(59; "Input Packing Cost (LCY)"; Decimal)
        {
            Caption = 'Input Packing Cost (LCY)';
        }
        field(60; "Total Packing Cost (LCY)"; Decimal)
        {
            Caption = 'Total Packing Cost (LCY)';
        }
        field(70; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            TableRelation = "Item Ledger Entry";
        }
        field(71; "Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            OptionCaption = ' ,Payed,Not Payed';
            OptionMembers = " ",Payed,"Not Payed";
        }
        field(72; "Sales Order Doc. No."; Code[20])
        {
            Caption = 'Sales Order Doc. No.';
        }
        field(73; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
        }
        field(80; "Amount (LCY)"; Decimal)
        {
            Caption = 'Betrag (MW)';
        }
        field(90; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(91; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
        }
        field(100; "Revenue Quantity"; Decimal)
        {
            Caption = 'Revenue Quantity';
        }
        field(101; "Revenue Quantity (Base)"; Decimal)
        {
            Caption = 'Revenue Quantity (Base)';
        }
        field(102; "Revenue Qty. per UnitofMeasure"; Decimal)
        {
            Caption = 'Revenue Qty. per Unit of Measure';
        }
        field(110; "Output Qty. Quota"; Decimal)
        {
            Caption = 'Output Qty. Quota';
            Description = 'POI60049';
        }
        field(111; "Output Qty. Quota (Base)"; Decimal)
        {
            Caption = 'Anteil. Menge (Output) (Basis)';
        }
    }

    keys
    {
        key(Key1; "Doc. No.", "Doc. Line No. Output", "Doc. Line No. Input", "Line No.")
        {
        }
        key(Key2; "Posting Date", "Customer No.")
        {
        }
        key(Key3; "Posting Date", "Item No.")
        {
        }
        key(Key4; "Input Batch Variant No.")
        {
            SumIndexFields = "Output Qty. Quota (Base)";
        }
        key(Key5; "Input Master Batch No.")
        {
        }
        key(Key6; "Input Batch No.")
        {
        }
        key(Key7; "Output Master Batch No.")
        {
        }
    }

    trigger OnInsert()
    begin
        IF "Line No." = 0 THEN BEGIN
            lrc_PackOrderRevperInpBatch.Reset();
            lrc_PackOrderRevperInpBatch.SETRANGE("Doc. No.", "Doc. No.");
            lrc_PackOrderRevperInpBatch.SETRANGE("Doc. Line No. Output", "Doc. Line No. Output");
            lrc_PackOrderRevperInpBatch.SETRANGE("Doc. Line No. Input", "Doc. Line No. Input");
            IF lrc_PackOrderRevperInpBatch.FIND('+') THEN
                "Line No." := lrc_PackOrderRevperInpBatch."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;
    end;

    var
        lrc_PackOrderRevperInpBatch: Record "POI PaOrder Rev. per Inp.Batch";
}

