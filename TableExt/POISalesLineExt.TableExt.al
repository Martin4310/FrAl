tableextension 50033 "POI Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50000; "POI Batch No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Batch No.';
            TableRelation = "POI Batch" where("Master Batch No." = field("POI Master Batch No."));
        }
        field(50001; "POI Master Batch No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Master batch No.';
            TableRelation = "POI Master Batch";
        }
        field(50002; "POI Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            DataClassification = CustomerContent;
            TableRelation = "POI Batch Variant"."No." where("Master Batch No." = field("POI Master Batch No."));
        }
        field(50003; "POI Info 1"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Info1';
        }
        field(50004; "POI Info 2"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Info 2';
        }
        field(50005; "POI Info 3"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Info 3';
        }
        field(50006; "POI Info 4"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Info 4';
        }
        field(50007; "POI Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
        }
        field(50008; "POI Empties Blanket Order No."; Code[20])
        {
            Caption = 'Leergut Rahmenauftragsnummer';
        }
        field(50009; "POI Empties Blank Ord Line No."; Integer)
        {
            Caption = 'Leergut Rahmenauftragszeilennr.';
        }
        field(50010; "POI Empties Order No. Refer"; Code[20])
        {
            Caption = 'Leergut Auftragsreferenz';
        }
        field(50011; "POI Empt Order Ref. Line No."; Integer)
        {
            Caption = 'Leergut Auftragszeilenreferenz';
        }
        field(50012; "POI Empt Blanket Ord Line No."; Integer)
        {
            Caption = 'Leergut Rahmenauftragszeilennr.';
        }
        field(5110300; "POI Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'EDM';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "POI Shortcut Dimension 3 Code");
                //161123 rs Übernahme Shortcut Dim 3 in Batch No.
                IF Type = Type::"G/L Account" THEN
                    VALIDATE("POI Batch No.", "POI Shortcut Dimension 3 Code");
            end;
        }
        field(5110301; "POI Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'EDM';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "POI Shortcut Dimension 4 Code");
            end;
        }
        field(5110305; "POI Subtyp"; Option)
        {
            Caption = 'Subtyp';
            OptionCaption = ' ,Discount,Refund Empties,Refund Transport,,,,Freight,Insurance';
            OptionMembers = " ",Discount,"Refund Empties","Refund Transport",,,,Freight,Insurance;
        }
        field(5110308; "POI Location Group Code"; Code[10])
        {
            Caption = 'Location Group Code';
            TableRelation = "POI Location Group";
        }
        field(5110309; "POI Departure Region Code"; Code[20])
        {
            Caption = 'Departure Region Code';
            TableRelation = "POI Departure Region" where(RegionType = const(Departure));
        }
        field(5110310; "POI Sales Doc. Subtype Code"; Code[10])
        {
            Caption = 'Sales Doc. Subtype Code';
            TableRelation = "POI Sales Doc. Subtype".Code WHERE("Document Type" = FIELD("Document Type"));
        }
        field(5110312; "POI Customer Order No."; Code[20])
        {
            Caption = 'Customer Order No.';
        }
        field(5110320; "POI Item Typ"; Option)
        {
            Caption = 'Item Typ';
            OptionCaption = 'Trade Item,,Empties Item,Transport Item,,Packing Material,,,Spare Parts,,,Freight Item,Dummy Item';
            OptionMembers = "Trade Item",,"Empties Item","Transport Item",,"Packing Material",,,"Spare Parts",,,"Freight Item","Dummy Item";
        }
        field(5110326; "POI Batch Item"; Boolean)
        {
            Caption = 'Batch Item';
        }
        field(5110370; "POI Price Unit of Measure"; Code[10])
        {
            Caption = 'Price Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(5110375; "POI Reference Freight Costs"; Option)
        {
            Caption = 'Reference Freight Costs';
            Description = 'Collo,Pallet,Weight,Pallet Type';
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

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("POI Freight Cost per Ref. Unit") THEN BEGIN
                    GetSalesHeader();
                    IF SalesHeader."POI Freight Calculation" <> SalesHeader."POI Freight Calculation"::"Manual in Line" THEN
                        // Manuelle Eingabe nicht zulässig!
                        ERROR(AGILES_TEXT002Txt);
                    "POI Freight Costs Amount (LCY)" := "POI Freight Cost per Ref. Unit" * "POI Quantity (TU)";
                END;
            end;
        }
        field(5110378; "POI Freight Costs Amount (LCY)"; Decimal)
        {
            Caption = 'Freight Costs Amount (LCY)';

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("POI Freight Costs Amount (LCY)") THEN BEGIN
                    GetSalesHeader();
                    IF SalesHeader."POI Freight Calculation" <> SalesHeader."POI Freight Calculation"::"Manual in Line" THEN
                        // Manuelle Eingabe nicht zulässig!
                        ERROR(AGILES_TEXT002Txt);
                END;
            end;
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
            Description = 'DSD';
            TableRelation = "Unit of Measure" WHERE("POI Is Packing Unit of Measure" = CONST(true));
        }
        field(5110382; "POI Qty. (PU) per Unit of Meas"; Decimal)
        {
            Caption = 'Qty. (PU) per Unit of Measure';

            trigger OnValidate()
            begin
                ADF_CalcQuantity(FIELDNO("POI Qty. (PU) per Unit of Meas"));
            end;
        }
        field(5110383; "POI Quantity (PU)"; Decimal)
        {
            Caption = 'Quantity (PU)';

            trigger OnValidate()
            begin
                ADF_CalcQuantity(FIELDNO("POI Quantity (PU)"));
                VALIDATE("Line Discount %");
            end;
        }
        field(5110384; "POI Transp. Unit of Meas (TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));

            trigger OnValidate()
            var

                lrc_UnitofMeasure: Record "Unit of Measure";
                lrc_ItemTransportUnitFactor: Record "POI Factor Transport Unit";
                lcu_UnitMgt: Codeunit "POI Unit Mgt";
                ldc_PalletFaktor: Decimal;
            begin
                IF "POI Transp. Unit of Meas (TU)" <> '' THEN BEGIN

                    IF ("POI Transp. Unit of Meas (TU)" <> '') AND
                       ("POI Transp. Unit of Meas (TU)" <> xRec."POI Transp. Unit of Meas (TU)") AND
                       (CurrFieldNo <> 0) THEN BEGIN

                        lcu_UnitMgt.GetItemVendorUnitPalletFactor("No.",
                                                                  lrc_ItemTransportUnitFactor."Reference Typ"::Customer,
                                                                  "Sell-to Customer No.",
                                                                  "Unit of Measure Code",
                                                                  "Qty. per Unit of Measure",
                                                                  "POI Empties Item No.",
                                                                  "POI Transp. Unit of Meas (TU)",
                                                                  ldc_PalletFaktor);

                        IF ldc_PalletFaktor = 0 THEN BEGIN
                            // Bestehenden Faktor umrechnen
                            lrc_PalletFactorbyPercentage.SETRANGE("From Transport Unit", xRec."POI Transp. Unit of Meas (TU)");
                            lrc_PalletFactorbyPercentage.SETRANGE("Into Transport Unit", "POI Transp. Unit of Meas (TU)");
                            IF lrc_PalletFactorbyPercentage.FINDFIRST() THEN
                                ldc_PalletFaktor := (ROUND(("POI Qty.(Unit) per Transp.(TU)" * (lrc_PalletFactorbyPercentage.Percentage / 100)), 1, '>'));
                        END;

                        IF ldc_PalletFaktor <> 0 THEN BEGIN
                            "POI Qty.(Unit) per Transp.(TU)" := ldc_PalletFaktor;
                            // Menge Paletten berechnen
                            IF "POI Qty.(Unit) per Transp.(TU)" <> 0 THEN
                                "POI Quantity (TU)" := Quantity / "POI Qty.(Unit) per Transp.(TU)"
                            ELSe
                                "POI Quantity (TU)" := 0;
                        END;
                    END;

                    lrc_UnitofMeasure.GET("POI Transp. Unit of Meas (TU)");
                    "POI Freight Unit of Meas (FU)" := lrc_UnitofMeasure."POI Freight Unit of Meas (FU)";

                END ELSE BEGIN
                    "POI Freight Unit of Meas (FU)" := '';
                    "POI Qty.(Unit) per Transp.(TU)" := 0;
                    "POI Quantity (TU)" := 0;
                END;
            end;
        }
        field(5110385; "POI Qty.(Unit) per Transp.(TU)"; Decimal)
        {
            Caption = 'Qty. (Unit) per Transp.(TU)';

            trigger OnValidate()
            begin
                ADF_CalcQuantity(FIELDNO("POI Qty.(Unit) per Transp.(TU)"));
            end;
        }
        field(5110386; "POI Quantity (TU)"; Decimal)
        {
            Caption = 'Quantity (TU)';

            trigger OnValidate()
            begin
                ADF_CalcQuantity(FIELDNO("POI Quantity (TU)"));
            end;
        }
        field(5110387; "POI Collo Unit of Measure (PQ)"; Code[10])
        {
            Caption = 'Collo Unit of Measure (PQ)';
            TableRelation = "Unit of Measure" WHERE("POI Is Collo Unit of Measure" = CONST(true));
        }
        field(5110388; "POI Content Unit of Meas (COU)"; Code[10])
        {
            Caption = 'Content Unit of Measure (COU)';
            TableRelation = "Unit of Measure";
        }
        field(5110389; "POI Partial Quantity (PQ)"; Boolean)
        {
            Caption = 'Partial Quantity (PQ)';

            trigger OnValidate()
            begin
                TESTFIELD("Quantity Shipped", 0);
                IF "POI Partial Quantity (PQ)" = xRec."POI Partial Quantity (PQ)" THEN
                    EXIT;
                ADF_ChangeUnitPartitialQty();
            end;
        }
        field(5110390; "POI Price Base (Sales Price)"; Code[10])
        {
            Caption = 'Price Base (Sales Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Sales Price"),
                                                     Blocked = CONST(false));

            trigger OnValidate()
            var
                lrc_PriceCalculation: Record "POI Price Base";
                lcu_SalesClaimMgt: Codeunit "POI Sales Claim Mgt";
            begin
                IF lrc_PriceCalculation.GET(lrc_PriceCalculation."Purch./Sales Price Calc."::"Sales Price",
                                            "POI Price Base (Sales Price)") THEN
                    IF (lrc_PriceCalculation.Weight <> lrc_PriceCalculation.Weight::" ") AND
                       ("POI Weight" <> lrc_PriceCalculation.Weight) THEN
                        VALIDATE("POI Weight", lrc_PriceCalculation.Weight);

                VALIDATE("Sales Price (Price Base)");

                IF "Document Type" = "Document Type"::"Credit Memo" THEN
                    IF "POI Price Base (Sales Price)" <> xRec."POI Price Base (Sales Price)" THEN
                        lcu_SalesClaimMgt.AktualSalesClaimLineFromCrMemo(Rec);

            end;
        }
        field(5110391; "Sales Price (Price Base)"; Decimal)
        {
            Caption = 'Sales Price (Price Base)';

            trigger OnValidate()
            var
                lcu_SalesClaimMgt: Codeunit "POI Sales Claim Mgt";
            begin
                "POI Price Unit of Measure" := gcu_SalesMgt.SalesLineGetPriceUnit(Rec);
                VALIDATE("Unit Price", gcu_SalesMgt.SalesLineCalcUnitPrice(Rec));

                IF "Document Type" = "Document Type"::"Credit Memo" THEN
                    IF "Sales Price (Price Base)" <> xRec."Sales Price (Price Base)" THEN
                        lcu_SalesClaimMgt.AktualSalesClaimLineFromCrMemo(Rec);


                //RS Prüfung ob bei Europool Artikeln der Preis abweichend sein soll
                IF ((CurrFieldNo = FIELDNO("Sales Price (Price Base)")) AND (Type = Type::Item)) THEN
                    IF "POI Product Group Code" = '70002' THEN
                        IF "Sales Price (Price Base)" <> (3.86) THEN
                            IF GUIALLOWED() THEN
                                IF NOT CONFIRM('Der Preis für den EPS-Artikel weicht vom Standardpreis 3,86 ab. Wollen Sie wirklich übernehmen?', FALSE) THEN
                                    "Sales Price (Price Base)" := xRec."Sales Price (Price Base)";
            end;
        }
        field(5110394; "POI Weight"; Option)
        {
            Caption = 'Weight';
            OptionCaption = ' ,Net Weight,Gross Weight';
            OptionMembers = " ","Net Weight","Gross Weight";

            trigger OnValidate()
            var
                lrc_PriceBase: Record "POI Price Base";
                lrc_UnitofMeasure: Record "Unit of Measure";
                lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
                lrc_SalesDocSubtype: Record "POI Sales Doc. Subtype";
                lrc_BatchVariant: Record "POI Batch Variant";
            begin
                // Prüfung ob Wiegen mit Wiegevorgabe aus Preisbasis kollidiert
                IF CurrFieldNo = FIELDNO("POI Weight") THEN
                    IF lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Sales Price", "POI Price Base (Sales Price)") THEN
                        IF (lrc_PriceBase.Weight <> lrc_PriceBase.Weight::" ") AND ("POI Weight" <> lrc_PriceBase.Weight) THEN
                            // Eingabe Wiegen ist abweichend von Vorgabe aus Preisbasis!
                            ERROR(ADF_GT_TEXT019Txt);

                CASE "POI Weight" OF
                    "POI Weight"::" ":
                        BEGIN
                            IF lrc_UnitofMeasure.GET("Unit of Measure Code") THEN BEGIN
                                "Gross Weight" := lrc_UnitofMeasure."POI Gross Weight";
                                "Net Weight" := lrc_UnitofMeasure."POI Net Weight";
                                IF lrc_ItemUnitofMeasure.GET("No.", "Unit of Measure Code") THEN BEGIN
                                    IF lrc_ItemUnitofMeasure."POI Gross Weight" <> 0 THEN
                                        "Gross Weight" := lrc_ItemUnitofMeasure."POI Gross Weight";
                                    IF lrc_ItemUnitofMeasure."POI Net Weight" <> 0 THEN
                                        "Net Weight" := lrc_ItemUnitofMeasure."POI Net Weight";
                                END;
                            END ELSE BEGIN
                                "Gross Weight" := 0;
                                "Net Weight" := 0;
                            END;
                            "POI Total Gross Weight" := Quantity * "Gross Weight";
                            "POI Total Net Weight" := Quantity * "Net Weight";
                        END;

                    "POI Weight"::"Net Weight", "POI Weight"::"Gross Weight":
                        BEGIN
                            lrc_SalesDocSubtype.GET("Document Type", "POI Sales Doc. Subtype Code");
                            CASE lrc_SalesDocSubtype."Default Value for Weighting" OF
                                lrc_SalesDocSubtype."Default Value for Weighting"::"Weight from Unit of Measure",
                                lrc_SalesDocSubtype."Default Value for Weighting"::"Weight from Batch Variant":
                                    BEGIN
                                        IF lrc_UnitofMeasure.GET("Unit of Measure Code") THEN BEGIN
                                            "Gross Weight" := lrc_UnitofMeasure."POI Gross Weight";
                                            "Net Weight" := lrc_UnitofMeasure."POI Net Weight";
                                            IF lrc_ItemUnitofMeasure.GET("No.", "Unit of Measure Code") THEN BEGIN
                                                IF lrc_ItemUnitofMeasure."POI Gross Weight" <> 0 THEN
                                                    "Gross Weight" := lrc_ItemUnitofMeasure."POI Gross Weight";

                                                IF lrc_ItemUnitofMeasure."POI Net Weight" <> 0 THEN
                                                    "Net Weight" := lrc_ItemUnitofMeasure."POI Net Weight";

                                            END;
                                        END ELSE BEGIN
                                            "Gross Weight" := 0;
                                            "Net Weight" := 0;
                                        END;

                                        IF lrc_SalesDocSubtype."Default Value for Weighting" =
                                           lrc_SalesDocSubtype."Default Value for Weighting"::"Weight from Batch Variant" THEN
                                            IF "POI Batch Variant No." <> '' THEN BEGIN
                                                lrc_BatchVariant.GET("POI Batch Variant No.");
                                                IF lrc_BatchVariant."Net Weight" <> 0 THEN
                                                    "Net Weight" := lrc_BatchVariant."Net Weight";
                                                IF lrc_BatchVariant."Gross Weight" <> 0 THEN
                                                    "Gross Weight" := lrc_BatchVariant."Gross Weight";
                                            END;

                                        "POI Total Gross Weight" := Quantity * "Gross Weight";
                                        "POI Total Net Weight" := Quantity * "Net Weight";
                                    END;

                                lrc_SalesDocSubtype."Default Value for Weighting"::"No Weight":
                                    BEGIN
                                        "Gross Weight" := 0;
                                        "Net Weight" := 0;
                                        "POI Total Gross Weight" := 0;
                                        "POI Total Net Weight" := 0;
                                    END;
                            END;
                        END;
                END;

                // Kontrolle ob eine Eink.-Auftragszeile mit der Verk.-Auftragszeile verbunden ist
                IF ("Purchase Order No." <> '') AND
                   ("Purch. Order Line No." <> 0) THEN
                    IF gbn_CalledChangefromPurchLine = FALSE THEN
                        gcu_AgencyBusinessMgt.ChangeSalesWeight(Rec);
            end;
        }
        field(5110396; "POI Blocked for Sale"; Boolean)
        {
            Caption = 'Blocked for Sale';
        }
        field(5110397; "POI Qty.(COU) pr Pack.Unit(PU)"; Decimal)
        {
            Caption = 'Qty. (COU) per Pack. Unit (PU)';
        }
        field(5110410; "POI Empties Item No."; Code[20])
        {
            Caption = 'Empties Item No.';
            Description = 'LVW';
            TableRelation = IF (Type = CONST(Item)) Item WHERE("POI Item Typ" = CONST("Empties Item"));

            trigger OnValidate()
            var
                lcu_EmptiesManagement: Codeunit "POI EIM Empties Item Mgt";
            begin
                ADF_CalculateEmptiesRefund();
                IF ("POI Empties Item No." <> xRec."POI Empties Item No.") AND
                   (xRec."POI Empties Item No." <> '') THEN
                    lcu_EmptiesManagement.DeleteEmptiesItemSalesLines(Rec);
            end;
        }
        field(5110411; "POI Empties Quantity"; Decimal)
        {
            Caption = 'Empties Quantity';
            Description = 'LVW';

            trigger OnValidate()
            var

                lcu_EmptiesManagement: Codeunit "POI EIM Empties Item Mgt";
                lint_EmptiesLineNo: Integer;
                lco_EmptiesBlanketDocNo: Code[20];
                lint_EmptiesBlanketLineNo: Integer;
            begin
                ADF_CalculateEmptiesRefund();
                //RS Leergutzeile anlegen

                IF "Blanket Order No." = '' THEN BEGIN
                    IF (("POI Empties Quantity" <> 0) OR (xRec."POI Empties Quantity" <> 0)) THEN
                        IF (("POI Empties Line No" = 0) AND ("POI Empties Blank Ord Line No." = 0)) THEN
                            lcu_EmptiesManagement.SalesAttachEmptiestoSalesLines("Document Type", "Document No.", "Line No.",
                                                                                 lint_EmptiesLineNo, lco_EmptiesBlanketDocNo,
                                                                                 lint_EmptiesBlanketLineNo, "POI Empties Quantity");
                    "POI Empties Blank Ord Line No." := lint_EmptiesBlanketLineNo;
                    "POI Empties Line No" := lint_EmptiesLineNo;
                    "POI Empties Blanket Order No." := lco_EmptiesBlanketDocNo;
                END ELSE
                    IF "POI Empties Line No" <> 0 THEN BEGIN
                        lrc_EmptiesSalesLine.SETRANGE("Document Type", "Document Type");
                        lrc_EmptiesSalesLine.SETRANGE("Document No.", "Document No.");
                        lrc_EmptiesSalesLine.SETRANGE("Line No.", "POI Empties Line No");
                        IF lrc_EmptiesSalesLine.FINDSET(TRUE, FALSE) THEN BEGIN
                            //lrc_EmptiesSalesLine.Quantity := "POI Empties Quantity";
                            lrc_EmptiesSalesLine.VALIDATE(Quantity, "POI Empties Quantity");
                            lrc_EmptiesSalesLine.MODIFY();
                        END;
                    END ELSE
                        IF "POI Empties Blank Ord Line No." <> 0 THEN BEGIN
                            lrc_EmptiesSalesLine.SETRANGE("Document Type", "Document Type"::"Blanket Order");
                            lrc_EmptiesSalesLine.SETRANGE("Document No.", "POI Empties Blanket Order No.");
                            lrc_EmptiesSalesLine.SETRANGE("Line No.", "POI Empties Blank Ord Line No.");
                            IF lrc_EmptiesSalesLine.FINDSET(TRUE, FALSE) THEN BEGIN
                                //lrc_EmptiesSalesLine.Quantity := "POI Empties Quantity";
                                lrc_EmptiesSalesLine.VALIDATE(Quantity, "POI Empties Quantity");
                                lrc_EmptiesSalesLine.MODIFY();
                            END;
                        END;
            end;
        }
        field(5110413; "POI Empties Refund Amount"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Empties Refund Amount';
            Description = 'LVW';
        }
        field(5110414; "POI Empties Line No"; Integer)
        {
            Caption = 'Empties Line No';
            Description = 'LVW';
        }
        field(5110427; "POI Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            TableRelation = Vendor."No." WHERE(Blocked = FILTER(' '));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_SalesDocType: Record "POI Sales Doc. Subtype";
                lrc_SalesHeader: Record "Sales Header";
            begin
                gcu_BaseDataMgt.VendValidateSearch("POI Buy-from Vendor No.", (CurrFieldNo = FIELDNO("POI Buy-from Vendor No.")));
                IF "POI Buy-from Vendor No." <> '' THEN
                    IF lrc_SalesHeader.GET("Document Type", "Document No.") THEN
                        IF lrc_SalesDocType.GET("Document Type", lrc_SalesHeader."POI Sales Doc. Subtype Code") THEN BEGIN
                            lrc_PurchSalesDocReference.RESET();
                            lrc_PurchSalesDocReference.SETRANGE(Source, lrc_PurchSalesDocReference.Source::Purchase);
                            lrc_PurchSalesDocReference.SETFILTER("Document Type", '%1|%2', lrc_PurchSalesDocReference."Document Type"::None, "Document Type");
                            IF lrc_SalesDocType."Purch. Order Doc. Subtype Code" <> '' THEN
                                lrc_PurchSalesDocReference.SETRANGE("Doc. Subtype Code", lrc_SalesDocType."Purch. Order Doc. Subtype Code")
                            ELSE
                                lrc_PurchSalesDocReference.SETRANGE("Doc. Subtype Code", lrc_SalesHeader."POI Sales Doc. Subtype Code");
                            lrc_PurchSalesDocReference.SETRANGE("Reference Type", lrc_PurchSalesDocReference."Reference Type"::Location);
                            lrc_PurchSalesDocReference.SETRANGE("Reference Source Code", "POI Buy-from Vendor No.");
                            IF lrc_PurchSalesDocReference.FINDFIRST() THEN
                                IF lrc_PurchSalesDocReference."Reference Code" <> '' THEN
                                    VALIDATE("Location Code", lrc_PurchSalesDocReference."Reference Code");
                        END;
            end;
        }
        field(5110429; "POI Order Address Code"; Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code WHERE("Vendor No." = FIELD("POI Buy-from Vendor No."));

            trigger OnLookup()
            var
                lrc_OrderAddress: Record "Order Address";
                lfm_OrderAddressList: Page "Order Address List";
            begin
                lrc_OrderAddress.RESET();
                lrc_OrderAddress.FILTERGROUP(2);
                lrc_OrderAddress.SETFILTER("Vendor No.", '%1|%2', "POI Buy-from Vendor No.", '');
                lrc_OrderAddress.FILTERGROUP(0);
                lfm_OrderAddressList.LOOKUPMODE := TRUE;
                lfm_OrderAddressList.SETTABLEVIEW(lrc_OrderAddress);
                IF lfm_OrderAddressList.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                    lfm_OrderAddressList.GETRECORD(lrc_OrderAddress);
                    IF lrc_OrderAddress.Code <> '' THEN
                        VALIDATE("POI Order Address Code", lrc_OrderAddress.Code);
                END;
            end;
        }

        field(5110430; "POI Total Net Weight"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Total Net Weight';
            DecimalPlaces = 0 : 3;

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("POI Total Net Weight") THEN
                    IF "POI Weight" <> "POI Weight"::"Net Weight" THEN
                        // Kein Artikel für Nettowiegen!
                        ERROR(ADF_GT_TEXT036Txt);


                TESTFIELD(Quantity);
                VALIDATE("Net Weight", ROUND("POI Total Net Weight" / Quantity, 0.00001));
                VALIDATE("Sales Price (Price Base)");
            end;
        }
        field(5110431; "POI Total Gross Weight"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Total Gross Weight';
            DecimalPlaces = 0 : 3;

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("POI Total Gross Weight") THEN
                    IF "POI Weight" <> "POI Weight"::"Gross Weight" THEN
                        // Kein Artikel für Bruttowiegen!
                        ERROR(ADF_GT_TEXT037Txt);

                TESTFIELD(Quantity);
                VALIDATE("Gross Weight", ROUND("POI Total Gross Weight" / Quantity, 0.00001));
                VALIDATE("Sales Price (Price Base)");
            end;
        }
        field(5110440; "POI Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            Description = 'EIA,EDM';
            TableRelation = "Country/Region".Code;
        }
        field(5110441; "POI Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            Description = 'EIA';
            TableRelation = "POI Variety";
        }
        field(5110442; "POI Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            Description = 'EIA';
            TableRelation = "POI Trademark";
            ValidateTableRelation = false;
        }
        field(5110443; "POI Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            Description = 'EIA';
            TableRelation = "POI Caliber".Code;
            ValidateTableRelation = false;
        }
        field(5110444; "POI Vendor Caliber Code"; Code[10])
        {
            Caption = 'Vendor Caliber Code';
            Description = 'EIA';
            TableRelation = "POI Caliber - Vendor Caliber"."Vend. Caliber Code" WHERE("Caliber Code" = FIELD("POI Caliber Code"));
            ValidateTableRelation = false;
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
            Caption = 'Grade of Goods Code';
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

            trigger OnValidate()
            var
                lrc_ProperName: Record "POI Proper Name";
            begin

                //RS Anlage EPS Zeile
                IF lrc_ProperName.GET("POI Item Attribute 6") THEN
                    IF lrc_ProperName.Artikelnummer <> '' THEN BEGIN
                        "POI Empties Item No." := lrc_ProperName.Artikelnummer;
                        IF Quantity <> 0 THEN
                            VALIDATE("POI Empties Quantity", Quantity);
                    END;
            end;
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
        field(5110455; "POI Item Attribute 1"; Code[10])
        {
            CaptionClass = '5110310,1,1';
            Caption = 'Item Attribute 1';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 1";
        }
        field(5110467; "POI Reference Item No."; Code[20])
        {
            Caption = 'Reference Item No.';
            TableRelation = Item;
        }
        field(3010501; "POI Customer Line Reference"; Integer)
        {
            Caption = 'Customer Line Reference';
        }

    }
    procedure ADF_ChangeUnitPartitialQty()
    var

        //lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        //lrc_Item: Record Item;
        lrc_UnitofMeasure: Record "Unit of Measure";
        //lrc_BatchVariant: Record "POI Batch Variant";
        //lco_ColloUnit: Code[10];
        AGILES_LT_001Txt: Label 'Anbruch nur für Artikel zulässig!';
        AGILES_LT_002Txt: Label 'Bitte zuerst Artikelnummer eingeben!';
    begin
        // ---------------------------------------------------------------------------------
        // Funktion zum Wechsel der Verkaufseinheit
        // Funktion muss noch in die Codeunit Sales ausgelagert werden
        // ---------------------------------------------------------------------------------

        IF Type <> Type::Item THEN BEGIN
            IF "POI Partial Quantity (PQ)" = TRUE THEN
                // Anbruch nur für Artikel zulässig!
                ERROR(AGILES_LT_001Txt);
            EXIT;
        END;
        IF "No." = '' THEN
            // Bitte zuerst Artikelnummer eingeben!
            ERROR(AGILES_LT_002Txt);

        // Einheit auf Anbruchseinheit setzen
        IF "POI Partial Quantity (PQ)" = TRUE THEN BEGIN
            lrc_UnitofMeasure.GET("Unit of Measure Code");
            lrc_UnitofMeasure.TESTFIELD("POI Part. Qty. Unit of Measure");
            // Kolloeinheit die angebrochen wird speichern
            "POI Collo Unit of Measure (PQ)" := "Unit of Measure Code";
            VALIDATE("Unit of Measure Code", lrc_UnitofMeasure."POI Part. Qty. Unit of Measure");
            // Leergut Menge auf Null setzen
            VALIDATE("POI Empties Quantity", 0);
            "POI Partial Quantity (PQ)" := TRUE;

            // Einheit auf Kolloeinheit setzen
        END ELSE BEGIN
            VALIDATE("Unit of Measure Code", "POI Collo Unit of Measure (PQ)");
            "POI Collo Unit of Measure (PQ)" := '';
            // Leergut Menge setzen
            //VALIDATE("Empties Quantity",0);
            "POI Partial Quantity (PQ)" := FALSE;
        END;

        // Menge und Preis auf Null setzen bei Anbruchswechsel
        VALIDATE(Quantity, 0);
        VALIDATE("Sales Price (Price Base)", 0);
    end;

    procedure ADF_CalculateEmptiesRefund()
    var
        lrc_SalesHeader: Record "Sales Header";
        lrc_RefundCosts: Record "POI Empties/Transport Ref Cost";
        lrc_UnitofMeasure: Record "Unit of Measure";
        lcu_EmptiesManagement: Codeunit "POI EIM Empties Item Mgt";
        ldt_Date: Date;
        ldc_Quantity: Decimal;
        lin_Faktor: Integer;

    begin

        lrc_SalesHeader.GET("Document Type", "Document No.");
        ldt_Date := lrc_SalesHeader."Order Date";
        IF ldt_Date = 0D THEN
            ldt_Date := lrc_SalesHeader."Document Date";

        IF NOT "POI Partial Quantity (PQ)" THEN
            ldc_Quantity := Quantity
        ELSE BEGIN
            // Über "Collo Unit of Measure (PQ)" rechnen, welcher Menge an Kolli dies entspricht
            // dies dann kaufmännisch runden. Mindestens ist der Faktor aber immer 1
            lin_Faktor := 1;
            IF lrc_UnitofMeasure.GET("POI Collo Unit of Measure (PQ)") THEN
                // Um sicherzustellen, dass der richtige Faktor verwendet wird, wird hier geschaut, ob die Anbruchseinheit
                // der Verkaufszeile der Verpackungseinheit aus der Hinterlegung entspricht
                IF "Unit of Measure Code" = lrc_UnitofMeasure."POI Packing Unit of Meas (PU)" THEN BEGIN
                    lin_Faktor := ROUND(Quantity / lrc_UnitofMeasure."POI Qty. (PU) per Unit of Meas", 1);
                    // Es muss immer mindestens 1 sein
                    IF lin_Faktor < 1 THEN
                        lin_Faktor := 1;
                END;
            ldc_Quantity := lin_Faktor;
        END;

        IF (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Credit Memo") OR
           (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Return Order") THEN
            lcu_EmptiesManagement.CalculateEmptiesReceiptPrice(Rec."POI Empties Item No.",
                                                                lrc_RefundCosts."Source Type"::Customer,
                                                                lrc_SalesHeader."Sell-to Customer No.",
                                                                Rec."Location Code",
                                                                ldt_Date,
                                                                ldc_Quantity,
                                                                "POI Empties Quantity",
                                                                Rec."Document Type",
                                                                Rec."Document No.",
                                                                Rec."Line No.",
                                                                Rec."POI Empties Refund Amount")
        ELSE
            lcu_EmptiesManagement.CalculateEmptiesShipmentPrice(Rec."POI Empties Item No.",
                                                                 lrc_RefundCosts."Source Type"::Customer,
                                                                 lrc_SalesHeader."Sell-to Customer No.",
                                                                 Rec."Location Code",
                                                                 ldt_Date,
                                                                 ldc_Quantity,
                                                                 "POI Empties Quantity",
                                                                 Rec."POI Empties Refund Amount");
    end;

    procedure ADF_CalcQuantity(vin_FieldNo: Integer)
    begin
        // --------------------------------------------------------------------------------------
        // Funktion zur Berechnung der Mengen
        // --------------------------------------------------------------------------------------

        IF CurrFieldNo <> vin_FieldNo THEN
            EXIT;

        CASE vin_FieldNo OF
            // Keine explizite Eingabe
            0:
                BEGIN
                    // Menge Verpackungen berechnen
                    "POI Quantity (PU)" := Quantity * "POI Qty. (PU) per Unit of Meas";
                    // Menge Paletten berechnen
                    IF "POI Qty.(Unit) per Transp.(TU)" <> 0 THEN
                        "POI Quantity (TU)" := ROUND(Quantity / "POI Qty.(Unit) per Transp.(TU)", 0.00001)
                    ELSE
                        "POI Quantity (TU)" := 0;
                END;
            // Eingabe Menge Verkaufseinheit
            FIELDNO(Quantity):
                BEGIN
                    // Menge Verpackungen berechnen
                    "POI Quantity (PU)" := Quantity * "POI Qty. (PU) per Unit of Meas";
                    // Menge Paletten berechnen
                    IF "POI Qty.(Unit) per Transp.(TU)" <> 0 THEN
                        "POI Quantity (TU)" := ROUND(Quantity / "POI Qty.(Unit) per Transp.(TU)", 0.00001)
                    ELSE
                        "POI Quantity (TU)" := 0;
                END;
            // Eingabe Menge Paletten
            FIELDNO("POI Quantity (TU)"):
                BEGIN
                    // Anbruch nicht zulässig
                    TESTFIELD("POI Partial Quantity (PQ)", FALSE);
                    // Menge Kolli berechnen
                    VALIDATE(Quantity, ("POI Quantity (TU)" * "POI Qty.(Unit) per Transp.(TU)"));
                    // Menge Verpackungen berechnen
                    "POI Quantity (PU)" := Quantity * "POI Qty. (PU) per Unit of Meas";
                END;
            // Eingabe Menge Verpackungen
            FIELDNO("POI Quantity (PU)"):
                BEGIN
                    // Anbruch nicht zulässig
                    TESTFIELD("POI Partial Quantity (PQ)", FALSE);
                    // Menge Kolli berechnen
                    TESTFIELD("POI Qty. (PU) per Unit of Meas");
                    VALIDATE(Quantity, ROUND("POI Quantity (PU)" / "POI Qty. (PU) per Unit of Meas", 0.00001));
                    // Menge Paletten berechnen
                    IF "POI Qty.(Unit) per Transp.(TU)" <> 0 THEN
                        "POI Quantity (TU)" := ROUND(Quantity / "POI Qty.(Unit) per Transp.(TU)", 0.00001)
                    ELSE
                        "POI Quantity (TU)" := 0;
                END;
            // Eingabe Menge Verpackungen pro Einheit
            FIELDNO("POI Qty. (PU) per Unit of Meas"):
                // Menge Verpackungen berechnen
                "POI Quantity (PU)" := Quantity * "POI Qty. (PU) per Unit of Meas";
            // Eingabe Menge Einheiten pro Transporteinheit
            FIELDNO("POI Qty.(Unit) per Transp.(TU)"):
                // Menge Paletten berechnen
                IF "POI Qty.(Unit) per Transp.(TU)" <> 0 THEN
                    "POI Quantity (TU)" := ROUND(Quantity / "POI Qty.(Unit) per Transp.(TU)", 0.00001)
                ELSE
                    "POI Quantity (TU)" := 0;
        END;
    end;

    procedure ADF_ChangeCalledFromPurchLine(rbn_CalledChangefromPurchLine: Boolean)
    begin
        // ---------------------------------------------------------------------------------------------------------
        // Funktion zum Setzen der Globalen Variable
        // ---------------------------------------------------------------------------------------------------------
        gbn_CalledChangefromPurchLine := rbn_CalledChangefromPurchLine;
    end;

    var
        SalesHeader: Record "Sales Header";
        lrc_PalletFactorbyPercentage: Record "POI Pallet Factor by Percent";
        lrc_EmptiesSalesLine: Record "Sales Line";
        lrc_PurchSalesDocReference: Record "POI Purch./Sales Doc. Refer.";
        gcu_BaseDataMgt: Codeunit "POI BDM Base Data Mgmt";
        gcu_AgencyBusinessMgt: Codeunit "POI Agency Business Mgt";
        gcu_SalesMgt: Codeunit "POI Sales Mgt";
        gbn_CalledChangefromPurchLine: Boolean;
        AGILES_TEXT002Txt: Label 'Input not allowed!';
        ADF_GT_TEXT019Txt: Label 'Eingabe Wiegen ist abweichend von Vorgabe aus Preisbasis!';
        ADF_GT_TEXT036Txt: Label 'Kein Artikel für Nettowiegen!';
        ADF_GT_TEXT037Txt: Label 'Kein Artikel für Bruttowiegen!';
}