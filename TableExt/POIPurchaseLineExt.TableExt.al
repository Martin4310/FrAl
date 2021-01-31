tableextension 50008 "POI PurchaseLineExt" extends "Purchase Line"
{
    fields
    {
        field(50000; "POI Means of Transp.Code (Arr)"; Code[20])
        {
            Caption = 'Means of Transp. Code (Arriva)';
            Description = 'von FlowField in Normal CalcFormula: Lookup("Purchase Header"."Means of Transp. Code (Arriva)" WHERE (Document Type=FIELD(Document Type),No.=FIELD(Document No.)))';
            Editable = false;
            TableRelation = "POI Means of Transport".Code;
        }
        field(50003; "POI Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
        }
        field(50001; "POI ETA week"; Integer)
        {
            BlankZero = true;
        }
        field(50002; "POI ETA year"; Integer)
        {
            BlankZero = true;
        }
        field(50010; "POI Zusatz"; Code[30])
        {
            TableRelation = "POI Standardplankostenzusatz".Merkmal;
        }
        field(50011; "POI Packing Type"; Code[20])
        {
            Caption = 'Verpackungstyp';
            TableRelation = "POI Parameter".Typecode1 where("Source No." = field("No."), Department = const('PACKTYP'), "Source Type" = const(Item));
            trigger OnLookup()
            var
                Parameter: Record "POI Parameter";
                ParameterPL: Page "POI Parameter";
            begin
                Parameter.Reset();
                Parameter.SetRange(Department, 'PACKTYP');
                Parameter.SetRange("Source No.", "No.");
                Parameter.SetRange("Source Type", Parameter."Source Type"::Item);
                Clear(ParameterPL);
                ParameterPL.SetTableView(Parameter);
                ParameterPL.Editable := false;
                if ParameterPL.RunModal() = action::OK then begin
                    ParameterPL.GetRecord(Parameter);
                    "POI Packing Type" := Parameter.Typecode1;
                end;
            end;
        }
        field(50040; "POI EAN"; Code[13])
        {
            Caption = 'EAN-Code';
            trigger OnLookup()
            begin
                ItemAttribut.Reset();
                ItemAttribut.SetRange("Item No.", "No.");
                ItemAttribut.SetRange("Attribute Type", ItemAttribut."Attribute Type"::"EAN Code");
                ItemAttribut.SetRange("Source No.", "Buy-from Vendor No.");
                ItemAttribut.SetRange("Source Type", ItemAttribut."Source Type"::Vendor);
                if ItemAttribut.Count() = 0 then begin
                    ItemAttribut.SetRange("Source No.", '');
                    ItemAttribut.SetRange("Source Type", ItemAttribut."Source Type"::" ");
                end;
                clear(ItemAttributpg);
                ItemAttributpg.SetTableView(ItemAttribut);
                ItemAttributpg.Editable := false;
                if ItemAttributpg.RunModal() = Action::OK then begin
                    ItemAttributpg.GetRecord(ItemAttribut);
                    "POI EAN" := copystr(ItemAttribut."Attribute Code", 1, 13);
                end;
            end;
        }
        field(50041; "POI PLU-Code"; Code[5])
        {
            trigger OnLookup()
            begin
                ItemAttribut.Reset();
                ItemAttribut.SetRange("Item No.", "No.");
                ItemAttribut.SetRange("Attribute Type", ItemAttribut."Attribute Type"::"PLU-Code");
                ItemAttribut.SetFilter("Source No.", '%1|%2', "Buy-from Vendor No.", '');
                ItemAttribut.SetFilter("Source Type", '%1|%2', ItemAttribut."Source Type"::Vendor, ItemAttribut."Source Type"::" ");
                clear(ItemAttributpg);
                ItemAttributpg.SetTableView(ItemAttribut);
                if ItemAttributpg.RunModal() = Action::OK then begin
                    ItemAttributpg.GetRecord(ItemAttribut);
                    "POI PLU-Code" := copystr(ItemAttribut."Attribute Code", 1, 5);
                end;
            end;
        }
        field(50042; "POI Customer Group Code"; Code[10])
        {
            Caption = 'Kundengruppe';
            TableRelation = "POI Customer Group".Code;
        }
        field(50060; "POI Departure Location Code"; Code[20])
        {
            CalcFormula = Lookup ("Purchase Header"."POI Departure Location Code" WHERE("Document Type" = FIELD("Document Type"),
                                                                                    "No." = FIELD("Document No.")));
            Caption = 'Abgangslager';
            FieldClass = FlowField;
            TableRelation = Location.Code;
        }
        field(5110304; "POI Expected Purch. Price"; Boolean)
        {
            Caption = 'Expected Purch. Price';
        }
        field(5110305; "POI Subtyp"; Option)
        {
            Caption = 'Subtyp';
            Description = ' ,Discount,Refund';
            OptionCaption = ' ,Discount,Refund Empties,Refund Transport,,,,Freight,Insurance,,,,,Statement';
            OptionMembers = " ",Discount,"Refund Empties","Refund Transport",,,,Freight,Insurance,,,,,Statement;
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
        field(5110303; "POI Shelf No."; Code[10])
        {
            Caption = 'Shelf No.';
        }
        field(5110307; "POI Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            Description = ' ,Payed,Not Payed';
            OptionCaption = ' ,Payed,Not Payed';
            OptionMembers = " ",Payed,"Not Payed";

            trigger OnValidate()
            begin
                TESTFIELD("Quantity Received", 0);
            end;
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
        field(5110310; "POI Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;
        }
        field(5110311; "POI Lot No. Producer"; Code[30])
        {
            Caption = 'Lot No. Producer';

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF "POI Lot No. Producer" <> xRec."POI Lot No. Producer" THEN
                    lcu_PalletManagement.ActualFieldsFromPurchLine(copystr(FIELDCAPTION("POI Lot No. Producer"), 1, 100), Rec, xRec);
            end;
        }
        field(5110312; "POI Order Address Code"; Code[10])
        {
            Caption = 'Order Address Code';

            trigger OnLookup()
            var
                lrc_OrderAddress: Record "Order Address";
                lfm_OrderAddressList: page "Order Address List";
            begin
                // Filterung setzen
                lrc_OrderAddress.FILTERGROUP(2);
                lrc_OrderAddress.SETFILTER("Vendor No.", '%1|%2', "Buy-from Vendor No.", '');
                lrc_OrderAddress.FILTERGROUP(0);
                lfm_OrderAddressList.LOOKUPMODE := TRUE;
                lfm_OrderAddressList.SETTABLEVIEW(lrc_OrderAddress);
                IF lfm_OrderAddressList.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                    lfm_OrderAddressList.GETRECORD(lrc_OrderAddress);
                    IF lrc_OrderAddress.Code <> '' THEN
                        VALIDATE("POI Order Address Code", lrc_OrderAddress.Code);
                END;
            end;

            trigger OnValidate()
            begin
                UpdateUnitCost();
            end;
        }
        field(5110313; "POI Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent".Code WHERE("POI Blocked" = CONST(false));
        }
        field(5110316; "POI Waste Disposal Paymt Thru"; Option)
        {
            Caption = 'Waste Disposal Payment Thru';
            Description = 'DSD';
            OptionCaption = 'Us,Vendor';
            OptionMembers = Us,Vendor;
        }
        field(5110319; "POI Cost Category Code"; Code[20])
        {
            Caption = 'Cost Category Code';
            TableRelation = "POI Cost Category" WHERE("Cost Global Source" = CONST(Purchase));

            trigger OnValidate()
            begin
                ADF_CheckCostCategoryCode();
            end;
        }
        field(5110320; "POI Item Typ"; Option)
        {
            Caption = 'Item Typ';
            Description = 'Standard,Batch Item,Empties Item';
            OptionCaption = 'Trade Item,,Empties Item,Transport Item,,Packing Material,,,Spare Parts,,,Freight Item,Dummy Item';
            OptionMembers = "Trade Item",,"Empties Item","Transport Item",,"Packing Material",,,"Spare Parts",,,"Freight Item","Dummy Item";
        }
        field(50321; "POI Master Batch No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'POI Master Batch No.';
        }
        field(50322; "POI Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
        }
        field(5110323; "POI Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = IF (Type = CONST(Item)) "POI Batch Variant"."No." WHERE("Item No." = FIELD("No."));

            trigger OnValidate()
            var

                lrc_BatchVariant: Record "POI Batch Variant";
                //lrc_DocDim: Record "357";
                //lrc_MasterBatch: Record "POI Master Batch";
                lcu_PalletManagement: Codeunit "POI Pallet Management";
                AGILES_LT_TEXT001Txt: Label 'Änderung nicht zulässig!';

            begin
                IF CurrFieldNo = FIELDNO("POI Batch Variant No.") THEN
                    IF "POI Batch Variant generated" = TRUE THEN
                        // Änderung nicht zulässig!
                        ERROR(AGILES_LT_TEXT001Txt);

                IF (xRec."POI Batch Variant No." <> "POI Batch Variant No.") THEN
                    lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PL(copystr(FIELDCAPTION("POI Batch Variant No."), 1, 100), Rec);

                IF "POI Batch Variant No." = '' THEN BEGIN
                    IF Type = Type::Item THEN BEGIN
                        Item.GET("No.");
                        Description := Item.Description;
                        "Description 2" := Item."Description 2";
                        "POI Variety Code" := Item."POI Variety Code";
                        "POI Country of Origin Code" := Item."POI Countr of Ori Code (Fruit)";
                        "POI Trademark Code" := Item."POI Trademark Code";
                        "POI Item Attribute 6" := Item."POI Item Attribute 6";
                        "POI Caliber Code" := Item."POI Caliber Code";
                        "POI Item Attribute 2" := Item."POI Item Attribute 2";
                        "POI Grade of Goods Code" := Item."POI Grade of Goods Code";
                        "POI Item Attribute 7" := Item."POI Item Attribute 7";
                        "POI Item Attribute 3" := Item."POI Item Attribute 3";
                        "POI Item Attribute 4" := Item."POI Item Attribute 4";
                        "POI Coding Code" := Item."POI Coding Code";
                        "POI Item Attribute 5" := Item."POI Item Attribute 5";
                        "POI Cultivation Type" := Item."POI Cultivation Type";
                        "POI Item Attribute 1" := Item."POI Item Attribute 1";
                        "POI Cultivation Associat. Code" := '';
                        "POI Batch No." := '';
                    END;
                END ELSE BEGIN
                    lrc_BatchVariant.GET("POI Batch Variant No.");
                    "POI Variety Code" := lrc_BatchVariant."Variety Code";
                    "POI Country of Origin Code" := lrc_BatchVariant."Country of Origin Code";
                    "POI Trademark Code" := lrc_BatchVariant."Trademark Code";
                    "POI Item Attribute 6" := lrc_BatchVariant."Item Attribute 6";
                    "POI Caliber Code" := lrc_BatchVariant."Caliber Code";
                    "POI Item Attribute 2" := lrc_BatchVariant."Item Attribute 2";
                    "POI Grade of Goods Code" := lrc_BatchVariant."Grade of Goods Code";
                    "POI Item Attribute 7" := lrc_BatchVariant."Item Attribute 7";
                    "POI Item Attribute 3" := lrc_BatchVariant."Item Attribute 3";
                    "POI Item Attribute 4" := lrc_BatchVariant."Item Attribute 4";
                    "POI Coding Code" := lrc_BatchVariant."Coding Code";
                    "POI Item Attribute 5" := lrc_BatchVariant."Item Attribute 5";
                    "POI Cultivation Type" := lrc_BatchVariant."Cultivation Type";
                    "POI Item Attribute 1" := lrc_BatchVariant."Item Attribute 1";
                    "POI Cultivation Associat. Code" := lrc_BatchVariant."Cultivation Association Code";
                    IF ("POI Batch No." = '') OR
                       ("POI Batch No." <> lrc_BatchVariant."Batch No.") THEN
                        "POI Batch No." := lrc_BatchVariant."Batch No."
                END;

                //RS Dimensionen setzen
                // lrc_DocDim.SETRANGE("Table ID", 39);
                // lrc_DocDim.SETRANGE("Document Type", "Document Type");
                // lrc_DocDim.SETRANGE("Document No.", "Document No.");
                // lrc_DocDim.SETRANGE("Line No.", "Line No.");
                // IF "POI Batch Variant No." <> '' THEN BEGIN //TODO: Dimensionen neu berechnen
                //   lrc_MasterBatch.GET(lrc_BatchVariant."Master Batch No.");
                //   //Einkäufer
                //   lrc_DocDim.SETRANGE("Dimension Code", 'EINKÄUFER');
                //   IF lrc_DocDim.FINDSET(TRUE, FALSE) THEN BEGIN
                //     lrc_DocDim."Dimension Value Code" := lrc_MasterBatch."Purchaser Code";
                //     lrc_DocDim.MODIFY();
                //   END ELSE BEGIN;
                //     lrc_DocDim.INIT();
                //     lrc_DocDim."Table ID" := 39;
                //     lrc_DocDim."Document Type" := "Document Type";
                //     lrc_DocDim."Document No." := "Document No.";
                //     lrc_DocDim."Line No." := "Line No.";
                //     lrc_DocDim."Dimension Code" := 'EINKÄUFER';
                //     lrc_DocDim."Dimension Value Code" := lrc_MasterBatch."Purchaser Code";
                //     lrc_DocDim.INSERT();
                //   END;
                //   //Marke
                //   lrc_DocDim.SETRANGE("Dimension Code", 'MARKE');
                //   IF lrc_DocDim.FINDSET(TRUE, FALSE) THEN BEGIN
                //     lrc_DocDim."Dimension Value Code" := lrc_BatchVariant."Trademark Code";
                //     lrc_DocDim.Modify();
                //   END ELSE BEGIN;
                //     lrc_DocDim.INIT();
                //     lrc_DocDim."Table ID" := 39;
                //     lrc_DocDim."Document Type" := "Document Type";
                //     lrc_DocDim."Document No." := "Document No.";
                //     lrc_DocDim."Line No." := "Line No.";
                //     lrc_DocDim."Dimension Code" := 'MARKE';
                //     lrc_DocDim."Dimension Value Code" := lrc_BatchVariant."Trademark Code";
                //     lrc_DocDim.insert();
                //   END;

                //   //Partie
                //   lrc_DocDim.SETRANGE("Dimension Code", 'PARTIE');
                //   IF lrc_DocDim.FINDSET(TRUE, FALSE) THEN BEGIN
                //     lrc_DocDim."Dimension Value Code" := lrc_BatchVariant."Master Batch No.";
                //     lrc_DocDim.Modify();
                //   END ELSE BEGIN;
                //     lrc_DocDim.INIT();
                //     lrc_DocDim."Table ID" := 39;
                //     lrc_DocDim."Document Type" := "Document Type";
                //     lrc_DocDim."Document No." := "Document No.";
                //     lrc_DocDim."Line No." := "Line No.";
                //     lrc_DocDim."Dimension Code" := 'PARTIE';
                //     lrc_DocDim."Dimension Value Code" := lrc_BatchVariant."Master Batch No.";
                //     lrc_DocDim.insert();
                //   END;
                //   //EK von Kreditor
                //   lrc_DocDim.SETRANGE("Dimension Code", 'EK von KREDITOR');
                //   IF lrc_DocDim.FINDSET(TRUE, FALSE) THEN BEGIN
                //     lrc_DocDim."Dimension Value Code" := lrc_BatchVariant."Vendor No.";
                //     lrc_DocDim.Modify();
                //   END ELSE BEGIN;
                //     lrc_DocDim.INIT();
                //     lrc_DocDim."Table ID" := 39;
                //     lrc_DocDim."Document Type" := "Document Type";
                //     lrc_DocDim."Document No." := "Document No.";
                //     lrc_DocDim."Line No." := "Line No.";
                //     lrc_DocDim."Dimension Code" := 'EK von KREDITOR';
                //     lrc_DocDim."Dimension Value Code" := lrc_BatchVariant."Vendor No.";
                //     lrc_DocDim.insert();
                //   END;


                //IF Type <> Type:: Item THEN BEGIN
                // //Artikelkategorie
                // lrc_DocDim.SETRANGE("Dimension Code", 'ARTIKELKATEGORIE');
                // IF lrc_DocDim.FINDSET(TRUE, FALSE) THEN BEGIN
                //   lrc_DocDim."Dimension Value Code" := lrc_BatchVariant."Item Category Code";
                //   lrc_DocDim.Modify();
                // END ELSE BEGIN;
                //   lrc_DocDim.INIT();
                //   lrc_DocDim."Table ID" := 39;
                //   lrc_DocDim."Document Type" := "Document Type";
                //   lrc_DocDim."Document No." := "Document No.";
                //   lrc_DocDim."Line No." := "Line No.";
                //   lrc_DocDim."Dimension Code" := 'ARTIKELKATEGORIE';
                //   lrc_DocDim."Dimension Value Code" := lrc_BatchVariant."Item Category Code";
                //   lrc_DocDim.insert();
                // END;

                // //Artikelhauptkat
                // lrc_DocDim.SETRANGE("Dimension Code", 'ARTIKELHAUPTKAT');
                // IF lrc_DocDim.FINDSET(TRUE, FALSE) THEN BEGIN
                //   lrc_DocDim."Dimension Value Code" := lrc_BatchVariant."Item Main Category Code";
                //   lrc_DocDim.Modify();
                // END ELSE BEGIN;
                //   lrc_DocDim.INIT();
                //   lrc_DocDim."Table ID" := 39;
                //   lrc_DocDim."Document Type" := "Document Type";
                //   lrc_DocDim."Document No." := "Document No.";
                //   lrc_DocDim."Line No." := "Line No.";
                //   lrc_DocDim."Dimension Code" := 'ARTIKELHAUPTKAT';
                //   lrc_DocDim."Dimension Value Code" := lrc_BatchVariant."Item Main Category Code";
                //   lrc_DocDim.insert();
                // END;
                // //Produktgruppe
                // lrc_DocDim.SETRANGE("Dimension Code", 'PRODUKTGRUPPE');
                // IF lrc_DocDim.FINDSET(TRUE, FALSE) THEN BEGIN
                //   lrc_DocDim."Dimension Value Code" := lrc_BatchVariant."Product Group Code";
                //   lrc_DocDim.Modify();
                // END ELSE BEGIN;
                //   lrc_DocDim.INIT();
                //   lrc_DocDim."Table ID" := 39;
                //   lrc_DocDim."Document Type" := "Document Type";
                //   lrc_DocDim."Document No." := "Document No.";
                //   lrc_DocDim."Line No." := "Line No.";
                //   lrc_DocDim."Dimension Code" := 'PRODUKTGRUPPE';
                //   lrc_DocDim."Dimension Value Code" := lrc_BatchVariant."Product Group Code";
                //   lrc_DocDim.insert();
                // END;
                //     //Kostenträger
                //     lrc_DocDim.SETRANGE("Dimension Code", 'KOSTENTRÄGER');
                //     IF lrc_DocDim.FINDSET(TRUE, FALSE) THEN BEGIN
                //       lrc_DocDim."Dimension Value Code" := lrc_BatchVariant."Item No.";
                //       lrc_DocDim.Modify();
                //     END ELSE BEGIN;
                //       lrc_DocDim.INIT();
                //       lrc_DocDim."Table ID" := 39;
                //       lrc_DocDim."Document Type" := "Document Type";
                //       lrc_DocDim."Document No." := "Document No.";
                //       lrc_DocDim."Line No." := "Line No.";
                //       lrc_DocDim."Dimension Code" := 'KOSTENTRÄGER';
                //       lrc_DocDim."Dimension Value Code" := lrc_BatchVariant."Item No.";
                //       lrc_DocDim.insert();
                //     END;
                //   END;
                //END ELSE BEGIN //Batch Variant ohne Wert
                //   //Einkäufer löschen
                //   lrc_DocDim.SETRANGE("Dimension Code", 'EINKÄUFER');
                //   IF lrc_DocDim.FINDSET() THEN
                //     lrc_DocDim.DELETEALL();
                //   //EK von Kreditor löschen
                //   lrc_DocDim.SETRANGE("Dimension Code", 'EK von KREDITOR');
                //   IF lrc_DocDim.FINDSET() THEN
                //     lrc_DocDim.DELETEALL();
                //   //Marke löschen
                //   lrc_DocDim.SETRANGE("Dimension Code", 'MARKE');
                //   IF lrc_DocDim.FINDSET() THEN
                //     lrc_DocDim.DELETEALL();
                //   //Partie löschen
                //   lrc_DocDim.SETRANGE("Dimension Code", 'PARTIE');
                //   IF lrc_DocDim.FINDSET() THEN
                //     lrc_DocDim.DELETEALL();
                //   IF Type <> Type :: Item THEN BEGIN
                //     //Partie löschen
                //     lrc_DocDim.SETRANGE("Dimension Code", 'PARTIE');
                //     IF lrc_DocDim.FINDSET() THEN
                //       lrc_DocDim.DELETEALL();
                //     //Produktgruppe löschen
                //     lrc_DocDim.SETRANGE("Dimension Code", 'PRODUKTGRUPPE');
                //     IF lrc_DocDim.FINDSET() THEN
                //       lrc_DocDim.DELETEALL();
                //     //Kostenträger löschen
                //     lrc_DocDim.SETRANGE("Dimension Code", 'KOSTENTRÄGER');
                //     IF lrc_DocDim.FINDSET() THEN
                //       lrc_DocDim.DELETEALL();
                //     //Artikelhauptkat löschen
                //     lrc_DocDim.SETRANGE("Dimension Code", 'ARTIKELHAUPTKAT');
                //     IF lrc_DocDim.FINDSET() THEN
                //       lrc_DocDim.DELETEALL();
                //     //Artikelkategorie löschen
                //     lrc_DocDim.SETRANGE("Dimension Code", 'ARTIKELKATEGORIE');
                //     IF lrc_DocDim.FINDSET() THEN
                //       lrc_DocDim.DELETEALL();
                //   END;
                // END;
            end;
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
        field(50326; "POI Batch Item"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Batch Item';
        }
        field(5110340; "POI Item Charg Batch Var. Code"; Code[20])
        {
            Caption = 'Item Charge Batch Var. Code';
        }
        field(5110341; "POI Item Charge Quantity"; Decimal)
        {
            Caption = 'Item Charge Quantity';
        }
        field(5110354; "POI Fiscal Agent Code"; Code[10])
        {
            Caption = 'Fiscal Agent Code';
            TableRelation = "POI Fiscal Agent".Code;
        }
        field(5110359; "POI Entry via Trans Loc. Code"; Code[10])
        {
            Caption = 'Entry via Transfer Loc. Code';
            TableRelation = Location;

            trigger OnValidate()
            var
                lrc_Location: Record Location;
            begin
                IF lrc_Location.GET("POI Entry via Trans Loc. Code") THEN
                    IF lrc_Location."POI Shipping Agent Code" <> '' THEN
                        VALIDATE("POI Shipping Agent Code", lrc_Location."POI Shipping Agent Code");
                UpdateUnitCost();
            end;
        }
        field(5110360; "POI Location Reference No."; Code[20])
        {
            Caption = 'Location Reference No.';
        }
        field(5110363; "POI Voyage No."; Code[20])
        {
            Caption = 'Voyage No.';
            TableRelation = "POI Voyage";

            trigger OnValidate()
            var
                lrc_Voyage: Record "POI Voyage";
            begin
                IF "POI Voyage No." <> '' THEN BEGIN
                    lrc_Voyage.GET("POI Voyage No.");
                    "Promised Receipt Date" := lrc_Voyage.ETA;
                    IF lrc_Voyage."Date of Arrival" <> 0D THEN
                        "Promised Receipt Date" := lrc_Voyage."Date of Arrival";
                    IF lrc_Voyage."Shipping Agent Code" <> '' THEN
                        "POI Shipping Agent Code" := lrc_Voyage."Shipping Agent Code";
                END;
            end;
        }
        field(5110364; "POI Container No."; Code[20])
        {
            Caption = 'Container No.';
            TableRelation = "POI Container";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lcu_ContainerMgt: Codeunit "POI Container Mgt";
            begin
                IF (Type <> Type::Item) OR ("No." = '') THEN
                    // Nur für Artikelzeilen zulässig!
                    ERROR(ADF_GT_TEXT007Txt);
                lcu_ContainerMgt.UpdContainerFromPurchLine(Rec, xRec."POI Container No.");
            end;
        }
        field(5110365; "POI Kind of Loading"; Option)
        {
            Caption = 'Kind of Loading';
            Description = ' ,Container,Reefer Vessel,Container and Reefer Vessel,,Konventionell';
            OptionCaption = ' ,Container,Reefer Vessel,Container and Reefer Vessel,,Konventionell';
            OptionMembers = " ",Container,"Reefer Vessel","Container and Reefer Vessel",,Konventionell;
        }
        field(5110370; "POI Price Unit of Measure"; Code[10])
        {
            Caption = 'Price Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(5110376; "POI Freight Unit of Meas (FU)"; Code[10])
        {
            Caption = 'Freight Unit of Measure (FU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF CurrFieldNo = FIELDNO("POI Freight Unit of Meas (FU)") THEN
                    ERROR('Direkte Eingabe nicht zulässig!');
                IF ((xRec."POI Freight Unit of Meas (FU)" <> "POI Freight Unit of Meas (FU)")) AND
                    ("POI Freight Unit of Meas (FU)" <> '') THEN
                    lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PL(copystr(FIELDCAPTION("POI Freight Unit of Meas (FU)"), 1, 100), Rec);
            end;
        }
        field(5110380; "POI Base Unit of Measure (BU)"; Code[10])
        {
            Caption = 'Base Unit of Measure (BU)';
            Editable = false;
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF (xRec."POI Base Unit of Measure (BU)" <> "POI Base Unit of Measure (BU)") THEN
                    lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PL(copystr(FIELDCAPTION("POI Base Unit of Measure (BU)"), 1, 100), Rec);
            end;
        }
        field(5110381; "POI Packing Unit of Meas (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));

            trigger OnValidate()
            var
                lrc_UnitofMeasure: Record "Unit of Measure";
                AGILES_LT_001Txt: Label 'Basiseinheit Kollo und Verpackung sind nicht identisch!';
            begin
                TESTFIELD("Quantity Received", 0);
                TESTFIELD("Qty. Received (Base)", 0);
                TESTFIELD("Qty. Rcd. Not Invoiced", 0);

                IF "POI Packing Unit of Meas (PU)" <> '' THEN BEGIN
                    lrc_UnitofMeasure.GET("POI Packing Unit of Meas (PU)");
                    IF lrc_UnitofMeasure."POI Base Unit of Measure (BU)" <> "POI Base Unit of Measure (BU)" THEN
                        ERROR(AGILES_LT_001Txt);
                    "POI Qty. (PU) per Unit of Meas" := lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas" / "Qty. per Unit of Measure";
                    "POI Quantity (PU)" := "POI Qty. (PU) per Unit of Meas" * Quantity;
                END ELSE BEGIN
                    "POI Qty. (PU) per Unit of Meas" := 0;
                    "POI Quantity (PU)" := 0;
                END;
            end;
        }
        field(5110382; "POI Qty. (PU) per Unit of Meas"; Decimal)
        {
            Caption = 'Qty. (PU) per Unit of Measure';

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("POI Qty. (PU) per Unit of Meas") THEN
                    ADF_CalcQuantity(FIELDNO("POI Qty. (PU) per Unit of Meas"));
            end;
        }
        field(5110383; "POI Quantity (PU)"; Decimal)
        {
            Caption = 'Quantity (PU)';

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("POI Quantity (PU)") THEN
                    ADF_CalcQuantity(FIELDNO("POI Quantity (PU)"));
            end;
        }
        field(5110384; "POI Transport Unit of Meas(TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));

            trigger OnValidate()
            var
                lrc_UnitofMeasure: Record "Unit of Measure";
                lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
                lcu_UnitMgt: Codeunit "POI Unit Mgt";
                lcu_PalletManagement: Codeunit "POI Pallet Management";
                ldc_PalletFaktor: Decimal;
            begin
                TESTFIELD("Quantity Received", 0);
                TESTFIELD("Unit of Measure Code");
                TESTFIELD(Type, Type::Item);

                // Keine Änderung wenn Pos.-Var. und Verkaufslieferungen vorhanden
                IF ADF_CheckIfSalesOrderShip((CurrFieldNo <> 0), TRUE, TRUE, TRUE) = TRUE THEN
                    ERROR('');

                // Prüfen, ob Feld generell geändert werden darf - Pflichtdimension darf nicht geändert werden, wenn Menge <> 0
                IF CurrFieldNo = FIELDNO("POI Transport Unit of Meas(TU)") THEN
                    gcu_ItemAttributeMgt.PurchLineCheckOnValidate(Rec, xRec, FIELDNO("POI Transport Unit of Meas(TU)"));

                // Transporteinheit leer dann Werte zurücksetzen und Validierung beenden
                IF "POI Transport Unit of Meas(TU)" = '' THEN BEGIN
                    "POI Qty. (Unit) per Transp(TU)" := 0;
                    "POI Quantity (TU)" := 0;
                    "POI Freight Unit of Meas (FU)" := '';
                    EXIT;
                END;

                // Transporteinheit lesen
                lrc_UnitofMeasure.GET("POI Transport Unit of Meas(TU)");
                // Frachteinheit setzen
                "POI Freight Unit of Meas (FU)" := lrc_UnitofMeasure."POI Freight Unit of Meas (FU)";

                // Transporteinheitenfaktor ermitteln
                // Prüfen ob eine Transporteinheit in Artikeleinheiten eingetragen ist
                IF lrc_ItemUnitofMeasure.GET("No.", "POI Transport Unit of Meas(TU)") THEN
                    VALIDATE("POI Qty. (Unit) per Transp(TU)", ROUND(lrc_ItemUnitofMeasure."Qty. per Unit of Measure" / "Qty. per Unit of Measure", 1))
                ELSE
                    // Prüfung auf Eintrag in Transporteinheit Faktor Tabelle
                    IF lcu_UnitMgt.GetItemVendorUnitPalletFactor("No.",
                                                              1,
                                                              "Buy-from Vendor No.",
                                                              "Unit of Measure Code",
                                                              "Qty. per Unit of Measure",
                                                              "POI Empties Item No.",
                                                              "POI Transport Unit of Meas(TU)",
                                                              ldc_PalletFaktor) = TRUE THEN
                        VALIDATE("POI Qty. (Unit) per Transp(TU)", ldc_PalletFaktor)
                    ELSE
                        // Transporteinheitenfaktor aus Eintrag Transporteinheit berechnen
                        IF lrc_UnitofMeasure."POI Qty. per Transp. Unit (TU)" <> 0 THEN
                            VALIDATE("POI Qty. (Unit) per Transp(TU)", (lrc_UnitofMeasure."POI Qty. per Transp. Unit (TU)" * lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas") / "Qty. per Unit of Measure")
                        ELSE BEGIN

                            // Bestehenden Faktor umrechnen
                            lrc_PalletFactorbyPercentage.SETRANGE("From Transport Unit", xRec."POI Transport Unit of Meas(TU)");
                            lrc_PalletFactorbyPercentage.SETRANGE("Into Transport Unit", "POI Transport Unit of Meas(TU)");
                            IF lrc_PalletFactorbyPercentage.FINDFIRST() THEN
                                VALIDATE("POI Qty. (Unit) per Transp(TU)", (ROUND(("POI Qty. (Unit) per Transp(TU)" * (lrc_PalletFactorbyPercentage.Percentage / 100)), 1, '>')));
                        END;


                // Anzahl Transporteinheiten berechnen
                IF "POI Qty. (Unit) per Transp(TU)" <> 0 THEN
                    "POI Quantity (TU)" := Quantity / "POI Qty. (Unit) per Transp(TU)"
                ELSE
                    "POI Quantity (TU)" := 0;

                IF ((xRec."POI Transport Unit of Meas(TU)" <> "POI Transport Unit of Meas(TU)")) AND
                   ("POI Transport Unit of Meas(TU)" <> '') THEN
                    lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PL(copystr(FIELDCAPTION("POI Transport Unit of Meas(TU)"), 1, 100), Rec);
            end;
        }
        field(5110385; "POI Qty. (Unit) per Transp(TU)"; Decimal)
        {
            Caption = 'Qty. (Unit) per Transp.(TU)';

            trigger OnValidate()
            begin
                TESTFIELD("Quantity Received", 0);
                TESTFIELD("POI Transport Unit of Meas(TU)");

                // Keine Änderung wenn Pos.-Var. und Verkaufslieferungen vorhanden
                IF ADF_CheckIfSalesOrderShip((CurrFieldNo <> 0), TRUE, TRUE, TRUE) = TRUE THEN
                    ERROR('');

                // Prüfen, ob Feld generell geändert werden darf - Pflichtdimension darf nicht geändert werden, wenn Menge <> 0
                IF CurrFieldNo = FIELDNO("POI Qty. (Unit) per Transp(TU)") THEN
                    gcu_ItemAttributeMgt.PurchLineCheckOnValidate(Rec, xRec, FIELDNO("POI Qty. (Unit) per Transp(TU)"));

                IF CurrFieldNo = FIELDNO("POI Qty. (Unit) per Transp(TU)") THEN
                    ADF_CalcQuantity(FIELDNO("POI Qty. (Unit) per Transp(TU)"));
            end;
        }
        field(5110386; "POI Quantity (TU)"; Decimal)
        {
            Caption = 'Quantity (TU)';

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("POI Quantity (TU)") THEN
                    ADF_CalcQuantity(FIELDNO("POI Quantity (TU)"));
            end;
        }
        field(5110388; "POI Content Unit of Meas (COU)"; Code[10])
        {
            Caption = 'Content Unit of Measure (COU)';
            TableRelation = "Item Unit of Measure".Code;
        }
        field(5110389; "POI No. of Layers on TU"; Decimal)
        {
            Caption = 'No. of Layers on TU';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5110390; "POI Price Base (Purch. Price)"; Code[10])
        {
            Caption = 'Price Base (Purch. Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Purch. Price"),
                                                     Blocked = CONST(false));

            trigger OnValidate()
            var
                lrc_PriceBase: Record "POI Price Base";
            begin
                "POI Price Unit of Measure" := gcu_PurchMgt.PurchLineGetPriceUnit(Rec);

                IF lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Purch. Price", "POI Price Base (Purch. Price)") then
                    // Prüfen ob es eine Vorgabe aus der Preisbasis gibt
                    IF (lrc_PriceBase.Weight <> lrc_PriceBase.Weight::" ") AND ("POI Weight" <> lrc_PriceBase.Weight) THEN
                        VALIDATE("POI Weight", lrc_PriceBase.Weight);

                UpdateDirectUnitCost(FIELDNO("POI Price Base (Purch. Price)"));
                VALIDATE("POI Purch. Price (Price Base)");
            end;
        }
        field(5110391; "POI Purch. Price (Price Base)"; Decimal)
        {
            AutoFormatType = 2;
            BlankZero = true;
            Caption = 'Purch. Price (Price Base)';

            trigger OnValidate()
            begin
                "POI Price Unit of Measure" := gcu_PurchMgt.PurchLineGetPriceUnit(Rec);
                VALIDATE("Direct Unit Cost", gcu_PurchMgt.PurchCalcUnitPrice(Rec, FALSE));

                // Aktualisierung Markteinkaufspreis
                IF (CurrFieldNo = FIELDNO("POI Purch. Price (Price Base)")) OR
                   (CurrFieldNo = FIELDNO("POI Price Base (Purch. Price)")) THEN
                    ADF_CalcMarketUnitPrice();
            end;
        }
        field(5110393; "POI Price Base (Sales Price)"; Code[10])
        {
            Caption = 'Price Base (Sales Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Sales Price"),
                                                     Blocked = CONST(false));

            trigger OnValidate()
            var
                lrc_SalesLine: Record "Sales Line";
            begin
                IF ("POI Price Base (Sales Price)" <> xRec."POI Price Base (Sales Price)") AND
                   (Type = Type::Item) AND
                   ("No." <> '') AND
                   ("POI Batch Variant No." <> '') THEN BEGIN
                    lrc_SalesLine.SETRANGE("POI Batch Variant No.", "POI Batch Variant No.");
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("No.", "No.");
                    IF NOT lrc_SalesLine.ISEMPTY() THEN
                        IF NOT CONFIRM('Die Änderung wird nicht in die bestehenden Verk.-Zeilen übertragen! Trotzdem ändern?') THEN
                            ERROR('')
                END;
            end;
        }
        field(5110394; "POI Sal Price(Price Base)(LCY)"; Decimal)
        {
            Caption = 'Sales Price (Price Base) (LCY)';
        }
        field(5110396; "POI Weight"; Option)
        {
            Caption = 'Weight';
            OptionCaption = ' ,Net Weight,Gross Weight';
            OptionMembers = " ","Net Weight","Gross Weight";

            trigger OnValidate()
            var
                lrc_PriceBase: Record "POI Price Base";
                lrc_UnitofMeasure: Record "Unit of Measure";
                lrc_ItemUnitOfMeasure: Record "Item Unit of Measure";
            begin
                // Prüfung ob Wiegen mit Wiegevorgabe aus Preisbasis kollidiert
                IF CurrFieldNo = FIELDNO("POI Weight") THEN
                    IF lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Purch. Price", "POI Price Base (Purch. Price)") THEN
                        IF (lrc_PriceBase.Weight <> lrc_PriceBase.Weight::" ") AND
                           ("POI Weight" <> lrc_PriceBase.Weight) THEN
                            // Eingabe Wiegen ist abweichend von Vorgabe aus Preisbasis!
                            ERROR(ADF_GT_TEXT035Txt);


                CASE "POI Weight" OF
                    // Kein Wiegen --> Gewichte aus Einheit oder Artikeleinheit
                    "POI Weight"::" ":
                        BEGIN
                            IF lrc_UnitofMeasure.GET("Unit of Measure Code") THEN BEGIN
                                "Gross Weight" := lrc_UnitofMeasure."POI Gross Weight";
                                "Net Weight" := lrc_UnitofMeasure."POI Net Weight";
                                IF lrc_ItemUnitOfMeasure.GET("No.", "Unit of Measure Code") THEN
                                    IF lrc_ItemUnitOfMeasure."POI Gross Weight" <> 0 THEN
                                        "Gross Weight" := lrc_ItemUnitOfMeasure."POI Gross Weight";
                                IF lrc_ItemUnitOfMeasure."POI Net Weight" <> 0 THEN
                                    "Net Weight" := lrc_ItemUnitOfMeasure."POI Net Weight";
                            END ELSE BEGIN
                                "Gross Weight" := 0;
                                "Net Weight" := 0;
                            END;
                            "POI Total Gross Weight" := Quantity * "Gross Weight";
                            "POI Total Net Weight" := Quantity * "Net Weight";
                        END;

                    //
                    "POI Weight"::"Net Weight", "POI Weight"::"Gross Weight":
                        BEGIN

                            IF "POI Weight" = xRec."POI Weight" THEN
                                EXIT;
                            TESTFIELD(Type, Type::Item);

                            // Prüfung ob Gewichtsvorgabe Null sein soll


                            IF lrc_UnitofMeasure.GET("Unit of Measure Code") THEN BEGIN
                                "Gross Weight" := lrc_UnitofMeasure."POI Gross Weight";
                                "Net Weight" := lrc_UnitofMeasure."POI Net Weight";
                                IF lrc_ItemUnitOfMeasure.GET("No.", "Unit of Measure Code") THEN
                                    IF lrc_ItemUnitOfMeasure."POI Gross Weight" <> 0 THEN BEGIN
                                        "Gross Weight" := lrc_ItemUnitOfMeasure."POI Gross Weight";
                                        IF lrc_ItemUnitOfMeasure."POI Net Weight" <> 0 THEN
                                            "Net Weight" := lrc_ItemUnitOfMeasure."POI Net Weight";
                                    END;
                            END ELSE BEGIN
                                "Gross Weight" := lrc_ItemUnitOfMeasure."POI Gross Weight";
                                "Net Weight" := lrc_ItemUnitOfMeasure."POI Net Weight";
                            END;
                            "POI Total Gross Weight" := Quantity * "Gross Weight";
                            "POI Total Net Weight" := Quantity * "Net Weight";

                        END;
                END;

                // Kontrolle ob eine Eink.-Auftragszeile mit der Verk.-Auftragszeile verbunden ist
                IF ("Sales Order No." <> '') AND
                   ("Sales Order Line No." <> 0) THEN
                    IF gbn_CalledChangefromSalesLine = FALSE THEN
                        gcu_AgencyBusinessMgt.ChangePurchaseLineWeight(Rec);

            end;
        }
        field(5110397; "POI Qty.(COU) p Pack. Unit(PU)"; Decimal)
        {
            Caption = 'Qty. (COU) per Pack. Unit (PU)';
        }
        field(5110400; "POI Inv.Disc.not Rela.to Goods"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Inv. Disc. not Relat. to Goods';
        }
        field(5110401; "POI Accr Inv. Disc. (External)"; Decimal)
        {
            Caption = 'Accruel Inv. Disc. (External)';
        }
        field(5110403; "POI Indirect Cost Amount (LCY)"; Decimal)
        {
            Caption = 'Indirect Cost Amount (LCY)';

            trigger OnValidate()
            begin
                TESTFIELD("No.");
                TestStatusOpen();

                IF Type = Type::"Charge (Item)" THEN
                    TESTFIELD("POI Indirect Cost Amount (LCY)", 0);

                IF (Type = Type::Item) AND ("Prod. Order No." = '') THEN BEGIN
                    GetItem();
                    IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                        ERROR(
                          Text010Txt,
                          FIELDCAPTION("Indirect Cost %"), Item.FIELDCAPTION("Costing Method"), Item."Costing Method");
                END;

                IF "POI Indirect Cost Amount (LCY)" <> 0 THEN
                    "Indirect Cost %" := ROUND("POI Indirect Cost Amount (LCY)" / "Direct Unit Cost" * 100, 0.00001)
                ELSE
                    "Indirect Cost %" := 0;


                UpdateUnitCost();

            end;
        }
        field(5110406; "POI Cost Calc. (UOM) (LCY)"; Decimal)
        {
            Caption = 'Cost Calc. (UOM) (LCY)';

            trigger OnValidate()
            begin
                grc_FruitVisionSetup.GET();
                CASE grc_FruitVisionSetup."Cost Category Calc. Type" OF
                    grc_FruitVisionSetup."Cost Category Calc. Type"::Standard:
                        ;
                    grc_FruitVisionSetup."Cost Category Calc. Type"::"Rekursiv von Zeile":
                        IF CurrFieldNo = FIELDNO("POI Cost Calc. (UOM) (LCY)") THEN BEGIN
                            IF Type <> Type::Item THEN
                                // Nur für Artikelzeilen zulässig!
                                ERROR(ADF_GT_TEXT007Txt);
                            "POI Cost Calc. Amount (LCY)" := "POI Cost Calc. (UOM) (LCY)" * Quantity;
                        END;
                END;
                UpdateUnitCost();
            end;
        }
        field(5110407; "POI Cost Calc. Amount (LCY)"; Decimal)
        {
            Caption = 'Cost Calc. Amount (LCY)';

            trigger OnValidate()
            begin
                grc_FruitVisionSetup.GET();
                CASE grc_FruitVisionSetup."Cost Category Calc. Type" OF
                    grc_FruitVisionSetup."Cost Category Calc. Type"::Standard:
                        ;
                    grc_FruitVisionSetup."Cost Category Calc. Type"::"Rekursiv von Zeile":
                        BEGIN
                            IF CurrFieldNo = FIELDNO("POI Cost Calc. Amount (LCY)") THEN
                                IF Type <> Type::Item THEN
                                    // Nur für Artikelzeilen zulässig!
                                    ERROR(ADF_GT_TEXT007Txt);
                            IF Quantity <> 0 THEN
                                "POI Cost Calc. (UOM) (LCY)" := "POI Cost Calc. Amount (LCY)" / Quantity
                            ELSE
                                "POI Cost Calc. (UOM) (LCY)" := 0;
                        END;
                END;
                UpdateUnitCost();
            end;
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

            trigger OnValidate()
            begin
                // Keine Änderung falls Lieferung bereits erfolgt
                IF CurrFieldNo = FIELDNO("POI Mark Unit Cost(Price Base)") THEN
                    IF "Quantity Received" <> 0 THEN
                        // Es sind bereits Mengen geliefert. Möchten Sie trotzdem ändern?
                        IF NOT CONFIRM(ADF_GT_TEXT020Txt) THEN
                            // Abbruch!
                            ERROR(ADF_GT_TEXT021Txt);


                // Umrechnen in die Basiseinheit über die Einkaufseinheit
                "POI Mark Unit Cost(Basis)(LCY)" := gcu_PurchMgt.PurchCalcUnitPrice(Rec, TRUE);
                IF "Qty. per Unit of Measure" <> 0 THEN
                    CASE "POI Weight" OF
                        "POI Weight"::" ":
                            "POI Mark Unit Cost(Basis)(LCY)" := "POI Mark Unit Cost(Basis)(LCY)" / "Qty. per Unit of Measure";
                        "POI Weight"::"Net Weight":
                            IF "Net Weight" <> 0 THEN
                                "POI Mark Unit Cost(Basis)(LCY)" := "POI Mark Unit Cost(Basis)(LCY)" / "Net Weight"
                            ELSE
                                "POI Mark Unit Cost(Basis)(LCY)" := 0;
                        "POI Weight"::"Gross Weight":
                            IF "Gross Weight" <> 0 THEN
                                "POI Mark Unit Cost(Basis)(LCY)" := "POI Mark Unit Cost(Basis)(LCY)" / "Gross Weight"
                            ELSE
                                "POI Mark Unit Cost(Basis)(LCY)" := 0;
                    END
                ELSE
                    "POI Mark Unit Cost(Basis)(LCY)" := "POI Mark Unit Cost(Basis)(LCY)";

                // Item Ledger Entry Einträge suchen
                IF "Quantity Received" <> 0 THEN BEGIN
                    lrc_ItemLedgerEntry.SETCURRENTKEY("Item No.", "Posting Date", "Entry Type", "POI Source Doc. Type", "Location Code", "Variant Code");
                    lrc_ItemLedgerEntry.SETRANGE("Entry Type", lrc_ItemLedgerEntry."Entry Type"::Purchase);
                    lrc_ItemLedgerEntry.SETRANGE("Item No.", "No.");
                    lrc_ItemLedgerEntry.SETRANGE("POI Source Doc. Type", lrc_ItemLedgerEntry."POI Source Doc. Type"::Order);
                    lrc_ItemLedgerEntry.SETRANGE("POI Source Doc. No.", "Document No.");
                    lrc_ItemLedgerEntry.SETRANGE("POI Source Doc. Line No.", "Line No.");
                    IF lrc_ItemLedgerEntry.FINDSET(TRUE, FALSE) THEN
                        REPEAT
                            lrc_ItemLedgerEntry."POI Market Purch. Price" := "POI Mark Unit Cost(Basis)(LCY)";
                            lrc_ItemLedgerEntry."POI Market Purch. Amount" := "POI Mark Unit Cost(Basis)(LCY)" *
                                                                          lrc_ItemLedgerEntry.Quantity;
                            lrc_ItemLedgerEntry.MODIFY();
                        UNTIL lrc_ItemLedgerEntry.NEXT() = 0
                    ELSE
                        // Artikelposten nicht gefunden!
                        ERROR(ADF_GT_TEXT022Txt);
                END;
            end;
        }
        field(5110410; "POI Empties Item No."; Code[20])
        {
            Caption = 'Empties Item No.';
            Description = 'LVW';
            TableRelation = IF (Type = CONST(Item)) Item WHERE("POI Item Typ" = FILTER("Empties Item" | "Transport Item"));

            trigger OnValidate()
            var
                lrc_Item: Record Item;
                lcu_EmptiesManagement: Codeunit "POI EIM Empties Item Mgt";
                lcu_UnitMgt: Codeunit "POI Unit Mgt";
                ldc_PalletFaktor: Decimal;
            begin
                TESTFIELD("Quantity Received", 0);

                IF ADF_CheckIfSalesOrderShip(FALSE, FALSE, TRUE, FALSE) = TRUE THEN
                    // Es bestehen bereits Verkaufslieferungen! Möchten Sie das Leergut trotzdem ändern?
                    IF NOT CONFIRM(ADF_GT_TEXT038Txt) THEN
                        ERROR('');

                IF "POI Empties Item No." = '' THEN
                    "POI Empties Quantity" := 0
                ELSE BEGIN
                    lrc_Item.GET("POI Empties Item No.");
                    "POI Empties Quantity" := lrc_Item."POI Empties Quantity";
                END;

                ADF_CalculateEmptiesRefund();

                IF ("POI Empties Item No." <> xRec."POI Empties Item No.") AND
                   (xRec."POI Empties Item No." <> '') THEN
                    lcu_EmptiesManagement.PurchDeleteEmptiesItemLines(Rec);

                // Prüfung auf Eintrag in Transporteinheit Faktor Tabelle
                IF lcu_UnitMgt.GetItemVendorUnitPalletFactor("No.",
                                                             1,
                                                             "Buy-from Vendor No.",
                                                             "Unit of Measure Code",
                                                             "Qty. per Unit of Measure",
                                                             "POI Empties Item No.",
                                                             "POI Transport Unit of Meas(TU)",
                                                             ldc_PalletFaktor) = TRUE THEN BEGIN
                    IF "POI Transport Unit of Meas(TU)" <> '' THEN
                        VALIDATE("POI Qty. (Unit) per Transp(TU)", ldc_PalletFaktor);
                    // Anzahl Transporteinheiten berechnen
                    IF "POI Qty. (Unit) per Transp(TU)" <> 0 THEN
                        "POI Quantity (TU)" := Quantity / "POI Qty. (Unit) per Transp(TU)"
                    ELSE
                        "POI Quantity (TU)" := 0;

                END;
            end;
        }
        field(5110411; "POI Empties Quantity"; Decimal)
        {
            Caption = 'Empties Quantity';
            Description = 'LVW';

            trigger OnValidate()
            var
                lcu_EmptiesMgt: Codeunit "POI EIM Empties Item Mgt";
            begin
                TESTFIELD("Quantity Received", 0);

                IF CurrFieldNo = FIELDNO("POI Empties Quantity") THEN
                    IF ADF_CheckIfSalesOrderShip(FALSE, FALSE, TRUE, FALSE) = TRUE THEN
                        // Es bestehen bereits Verkaufslieferungen! Möchten Sie das Leergut trotzdem ändern?
                        IF NOT CONFIRM(ADF_GT_TEXT038Txt) THEN
                            ERROR('');

                ADF_CalculateEmptiesRefund();

                IF ((("Document Type" = "Document Type"::Order) AND ("Document No." > '15-80039')) OR
                     (("Document Type" = "Document Type"::"Blanket Order") AND ("Document No." > '15-1728'))) THEN
                    IF "POI Empties Quantity" <> 0 THEN
                        IF "POI Empties Attached Line No" = 0 THEN BEGIN
                            PurchHeader.GET("Document Type", "Document No.");
                            //IF CONFIRM('Wollen Sie die zugehörige Leergutzeile einfügen', TRUE) THEN // Leergutzeile immer anlegen
                            lcu_EmptiesMgt.PurchAttachEmptiesToCurrLine(Rec, PurchHeader, "POI Empties Attached Line No");
                        END ELSE BEGIN
                            ;
                            lrc_EmptiesPurchLine.SETRANGE("Document Type", "Document Type");
                            lrc_EmptiesPurchLine.SETRANGE("Document No.", "Document No.");
                            lrc_EmptiesPurchLine.SETRANGE("Line No.", "POI Empties Attached Line No");
                            IF lrc_EmptiesPurchLine.FINDSET(TRUE, FALSE) THEN BEGIN
                                lrc_EmptiesPurchLine.VALIDATE(Quantity, Rec."POI Empties Quantity");
                                lrc_EmptiesPurchLine.MODIFY();
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
        field(5110414; "POI Empties Attached Line No"; Integer)
        {
            Caption = 'Empties Attached Line No';
            Description = 'LVW';
        }
        field(5110415; "POI Batch State"; Option)
        {
            Caption = 'Positionstatus';
            OptionCaption = ' ,Gesperrt';
            OptionMembers = " ",Blocked;

            trigger OnValidate()
            begin
                IF "POI Batch State" = "POI Batch State"::" " THEN BEGIN
                    IF lrc_BatchVariant.GET("POI Batch Variant No.") THEN BEGIN
                        lrc_BatchVariant.VALIDATE(State, lrc_BatchVariant.State::Open);
                        lrc_BatchVariant.MODIFY();
                        "POI Batch State" := "POI Batch State"::" ";
                    END;
                END ELSE
                    IF lrc_BatchVariant.GET("POI Batch Variant No.") THEN BEGIN
                        lrc_BatchVariant.VALIDATE(State, lrc_BatchVariant.State::"Manual Blocked");
                        lrc_BatchVariant.MODIFY();
                        "POI Batch State" := "POI Batch State"::Blocked;
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

                IF Quantity <> 0 THEN BEGIN
                    "Net Weight" := ROUND("POI Total Net Weight" / Quantity, 0.00001);
                    VALIDATE("POI Purch. Price (Price Base)");
                END ELSE
                    "Net Weight" := 0;
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

                IF Quantity <> 0 THEN BEGIN
                    "Gross Weight" := ROUND("POI Total Gross Weight" / Quantity, 0.00001);
                    VALIDATE("POI Purch. Price (Price Base)");
                END ELSe
                    "Gross Weight" := 0;
            end;
        }

        field(5110435; "POI Info 1"; Code[30])
        {
            //CaptionClass = '5110300,1,1';
            Caption = 'Info 1';
            Description = 'BSI';

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
                l_TXT_NotallowdTxt: Label ' ABCDEFGHIJKLMNOPQRSTUVWXYZŽ™šá.,&-+*%/$';
            begin
                ADF_AttributeFieldsValidate(FIELDNO("POI Info 1"));
                IF "POI Info 1" <> xRec."POI Info 1" THEN
                    lcu_PalletManagement.ActualFieldsFromPurchLine(copystr(FIELDCAPTION("POI Info 1"), 1, 100), Rec, xRec);

                IF STRPOS(UPPERCASE("POI Info 1"), 'GGN') <> 0 THEN
                    IF (STRLEN(DELCHR(COPYSTR("POI Info 1", STRPOS(UPPERCASE("POI Info 1"), 'GGN') + 3), '<>=', l_TXT_NotallowdTxt)) < 13) OR
                      (STRLEN(DELCHR(COPYSTR("POI Info 1", STRPOS(UPPERCASE("POI Info 1"), 'GGN') + 3), '<>=', l_TXT_NotallowdTxt)) > 13)
                    THEN
                        ERROR('Die GGN soll 13 Ziffern lang sein.');
            end;
        }
        field(5110436; "POI Info 2"; Code[50])
        {
            //CaptionClass = '5110300,1,2';
            Caption = 'Info 2';
            Description = 'BSI';

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                ADF_AttributeFieldsValidate(FIELDNO("POI Info 2"));
                IF "POI Info 2" <> xRec."POI Info 2" THEN
                    lcu_PalletManagement.ActualFieldsFromPurchLine(copystr(FIELDCAPTION("POI Info 2"), 1, 100), Rec, xRec)
            end;
        }
        field(5110437; "POI Info 3"; Code[20])
        {
            //CaptionClass = '5110300,1,3';
            Caption = 'Info 3';
            Description = 'BSI';

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                ADF_AttributeFieldsValidate(FIELDNO("POI Info 3"));
                IF "POI Info 3" <> xRec."POI Info 3" THEN
                    lcu_PalletManagement.ActualFieldsFromPurchLine(Copystr(FIELDCAPTION("POI Info 3"), 1, 100), Rec, xRec)
            end;
        }
        field(5110438; "POI Info 4"; Code[20])
        {
            //CaptionClass = '5110300,1,4';
            Caption = 'Info 4';
            Description = 'BSI';

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                ADF_AttributeFieldsValidate(FIELDNO("POI Info 4"));
                IF "POI Info 4" <> xRec."POI Info 4" THEN
                    lcu_PalletManagement.ActualFieldsFromPurchLine(copystr(FIELDCAPTION("POI Info 4"), 1, 100), Rec, xRec)

            end;
        }
        field(5110440; "POI Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            Description = 'EIA';
            TableRelation = "Country/Region" where("POI Relevant" = const(true));

            // trigger OnLookup()
            // begin
            //     ADF_FieldsLookUp(FIELDNO("POI Country of Origin Code"));
            // end;

            // trigger OnValidate()
            // begin
            //     ADF_AttributeFieldsValidate(FIELDNO("POI Country of Origin Code"));
            // end;
        }
        field(5110441; "POI Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            Description = 'EIA';
            TableRelation = "POI Variety";

            trigger OnLookup()
            var
                Variety: Record "POI Variety";
                VarietyPL: page "POI Variety";
                Filterstring: Text[250];
            begin
                Filterstring := GetAttributFilterstringForItem("No.", ItemAttribut."Attribute Type"::Variety);
                if Filterstring = '' then
                    Message('keine Sorten für den Artikel hinterlegt.')
                else begin
                    Variety.SetFilter(Code, Filterstring);
                    VarietyPL.SetTableView(Variety);
                    if VarietyPL.RunModal() = Action::OK then begin
                        VarietyPL.GetRecord(Variety);
                        "POI Variety Code" := Variety.Code;
                    end;
                end;
            end;

            // trigger OnLookup()
            // begin
            //     ADF_FieldsLookUp(FIELDNO("POI Variety Code"));
            // end;

            // trigger OnValidate()
            // begin
            //     ADF_AttributeFieldsValidate(FIELDNO("POI Variety Code"));
            // end;
        }
        field(5110442; "POI Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            Description = 'EIA';
            TableRelation = "POI Trademark";
            ValidateTableRelation = false;
            trigger OnLookup()
            var
                Trademark: Record "POI Trademark";
                TrademarkPL: page "POI Trademark";
                Filterstring: Text[250];
            begin
                Filterstring := GetAttributFilterstringForItem("No.", ItemAttribut."Attribute Type"::Trademark);
                if Filterstring = '' then
                    Message('keine Marken für den Artikel hinterlegt.')
                else begin
                    Trademark.SetFilter(Code, Filterstring);
                    TrademarkPL.SetTableView(Trademark);
                    if TrademarkPL.RunModal() = Action::OK then begin
                        TrademarkPL.GetRecord(Trademark);
                        "POI Trademark Code" := Trademark.Code;
                    end;
                end;
            end;
            // trigger OnLookup()
            // begin
            //     ADF_FieldsLookUp(FIELDNO("POI Trademark Code"));
            // end;

            // trigger OnValidate()
            // begin
            //     ADF_AttributeFieldsValidate(FIELDNO("POI Trademark Code"));
            // end;
        }
        field(5110443; "POI Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            Description = 'EIA';
            TableRelation = "POI Caliber";
            ValidateTableRelation = false;
            trigger OnLookup()
            var
                Caliber: Record "POI Caliber";
                CaliberPL: page "POI Caliber";
                Filterstring: Text[250];
            begin
                Filterstring := GetAttributFilterstringForItem("No.", ItemAttribut."Attribute Type"::Caliber);
                if Filterstring = '' then
                    Message('keine Kaliber für den Artikel hinterlegt.')
                else begin
                    Caliber.SetFilter(Code, Filterstring);
                    CaliberPL.SetTableView(Caliber);
                    if CaliberPL.RunModal() = Action::OK then begin
                        CaliberPL.GetRecord(Caliber);
                        "POI Caliber Code" := Caliber.Code;
                    end;
                end;
            end;
            // trigger OnLookup()
            // begin
            //     ADF_FieldsLookUp(FIELDNO("POI Caliber Code"));
            // end;

            // trigger OnValidate()
            // begin
            //     ADF_AttributeFieldsValidate(FIELDNO("POI Caliber Code"));
            // end;
        }
        field(5110444; "POI Vendor Caliber Code"; Code[10])
        {
            Caption = 'Vendor Caliber Code';
            Description = 'EIA';
            TableRelation = "POI Caliber - Vendor Caliber"."Vend. Caliber Code";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                ADF_AttributeFieldsValidate(FIELDNO("POI Vendor Caliber Code"));
            end;
        }
        field(5110445; "POI Item Attribute 3"; Code[10])
        {
            Caption = 'Quality Code';
            TableRelation = "POI Item Attribute 3";
            // trigger OnValidate()
            // begin
            //     ADF_AttributeFieldsValidate(FIELDNO("POI Item Attribute 3"));
            // end;
        }
        field(5110446; "POI Item Attribute 2"; Code[10])
        {
            Caption = 'Color Code';
            TableRelation = "POI Item Attribute 2";

            trigger OnLookup()
            var
                Color: Record "POI Item Attribute 2";
                ColorPL: Page "POI Color";
                Filterstring: Text[250];
            begin
                Filterstring := GetAttributFilterstringForItem("No.", ItemAttribut."Attribute Type"::Color);
                if Filterstring = '' then
                    Message('keine Farben für den Artikel hinterlegt.')
                else begin
                    Color.SetFilter(Code, Filterstring);
                    ColorPL.SetTableView(Color);
                    if ColorPL.RunModal() = Action::OK then begin
                        ColorPL.GetRecord(Color);
                        "POI Item Attribute 2" := Color.Code;
                    end;
                end;
            end;
            // trigger OnValidate()
            // begin
            //     ADF_AttributeFieldsValidate(FIELDNO("POI Item Attribute 2"));
            // end;
        }
        field(5110447; "POI Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            Description = 'EIA';
            TableRelation = "POI Grade of Goods";
            trigger OnLookup()
            var
                Quality: Record "POI Grade of Goods";
                QualityPL: page "POI Grade of Goods";
                Filterstring: Text[250];
            begin
                Filterstring := GetAttributFilterstringForItem("No.", ItemAttribut."Attribute Type"::"Grade of Goods");
                if Filterstring = '' then
                    Message('keine Handelsklassen für den Artikel hinterlegt.')
                else begin
                    Quality.SetFilter(Code, Filterstring);
                    QualityPL.SetTableView(Quality);
                    if QualityPL.RunModal() = Action::OK then begin
                        QualityPL.GetRecord(Quality);
                        "POI Grade of Goods Code" := Quality.Code;
                    end;
                end;
            end;

            // trigger OnValidate()
            // begin

            //     ADF_AttributeFieldsValidate(FIELDNO("POI Grade of Goods Code"));
            // end;
        }
        field(5110448; "POI Item Attribute 7"; Code[10])
        {
            Caption = 'Conservation Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 7";

            // trigger OnValidate()
            // begin
            //     ADF_AttributeFieldsValidate(FIELDNO("POI Item Attribute 7"));
            // end;
        }
        field(5110449; "POI Item Attribute 4"; Code[10])
        {
            Caption = 'Packing Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 4";

            trigger OnValidate()
            begin

                ADF_AttributeFieldsValidate(FIELDNO("POI Item Attribute 4"));
            end;
        }
        field(5110450; "POI Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            Description = 'EIA';
            TableRelation = "POI Coding";
            trigger OnLookup()
            var
                Coding: Record "POI Coding";
                CodingPL: page "POI Coding";
                Filterstring: Text[250];
            begin
                Filterstring := GetAttributFilterstringForItem("No.", ItemAttribut."Attribute Type"::Coding);
                if Filterstring = '' then
                    Message('keine Kodierung für den Artikel hinterlegt.')
                else begin
                    Coding.SetFilter(Code, Filterstring);
                    CodingPL.SetTableView(Coding);
                    if CodingPL.RunModal() = Action::OK then begin
                        CodingPL.GetRecord(Coding);
                        "POI Coding Code" := Coding.Code;
                    end;
                end;
            end;

            // trigger OnValidate()
            // begin
            //     ADF_AttributeFieldsValidate(FIELDNO("POI Coding Code"));
            // end;
        }
        field(5110451; "POI Item Attribute 5"; Code[10])
        {
            //CaptionClass = '5110310,1,5';
            Caption = 'Treatment Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 5";

            trigger OnValidate()
            begin

                ADF_AttributeFieldsValidate(FIELDNO("POI Item Attribute 5"));
            end;
        }
        field(5110452; "POI Item Attribute 6"; Code[20])
        {
            //CaptionClass = '5110310,1,6';
            Caption = 'Proper Name Code';
            Description = 'EIA';
            TableRelation = "POI Proper Name";

            trigger OnValidate()
            var
                lrc_ProperName: Record "POI Proper Name";
                lrc_EmptiesPurchLine: Record "Purchase Line";
            begin

                ADF_AttributeFieldsValidate(FIELDNO("POI Item Attribute 6"));
                IF lrc_ProperName.GET("POI Item Attribute 6") THEN
                    IF lrc_ProperName.Artikelnummer <> '' THEN BEGIN
                        "POI Empties Item No." := lrc_ProperName.Artikelnummer;
                        IF Quantity <> 0 THEN
                            VALIDATE("POI Empties Quantity", Quantity);
                    END ELSE
                        IF "POI Empties Attached Line No" <> 0 THEN BEGIN
                            MESSAGE('Die Leergutzeile wird gelöscht');
                            lrc_EmptiesPurchLine.GET("Document Type", "Document No.", "POI Empties Attached Line No");
                            lrc_EmptiesPurchLine.DELETE();
                            "POI Empties Attached Line No" := 0;
                        END;

                IF ((xRec."POI Item Attribute 6" <> '') AND (Rec."POI Item Attribute 6" = '') AND ("POI Empties Attached Line No" <> 0)) THEN BEGIN
                    MESSAGE('Die Leergutzeile wird gelöscht');
                    lrc_EmptiesPurchLine.GET("Document Type", "Document No.", "POI Empties Attached Line No");
                    lrc_EmptiesPurchLine.DELETE();
                    "POI Empties Attached Line No" := 0;
                END;

                //RS bei Interserohverpackung Plankostenzusatzmerkmal setzen
                IF lrc_ProperName.Interseroh THEN
                    "POI Zusatz" := lrc_ProperName.Code;

                //Bei Änderung Leergutartikelnummer Zeile löschen und neue Zeile anlegen
                IF ((xRec."POI Item Attribute 6" <> Rec."POI Item Attribute 6") AND
                  (Rec."POI Item Attribute 6" <> '') AND (xRec."POI Empties Attached Line No" <> 0)) THEN BEGIN
                    lrc_EmptiesPurchLine.GET("Document Type", "Document No.", "POI Empties Attached Line No");
                    lrc_EmptiesPurchLine.DELETE();
                    "POI Empties Attached Line No" := 0;
                    "POI Empties Item No." := '';
                    "POI Empties Quantity" := 0;
                    "POI Empties Refund Amount" := 0;
                    IF lrc_ProperName.GET("POI Item Attribute 6") THEN
                        IF lrc_ProperName.Artikelnummer <> '' THEN BEGIN
                            "POI Empties Item No." := lrc_ProperName.Artikelnummer;
                            IF Quantity <> 0 THEN
                                VALIDATE("POI Empties Quantity", Quantity);
                        END;
                END;
            end;
        }
        field(5110453; "POI Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            Description = 'EIA';
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;

            // trigger OnValidate()
            // begin

            //     ADF_AttributeFieldsValidate(FIELDNO("POI Cultivation Type"));
            // end;
        }
        field(5110454; "POI Cultivation Associat. Code"; Code[10])
        {
            Caption = 'Cultivation Association Code';
            Description = 'EIA';
            TableRelation = "POI Cultivation Association";

            // trigger OnValidate()
            // begin
            //     ADF_AttributeFieldsValidate(FIELDNO("POI Cultivation Associat. Code"));
            // end;
        }
        field(5110455; "POI Item Attribute 1"; Code[10])
        {
            //CaptionClass = '5110310,1,1';
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 1";

            // trigger OnValidate()
            // begin
            //     ADF_AttributeFieldsValidate(FIELDNO("POI Item Attribute 1"));
            // end;
        }
        field(5110460; "POI Date of Expiry"; Date)
        {
            Caption = 'Date of Expiry';

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF "POI Date of Expiry" <> xRec."POI Date of Expiry" THEN
                    lcu_PalletManagement.ActualFieldsFromPurchLine(copystr(FIELDCAPTION("POI Date of Expiry"), 1, 100), Rec, xRec)
            end;
        }
        field(5110464; "POI Item Charge Assignment"; Option)
        {
            Caption = 'Item Charge Assignment';
            Description = ' ,Eins zu Eins';
            OptionCaption = ' ,One to One';
            OptionMembers = " ","Eins zu Eins";
        }
        field(5110465; "POI Reference Doc. No."; Code[20])
        {
            Caption = 'Reference Doc. No.';
        }
        field(5110466; "POI Reference Doc. Line No."; Integer)
        {
            Caption = 'Reference Doc. Line No.';
        }
        field(5110467; "POI Reference Item No."; Code[20])
        {
            Caption = 'Reference Item No.';
            TableRelation = Item;
        }
        field(5110468; "POI Reference Doc. Type"; Option)
        {
            Caption = 'Reference Doc. Type';
            OptionCaption = ' ,Credit Memo,,,,,Purch. Receipt,Purch. Invoice';
            OptionMembers = " ","Credit Memo",,,,,"Purch. Receipt","Purch. Invoice";
        }
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

            trigger OnLookup()
            var
                lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
            begin
                IF lcu_GlobalFunctions.SelectDateByCalendar("POI Date of Discharge") THEN
                    VALIDATE("POI Date of Discharge");
            end;
        }
        field(5110482; "POI Time of Discharge"; Time)
        {
            Caption = 'Time of Discharge';
        }
        field(5110600; "POI Customs Weight (Average)"; Decimal)
        {
            Caption = 'Customs Weight (Average)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                ldc_DifferenceNetGrossWeight: Decimal;
            begin
                grc_FruitVisionSetup.GET();
                IF ("POI Customs Weight (Average)" <> xRec."POI Customs Weight (Average)") AND
                   ("POI Customs Weight (Average)" <> 0) THEN BEGIN

                    IF ("Gross Weight" <> 0) AND ("Gross Weight" <> 0) THEN
                        ldc_DifferenceNetGrossWeight := "Gross Weight" - "Net Weight";
                    VALIDATE("Net Weight", "POI Customs Weight (Average)");
                    IF grc_FruitVisionSetup."Internal Customer Code" <> 'INTERWEICHERT' THEN
                        VALIDATE("Gross Weight", "POI Customs Weight (Average)" + ldc_DifferenceNetGrossWeight);
                END ELSe
                    VALIDATE("Net Weight", "POI Customs Weight (Average)");
            end;
        }
        field(5110604; "POI Originally Qty (Order)"; Decimal)
        {
            Caption = 'Originally Qty (Order)';
        }
        field(5110605; "POI Member State Companionship"; Option)
        {
            Caption = 'Member State Companionship';
            OptionCaption = ' ,Ohne,,,Mitglied,Nicht Mitglied,,,Sonstiges';
            OptionMembers = " ",Ohne,,,Mitglied,"Nicht Mitglied",,,Sonstiges;
        }
        field(5110700; "POI B/L Shipper"; Code[20])
        {
            Caption = 'B/L Shipper';
            TableRelation = Vendor."No.";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                IF NOT gcu_BaseDataMgt.VendorValidate("POI B/L Shipper") THEN
                    ERROR(ADF_GT_TEXT024Txt, "POI B/L Shipper");
            end;
        }
        field(50550; "POI Line Amount (MW)"; Decimal)
        {
            Caption = 'Line Amount (MW)';
            DataClassification = CustomerContent;
        }
        field(50551; "POI Line Discount Amount (MW)"; Decimal)
        {
            Caption = 'Line Discount Amount (MW)';
            DataClassification = CustomerContent;
        }
        field(50400; "POI Inv.Disc.notRelat.toGoods"; Decimal)
        {
            Caption = 'Inv. Disc. not Relat. to Goods';
            DataClassification = CustomerContent;
        }
        field(50401; "POI Pallet number"; Decimal)
        {
            Caption = 'Palettenanzahl';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                POIFunction: Codeunit POIFunction;
            begin
                "POI Logistic Cost" := POIFunction.CalcFreightChargesPerLine("Document No.", "Line No.", 1) //TODO:Frachtkostenberechnung
            end;
        }
        field(50402; "POI Logistic Cost"; Decimal)
        {
            Caption = 'Transportkosten';
            DataClassification = CustomerContent;
        }
        field(50306; "POI Kind of Settlement"; Option)
        {
            OptionCaption = 'Fix Price(Invoice),Fix Price(Credit Memo),Commission';
            OptionMembers = "Fixed Price(Invoice)","Fix Price(Credit Memo)",Commission;
            DataClassification = CustomerContent;
        }
        field(50309; "POI Arrival Region"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "POI Departure Region".Code where(RegionType = const(Arrival));
        }
        field(50313; "POI Shipping agent"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Shipping Agent".Code;
        }
        field(50315; "POI Waste Disposal Duty"; Option)
        {
            OptionMembers = " ",DSD,ARA;
            OptionCaption = ',DSD,ARA';
            DataClassification = CustomerContent;
        }
        field(50316; "POI Waste Disposal Payment"; Option)
        {
            OptionMembers = "",Us,Vendor;
            OptionCaption = ',Us,Vendor';
            DataClassification = CustomerContent;
        }
        field(50317; "POI Waste Disp. Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Waste Disposal Amount (LCY)';
        }
        field(50319; "POI Cost Category"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cost Category';
            TableRelation = "POI Cost Category".Code where("Cost Global Source" = const(Purchase));
        }
        field(50320; "POI Item Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Standard,"Batch Item","Empties Item";
            OptionCaption = 'Standard,Batch Item,Empties Item';
        }
        // field(50000; "POI Lot No."; Code[20])
        // {
        //     DataClassification = CustomerContent;
        //     Caption = 'Lot No.';
        // }
        field(50384; "POI Transp. Unit of Measure"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Transportation Unit of Measure (TU)';
            TableRelation = "Unit of Measure".Code where("POI Is Transportation Unit" = const(true));
        }
        modify(Type)
        {
            trigger OnBeforeValidate()
            begin
                IF (xRec.Type = xRec.Type::Item) AND
                   ("POI Batch Variant No." <> '') AND
                   ("POI Batch Variant generated" = TRUE) THEN
                    // Pos.-Var. bereits generiert. Änderung nicht zulässig!
                    ERROR(ADF_GT_TEXT003Txt);

                //Kontrolle bei Änderung Type ob es eine verbundene Verkaufszeile gibt
                IF ("Drop Shipment" = FALSE) AND ("Sales Order No." <> '') AND ("Sales Order Line No." <> 0) THEN
                    IF (Type <> xRec.Type) AND (xRec.Type = xRec.Type::Item) THEN
                        ERROR(ADF_GT_TEXT002Txt);

                TempPurchLine := Rec;
            end;

            trigger OnAfterValidate()
            begin
                "POI Voyage No." := TempPurchLine."POI Voyage No.";
            end;
        }
        modify("No.")
        {
            trigger OnBeforeValidate()
            begin
                ADF_No_Validate();
                IF (Type = Type::Item) AND
                   ("POI Batch Variant No." <> '') AND
                   ("POI Batch Variant generated" = TRUE) THEN
                    // Pos.-Var. bereits generiert. Änderung nicht zulässig!
                    ERROR(ADF_GT_TEXT003Txt);
                // Kontrolle bei Änderung Artikelnummer ob es eine verbundene Verkaufszeile gibt
                IF (Type = Type::Item) AND
                   ("Drop Shipment" = FALSE) AND ("Sales Order No." <> '') AND ("Sales Order Line No." <> 0) THEN
                    IF ("No." <> xRec."No.") AND (xRec."No." <> '') THEN
                        // Änderung Artikelnr. nicht zulässig!
                        ERROR(ADF_GT_TEXT006Txt);
            end;

            trigger OnAfterValidate()
            var
                lrc_Vendor: Record Vendor;
                lrc_PurchDocSubtype: Record "POI Purch. Doc. Subtype";
                ItemCharge: Record "Item Charge";
                lrc_Item: Record Item;
                lrc_CostCategoryAccounts: Record "POI Cost Category Accounts";
                lcu_EmptiesItemMgt: Codeunit "POI EIM Empties Item Mgt";

            begin
                "POI Shortcut Dimension 3 Code" := PurchHeader."POI Shortcut Dimension 3 Code";
                "POI Shortcut Dimension 4 Code" := PurchHeader."POI Shortcut Dimension 4 Code";
                "POI Departure Date" := PurchHeader."POI Departure Date";
                //RS Transportmittelcode aus Kopf übernehmen
                "POI Means of Transp.Code (Arr)" := PurchHeader."POI Means of TransCode(Arriva)";

                case Type of
                    Type::Item:
                        begin
                            // Kontrolle ob Eingrenzung über Belegunterart
                            IF lrc_PurchDocSubtype.GET("Document Type", PurchHeader."POI Purch. Doc. Subtype Code") THEN
                                CASE lrc_PurchDocSubtype."Restriction Items" OF
                                    lrc_PurchDocSubtype."Restriction Items"::"Only Items Activ in Sales":
                                        IF NOT Item."POI Activ in Sales" THEN
                                            // Artikel ist nicht aktiv im Verkauf! Einkauf nicht zulässig.
                                            ERROR(ADF_GT_TEXT026Txt);
                                    lrc_PurchDocSubtype."Restriction Items"::"Only Items Activ in Purchase":
                                        IF NOT Item."POI Activ in Purchase" THEN
                                            // Artikel ist nicht aktiv im Einkauf! Einkauf nicht zulässig.
                                            ERROR(ADF_GT_TEXT029Txt);
                                    lrc_PurchDocSubtype."Restriction Items"::"Only Items Activ in Purchase and Sales":

                                        IF NOT Item."POI Activ in Sales" OR
                                           NOT Item."POI Activ in Purchase" THEN
                                            // Artikel ist nicht aktiv im Einkauf und Verkauf! Einkauf nicht zulässig.
                                            ERROR(ADF_GT_TEXT030Txt);
                                END;

                            IF lrc_Vendor.GET(PurchHeader."Buy-from Vendor No.") THEN
                                "POI B/L Shipper" := lrc_Vendor."POI B/L Shipper";
                            IF Item."POI Location Code" <> '' THEN
                                "Location Code" := Item."POI Location Code";
                            "POI Shelf No." := Item."Shelf No.";
                            "POI Base Unit of Measure (BU)" := Item."Base Unit of Measure";

                            "POI Item Typ" := Item."POI Item Typ";
                            "POI Batch Item" := Item."POI Batch Item";
                            IF Item."POI Countr of Ori Code (Fruit)" <> '' THEN
                                "POI Country of Origin Code" := Item."POI Countr of Ori Code (Fruit)"
                            ELSE
                                "POI Country of Origin Code" := PurchHeader."POI Country of Origin Code";
                            "POI Variety Code" := Item."POI Variety Code";
                            "POI Trademark Code" := Item."POI Trademark Code";
                            "POI Item Attribute 6" := Item."POI Item Attribute 6";
                            "POI Caliber Code" := Item."POI Caliber Code";
                            "POI Item Attribute 3" := Item."POI Item Attribute 3";
                            "POI Item Attribute 2" := Item."POI Item Attribute 2";
                            "POI Grade of Goods Code" := Item."POI Grade of Goods Code";
                            "POI Item Attribute 7" := Item."POI Item Attribute 7";
                            "POI Item Attribute 4" := Item."POI Item Attribute 4";
                            "POI Coding Code" := Item."POI Coding Code";
                            "POI Item Attribute 5" := Item."POI Item Attribute 5";

                            IF Item."POI Cultivation Type" <> Item."POI Cultivation Type"::" " THEN
                                "POI Cultivation Type" := Item."POI Cultivation Type"
                            ELSE
                                "POI Cultivation Type" := lrc_Vendor."POI Cultivation Type";
                            "POI Item Attribute 1" := Item."POI Item Attribute 1";

                            "POI Cultivation Associat. Code" := PurchHeader."POI Cultivation Associat. Code";
                            "POI Location Reference No." := PurchHeader."POI Location Reference No.";

                            "POI Weight" := Item."POI Weight";
                            "POI Price Base (Purch. Price)" := Item."POI Price Base (Purch. Price)";
                            "POI Price Base (Sales Price)" := Item."POI Price Base (Sales Price)";

                            "POI Manufacturer Code" := PurchHeader."POI Manufacturer Code";
                            "POI Lot No. Producer" := PurchHeader."POI Manufacturer Lot No.";

                            // Subtype setzen
                            CASE Item."POI Item Typ" OF
                                Item."POI Item Typ"::"Empties Item":
                                    "POI Subtyp" := "POI Subtyp"::"Refund Empties";
                                Item."POI Item Typ"::"Transport Item":
                                    "POI Subtyp" := "POI Subtyp"::"Refund Transport";
                            END;

                            IF ("POI Subtyp" = "POI Subtyp"::" ") AND (Type = Type::Item) THEN
                                IF Item."POI Empties Item No." <> '' THEN
                                    VALIDATE("POI Empties Item No.", Item."POI Empties Item No.")
                                ELSE BEGIN
                                    lcu_EmptiesItemMgt.PurchGetEmptiesItemData("No.", "Unit of Measure Code", "POI Empties Item No.", "POI Empties Quantity");
                                    VALIDATE("POI Empties Item No.");
                                END;
                        end;
                    Type::"Charge (Item)":
                        begin
                            ItemCharge.GET("No.");
                            "Allow Invoice Disc." := ItemCharge."POI Allow Invoice Disc.";
                            "POI Item Charge Assignment" := ItemCharge."POI Item Charge Assignment";
                        end;
                    Type::"G/L Account":
                        ADF_GetGLAccountTranslation();
                end;

                //Aktionen für Artikelzeilen in Bestellung
                IF ("Document Type" = "Document Type"::Order) AND (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                    // Pos.-Var. Nr. generieren
                    IF gbn_CalledFromInterface = FALSE THEN BEGIN
                        "POI Master Batch No." := PurchHeader."POI Master Batch No.";
                        IF "POI Batch Variant No." = '' THEN BEGIN
                            gcu_BatchMgt.BatchVarNewFromPurchLine(Rec, FALSE, "POI Batch No.", "POI Batch Variant No.");
                            IF "POI Batch Variant No." <> '' THEN BEGIN
                                TESTFIELD("POI Batch No.");
                                "POI Batch Variant generated" := TRUE;
                            END;
                        END;
                    END;

                    IF lrc_BatchVariant.GET("POI Batch Variant No.") THEn
                        IF lrc_Item.GET("No.") THEN
                            IF lrc_Item."POI First Batch State in Purch" <> lrc_Item."POI First Batch State in Purch"::" " THEN BEGIN
                                lrc_BatchVariant.VALIDATE(State, lrc_BatchVariant.State::"Manual Blocked");
                                lrc_BatchVariant.MODIFY();
                                "POI Batch State" := "POI Batch State"::Blocked;
                            END;

                    IF "POI Item Typ" = "POI Item Typ"::"Trade Item" THEN
                        IF ("POI Kind of Settlement" = "POI Kind of Settlement"::Commission) OR
                           ("POI Kind of Settlement" = "POI Kind of Settlement"::"Fixed Price(Invoice)") THEN
                            "POI Expected Purch. Price" := TRUE;
                END;

                IF "POI Batch No." <> '' THEN
                    VALIDATE("POI Batch No.");

                // Kontrolle, ob es nur eine Änderung in der Sachkontonummer gab,
                // dann Übernahme der Werte aus der vorherigen Eingabe
                // ACHTUNG muss hier kommen das die Standard Funktion CreateDim die Dimension sonst zurücksetzt !!!
                IF (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) AND
                   (PurchHeader."POI Purch. Doc. Subtype Detail" =
                    PurchHeader."POI Purch. Doc. Subtype Detail"::"Invoice of Expences") THEN
                    IF (CurrFieldNo = FIELDNO("No.")) AND
                       (Type = Type::"G/L Account") AND
                       (TempPurchLine.Type = Type) AND
                       (TempPurchLine."No." <> '') AND
                       (TempPurchLine."No." <> "No.") THEN BEGIN
                        VALIDATE(Quantity, TempPurchLine.Quantity);
                        VALIDATE("Direct Unit Cost", TempPurchLine."Direct Unit Cost");
                        VALIDATE("Shortcut Dimension 1 Code", TempPurchLine."Shortcut Dimension 1 Code");
                        VALIDATE("Shortcut Dimension 2 Code", TempPurchLine."Shortcut Dimension 2 Code");
                        VALIDATE("POI Shortcut Dimension 3 Code", TempPurchLine."POI Shortcut Dimension 3 Code");
                        VALIDATE("POI Shortcut Dimension 4 Code", TempPurchLine."POI Shortcut Dimension 4 Code");
                        // Kostenkategorie auch übernehmen --> Prüfung findet in CheckCostCategoryCode statt
                        "POI Cost Category Code" := TempPurchLine."POI Cost Category Code";
                    END ELSE
                        // Prüfung ob Kostenkategorie gültig - Auswahl einer gültigen Kostenkategorie
                        ADF_CheckCostCategoryCode();
                IF (Type = Type::"Charge (Item)") AND ("No." <> '') THEN
                    IF CurrFieldNo = FIELDNO("No.") THEN
                        VALIDATE(Quantity, 1);

                // Lagerortkombinationen für Pos.-Variante eintragen
                IF (Type = Type::Item) AND
                   ("POI Batch Variant No." <> '') AND
                   ("Location Code" <> '') THEN
                    gcu_StockMgt.BatchVarFillLocations("POI Batch Variant No.", "POI Batch No.", "No.", "Location Code");

                //RS Prüfung bei PIES ob Zielland im Kopf angegeben
                IF COMPANYNAME() = 'PI European Sourcing' THEN
                    IF (Type = Type::Item) AND ("Document Type" = "Document Type"::Order) THEN
                        IF PurchHeader.GET("Document Type", "Document No.") AND (PurchHeader."POI Destination Country Code" = '') THEN
                            ERROR('Sie müssen das Zielland der Ware im Einkaufskopf angeben bevor Sie Artikelzeilen anlegen können');

                //RS Prüfung Kostenkategorie Kostenart
                IF (("POI Cost Category Code" <> '') AND ("No." <> '') AND (Type = Type::"G/L Account")) THEN
                    IF ((lrc_CostCategoryAccounts.GET('', "POI Cost Category Code", "No.", 'KOSTEN', "POI Cost Category Code")) AND
                        (lrc_CostCategoryAccounts.Kostenart <> '')) THEN
                        VALIDATE("Shortcut Dimension 2 Code", lrc_CostCategoryAccounts.Kostenart);

                //Laden von Debitorengruppen spezifischen Anforderungen
                IF "POI Customer Group Code" <> '' THEN
                    VALIDATE("POI Customer Group Code", "POI Customer Group Code");
            end;
        }
        modify("Location Code")
        {
            trigger OnBeforeValidate()
            begin
                gcu_BDMBaseDataMgt.LocationValidateSearch("Location Code", TRUE);
                // Keine Änderung wenn Pos.-Var. und Verkaufslieferungen vorhanden
                TESTFIELD("Quantity Received", 0);
                IF ADF_CheckIfSalesOrderShip((CurrFieldNo <> 0), TRUE, TRUE, TRUE) = TRUE THEN
                    ERROR('');
            end;

            trigger OnAfterValidate()
            var
                Location: Record Location;
                GGNBatch: Record "POI GGN - Batch";
            begin
                IF Location.GET("Location Code") THEN
                    IF Location."POI Status Customs Duty" <> Location."POI Status Customs Duty"::" " THEN
                        "POI Status Customs Duty" := Location."POI Status Customs Duty";

                // Lagerortkombinationen für Pos.-Variante eintragen
                IF (Type = Type::Item) AND ("POI Batch Variant No." <> '') AND ("Location Code" <> '') THEN
                    gcu_StockMgt.BatchVarFillLocations("POI Batch Variant No.", "POI Batch No.", "No.", "Location Code");

                // Einstandspreis neu kalkulaieren
                UpdateUnitCost();

                //RS Test ob Land Lager mit Zielland
                IF (COMPANYNAME() = 'PI European Sourcing') OR (COMPANYNAME() = 'PI Fruit GmbH') THEN
                    IF Location.GET("Location Code") AND ("Document Type" = "Document Type"::Order) THEN
                        IF PurchHeader.GET("Document Type", "Document No.") AND
                           (PurchHeader."POI Destination Country Code" <> Location."Country/Region Code") THEN
                            ERROR('Das Zielland der Ware stimmt nicht mit dem Land des Lagers überein');


                //Leergutlager anpassen
                IF "POI Empties Attached Line No" <> 0 THEN BEGIN
                    lrc_EmptiesPurchLine.SETRANGE("Document Type", "Document Type");
                    lrc_EmptiesPurchLine.SETRANGE("Document No.", "Document No.");
                    lrc_EmptiesPurchLine.SETRANGE("Line No.", "POI Empties Attached Line No");
                    IF lrc_EmptiesPurchLine.FINDSET(TRUE, FALSE) THEN BEGIN
                        lrc_EmptiesPurchLine."Location Code" := Rec."Location Code";
                        lrc_EmptiesPurchLine.MODIFY();
                    END;
                END;
                //Prüfung auf QS-Kreditor
                IF ((PurchHeader."POI Quality Control Vendor No." = '') AND ("Location Code" <> '') AND ("Location Code" <> xRec."Location Code")) THEN BEGIN
                    Location.GET("Location Code");
                    IF Location."POI Quality Control Vendor No." <> '' THEN BEGIN
                        PurchHeader."POI Quality Control Vendor No." := Location."POI Quality Control Vendor No.";
                        PurchHeader.MODIFY();
                    END;
                END;

                //GGNBatch
                IF "POI Batch Variant No." <> '' THEN BEGIN
                    GGNBatch.RESET();
                    GGNBatch.SETRANGE("Batch No.", "POI Batch Variant No.");
                    GGNBatch.ModifyAll("Location Code", "Location Code", false);
                    //   IF GGNBatch.FINDSET() THEN
                    //     REPEAT
                    //       GGNBatch."Location Code" := "Location Code";
                    //       GGNBatch.MODIFY();
                    //     UNTIL GGNBatch.NEXT() = 0;
                END;
            end;
        }
        modify("Expected Receipt Date")
        {
            trigger OnAfterValidate()
            begin
                "POI ETA week" := DATE2DWY("Expected Receipt Date", 2);
                "POI ETA year" := DATE2DWY("Expected Receipt Date", 3);
            end;
        }
        modify(Quantity)
        {
            trigger OnBeforeValidate()
            var
                lc_POIPortPurch: Codeunit 60015;
            begin
                // Bestandsprüfung
                IF ("Document Type" = "Document Type"::Order) AND (Quantity < xRec.Quantity) AND ("POI Batch Variant No." <> '') THEN
                    lc_POIPortPurch.Bestandsprüfung(Rec);

                IF (Type = Type::Item) AND
                   ("No." <> '') AND
                   ("POI Batch Variant No." <> '') THEN
                    IF (gbn_CalledChangefromSalesLine = FALSE) AND ("Sales Order No." = '') AND ("Sales Order Line No." = 0) THEn
                        IF NOT gcu_BatchMgt.PurchCheckStockBatchVar(Rec) THEN
                            ERROR('');
            end;

            trigger OnAfterValidate()
            begin
                IF Type = Type::Item THEN BEGIN
                    IF Quantity <> 0 THEN
                        gcu_ItemAttributeMgt.PurchLineCheckOnPostPrint(Rec);
                    UpdateDirectUnitCost(FIELDNO(Quantity));
                END ELSE
                    VALIDATE("Line Discount %");

                ADF_SetQtyAssigned();

                IF CurrFieldNo <> FIELDNO("POI Qty. (Unit) per Transp(TU)") THEN
                    ADF_CalcQuantity(0);

                IF (Type = Type::Item) AND
                   ("POI Batch Variant No." <> '') AND
                   ("Location Code" <> '') THEN
                    gcu_StockMgt.BatchVarFillLocations("POI Batch Variant No.", "POI Batch No.", "No.", "Location Code");

                ADF_CalculateEmptiesRefund();
                // Summe Gewichte berechnen
                "POI Total Net Weight" := "Net Weight" * Quantity;
                "POI Total Gross Weight" := "Gross Weight" * Quantity;
                VALIDATE("POI Purch. Price (Price Base)");

                IF ((CurrFieldNo = FIELDNO(Quantity)) AND
                    ("POI Item Typ" = "POI Item Typ"::"Empties Item") AND
                    ("Attached to Line No." <> 0)) THEN
                    ERROR('Sie dürfen die Menge in der Leergutzeile nicht ändern. Bitte änderns sie die dazugehörige Artikelzeile');

                //Leergutmenge einpflegen
                IF "POI Empties Item No." <> '' THEN
                    VALIDATE("POI Empties Quantity", Quantity);

                //RS Prüfung ob verbundene Leergutzeile und ggf. Anpassung
                IF "POI Empties Attached Line No" <> 0 THEn
                    IF lrc_PurchLine.GET("Document Type", "Document No.", "POI Empties Attached Line No") THEN BEGIN
                        lrc_PurchLine.VALIDATE(Quantity, Quantity);
                        lrc_PurchLine.MODIFY();
                    END;


            end;
        }

        modify("Qty. to Invoice")
        {
            trigger OnAfterValidate()
            begin
                //RS Prüfung ob Änderung aus Leergutzeile erfolgt
                IF ((CurrFieldNo = FIELDNO("Qty. to Invoice")) AND
                    ("POI Item Typ" = "POI Item Typ"::"Empties Item") AND
                    ("Attached to Line No." <> 0)) THEN
                    //ERROR('Sie dürfen die Menge in der Leergutzeile nicht ändern. Bitte ändern sie die dazugehörige Artikelzeile');
                    IF NOT CONFIRM('Wollen Sie die Menge der Leergutzeile wirklich isoliert ändern und nicht die Artikelzeile?', FALSE) THEN
                        ERROR('Menge in der Leergutzeile nicht geändert. Bitte ändern sie die dazugehörige Artikelzeile');

                //RS Prüfung, ob verbundene Leergutzeile
                IF CurrFieldNo = FIELDNO("Qty. to Invoice") THEN
                    IF "POI Empties Attached Line No" <> 0 THEN
                        IF lrc_PurchLine.GET("Document Type", "Document No.", "POI Empties Attached Line No") THEN BEGIN
                            lrc_PurchLine.VALIDATE("Qty. to Invoice", "Qty. to Invoice");
                            lrc_PurchLine.MODIFY();
                        END;
            end;
        }
        modify("Qty. to Receive")
        {
            trigger OnAfterValidate()
            begin
                //RS Prüfung ob Änderung aus Leergutzeile erfolgt
                IF ((CurrFieldNo = FIELDNO("Qty. to Receive")) AND
                    ("POI Item Typ" = "POI Item Typ"::"Empties Item") AND
                    ("Attached to Line No." <> 0)) THEN
                    //ERROR('Sie dürfen die Menge in der Leergutzeile nicht ändern. Bitte ändern sie die dazugehörige Artikelzeile');
                    IF NOT CONFIRM('Wollen Sie die Menge der Leergutzeile wirklich isoliert ändern und nicht die Artikelzeile?', FALSE) THEN
                        ERROR('Menge in der Leergutzeile nicht geändert. Bitte ändern sie die dazugehörige Artikelzeile');

                //RS Prüfung, ob verbundene Leergutzeile
                IF CurrFieldNo = FIELDNO("Qty. to Receive") THEN
                    IF "POI Empties Attached Line No" <> 0 THEN
                        IF lrc_PurchLine.GET("Document Type", "Document No.", "POI Empties Attached Line No") THEN BEGIN
                            lrc_PurchLine.VALIDATE("Qty. to Receive", "Qty. to Receive");
                            lrc_PurchLine.MODIFY();
                        END;
            end;
        }
        modify("Gross Weight")
        {
            trigger OnAfterValidate()
            begin
                IF CurrFieldNo = FIELDNO("Gross Weight") THEN
                    IF "POI Weight" <> "POI Weight"::"Gross Weight" THEN
                        // Kein Artikel für Bruttowiegen!
                        ERROR(ADF_GT_TEXT037Txt);

                "POI Total Gross Weight" := Quantity * "Gross Weight";
                VALIDATE("POI Purch. Price (Price Base)");

                // Kontrolle ob eine Eink.-Auftragszeile mit der Verk.-Auftragszeile verbunden ist
                IF ("Sales Order No." <> '') AND ("Sales Order Line No." <> 0) THEN
                    IF gbn_CalledChangefromSalesLine = FALSE THEN
                        gcu_AgencyBusinessMgt.ChangePurchaseLineGrossWeight(Rec);
            end;
        }

        modify("Net Weight")
        {
            trigger OnAfterValidate()
            begin
                IF CurrFieldNo = FIELDNO("Net Weight") THEN
                    IF "POI Weight" <> "POI Weight"::"Net Weight" THEN
                        // Kein Artikel für Nettowiegen!
                        ERROR(ADF_GT_TEXT036Txt);

                "POI Total Net Weight" := Quantity * "Net Weight";
                VALIDATE("POI Purch. Price (Price Base)");

                // Kontrolle ob eine Eink.-Auftragszeile mit der Verk.-Auftragszeile verbunden ist
                IF ("Sales Order No." <> '') AND
                   ("Sales Order Line No." <> 0) THEN
                    IF gbn_CalledChangefromSalesLine = FALSE THEN
                        gcu_AgencyBusinessMgt.ChangePurchaseLineNetWeight(Rec);
            end;
        }
        modify("Indirect Cost %")
        {
            trigger OnBeforeValidate()
            begin
                IF CurrFieldNo = FIELDNO("Indirect Cost %") THEN
                    "POI Indirect Cost Amount (LCY)" := 0;
            end;
        }
        modify("Unit of Measure Code")
        {
            trigger OnBeforeValidate()
            begin
                gcu_BDMBaseDataMgt.UOMPurchLineValidateSearch(Rec, (CurrFieldNo = FIELDNO("Unit of Measure Code")), "Unit of Measure Code");
                IF ADF_CheckIfSalesOrderShip((CurrFieldNo <> 0), TRUE, TRUE, TRUE) THEN
                    ERROR('');
            end;

            trigger OnAfterValidate()
            var
                UnitOfMeasure: Record "Unit of Measure";
            begin
                IF "Unit of Measure Code" = '' THEN BEGIN
                    "Unit of Measure" := '';
                    "POI Packing Unit of Meas (PU)" := '';
                    "POI Qty. (PU) per Unit of Meas" := 0;
                    "POI Quantity (PU)" := 0;
                    "POI Content Unit of Meas (COU)" := '';
                    "POI Transport Unit of Meas(TU)" := '';
                    "POI Qty. (Unit) per Transp(TU)" := 0;
                    "POI Quantity (TU)" := 0;
                END ELSE BEGIN
                    UnitOfMeasure.GET("Unit of Measure Code");
                    "Unit of Measure" := UnitOfMeasure.Description;

                    // Kontrolle ob Einheit gesperrt ist und Werte setzen
                    IF (UnitOfMeasure."POI Blocked" = UnitOfMeasure."POI Blocked"::Purchase) OR (UnitOfMeasure."POI Blocked" = UnitOfMeasure."POI Blocked"::Total) THEN
                        ERROR(ADF_GT_TEXT004Txt);
                    IF UnitOfMeasure."POI Packing Unit of Meas (PU)" <> '' THEN BEGIN
                        "POI Packing Unit of Meas (PU)" := UnitOfMeasure."POI Packing Unit of Meas (PU)";
                        "POI Qty. (PU) per Unit of Meas" := UnitOfMeasure."POI Qty. (PU) per Unit of Meas";
                        "POI Quantity (PU)" := UnitOfMeasure."POI Qty. (PU) per Unit of Meas" * Quantity;
                    END ELSE BEGIN
                        "POI Packing Unit of Meas (PU)" := '';
                        "POI Qty. (PU) per Unit of Meas" := 0;
                        "POI Quantity (PU)" := 0;
                    END;
                    IF UnitOfMeasure."POI Transp. Unit of Meas (TU)" <> '' THEN BEGIN
                        VALIDATE("POI Transport Unit of Meas(TU)", UnitOfMeasure."POI Transp. Unit of Meas (TU)");
                        VALIDATE("POI Qty. (Unit) per Transp(TU)", UnitOfMeasure."POI Qty. per Transp. Unit (TU)");
                        IF "POI Qty. (Unit) per Transp(TU)" <> 0 THEN
                            "POI Quantity (TU)" := Quantity / "POI Qty. (Unit) per Transp(TU)";
                    END ELSE BEGIN
                        "POI Transport Unit of Meas(TU)" := '';
                        "POI Qty. (Unit) per Transp(TU)" := 0;
                        "POI Quantity (TU)" := 0;
                    END;
                end;

                IF "Prod. Order No." = '' THEN BEGIN
                    IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                        IF "Gross Weight" = 0 THEN
                            VALIDATE("Gross Weight", UnitOfMeasure."POI Gross Weight");
                        IF "Net Weight" = 0 THEN
                            VALIDATE("Net Weight", UnitOfMeasure."POI Net Weight");
                    END ELSE
                        "Qty. per Unit of Measure" := 1;
                END ELSE
                    "Qty. per Unit of Measure" := 0;
            end;
        }
    }

    procedure ADF_CheckIfSalesOrderShip(vbn_Dialog: Boolean; vbn_CheckOrder: Boolean; vbn_CheckShip: Boolean; vbn_CheckInv: Boolean): Boolean
    var
        lrc_TransferLine: Record "Transfer Line";
        lrc_TransferShipmentLine: Record "Transfer Shipment Line";
        lrc_TransferReceiptLine: Record "Transfer Receipt Line";
        lrc_PackOrderInputLine: Record "POI Pack. Order Input Items";
        LT_TEXT_PackTxt: Label 'Die Ware ist bereits als Inputzeile in Packaufträgen! Änderung nicht zulässig!';
        ADF_LT_TEXT001Txt: Label 'Es bestehen bereits Verkaufsaufträge! Änderung nicht zulässig!';
        ADF_LT_TEXT002Txt: Label 'Es bestehen bereits Verkaufslieferungen! Änderung nicht zulässig!';
        ADF_LT_TEXT003Txt: Label 'Es bestehen bereits Verkaufsrechnungen! Änderung nicht zulässig!';
        L_Text_TransferTxt: Label 'Es bestehen bereits Umlagerungen! Änderung nicht zulässig!';
    begin
        // -------------------------------------------------------------------------------------------
        // Prüfung ob Verkaufsauftrag, Verkaufslieferung oder Verkaufsrechnung //RS Umlagerung, Packauftrag
        // -------------------------------------------------------------------------------------------


        IF ("Document Type" = "Document Type"::Order) AND
           (Type = Type::Item) AND
           ("No." <> '') AND
           ("POI Batch Variant No." <> '') THEN BEGIN

            TESTFIELD("Quantity Received", 0);

            lrc_BatchVariant.GET("POI Batch Variant No.");

            IF vbn_CheckOrder = TRUE THEN BEGIN
                lrc_BatchVariant.CALCFIELDS("B.V. Sales Order (Qty)");
                IF lrc_BatchVariant."B.V. Sales Order (Qty)" <> 0 THEN BEGIN
                    IF vbn_Dialog = TRUE THEN
                        // Es bestehen bereits Verkaufsaufträge! Änderung nicht zulässig!
                        ERROR(ADF_LT_TEXT001Txt);
                    EXIT(TRUE);
                END;
            END;

            IF vbn_CheckShip = TRUE THEN BEGIN
                lrc_BatchVariant.CALCFIELDS("B.V. Sales Shipped (Qty)");
                IF lrc_BatchVariant."B.V. Sales Shipped (Qty)" <> 0 THEN BEGIN
                    IF vbn_Dialog = TRUE THEN
                        // Es bestehen bereits Verkaufslieferungen! Änderung nicht zulässig!
                        ERROR(ADF_LT_TEXT002Txt);
                    EXIT(TRUE);
                END;
            END;

            IF vbn_CheckInv = TRUE THEN BEGIN
                lrc_BatchVariant.CALCFIELDS("B.V. Sales Inv. (Qty.)");
                IF lrc_BatchVariant."B.V. Sales Inv. (Qty.)" <> 0 THEN BEGIN
                    IF vbn_Dialog = TRUE THEN
                        // Es bestehen bereits Verkaufsrechnungen! Änderung nicht zulässig!
                        ERROR(ADF_LT_TEXT003Txt);
                    EXIT(TRUE);
                END;
            END;

            //Abfrage, ob Ware bereits in Umlagerungsaufträgen
            lrc_TransferLine.RESET();
            lrc_TransferLine.SETCURRENTKEY("POI Batch Variant No.", "Item No.", "Derived From Line No.");
            lrc_TransferLine.SETRANGE("POI Batch Variant No.", "POI Batch Variant No.");
            //IF lrc_TransferLine.FIND('-') THEN
            if not lrc_TransferLine.IsEmpty() then
                ERROR(L_Text_TransferTxt);

            lrc_TransferShipmentLine.RESET();
            lrc_TransferShipmentLine.SETCURRENTKEY("POI Batch Variant No.", "Item No.");
            lrc_TransferShipmentLine.SETRANGE("POI Batch Variant No.", "POI Batch Variant No.");
            //IF lrc_TransferShipmentLine.FIND('-') THEN
            IF not lrc_TransferShipmentLine.IsEmpty() THEN
                ERROR(L_Text_TransferTxt);

            lrc_TransferReceiptLine.RESET();
            lrc_TransferReceiptLine.SETCURRENTKEY("POI Batch Variant No.", "Item No.");
            lrc_TransferReceiptLine.SETRANGE("POI Batch Variant No.", "POI Batch Variant No.");
            //IF lrc_TransferReceiptLine.FIND('-') THEN
            IF not lrc_TransferReceiptLine.IsEmpty() THEN
                ERROR(L_Text_TransferTxt);

            //Abfrage, ob Ware bereits in Packauftrags-Inputzeilen
            lrc_PackOrderInputLine.RESET();
            lrc_PackOrderInputLine.SETCURRENTKEY("Batch Variant No.");
            lrc_PackOrderInputLine.SETRANGE("Batch Variant No.", "POI Batch Variant No.");
            //IF lrc_PackOrderInputLine.FINDSET(FALSE, FALSE) THEN
            IF not lrc_PackOrderInputLine.IsEmpty() THEN
                ERROR(LT_TEXT_PackTxt);
        END;

        EXIT(FALSE);
    end;

    procedure ADF_CalculateEmptiesRefund()
    var
        lrc_PurchaseHeader: Record "Purchase Header";
        lrc_RefundCosts: Record "POI Empties/Transport Ref Cost";
        lcu_EmptiesManagement: Codeunit "POI EIM Empties Item Mgt";
        ldt_Date: Date;
    begin
        // ---------------------------------------------------------------------------------------------------------
        // Funktion zur Berechnung der Leergut-Pfandkosten
        // ---------------------------------------------------------------------------------------------------------

        lrc_PurchaseHeader.GET("Document Type", "Document No.");
        ldt_Date := lrc_PurchaseHeader."Order Date";
        IF ldt_Date = 0D THEN
            ldt_Date := lrc_PurchaseHeader."Document Date";
        IF ldt_Date = 0D THEN
            ldt_Date := TODAY();

        CASE PurchHeader."Document Type" OF
            PurchHeader."Document Type"::"Credit Memo", PurchHeader."Document Type"::"Return Order":
                lcu_EmptiesManagement.CalculateEmptiesReceiptPrice(Rec."POI Empties Item No.",
                                                                   lrc_RefundCosts."Source Type"::Vendor,
                                                                   lrc_PurchaseHeader."Buy-from Vendor No.",
                                                                   Rec."Location Code",
                                                                   ldt_Date,
                                                                   Rec.Quantity,
                                                                   "POI Empties Quantity",
                                                                   Rec."Document Type",
                                                                   Rec."Document No.",
                                                                   Rec."Line No.",
                                                                   Rec."POI Empties Refund Amount");

            PurchHeader."Document Type"::Quote, PurchHeader."Document Type"::Order,
        PurchHeader."Document Type"::Invoice, PurchHeader."Document Type"::"Blanket Order":
                lcu_EmptiesManagement.CalculateEmptiesShipmentPrice(Rec."POI Empties Item No.",
                                                                    lrc_RefundCosts."Source Type"::Vendor,
                                                                    lrc_PurchaseHeader."Buy-from Vendor No.",
                                                                    Rec."Location Code",
                                                                    ldt_Date,
                                                                    Rec.Quantity,
                                                                    "POI Empties Quantity",
                                                                    Rec."POI Empties Refund Amount");
        END;
    end;

    procedure ADF_CalcQuantity(vin_CurrFieldNo: Integer)
    begin
        // --------------------------------------------------------------------------------------
        // Funktion zur Berechnung der Mengen
        // --------------------------------------------------------------------------------------

        CASE vin_CurrFieldNo OF

            // -----------------------------------------------------------
            // Eingabe Menge Paletten
            // -----------------------------------------------------------
            FIELDNO("POI Quantity (TU)"):
                BEGIN
                    TESTFIELD("POI Qty. (Unit) per Transp(TU)");
                    // Menge Kolli berechnen
                    VALIDATE(Quantity, ("POI Quantity (TU)" * "POI Qty. (Unit) per Transp(TU)"));
                END;

            // -----------------------------------------------------------
            // Eingabe Menge Verpackungen
            // -----------------------------------------------------------
            FIELDNO("POI Quantity (PU)"):
                BEGIN
                    TESTFIELD("POI Qty. (PU) per Unit of Meas");
                    // Menge Kolli berechnen
                    VALIDATE(Quantity, ("POI Quantity (PU)" / "POI Qty. (PU) per Unit of Meas"));
                END;

            // -----------------------------------------------------------
            // Eingabe Menge Verpackungen pro Einheit
            // -----------------------------------------------------------
            FIELDNO("POI Qty. (PU) per Unit of Meas"):
                // Menge neu validieren
                VALIDATE(Quantity);

            // -----------------------------------------------------------
            // Eingabe Menge Einheiten pro Transporteinheit
            // -----------------------------------------------------------
            FIELDNO("POI Qty. (Unit) per Transp(TU)"):
                // Menge neu validieren
                VALIDATE(Quantity);

        END;

        // -----------------------------------------------------------
        // Menge eingegeben - geändert
        // -----------------------------------------------------------

        // Menge Verpackungen
        "POI Quantity (PU)" := Quantity * "POI Qty. (PU) per Unit of Meas";

        // Menge Paletten berechnen
        IF "POI Qty. (Unit) per Transp(TU)" <> 0 THEN
            "POI Quantity (TU)" := Quantity / "POI Qty. (Unit) per Transp(TU)"
        ELSE
            "POI Quantity (TU)" := 0;
    end;

    procedure ADF_AttributeFieldsValidate(vin_FieldNo: Integer)
    var
        //lrc_BatchVariant: Record "POI Batch Variant";
        //lrc_Trademark: Record "POI Trademark";
        lrc_Item: Record Item;
        //lrc_BatchInfoDetails: Record "POI Batch Info Details";
        //lcu_ExtendedDimensionMgt: Codeunit "5087916";
        //ADF_LT_TEXT001Txt: Label 'Quantity shipped exist ! Change not possible !';
        //ADF_LT_TEXT002Txt: Label 'Abbruch!';
        ADF_LT_TEXT003Txt: Label 'Sortencode ist abweichend vom Artikelstamm!';
    begin
        // -----------------------------------------------------------------------------------------------------
        // Funktion zur Validierung von Eingaben
        // -----------------------------------------------------------------------------------------------------

        // Keine Änderung wenn Eink.-Lieferung oder Verk.-Lieferungen auf Pos.-Var
        IF CurrFieldNo <> 0 THEN
            //  ADF_CheckIfSalesOrderShip(TRUE,FALSE,TRUE,TRUE); --RS alle Paramter auf TRUE gesetzt
            ADF_CheckIfSalesOrderShip(TRUE, TRUE, TRUE, TRUE);

        CASE vin_FieldNo OF
            // -----------------------------------------------------------------------------------------
            // Sorte
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Variety Code"):
                BEGIN
                    IF lrc_Item.GET("No.") THEN
                        IF lrc_Item."POI Variety Code" <> '' THEN
                            IF "POI Variety Code" <> lrc_Item."POI Variety Code" THEN
                                // Sortencode ist abweichend vom Artikelstamm!
                                ERROR(ADF_LT_TEXT003Txt);
                    gcu_BDMBaseDataMgt.VarietyValidateSearch("POI Variety Code", "POI Product Group Code", (CurrFieldNo = FIELDNO("POI Variety Code")));
                END;

            // -----------------------------------------------------------------------------------------
            // Erzeugerland
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Country of Origin Code"):
                // IF CurrFieldNo = FIELDNO("POI Country of Origin Code") THEN
                //     gcu_ItemAttributeMgt.PurchLineCheckOnValidate(Rec, xRec, FIELDNO("POI Country of Origin Code"));

                gcu_BDMBaseDataMgt.CountryValidateSearch("POI Country of Origin Code", "POI Product Group Code", (CurrFieldNo = FIELDNO("POI Country of Origin Code")));
            // -----------------------------------------------------------------------------------------
            // Kaliber
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Caliber Code"):
                gcu_BDMBaseDataMgt.CaliberValidateSearch("POI Caliber Code", "POI Product Group Code",
                                                             (CurrFieldNo = FIELDNO("POI Caliber Code")));
            // -----------------------------------------------------------------------------------------
            // Kreditorenkaliber
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Vendor Caliber Code"):
                IF "POI Vendor Caliber Code" <> '' THEN
                    VALIDATE("POI Caliber Code", (gcu_BaseDataMgt.VendorCaliberInCaliber("Buy-from Vendor No.", "POI Vendor Caliber Code", "POI Product Group Code", "POI Variety Code")));
            // -----------------------------------------------------------------------------------------
            // Marke
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Trademark Code"):
                IF "POI Trademark Code" <> '' THEN BEGIN
                    gcu_BDMBaseDataMgt.TrademarkValidateSearch("POI Trademark Code", (CurrFieldNo = FIELDNO("POI Trademark Code")));
                    gcu_BDMBaseDataMgt.AttributeTrademarkValidate("POI Trademark Code", "POI Product Group Code");
                END;
            // -----------------------------------------------------------------------------------------
            // Farbe
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Item Attribute 2"):
                ;
            // -----------------------------------------------------------------------------------------
            // Handelsklasse
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Grade of Goods Code"):
                ;
            // -----------------------------------------------------------------------------------------
            // Konservierung
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Item Attribute 7"):
                ;
            // -----------------------------------------------------------------------------------------
            // Abpackung
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Item Attribute 4"):
                ;
            //-----------------------------------------------------------------------------------------
            // Kodierung
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Coding Code"):
                ;
            // -----------------------------------------------------------------------------------------
            // Aufbereitung
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Item Attribute 5"):
                ;
            // -----------------------------------------------------------------------------------------
            // Eigenname
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Item Attribute 6"):
                ;
            // -----------------------------------------------------------------------------------------
            // Anbauart
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Cultivation Type"):
                ;
            // -----------------------------------------------------------------------------------------
            // Anbauverfahren
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Item Attribute 1"):
                ;
            // -----------------------------------------------------------------------------------------
            // Anbauverband
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Cultivation Associat. Code"):
                ;
            // -----------------------------------------------------------------------------------------
            // Infofeld 1
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Info 1"):
                IF (Type = Type::Item) AND
                   ("POI Batch No." <> '') THEN
                    gcu_BatchMgt.UpdBatchSourceInfo("POI Batch No.", "POI Batch Variant No.", 0, 2, "POI Info 1");
            // -----------------------------------------------------------------------------------------
            // Infofeld 2
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Info 2"):

                IF (Type = Type::Item) AND ("POI Batch No." <> '') THEn
                    gcu_BatchMgt.UpdBatchSourceInfo("POI Batch No.", "POI Batch Variant No.", 1, 2, "POI Info 2");
            // -----------------------------------------------------------------------------------------
            // Infofeld 3
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Info 3"):

                IF (Type = Type::Item) AND ("POI Batch No." <> '') THEN
                    gcu_BatchMgt.UpdBatchSourceInfo("POI Batch No.", "POI Batch Variant No.", 2, 2, "POI Info 3");
            // -----------------------------------------------------------------------------------------
            // Infofeld 4
            // -----------------------------------------------------------------------------------------
            FIELDNO("POI Info 4"):
                IF (Type = Type::Item) AND
                   ("POI Batch No." <> '') THEN
                    gcu_BatchMgt.UpdBatchSourceInfo("POI Batch No.", "POI Batch Variant No.", 3, 2, "POI Info 4");
        END;
    end;

    procedure ADF_FieldsLookUp(vin_FieldNo: Integer)
    var
        lco_ReturnCode: Code[10];
    begin
        // -----------------------------------------------------------------
        // Allgemeine Funktion für Lookup
        // -----------------------------------------------------------------

        CASE vin_FieldNo OF
            FIELDNO("POI Variety Code"):
                BEGIN
                    lco_ReturnCode := "POI Variety Code";
                    IF gcu_BDMBaseDataMgt.VarietyLookUp(lco_ReturnCode, "POI Product Group Code") = TRUE THEN
                        VALIDATE("POI Variety Code", lco_ReturnCode);
                END;

            FIELDNO("POI Country of Origin Code"):
                BEGIN
                    lco_ReturnCode := gcu_BaseDataMgt.CountryLookUp("POI Product Group Code");
                    IF (lco_ReturnCode <> '') THEN
                        VALIDATE("POI Country of Origin Code", lco_ReturnCode);
                END;

            FIELDNO("POI Caliber Code"):
                IF gcu_BDMBaseDataMgt.CaliberLookUp(lco_ReturnCode, "POI Product Group Code") = TRUE THEN
                    VALIDATE("POI Caliber Code", lco_ReturnCode);


            FIELDNO("POI Trademark Code"):
                IF gcu_BDMBaseDataMgt.TrademarkLookup("POI Trademark Code", "POI Product Group Code") THEN
                    VALIDATE("POI Trademark Code", "POI Trademark Code");
        END;
    end;

    procedure ADF_CalcMarketUnitPrice()
    begin
        // --------------------------------------------------------------------------------------
        // Funktion zur Berechnung des Markteinkaufspreises
        // --------------------------------------------------------------------------------------

        // Keine Änderung falls Lieferung bereits erfolgt
        IF "Quantity Received" <> 0 THEN
            EXIT;

        grc_FruitVisionSetup.GET();
        IF grc_FruitVisionSetup."Market Unit Price activ" = TRUE THEN
            CASE grc_FruitVisionSetup."Calc Market Unit Price" OF
                grc_FruitVisionSetup."Calc Market Unit Price"::"Immer bei Preisänderung":
                    VALIDATE("POI Mark Unit Cost(Price Base)", "POI Purch. Price (Price Base)");
                grc_FruitVisionSetup."Calc Market Unit Price"::"Nur wenn Markteinkaufspreis Null":
                    IF ("POI Mark Unit Cost(Price Base)" = 0) THEN
                        VALIDATE("POI Mark Unit Cost(Price Base)", "POI Purch. Price (Price Base)");
            END;
    end;

    local procedure GetItem()
    begin
        TESTFIELD("No.");
        IF Item."No." <> "No." THEN
            Item.GET("No.");
    end;

    procedure ADF_CheckCostCategoryCode()
    var
        lrc_PurchHeader: Record "Purchase Header";
        lfm_CostCategoryAccounts: Page "POI Cost Category Accounts";
        AGILES_LT_TEXT001Txt: Label 'Eingabe Kostenkategorie nur für Sachkonten zulässig!';
        AGILES_LT_TEXT002Txt: Label 'Kostenkategorie %1 für Sachkonto %2 nicht zugelassen!', Comment = '%1 %2';
        AGILES_LT_TEXT003Txt: Label 'Keine Kontenzuordnung für Kostenkategorie %1 vorhanden!', Comment = '%1';
    //AGILES_LT_TEXT004Txt: Label 'Es sind keine Kostenkategorien für das Konto vorhanden!';
    begin
        // -----------------------------------------------------------------
        // Funktion zur Validierung der Kostenkategorie
        // -----------------------------------------------------------------

        IF NOT ("Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) THEN
            EXIT;

        lrc_PurchHeader.GET("Document Type", "Document No.");

        grc_FruitVisionSetup.GET();

        // -------------------------------------------------------------------------------------------------------------
        // Prüfung bei Eingabe der Kostenkategorie
        // -------------------------------------------------------------------------------------------------------------
        IF (gbn_CalledFromInterface = FALSE) AND
           (CurrFieldNo = FIELDNO("POI Cost Category Code")) THEN BEGIN

            // Kostenkategorien nur für Sachkontenzeilen
            IF ("POI Cost Category Code" <> '') AND
               (Type <> Type::"G/L Account") AND
               ("No." <> '') THEN
                // Eingabe Kostenkategorie nur für Sachkonten zulässig!
                ERROR(AGILES_LT_TEXT001Txt);

            // Typ auf Sachkonto setzen
            IF ("POI Cost Category Code" <> '') AND
               ("No." = '') AND
               (Type <> Type::"G/L Account") THEN
                VALIDATE(Type, Type::"G/L Account");


            // Prüfung ob Sachkontonr. zur Kostenkategorie passt
            IF ("POI Cost Category Code" <> '') AND
               ("No." <> '') AND
               (Type = Type::"G/L Account") THEN BEGIN

                lrc_CostCategoryAccounts.RESET();
                lrc_CostCategoryAccounts.SETRANGE("Cost Schema Code", '');
                lrc_CostCategoryAccounts.SETRANGE("Cost Category Code", "POI Cost Category Code");
                lrc_CostCategoryAccounts.SETRANGE("G/L Account No.", "No.");
                lrc_CostCategoryAccounts.SETRANGE(blocked, FALSE);
                IF NOT lrc_CostCategoryAccounts.FIND('-') THEN
                    // Kostenkategorie %1 für Sachkonto %2 nicht zugelassen!
                    ERROR(AGILES_LT_TEXT002Txt, "POI Cost Category Code", "No.");

            END ELSE

                IF ("POI Cost Category Code" <> '') AND ("No." = '') AND (Type = Type::"G/L Account") THEN
                    IF (grc_FruitVisionSetup."Purch. Inv. Load Cost Category" =
                        grc_FruitVisionSetup."Purch. Inv. Load Cost Category"::"Cost Cat. - Show G/L Account") OR
                       (grc_FruitVisionSetup."Purch. Inv. Load Cost Category" =
                        grc_FruitVisionSetup."Purch. Inv. Load Cost Category"::Both) OR
                       (grc_FruitVisionSetup."Purch. Inv. Load Cost Category" =
                        grc_FruitVisionSetup."Purch. Inv. Load Cost Category"::"Cost Cat - Show allways G/L Accounts") THEN BEGIN

                        lrc_PurchHeader.GET("Document Type", "Document No.");

                        lrc_CostCategoryAccounts.RESET();
                        lrc_CostCategoryAccounts.FILTERGROUP(2);
                        lrc_CostCategoryAccounts.SETRANGE("Cost Schema Code", '');
                        lrc_CostCategoryAccounts.SETRANGE("Cost Category Code", "POI Cost Category Code");
                        lrc_CostCategoryAccounts.SETRANGE(blocked, FALSE);
                        lrc_CostCategoryAccounts.FILTERGROUP(0);

                        // Ohne Zuordnung durch das Programm - Kontowahl immer durch den Benutzer
                        IF (grc_FruitVisionSetup."Purch. Inv. Load Cost Category" =
                            grc_FruitVisionSetup."Purch. Inv. Load Cost Category"::"Cost Cat - Show allways G/L Accounts") THEN BEGIn
                            lfm_CostCategoryAccounts.SETTABLEVIEW(lrc_CostCategoryAccounts);
                            lfm_CostCategoryAccounts.LOOKUPMODE := TRUE;
                            IF lfm_CostCategoryAccounts.RUNMODAL() <> ACTION::LookupOK THEN
                                EXIT;
                            lrc_CostCategoryAccounts.RESET();
                            lfm_CostCategoryAccounts.GETRECORD(lrc_CostCategoryAccounts);
                            VALIDATE("No.", lrc_CostCategoryAccounts."G/L Account No.");
                            //RS Prüfung ob in CostCategoryAccountKostenart hinterlegt
                            IF lrc_CostCategoryAccounts.Kostenart <> '' THEN
                                VALIDATE("Shortcut Dimension 2 Code", lrc_CostCategoryAccounts.Kostenart);
                            "POI Cost Category Code" := TempPurchLine."POI Cost Category Code";

                            // Mit Zuordnung durch das Programm
                        END ELSE BEGIN
                            //lrc_CostCategoryAccounts.SETRANGE("Gen. Bus. Posting Group",lrc_PurchHeader."Gen. Bus. Posting Group");
                            lrc_CostCategoryAccounts.SETFILTER("Gen. Bus. Posting Group", '%1|%2', lrc_PurchHeader."Gen. Bus. Posting Group", '');

                            IF NOT lrc_CostCategoryAccounts.FIND('-') THEN
                                lrc_CostCategoryAccounts.SETRANGE("Gen. Bus. Posting Group");

                            IF lrc_CostCategoryAccounts.COUNT() >= 1 THEN BEGIN
                                IF lrc_CostCategoryAccounts.COUNT() > 1 THEN BEGIN
                                    lfm_CostCategoryAccounts.SETTABLEVIEW(lrc_CostCategoryAccounts);
                                    lfm_CostCategoryAccounts.LOOKUPMODE := TRUE;
                                    IF lfm_CostCategoryAccounts.RUNMODAL() <> ACTION::LookupOK THEN
                                        EXIT;
                                    lrc_CostCategoryAccounts.RESET();
                                    lfm_CostCategoryAccounts.GETRECORD(lrc_CostCategoryAccounts);
                                    VALIDATE("No.", lrc_CostCategoryAccounts."G/L Account No.");
                                    //RS Prüfung ob in CostCategoryAccountKostenart hinterlegt
                                    IF lrc_CostCategoryAccounts.Kostenart <> '' THEN
                                        VALIDATE("Shortcut Dimension 2 Code", lrc_CostCategoryAccounts.Kostenart);
                                    "POI Cost Category Code" := TempPurchLine."POI Cost Category Code";
                                END ELSE BEGIN
                                    lrc_CostCategoryAccounts.FIND('-');
                                    VALIDATE("No.", lrc_CostCategoryAccounts."G/L Account No.");
                                    //RS Prüfung ob in CostCategoryAccountKostenart hinterlegt
                                    IF lrc_CostCategoryAccounts.Kostenart <> '' THEN
                                        VALIDATE("Shortcut Dimension 2 Code", lrc_CostCategoryAccounts.Kostenart);
                                    "POI Cost Category Code" := lrc_CostCategoryAccounts."Cost Category Code";
                                END;
                            END ELSE
                                // Keine Kontenzuordnung für Kostenkategorie %1 vorhanden!
                                ERROR(AGILES_LT_TEXT003Txt, "POI Cost Category Code");
                        END;
                    END;

        END;

        // -------------------------------------------------------------------------------------------------------------
        // Prüfung bei Eingabe der Sachkontonummer
        // -------------------------------------------------------------------------------------------------------------
        IF (gbn_CalledFromInterface = FALSE) AND
           (CurrFieldNo = FIELDNO("No.")) THEN BEGIN

            // Kontrolle ob eine eventuell vorhandene Kostenkategorie zum Sachkonto passt
            IF "POI Cost Category Code" <> '' THEN BEGIN
                lrc_CostCategoryAccounts.RESET();
                lrc_CostCategoryAccounts.SETRANGE("Cost Schema Code", '');
                lrc_CostCategoryAccounts.SETRANGE("Cost Category Code", "POI Cost Category Code");
                lrc_CostCategoryAccounts.SETRANGE("G/L Account No.", "No.");
                IF NOT lrc_CostCategoryAccounts.FINDFIRST() THEN
                    "POI Cost Category Code" := '';
            END;

            IF (grc_FruitVisionSetup."Purch. Inv. Load Cost Category" =
                grc_FruitVisionSetup."Purch. Inv. Load Cost Category"::"G/L Account - Show Cost Cat.") OR
               (grc_FruitVisionSetup."Purch. Inv. Load Cost Category" =
                grc_FruitVisionSetup."Purch. Inv. Load Cost Category"::Both) OR
               (grc_FruitVisionSetup."Purch. Inv. Load Cost Category" =
                grc_FruitVisionSetup."Purch. Inv. Load Cost Category"::"Cost Cat - Show allways G/L Accounts") THEN BEGIN

                lrc_PurchHeader.GET("Document Type", "Document No.");

                lrc_CostCategoryAccounts.RESET();
                lrc_CostCategoryAccounts.FILTERGROUP(2);
                lrc_CostCategoryAccounts.SETRANGE("Cost Schema Code", '');
                lrc_CostCategoryAccounts.SETRANGE("G/L Account No.", "No.");
                lrc_CostCategoryAccounts.SETFILTER("Cost Category Code", '<>%1', '');
                lrc_CostCategoryAccounts.FILTERGROUP(0);
                IF lrc_CostCategoryAccounts.COUNT() >= 1 THEN BEGIN
                    IF lrc_CostCategoryAccounts.COUNT() > 1 THEN BEGIN
                        lfm_CostCategoryAccounts.SETTABLEVIEW(lrc_CostCategoryAccounts);
                        lfm_CostCategoryAccounts.LOOKUPMODE := TRUE;
                        IF lfm_CostCategoryAccounts.RUNMODAL() <> ACTION::LookupOK THEN
                            EXIT
                        ELSE BEGIN
                            lrc_CostCategoryAccounts.RESET();
                            lfm_CostCategoryAccounts.GETRECORD(lrc_CostCategoryAccounts);
                            "POI Cost Category Code" := lrc_CostCategoryAccounts."Cost Category Code";
                            //RS Prüfung ob in CostCategoryAccountKostenart hinterlegt
                            IF lrc_CostCategoryAccounts.Kostenart <> '' THEN
                                VALIDATE("Shortcut Dimension 2 Code", lrc_CostCategoryAccounts.Kostenart);
                        END;
                    END ELSE BEGIN
                        lrc_CostCategoryAccounts.FIND('-');
                        "POI Cost Category Code" := lrc_CostCategoryAccounts."Cost Category Code";
                        //RS Prüfung ob in CostCategoryAccountKostenart hinterlegt
                        IF lrc_CostCategoryAccounts.Kostenart <> '' THEN
                            VALIDATE("Shortcut Dimension 2 Code", lrc_CostCategoryAccounts.Kostenart);
                    END;
                END ELSE
                    "POI Cost Category Code" := '';
            END;

        END;


        // Dimension setzen
        CASE grc_FruitVisionSetup."Dim. No. Cost Category" OF
            grc_FruitVisionSetup."Dim. No. Cost Category"::"1.Dimension":
                VALIDATE("Shortcut Dimension 1 Code", "POI Cost Category Code");
            grc_FruitVisionSetup."Dim. No. Cost Category"::"2.Dimension":
                VALIDATE("Shortcut Dimension 2 Code", "POI Cost Category Code");
            grc_FruitVisionSetup."Dim. No. Cost Category"::"3.Dimension":
                VALIDATE("POI Shortcut Dimension 3 Code", "POI Cost Category Code");
            grc_FruitVisionSetup."Dim. No. Cost Category"::"4.Dimension":
                VALIDATE("POI Shortcut Dimension 4 Code", "POI Cost Category Code");
        END;

    end;

    procedure ADF_ChangeCalledFromSalesLine(rbn_CalledChangefromSalesLine: Boolean)
    begin
        // --------------------------------------------------------------------------------------
        // Funktion zum Setzen einer Globalen Boolean ob Aufruf aus Verkaufszeile erfolgt
        // --------------------------------------------------------------------------------------
        gbn_CalledChangefromSalesLine := rbn_CalledChangefromSalesLine;
    end;

    procedure ADF_No_Validate()
    var
        lrc_PurchaseHeader: Record "Purchase Header";
        lrc_GLAccount: Record "G/L Account";
        lrc_ItemCharge: Record "Item Charge";
        lrc_StandardText: Record "Standard Text";
        lrc_FixedAsset: Record "Fixed Asset";
        lrc_UserSetup: Record "User Setup";
    begin
        // --------------------------------------------------------------------------------------
        // Funktion zur Validierung der Nummern Eingabe
        // --------------------------------------------------------------------------------------

        IF "No." = '' THEN
            EXIT;

        // Prüfung in Abhängigkeit vom Typ
        CASE Type OF
            // Sachkonto
            Type::"G/L Account":
                BEGIN
                    lrc_GLAccount.GET("No.");
                    lrc_UserSetup.GET(USERID());
                    IF lrc_UserSetup."POI Perm. for all G/L Accounts" = FALSE THEN
                        lrc_GLAccount.TESTFIELD("POI Allowed in Purchase");
                END;

            // Artikel
            Type::Item:
                BEGIN

                    IF lrc_PurchaseHeader.GET("Document Type", "Document No.") THEN
                        gcu_GlobalVariablesMgt.SetGlobalVariant(DATABASE::"Purchase Header", lrc_PurchaseHeader);

                    // -----------------------------------------------------------------------------------
                    // Funktion zur Suche eines Artikels
                    // -----------------------------------------------------------------------------------
                    // rco_ItemNo
                    // vbn_Search
                    // vop_Source
                    // vdt_OrderDate
                    // vco_CustomerNo
                    // vbn_SearchInAssortment
                    // vco_AssortmentVersionNo
                    // -----------------------------------------------------------------------------------
                    gcu_BDMBaseDataMgt.ItemValidateSearch("No.", (CurrFieldNo = FIELDNO("No.")), 1, 0D, '', FALSE, '');
                    // Prüfung ob Debitor für Belegunterart zugelassen
                    gcu_DSTDocSubtypeMgt.CheckItemPurchDocTyp("Document Type", "Document No.", "No.");
                END;
            // Sachanlagen
            Type::"Fixed Asset":
                lrc_FixedAsset.GET("No.");
            // Zu-/Abschlag
            Type::"Charge (Item)":
                lrc_ItemCharge.GET("No.");
            // Text
            Type::" ":
                lrc_StandardText.GET("No.");
        END;
    end;

    procedure ADF_GetGLAccountTranslation()
    var
        lrc_LanguageTranslation: Record "POI Language Translation";
    begin
        // -----------------------------------------------------------------
        // Funktion zur Übersetzung der Beschreibung vom Sachkonto
        // -----------------------------------------------------------------

        GetPurchHeader();

        lrc_LanguageTranslation.RESET();
        lrc_LanguageTranslation.SETRANGE("Table ID", 15);
        lrc_LanguageTranslation.SETRANGE(Code, "No.");
        lrc_LanguageTranslation.SETRANGE("Language Code", PurchHeader."Language Code");
        IF lrc_LanguageTranslation.FINDFIRST() THEN BEGIN
            IF lrc_LanguageTranslation.Description <> '' THEN
                Description := lrc_LanguageTranslation.Description;

            IF lrc_LanguageTranslation."Description 2" <> '' THEN
                "Description 2" := copystr(lrc_LanguageTranslation."Description 2", 1, MaxStrLen("Description 2"));

        END ELSE BEGIN
            lrc_LanguageTranslation.SETRANGE("Language Code", '');
            IF lrc_LanguageTranslation.FINDFIRST() THEN BEGIN
                IF lrc_LanguageTranslation.Description <> '' THEN
                    Description := lrc_LanguageTranslation.Description;
                IF lrc_LanguageTranslation."Description 2" <> '' THEN
                    "Description 2" := copystr(lrc_LanguageTranslation."Description 2", 1, MaxStrLen("Description 2"));
            END;
        END;
    end;

    procedure ADF_SetQtyAssigned()
    begin
        // ----------------------------------------------------------------------------------------------------------
        // Funktion zur Aktualisierung der zugewiesenen Menge
        // ----------------------------------------------------------------------------------------------------------

        IF (("Document Type" = "Document Type"::"Credit Memo") OR
            ("Document Type" = "Document Type"::"Return Order")) AND
           (Type = Type::"Charge (Item)") AND
           (Quantity <> "Qty. Assigned") AND
           ("No." <> '') AND
           ("POI Reference Item No." <> '') THEN BEGIN
            lrc_ItemChargeAssignPurch.RESET();
            lrc_ItemChargeAssignPurch.SETRANGE("Document Type", "Document Type");
            lrc_ItemChargeAssignPurch.SETRANGE("Document No.", "Document No.");
            lrc_ItemChargeAssignPurch.SETRANGE("Document Line No.", "Line No.");
            IF lrc_ItemChargeAssignPurch.FINDFIRST() THEN BEGIN
                lrc_ItemChargeAssignPurch.VALIDATE("Qty. to Assign", Quantity);
                lrc_ItemChargeAssignPurch.MODIFY();
            END;
        END;
    end;

    Procedure GetAttributFilterstringForItem(ItemNo: code[20]; AttributType: enum "POI Item Attribute"): Text[250]
    var
        Filterstring: Text[250];
    begin
        ItemAttribut.SetRange("Item No.", ItemNo);
        ItemAttribut.SetRange("Attribute Type", AttributType);
        if ItemAttribut.FindSet() then
            repeat
                if Filterstring <> '' then
                    Filterstring += '|';
                Filterstring += ItemAttribut."Attribute Code";
            until ItemAttribut.Next() = 0;
        exit(Filterstring);
    end;


    var
        PurchHeader: Record "Purchase Header";
        Item: Record Item;
        TempPurchLine: Record "Purchase Line";
        grc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_PalletFactorbyPercentage: Record "POI Pallet Factor by Percent";
        lrc_ItemLedgerEntry: Record "Item Ledger Entry";
        lrc_EmptiesPurchLine: Record "Purchase Line";
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_CostCategoryAccounts: Record "POI Cost Category Accounts";
        lrc_PurchLine: Record "Purchase Line";
        lrc_ItemChargeAssignPurch: Record "Item Charge Assignment (Purch)";
        ItemAttribut: Record "POI Item Attribute";

        gcu_PurchMgt: Codeunit "POI Purch. Mgt";
        gcu_AgencyBusinessMgt: Codeunit "POI Agency Business Mgt";
        gcu_BDMBaseDataMgt: Codeunit "POI BDM Base Data Mgmt";
        gcu_BatchMgt: Codeunit "POI BAM Batch Management";
        gcu_BaseDataMgt: Codeunit "POI Base Data Mgt";
        gcu_ItemAttributeMgt: Codeunit "POI Item Attribute Mask Mgt";
        gcu_GlobalVariablesMgt: Codeunit "POI Global Variables Mgt.";
        gcu_DSTDocSubtypeMgt: Codeunit "POI DST Doc. Subtype Mgt";
        gcu_StockMgt: Codeunit "POI Stock Management";
        ItemAttributpg: page "POI Item Attribute Purch";
        ADF_GT_TEXT004Txt: Label '%1 %Drawback', Comment = '%1';
        ADF_GT_TEXT020Txt: Label 'Es sind bereits Mengen geliefert. Möchten Sie trotzdem ändern?';
        ADF_GT_TEXT021Txt: Label 'Abbruch!';
        ADF_GT_TEXT022Txt: Label 'Artikelposten nicht gefunden!';
        ADF_GT_TEXT026Txt: Label 'Artikel ist nicht aktiv im Verkauf! Einkauf nicht zulässig.';
        // ADF_GT_TEXT027: Label 'Item must have ''Date of Expiry Mandatory'', if ''Guaranteed Shelf Life'' is not empty.';
        // ADF_GT_TEXT028: Label 'Mandatory field %1 in the line %2 is empty';
        ADF_GT_TEXT029Txt: Label 'Artikel ist nicht aktiv im Einkauf! Einkauf nicht zulässig.';
        ADF_GT_TEXT030Txt: Label 'Artikel ist nicht aktiv im Einkauf und Verkauf! Einkauf nicht zulässig.';
        ADF_GT_TEXT038Txt: Label 'Es bestehen bereits Verkaufslieferungen! Möchten Sie das Leergut trotzdem ändern?';
        ADF_GT_TEXT036Txt: Label 'Kein Artikel für Nettowiegen!';
        ADF_GT_TEXT037Txt: Label 'Kein Artikel für Bruttowiegen!';
        ADF_GT_TEXT035Txt: Label 'Eingabe Wiegen ist abweichend von Vorgabe aus Preisbasis!';
        ADF_GT_TEXT024Txt: Label 'Vendor No. %1 does not exist.', Comment = '%1';
        Text010Txt: Label 'You cannot change %1 when %2 is %3.', Comment = '%1 %2 %3';
        ADF_GT_TEXT006Txt: Label 'Änderung Artikelnr. nicht zulässig!';
        ADF_GT_TEXT007Txt: Label 'Nur für Artikelzeilen zulässig!';
        ADF_GT_TEXT002Txt: Label 'Änderung Type nicht zulässig !';
        ADF_GT_TEXT003Txt: Label 'Pos.-Var. bereits generiert. Änderung nicht zulässig!';
        gbn_CalledChangefromSalesLine: Boolean;
        gbn_CalledFromInterface: Boolean;

}