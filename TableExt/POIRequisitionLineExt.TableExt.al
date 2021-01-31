tableextension 50044 "POI Requisition Line Ext" extends "Requisition Line"
{
    fields
    {
        field(5110300; "POI Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "POI Shortcut Dimension 3 Code");
            end;
        }
        field(5110301; "POI Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "POI Shortcut Dimension 4 Code");
            end;
        }
        field(5110309; "POI Batch Item"; Boolean)
        {
            Caption = 'Batch Item';
        }
        field(5110310; "POI Search Description"; Code[60])
        {
            Caption = 'Search Description';
        }
        field(5110330; "POI Item Main Category Code"; Code[10])
        {
            Caption = 'Item Main Category Code';
            TableRelation = "POI Item Main Category";
        }
        field(5110381; "POI Packing Unit of Meas (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            TableRelation = "Item Unit of Measure".Code;
        }
        field(5110382; "POI Qty. (PU) per Unit of Meas"; Decimal)
        {
            Caption = 'Qty. (PU) per Unit of Measure';
        }
        field(5110390; "POI Price Base (Purch. Price)"; Code[10])
        {
            Caption = 'Price Base (Purch. Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Purch. Price"),
                                                     Blocked = CONST(false));

            trigger OnValidate()
            begin
                VALIDATE("POI Purch. Price (Price Base)");
            end;
        }
        field(5110391; "POI Purch. Price (Price Base)"; Decimal)
        {
            Caption = 'Purch. Price (Price Base)';

            trigger OnValidate()
            var
            //lrc_PriceCalculation: Record "POI Price Base";
            begin
                IF CurrFieldNo = FIELDNO("POI Purch. Price (Price Base)") THEN
                    "POI Manual Price" := TRUE;

                // IF "POI Price Base (Purch. Price)" <> '' THEN 
                // BEGIN
                //     lrc_PriceCalculation.RESET();
                //     lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.", lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
                //     lrc_PriceCalculation.SETRANGE(Code, "POI Price Base (Purch. Price)");
                //     lrc_PriceCalculation.FINDFIRST();
                //     VALIDATE("Direct Unit Cost", gcu_Purchase.RequisitionCalcUnitPrice(Rec, FALSE));
                // END;


                CalcMarketUnitPrice();

            end;
        }
        field(5110393; "POI Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
        }
        field(5110408; "POI Mark Unit Cost(Basis)(LCY)"; Decimal)
        {
            Caption = 'Market Unit Cost (Basis) (LCY)';
            Description = 'MEK';

            trigger OnValidate()
            begin
                // FV START --> Umrechnen in die Basiseinheit über die Einkaufseinheit
                "POI Mark Unit Cost(Basis)(LCY)" := gcu_Purchase.RequisitionCalcUnitPrice(Rec, TRUE);
                IF "Qty. per Unit of Measure" <> 0 THEN
                    "POI Mark Unit Cost(Basis)(LCY)" := "POI Mark Unit Cost(Basis)(LCY)" / "Qty. per Unit of Measure"
                ELSE
                    "POI Mark Unit Cost(Basis)(LCY)" := 0;
            end;
        }
        field(5110409; "POI Mark Unit Cost(Price Base)"; Decimal)
        {
            Caption = 'Market Unit Cost (Price Base)';
            Description = 'MEK';

            trigger OnValidate()
            begin
                VALIDATE("POI Mark Unit Cost(Basis)(LCY)");
            end;
        }
        field(5110420; "POI Price Type"; Option)
        {
            Caption = 'Price Type';
            OptionCaption = ' ,Einführungspreis,Herstelleraktionspreis,Messepreis,Echt BIO Aktion,Power Flyer,Dauertiefpreis,Abverkauf';
            OptionMembers = " ","Einführungspreis",Herstelleraktionspreis,Messepreis,"Echt BIO Aktion","Power Flyer",Dauertiefpreis,Abverkauf;
        }
        field(5110421; "POI Purch. Price Starting Date"; Date)
        {
        }
        field(5110422; "POI Purch. Price Ending Date"; Date)
        {
        }
        field(5110425; "POI Sales Price Starting Date"; Date)
        {
        }
        field(5110426; "POI Sales Price Ending Date"; Date)
        {
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
        field(5110442; "POI Trademark Code"; Code[10])
        {
            Caption = 'Trademark Code';
            Description = 'EIA';
            TableRelation = "POI Trademark";
        }
        field(5110443; "POI Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            Description = 'EIA';
            TableRelation = "POI Caliber".Code;
            ValidateTableRelation = false;
        }
        field(5110444; "POI Item Attribute 1"; Code[10])
        {
            CaptionClass = '5110310,1,1';
            Caption = 'Item Attribute 1';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 1".Code;
        }
        field(5110445; "POI Item Attribute 3"; Code[10])
        {
            CaptionClass = '5110310,1,3';
            Caption = 'Quality Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 3".Code;
        }
        field(5110446; "POI Item Attribute 2"; Code[10])
        {
            CaptionClass = '5110310,1,2';
            Caption = 'Color Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 2";
        }
        field(5110447; "POI Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of goods Code';
            Description = 'EIA';
            TableRelation = "POI Grade of Goods";
        }
        field(5110448; "POI Item Attribute 7"; Code[10])
        {
            CaptionClass = '5110310,1,7';
            Caption = 'Conservation Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 7";
        }
        field(5110449; "POI Item Attribute 4"; Code[10])
        {
            CaptionClass = '5110310,1,4';
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
        field(5110451; "POI Item Attribute 5"; Code[10])
        {
            CaptionClass = '5110310,1,5';
            Caption = 'Treatment Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 5";
        }
        field(5110452; "POI Item Attribute 6"; Code[20])
        {
            CaptionClass = '5110310,1,6';
            Caption = 'Proper Name Code';
            Description = 'EIA';
            TableRelation = "POI Proper Name";
            ValidateTableRelation = false;
        }
        field(5110453; "POI Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            Description = 'EIA';
            OptionCaption = ' ,Transmission,Organic';
            OptionMembers = " ",Transmission,Organic;
        }
        field(5110454; "POI Item Attribute 8"; Code[10])
        {
            CaptionClass = '5110310,1,8';
            Caption = 'Item Attribute 8';
            Description = 'EIA';
            //TableRelation = "POI Item Attribute 8";
            //ValidateTableRelation = false;
        }
        field(5110460; "POI Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
        }
        field(5110461; "POI Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
        }
        field(5110462; "POI Total Net Weight"; Decimal)
        {
            Caption = 'Total Net Weight';
        }
        field(5110463; "POI Total Gross Weight"; Decimal)
        {
            Caption = 'Total Gross Weight';
        }
        field(5110488; "POI Manual Price"; Boolean)
        {
            Caption = 'Manual Price';

            trigger OnValidate()
            begin
                IF "POI Manual Price" = FALSE THEN
                    GetDirectCost(FIELDNO("POI Manual Price"));
            end;
        }
        field(5110490; "POI Sales Unit of Measure"; Code[10])
        {
            Caption = 'Sales Unit of Measure';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));

            trigger OnValidate()
            var
                lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
            begin
                IF "POI Sales Unit of Measure" = '' THEN BEGIN
                    "POI Qty. Base per Sales Unit" := 0;
                    "POI Quantity (Sales Unit)" := 0;
                    EXIT;
                END;

                TESTFIELD(Type, Type::Item);
                TESTFIELD("No.");
                TESTFIELD("Unit of Measure Code");

                lrc_ItemUnitofMeasure.GET("No.", "POI Sales Unit of Measure");
                "POI Qty. Base per Sales Unit" := lrc_ItemUnitofMeasure."Qty. per Unit of Measure";
                "POI Quantity (Sales Unit)" := (Quantity * "Qty. per Unit of Measure") / "POI Qty. Base per Sales Unit";
            end;
        }
        field(5110491; "POI Qty. Base per Sales Unit"; Decimal)
        {
            Caption = 'Mge. Basis pro Verk.-Einh.';
        }
        field(5110494; "POI Quantity (Sales Unit)"; Decimal)
        {
            Caption = 'Quantity (Sales Unit)';

            trigger OnValidate()
            begin
                TESTFIELD("POI Sales Unit of Measure");

                Quantity := ("POI Quantity (Sales Unit)" * "POI Qty. Base per Sales Unit") / "Qty. per Unit of Measure";
                IF Quantity <> ROUND(Quantity, 1) THEN
                    ERROR('Menge in Verkaufseinheit kann nicht in Einkaufseinheit umgerechnet werden!');
                VALIDATE(Quantity);

                "POI Line Amount" := "Direct Unit Cost" * Quantity;
            end;
        }
        field(5110498; "POI Quantity (Vorschlag)"; Decimal)
        {
            Caption = 'Menge (Vorschlag)';
        }
        field(5110502; "POI Purchaser Code"; Code[10])
        {
            Caption = 'Purchaser Code';
            Description = 'DIS';
            TableRelation = "Salesperson/Purchaser";
        }
        field(5110511; "POI Planing Date from"; Date)
        {
            Caption = 'Planungsdatum von';
        }
        field(5110512; "POI Planing Date till"; Date)
        {
            Caption = 'Planungsdatum bis';
        }
        field(5110600; "POI Date Time Created"; DateTime)
        {
            Caption = 'Date Time Created';
            Editable = false;
        }
    }
    procedure CalcMarketUnitPrice()
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
    begin
        // --------------------------------------------------------------------------------------
        // Funktion zur Berechnung des Markteinkaufspreises
        // --------------------------------------------------------------------------------------

        lrc_FruitVisionSetup.GET();
        IF lrc_FruitVisionSetup."Market Unit Price activ" = TRUE THEN
            CASE lrc_FruitVisionSetup."Calc Market Unit Price" OF
                lrc_FruitVisionSetup."Calc Market Unit Price"::"Immer bei Preisänderung":
                    VALIDATE("POI Mark Unit Cost(Price Base)", "POI Purch. Price (Price Base)");
                lrc_FruitVisionSetup."Calc Market Unit Price"::"Nur wenn Markteinkaufspreis Null":
                    IF ("POI Mark Unit Cost(Price Base)" = 0) THEN
                        VALIDATE("POI Mark Unit Cost(Price Base)", "POI Purch. Price (Price Base)");
            END;
    end;

    var
        gcu_Purchase: Codeunit "POI Purch. Mgt";

}