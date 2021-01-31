tableextension 50045 "POI Purch. ReceiptLine Ext" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50000; "POI Product Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Group Code';
        }
        field(5110300; "POI Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'EDM';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(5110301; "POI Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'EDM';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(5110302; "POI Purch. Doc. Subtype Code"; Code[10])
        {
            Caption = 'Purch. Doc. Subtype Code';
            Description = 'EDM';
            TableRelation = "POI Purch. Doc. Subtype";
        }
        field(5110305; "POI Subtyp"; Option)
        {
            Caption = 'Subtyp';
            Description = ' ,Discount,Refund';
            OptionCaption = ' ,Discount,Refund Empties,Refund Transport,,,,Freight,Insurance';
            OptionMembers = " ",Discount,"Refund Empties","Refund Transport",,,,Freight,Insurance;
        }
        field(5110306; "POI Kind of Settlement"; Option)
        {
            Caption = 'Kind of Settlement';
            Description = 'Fixed Price,Commission,Account Sale + Commission';
            OptionCaption = 'Fix Price,Commission,Account Sale+Commission';
            OptionMembers = "Fixed Price",Commission,"Account Sale + Commission";
        }
        field(5110307; "POI Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            OptionCaption = ' ,Payed,Not Payed';
            OptionMembers = " ",Payed,"Not Payed";
        }
        field(5110308; "POI Location Group Code"; Code[10])
        {
            Caption = 'Location Group Code';
            TableRelation = "POI Location Group";
        }
        field(5110309; "POI Arrival Region Code"; Code[10])
        {
            Caption = 'Arrival Region Code';
        }
        field(5110310; "POI Producer No."; Code[20])
        {
            Caption = 'Producer No.';
            TableRelation = Vendor WHERE("POI Is Manufacturer" = CONST(true));
        }
        field(5110311; "POI Lot No. Producer"; Code[30])
        {
            Caption = 'Lot No. Producer';
        }
        field(5110312; "POI Order Address Code"; Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code WHERE("Vendor No." = FIELD("Buy-from Vendor No."));
        }
        field(5110313; "POI Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(5110315; "POI Green Point Duty"; Option)
        {
            Caption = 'Green Point Duty';
            Description = 'DSD';
            OptionCaption = ' ,Green Point Duty';
            OptionMembers = " ","Green Point Duty";
        }
        field(5110316; "POI Green Point Payment Thru"; Option)
        {
            Caption = 'Green Point Payment Thru';
            Description = 'DSD';
            OptionCaption = 'Us,Vendor';
            OptionMembers = Us,Vendor;
        }
        field(5110317; "POI Green Point Amount (LCY)"; Decimal)
        {
            Caption = 'Green Point Amount (LCY)';
            Description = 'DSD';
        }
        field(5110319; "POI Cost Category Code"; Code[20])
        {
            Caption = 'Cost Category Code';
            TableRelation = "POI Cost Category";
        }
        field(5110320; "POI Item Typ"; Option)
        {
            Caption = 'Item Typ';
            Description = 'Standard,Batch Item,Empties Item';
            OptionCaption = 'Trade Item,,Empties Item,Transport Item,,Packing Material';
            OptionMembers = "Trade Item",,"Empties Item","Transport Item",,"Packing Material";
        }
        field(5110321; "POI Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(5110322; "POI Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            NotBlank = true;
            TableRelation = "POI Batch";
        }
        field(5110323; "POI Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = "POI Batch Variant";
        }
        field(5110324; "POI Batch Var. Detail ID"; Integer)
        {
            Caption = 'Batch Var. Detail ID';
        }
        field(5110325; "POI Batch Variant generated"; Boolean)
        {
            Caption = 'Batch Variant generated';
            Editable = false;
        }
        field(5110326; "POI Batch Item"; Boolean)
        {
            Caption = 'Batch Item';
        }
        field(5110340; "POI Batch Var Code Item Charge"; Code[20])
        {
            Caption = 'Batch Variant Code Item Charge';
        }
        field(5110341; "POI Quantity Item Charge"; Decimal)
        {
            Caption = 'Quantity Item Charge';
        }
        field(5110354; "POI Fiscal Agent Code"; Code[10])
        {
            Caption = 'Fiscal Agent Code';
            NotBlank = true;
            TableRelation = "POI Fiscal Agent".Code;
        }
        field(5110358; "POI Sh-Ag Code to Transf. Loc"; Code[10])
        {
            Caption = 'Ship-Agent Code to Transf. Loc';
            TableRelation = "Shipping Agent";
        }
        field(5110359; "POI Entry via Trans Loc. Code"; Code[10])
        {
            Caption = 'Entry via Transfer Loc. Code';
            TableRelation = Location;
        }
        field(5110360; "POI Location's Reference No."; Code[20])
        {
            Caption = 'Location''s Reference No.';
        }
        field(5110363; "POI Voyage No."; Code[20])
        {
            Caption = 'Voyage No.';
        }
        field(5110364; "POI Container Code"; Code[20])
        {
            Caption = 'Container Code';
        }
        field(5110365; "POI Kind of Loading"; Option)
        {
            Caption = 'Kind of Loading';
            Description = ' ,Container,Reefer Vessel';
            OptionCaption = ' ,Container,Reefer Vessel';
            OptionMembers = " ",Container,"Reefer Vessel";
        }
        field(5110370; "POI Price Unit of Measure"; Code[10])
        {
            Caption = 'Price Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(5110375; "POI Reference Freight Costs"; Option)
        {
            Caption = 'Reference Freight Costs';
            OptionCaption = 'Collo,Pallet,Weight,Pallet Type';
            OptionMembers = Collo,Pallet,Weight,"Pallet Type";
        }
        field(5110376; "POI Freight Unit of Meas (FU)"; Code[10])
        {
            Caption = 'Freight Unit of Measure (FU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));
        }
        field(5110377; "POI Freight Cost per Ref. Unit"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Freigth Costs per Ref. Unit';
        }
        field(5110378; "POI Freight Costs Amount (LCY)"; Decimal)
        {
            Caption = 'Freight Costs Amount (LCY)';
        }
        field(5110380; "POI Base Unit of Measure (BU)"; Code[10])
        {
            Caption = 'Base Unit of Measure (BU)';
            Editable = false;
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
        }
        field(5110381; "POI Packing Unit of Meas (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Packing Unit of Measure" = CONST(true));
        }
        field(5110382; "POI Qty. (PU) per Unit of Meas"; Decimal)
        {
            Caption = 'Qty. (PU) per Unit of Measure';
        }
        field(5110383; "POI Quantity (PU)"; Decimal)
        {
            Caption = 'Quantity (PU)';
        }
        field(5110384; "POI Transport Unit of Meas(TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));
        }
        field(5110385; "POI Qty.(Unit) per Pallet(TU)"; Decimal)
        {
            Caption = 'Qty. (Unit) per Pallet (TU)';
        }
        field(5110386; "POI Quantity (TU)"; Decimal)
        {
            Caption = 'Quantity (TU)';
        }
        field(5110387; "POI Collo Unit of Measure (CU)"; Code[10])
        {
            Caption = 'Collo Unit of Measure (CU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Collo Unit of Measure" = CONST(true));
        }
        field(5110388; "POI Content Unit of Meas (COU)"; Code[10])
        {
            Caption = 'Content Unit of Measure (COU)';
            TableRelation = "Unit of Measure";
        }
        field(5110390; "POI Price Base (Purch. Price)"; Code[10])
        {
            Caption = 'Price Base (Purch. Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Purch. Price"),
                                                     Blocked = CONST(false));
        }
        field(5110391; "POI Purch. Price (Price Base)"; Decimal)
        {
            Caption = 'Purch. Price (Price Base)';
        }
        field(5110393; "POI Price Base (Sales Price)"; Code[10])
        {
            Caption = 'Price Base (Sales Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Sales Price"),
                                                     Blocked = CONST(false));
        }
        field(5110394; "POI Sal Price(Price Base)(LCY)"; Decimal)
        {
            Caption = 'Sales Price (Price Base) (LCY)';
        }
        field(5110396; Weight; Option)
        {
            Caption = 'Weight';
            OptionCaption = ' ,Netto,Brutto,,,,Anbruch Netto wiegen';
            OptionMembers = " ",Netto,Brutto,,,,"Anbruch Netto wiegen";
        }
        field(5110397; "POI Qty.(COU) p Pack. Unit(PU)"; Decimal)
        {
            Caption = 'Qty. (COU) per Pack. Unit (PU)';
        }
        field(5110400; "POI Inv.Disc.notRelat.to Goods"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Inv. Disc. not Relat. to Goods';
        }
        field(5110401; "POI Accru Inv.Disc.(External)"; Decimal)
        {
            Caption = 'Accruel Inv. Disc. (External)';
        }
        field(5110402; "POI Accru Inv.Disc.(Internal)"; Decimal)
        {
            Caption = 'Accruel Inv. Disc. (Internal)';
            Description = 'FV';
            Editable = false;
        }
        field(5110406; "POI Est. Cost per EE (LCY)"; Decimal)
        {
            Caption = 'Est. Cost per EE (LCY)';
        }
        field(5110407; "POI Amount Est. Cost (LCY)"; Decimal)
        {
            Caption = 'Amount Est. Cost (LCY)';
        }
        field(5110408; "POI Mark Unit Cost(Basis)(LCY)"; Decimal)
        {
            Caption = 'Market Unit Cost (Basis) (LCY)';
            Description = 'MEK';
        }
        field(5110409; "POI Mark Unit Cost(Price Base)"; Decimal)
        {
            Caption = 'Market Unit Cost (Price Base)';
            Description = 'MEK';
        }
        field(5110410; "POI Empties Item No."; Code[20])
        {
            Caption = 'Empties Item No.';
            Description = 'LVW';
            TableRelation = IF (Type = CONST(Item)) Item WHERE("POI Item Typ" = CONST("Empties Item"));
        }
        field(5110411; "POI Empties Quantity"; Decimal)
        {
            Caption = 'Empties Quantity';
            Description = 'LVW';
        }
        field(5110413; "POI Empties Refund Amount"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Empties Refund Amount';
            Description = 'LVW';
        }
        field(5110414; "POI Empties Attached Line No"; Integer)
        {
            Caption = 'Empties Attached Line No';
            Description = 'LVW';
        }
        field(5110430; "POI Total Net Weight"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Total Net Weight';
            DecimalPlaces = 0 : 3;
        }
        field(5110431; "POI Total Gross Weight"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Total Gross Weight';
            DecimalPlaces = 0 : 3;
        }
        field(5110435; "POI Info 1"; Code[30])
        {
            CaptionClass = '5110300,1,1';
            Caption = 'Info 1';
            Description = 'BSI';
        }
        field(5110436; "POI Info 2"; Code[50])
        {
            CaptionClass = '5110300,1,2';
            Caption = 'Info 2';
            Description = 'BSI';
        }
        field(5110437; "POI Info 3"; Code[20])
        {
            CaptionClass = '5110300,1,3';
            Caption = 'Info 3';
            Description = 'BSI';
        }
        field(5110438; "POI Info 4"; Code[20])
        {
            CaptionClass = '5110300,1,4';
            Caption = 'Info 4';
            Description = 'BSI';
        }
        field(5110440; "POI Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            Description = 'EIA';
            TableRelation = "Country/Region".Code;
        }
        field(5110441; "POI Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            Description = 'EIA';
            TableRelation = "POI Variety".Code;
        }
        field(5110442; "POI Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            Description = 'EIA';
            TableRelation = "POI Trademark" WHERE("Filter Vendor No." = FIELD("Buy-from Vendor No."),
                                             "Trademark from Vendor" = CONST(true));
            ValidateTableRelation = false;
        }
        field(5110443; "POI Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            Description = 'EIA';
            TableRelation = "POI Caliber".Code;
        }
        field(5110444; "POI Vendor Caliber Code"; Code[10])
        {
            Caption = 'Vendor Caliber Code';
            Description = 'EIA';
            TableRelation = IF ("POI Product Group Code" = FILTER(<> ''),
                                "POI Variety Code" = FILTER(<> '')) "POI Caliber - Vendor Caliber"."Vend. Caliber Code" WHERE("Vendor No." = FIELD("Buy-from Vendor No."),
                                                                                                                  "Variety Code" = FIELD("POI Variety Code"),
                                                                                                                  "Product Group Code" = FIELD("POI Product Group Code"))
            ELSE
            "POI Caliber - Vendor Caliber"."Vend. Caliber Code" WHERE("Vendor No." = FIELD("Buy-from Vendor No."),
                                                                                                                                                                              "Variety Code" = FIELD("POI Variety Code"),
                                                                                                                                                                              "Product Group Code" = FIELD("POI Product Group Code"));
            ValidateTableRelation = false;
        }
        field(5110445; "POI Quality Code"; Code[10])
        {
            Caption = 'Quality Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 3".Code;
        }
        field(5110446; "POI Color Code"; Code[10])
        {
            Caption = 'Color Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 2";
        }
        field(5110447; "POI Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            Description = 'EIA';
            TableRelation = "POI Grade of Goods";
        }
        field(5110448; "POI Conservation Code"; Code[10])
        {
            Caption = 'Conservation Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 7";
        }
        field(5110449; "POI Packing Code"; Code[10])
        {
            Caption = 'Packing Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 4";
        }
        field(5110450; "POI Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            Description = 'EIA';
            TableRelation = "POI Coding";
        }
        field(5110451; "POI Treatment Code"; Code[10])
        {
            Caption = 'Treatment Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 5";
        }
        field(5110452; "POI Proper Name Code"; Code[20])
        {
            Caption = 'Proper Name Code';
            Description = 'EIA';
            TableRelation = "POI Proper Name";
        }
        field(5110453; "POI Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            Description = 'EIA';
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;
        }
        field(5110454; "POI Cultivation Associat. Code"; Code[10])
        {
            Caption = 'Cultivation Association Code';
            Description = 'EIA';
            TableRelation = "POI Cultivation Association";
        }
        field(5110455; "POI Cultivation Process Code"; Code[10])
        {
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 1";
        }
        field(5110460; "POI Date of Expiry"; Date)
        {
            Caption = 'Date of Expiry';
        }
        field(5110464; "POI Item Charge Assignment"; Option)
        {
            Caption = 'Item Charge Assignment';
            Description = ' ,Eins zu Eins';
            OptionCaption = ' ,One to One';
            OptionMembers = " ","Eins zu Eins";
        }
        field(5110465; "POI Cr. Memo Ship. No."; Code[20])
        {
            Caption = 'Cr. Memo Ship. No.';
        }
        field(5110466; "POI Cr. Memo Ship. Line"; Integer)
        {
            Caption = 'Cr. Memo Ship. Line';
        }
        field(5110467; "POI Cr. Memo Item No."; Code[20])
        {
            Caption = 'Cr. Memo Item No.';
            TableRelation = Item;
        }
        field(5110469; "POI In Goods Receiving"; Boolean)
        {
            CalcFormula = Exist ("POI Warehouse Receive Line" WHERE(Source = CONST(Purchase),
                                                                "Source No." = FIELD("Document No."),
                                                                "Source Line No." = FIELD("Line No.")));
            Caption = 'In Goods Receiving';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110470; "POI Purch. Disc. Entry No."; Integer)
        {
            Caption = 'Purch. Disc. Entry No.';
            Description = 'RAB';
            Editable = false;
        }
        // field(5110478;"Port of Loading Code";Code[10])
        // {
        //     Caption = 'Port of Loading Code';
        //     TableRelation = "POI Harbour";
        // }
        field(5110479; "POI Departure Date"; Date)
        {
            Caption = 'Departure Date';

            trigger OnLookup()
            var
                lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
            begin
                IF lcu_GlobalFunctions.SelectDateByCalendar("POI Date of Discharge") THEN
                    VALIDATE("POI Date of Discharge");
            end;
        }
        field(5110480; "POI Port of Disch. Code (UDE)"; Code[10])
        {
            Caption = 'Port of Discharge Code (UDE)';
            TableRelation = "Entry/Exit Point";
        }
        field(5110481; "POI Date of Discharge"; Date)
        {
            Caption = 'Date of Discharge';
        }
        field(5110482; "POI Time of Discharge"; Time)
        {
            Caption = 'Time of Discharge';
        }
        field(5110483; "POI No. of Weightings"; Integer)
        {
            Caption = 'No. of Weightings';
        }
        field(5110503; "POI Blanket Order Valid from"; Date)
        {
            Caption = 'Blanket Order Valid from';
            Description = 'DIS';
        }
        field(5110504; "POI Blanket Order Valid till"; Date)
        {
            Caption = 'Blanket Order Valid till';
            Description = 'DIS';
        }
        field(5110505; "POI Validation active"; Boolean)
        {
            Caption = 'Validation active';
            Description = 'DIS';
            InitValue = false;
        }
        field(5110600; "POI Average Customs Weight"; Decimal)
        {
            Caption = 'Average Customs Weight';
            DecimalPlaces = 0 : 5;
        }
        field(5110604; "POI Original Quantity"; Decimal)
        {
            Caption = 'Original Quantity';
            Description = 'PVP';
        }
        field(5110605; "POI Member State Companionship"; Option)
        {
            Caption = 'Member State Companionship';
            OptionCaption = ' ,Ohne,,,Mitglied,Nicht Mitglied,,,Sonstiges';
            OptionMembers = " ",Ohne,,,Mitglied,"Nicht Mitglied",,,Sonstiges;
        }
        field(5110606; "POI Empties Posting Item No."; Code[20])
        {
            Caption = 'Empties Posting Item No.';
            Description = 'ERZ';
            TableRelation = Item;
        }
        field(5110607; DummyField; Date)
        {
            Caption = 'DummyField';
        }
        field(5110608; "POI Sales Reference No."; Code[20])
        {
            Caption = 'Sales Reference No.';
        }
        field(5110700; "POI B/L Shipper"; Code[20])
        {
            Caption = 'B/L Shipper';
            TableRelation = Vendor."No.";
        }
    }

}