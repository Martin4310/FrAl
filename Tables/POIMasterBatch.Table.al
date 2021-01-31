table 50903 "POI Master Batch"
{
    Caption = 'Master Batch';
    // DrillDownFormID = Form5110480;
    // LookupFormID = Form5110480;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(10; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                lrc_Vendor: Record "Vendor";
            begin
                IF lrc_Vendor.GET("Vendor No.") THEN
                    "Vendor Search Name" := COPYSTR(lrc_Vendor."Search Name", 1, 30)
                ELSE
                    "Vendor Search Name" := '';
            end;
        }
        field(11; "Vendor Search Name"; Text[30])
        {
            Caption = 'Vendor Search Name';
        }
        field(12; "Producer No."; Code[20])
        {
            Caption = 'Producer No.';
            ///???TableRelation = Vendor WHERE (Is Manufacturer=CONST(Yes));
        }
        field(18; "Batch Postfix Counter"; Integer)
        {
            Caption = 'Batch Postfix Counter';
        }
        field(20; Source; Option)
        {
            Caption = 'Source';
            Description = ' ,Purch. Order,Packing Order,Sorting Order,,Item Journal Line,Inventory Journal Line,,,Company Copy';
            OptionCaption = ' ,Purch. Order,Packing Order,Sorting Order,,Item Journal Line,Inventory Journal Line,Assortment,,Company Copy,,,Dummy';
            OptionMembers = " ","Purch. Order","Packing Order","Sorting Order",,"Item Journal Line","Inventory Journal Line",Assortment,,"Company Copy",,,Dummy;
        }
        field(21; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST("Purch. Order")) "Purchase Header"."No." WHERE("Document Type" = CONST(Order))
            ELSE
            IF (Source = CONST("Packing Order")) "POI Pack. Order Header"."No.";
        }
        field(23; "Purchaser Code"; Code[20])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser" WHERE("POI Is Purchaser" = CONST(true));
        }
        field(24; "Person in Charge Code"; Code[20])
        {
            Caption = 'Person in Charge Code';
            TableRelation = "Salesperson/Purchaser" WHERE("POI Is Sales Agent Person" = CONST(true));
        }
        field(28; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(29; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(30; "Cost Schema Name Code"; Code[20])
        {
            Caption = 'Cost Schema Name Code';
            TableRelation = "POI Cost Schema Name";
        }
        field(45; State; Option)
        {
            Caption = 'State';
            Description = 'New,Opened,Closed,Account Sale,Blocked,Manuel Blocked,Deleted';
            OptionCaption = 'New,Opened,Closed,Account Sale,Blocked,Manual Blocked,Deleted';
            OptionMembers = New,Opened,Closed,"Account Sale",Blocked,"Manual Blocked",Deleted;
        }
        field(50; "Entry Date"; Date)
        {
            Caption = 'Entry Date';
        }
        field(55; "Purch. Doc. Subtype Code"; Code[10])
        {
            Caption = 'Purch. Doc. Subtype Code';
        }
        field(56; "Order Type"; Option)
        {
            Caption = 'Auftragsart';
            Description = ' ,Wholesaler-To-Client,Agency';
            OptionCaption = ' ,Wholesaler-To-Client,Agency';
            OptionMembers = " ","Wholesaler-To-Client",Agency;
        }
        field(57; "Your Reference"; Text[70])
        {
            Caption = 'Your Reference';
        }
        field(58; "Vendor Order No."; Code[35])
        {
            Caption = 'Vendor Order No.';
        }
        field(59; "Receipt Info"; Text[30])
        {
            Caption = 'Receipt Info';
        }
        field(60; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(61; "Location Reference No."; Code[20])
        {
            Caption = 'Location Reference No.';
        }
        field(65; "Kind of Settlement"; Option)
        {
            Caption = 'Kind of Settlement';
            Description = 'Fixed Price,Commission,Account Sale + Commission';
            OptionCaption = 'Fix Price,Commission,Account Sale+Commission';
            OptionMembers = "Fixed Price",Commission,"Account Sale + Commission";
        }
        field(67; "Waste Disposal Duty"; Option)
        {
            Caption = 'Waste Disposal Duty';
            Description = ' ,Green Point Duty';
            OptionCaption = ' ,Green Point Duty';
            OptionMembers = " ","Green Point Duty";
        }
        field(68; "Waste Disposal Payment Thru"; Option)
        {
            Caption = 'Waste Disposal Payment Thru';
            Description = 'Us,Vendor';
            OptionCaption = 'Us,Vendor';
            OptionMembers = Us,Vendor;
        }
        field(70; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(71; "Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            Description = ' ,Payed,Not Payed';
            OptionCaption = ' ,Payed,Not Payed';
            OptionMembers = " ",Payed,"Not Payed";
        }
        field(73; "Clearing by Vendor No."; Code[20])
        {
            Caption = 'Clearing by Vendor No.';
            TableRelation = Vendor."No." WHERE("POI Customs Agent" = CONST(true));
        }
        field(74; "Fiscal Agent Code"; Code[10])
        {
            Caption = 'Fiscal Agent Code';
            NotBlank = true;
            TableRelation = Vendor."No." where("POI Tax Representative" = const(true));
        }
        field(75; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(80; "Voyage No."; Code[20])
        {
            Caption = 'Voyage No.';
            TableRelation = "POI Voyage";
        }
        field(81; "Means of Transport Type"; Option)
        {
            Caption = 'Means of Transport Type';
            Description = ' ,Truck,Train,Ship,Airplane';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;
        }
        field(82; "Means of Transp. Code (Arriva)"; Code[20])
        {
            Caption = 'Means of Transp. Code (Arriva)';
            // TableRelation = "Means of Transport".Code WHERE (Type=FIELD("Means of Transport Type"));
            // ValidateTableRelation = false;
        }
        field(83; "Means of Transport Info"; Code[30])
        {
            Caption = 'Means of Transport Info';
            // TableRelation = "Means of Transport Info".Code;
            // ValidateTableRelation = false;
        }
        field(84; "Means of Transp. Code (Depart)"; Code[20])
        {
            Caption = 'Means of Transp. Code (Depart)';
            // TableRelation = "Means of Transport".Code WHERE (Type=FIELD(Means of Transport Type));
            // ValidateTableRelation = false;
        }
        field(85; "Kind of Loading"; Option)
        {
            Caption = 'Kind of Loading';
            Description = ' ,Container,Reefer Vessel,Container and Reefer Vessel';
            OptionCaption = ' ,Container,Reefer Vessel,Container and Reefer Vessel';
            OptionMembers = " ",Container,"Reefer Vessel","Container and Reefer Vessel";
        }
        field(87; "Departure Region Code"; Code[20])
        {
            Caption = 'Departure Region Code';
            TableRelation = "POI Departure Region";
        }
        field(88; "Port of Discharge Code (UDE)"; Code[10])
        {
            Caption = 'Port of Discharge Code (UDE)';
            ///???TableRelation = Harbour;
        }
        field(90; "Departure Date"; Date)
        {
            Caption = 'Departure Date';
        }
        field(91; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
        }
        field(92; "Expected Receipt Time"; Time)
        {
            Caption = 'Expected Receipt Time';
        }
        field(94; "Container Code"; Code[20])
        {
            Caption = 'Container Code';
        }
        field(95; "Quality Control Vendor No."; Code[20])
        {
            Caption = 'Quality Control Vendor No.';
            ///???TableRelation = Vendor WHERE (Is Quality Controller=CONST(true));
        }
        field(97; "Company Season Code"; Code[10])
        {
            Caption = 'Company Season Code';
            ///???TableRelation = "Company Season";
        }
        field(98; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            TableRelation = "Country/Region";
        }
        field(100; "No. of Open Acc. Sales"; Integer)
        {
            ///???CalcFormula = Count("Acc. Sales Header" WHERE ("Master Batch No."=FIELD("No."),Status=CONST(Open)));
            Caption = 'No. of Open Acc. Sales';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "No. of Posted Acc. Sales"; Integer)
        {
            ///???CalcFormula = Count("Acc. Sales Header" WHERE ("Master Batch No."=FIELD("No."),Status=FILTER(Posted|Closed)));
            Caption = 'No. of Posted Acc. Sales';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "No. of Batches"; Integer)
        {
            CalcFormula = Count ("POI Batch" WHERE("Master Batch No." = FIELD("No.")));
            Caption = 'No. of Batches';
            Editable = false;
            FieldClass = FlowField;
        }
        field(106; "No. of Batch Variants"; Integer)
        {
            ///???CalcFormula = Count("Batch Variant" WHERE (Master Batch No.=FIELD(No.)));
            Caption = 'No. of Batch Variants';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; "Date of Discharge"; Date)
        {
            Caption = 'Date of Discharge';
        }
        field(111; "Time of Discharge"; Time)
        {
            Caption = 'Time of Discharge';
        }
        field(190; Comment; Boolean)
        {
            ///???CalcFormula = Exist("Batch Comment" WHERE (Source=CONST(Master Batch),Source No.=FIELD(No.)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(200; "Purchases (Qty.)"; Decimal)
        {
            ///???CalcFormula = Sum("Batch Variant Entry"."Quantity (Base)" WHERE (Item Ledger Entry Type=CONST(Purchase),Master Batch No.=FIELD(No.)));
            Caption = 'Purchases (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(201; "Sales (Qty.)"; Decimal)
        {
            ///???CalcFormula = Sum("Batch Variant Entry"."Quantity (Base)" WHERE (Item Ledger Entry Type=CONST(Sale),Master Batch No.=FIELD(No.)));
            Caption = 'Sales (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(202; "Positive Adjmt. (Qty.)"; Decimal)
        {
            ///???CalcFormula = Sum("Batch Variant Entry"."Quantity (Base)" WHERE (Item Ledger Entry Type=CONST(Positive Adjmt.),Master Batch No.=FIELD(No.)));
            Caption = 'Positive Adjmt. (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(203; "Negative Adjmt. (Qty.)"; Decimal)
        {
            ///???CalcFormula = Sum("Batch Variant Entry"."Quantity (Base)" WHERE (Item Ledger Entry Type=CONST(Negative Adjmt.),Master Batch No.=FIELD(No.)));
            Caption = 'Negative Adjmt. (Qty.)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(500; "Amount Calc Cost (LCY)"; Decimal)
        {
            ///???CalcFormula = Sum("Cost Calc. - Enter Data"."Amount (LCY)" WHERE (Master Batch No.=FIELD(No.),Entry Type=CONST(Enter Data)));
            Caption = 'Amount Calc Cost (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000; "Departure Location Code"; Code[20])
        {
            Caption = 'Abgangslager';
        }
        field(90050; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(90051; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(90052; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(90053; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; Source, "Source No.")
        {
        }
        key(Key3; "Vendor No.")
        {
        }
        key(Key4; "Vendor No.", "Expected Receipt Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Documents2: Record "POI Documents";
        lrc_BatchSourceInfo: Record "POI Batch Info Details";
    begin
        // Löschen Positionen
        // Löschen Positionsvarianten
        Documents2.RESET();
        Documents2.SETCURRENTKEY("Document Type", "Document No.", "Master Batch No.", "Entry Type", Area);
        Documents2.SETRANGE("Document Type", Documents2."Document Type"::Masterdata);
        Documents2.SETRANGE("Document No.");
        Documents2.SETRANGE("Master Batch No.", "No.");
        Documents2.SETRANGE("Entry Type", Documents2."Entry Type"::Document);
        Documents2.SETRANGE(Area, Documents2.Area::"Master Batch");
        IF Documents2.FIND('-') THEN
            Documents2.DELETEALL(TRUE);



        lrc_BatchSourceInfo.RESET();
        lrc_BatchSourceInfo.SETRANGE("Batch Source Type", lrc_BatchSourceInfo."Batch Source Type"::"Master Batch No.");
        lrc_BatchSourceInfo.SETRANGE("Batch Source No.", "No.");
        IF lrc_BatchSourceInfo.FIND('-') THEN
            lrc_BatchSourceInfo.DELETEALL(TRUE);

    end;

    trigger OnInsert()
    var
        BatchSetup: Record "POI Master Batch Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DummyCode: Code[20];
    begin
        clear(DummyCode);
        // Wenn die Partienummer nicht geladen ist, wird auf den Nummernkreis gemäß
        // Einrichtungstabelle zugegriffen
        IF "No." = '' THEN BEGIN
            BatchSetup.GET();
            BatchSetup.TESTFIELD("Purch. Master Batch No. Series");
            NoSeriesManagement.InitSeries(BatchSetup."Purch. Master Batch No. Series", DummyCode, 0D, "No.", DummyCode);
        END;
        "Entry Date" := TODAY();
    end;
}

