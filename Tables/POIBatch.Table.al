table 5110365 "POI Batch"
{
    Caption = 'Batch';
    //DrillDownFormID = Form5110481;
    //LookupFormID = Form5110481;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            NotBlank = true;

            trigger OnValidate()
            var
                BatchSetup: Record "POI Master Batch Setup";
                NoSeriesManagement: Codeunit NoSeriesManagement;
            begin
                // Wenn die Partienummer gelöscht oder geändert wird, wird geprüft, ob eine manuelle Vergabe im verwendeten
                // Nummernkreis zugelassen ist.
                IF "No." <> xRec."No." THEN
                    BatchSetup.GET();
                NoSeriesManagement.TestManual(BatchSetup."Purch. Batch No. Series");
            end;
        }
        field(8; "No. 2"; Code[20])
        {
            Caption = 'No. 2';
            DataClassification = CustomerContent;
        }
        field(10; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            DataClassification = CustomerContent;
            NotBlank = true;
            //TableRelation = "Master Batch";
        }
        field(11; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = CustomerContent;
        }
        field(12; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(13; "Lot No. Producer"; Code[30])
        {
            Caption = 'Lot No. Producer';
            DataClassification = CustomerContent;
        }
        field(14; "Producer No."; Code[20])
        {
            Caption = 'Producer No.';
            DataClassification = CustomerContent;
            TableRelation = Manufacturer;
        }
        field(15; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;

            trigger OnValidate()
            var
                lrc_Vendor: Record "Vendor";
            begin
                IF lrc_Vendor.GET("Vendor No.") THEN
                    "Vendor Search Name" := lrc_Vendor."Search Name"
                ELSE
                    "Vendor Search Name" := '';
            end;
        }
        field(18; "Batch Variant Postfix Counter"; Integer)
        {
            Caption = 'Batch Variant Postfix Counter';
            DataClassification = CustomerContent;
        }
        field(19; "Vendor Order No."; Code[35])
        {
            Caption = 'Vendor Order No.';
            DataClassification = CustomerContent;
        }
        field(23; "B/L Shipper"; Code[20])
        {
            Caption = 'B/L Shipper';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(24; "Vendor Search Name"; Code[100])
        {
            Caption = 'Vendor Search Name';
            DataClassification = CustomerContent;
        }
        field(25; "Kind of Settlement"; Option)
        {
            Caption = 'Kind of Settlement';
            DataClassification = CustomerContent;
            Description = 'Fixed Price,Commission,Account Sale + Commission';
            OptionCaption = 'Fix Price,Commission,Account Sale+Commission';
            OptionMembers = "Fixed Price",Commission,"Account Sale + Commission";
        }
        field(26; "Company Season Code"; Code[10])
        {
            Caption = 'Company Season Code';
            DataClassification = CustomerContent;
            //TableRelation = "Company Season";
        }
        field(29; "Kind of Loading"; Option)
        {
            Caption = 'Kind of Loading';
            DataClassification = CustomerContent;
            Description = ' ,Container,Reefer Vessel,,,Konventionell';
            OptionCaption = ' ,Container,Reefer Vessel,,,Konventionell';
            OptionMembers = " ",Container,"Reefer Vessel",,,Konventionell;
        }
        field(30; "Voyage No."; Code[20])
        {
            Caption = 'Voyage No.';
            DataClassification = CustomerContent;
            //TableRelation = Voyage;
        }
        field(31; "Container No."; Code[20])
        {
            Caption = 'Container No.';
            DataClassification = CustomerContent;
        }
        field(32; "Means of Transport Type"; Option)
        {
            Caption = 'Means of Transport Type';
            DataClassification = CustomerContent;
            Description = ' ,Truck,Train,Ship,Airplane';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;
        }
        field(33; "Means of Transp. Code (Arriva)"; Code[20])
        {
            Caption = 'Means of Transp. Code (Arriva)';
            DataClassification = CustomerContent;
            //TableRelation = IF ("Means of Transport Type"=CONST(Ship)) "Means of Transport".Code WHERE (Type=FIELD("Means of Transport Type"));
        }
        field(34; "Means of Transport Info"; Code[30])
        {
            Caption = 'Means of Transport Info';
            DataClassification = CustomerContent;
        }
        field(35; "Departure Region Code"; Code[20])
        {
            Caption = 'Departure Region Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Departure Region";
        }
        field(36; "Port of Discharge Code"; Code[10])
        {
            Caption = 'Port of Discharge Code';
            DataClassification = CustomerContent;
            Description = 'Eventuell überflüssig druch Entry Point';
            //TableRelation = Harbour;
        }
        field(37; "Date of Discharge"; Date)
        {
            Caption = 'Date of Discharge';
            DataClassification = CustomerContent;
        }
        field(38; "Time of Discharge"; Time)
        {
            Caption = 'Time of Discharge';
            DataClassification = CustomerContent;
        }
        field(40; "Receipt Info"; Text[30])
        {
            Caption = 'Receipt Info';
            DataClassification = CustomerContent;
        }
        field(41; "Location's Reference No."; Code[20])
        {
            Caption = 'Location''s Reference No.';
            DataClassification = CustomerContent;
        }
        field(42; "Entry Location Code"; Code[10])
        {
            Caption = 'Entry Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(43; "Info 1"; Code[50])
        {
            CaptionClass = '5110300,1,1';
            DataClassification = CustomerContent;
            Caption = 'Info 1';
            Description = 'BSI';
        }
        field(44; "Info 2"; Code[50])
        {
            CaptionClass = '5110300,1,2';
            DataClassification = CustomerContent;
            Caption = 'Info 2';
            Description = 'BSI';
        }
        field(45; "Info 3"; Code[50])
        {
            CaptionClass = '5110300,1,3';
            DataClassification = CustomerContent;
            Caption = 'Info 3';
            Description = 'BSI';
        }
        field(46; "Info 4"; Code[50])
        {
            CaptionClass = '5110300,1,4';
            DataClassification = CustomerContent;
            Caption = 'Info 4';
            Description = 'BSI';
        }
        field(47; "Shelf No."; Code[10])
        {
            Caption = 'Shelf No.';
            DataClassification = CustomerContent;
        }
        field(48; "Via Entry Location Code"; Code[10])
        {
            Caption = 'Via Entry Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(50; "Departure Date"; Date)
        {
            Caption = 'Departure Date';
            DataClassification = CustomerContent;
        }
        field(52; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
            DataClassification = CustomerContent;
        }
        field(54; "Promised Receipt Date"; Date)
        {
            Caption = 'Promised Receipt Date';
            DataClassification = CustomerContent;
        }
        field(55; "Promised Receipt Time"; Time)
        {
            Caption = 'Promised Receipt Time';
            DataClassification = CustomerContent;
        }
        field(56; "Date of Delivery"; Date)
        {
            Caption = 'Date of Delivery';
            DataClassification = CustomerContent;
        }
        field(59; "Date of Expiry"; Date)
        {
            Caption = 'Date of Expiry';
            DataClassification = CustomerContent;
        }
        field(60; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(61; "Item Description"; Text[50])
        {
            Caption = 'Item Description';
            DataClassification = CustomerContent;
        }
        field(62; "Item Description 2"; Text[50])
        {
            Caption = 'Item Description 2';
            DataClassification = CustomerContent;
        }
        field(63; "Item Search Description"; Code[60])
        {
            Caption = 'Item Search Description';
            DataClassification = CustomerContent;
        }
        field(64; "Item No. 2"; Code[20])
        {
            Caption = 'Item No. 2';
            DataClassification = CustomerContent;
        }
        field(65; "Item Variant Code"; Code[10])
        {
            Caption = 'Item Variant Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(67; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(68; "Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            DataClassification = CustomerContent;
            //TableRelation = Variety;
        }
        field(69; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            DataClassification = CustomerContent;
            //TableRelation = Trademark;
        }
        field(70; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            DataClassification = CustomerContent;
            //TableRelation = Caliber;
            //ValidateTableRelation = false;
        }
        field(71; "Vendor Caliber Code"; Code[10])
        {
            Caption = 'Vendor Caliber Code';
            DataClassification = CustomerContent;
            //TableRelation = "Caliber - Vendor Caliber"."Vend. Caliber Code";
        }
        field(72; "Item Attribute 3"; Code[10])
        {
            CaptionClass = '5110310,1,3';
            DataClassification = CustomerContent;
            Caption = 'Quality Code';
            //TableRelation = "Item Attribute 3";
        }
        field(73; "Item Attribute 2"; Code[10])
        {
            CaptionClass = '5110310,1,2';
            DataClassification = CustomerContent;
            Caption = 'Color Code';
            //TableRelation = "Item Attribute 2";
        }
        field(74; "Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            DataClassification = CustomerContent;
            //TableRelation = "Grade of Goods";
        }
        field(75; "Item Attribute 7"; Code[10])
        {
            CaptionClass = '5110310,1,7';
            DataClassification = CustomerContent;
            Caption = 'Conservation Code';
            //TableRelation = "Item Attribute 7";
        }
        field(76; "Item Attribute 4"; Code[10])
        {
            CaptionClass = '5110310,1,4';
            DataClassification = CustomerContent;
            Caption = 'Packing Code';
            //TableRelation = "Item Attribute 4";
        }
        field(77; "Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            DataClassification = CustomerContent;
            //TableRelation = Coding;
        }
        field(78; "Item Attribute 5"; Code[10])
        {
            CaptionClass = '5110310,1,5';
            DataClassification = CustomerContent;
            Caption = 'Treatment Code';
            //TableRelation = "Item Attribute 5";
        }
        field(79; "Item Attribute 6"; Code[20])
        {
            CaptionClass = '5110310,1,6';
            DataClassification = CustomerContent;
            Caption = 'Proper Name Code';
            //TableRelation = "Proper Name";
        }
        field(80; "Freight Inv. Received"; Boolean)
        {
            Caption = 'Freight Inv. Received';
            DataClassification = CustomerContent;
        }
        field(81; "Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;
        }
        field(82; "Item Attribute 1"; Code[10])
        {
            CaptionClass = '5110310,1,1';
            DataClassification = CustomerContent;
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            //TableRelation = "Item Attribute 1";
        }
        field(84; "Means of Transp. Code (Depart)"; Code[20])
        {
            Caption = 'Means of Transp. Code (Depart)';
            DataClassification = CustomerContent;
            //TableRelation = "Means of Transport".Code WHERE (Type=FIELD("Means of Transport Type"));
            //ValidateTableRelation = false;
        }
        field(85; "Waste Disposal Duty"; Option)
        {
            Caption = 'Waste Disposal Duty';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Green Point Duty';
            OptionMembers = " ","Green Point Duty";
        }
        field(86; "Waste Disposal Payment By"; Option)
        {
            Caption = 'Waste Disposal Payment By';
            DataClassification = CustomerContent;
            OptionCaption = 'Us,Vendor';
            OptionMembers = Us,Vendor;
        }
        field(88; "Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Verzollt,Unverzollt';
            OptionMembers = " ",Verzollt,Unverzollt;
        }
        field(90; "Type of Packing Product"; Option)
        {
            Caption = 'Type of Packing Product';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Finished Product,,,Industry Goods,,,Fruit Juice,,,Spoilt,,,Sub-/Out-Size';
            OptionMembers = " ","Finished Product",,,"Industry Goods",,,"Fruit Juice",,,Spoilt,,,"Sub-/Out-Size";
        }
        field(92; "Item Main Category Code"; Code[10])
        {
            Caption = 'Item Main Category Code';
            DataClassification = CustomerContent;
            //TableRelation = "Item Main Category";
        }
        field(93; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Category";

        }
        field(94; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
        }
        field(110; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DataClassification = CustomerContent;
        }
        field(111; "Base Unit of Measure (BU)"; Code[10])
        {
            Caption = 'Base Unit of Measure (BU)';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(113; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            //TableRelation = "Unit of Measure".Code WHERE ("Is Collo Unit of Measure"=CONST(Yes));
        }
        field(114; "Packing Unit of Measure (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            DataClassification = CustomerContent;
            //TableRelation = "Unit of Measure" WHERE ("Is Packing Unit of Measure"=CONST(Yes));
        }
        field(115; "Qty. (PU) per Collo (CU)"; Decimal)
        {
            Caption = 'Qty. (PU) per Collo (CU)';
            DataClassification = CustomerContent;
        }
        field(118; "Transport Unit of Measure (TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            DataClassification = CustomerContent;
            //TableRelation = "Unit of Measure" WHERE("Is Transport Unit of Measure" = CONST(Yes));
        }
        field(119; "Qty. (Unit) per Transp. (TU)"; Decimal)
        {
            Caption = 'Qty. (Unit) per Transp. (TU)';
            DataClassification = CustomerContent;
        }
        field(121; "Content Unit of Measure (CP)"; Code[10])
        {
            Caption = 'Content Unit of Measure (CP)';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }
        field(122; "Qty. (BU) per Collo (CU)"; Decimal)
        {
            Caption = 'Qty. (BU) per Collo (CU)';
            DataClassification = CustomerContent;
        }
        field(125; "Price Base (Purch. Price)"; Code[10])
        {
            Caption = 'Price Base (Purch. Price)';
            DataClassification = CustomerContent;
            // TableRelation = "Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Purch. Price"),
            //                                          Blocked = CONST(No));
        }
        field(126; "Purch. Price (Price Base)"; Decimal)
        {
            Caption = 'Purch. Price (Price Base)';
            DataClassification = CustomerContent;
        }
        field(127; "Price Base (Sales Price)"; Code[10])
        {
            Caption = 'Price Base (Sales Price)';
            DataClassification = CustomerContent;
            //TableRelation = "Price Base".Code WHERE ("Purch./Sales Price Calc."=CONST("Sales Price"),
            //                                         Blocked=CONST(No));
        }
        field(128; "Sales Price (Price Base)"; Decimal)
        {
            Caption = 'Sales Price (Price Base)';
            DataClassification = CustomerContent;
        }
        field(129; "Market Unit Cost (Base) (LCY)"; Decimal)
        {
            Caption = 'Market Unit Cost (Base) (LCY)';
            DataClassification = CustomerContent;
        }
        field(130; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = CustomerContent;
        }
        field(131; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DataClassification = CustomerContent;
        }
        field(133; Weight; Option)
        {
            Caption = 'Weight';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Net Weight,Gross Weight,Manuel Weight';
            OptionMembers = " ","Net Weight","Gross Weight","Manuel Weight";
        }
        field(135; "Empties Item No."; Code[20])
        {
            Caption = 'Empties Item No.';
            DataClassification = CustomerContent;
            //TableRelation = Item WHERE ("Item Typ"=CONST("Empties Item"));
        }
        field(136; "Empties Quantity"; Decimal)
        {
            Caption = 'Empties Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(137; "Empties Posting Item No."; Code[20])
        {
            Caption = 'Empties Posting Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(140; "Blocked from User ID"; Code[20])
        {
            Caption = 'Blocked from User ID';
            DataClassification = CustomerContent;
            Editable = false;
            //TableRelation = User."User ID";
        }
        field(141; "Date of Blocking"; Date)
        {
            Caption = 'Date of Blocking';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(142; "Time of Blocking"; Time)
        {
            Caption = 'Time of Blocking';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(143; "Blocking Comment"; Text[80])
        {
            Caption = 'Blocking Comment';
            DataClassification = CustomerContent;
        }
        field(144; "Released from User ID"; Code[20])
        {
            Caption = 'Released from User ID';
            DataClassification = CustomerContent;
            Editable = false;
            //TableRelation = User."User ID";
        }
        field(145; "Date of Releasing"; Date)
        {
            Caption = 'Date of Releasing';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(146; "Time of Releasing"; Time)
        {
            Caption = 'Time of Releasing';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(151; "Calc. Cost per Unit"; Decimal)
        {
            Caption = 'Calc. Cost per Unit';
            DataClassification = CustomerContent;
        }
        field(152; "Cost Calc. (UOM) (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            // FieldClass = FlowField;
            // CalcFormula = Sum ("Cost Calc. - Enter Data"."Cost per Collo" WHERE("POI Batch No." = FIELD("No."),
            //                                                                     "Indirect Cost (Purchase)"=CONST(Yes),
            //                                                                     "Entry Type"=CONST("Detail Batch")));
            Caption = 'Cost Calc. per Unit (LCY)';
            Editable = false;

        }
        field(160; "Posted Indirect Purch. Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("G/L Entry".Amount WHERE("POI Batch No." = FIELD("No."),
                                                        "POI Cost Allocation" = CONST("Indirect Purchase Cost"),
                                                        "POI Income/Balance" = CONST("Income Statement")));
            Caption = 'Posted Indirect Purch. Cost';
            Editable = false;

        }
        field(195; Source; Option)
        {
            Caption = 'Source';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Purch. Order,Packing Order,Sorting Order,,Item Journal Line,Inventory Journal Line,Assortment,,Company Copy,,,Dummy';
            OptionMembers = " ","Purch. Order","Packing Order","Sorting Order",,"Item Journal Line","Inventory Journal Line",Assortment,,"Company Copy",,,Dummy;
        }
        field(196; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
        }
        field(197; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
            DataClassification = CustomerContent;
        }
        field(198; Comment; Boolean)
        {
            // CalcFormula = Exist ("Batch Comment" WHERE(Source = CONST(Batch),
            //                                            "Source No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(200; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(201; "Basis Positionssub.-Nr."; Code[10])
        {
            Caption = 'Basis Positionssub.-Nr.';
            DataClassification = CustomerContent;
        }
        field(202; "Letzte Positionssub.-Nr."; Integer)
        {
            Caption = 'Letzte Positionssub.-Nr.';
            DataClassification = CustomerContent;
            Description = 'Zähler zur Vergabe der Partiezeilennummer';
        }
        field(205; Anlagedatum; Date)
        {
            Caption = 'Anlagedatum';
            DataClassification = CustomerContent;
        }
        field(220; State; Option)
        {
            Caption = 'State';
            DataClassification = CustomerContent;
            Description = 'Neuanlage,Offen,Geschlossen,Abgerechnet,Gesperrt,Löschung';
            OptionCaption = 'New,Open,Closed,Account Sale,Blocked,Manual Blocked,Deleted';
            OptionMembers = New,Open,Closed,"Account Sale",Blocked,"Manual Blocked",Deleted;
        }
        field(300; "Release Date"; Date)
        {
            Caption = 'Release Date';
            DataClassification = CustomerContent;
            Description = 'PVP';

            trigger OnValidate()
            var
                lInt_Year: Integer;
                lCod_Year: Code[4];
            begin
                IF "Release Date" <> 0D THEN BEGIN
                    lInt_Year := DATE2DWY("Release Date", 3);
                    lCod_Year := FORMAT(lInt_Year);
                    IF STRLEN(lCod_Year) > 2 THEN
                        lCod_Year := COPYSTR(lCod_Year, STRLEN(lCod_Year) - 1, 2)
                    ELSE
                        IF STRLEN(lCod_Year) = 1 THEN
                            lCod_Year := CopyStr('0' + lCod_Year, 1, 4);

                    IF DATE2DWY("Release Date", 2) < 10 THEN
                        "Disposition Week" := CopyStr('0' + FORMAT(DATE2DWY("Release Date", 2)) + '_' + lCod_Year, 1, 5)
                    ELSE
                        "Disposition Week" := FORMAT(DATE2DWY("Release Date", 2)) + '_' + lCod_Year;
                END;
            end;
        }
        field(301; "Disposition Week"; Code[5])
        {
            Caption = 'Disposition Week';
            DataClassification = CustomerContent;
            Description = 'PVP';

            trigger OnValidate()
            var
                ADF_LT_TEXT001Txt: Label 'Die Planungswoche %1 ist bereits bei %2 Planungszeilen hinterlegt !', Comment = '%1 %2';
            begin
                IF "Disposition Week" <> '' THEN BEGIN
                    lrc_Dispolines.Check_DispoKW("Disposition Week");
                    lrc_Dispolines.RESET();
                    lrc_Dispolines.SETCURRENTKEY("Batch No.", "Target No", "Batch Variant No.", "Disposition For Week");
                    lrc_Dispolines.SETRANGE("Batch No.", "No.");
                    lrc_Dispolines.SETRANGE(lrc_Dispolines."Disposition For Week", "Disposition Week");
                    IF lrc_Dispolines.FINDFIRST() THEN
                        ERROR(ADF_LT_TEXT001Txt, "Disposition Week", lrc_Dispolines.COUNT());
                END;
            end;
        }
        field(302; "Qty. Disposition Plan Cust."; Decimal)
        {
            // CalcFormula = Sum(Dispolines.Quantity WHERE ("POI Batch No."=FIELD("No."),
            //                                              "Target Type"=CONST(Customer)));
            Caption = 'Quantity Customer Disposition Planning Lines On File No.';
            Description = 'PVP';
            Editable = false;
            FieldClass = FlowField;
        }
        field(303; "Release Planning"; Boolean)
        {
            Caption = 'Release Planning';
            DataClassification = CustomerContent;
            Description = 'PVP';

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
                ADF_LT_TEXT002Txt: Label 'Es sind keine Mengen in Planungszeilen zugewiesen !';
                ldc_QtyDispolines: Decimal;
            begin
                IF "Release Planning" <> xRec."Release Planning" THEN BEGIN
                    UserSetup.RESET();
                    UserSetup.GET(USERID());
                    IF "Release Planning" = TRUE THEN BEGIN
                        CALCFIELDS("Qty. Disposition Plan Cust.", "Qty. Disposition Plan Cust.-Gr");

                        CALCFIELDS("Qty. Disposition Plan Location", "Qty. Disposition Plan MatAtLoc",
                                   "Qty. DispositionPlan MatForLoc", "Qty. Disposition Plan MatforCu");
                        ldc_QtyDispolines := "Qty. Disposition Plan Cust." + "Qty. Disposition Plan Cust.-Gr" + "Qty. Disposition Plan Location" +
                                             "Qty. Disposition Plan MatAtLoc" + "Qty. DispositionPlan MatForLoc" + "Qty. Disposition Plan MatforCu";
                        IF ldc_QtyDispolines = 0 THEN
                            ERROR(ADF_LT_TEXT002Txt);

                        "Release Planning User" := CopyStr(USERID(), 1, 20);
                        "Release Planning Date" := WORKDATE();
                    END ELSE BEGIN
                        "Release Planning User" := '';
                        "Release Planning Date" := 0D;
                    END;
                END;
            end;
        }
        field(304; "Release Planning User"; Code[20])
        {
            Caption = 'User Release Planning';
            DataClassification = CustomerContent;
            Description = 'PVP';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(305; "Release Planning Date"; Date)
        {
            Caption = 'Release Planning Date';
            DataClassification = CustomerContent;
            Description = 'PVP';
            Editable = false;
        }
        field(306; "Dispolines with DispoWeek Cust"; Integer)
        {
            // CalcFormula = Count(Dispolines WHERE ("POI Batch No."=FIELD("No."),
            //                                       "Disposition For Week"=FIELD("Disposition Week Filter"),
            //                                       Quantity=FILTER(<>0),
            //                                       "Target Type"=CONST(Customer)));
            Caption = 'Dispolines Customer with Disposition for Week';
            Description = 'PVP, Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(307; "Disposition Week Filter"; Code[5])
        {
            Caption = 'Disposition Week Filter';
            Description = 'PVP';
            FieldClass = FlowFilter;
        }
        field(308; "Qty. Disposition Plan Cust.-Gr"; Decimal)
        {
            // CalcFormula = Sum(Dispolines.Quantity WHERE ("POI Batch No."=FIELD("No."),
            //                                              "Target Type"=CONST("Customer Group")));
            Caption = 'Quantity Customer Group Disposition Planning Lines On File No.';
            Description = 'PVP, Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(309; "Dispolines with DispoWeek CuGr"; Integer)
        {
            // CalcFormula = Count(Dispolines WHERE ("POI Batch No."=FIELD("No."),
            //                                       "Disposition For Week"=FIELD("Disposition Week Filter"),
            //                                       Quantity=FILTER(<>0),
            //                                       "Target Type"=CONST("Customer Group")));
            Caption = 'Dispolines Customer Group with Disposition for Week';
            Description = 'PVP, Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(310; "Qty. Disposition Plan Location"; Decimal)
        {
            // CalcFormula = Sum(Dispolines.Quantity WHERE ("POI Batch No."=FIELD("No."),
            //                                              "Target Type"=CONST(Location)));
            Caption = 'Quantity Location Disposition Planning Lines On File No.';
            Description = 'PVP, Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(311; "Dispolines with DispoWeek Loc"; Integer)
        {
            // CalcFormula = Count (Dispolines WHERE("POI Batch No." = FIELD("No."),
            //                                       "Disposition For Week" = FIELD("Disposition Week Filter"),
            //                                       Quantity = FILTER(<> 0),
            //                                       "Target Type" = CONST(Location)));
            Caption = 'Dispolines Location with Disposition for Week';
            Description = 'PVP, Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(320; "Qty. Disposition Plan MatAtLoc"; Decimal)
        {
            // CalcFormula = Sum (Dispolines.Quantity WHERE("POI Batch No." = FIELD("No."),
            //                                              "Target Type" = CONST("Maturation at Location")));
            Caption = 'Quantity Maturation At Location Disposition Planning Lines On File No.';
            Description = 'PVP, Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(321; "Dispolines with DispoWE MatLoc"; Integer)
        {
            // CalcFormula = Count (Dispolines WHERE("POI Batch No." = FIELD("No."),
            //                                       "Disposition For Week" = FIELD("Disposition Week Filter"),
            //                                       Quantity = FILTER(<> 0),
            //                                       "Target Type" = CONST("Maturation at Location")));
            Caption = 'Dispolines Maturation at Location with Disposition for Week';
            Description = 'PVP, Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(330; "Qty. DispositionPlan MatForLoc"; Decimal)
        {
            // CalcFormula = Sum (Dispolines.Quantity WHERE("POI Batch No." = FIELD("No."),
            //                                              "Target Type" = CONST("PreMaturation for Location")));
            Caption = 'Quantity Maturation For Location Disposition Planning Lines On File No.';
            Description = 'PVP, Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(331; "Dispolines with DispoWE MfoLoc"; Integer)
        {
            // CalcFormula = Count (Dispolines WHERE("POI Batch No." = FIELD("No."),
            //                                       "Disposition For Week" = FIELD("Disposition Week Filter"),
            //                                       Quantity = FILTER(<> 0),
            //                                       "Target Type" = CONST("PreMaturation for Location")));
            Caption = 'Dispolines Maturation for Location with Disposition for Week';
            Description = 'PVP, Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(340; "Qty. Disposition Plan MatforCu"; Decimal)
        {
            // CalcFormula = Sum (Dispolines.Quantity WHERE("POI Batch No." = FIELD("No."),
            //                                              "Target Type" = CONST("PreMaturation for Customer")));
            Caption = 'Quantity Maturation For Customer Disposition Planning Lines On File No.';
            Description = 'PVP, Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(341; "Dispolines with DispoWE MForCu"; Integer)
        {
            // CalcFormula = Count (Dispolines WHERE("POI Batch No." = FIELD("No."),
            //                                       "Disposition For Week" = FIELD("Disposition Week Filter"),
            //                                       Quantity = FILTER(<> 0),
            //                                       "Target Type" = CONST("PreMaturation for Customer")));
            Caption = 'Dispolines Maturation For Customer with Disposition for Week';
            Description = 'PVP, Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(500; "Purch. Rec. (Qty) (Base)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE("POI Batch No." = FIELD("No."),
                                                                  "Entry Type" = CONST(Purchase)));
            Caption = 'Purch. Rec. (Qty) (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(501; "Purch. Order (Qty) (Base)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Purchase Line"."Outstanding Qty. (Base)" WHERE("POI Batch No." = FIELD("No."),
                                                                               Type = CONST(Item),
                                                                               "Document Type" = CONST(Order)));
            Caption = 'Purch. Order (Qty) (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(502; "Purch. Inv. (Qty) (Base)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Item Ledger Entry"."Invoiced Quantity" WHERE("Entry Type" = CONST(Purchase),
                                                                             "POI Batch No." = FIELD("No.")));
            Caption = 'Purch. Inv. (Qty) (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(520; "Cost Calc. Amount (LCY)"; Decimal)
        {
            BlankNumbers = BlankZero;
            // CalcFormula = Sum ("Cost Calc. - Enter Data"."Amount (LCY)" WHERE("Entry Type" = CONST("Detail Batch"),
            //                                                                   "POI Batch No." = FIELD("No."),
            //                                                                   "Reduce Cost from Turnover" = CONST(No)));
            Caption = 'Cost Calc. Amount (LCY)';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(521; "Cost Calc. Amount f. Turnover"; Decimal)
        {
            BlankNumbers = BlankZero;
            // CalcFormula = Sum ("Cost Calc. - Enter Data"."Amount (LCY)" WHERE("Entry Type" = CONST("Detail Batch"),
            //                                                                   "POI Batch No." = FIELD("No."),
            //                                                                   "Reduce Cost from Turnover" = CONST(Yes)));
            Caption = 'Cost Calc. Amount f. Turnover';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(525; ddddd; Decimal)
        {
            // CalcFormula = Sum ("Cost Calc. - Alloc. Data"."Amount (LCY)" WHERE("POI Batch No." = FIELD("No."),
            //                                                                    "Cost Allocation" = CONST("Indirect Purchase Cost")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(530; "Posted Cost Amount"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("G/L Entry".Amount WHERE("Global Dimension 1 Code" = FIELD("No."),
                                                        "POI Batch Cost Account" = CONST(Cost)));
            Caption = 'Posted Cost Amount';
            Description = 'Flowfield Unsinn';
            Editable = false;
            FieldClass = FlowField;
        }
        field(531; "Posted Amount Cost f. Turnover"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("G/L Entry".Amount WHERE("Global Dimension 1 Code" = FIELD("No."),
                                                        "POI Batch Cost Account" = CONST("Turnover deducted Cost")));
            Caption = 'Posted Amount Cost f. Turnover';
            Description = 'Flowfield Unsinn';
            Editable = false;
            FieldClass = FlowField;
        }
        field(535; "P.O. Amount (LCY)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Purchase Line"."POI Line Amount (MW)" WHERE("POI Batch No." = FIELD("No."),
                                                                        Type = CONST(Item),
                                                                        "Document Type" = CONST(Order)));
            Caption = 'P.O. Amount (LCY)';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(536; "P.O. Line Discount Amt. (LCY)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Purchase Line"."POI Line Discount Amount (MW)" WHERE("POI Batch No." = FIELD("No."),
                                                                                 Type = CONST(Item),
                                                                                 "Document Type" = CONST(Order)));
            Caption = 'P.O. Line Discount Amt. (LCY)';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(540; "Pur. Amount (Actual)"; Decimal)
        {
            AutoFormatType = 1;
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Value Entry"."Purchase Amount (Actual)" WHERE("Item Ledger Entry Type" = CONST(Purchase),
                                                                              "POI Batch No." = FIELD("No.")));
            Caption = 'Pur. Amount (Actual)';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(541; "Pur. Amount (Expected)"; Decimal)
        {
            AutoFormatType = 1;
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Value Entry"."Purchase Amount (Expected)" WHERE("Item Ledger Entry Type" = CONST(Purchase),
                                                                                "POI Batch No." = FIELD("No.")));
            Caption = 'Pur. Amount (Expected)';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(542; "Inventory Amount (Expected)"; Decimal)
        {
            BlankNumbers = BlankZero;
            FieldClass = FlowField;
            CalcFormula = Sum ("Value Entry"."Cost Amount (Actual)" WHERE("Item Ledger Entry Type" = CONST("Positive Adjmt."),
                                                                          "POI Batch No." = FIELD("No.")));
            Description = 'Flowfield';
            Editable = false;

        }
        field(560; "Pur. Inv. Disc. (Act)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Value Entry"."POI Inv. Disc. (Act)" WHERE("Item Ledger Entry Type" = CONST(Purchase),
                                                                      "POI Batch No." = FIELD("No.")));
            Caption = 'Pur. Inv. Disc. (Act)';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(561; "Pur. Rg.Rab. ohne Wbz."; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Value Entry"."POI Inv.Disc.not Relat.toGoods" WHERE("POI Batch No." = FIELD("No."),
                                                                                    "Item Ledger Entry Type" = CONST(Purchase)));
            Caption = 'Pur. Rg.Rab. ohne Wbz. (Act)';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(562; "Pur. Accruel Inv. Disc. (Ext)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Value Entry"."POI AccruelInv.Disc.(External)" WHERE("POI Batch No." = FIELD("No."),
                                                                                   "Item Ledger Entry Type" = CONST(Purchase)));
            Caption = 'Pur. Accruel Inv. Disc. (Ext)';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(563; "Pur. Accruel Inv. Disc. (Int)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Value Entry"."POI AccruelInv.Disc.(Internal)" WHERE("POI Batch No." = FIELD("No."),
                                                                                   "Item Ledger Entry Type" = CONST(Purchase)));
            Caption = 'Pur. Accruel Inv. Disc. (Int)';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(564; "Pur. Green Point Costs"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Value Entry"."POI Green Point Costs" WHERE("POI Batch No." = FIELD("No."),
                                                                       "Item Ledger Entry Type" = CONST(Purchase)));
            Caption = 'Pur. Green Point Costs';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(565; "Pur. Freight Costs"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Value Entry"."POI Freight Costs" WHERE("POI Batch No." = FIELD("No."),
                                                                   "Item Ledger Entry Type" = CONST(Purchase)));
            Caption = 'Pur. Freight Costs';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(600; "Purch. Doc. Subtype Code"; Code[10])
        {
            Caption = 'Purch. Doc. Subtype Code';
            DataClassification = CustomerContent;
        }
        field(650; "Dimension Blocked"; Boolean)
        {
            CalcFormula = Lookup ("Dimension Value".Blocked WHERE(Code = FIELD("No.")));
            Caption = 'Dimension Blocked';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2; "Departure Location Code"; Code[20])
        {
            Caption = 'Abgangslager';
            DataClassification = CustomerContent;
        }
        field(3; Zusatzmerkmal; Code[20])
        {
            DataClassification = CustomerContent;
            //TableRelation = StandardplankostzusatzMM.Merkmal;
        }
        field(4; EAN; Code[13])
        {
            Caption = 'EAN';
            DataClassification = CustomerContent;
        }
        field(17; "PLU-Code"; Code[5])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Customer Group Code"; Code[10])
        {
            Caption = 'Kundengruppe';
            DataClassification = CustomerContent;
            //TableRelation = "Customer Group".Code;
        }
        field(6; "POInv. Disc. not Relat. to G."; Decimal)
        {
            CalcFormula = Sum ("Purchase Line"."POI Inv.Disc.notRelat.toGoods" WHERE("POI Batch No." = FIELD("No."),
                                                                                      Type = CONST(Item),
                                                                                      "Document Type" = CONST(Order)));
            Description = 'Flowfield';
            FieldClass = FlowField;
        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(21; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(9; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(22; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(27; "Average Customs Weight"; Decimal)
        {
            Caption = 'Average Customs Weight';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Master Batch No.")
        {
        }
        key(Key3; "Vendor No.", "Master Batch No.")
        {
        }
        key(Key4; "Disposition Week")
        {
        }
        key(Key5; Source)
        {
        }
        key(Key6; "Disposition Week", "Port of Discharge Code", "Means of Transport Type", "Means of Transp. Code (Arriva)", "Means of Transport Info", "Promised Receipt Date", "Promised Receipt Time")
        {
        }
        key(Key7; "Master Batch No.", "Country of Origin Code", "Item No.")
        {
        }
        key(Key8; "Item No.", "Unit of Measure Code", "Country of Origin Code")
        {
        }
        key(Key9; "Voyage No.", "Master Batch No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lrc_BatchSourceInfo: Record "POI Batch Info Details";
    begin
        lrc_BatchSourceInfo.RESET();
        lrc_BatchSourceInfo.SETRANGE("Batch Source Type", lrc_BatchSourceInfo."Batch Source Type"::"Batch No.");
        lrc_BatchSourceInfo.SETRANGE("Batch Source No.", "No.");
        IF NOT lrc_BatchSourceInfo.ISEMPTY() THEN
            lrc_BatchSourceInfo.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    var
        BatchSetup: Record "POI Master Batch Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DummyCode: Code[20];
    begin
        // Wenn die Partienummer nicht geladen ist, wird auf den Nummernkreis gemäß
        // Einrichtungstabelle zugegriffen
        DummyCode := '';
        IF "No." = '' THEN BEGIN
            BatchSetup.GET();
            BatchSetup.TESTFIELD("Purch. Batch No. Series");
            NoSeriesManagement.InitSeries(BatchSetup."Purch. Batch No. Series", DummyCode, 0D, "No.", DummyCode);
        END;
    end;

    var
        lrc_Dispolines: Record "POI Dispolines";
}

