table 5087936 "POI ADF Temp II"
{

    //LookupFormID = Form5088119;

    fields
    {
        field(1; "User ID"; Code[50])
        {
        }
        field(2; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = ' ,Inventory Value,Purch.-Statistic,Posting Add. Freight Cost,Acc. Sales Cost,Calc Cost,Posted Cost,REP,Navigate OSI No,Post Freight Cost';
            OptionMembers = " ","Inventory Value","Purch.-Statistic","Posting Add. Freight Cost","Acc. Sales Cost","Calc Cost","Posted Cost",REP,"Navigate OSI No","Post Freight Cost";
        }
        field(3; "Entry No."; Integer)
        {
        }
        field(100; "BB Master Batch No."; Code[20])
        {
        }
        field(101; "BB Batch No."; Code[20])
        {
        }
        field(102; "BB Batch Variant No."; Code[20])
        {
        }
        field(105; "BB Product Group Code"; Code[10])
        {
        }
        field(107; "BB Item No."; Code[20])
        {
        }
        field(110; "BB Item Description"; Text[30])
        {
        }
        field(115; "BB Stichtag"; Date)
        {
        }
        field(116; "BB Prozentsatz Kosten"; Decimal)
        {
        }
        field(120; "BB Vendor No."; Code[20])
        {
        }
        field(122; "BB Vendor Searchname"; Code[30])
        {
        }
        field(130; "BB Warenabgangsdatum"; Date)
        {
        }
        field(131; "BB Wareneingangsdatum"; Date)
        {
        }
        field(140; "BB Eink. Restmenge"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(141; "BB Eink. Gel. Menge"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(142; "BB Eink. Gesamtmenge"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(147; "BB Eink. Restmenge (Basis)"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(148; "BB Eink. Gel. Menge (Basis)"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(149; "BB Eink. Gesamtmenge (Basis)"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(152; "BB Bestand Aktuell"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(153; "BB Bestand Aktuell (Basis)"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(157; "BB Einkaufsbetrag"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(158; "BB Einkaufskosten"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(160; "BB Einstandsbetrag"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(163; "BB Einstandsbetrag Bestand"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(170; "BB Verk. Restmenge"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(171; "BB Verk. Gel. Menge"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(172; "BB Verk. Gesamtmenge"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(177; "BB Verk. Restmenge (Basis)"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(178; "BB Verk. Gel. Menge (Basis)"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(179; "BB Verk. Gesamtmenge (Basis)"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(210; "BB Verk. Direkte Verk.-Kosten"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(211; "BB Verk. Dir. Verk.Kost. (Ein)"; Decimal)
        {
        }
        field(215; "BB Verk. V+V"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(220; "BB Verk. Erlöse Brutto"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(221; "BB Kosten Verw.,Vertrieb,Marge"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(222; "BB Verk. Vergütungen (Sofort)"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(223; "BB Verk. Frachtkosten"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(224; "BB Umlag. Frachtkosten"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(225; "FREI 225"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(226; "BB Verk. Rab. Rückst. (Extern)"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(227; "BB Verk. Rab. Rückst. (Intern)"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(229; "FREI 229"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(235; "BB Bestand Stichtag"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(236; "BB Bestand Stichtag (Basis)"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(240; "BB Bestandswert Stichtag"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(245; "BB Teilwertabschlag"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(320; "BB Bestand Ist Stichtag"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(321; "BB Bestand Ver. Stichtag"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(322; "BB Bestand Erw. Ver. Stichtag"; Decimal)
        {
            BlankNumbers = BlankZero;
            DecimalPlaces = 0 : 5;
        }
        field(330; "BB Verk. Erlöse Netto I"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(331; "BB Verk. Erlöse Netto II"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(332; "BB Verk. Erlöse Netto III"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(350; "BB Bestandswert Einstand"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(351; "BB Bestandswert Erlöse"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(360; "BB Bestandswert IST"; Decimal)
        {
            BlankNumbers = BlankZero;
        }
        field(500; "ES Item No."; Code[20])
        {
            Caption = 'Item No.';
            Description = 'Einkaufsstatistik';
        }
        field(501; "ES Item Variant Code"; Code[10])
        {
            Caption = 'Item Variant Code';
        }
        field(510; "ES Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(511; "ES Quantity"; Decimal)
        {
            Caption = 'Quantity';
        }
        field(512; "ES Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
        }
        field(513; "ES Qty. per Unit"; Decimal)
        {
            Caption = 'Qty. per Unit';
        }
        field(514; "ES Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
        }
        field(520; "ES Transport Unit of Measure"; Code[10])
        {
            Caption = 'Transport Unit of Measure';
        }
        field(521; "ES Quantity (TU)"; Decimal)
        {
            Caption = 'Quantity (TU)';
        }
        field(700; "FC Batch No."; Code[20])
        {
            Caption = 'FC Positionsnr.';
        }
        field(701; "FC Qty. Pallets"; Decimal)
        {
            Caption = 'FC Mge. Paletten';
        }
        field(702; "FC Qty. Colli"; Decimal)
        {
            Caption = 'FC Mge. Kolli';
        }
        field(703; "FC Total Net Weight"; Decimal)
        {
            Caption = 'FC Total Net Weight';
        }
        field(704; "FC Total Gross Weight"; Decimal)
        {
            Caption = 'FC Total Gross Weight';
        }
        field(720; "FC Posting Amount"; Decimal)
        {
            Caption = 'FC Posting Amount';
        }
        field(800; "AC Cost Category Code"; Code[20])
        {
            Caption = 'AC Cost Category Code';
        }
        field(810; "AC Cost Amount"; Decimal)
        {
            Caption = 'AC Cost Amount';
        }
        field(900; "-- CALC COST --"; Integer)
        {
        }
        field(901; "CC Voyage No."; Code[20])
        {
        }
        field(902; "CC Master Batch No."; Code[20])
        {
        }
        field(903; "CC Batch No."; Code[20])
        {
        }
        field(904; "CC Cost Category Code"; Code[20])
        {
        }
        field(910; "CC Calc. Cost Amount"; Decimal)
        {
        }
        field(912; "CC Calc. Cost Quantity"; Decimal)
        {
        }
        field(950; "-- POSTED COST --"; Integer)
        {
        }
        field(951; "PC Voyage No."; Code[20])
        {
        }
        field(952; "PC Master Batch No."; Code[20])
        {
        }
        field(953; "PC Batch No."; Code[20])
        {
        }
        field(954; "PC Cost Category Code"; Code[20])
        {
        }
        field(965; "PC Posted Cost Amount"; Decimal)
        {
        }
        field(966; "PC Posted. Cost Quantity"; Decimal)
        {
        }
        field(1000; "----"; Integer)
        {
        }
        field(1001; "REP Entry No."; Integer)
        {
        }
        field(1002; "REP Item No."; Code[20])
        {
        }
        field(1003; "REP Ship-to Code"; Code[10])
        {
        }
        field(1004; "REP Region"; Text[50])
        {
        }
        field(1005; "REP Unit of Measure Code"; Code[10])
        {
        }
        field(1006; "REP Value 1 Quantity"; Decimal)
        {
        }
        field(1007; "REP Value 1 Pallets"; Decimal)
        {
        }
        field(1008; "REP Value 1 Amount"; Decimal)
        {
        }
        field(1009; "REP Value 1 Avg. Unit Price"; Decimal)
        {
        }
        field(1010; "REP Value 2 Quantity"; Decimal)
        {
        }
        field(1011; "REP Value 2 Pallets"; Decimal)
        {
        }
        field(1012; "REP Value 2 Amount"; Decimal)
        {
        }
        field(1013; "REP Value 2 Avg. Unit Price"; Decimal)
        {
        }
        field(1014; "REP Value 3 Quantity"; Decimal)
        {
        }
        field(1015; "REP Value 3 Pallets"; Decimal)
        {
        }
        field(1016; "REP Value 3 Amount"; Decimal)
        {
        }
        field(1017; "REP Value 3 Avg. Unit Price"; Decimal)
        {
        }
        field(1018; "REP Value 4 Quantity"; Decimal)
        {
        }
        field(1019; "REP Value 4 Pallets"; Decimal)
        {
        }
        field(1020; "REP Value 4 Amount"; Decimal)
        {
        }
        field(1021; "REP Value 4 Avg. Unit Price"; Decimal)
        {
        }
        field(1022; "REP Value 5 Quantity"; Decimal)
        {
        }
        field(1023; "REP Value 5 Pallets"; Decimal)
        {
        }
        field(1024; "REP Value 5 Amount"; Decimal)
        {
        }
        field(1025; "REP Value 5 Avg. Unit Price"; Decimal)
        {
        }
        field(1026; "REP Value 6 Quantity"; Decimal)
        {
        }
        field(1027; "REP Value 6 Pallets"; Decimal)
        {
        }
        field(1028; "REP Value 6 Amount"; Decimal)
        {
        }
        field(1029; "REP Value 6 Avg. Unit Price"; Decimal)
        {
        }
        field(1030; "REP Value 7 Quantity"; Decimal)
        {
        }
        field(1031; "REP Value 7 Pallets"; Decimal)
        {
        }
        field(1032; "REP Value 7 Amount"; Decimal)
        {
        }
        field(1033; "REP Value 7 Avg. Unit Price"; Decimal)
        {
        }
        field(1034; "REP Value Total Quantity"; Decimal)
        {
        }
        field(1035; "REP Value Total Pallets"; Decimal)
        {
        }
        field(1036; "REP Value Total Amount"; Decimal)
        {
        }
        field(1037; "REP Value Total Avg.Unit Price"; Decimal)
        {
        }
        field(1038; "REP Value 1 Org. Quantity"; Decimal)
        {
        }
        field(1039; "REP Value 2 Org. Quantity"; Decimal)
        {
        }
        field(1040; "REP Value 3 Org. Quantity"; Decimal)
        {
        }
        field(1041; "REP Value 4 Org. Quantity"; Decimal)
        {
        }
        field(1042; "REP Value 5 Org. Quantity"; Decimal)
        {
        }
        field(1043; "REP Value 6 Org. Quantity"; Decimal)
        {
        }
        field(1044; "REP Value 7 Org. Quantity"; Decimal)
        {
        }
        field(1045; "REP Value Total Org. Quantity"; Decimal)
        {
        }
        field(1046; "REP No."; Integer)
        {
        }
        field(1500; "Post Freight Cost"; Integer)
        {
        }
        field(1510; "Freight Shipping Agent Code"; Code[10])
        {
            Caption = 'Freight Shipping Agent Code';
        }
        field(1511; "Freight Departure Region Code"; Code[20])
        {
            Caption = 'Freight Departure Region Code';
        }
        field(1520; "Freight Sales G/L Acc. No"; Code[20])
        {
            Caption = 'Freight Sales G/L Acc. No';
        }
        field(1521; "Freight Sales Bal. G/L Acc. No"; Code[20])
        {
            Caption = 'Freight Sales Bal. G/L Acc. No';
        }
        field(1522; "Freight Sales Amout Deb./Cred."; Option)
        {
            Caption = 'Freight Sales Amout Deb./Cred.';
            OptionCaption = 'Soll,Haben';
            OptionMembers = Soll,Haben;
        }
        field(1523; "Freight Sales Change Sign"; Boolean)
        {
            Caption = 'Freight Sales Change Sign';
        }
        field(1530; "Freight Debit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Freight Debit Amount';
        }
        field(1531; "Freight Credit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Freight Credit Amount';
        }
        field(1532; "Freight Sales Description"; Text[50])
        {
            Caption = 'Freight Sales Description';
        }
        field(1540; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(1541; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(1542; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(1543; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(2000; "OSI Source"; Option)
        {
            Caption = 'Source';
            Description = 'Order Shipment Invoice Number';
            OptionCaption = 'Sales Order,Sales Shipment,Sales Invoice,Sales Credit Memo';
            OptionMembers = "Sales Order","Sales Shipment","Sales Invoice","Sales Credit Memo";
        }
        field(2001; "OSI Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(2002; "OSI Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(2005; "OSI Sales Order No."; Code[20])
        {
            Caption = 'OSI Sales Order No.';
        }
        field(2010; "OSI Item No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "User ID", "Entry Type", "Entry No.")
        {
        }
        key(Key2; "BB Batch No.", "BB Batch Variant No.")
        {
        }
        key(Key3; "BB Product Group Code", "BB Item No.")
        {
        }
        key(Key4; "CC Master Batch No.", "CC Cost Category Code")
        {
        }
        key(Key5; "REP Region", "REP Ship-to Code", "REP Item No.", "REP Unit of Measure Code")
        {
        }
        key(Key6; "OSI Sales Order No.", "OSI Source", "OSI Source No.")
        {
        }
        key(Key7; "Freight Shipping Agent Code", "Freight Departure Region Code", "BB Batch No.", "Freight Sales G/L Acc. No", "Freight Sales Bal. G/L Acc. No", "Freight Sales Amout Deb./Cred.", "Freight Sales Change Sign", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code")
        {
        }
    }

    trigger OnInsert()

    begin
        IF "Entry No." = 0 THEN BEGIN
            lrc_FruitVisionTempII.SETRANGE("User ID", USERID());
            lrc_FruitVisionTempII.SETRANGE("Entry Type", "Entry Type");
            IF lrc_FruitVisionTempII.FIND('+') THEN
                "Entry No." := lrc_FruitVisionTempII."Entry No." + 1
            ELSE
                "Entry No." := 1;
        END;
    end;

    var
        lrc_FruitVisionTempII: Record "POI ADF Temp II";
}

