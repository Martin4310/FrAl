table 50905 "POI Batch Variant"
{
    Caption = 'Batch Variant';
    DataCaptionFields = "No.", Description;
    // DrillDownFormID = Form5110482;
    // LookupFormID = Form5110482;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(9; "No. 2"; Code[20])
        {
            Caption = 'No. 2';
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(11; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(12; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
        }
        field(15; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            NotBlank = true;
            TableRelation = "POI Master Batch";
        }
        field(16; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            NotBlank = true;
            TableRelation = "POI Batch";
        }
        field(20; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("Item No.") THEN
                    ItemNo_Validate();
            end;
        }
        field(21; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(23; "Type of Packing Product"; Option)
        {
            Caption = 'Type of Packing Product';
            OptionCaption = ' ,Finished Product,,,Industry Goods,,,Fruit Juice,,,Spoilt,,,Sub-/Out-Size';
            OptionMembers = " ","Finished Product",,,"Industry Goods",,,"Fruit Juice",,,Spoilt,,,"Sub-/Out-Size";
        }
        field(24; "Item Main Category Code"; Code[10])
        {
            Caption = 'Item Main Category Code';
            TableRelation = "POI Item Main Category";
        }
        field(25; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(26; "Product Group Code"; Code[20])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
        }
        field(31; "Blocked from User ID"; Code[20])
        {
            Caption = 'Blocked from User ID';
            Editable = false;
            TableRelation = User."Application ID";
        }
        field(32; "Date of Blocking"; Date)
        {
            Caption = 'Date of Blocking';
            Editable = false;
        }
        field(33; "Time of Blocking"; Time)
        {
            Caption = 'Time of Blocking';
            Editable = false;
        }
        field(34; "Blocking Comment"; Text[80])
        {
            Caption = 'Blocking Comment';
        }
        field(35; "Released from User ID"; Code[20])
        {
            Caption = 'Released from User ID';
            Editable = false;
            ///???TableRelation = User."User ID";
        }
        field(36; "Date of Releasing"; Date)
        {
            Caption = 'Date of Releasing';
            Editable = false;
        }
        field(37; "Time of Releasing"; Time)
        {
            Caption = 'Time of Releasing';
            Editable = false;
        }
        field(39; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(40; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                lrc_Vendor: Record "Vendor";
            begin
                IF CurrFieldNo = FIELDNO("Vendor No.") THEN BEGIN
                    "Vendor Search Name" := '';
                    IF "Vendor No." <> '' THEN
                        IF lrc_Vendor.GET("Vendor No.") THEN
                            "Vendor Search Name" := lrc_Vendor."Search Name";
                END;
            end;
        }
        field(41; "Vendor Search Name"; Code[100])
        {
            Caption = 'Vendor Search Name';
        }
        field(42; "Producer No."; Code[20])
        {
            Caption = 'Producer No.';
            TableRelation = Manufacturer;
        }
        field(43; "Lot No. Producer"; Code[30])
        {
            Caption = 'Lot No. Producer';
        }
        field(44; "B/L Shipper"; Code[20])
        {
            Caption = 'B/L Shipper';
            TableRelation = Vendor."No.";
        }
        field(45; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            TableRelation = "Country/Region";
        }
        field(46; "Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            ///???TableRelation = Variety;
        }
        field(47; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            ///???TableRelation = Trademark;
        }
        field(48; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            ///???TableRelation = Caliber;
        }
        field(49; "Vendor Caliber Code"; Code[10])
        {
            Caption = 'Vendor Caliber Code';
            ///???TableRelation = "Caliber - Vendor Caliber"."Vend. Caliber Code";
        }
        field(50; "Item Attribute 3"; Code[10])
        {
            CaptionClass = '5110310,1,3';
            Caption = 'Quality Code';
            ///???TableRelation = "Item Attribute 3";
        }
        field(51; "Item Attribute 2"; Code[10])
        {
            CaptionClass = '5110310,1,2';
            Caption = 'Color Code';
            ///???TableRelation = "Item Attribute 2";
        }
        field(52; "Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            ///???TableRelation = "Grade of Goods";
        }
        field(53; "Item Attribute 7"; Code[10])
        {
            CaptionClass = '5110310,1,7';
            Caption = 'Conservation Code';
            ///???TableRelation = "Item Attribute 7";
        }
        field(54; "Item Attribute 4"; Code[10])
        {
            CaptionClass = '5110310,1,4';
            Caption = 'Packing Code';
            ///???TableRelation = "Item Attribute 4";
        }
        field(55; "Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            ///???TableRelation = Coding;
        }
        field(56; "Item Attribute 5"; Code[10])
        {
            CaptionClass = '5110310,1,5';
            Caption = 'Treatment Code';
            ///???TableRelation = "Item Attribute 5";
        }
        field(57; "Item Attribute 6"; Code[20])
        {
            CaptionClass = '5110310,1,6';
            Caption = 'Proper Name Code';
            ///???TableRelation = "Proper Name";
        }
        field(58; "Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;
        }
        field(60; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
        }
        field(61; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 5;
        }
        field(63; "Cultivation Association Code"; Code[10])
        {
            Caption = 'Cultivation Association Code';
            Description = 'EIA';
            ///???TableRelation = "Cultivation Association";
        }
        field(64; "Item Attribute 1"; Code[10])
        {
            CaptionClass = '5110310,1,1';
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            ///???TableRelation = "Item Attribute 1";
        }
        field(65; "Empties Posting Item No."; Code[20])
        {
            Caption = 'Empties Posting Item No.';
            TableRelation = Item;
        }
        field(66; "Empties Item No."; Code[20])
        {
            Caption = 'Empties Item No.';
            ///???TableRelation = Item WHERE (Item Typ=CONST(Empties Item));

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("Empties Item No.") THEN
                    EmptiesItemNo_Validate();
            end;
        }
        field(67; "Empties Quantity"; Decimal)
        {
            Caption = 'Empties Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(68; "Departure Date"; Date)
        {
            Caption = 'Departure Date';

            // trigger OnLookup()
            // begin
            //     IF gcu_GlobalFunctionsMgt.SelectDateByCalendar("Departure Date") THEN
            //         VALIDATE("Departure Date");
            // end;
        }
        field(69; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(70; "Date of Delivery"; Date)
        {
            Caption = 'Date of Delivery';

            // trigger OnLookup()
            // var
            //     lcu_GlobalFunctionsMgt: Codeunit "5110300";
            // begin
            //     IF gcu_GlobalFunctionsMgt.SelectDateByCalendar("Date of Delivery") THEN
            //         VALIDATE("Date of Delivery");
            // end;
        }
        field(71; "Date of Expiry"; Date)
        {
            Caption = 'Date of Expiry';

            // trigger OnLookup()
            // begin
            //     IF gcu_GlobalFunctionsMgt.SelectDateByCalendar("Date of Expiry") THEN
            //         VALIDATE("Date of Expiry");
            // end;
        }
        field(80; "Kind of Settlement"; Option)
        {
            Caption = 'Kind of Settlement';
            OptionCaption = 'Fix Price,Commission,Account Sale+Commission';
            OptionMembers = "Fix Price",Commission,"Account Sale+Commission";
        }
        field(82; Weight; Option)
        {
            Caption = 'Weight';
            OptionCaption = ' ,Net Weight,Gross Weight,Manuel Weight';
            OptionMembers = " ","Net Weight","Gross Weight","Manuel Weight";
        }
        field(89; "Entry via Transfer Loc. Code"; Code[10])
        {
            Caption = 'Entry via Transfer Loc. Code';
            TableRelation = Location;
        }
        field(90; "Entry Location Code"; Code[10])
        {
            Caption = 'Entry Location Code';
            TableRelation = Location;
        }
        field(91; "Location Reference No."; Code[20])
        {
            Caption = 'Location Reference No.';
        }
        field(92; "Shelf No."; Code[10])
        {
            Caption = 'Shelf No.';
        }
        field(95; "Info 1"; Code[30])
        {
            CaptionClass = '5110300,1,1';
            Caption = 'Info 1';
            Description = 'BSI';
        }
        field(96; "Info 2"; Code[50])
        {
            CaptionClass = '5110300,1,2';
            Caption = 'Info 2';
            Description = 'BSI';
        }
        field(97; "Info 3"; Code[20])
        {
            CaptionClass = '5110300,1,3';
            Caption = 'Info 3';
            Description = 'BSI';
        }
        field(98; "Info 4"; Code[20])
        {
            CaptionClass = '5110300,1,4';
            Caption = 'Info 4';
            Description = 'BSI';
        }
        field(100; "Kind of Loading"; Option)
        {
            Caption = 'Kind of Loading';
            Description = ' ,Container,Reefer Vessel';
            OptionCaption = ' ,Container,Reefer Vessel';
            OptionMembers = " ",Container,"Reefer Vessel";
        }
        field(103; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            ///???TableRelation = "Shipping Agent";
        }
        field(105; "Fiscal Agent Code"; Code[10])
        {
            Caption = 'Fiscal Agent Code';
            TableRelation = Vendor."No.";
        }
        field(110; "Voyage No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Voyage No.';
            TableRelation = "POI Voyage";
        }
        field(111; "Container No."; Code[20])
        {
            Caption = 'Container No.';
        }
        field(112; "Means of Transport Type"; Option)
        {
            Caption = 'Means of Transport Type';
            Description = ' ,Truck,Train,Ship,Airplane';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;
        }
        field(113; "Means of Transp. Code (Arriva)"; Code[20])
        {
            Caption = 'Means of Transp. Code (Arriva)';
            ///???TableRelation = IF (Means of Transport Type=CONST(Ship)) "Means of Transport".Code WHERE (Type=FIELD(Means of Transport Type));
        }
        field(114; "Means of Transport Info"; Code[30])
        {
            Caption = 'Means of Transport Info';
        }
        field(115; "Means of Transp. Code (Depart)"; Code[20])
        {
            Caption = 'Means of Transp. Code (Depart)';
            ///???TableRelation = "Means of Transport".Code WHERE (Type=FIELD(Means of Transport Type));
            ///???ValidateTableRelation = false;
        }
        field(116; "Port of Discharge Code"; Code[10])
        {
            Caption = 'Port of Discharge Code';
            ///???TableRelation = Harbour;
        }
        field(117; "Date of Discharge"; Date)
        {
            Caption = 'Date of Discharge';
        }
        field(118; "Time of Discharge"; Time)
        {
            Caption = 'Time of Discharge';
        }
        field(120; "Waste Disposal Duty"; Option)
        {
            Caption = 'Waste Disposal Duty';
            OptionCaption = ' ,Green Point Duty';
            OptionMembers = " ","Green Point Duty";
        }
        field(121; "Waste Disposal Payment By"; Option)
        {
            Caption = 'Waste Disposal Payment By';
            OptionCaption = 'Us,Vendor';
            OptionMembers = Us,Vendor;
        }
        field(125; "Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            OptionCaption = ' ,Verzollt,Unverzollt';
            OptionMembers = " ",Verzollt,Unverzollt;
        }
        field(149; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
        }
        field(150; "Base Unit of Measure (BU)"; Code[10])
        {
            Caption = 'Base Unit of Measure (BU)';
            Editable = false;
            TableRelation = "Unit of Measure";
        }
        field(151; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            ///???TableRelation = "Unit of Measure".Code WHERE (Is Collo Unit of Measure=CONST(Yes));
            ///???ValidateTableRelation = false;

            // trigger OnValidate()
            // begin
            //     IF CurrFieldNo = FIELDNO("Unit of Measure Code") THEN
            //         UnitOfMeasure_Validate;
            // end;
        }
        field(152; "Packing Unit of Measure (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            ///???TableRelation = "Unit of Measure" WHERE (Is Packing Unit of Measure=CONST(Yes));
        }
        field(153; "Qty. (PU) per Collo (CU)"; Decimal)
        {
            Caption = 'Qty. (PU) per Collo (CU)';
        }
        field(156; "Transport Unit of Measure (TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            ///???TableRelation = "Unit of Measure" WHERE (Is Transport Unit of Measure=CONST(Yes));

            // trigger OnValidate()
            // begin
            //     CheckChangeBatchVarAttrib(FIELDNO("Transport Unit of Measure (TU)"));
            // end;
        }
        field(157; "Qty. (Unit) per Transp. (TU)"; Decimal)
        {
            Caption = 'Qty. (Unit) per Transp. (TU)';

            // trigger OnValidate()
            // begin
            //     CheckChangeBatchVarAttrib(FIELDNO("Qty. (Unit) per Transp. (TU)"));
            // end;
        }
        field(158; "No. of Layers on TU"; Decimal)
        {
            Caption = 'No. of Layers on TU';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(160; "Price Base (Purch. Price)"; Code[10])
        {
            Caption = 'Price Base (Purch. Price)';
            ///???TableRelation = "Price Base".Code WHERE ("Purch./Sales Price Calc."=CONST("Purch. Price"),
            ///???                                         Blocked=CONST(No));
        }
        field(161; "Purch. Price (Price Base)"; Decimal)
        {
            Caption = 'Purch. Price (Price Base)';
        }
        field(165; "Price Base (Sales Price)"; Code[10])
        {
            Caption = 'Price Base (Sales Price)';
            ///???TableRelation = "Price Base".Code WHERE (Purch./Sales Price Calc.=CONST(Sales Price),
            ///???                                         Blocked=CONST(No));
        }
        field(166; "Sales Price (Price Base)"; Decimal)
        {
            Caption = 'Sales Price (Price Base)';
        }
        field(168; "Market Unit Cost (Base) (LCY)"; Decimal)
        {
            Caption = 'Market Unit Cost (Base) (LCY)';
        }
        field(171; "Content Unit of Measure (CP)"; Code[10])
        {
            Caption = 'Content Unit of Measure (CP)';
            TableRelation = "Unit of Measure";
        }
        field(190; Source; Option)
        {
            Caption = 'Source';
            Description = ' ,Purch. Order,Packing Order,Sorting Order,,Item Journal Line,Inventory Journal Line,,,Company Copy,,,Dummy';
            OptionCaption = ' ,Purch. Order,Packing Order,Sorting Order,,Item Journal Line,Inventory Journal Line,Assortment,,Company Copy,,,Dummy';
            OptionMembers = " ","Purch. Order","Packing Order","Sorting Order",,"Item Journal Line","Inventory Journal Line",Assortment,,"Company Copy",,,Dummy;
        }
        field(191; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(192; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(195; "Source Company"; Text[30])
        {
            Caption = 'Source Company';
        }
        field(250; "Source Batch Variant No."; Code[20])
        {
            Caption = 'Source Batch Variant No.';
            TableRelation = Location;
        }
        field(251; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            TableRelation = Dimension;
        }
        field(252; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"));
        }
        field(299; Comment; Boolean)
        {
            ///???CalcFormula = Exist("Batch Comment" WHERE (Source=CONST("Batch Variant"),"Source No."=FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(300; State; Option)
        {
            Caption = 'State';
            OptionCaption = 'New,Open,Closed,Account Sale,Blocked,Manual Blocked,Deleted';
            OptionMembers = New,Open,Closed,"Account Sale",Blocked,"Manual Blocked",Deleted;

            // trigger OnValidate()
            // var
            //     lcu_BatchManagement: Codeunit "5110307";
            //     lrc_UserSetup: Record "User Setup";
            //     AgilesText001Txt: Label 'Der Status %1 muss offen, oder geschlossen sein ! ';
            // begin
            //     IF State <> xRec.State THEN BEGIN
            //         IF State = State::"Manual Blocked" THEN BEGIN
            //             IF (xRec.State = State::Open) OR
            //                (xRec.State = xRec.State::Closed) THEN BEGIN
            //                 // Sperrung
            //                 "Blocked from User ID" := USERID;
            //                 "Date of Blocking" := TODAY;
            //                 "Time of Blocking" := TIME;
            //             END ELSE BEGIN
            //                 ERROR(AgilesText001Txt, xRec.State);
            //             END;
            //             CheckAssigments();
            //         END ELSE BEGIN
            //             IF xRec.State = xRec.State::"Manual Blocked" THEN BEGIN
            //                 // manuelle Entsperrung
            //                 lrc_UserSetup.GET(Userid());
            //                 lrc_UserSetup.TESTFIELD("Allow Unlocking Batch Variant");
            //                 lcu_BatchManagement.BatchVariantRecalc("Item No.", "No.");
            //                 "Released from User ID" := USERID;
            //                 "Date of Releasing" := TODAY;
            //                 "Time of Releasing" := TIME;
            //             END;
            //         END;
            //     END;
            // end;
        }
        field(310; "Sales Statement Closed"; Boolean)
        {
            Caption = 'Sales Statement Closed';
        }
        field(400; "Purch. Currency Code"; Code[10])
        {
            Caption = 'Purch. Currency Code';
            TableRelation = Currency;
        }
        field(401; "Purch. Price (UOM) (LCY)"; Decimal)
        {
            Caption = 'Purch. Price (EE) (LCY)';
        }
        field(402; "Purch. Price Net (UOM) (LCY)"; Decimal)
        {
            Caption = 'Purch. Price Net per EE (LCY)';
            Description = 'Einkaufspreis abzgl. Zeilenrabatt / Rg.Rab. / Rück. Rg.Rab. / VVE';
        }
        field(403; "Cost Calc. (UOM) (LCY)"; Decimal)
        {
            Caption = 'Cost Calc. per Unit (LCY)';
        }
        field(404; "Post. Purch. Cost (UOM) (LCY)"; Decimal)
        {
            Caption = 'Post. Purch. Cost per EE (LCY)';
        }
        field(408; "Cost Calc. Amount (LCY)"; Decimal)
        {
            Caption = 'Cost Calc. Amount (LCY)';
        }
        field(410; "Indirect Cost %"; Decimal)
        {
            Caption = 'Indirect Cost %';
        }
        field(411; "Indirect Cost Amount"; Decimal)
        {
            Caption = 'Indirect Cost Amount';
        }
        field(415; "Unit Cost (UOM) (LCY)"; Decimal)
        {
            Caption = 'Unit Cost (UOM) (LCY)';
        }
        field(450; "Company Season Code"; Code[10])
        {
            Caption = 'Company Season Code';
            ///???TableRelation = "Company Season".Code;
        }
        field(460; "Original Quantity"; Decimal)
        {
            Caption = 'Original Quantity';
            Description = 'PVP';
        }
        field(600; "Dispolines with DispoWeek Cust"; Integer)
        {
            // CalcFormula = Count ("POI Dispolines" WHERE("Batch No." = FIELD("Batch No."),
            //                                       "Batch Variant No." = FIELD("No."),
            //                                       "Disposition For Week" = FIELD("Disposition Week Filter"),
            //                                       Quantity = FILTER(<> 0),
            //                                       "Target Type" = CONST(Customer)));
            Caption = 'Dispolines Customer with Disposition for Week';
            Description = 'PVP, Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(601; "Disposition Week Filter"; Code[5])
        {
            Caption = 'Disposition Week Filter';
            Description = 'PVP';
            FieldClass = FlowFilter;
        }
        field(602; "Leaving On"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("POI Batch"."Release Date" WHERE("No." = FIELD("Batch No.")));
            Caption = 'Leaving On';
            Description = 'PVP, Flowfield';
            Editable = false;

        }
        field(603; "Disposition For Week"; Code[5])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("POI Batch"."Disposition Week" WHERE("No." = FIELD("Batch No.")));
            Caption = 'Disposition For Week';
            Description = 'PVP, Flowfield';
            Editable = false;

        }
        field(604; "Release Planning"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("POI Batch"."Release Planning" WHERE("No." = FIELD("Batch No.")));
            Caption = 'Release Planning';
            Description = 'PVP, Flowfield';
            Editable = false;

        }
        field(605; "Release Planning User"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("POI Batch"."Release Planning User" WHERE("No." = FIELD("Batch No.")));
            Caption = 'Release Planning User';
            Description = 'PVP, Flowfield';
            Editable = false;

        }
        field(606; "Date Release Planning"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("POI Batch"."Release Planning Date" WHERE("No." = FIELD("Batch No.")));
            Caption = 'Date Release Planning';
            Description = 'PVP, Flowfield';
            Editable = false;
        }
        field(607; "Quantity Dispo Plan PosVarCust"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("POI Dispolines".Quantity WHERE("Batch No." = FIELD("Batch No."),
                                                         "Batch Variant No." = FIELD("No."),
                                                         "Target Type" = CONST(Customer)));
            Caption = 'Quantity Customer Disposition Planning Lines On PositionsVariant';
            Description = 'PVP, Flowfield';
            Editable = false;

        }
        field(608; "Quantity Dispo Plan Cust"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("POI Dispolines".Quantity WHERE("Batch No." = FIELD("Batch No."),
                                                         "Target Type" = CONST(Customer)));
            Caption = 'Quantity Customer Disposition Planning Lines On File No.';
            Description = 'PVP, Flowfield';
            Editable = false;

        }
        field(609; "Dispolines with DispoWeek CuGr"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("POI Dispolines" WHERE("Batch No." = FIELD("Batch No."),
                                                  "Batch Variant No." = FIELD("No."),
                                                  "Disposition For Week" = FIELD("Disposition Week Filter"),
                                                  Quantity = FILTER(<> 0),
                                                  "Target Type" = CONST("Customer Group")));
            Caption = 'Dispolines Customer Group with Disposition for Week';
            Description = 'PVP, Flowfield';
            Editable = false;

        }
        field(610; "Quantity Dispo Plan PosVarCuGr"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("POI Dispolines".Quantity WHERE("Batch No." = FIELD("Batch No."),
                                                         "Batch Variant No." = FIELD("No."),
                                                         "Target Type" = CONST("Customer Group")));
            Caption = 'Quantity Customer Group Disposition Planning Lines On PositionsVariant';
            Description = 'PVP, Flowfield';
            Editable = false;
        }
        field(611; "Quantity Dispo Plan CuGr"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("POI Dispolines".Quantity WHERE("Batch No." = FIELD("Batch No."),
                                                         "Target Type" = CONST("Customer Group")));
            Caption = 'Quantity Customer Group Disposition Planning Lines On File No.';
            Description = 'PVP, Flowfield';
            Editable = false;
        }
        field(612; "Dispolines with DispoWeek Loc"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("POI Dispolines" WHERE("Batch No." = FIELD("Batch No."),
                                                  "Batch Variant No." = FIELD("No."),
                                                  "Disposition For Week" = FIELD("Disposition Week Filter"),
                                                  Quantity = FILTER(<> 0),
                                                  "Target Type" = CONST(Location)));
            Caption = '"POI Dispolines" Location with Disposition for Week';
            Description = 'PVP, Flowfield';
            Editable = false;

        }
        field(613; "Quantity Dispo Plan PosVarLoc"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("POI Dispolines".Quantity WHERE("Batch No." = FIELD("Batch No."),
                                                         "Batch Variant No." = FIELD("No."),
                                                         "Target Type" = CONST(Location)));
            Caption = 'Quantity Location Disposition Planning Lines On PositionsVariant';
            Description = 'PVP, Flowfield';
            Editable = false;
        }
        field(614; "Quantity Dispo Plan Location"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("POI Dispolines".Quantity WHERE("Batch No." = FIELD("Batch No."),
                                                         "Target Type" = CONST(Location)));
            Caption = 'Quantity Location Planning Lines On File No.';
            Description = 'PVP, Flowfield';
            Editable = false;
        }
        field(620; "Dispolines with DispoWeek MLoc"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("POI Dispolines" WHERE("Batch No." = FIELD("Batch No."),
                                                  "Batch Variant No." = FIELD("No."),
                                                  "Disposition For Week" = FIELD("Disposition Week Filter"),
                                                  Quantity = FILTER(<> 0),
                                                  "Target Type" = CONST("Maturation at Location")));
            Caption = 'Dispolines Maturation At Location with Disposition for Week';
            Description = 'PVP, Flowfield';
            Editable = false;

        }
        field(621; "Quantity Dispo Plan PosVarMLoc"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("POI Dispolines".Quantity WHERE("Batch No." = FIELD("Batch No."),
                                                         "Batch Variant No." = FIELD("No."),
                                                         "Target Type" = CONST("Maturation at Location")));
            Caption = 'Quantity Maturation At Location Disposition Planning Lines On PositionsVariant';
            Description = 'PVP, Flowfield';
            Editable = false;

        }
        field(622; "Quantity Dispo Plan MLocation"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("POI Dispolines".Quantity WHERE("Batch No." = FIELD("Batch No."),
                                                         "Target Type" = CONST("Maturation at Location")));
            Caption = 'Quantity Maturation At Location Planning Lines On File No.';
            Description = 'PVP, Flowfield';
            Editable = false;

        }
        field(630; "Dispoline with DispoWE MfoLoc"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("POI Dispolines" WHERE("Batch No." = FIELD("Batch No."),
                                                  "Batch Variant No." = FIELD("No."),
                                                  "Disposition For Week" = FIELD("Disposition Week Filter"),
                                                  Quantity = FILTER(<> 0),
                                                  "Target Type" = CONST("PreMaturation for Location")));
            Caption = 'Dispolines Maturation For Location with Disposition for Week';
            Description = 'PVP, Flowfield';
            Editable = false;

        }
        field(631; "Quantity Dispo Plan PosVarMfLo"; Decimal)
        {
            CalcFormula = Sum ("POI Dispolines".Quantity WHERE("Batch No." = FIELD("Batch No."),
                                                         "Batch Variant No." = FIELD("No."),
                                                         "Target Type" = CONST("PreMaturation for Location")));
            Caption = 'Quantity Maturation For Location Disposition Planning Lines On PositionsVariant';
            Description = 'PVP, Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(632; "Quantity Dispo Plan MfLocation"; Decimal)
        {
            CalcFormula = Sum ("POI Dispolines".Quantity WHERE("Batch No." = FIELD("Batch No."),
                                                         "Target Type" = CONST("PreMaturation for Location")));
            Caption = 'Quantity Maturation For Location Planning Lines On File No.';
            Description = 'PVP, Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(640; "Dispolines with DispoWE MfoCus"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("POI Dispolines" WHERE("Batch No." = FIELD("Batch No."),
                                                  "Batch Variant No." = FIELD("No."),
                                                  "Disposition For Week" = FIELD("Disposition Week Filter"),
                                                  Quantity = FILTER(<> 0),
                                                  "Target Type" = CONST("PreMaturation for Customer")));
            Caption = 'Dispolines Maturation For Customer with Disposition for Week';
            Description = 'PVP, Flowfield';
            Editable = false;

        }
        field(641; "Quantity Dispo Plan PosVarMfCu"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("POI Dispolines".Quantity WHERE("Batch No." = FIELD("Batch No."),
                                                         "Batch Variant No." = FIELD("No."),
                                                         "Target Type" = CONST("PreMaturation for Customer")));
            Caption = 'Quantity Maturation For Customer Disposition Planning Lines On PositionsVariant';
            Description = 'PVP, Flowfield';
            Editable = false;
        }
        field(642; "Quantity Dispo Plan MforCust"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("POI Dispolines".Quantity WHERE("Batch No." = FIELD("Batch No."),
                                                         "Target Type" = CONST("PreMaturation for Customer")));
            Caption = 'Quantity Maturation For Customer Planning Lines On File No.';
            Description = 'PVP, Flowfield';
            Editable = false;
        }
        field(700; "Quality Control Vendor No."; Code[20])
        {
            Caption = 'Quality Control Vendor No.';
            Editable = false;
            ///???TableRelation = Vendor WHERE (Is Quality Controller=CONST(Yes));
        }
        field(701; "Quality Control Date"; Date)
        {
            Caption = 'Quality Control Date';
            Editable = false;
        }
        field(702; "Quality Control Time"; Time)
        {
            Caption = 'Quality Control Time';
            Editable = false;
        }
        field(750; "Purch. Doc. Subtype Code"; Code[10])
        {
            Caption = 'Purch. Doc. Subtype Code';
        }
        field(1000; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(50000; "B.V. Pack.Rev.Input Quota(Qty)"; Decimal)
        {
            FieldClass = FlowField;
            BlankNumbers = BlankZero;
            ///???CalcFormula = Sum ("Pack. Order Rev. per Inp.Batch"."Output Qty. Quota (Base)" WHERE("Input Batch Variant No."=FIELD("No.")));
            Caption = 'P.V. Pack. Erl.Input Anteil (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(50010; "Departure Location Code"; Code[20])
        {
            Caption = 'Abgangslager';
        }
        field(50020; Zusatzmerkmal; Code[20])
        {
            ///???TableRelation = StandardplankostzusatzMM.Merkmal;
        }
        field(50040; EAN; Code[13])
        {
            Caption = 'EAN';
        }
        field(50041; "PLU-Code"; Code[5])
        {
        }
        field(50042; "Customer Group Code"; Code[10])
        {
            Caption = 'Kundengruppe';
            ///???TableRelation = "Customer Group".Code;

        }
        field(64001; "No. End Cust. Return Order"; Integer)
        {
            Caption = 'No. End Customer Return Order';
            FieldClass = Normal;
        }
        field(64002; "Guaranteed Shelf Life"; DateFormula)
        {
            Caption = 'Guaranteed Shelf Life';
        }
        field(89999; "-- FILTER --"; Integer)
        {
            Caption = '-- FILTER --';
            Enabled = false;
        }
        field(90000; "Bin Filter"; Code[20])
        {
            Caption = 'Bin Filter';
            Description = 'Flowfilter';
            FieldClass = FlowFilter;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Filter"));
        }
        field(90001; "Variant Filter"; Code[10])
        {
            Caption = 'Variant Filter';
            Description = 'Flowfilter';
            FieldClass = FlowFilter;
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("No."));
        }
        field(90002; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Description = 'Flowfilter';
            FieldClass = FlowFilter;
        }
        field(90003; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            Description = 'Flowfilter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(90010; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            Description = 'FlowFilter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(90011; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            Description = 'FlowFilter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(90012; "Global Dimension 3 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 3 Filter';
            Description = 'FlowFilter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(90013; "Global Dimension 4 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 4 Filter';
            Description = 'FlowFilter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
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
        field(90501; "B.V. Inventory (Qty.)"; Decimal)
        {
            FieldClass = FlowField;
            BlankNumbers = BlankZero;
            // CalcFormula = Sum ("Batch Variant Entry"."Quantity (Base)" WHERE("Batch Variant No." = FIELD("No."),
            //                                                                  "Location Code" = FIELD("Location Filter"),
            //                                                                  "Posting Date"=FIELD("Date Filter")));
            Caption = 'B.V. Inventory (Qty.)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(90502; "B.V. Net Change (Qty.)"; Decimal)
        {
            BlankNumbers = BlankZero;
            // CalcFormula = Sum("Batch Variant Entry"."Quantity (Base)" WHERE ("Batch Variant No."=FIELD("No."),
            //                                                                  "Location Code"=FIELD("Location Filter"),
            //                                                                  "Posting Date"=FIELD("Date Filter")));
            Caption = 'B.V. Net Change (Qty.)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90503; "B.V. Purch. Inv. (Qty.)"; Decimal)
        {
            FieldClass = FlowField;
            // CalcFormula = Sum ("Item Ledger Entry"."Invoiced Quantity" WHERE("Entry Type"=CONST(Purchase),
            //                                                                  "Item No."=FIELD("Item No."),
            //                                                                  "Batch Variant No."=FIELD("No."),
            //                                                                  "Location Code"=FIELD("Location Filter"),
            //                                                                  "Posting Date"=FIELD("Date Filter")));
            Caption = 'B.V. Purch. Inv. (Qty.)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(90504; "B.V. Purch. Rec. (Qty)"; Decimal)
        {
            FieldClass = FlowField;
            BlankNumbers = BlankZero;
            // CalcFormula = Sum ("Batch Variant Entry"."Quantity (Base)" WHERE("Batch Variant No." = FIELD("No."),
            //                                                                  "Item Ledger Entry Type"=CONST(Purchase),
            //                                                                  "Location Code"=FIELD("Location Filter"),
            //                                                                  "Posting Date"=FIELD("Date Filter")));
            Caption = 'B.V. Purch. Rec. (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
        }
        field(90505; "B.V. Sales Shipped (Qty)"; Decimal)
        {
            BlankNumbers = BlankZero;
            // CalcFormula = Sum("Batch Variant Entry"."Quantity (Base)" WHERE ("Batch Variant No."=FIELD("No."),
            //                                                                  "Item Ledger Entry Type"=CONST(Sale),
            //                                                                  "Location Code"=FIELD("Location Filter"),
            //                                                                  "Posting Date"=FIELD("Date Filter")));
            Caption = 'B.V. Sales Shipped (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90506; "B.V. Sales Inv. (Qty.)"; Decimal)
        {
            FieldClass = FlowField;
            // CalcFormula = Sum("Item Ledger Entry"."Invoiced Quantity" WHERE ("Entry Type"=CONST(Sale),
            //                                                                  "Item No."=FIELD("Item No."),
            //                                                                  "Batch Variant No."=FIELD("No."),
            //                                                                  "Location Code"=FIELD("Location Filter"),
            //                                                                  "Posting Date"=FIELD("Date Filter")));
            Caption = 'B.V. Sales Inv. (Qty.)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(90510; "B.V. Purch. Order (Qty)"; Decimal)
        {
            BlankNumbers = BlankZero;
            // CalcFormula = Sum ("Purchase Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Order),
            //                                                                    Type = CONST(Item),
            //                                                                    "Batch Variant No." = FIELD("No."),
            //                                                                    "Location Code" = FIELD("Location Filter"),
            //                                                                    "Expected Receipt Date" = FIELD("Date Filter")));
            Caption = 'B.V. Purch. Order (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90511; "B.V. Purch. Cr. Memo (Qty)"; Decimal)
        {
            FieldClass = FlowField;
            BlankNumbers = BlankZero;
            // CalcFormula = Sum ("Purchase Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST("Credit Memo"),
            //                                                                    Type=CONST(Item),
            //                                                                    "Batch Variant No."=FIELD("No."),
            //                                                                    "Location Code"=FIELD("Location Filter"),
            //                                                                    "Expected Receipt Date"=FIELD("Date Filter")));
            Caption = 'B.V. Purch. Cr. Memo (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(90512; "B.V. Sales Order (Qty)"; Decimal)
        {
            BlankNumbers = BlankZero;
            FieldClass = FlowField;
            // CalcFormula = Sum ("Batch Variant Detail"."Qty. Outstanding (Base)" WHERE(Source = CONST(Sales),
            //                                                                           "Source Type" = FILTER(Order | "Blanket Order"),
            //                                                                           "Batch Variant No."=FIELD("No."),
            //                                                                           "Location Code"=FIELD("Location Filter"),
            //                                                                           "Sales Shipment Date"=FIELD("Date Filter")));
            Caption = 'B.V. Sales Order (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(90513; "B.V. Sales Cr. Memo (Qty)"; Decimal)
        {
            BlankNumbers = BlankZero;
            FieldClass = FlowField;
            // CalcFormula = Sum ("Sales Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST("Credit Memo"),
            //                                                                 Type=CONST(Item),
            //                                                                 "Batch Variant No."=FIELD("No."),
            //                                                                 "Location Code"=FIELD("Location Filter"),
            //                                                                 "Shipment Date"=FIELD("Date Filter")));
            Caption = 'B.V. Sales Cr. Memo (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(90514; "B.V. FV Reservation (Qty)"; Decimal)
        {
            BlankNumbers = BlankZero;
            FieldClass = FlowField;
            // CalcFormula = Sum("Reservation Line"."Remaining Qty. (Base)" WHERE ("Batch Variant No."=FIELD("No."),
            //                                                                     "Location Code"=FIELD("Location Filter")));
            Caption = 'B.V. FV Reservation (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(90520; "B.V. Transfer Ship (Qty)"; Decimal)
        {
            BlankNumbers = BlankZero;
            FieldClass = FlowField;
            // CalcFormula = Sum("Transfer Line"."Outstanding Qty. (Base)" WHERE ("Derived From Line No."=CONST(0),
            //                                                                    "Batch Variant No."=FIELD("No."),
            //                                                                    "Transfer-from Code"=FIELD("Location Filter"),
            //                                                                    "Shipment Date"=FIELD("Date Filter")));
            Caption = 'B.V. Transfer Ship (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
        }
        field(90521; "B.V. Transfer Rec. (Qty)"; Decimal)
        {
            BlankNumbers = BlankZero;
            FieldClass = FlowField;
            // CalcFormula = Sum ("Transfer Line"."Outstanding Qty. (Base)" WHERE("Derived From Line No." = CONST(0),
            //                                                                    "Batch Variant No." = FIELD("No."),
            //                                                                    "Transfer-to Code" = FIELD("Location Filter"),
            //                                                                    "Receipt Date" = FIELD("Date Filter")));
            Caption = 'B.V. Transfer Rec. (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
        }
        field(90522; "B.V. Transfer in Transit (Qty)"; Decimal)
        {
            BlankNumbers = BlankZero;
            FieldClass = FlowField;
            // CalcFormula = Sum ("Transfer Line"."Qty. in Transit (Base)" WHERE("Derived From Line No." = CONST(0),
            //                                                                   "Batch Variant No." = FIELD("No."),
            //                                                                   "Transfer-to Code" = FIELD("Location Filter"),
            //                                                                   "Receipt Date" = FIELD("Date Filter")));
            Caption = 'P.V. Umlagerung in Transit (Mge)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(90530; "B.V. Pack. Input (Qty)"; Decimal)
        {
            BlankNumbers = BlankZero;
            FieldClass = FlowField;
            // CalcFormula = Sum ("Pack. Order Input Items"."Remaining Quantity (Base)" WHERE("Batch Variant No." = FIELD("No."),
            //                                                                                "Location Code" = FIELD("Location Filter")));
            Caption = 'B.V. Pack. Input (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(90531; "B.V. Pack. Output (Qty)"; Decimal)
        {
            BlankNumbers = BlankZero;
            FieldClass = FlowField;
            // CalcFormula = Sum ("Pack. Order Output Items"."Remaining Quantity (Base)" WHERE("Batch Variant No." = FIELD("No."),
            //                                                                                 "Location Code" = FIELD("Location Filter"),
            //                                                                                 "Expected Receipt Date" = FIELD("Date Filter")));
            Caption = 'B.V. Pack. Output (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(90532; "B.V. Pack. Pack.-Input (Qty)"; Decimal)
        {
            BlankNumbers = BlankZero;
            FieldClass = FlowField;
            // CalcFormula = Sum ("Pack. Order Input Pack. Items"."Remaining Quantity (Base)" WHERE("Batch Variant No." = FIELD("No."),
            //                                                                                      "Location Code" = FIELD("Location Filter"),
            //                                                                                      "Posting Date" = FIELD("Date Filter")));
            Caption = 'B.V. Pack. Pack.-Input (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(90533; "Pack. Input (Qty)"; Decimal)
        {
            FieldClass = FlowField;
            BlankZero = true;
            // CalcFormula = Sum ("Pack. Order Input Items"."Quantity (Base)" WHERE("Batch Variant No." = FIELD("No."),
            //                                                                      "Location Code" = FIELD("Location Filter")));
            Caption = 'Pack. Input (Qty)';
            Description = 'Flowfield - mly 141014';
            Editable = false;

        }
        field(90535; "B.V. Purchases Rec. (Qty.)"; Decimal)
        {
            FieldClass = FlowField;
            // CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE("Entry Type"=CONST(Purchase),
            //                                                       "Item No."=FIELD("Item No."),
            //                                                       "Batch Variant No."=FIELD("No."),
            //                                                       "Location Code"=FIELD("Location Filter"),
            //                                                       "Posting Date"=FIELD("Date Filter")));
            Caption = 'B.V. Purchases Rec. (Qty.)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
        }
        field(90540; "B.V. Pos. Shipped Adjmt. (Qty)"; Decimal)
        {
            FieldClass = FlowField;
            // CalcFormula = Sum("Batch Variant Entry"."Quantity (Base)" WHERE ("Batch Variant No."=FIELD("No."),
            //                                                                  "Item Ledger Entry Type"=CONST("Positive Adjmt."),
            //                                                                  "Location Code"=FIELD("Location Filter"),
            //                                                                  "Posting Date"=FIELD("Date Filter")));
            Caption = 'B.V. Pos. Shipped Adjmt. (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(90541; "B.V. Neg. Shipped Adjmt. (Qty)"; Decimal)
        {
            FieldClass = FlowField;
            // CalcFormula = Sum ("Batch Variant Entry"."Quantity (Base)" WHERE("Batch Variant No." = FIELD("No."),
            //                                                                  "Item Ledger Entry Type" = CONST("Negative Adjmt."),
            //                                                                  "Location Code"=FIELD("Location Filter"),
            //                                                                  "Posting Date"=FIELD("Date Filter")));
            Caption = 'B.V. Neg. Shipped Adjmt. (Qty)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(90545; "B.V. Sales Statement (Qty)"; Decimal)
        {
            FieldClass = FlowField;
            BlankNumbers = BlankZero;
            // CalcFormula = Sum("Post. Sales Stat. Line"."Quantity Total to Report" WHERE ("Batch Variant No."=FIELD("No.")));
            Caption = 'B.V. Sales Statement (Qty)';
            Description = 'Flowfield';
            Editable = false;
        }
        field(90601; "B.V. Purch. Claim (Qty.)"; Decimal)
        {
            FieldClass = FlowField;
            // CalcFormula = Sum ("Purch. Claim Notify Line"."Quantity (Base)" WHERE("Batch Variant No." = FIELD("No.")));
            Caption = 'B.V. Purch. Claim (Qty.)';
            Description = 'Flowfield';

        }
        field(90602; "B.V. Sales Claim (Qty.)"; Decimal)
        {
            Caption = 'B.V. Sales Claim (Qty.)';
            Description = 'Flowfield';
        }
        field(90651; "B.V. Inventory Pallets"; Decimal)
        {
            BlankNumbers = BlankZero;
            FieldClass = FlowField;
            // CalcFormula = Sum ("xPallet - Item Lines".Quantity WHERE("Batch Variant No." = FIELD("No."),
            //                                                          "Location Code" = FIELD("Location Filter")));
            Caption = 'B.V. Inventory Pallets';
            DecimalPlaces = 0 : 2;
            Description = 'PAL,Flowfield';
            Editable = false;

        }
        field(90652; "B.V. Inventory on Item Ledger"; Decimal)
        {
            FieldClass = FlowField;
            // CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE("Batch Variant No." = FIELD("No."),
            //                                                       "Location Code" = FIELD("Location Filter"),
            //                                                       "Posting Date" = FIELD("Date Filter")));
            Caption = 'B.V. Inventory on Item Ledger';
            Description = 'INV,Flowfield';
            Editable = false;
        }
        field(90701; "B.V. Sales Start"; Date)
        {
            FieldClass = FlowField;
            // CalcFormula = Min ("Batch Variant Entry"."Posting Date" WHERE("Batch Variant No." = FIELD("No."),
            //                                                               "Item Ledger Entry Type" = FILTER(Sale | "Negative Adjmt.")));
            Caption = 'B.V. Sales Start';
            Description = 'SAL,FlowField';
            Editable = false;
        }
        field(5110300; "B.V. Customer Clearance (Qty.)"; Decimal)
        {
            FieldClass = FlowField;
            // CalcFormula = Sum ("Customs Clearance Lines"."Quantity (Base)" WHERE("No." = FIELD("Item No."),
            //                                                                      "Batch Variant No." = FIELD("No.")));
            Caption = 'B.V. Customer Clearance (Qty.)';
            Description = 'Flowfield';
            Editable = false;
        }
        field(5110301; "Purchases Shipped (Qty.)"; Decimal)
        {
            FieldClass = FlowField;
            // CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST(Purchase),
            //                                                       "Item No." = FIELD("Item No."),
            //                                                       "Batch Variant No." = FIELD("No."),
            //                                                       "Location Code" = FIELD("Location Filter"),
            //                                                       "Posting Date" = FIELD("Date Filter")));
            Caption = 'Purchases Shipped (Qty.)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
            Enabled = false;

        }
        field(5110302; "Sales Shipped (Qty.)"; Decimal)
        {
            // CalcFormula = - Sum ("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST(Sale),
            //                                                        "Item No." = FIELD("Item No."),
            //                                                        "Batch Variant No." = FIELD("No."),
            //                                                        "Location Code" = FIELD("Location Filter"),
            //                                                        "Posting Date" = FIELD("Date Filter")));
            Caption = 'Sales Shipped (Qty.)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(5110303; "Positive Shipped Adjmt. (Qty.)"; Decimal)
        {
            // CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST("Positive Adjmt."),
            //                                                       "Item No." = FIELD("Item No."),
            //                                                       "Batch Variant No." = FIELD("No."),
            //                                                       "Location Code" = FIELD("Location Filter"),
            //                                                       "Posting Date" = FIELD("Date Filter")));
            Caption = 'Positive Shipped Adjmt. (Qty.)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(5110304; "Negative Shipped Adjmt. (Qty.)"; Decimal)
        {
            // CalcFormula = - Sum ("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST("Negative Adjmt."),
            //                                                        "Item No." = FIELD("Item No."),
            //                                                        "Batch Variant No." = FIELD("No."),
            //                                                        "Location Code" = FIELD("Location Filter"),
            //                                                        "Posting Date" = FIELD("Date Filter")));
            Caption = 'Negative Shipped Adjmt. (Qty.)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(5110480; "Qty. on Purch. Return Order"; Decimal)
        {
            // CalcFormula = Sum ("Purchase Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST("Return Order"),
            //                                                                    Type = CONST(Item),
            //                                                                    "No." = FIELD("Item No."),
            //                                                                    "Batch Variant No." = FIELD("No."),
            //                                                                    "Location Code" = FIELD("Location Filter"),
            //                                                                    "Expected Receipt Date" = FIELD("Date Filter")));
            Caption = 'Qty. on Purch. Return Order';
            Description = 'Flowfield';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(5110481; "Qty. on Sales Return Order"; Decimal)
        {
            // CalcFormula = Sum ("Sales Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST("Return Order"),
            //                                                                 Type = CONST(Item),
            //                                                                 "No." = FIELD("Item No."),
            //                                                                 "Batch Variant No." = FIELD("No."),
            //                                                                 "Location Code" = FIELD("Location Filter"),
            //                                                                 "Shipment Date" = FIELD("Date Filter")));
            Caption = 'Qty. on Sales Return Order';
            Description = 'Flowfield';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(5110482; "Qty. on Purch. Credit Memo"; Decimal)
        {
            FieldClass = FlowField;
            // CalcFormula = Sum ("Purchase Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST("Credit Memo"),
            //                                                                    Type = CONST(Item),
            //                                                                    "No." = FIELD("Item No."),
            //                                                                    "Batch Variant No." = FIELD("No."),
            //                                                                    "Location Code" = FIELD("Location Filter"),
            //                                                                    "Expected Receipt Date" = FIELD("Date Filter")));
            Caption = 'Qty. on Purch. Credit Memo';
            Description = 'Flowfield';
            Editable = false;

        }
        field(5110483; "Qty. on Sales Credit Memo"; Decimal)
        {
            FieldClass = FlowField;
            // CalcFormula = Sum ("Sales Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST("Credit Memo"),
            //                                                                 Type=CONST(Item),
            //                                                                 "No."=FIELD("Item No."),
            //                                                                 "Batch Variant No."=FIELD("No."),
            //                                                                 "Location Code"=FIELD("Location Filter"),
            //                                                                 "Shipment Date"=FIELD("Date Filter")));
            Caption = 'Qty. on Sales Credit Memo';
            Description = 'Flowfield';
            Editable = false;
        }
        field(5110600; "Average Customs Weight"; Decimal)
        {
            Caption = 'Average Customs Weight';
            DecimalPlaces = 0 : 5;
        }
        field(9995707; "B.V. Qty. in Transit"; Decimal)
        {
            FieldClass = FlowField;
            // CalcFormula = Sum("Transfer Line"."Qty. in Transit (Base)" WHERE ("Derived From Line No."=CONST(0),
            //                                                                   "Item No."=FIELD("Item No."),
            //                                                                   "Transfer-to Code"=FIELD("Location Filter"),
            //                                                                   "Variant Code"=FIELD("Variant Filter"),
            //                                                                   "Batch Variant No."=FIELD("No."),
            //                                                                   "Shortcut Dimension 1 Code"=FIELD("Global Dimension 1 Filter"),
            //                                                                   "Shortcut Dimension 2 Code"=FIELD("Global Dimension 2 Filter"),
            //                                                                   "Receipt Date"=FIELD("Date Filter")));
            Caption = 'B.V. Qty. in Transit';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;

        }
        field(9999989; "Drop Shipment Filter"; Boolean)
        {
            Caption = 'Drop Shipment Filter';
            Description = 'FlowFilter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Batch No.")
        {
        }
        key(Key3; "Master Batch No.", "Batch No.")
        {
        }
        key(Key4; State, "Product Group Code")
        {
        }
        key(Key5; State, "Product Group Code", "Date of Delivery")
        {
        }
        key(Key6; Description, "Country of Origin Code", "Caliber Code", "Unit of Measure Code", "Date of Delivery")
        {
        }
        key(Key7; "Master Batch No.", "Batch No.", "Item No.")
        {
        }
        key(Key8; "Item No.", "Variant Code", "Unit of Measure Code", State)
        {
        }
        key(Key9; State, "Item Category Code", "Product Group Code", "Country of Origin Code", "Variety Code", "Trademark Code", "Caliber Code", "Item No.", "Vendor No.", "Date of Delivery")
        {
        }
        key(Key10; "Lot No. Producer")
        {
        }
        key(Key11; "Item No.", "Vendor No.")
        {
        }
        key(Key12; "Product Group Code", Description, "Grade of Goods Code", "Country of Origin Code", "Variety Code", "Caliber Code", "Unit of Measure Code")
        {
        }
        key(Key13; "Date of Delivery")
        {
        }
        key(Key14; State, "Item No.", "Date of Delivery")
        {
        }
        key(Key15; "Product Group Code", Description, "Country of Origin Code", "Variety Code", "Unit of Measure Code", "Caliber Code", "Grade of Goods Code", "Date of Delivery")
        {
        }
        key(Key16; "Location Reference No.")
        {
        }
        key(Key17; State, "Item Category Code", "Product Group Code", "Item No.", "Date of Delivery", "Country of Origin Code", "Variety Code", "Trademark Code", "Caliber Code", "Vendor No.")
        {
        }
        key(Key18; "Vendor No.", "Item No.", "Variety Code", "Item Attribute 4")
        {
        }
        key(Key19; "Means of Transport Type", "Port of Discharge Code", "Date of Discharge", "No.")
        {
        }
        key(Key20; Description, "Date of Delivery")
        {
        }
    }

    // trigger OnDelete()
    // var
    //     lcu_BatchManagement: Codeunit "5110307";
    //     lcu_PurchMgt: Codeunit "5110323";
    //     lcu_BatchMgt: Codeunit "5110307";
    //     lrc_FruitVisionSetup: Record "5110302";
    //     lrc_BatchVariantPackingQuality: Record "5110367";
    //     lrc_BatchVaPackQualityCaliber: Record "5110486";
    //     lrc_IncomingPallet: Record "5110445";
    //     lrc_OutgoingPallet: Record "5110502";
    //     lrc_PalletItemLines: Record "5110503";
    //     AgilesText001: Label 'Löschung nicht möglich : Es existieren noch %1 eingehende Palettenzeilen !';
    //     AgilesText002: Label 'Löschung nicht möglich : Es existieren noch %1 offene Paletten Artikelzeilen !';
    //     AgilesText003: Label 'Löschung nicht möglich : Es existieren noch %1 ausgehende Palettenzeilen !';
    //     lrc_BatchSourceInfo: Record "5110354";
    // begin
    //     IF lcu_BatchMgt.BatchVarCheckIfInOpenDoc("Item No.","No.", '') = TRUE THEN
    //       // Löschung nicht zulässig, Positionsvariante %1 ist in Belegen zugeordnet!
    //       ERROR(ADF_GT_TEXT001,"No.");

    //     // Eingehende Zeilen
    //     lrc_IncomingPallet.Reset();
    //     lrc_IncomingPallet.SETCURRENTKEY("Batch Variant No.");
    //     lrc_IncomingPallet.SETRANGE("Batch Variant No.", "No.");
    //     IF NOT lrc_IncomingPallet.isempty()THEN
    //       ERROR(AgilesText001,lrc_IncomingPallet.COUNT());

    //     // Paletten Artikelzeilen
    //     lrc_PalletItemLines.Reset();
    //     lrc_PalletItemLines.SETCURRENTKEY("Batch Variant No.", Quantity);
    //     lrc_PalletItemLines.SETRANGE("Batch Variant No.", "No.");
    //     lrc_PalletItemLines.SETFILTER( Quantity, '<>%1', 0 );
    //     IF NOT lrc_PalletItemLines.isempty()THEN
    //       ERROR(AgilesText002,lrc_PalletItemLines.COUNT());

    //     // Ausgehende Palettenzeilen
    //     lrc_OutgoingPallet.Reset();
    //     lrc_OutgoingPallet.SETCURRENTKEY( "Batch Variant No." );
    //     lrc_OutgoingPallet.SETRANGE("Batch Variant No.", "No.");
    //     IF NOT lrc_OutgoingPallet.isempty()THEN
    //       ERROR(AgilesText003,lrc_OutgoingPallet.COUNT());

    //     lcu_BatchManagement.SetBatchStatusClosed("Batch No.","No.");

    //     lrc_BatchSourceInfo.Reset();
    //     lrc_BatchSourceInfo.SETRANGE("Batch Source Type",lrc_BatchSourceInfo."Batch Source Type"::"Batch Variant No.");
    //     lrc_BatchSourceInfo.SETRANGE("Batch Source No.","No.");
    //     IF NOT lrc_BatchSourceInfo.isempty()THEN
    //       lrc_BatchSourceInfo.DELETEALL(TRUE);

    //     lrc_BatchVariantPackingQuality.Reset();
    //     lrc_BatchVariantPackingQuality.SETRANGE("Batch Variant No.","No.");
    //     IF NOT lrc_BatchVariantPackingQuality.isempty()THEN
    //       lrc_BatchVariantPackingQuality.DELETEALL(TRUE);

    //     lrc_BatchVaPackQualityCaliber.Reset();
    //     lrc_BatchVaPackQualityCaliber.SETRANGE("Batch Variant No.", "No.");
    //     IF NOT lrc_BatchVaPackQualityCaliber.isempty()THEN
    //       lrc_BatchVaPackQualityCaliber.DELETEALL(TRUE);
    // end;

    trigger OnInsert()
    var
        lrc_MasterBatchSetup: Record "POI Master Batch Setup";
        lcu_NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        IF "No." = '' THEN BEGIN
            lrc_MasterBatchSetup.GET();
            lrc_MasterBatchSetup.TESTFIELD("Batch Var. No. Series");
            lcu_NoSeriesManagement.InitSeries(lrc_MasterBatchSetup."Batch Var. No. Series", xRec."No. Series", 0D, "No.", "No. Series");
        END;
    end;


    procedure AssistEdit(): Boolean
    var
        lrc_MasterBatchSetup: Record "POI Master Batch Setup";
        lcu_NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        lrc_MasterBatchSetup.GET();
        lrc_MasterBatchSetup.TESTFIELD("Batch Var. No. Series");
        IF lcu_NoSeriesManagement.SelectSeries(lrc_MasterBatchSetup."Batch Var. No. Series", xRec."No. Series", "No. Series") THEN BEGIN
            lcu_NoSeriesManagement.SetSeries("No.");
            EXIT(TRUE);
        END;
    end;

    procedure ItemNo_Validate()
    // var
    //     lcu_BDMBaseDataMgt: Codeunit "5087919";
    //     lrc_Item: Record Item;
    //     lrc_Vendor: Record "Vendor";
    begin
        //     // -----------------------------------------------------------------------------------
        //     // Funktion zur Suche eines Artikels
        //     // -----------------------------------------------------------------------------------
        //     // rco_ItemNo
        //     // vbn_Search
        //     // vop_Source
        //     // vdt_OrderDate
        //     // vco_CustomerNo
        //     // vbn_SearchInAssortment
        //     // vco_AssortmentVersionNo
        //     // -----------------------------------------------------------------------------------
        //     lcu_BDMBaseDataMgt.ItemValidateSearch("Item No.",TRUE,0,0D,'',FALSE,'');
        //     CheckChangeBatchVarAttrib(FIELDNO("Item No."));

        //     lrc_Item.GET("Item No.");
        //     Description := lrc_Item.Description;
        //     "Description 2" := lrc_Item."Description 2";
        //     "Search Description" := lrc_Item."Search Description";
        //     "Variant Code" := '';

        //     IF lrc_Item."Vendor No." <> '' THEN BEGIN
        //       "Vendor No." := lrc_Item."Vendor No.";
        //       IF lrc_Vendor.GET("Vendor No.") THEN BEGIN
        //         "Vendor Search Name" := lrc_Vendor."Search Name";
        //          "B/L Shipper" := lrc_Vendor."B/L Shipper";
        //        END;
        //     END ELSE BEGIN
        //       "Vendor No." := '';
        //       "Vendor Search Name" := '';
        //       "B/L Shipper" := '';
        //     END;

        //     "Producer No." := '';
        //     "Lot No. Producer" := '';
        //     "B/L Shipper" := '';
        //     "Country of Origin Code" := lrc_Item."Country of Origin Code (Fruit)";
        //     "Variety Code" := lrc_Item."Variety Code";
        //     "Trademark Code" := lrc_Item."Trademark Code";
        //     "Caliber Code" := lrc_Item."Caliber Code";
        //     "Vendor Caliber Code" := '';
        //     "Item Attribute 3" := lrc_Item."Item Attribute 3";
        //     "Item Attribute 2" := lrc_Item."Item Attribute 2";
        //     "Grade of Goods Code" := lrc_Item."Grade of Goods Code";
        //     "Item Attribute 7" := lrc_Item."Item Attribute 7";
        //     "Item Attribute 4" := lrc_Item."Item Attribute 4";
        //     "Coding Code" := lrc_Item."Coding Code";
        //     "Item Attribute 5" := lrc_Item."Item Attribute 5";
        //     "Item Attribute 6" := lrc_Item."Item Attribute 6";
        //     "Cultivation Type" := lrc_Item."Cultivation Type";
        //     "Net Weight" := 0;
        //     "Gross Weight" := 0;
        //     "Cultivation Association Code" := '';
        //     "Item Attribute 1" := lrc_Item."Item Attribute 1";
        //     "Empties Posting Item No." := lrc_Item."Empties Posting Item No.";
        //     "Empties Item No." := lrc_Item."Empties Item No.";
        //     "Empties Quantity" := lrc_Item."Empties Quantity";
        //     "Price Base (Purch. Price)" := lrc_Item."Price Base (Purch. Price)";
        //     "Price Base (Sales Price)" := lrc_Item."Price Base (Sales Price)";

        //     "Item Main Category Code" := lrc_Item."Item Main Category Code";
        //     "Item Category Code" := lrc_Item."Item Category Code";
        //     "Product Group Code" := lrc_Item."Product Group Code";

        //     IF lrc_Item."Purch. Unit of Measure" <> '' THEN
        //       "Unit of Measure Code" := lrc_Item."Purch. Unit of Measure"
        //     ELSE
        //       "Unit of Measure Code" := lrc_Item."Base Unit of Measure";
        //     UnitOfMeasure_Validate();
    end;

    procedure UnitOfMeasure_Validate()
    // var
    //     lcu_BaseDataMgt: Codeunit "5087919";
    //     lrc_UnitofMeasure: Record "204";
    //     lrc_Item: Record Item;
    //     ADF_LT_TEXT001: Label 'Basiseinheit Artikel abweichend von Basiseinheit Einheit!';
    begin
        //     // ------------------------------------------------------------------------------------
        //     // Funktion zur Validierung der Einheit
        //     // ------------------------------------------------------------------------------------

        //     lcu_BaseDataMgt.UOMValidateSearch("Unit of Measure Code","Item No.",TRUE,TRUE);
        //     CheckChangeBatchVarAttrib(FIELDNO("Unit of Measure Code"));

        //     lrc_UnitofMeasure.GET("Unit of Measure Code");
        //     lrc_Item.GET("Item No.");
        //     IF lrc_Item."Base Unit of Measure" <> lrc_UnitofMeasure."Base Unit of Measure (BU)" THEN
        //       // Basiseinheit Artikel abweichend von Basiseinheit Einheit!
        //       ERROR(ADF_LT_TEXT001);

        //     "Qty. per Unit of Measure" := lrc_UnitofMeasure."Qty. (BU) per Unit of Measure";

        //     "Base Unit of Measure (BU)" := lrc_UnitofMeasure."Base Unit of Measure (BU)";

        //     "Packing Unit of Measure (PU)" := lrc_UnitofMeasure."Packing Unit of Measure (PU)";
        //     "Qty. (PU) per Collo (CU)" := lrc_UnitofMeasure."Qty. (PU) per Unit of Measure";

        //     IF lrc_UnitofMeasure."Transport Unit of Measure (TU)" <> '' THEN BEGIN
        //       "Transport Unit of Measure (TU)" := lrc_UnitofMeasure."Transport Unit of Measure (TU)";
        //       "Qty. (Unit) per Transp. (TU)" := lrc_UnitofMeasure."Qty. per Transport Unit (TU)";
        //     END ELSE BEGIN
        //       "Transport Unit of Measure (TU)" := '';
        //       "Qty. (Unit) per Transp. (TU)" := 0;
        //     END;

        //     "Content Unit of Measure (CP)" := lrc_UnitofMeasure."Content Unit of Measure (CP)";

        //     "Net Weight" := lrc_UnitofMeasure."Net Weight";
        //     "Gross Weight" := lrc_UnitofMeasure."Gross Weight";
    end;

    procedure EmptiesItemNo_Validate()
    var
    //lrc_Item: Record Item;
    begin

        // IF "Empties Item No." <> '' THEN BEGIN
        //   lrc_Item.GET("Empties Item No.");
        //   "Empties Quantity" := lrc_Item."Empties Quantity";
        // END ELSE
        //   "Empties Quantity" := 0;
    end;

    procedure GetInventory(vco_LocationFilter: Code[20]): Decimal
    var
        lcu_BatchManagement: Codeunit "POI BAM Batch Management";
        ldc_Inventory: Decimal;
        ldc_InventoryAvailable: Decimal;
        ldc_InventoryAvailableExpected: Decimal;
        ldc_QtyInSalesOrder: Decimal;
        ldc_QtyInPurchOrder: Decimal;
        ldc_QtyInReservation: Decimal;
        ldc_QtyInCustomerClearance: Decimal;
        ldc_QtyInInvoice: Decimal;
        ldc_QtyInShipment: Decimal;
        ldc_QtyInReceive: Decimal;
    begin
        lcu_BatchManagement.CalcStockBatchVar("No.",
                                              vco_LocationFilter,
                                              0.1,
                                              ldc_Inventory,
                                              ldc_InventoryAvailable,
                                              ldc_InventoryAvailableExpected,
                                              ldc_QtyInSalesOrder,
                                              ldc_QtyInPurchOrder,
                                              ldc_QtyInReservation,
                                              ldc_QtyInCustomerClearance,
                                              ldc_QtyInInvoice,
                                              ldc_QtyInShipment,
                                              ldc_QtyInReceive,
                                              "Qty. per Unit of Measure");

        EXIT(ldc_Inventory);
    end;

    procedure GetAvailableInventory(vco_LocationFilter: Code[20]): Decimal
    var
        lcu_BatchManagement: Codeunit "POI BAM Batch Management";
        ldc_Inventory: Decimal;
        ldc_InventoryAvailable: Decimal;
        ldc_InventoryAvailableExpected: Decimal;
        ldc_QtyInSalesOrder: Decimal;
        ldc_QtyInPurchOrder: Decimal;
        ldc_QtyInReservation: Decimal;
        ldc_QtyInCustomerClearance: Decimal;
        ldc_QtyInInvoice: Decimal;
        ldc_QtyInShipment: Decimal;
        ldc_QtyInReceive: Decimal;
    begin
        lcu_BatchManagement.CalcStockBatchVar("No.",
                                              vco_LocationFilter,
                                              0.1,
                                              ldc_Inventory,
                                              ldc_InventoryAvailable,
                                              ldc_InventoryAvailableExpected,
                                              ldc_QtyInSalesOrder,
                                              ldc_QtyInPurchOrder,
                                              ldc_QtyInReservation,
                                              ldc_QtyInCustomerClearance,
                                              ldc_QtyInInvoice,
                                              ldc_QtyInShipment,
                                              ldc_QtyInReceive,
                                              "Qty. per Unit of Measure");

        EXIT(ldc_InventoryAvailableExpected);
    end;

    procedure CheckQtyToShipWithoutPallet(vdc_QuantityToShip: Decimal; vco_LocationFilter: Code[20])
    var
        ldc_InventoryAvailableExpected: Decimal;
        AgilesText001Txt: Label 'Batch. Variant %1: the ''Quantity to Ship'' without Pallets kann''t be more then %2 ', Comment = '%1 %2';
    begin
        // --------------------------------------------------------------------------------
        // Funktion prüft, ob die 'Menge zu liefern' ohne Palleten im Warenausgang geliefert werden darf
        // --------------------------------------------------------------------------------

        IF vdc_QuantityToShip <= 0 THEN
            EXIT;

        // Der gesamte Bestand auf den Paletten feststellen
        CALCFIELDS("B.V. Inventory Pallets");

        // Prüfen nur, wenn die Menge auf den Paletten eingekauft wurde ist
        IF "B.V. Inventory Pallets" = 0 THEN
            EXIT;

        // Der verfügbare Bestand auf dem Lagerort feststellen. Die aktuelle Zeile darf nicht berücksichtigt werden
        ldc_InventoryAvailableExpected := GetAvailableInventory(vco_LocationFilter) + vdc_QuantityToShip;
        IF vdc_QuantityToShip > ldc_InventoryAvailableExpected - "B.V. Inventory Pallets" THEN
            ERROR(AgilesText001Txt, "No.", ldc_InventoryAvailableExpected - "B.V. Inventory Pallets");
        // PAL 002 DMG50019.e
    end;

    procedure GetQuantitySalesOrder(vco_LocationFilter: Code[20]): Decimal
    var
        lcu_BatchManagement: Codeunit "POI BAM Batch Management";
        ldc_Inventory: Decimal;
        ldc_InventoryAvailable: Decimal;
        ldc_InventoryAvailableExpected: Decimal;
        ldc_QtyInSalesOrder: Decimal;
        ldc_QtyInPurchOrder: Decimal;
        ldc_QtyInReservation: Decimal;
        ldc_QtyInCustomerClearance: Decimal;
        ldc_QtyInInvoice: Decimal;
        ldc_QtyInShipment: Decimal;
        ldc_QtyInReceive: Decimal;
    begin
        lcu_BatchManagement.CalcStockBatchVar("No.",
                                              vco_LocationFilter,
                                              0.1,
                                              ldc_Inventory,
                                              ldc_InventoryAvailable,
                                              ldc_InventoryAvailableExpected,
                                              ldc_QtyInSalesOrder,
                                              ldc_QtyInPurchOrder,
                                              ldc_QtyInReservation,
                                              ldc_QtyInCustomerClearance,
                                              ldc_QtyInInvoice,
                                              ldc_QtyInShipment,
                                              ldc_QtyInReceive,
                                              "Qty. per Unit of Measure");

        IF ("Qty. per Unit of Measure" <> 1) AND ("Qty. per Unit of Measure" <> 0) THEN
            ldc_QtyInSalesOrder := ROUND((ldc_QtyInSalesOrder / "Qty. per Unit of Measure"), 0.1);

        EXIT(ldc_QtyInSalesOrder);
    end;

    procedure GetQuantityTransferOrder(vco_LocationFilter: Code[20]; var rdc_QtyShip: Decimal; var rdc_QtyRec: Decimal)
    var
        lrc_Location: Record Location;
        lcu_StockManagement: Codeunit "POI Stock Management";
        lco_LocationFilter: Code[20];
    begin
        IF vco_LocationFilter <> '' THEn
            IF lrc_Location.GET(vco_LocationFilter) THEN BEGIN
                // Filter für Lagerorte aufbauen
                lco_LocationFilter := copystr(lcu_StockManagement.GetLocFilter(lrc_Location.Code), 1, 20);
                // Filter Lagerorte setzen
                IF lco_LocationFilter = '' THEN
                    SETRANGE("Location Filter")
                ELSE
                    SETFILTER("Location Filter", lco_LocationFilter);
            END ELSE
                SETFILTER("Location Filter", vco_LocationFilter);

        CALCFIELDS("B.V. Transfer Ship (Qty)", "B.V. Transfer Rec. (Qty)");

        IF ("Qty. per Unit of Measure" <> 1) AND ("Qty. per Unit of Measure" <> 0) THEN BEGIN
            rdc_QtyShip := ROUND(("B.V. Transfer Ship (Qty)" / "Qty. per Unit of Measure"), 0.1);
            rdc_QtyRec := ROUND(("B.V. Transfer Rec. (Qty)" / "Qty. per Unit of Measure"), 0.1);
        END ELSE BEGIN
            rdc_QtyShip := "B.V. Transfer Ship (Qty)";
            rdc_QtyRec := "B.V. Transfer Rec. (Qty)";
        END;
    end;

    procedure GetQuantityInPurchase(): Decimal
    var
        lrc_PurchaseLine: Record "Purchase Line";
    begin
        IF lrc_PurchaseLine.GET(Source, "Source No.", "Source Line No.") THEN
            EXIT(lrc_PurchaseLine.Quantity)
        ELSE
            EXIT(0);
    end;

    procedure GetQtyInDispolines(): Decimal
    begin
        lrc_Dispolines.Quantity := 0;
        lrc_Dispolines.RESET();
        lrc_Dispolines.SETCURRENTKEY("Batch No.", "Batch Variant No.", "Document Line Line No.", "Target Type");
        lrc_Dispolines.SETRANGE("Batch No.", "Batch No.");
        lrc_Dispolines.SETRANGE("Batch Variant No.", "No.");
        lrc_Dispolines.CALCSUMS(Quantity);
        EXIT(lrc_Dispolines.Quantity);
    end;

    procedure GetQtyInDispolinesMainWeek(): Decimal
    var
        ldc_Quantity: Decimal;
    begin
        ldc_Quantity := 0;
        lrc_Dispolines.RESET();
        lrc_Dispolines.SETCURRENTKEY("Batch No.", "Batch Variant No.", "Target No", "Disposition For Week");
        lrc_Dispolines.SETRANGE("Batch No.", "Batch No.");
        lrc_Dispolines.SETRANGE("Batch Variant No.", "No.");
        lrc_Dispolines.SETFILTER("Disposition For Week", '%1', '');
        IF lrc_Dispolines.FIND('-') THEN
            REPEAT
                ldc_Quantity += lrc_Dispolines.Quantity;
            UNTIL lrc_Dispolines.NEXT() = 0;
        EXIT(ldc_Quantity);
    end;

    procedure GetQtyInDispolinesDisplaced(): Decimal
    var
        ldc_Quantity: Decimal;
    begin
        lrc_Dispolines.Quantity := 0;
        lrc_Dispolines.RESET();
        lrc_Dispolines.SETCURRENTKEY("Batch No.", "Batch Variant No.", "Target No", "Disposition For Week");
        lrc_Dispolines.SETRANGE("Batch No.", "Batch No.");
        lrc_Dispolines.SETRANGE("Batch Variant No.", "No.");
        lrc_Dispolines.SETFILTER("Disposition For Week", '<>%1', '');
        IF lrc_Dispolines.FIND('-') THEN
            REPEAT
                ldc_Quantity += lrc_Dispolines.Quantity;
            UNTIL lrc_Dispolines.NEXT() = 0;
        EXIT(ldc_Quantity);
    end;

    procedure GetQtyInDispolinesAssignInDoc(): Decimal
    begin
        lrc_Dispolines.Quantity := 0;
        lrc_Dispolines.RESET();
        lrc_Dispolines.SETCURRENTKEY("Batch No.", "Batch Variant No.", "Document Line Line No.", "Target Type");
        lrc_Dispolines.SETRANGE("Batch No.", "Batch No.");
        lrc_Dispolines.SETRANGE("Batch Variant No.", "No.");
        lrc_Dispolines.SETFILTER("Document Type", '<>%1', lrc_Dispolines."Document Type"::Position);
        lrc_Dispolines.CALCSUMS(Quantity);
        EXIT(lrc_Dispolines.Quantity);
    end;

    procedure GetQtyAssignedOutsideDispoline(): Decimal
    var
        ldc_QtyInPurchase: Decimal;
        ldc_QtyInDispo: Decimal;
        ldc_QtyInDispoInDoc: Decimal;
        ldc_Inventory: Decimal;
        ldc_QtyInDoc: Decimal;
    begin
        ldc_QtyInPurchase := GetQuantityInPurchase();
        ldc_QtyInDispo := GetQtyInDispolines();
        ldc_QtyInDispoInDoc := GetQtyInDispolinesAssignInDoc();
        ldc_Inventory := GetAvailableInventory("Entry Location Code");
        ldc_QtyInDoc := ldc_QtyInPurchase - ldc_Inventory;
        EXIT(ldc_QtyInDoc - ldc_QtyInDispoInDoc);
    end;

    procedure CheckAssigments()
    begin
        // Kalkulierung der Felder
        CALCFIELDS("B.V. Inventory (Qty.)", "B.V. Purch. Order (Qty)",
                   "B.V. Sales Order (Qty)", "B.V. FV Reservation (Qty)",
                   "B.V. Transfer Rec. (Qty)", "B.V. Transfer Ship (Qty)",
                   "B.V. Pack. Input (Qty)", "B.V. Pack. Pack.-Input (Qty)",
                   "B.V. Pack. Output (Qty)", "B.V. Customer Clearance (Qty.)",
                   "B.V. Sales Shipped (Qty)", "B.V. Sales Cr. Memo (Qty)",
                   "B.V. Sales Inv. (Qty.)");

        // Prüfung auf Zuweisungen in ungebuchten Tabellen
        // TESTFIELD("B.V. Purch. Order (Qty)",0);
        TESTFIELD("B.V. Sales Order (Qty)", 0);
        TESTFIELD("B.V. FV Reservation (Qty)", 0);
        TESTFIELD("B.V. Transfer Rec. (Qty)", 0);
        TESTFIELD("B.V. Transfer Ship (Qty)", 0);
        TESTFIELD("B.V. Pack. Input (Qty)", 0);
        TESTFIELD("B.V. Pack. Pack.-Input (Qty)", 0);
        // TESTFIELD("B.V. Pack. Output (Qty)",0);
        TESTFIELD("B.V. Customer Clearance (Qty.)", 0);
        TESTFIELD("B.V. Sales Cr. Memo (Qty)", 0);
    end;

    procedure CheckChangeBatchVarAttrib(vin_FieldNo: Integer)
    begin
        // --------------------------------------------------------------------------------
        // Funktion zur Prüfung ob bereits Belege mit der Pos.-Var. verbunden sind
        // --------------------------------------------------------------------------------

        IF (CurrFieldNo = 0) OR
           (CurrFieldNo <> vin_FieldNo) THEN
            EXIT;

        CASE vin_FieldNo OF
            FIELDNO("Unit of Measure Code"),
          FIELDNO("Caliber Code"),
          FIELDNO("Country of Origin Code"),
          FIELDNO("Empties Item No."),
          FIELDNO("Cultivation Type"),
          FIELDNO("Transport Unit of Measure (TU)"),
          FIELDNO("Qty. (Unit) per Transp. (TU)"):
                ;
            ELSE BEGIN
                    CALCFIELDS("B.V. Inventory (Qty.)", "B.V. Sales Order (Qty)",
                               "B.V. Sales Shipped (Qty)", "B.V. Purch. Rec. (Qty)");
                    IF ("B.V. Inventory (Qty.)" <> 0) OR
                       ("B.V. Sales Shipped (Qty)" <> 0) OR
                       ("B.V. Purch. Rec. (Qty)" <> 0) OR
                       ("B.V. Sales Order (Qty)" <> 0) THEN
                        ERROR('Änderung nicht zulässig!')
                    ELSE
                        EXIT;
                END;
        END;

        CALCFIELDS("B.V. Inventory (Qty.)", "B.V. Sales Order (Qty)",
                   "B.V. Sales Shipped (Qty)", "B.V. Purch. Rec. (Qty)");
        IF ("B.V. Inventory (Qty.)" <> 0) OR
           ("B.V. Sales Shipped (Qty)" <> 0) OR
           ("B.V. Purch. Rec. (Qty)" <> 0) THEN
            ERROR('Änderung nicht zulässig!');

        IF "B.V. Sales Order (Qty)" <> 0 THEN BEGIN
            IF NOT CONFIRM('Es sind bereits Aufträge zugeordnet! Trotzdem ändern?') THEN
                ERROR('');
            lrc_SalesLine.RESET();
            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
            lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
            lrc_SalesLine.SETRANGE("POI Batch Variant No.", "No.");
            lrc_SalesLine.SETRANGE("No.", "Item No.");
            IF lrc_SalesLine.FINDSET(TRUE, FALSE) THEN
                REPEAT
                    CASE vin_FieldNo OF
                        FIELDNO("Unit of Measure Code"):
                            lrc_SalesLine.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
                        FIELDNO("Caliber Code"):
                            lrc_SalesLine.VALIDATE("POI Caliber Code", "Caliber Code");
                        FIELDNO("Country of Origin Code"):
                            lrc_SalesLine.VALIDATE("POI Country of Origin Code", "Country of Origin Code");

                        FIELDNO("Cultivation Type"):
                            lrc_SalesLine.VALIDATE("POI Cultivation Type", "Cultivation Type");

                        FIELDNO("Empties Item No."):
                            lrc_SalesLine.VALIDATE("POI Empties Item No.", "Empties Item No.");

                        FIELDNO("Transport Unit of Measure (TU)"):
                            lrc_SalesLine.VALIDATE("POI Transp. Unit of Meas (TU)", "Transport Unit of Measure (TU)");

                        FIELDNO("Qty. (Unit) per Transp. (TU)"):
                            lrc_SalesLine.VALIDATE("POI Qty.(Unit) per Transp.(TU)", "Qty. (Unit) per Transp. (TU)");
                        ELSE
                            EXIT;
                    END;
                    lrc_SalesLine.MODIFY(TRUE);
                UNTIL lrc_SalesLine.NEXT() = 0;
        END;
    end;

    var
        lrc_Dispolines: Record "POI Dispolines";
        lrc_SalesLine: Record "Sales Line";
    ///???gcu_GlobalFunctionsMgt: Codeunit "5110300";
    //ADF_GT_TEXT001Txt: Label 'Löschung nicht zulässig, Positionsvariante %1 ist in Belegen zugeordnet!';
    //gbn_AllowIndirectValidate: Boolean;

}

