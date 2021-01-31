table 5110360 "POI ADF Temp I"
{
    Caption = 'ADF Temp I';

    fields
    {
        field(1; "User ID"; Code[20])
        {
            Caption = 'User ID';
        }
        field(2; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            Description = 'EZS=Ek-Zeile Splitt, SK=Sortiment kopieren,VSV=Verkauf Sortimentsvariable,WW=Währungswechsel,VW=Vendor Wechsel,CW=Cust. Wechsel,KL=Kommissionierliste,CC=Barverkauf,PE=Palettenerfassung,MAL=MAL Meldung,STO=Stock,ABGR=Rg.-Abgrenzung,NSO=NewSalesOrder,NRO=New Reservation Order';
            OptionCaption = 'EZS,SK,VSV,WW,VW,CW,KL,CC,PE,MAL,STOCK BV,STOCK ITEM,BA STATISTIC,ABGR,LOCBATCH,AGGBATCH,PD,NSO,NTO,NRO';
            OptionMembers = EZS,SK,VSV,WW,VW,CW,KL,CC,PE,MAL,"STOCK BV","STOCK ITEM","BA STATISTIC",ABGR,LOCBATCH,AGGBATCH,PD,NSO,NTO,NRO;
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(9; "-- EZS --"; Integer)
        {
            Caption = '-- EZS --';
        }
        field(10; "EZS Doc. No."; Code[20])
        {
            Caption = 'EZS Doc. No.';
            Description = 'EZS';
        }
        field(11; "EZS Item No."; Code[20])
        {
            Caption = 'EZS Item No.';
            Description = 'EZS';
        }
        field(14; "EZS Master Batch No."; Code[20])
        {
            Caption = 'EZS Master Batch No.';
            Description = 'EZS';
        }
        field(15; "EZS Batch No."; Code[20])
        {
            Caption = 'EZS Batch No.';
            Description = 'EZS';
        }
        field(16; "EZS Batch Variant No."; Code[20])
        {
            Caption = 'EZS Batch Variant No.';
            Description = 'EZS';
        }
        field(18; "EZS Location Code"; Code[10])
        {
            Caption = 'EZS Location Code';
            Description = 'EZS';
        }
        field(19; "EZS Unit of Measure Code"; Code[10])
        {
            Caption = 'EZS Unit of Measure Code';
            Description = 'EZS';
        }
        field(20; "EZS Quantity"; Decimal)
        {
            Caption = 'EZS Quantity';
            Description = 'EZS';
        }
        field(21; "EZS Remaining Quantity"; Decimal)
        {
            Caption = 'EZS Remaining Quantity';
            Description = 'EZS';
        }
        field(22; "EZS Transport of Measure Code"; Code[10])
        {
            Caption = 'EZS Transport Unit of Measure (TU)';
            Description = 'EZS';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));
        }
        field(23; "EZS Qty. (Unit) perTransp.Unit"; Decimal)
        {
            Caption = 'EZS Qty. (Unit) per Transp. Unit';
            Description = 'EZS';
        }
        field(25; "EZS Splitt Quantity"; Decimal)
        {
            Caption = 'EZS Splitt Quantity';
            Description = 'EZS';

            trigger OnValidate()
            var
                lrc_FruitVisionSetup: Record "POI ADF Setup";
            begin
                IF "EZS Splitt Quantity" < 0 THEN
                    ERROR('Splittmenge darf nicht negativ sein!');

                lrc_FruitVisionSetup.GET();
                IF (lrc_FruitVisionSetup."Internal Customer Code" <> 'INTERWEICHERT') AND
                   (lrc_FruitVisionSetup."Internal Customer Code" <> 'DELMONTEDE') THEN
                    IF "EZS Splitt Quantity" > "EZS Remaining Quantity" THEN
                        ERROR('Splittmenge darf nicht größer als Restbestellungsmenge sein!');
            end;
        }
        field(26; "EZS Splitt Location Code"; Code[10])
        {
            Caption = 'EZS Splitt Location Code';
            Description = 'EZS';
            TableRelation = Location;
        }
        field(30; "EZS Info 1"; Code[30])
        {
            CaptionClass = '5110300,1,1';
            Caption = 'Info 1';
            Description = 'EZS';
        }
        field(31; "EZS Info 2"; Code[50])
        {
            CaptionClass = '5110300,1,2';
            Caption = 'Info 2';
            Description = 'EZS';
        }
        field(32; "EZS Info 3"; Code[20])
        {
            CaptionClass = '5110300,1,3';
            Caption = 'Info 3';
            Description = 'EZS';
        }
        field(33; "EZS Info 4"; Code[20])
        {
            CaptionClass = '5110300,1,4';
            Caption = 'Info 4';
            Description = 'EZS';
        }
        field(34; "EZS Price"; Decimal)
        {
            Caption = 'EZS Price';
            Description = 'EZS';
        }
        field(40; "EZS Country of Origin Code"; Code[10])
        {
            Caption = 'EZS Country of Origin Code';
            Description = 'EZS';
            TableRelation = "Country/Region";
        }
        field(41; "EZS Variety Code"; Code[10])
        {
            Caption = 'EZS Variety Code';
            Description = 'EZS';
            TableRelation = "POI Variety";
        }
        field(42; "EZS Trademark Code"; Code[20])
        {
            Caption = 'EZS Trademark Code';
            Description = 'EZS';
            TableRelation = "POI Trademark";
        }
        field(43; "EZS Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            Description = 'EZS';
            TableRelation = "POI Caliber";
        }
        field(44; "EZS Color Code"; Code[10])
        {
            Caption = 'EZS Color Code';
            Description = 'EZS';
            TableRelation = "POI Item Attribute 2";
        }
        field(45; "EZS Conservation Code"; Code[10])
        {
            Caption = 'EZS Conservation Code';
            Description = 'EZS';
            TableRelation = "POI Item Attribute 7";
        }
        field(46; "EZS Packing Code"; Code[10])
        {
            Caption = 'EZS Packing Code';
            Description = 'EZS';
            TableRelation = "POI Item Attribute 4";
        }
        field(60; "EZS Splitt Typ"; Option)
        {
            Caption = 'EZS Splitt Typ';
            Description = 'EZS';
            OptionCaption = 'Splitting,New Line';
            OptionMembers = Splitting,"New Line";
        }
        field(70; "EZS Splitt Item No."; Code[20])
        {
            Caption = 'EZS Splitt Item No.';
            Description = 'EZS';
            TableRelation = Item."No.";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_SalesHeader: Record "Sales Header";
                lrc_ItemTransportUnitFactor: Record "POI Factor Transport Unit";
                lrc_FruitVisionSetup: Record "POI ADF Setup";
                lrc_Item: Record Item;
                lcu_UnitMgt: Codeunit "POI Unit Mgt";
                lcu_BaseDataMgt: Codeunit "POI Base Data Mgt";
                lco_TempTransportUnitOfMeasure: Code[10];
                lco_No: Code[20];
            begin
                IF ("EZS Splitt Item No." <> '') AND
                   (lrc_SalesHeader.GET(lrc_SalesHeader."Document Type"::Order, "EZS Doc. No.")) THEN BEGIN
                    // Referenzdatum ermitteln
                    IF lcu_BaseDataMgt.ItemNoSearch("EZS Splitt Item No.", 1, lrc_SalesHeader."Sell-to Customer No.",
                                                       lrc_SalesHeader."Order Date", FALSE,
                                                       lrc_SalesHeader."POI Assortment Version No.",
                                                       lco_No) = FALSE THEN BEGIN

                        lrc_FruitVisionSetup.GET();
                        ;
                        // IF lrc_FruitVisionSetup."Sales Beep if Item not found" = TRUE THEN BEGIN //TODO: Beep
                        //     BEEP(800, 250);
                        //     BEEP(500, 500);
                        //     ERROR('');
                        // END ELSE
                        //     ERROR('');
                    END ELSE
                        "EZS Splitt Item No." := lco_No;
                    IF lrc_Item.GET("EZS Splitt Item No.") THEN BEGIN
                        "EZS Splitt CountryofOriginCode" := lrc_Item."POI Countr of Ori Code (Fruit)";
                        "EZS Splitt Variety Code" := lrc_Item."POI Variety Code";
                        "EZS Splitt Trademark Code" := lrc_Item."POI Trademark Code";
                        "EZS Splitt Caliber Code" := lrc_Item."POI Caliber Code";
                        "EZS Splitt Color Code" := lrc_Item."POI Item Attribute 2";
                        "EZS Splitt Conservation Code" := lrc_Item."POI Item Attribute 7";
                        "EZS Splitt Packing Code" := lrc_Item."POI Item Attribute 4";
                        "EZS Splitt Unit of MeasureCode" := lrc_Item."Sales Unit of Measure";

                        // Transporteinheit ziehen
                        lco_TempTransportUnitOfMeasure := '';

                        lcu_UnitMgt.GetItemCustomerTransportUnit("EZS Splitt Item No.",
                                                                 lrc_ItemTransportUnitFactor."Reference Typ"::Customer,
                                                                 lrc_SalesHeader."Sell-to Customer No.",
                                                                 "EZS Splitt Unit of MeasureCode",
                                                                 lco_TempTransportUnitOfMeasure);

                        IF lco_TempTransportUnitOfMeasure <> '' THEN
                            VALIDATE("EZS Splitt (TU) of Measure", lco_TempTransportUnitOfMeasure);
                    END;

                END;
                // DMG 001 DMG50127.e
            end;
        }
        field(71; "EZS Splitt Blanket No."; Code[20])
        {
        }
        field(72; "EZS Splitt Blanket Line No."; Integer)
        {
        }
        field(80; "EZS Splitt CountryofOriginCode"; Code[10])
        {
            Caption = 'EZS Splitt Country of Origin Code';
            Description = 'EZS';
            TableRelation = "Country/Region";
        }
        field(81; "EZS Splitt Variety Code"; Code[10])
        {
            Caption = 'EZS Variety Splitt Code';
            Description = 'EZS';
            TableRelation = "POI Variety";
        }
        field(82; "EZS Splitt Trademark Code"; Code[20])
        {
            Caption = 'EZS Splitt Trademark Code';
            Description = 'EZS';
            TableRelation = "POI Trademark";
        }
        field(83; "EZS Splitt Caliber Code"; Code[10])
        {
            Caption = 'Splitt Caliber Code';
            Description = 'EZS';
            TableRelation = "POI Caliber";
        }
        field(84; "EZS Splitt Color Code"; Code[10])
        {
            Caption = 'EZS Splitt Color Code';
            Description = 'EZS';
            TableRelation = "POI Item Attribute 2";
        }
        field(85; "EZS Splitt Conservation Code"; Code[10])
        {
            Caption = 'EZS Splitt Conservation Code';
            Description = 'EZS';
            TableRelation = "POI Item Attribute 7";
        }
        field(86; "EZS Splitt Packing Code"; Code[10])
        {
            Caption = 'EZS Splitt Packing Code';
            Description = 'EZS';
            TableRelation = "POI Item Attribute 4";
        }
        field(94; "EZS Splitt Unit of MeasureCode"; Code[10])
        {
            Caption = 'EZS Splitt Unit of Measure Code';
            Description = 'EZS';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("EZS Splitt Item No."));
        }
        field(95; "EZS Splitt (TU) of Measure"; Code[10])
        {
            Caption = 'EZS Splitt Transport Unit of Measure (TU)';
            Description = 'EZS';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));

            trigger OnValidate()
            var
                lrc_ItemTransportUnitFactor: Record "POI Factor Transport Unit";
                lrc_SalesHeader: Record "Sales Header";
                lcu_UnitMgt: Codeunit "POI Unit Mgt";
                ldc_QtyPerUnitOfMeasure: Decimal;
                ldc_PalletFaktor: Decimal;
            begin
                // DMG 001 DMG50127.s
                TESTFIELD("EZS Splitt Item No.");
                IF "EZS Splitt (TU) of Measure" <> '' THEN BEGIN

                    IF ("EZS Splitt (TU) of Measure" <> xRec."EZS Splitt (TU) of Measure") AND
                       (CurrFieldNo <> 0) THEN BEGIN

                        ldc_PalletFaktor := 0;
                        IF (lrc_SalesHeader.GET(lrc_SalesHeader."Document Type"::Order, "EZS Doc. No.")) THEN BEGIN

                            ldc_QtyPerUnitOfMeasure := 1;
                            // ACHTUNG Leergut Artikelnummer muss noch übergeben werden!!
                            lcu_UnitMgt.GetItemVendorUnitPalletFactor("EZS Splitt Item No.",
                                                                      lrc_ItemTransportUnitFactor."Reference Typ"::Customer,
                                                                      lrc_SalesHeader."Sell-to Customer No.",
                                                                      "EZS Splitt Unit of MeasureCode",
                                                                      ldc_QtyPerUnitOfMeasure,
                                                                      '',
                                                                      "EZS Splitt (TU) of Measure",
                                                                      ldc_PalletFaktor);
                        END;
                        IF ldc_PalletFaktor <> 0 THEN //BEGIN
                            "EZS Splitt Qty(Unit) per (TU)" := ldc_PalletFaktor;
                        // Menge Paletten berechnen
                        //   IF "EZS Splitt Qty(Unit) per (TU)" <> 0 THEN BEGIN
                        //   //  "Quantity (TU)" := "EZS Splitt Quantity" / "EZS Splitt Qty(Unit) per (TU)"
                        //   END ELSE BEGIN
                        //   //  "Quantity (TU)" := 0;
                        //   END;
                        //END;
                    END;

                END ELSE //BEGIN
                    "EZS Splitt Qty(Unit) per (TU)" := 0;
                //  "Quantity (TU)" := 0;
                //END;
            end;
        }
        field(96; "EZS Splitt Qty(Unit) per (TU)"; Decimal)
        {
            Caption = 'EZS Splitt Qty. (Unit) per Transp. Unit';
            Description = 'EZS';
        }
        field(97; "EZS Qty Lines"; Integer)
        {
        }
        field(100; "SK Copy to Assortment Vers."; Code[20])
        {
            Caption = 'SK Copy to Assortment Vers.';
            Description = 'SK';
            TableRelation = "POI Assortment Version";
        }
        field(103; "SK Copy from Assortment Vers."; Code[20])
        {
            Caption = 'SK Copy from Assortment Vers.';
            Description = 'SK';
            TableRelation = "POI Assortment Version";

            trigger OnValidate()
            var
                lrc_AssortmentVersion: Record "POI Assortment Version";
            begin
                IF "SK Copy from Assortment Vers." = '' THEN BEGIN
                    "SK Copy from Valid From" := 0D;
                    "SK Copy from Valid To" := 0D;
                END ELSE BEGIN
                    lrc_AssortmentVersion.GET("SK Copy from Assortment Vers.");
                    "SK Copy from Valid From" := lrc_AssortmentVersion."Starting Date Assortment";
                    "SK Copy from Valid To" := lrc_AssortmentVersion."Ending Date Assortment";
                END;
            end;
        }
        field(106; "SK Copy to Valid From"; Date)
        {
            Caption = 'SK Copy to Valid From';
            Description = 'SK';
        }
        field(107; "SK Copy to Valid To"; Date)
        {
            Caption = 'SK Copy to Valid To';
            Description = 'SK';
        }
        field(110; "SK Copy from Valid From"; Date)
        {
            Caption = 'SK Copy from Valid From';
            Description = 'SK';
        }
        field(111; "SK Copy from Valid To"; Date)
        {
            Caption = 'SK Copy from Valid To';
            Description = 'SK';
        }
        field(112; "SK Copy Price"; Boolean)
        {
            Caption = 'SK Copy Price';
        }
        field(119; "-- WW --"; Integer)
        {
            Caption = '-- WW --';
            Description = 'WW';
        }
        field(120; "WW Aktuelle Währung"; Code[10])
        {
            Caption = 'WW Aktuelle Währung';
            Description = 'WW';
            TableRelation = Currency;
        }
        field(121; "WW Neue Währung"; Code[10])
        {
            Caption = 'WW Neue Währung';
            Description = 'WW';
            TableRelation = Currency;
        }
        field(146; "VW Akt. MwSt.-Ländercode"; Code[10])
        {
            Caption = 'VW Akt. MwSt.-Ländercode';
            Description = 'VW';
            TableRelation = "Country/Region";
        }
        field(147; "VW Neuer MwSt.-Ländercode"; Code[10])
        {
            Caption = 'VW Neuer MwSt.-Ländercode';
            Description = 'VW';
            TableRelation = "Country/Region";
        }
        field(149; "VW Akt. Zahl an Kreditorennr"; Code[20])
        {
            Caption = 'VW Akt. Zahl an Kreditorennr';
            Description = 'VW';
            TableRelation = Vendor;
        }
        field(150; "VW Akt. Kreditorennr"; Code[20])
        {
            Caption = 'VW Akt. Kreditorennr';
            Description = 'VW';
            TableRelation = Vendor;
        }
        field(151; "VW Akt. Geschäftsbuchungsgrupp"; Code[10])
        {
            Caption = 'VW Akt. Geschäftsbuchungsgrupp';
            Description = 'VW';
            TableRelation = "Gen. Business Posting Group";
        }
        field(152; "VW Akt. MwSt. Gesch. Buch. Grp"; Code[10])
        {
            Caption = 'VW Akt. MwSt. Gesch. Buch. Grp';
            Description = 'VW';
            TableRelation = "VAT Business Posting Group";
        }
        field(153; "VW Akt. Kreditorenbuch.Grp"; Code[20])
        {
            Caption = 'VW Akt. Kreditorenbuch.Grp';
            Description = 'VW';
            TableRelation = "Vendor Posting Group";
        }
        field(159; "VW Neue Zahl an Kreditorennr"; Code[20])
        {
            Caption = 'VW Neue Zahl an Kreditorennr';
            Description = 'VW';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                lrc_Vendor: Record Vendor;
            begin
                IF lrc_Vendor.GET("VW Neue Zahl an Kreditorennr") THEN BEGIN
                    "VW Neue Geschäftsbuchungsgrupp" := lrc_Vendor."Gen. Bus. Posting Group";
                    "VW Neue MwSt. Gesch. Buch. Grp" := lrc_Vendor."VAT Bus. Posting Group";
                    "VW Neue Kreditorenbuch.Grp" := lrc_Vendor."Vendor Posting Group";
                END;

            end;
        }
        field(160; "VW Neue Kreditorennr"; Code[20])
        {
            Caption = 'VW Neue Kreditorennr';
            Description = 'VW';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                lrc_Vendor: Record Vendor;
            begin
                IF lrc_Vendor.GET("VW Neue Kreditorennr") THEN
                    IF lrc_Vendor."Pay-to Vendor No." <> '' THEN
                        VALIDATE("VW Neue Zahl an Kreditorennr", lrc_Vendor."Pay-to Vendor No.")
                    ELSE
                        VALIDATE("VW Neue Zahl an Kreditorennr", "VW Neue Kreditorennr");
            end;
        }
        field(161; "VW Neue Geschäftsbuchungsgrupp"; Code[20])
        {
            Caption = 'VW Neue Geschäftsbuchungsgrupp';
            Description = 'VW';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            var
                lrc_GenBusPostingGrp: Record "Gen. Business Posting Group";
            begin
                IF "VW Neue Geschäftsbuchungsgrupp" <> xRec."VW Neue Geschäftsbuchungsgrupp" THEN
                    IF lrc_GenBusPostingGrp.ValidateVatBusPostingGroup(lrc_GenBusPostingGrp, "VW Neue Geschäftsbuchungsgrupp") THEN
                        VALIDATE("VW Neue MwSt. Gesch. Buch. Grp", lrc_GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(162; "VW Neue MwSt. Gesch. Buch. Grp"; Code[20])
        {
            Caption = 'VW Neue MwSt. Gesch. Buch. Grp';
            Description = 'VW';
            TableRelation = "VAT Business Posting Group";
        }
        field(163; "VW Neue Kreditorenbuch.Grp"; Code[20])
        {
            Caption = 'VW Neue Kreditorenbuch.Grp';
            Description = 'VW';
            TableRelation = "Vendor Posting Group";
        }
        field(169; "CW Akt. Rech. an Debitorennr."; Code[20])
        {
            Caption = 'CW Akt. Rech. an Debitorennr.';
            Description = 'CW';
            TableRelation = Customer;
        }
        field(170; "CW Akt. Verk. an Debitorennr."; Code[20])
        {
            Caption = 'CW Akt. Verk. an Debitorennr.';
            Description = 'CW';
            TableRelation = Customer;
        }
        field(171; "CW Akt. Geschäftsbuchungsgrupp"; Code[10])
        {
            Caption = 'CW Akt. Geschäftsbuchungsgrupp';
            Description = 'CW';
            TableRelation = "Gen. Business Posting Group";
        }
        field(172; "CW Akt. MwSt. Gesch. Buch. Grp"; Code[10])
        {
            Caption = 'CW Akt. MwSt. Gesch. Buch. Grp';
            Description = 'CW';
            TableRelation = "VAT Business Posting Group";
        }
        field(173; "CW Akt. Debitorenbuch.Grp"; Code[10])
        {
            Caption = 'CW Akt. Debitorenbuch.Grp';
            Description = 'CW';
            TableRelation = "Customer Posting Group";
        }
        field(179; "CW Neue Rech. an Debitorennr."; Code[20])
        {
            Caption = 'CW Neue Rech. an Debitorennr.';
            Description = 'CW';
            TableRelation = Customer;

            trigger OnValidate()
            var
                lrc_Customer: Record Customer;
            begin
                IF lrc_Customer.GET("CW Neue Rech. an Debitorennr.") THEN BEGIN
                    "CW Neue Geschäftsbuchungsgrupp" := lrc_Customer."Gen. Bus. Posting Group";
                    "CW Neue MwSt. Gesch. Buch. Grp" := lrc_Customer."VAT Bus. Posting Group";
                    "CW Neue Debitorenbuch.Grp" := lrc_Customer."Customer Posting Group";
                END;
            end;
        }
        field(180; "CW Neue Verk. an Debitorennr."; Code[20])
        {
            Caption = 'CW Neue Verk. an Debitorennr.';
            Description = 'CW';
            TableRelation = Customer;

            trigger OnValidate()
            var
                lrc_Customer: Record Customer;
            begin
                IF lrc_Customer.GET("CW Neue Verk. an Debitorennr.") THEN
                    IF lrc_Customer."Bill-to Customer No." <> '' THEN
                        VALIDATE("CW Neue Rech. an Debitorennr.", lrc_Customer."Bill-to Customer No.")
                    ELSE
                        VALIDATE("CW Neue Rech. an Debitorennr.", "CW Neue Verk. an Debitorennr.");
            end;
        }
        field(181; "CW Neue Geschäftsbuchungsgrupp"; Code[20])
        {
            Caption = 'CW Neue Geschäftsbuchungsgrupp';
            Description = 'CW';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            var
                lrc_GenBusPostingGrp: Record "Gen. Business Posting Group";
            begin
                IF "CW Neue Geschäftsbuchungsgrupp" <> xRec."CW Neue Geschäftsbuchungsgrupp" THEN
                    IF lrc_GenBusPostingGrp.ValidateVatBusPostingGroup(lrc_GenBusPostingGrp, "CW Neue Geschäftsbuchungsgrupp") THEN
                        VALIDATE("CW Neue MwSt. Gesch. Buch. Grp", lrc_GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(182; "CW Neue MwSt. Gesch. Buch. Grp"; Code[20])
        {
            Caption = 'CW Neue MwSt. Gesch. Buch. Grp';
            Description = 'CW';
            TableRelation = "VAT Business Posting Group";
        }
        field(183; "CW Neue Debitorenbuch.Grp"; Code[20])
        {
            Caption = 'CW Neue Debitorenbuch.Grp';
            Description = 'CW';
            TableRelation = "Customer Posting Group";
        }
        field(199; "-- VSV --"; Integer)
        {
            Caption = '-- VSV --';
        }
        field(200; "VSV Cust. Price Group Code"; Code[10])
        {
            Caption = 'VSV Cust. Price Group Code';
            Description = 'VSV';
            TableRelation = "Customer Price Group";
        }
        field(201; "VSV Customer No."; Code[20])
        {
            Caption = 'VSV Customer No.';
            Description = 'VSV';
            TableRelation = Customer;
        }
        field(202; "VSV Sales Order No."; Code[20])
        {
            Caption = 'VSV Sales Order No.';
            Description = 'VSV';
        }
        field(203; "VSV Price Reference Date"; Date)
        {
            Caption = 'VSV Price Reference Date';
            Description = 'VSV';
        }
        field(204; "VSV Assortment Code"; Code[10])
        {
            Caption = 'VSV Assortment Code';
            Description = 'VSV';
        }
        field(205; "VSV Assortment Version Code"; Code[20])
        {
            Caption = 'VSV Assortment Version Code';
            Description = 'VSV';
        }
        field(206; "VSV Shipment Date"; Date)
        {
            Caption = 'VSV Shipment Date';
        }
        field(207; "VSV Location Code"; Code[10])
        {
            Caption = 'VSV Location Code';
            TableRelation = Location;
        }
        field(220; "-- KL --"; Integer)
        {
            Caption = '-- KL --';
            Description = 'KL';
        }
        field(221; "KL Item No."; Code[20])
        {
            Caption = 'KL Item No.';
            Description = 'KL';
        }
        field(222; "KL Location Code"; Code[10])
        {
            Caption = 'KL Location Code';
            Description = 'KL';
        }
        field(223; "KL Print Sorting Code"; Code[10])
        {
            Caption = 'KL Print Sorting Code';
            Description = 'KL';
        }
        field(225; "KL Doc. No."; Code[20])
        {
            Caption = 'KL Doc. No.';
            Description = 'KL';
        }
        field(226; "KL Doc. Line No."; Integer)
        {
            Caption = 'KL Doc. Line No.';
            Description = 'KL';
        }
        field(240; "-- CC --"; Integer)
        {
            Caption = '-- CC --';
            Description = 'CC';
        }
        field(241; "CC Zahlungsmittel"; Option)
        {
            Caption = 'CC Zahlungsmittel';
            OptionCaption = ' ,Bargeld,Scheck,Rechnung';
            OptionMembers = " ",Bargeld,Scheck,Rechnung;
        }
        field(260; "-- MAL --"; Integer)
        {
            Caption = '-- MAL --';
        }
        field(261; "Variety Code"; Code[20])
        {
            Caption = 'Variety Code';
        }
        field(262; "Caliber Code"; Code[20])
        {
            Caption = 'Caliber Code';
        }
        field(263; "Total Net Weight"; Decimal)
        {
            Caption = 'Total Net Weight';
        }
        field(300; "-- STOCK ITEM --"; Integer)
        {
            Caption = '-- STOCK ITEM --';
        }
        field(301; "STO Item No."; Code[20])
        {
        }
        field(350; "-- PAL --"; Integer)
        {
            Caption = '-- PE --';
        }
        field(351; "Qty. Paletts"; Integer)
        {
            BlankNumbers = BlankZero;
            Caption = 'Quantity Paletts';
            Description = 'PAL';
        }
        field(352; "Qty. Colli per Palett"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Quantity Colli per Palett';
            DecimalPlaces = 0 : 5;
            Description = 'PAL';
        }
        field(353; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            Description = 'PAL';
        }
        field(354; "Date of Expiry"; Date)
        {
            Caption = 'Date of Expiry';
            Description = 'PAL';
        }
        field(355; "Pallet Unit Code"; Code[10])
        {
            Caption = 'Paletten Einheitencode';
            Description = 'PAL';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));
        }
        field(356; "Pallet Freight Unit Code"; Code[10])
        {
            Caption = 'Pallet Freight Unit Code';
            Description = 'PAL';
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));
        }
        field(357; Owner; Text[30])
        {
            Caption = 'Owner';
            Description = 'PAL';
        }
        field(358; "Owner Comment"; Text[50])
        {
            Caption = 'Owner Comment';
            Description = 'PAL';
        }
        field(359; "Collo Unit of Measure Code"; Code[10])
        {
            Caption = 'Collo Unit of Measure Code';
            Description = 'PAL';
            Editable = false;
        }
        field(360; "Owner Vendor No."; Code[20])
        {
            Caption = 'Owner Vendor No.';
            Description = 'PAL';
            TableRelation = Vendor;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_Vendor: Record Vendor;
            begin
                IF lrc_Vendor.GET("Owner Vendor No.") THEN
                    VALIDATE(Owner, lrc_Vendor.Name);
            end;
        }
        field(361; "Pallet No."; Code[20])
        {
            Caption = 'Pallet No.';
            Description = 'PAL';
            TableRelation = "POI Pallets";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_Pallets: Record "POI Pallets";
            begin
                IF "Pallet No." <> '' THEN
                    IF lrc_Pallets.GET("Pallet No.") THEN BEGIN
                        "Pallet Unit Code" := lrc_Pallets."Pallet Unit Code";
                        "Pallet Freight Unit Code" := lrc_Pallets."Pallet Freight Unit Code";
                    END;
            end;
        }
        field(401; "BV Item No."; Code[20])
        {
            Caption = 'BV Item No.';
        }
        field(402; "BV Variant Code"; Code[10])
        {
            Caption = 'BV Variant Code';
        }
        field(403; "BV Batch Variant No."; Code[20])
        {
            Caption = 'BV Batch Variant No.';
        }
        field(405; "BV Base Unit of Measure"; Code[10])
        {
            Caption = 'BV Base Unit of Measure';
        }
        field(406; "BV Qty. per Unit"; Decimal)
        {
            Caption = 'BV Qty. per Unit';
        }
        field(407; "BV Purchase Unit of Measure"; Code[10])
        {
            Caption = 'BV Purchase Unit of Measure';
        }
        field(408; "BV Location Code"; Code[10])
        {
            Caption = 'BV Location Code';
        }
        field(409; "BV Ref. Date"; Date)
        {
            Caption = 'BV Ref. Date';
        }
        field(420; "BV Inventory"; Decimal)
        {
            Caption = 'BV Inventory';
        }
        field(430; "BV Sales Order"; Decimal)
        {
            Caption = 'BV Sales Order';
        }
        field(431; "BV Transfer Order Ship"; Decimal)
        {
            Caption = 'BV Transfer Order Ship';
        }
        field(433; "BV Pack. Input"; Decimal)
        {
            Caption = 'BV Pack. Input';
        }
        field(435; "BV Reservation FV"; Decimal)
        {
            Caption = 'BV Reservation FV';
        }
        field(440; "BV Purchase Order"; Decimal)
        {
            Caption = 'BV Purchase Order';
        }
        field(441; "BV Transfer Order Rec"; Decimal)
        {
            Caption = 'BV Transfer Order Rec';
        }
        field(443; "BV Pack. Output"; Decimal)
        {
            Caption = 'BV Pack. Output';
        }
        field(500; "-- RECHNUNGSABGRENZUNG --"; Integer)
        {
        }
        field(501; "ABGR Ab Datum"; Date)
        {
        }
        field(502; "ABGR Anzahl Perioden"; Integer)
        {
        }
        field(503; "ABGR Bis Datum"; Date)
        {
        }
        field(504; "ABGR Gegenkontonr."; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(505; "ABGR Auflösungskonto"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(550; "-- NEW SALES ORDER"; Integer)
        {
        }
        field(551; "NSO Document Type"; Option)
        {
            Caption = 'NSO Document Type';
            Description = 'NSO New Sales Order';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(552; "NSO Document No."; Code[20])
        {
            Caption = 'NSO Document No.';
            Description = 'NSO New Sales Order';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FIELD("NSO Document Type"));

            trigger OnValidate()
            var
                lrc_SalesHeader: Record "Sales Header";
                lrc_Customer: Record Customer;
            begin
                IF "NSO Document No." <> '' THEN BEGIN
                    lrc_SalesHeader.GET("NSO Document Type", "NSO Document No.");
                    lrc_SalesHeader.TESTFIELD("Sell-to Customer No.");

                    lrc_Customer.GET(lrc_SalesHeader."Sell-to Customer No.");

                    "NSO Sell-to Cust. No." := lrc_SalesHeader."Sell-to Customer No.";
                    "NSO Sell-to Cust. Search Name" := lrc_Customer."Search Name";
                    "NSO Sales Doc. Subtype Code" := lrc_SalesHeader."POI Sales Doc. Subtype Code";
                    "NSO Promised Delivery Date" := lrc_SalesHeader."Promised Delivery Date";
                    "NSO Shipment Method Code" := lrc_SalesHeader."Shipment Method Code";
                END;
            end;
        }
        field(553; "NSO Sell-to Cust. No."; Code[20])
        {
            Caption = 'NSO Sell-to Cust. No.';
            Description = 'NSO New Sales Order';
            TableRelation = Customer;

            trigger OnValidate()
            var
                lrc_Customer: Record Customer;
            begin
                IF lrc_Customer.GET("NSO Sell-to Cust. No.") THEN BEGIN
                    "NSO Shipment Method Code" := lrc_Customer."Shipment Method Code";
                    "NSO Currency Code" := lrc_Customer."Currency Code";
                    "NSO Sell-to Cust. Search Name" := lrc_Customer."Search Name";
                END ELSE BEGIN
                    "NSO Shipment Method Code" := '';
                    "NSO Currency Code" := '';
                    "NSO Sell-to Cust. Search Name" := '';
                END;
            end;
        }
        field(554; "NSO Sell-to Cust. Search Name"; Text[100])
        {
            Caption = 'NSO Sell-to Cust. Search Name';
            Description = 'NSO New Sales Order';
        }
        field(555; "NSO Sales Doc. Subtype Code"; Code[10])
        {
            Caption = 'NSO Sales Doc. Subtype Code';
            Description = 'NSO New Sales Order';
            TableRelation = "POI Sales Doc. Subtype".Code WHERE("Document Type" = FIELD("NSO Document Type"));
        }
        field(557; "NSO Currency Code"; Code[10])
        {
            Caption = 'Währungscode';
            Description = 'NSO New Sales Order';
            TableRelation = Currency;
        }
        field(558; "NSO Shipment Method Code"; Code[10])
        {
            Caption = 'Lieferbedingung';
            Description = 'NSO New Sales Order';
            TableRelation = "Shipment Method";
        }
        field(559; "NSO Shipment Date"; Date)
        {
            Caption = 'NSO Shipment Date';
            Description = 'NSO New Sales Order';
        }
        field(560; "NSO Promised Delivery Date"; Date)
        {
            Caption = 'NSO Promised Delivery Date';
            Description = 'NSO New Sales Order';
        }
        field(566; "-- FROM TRANSFER ORDER"; Integer)
        {
        }
        field(567; "FTO Document No."; Code[20])
        {
            Caption = 'FTO Document No.';
            TableRelation = "Transfer Header";

            trigger OnValidate()
            var
                lrc_TransferHeader: Record "Transfer Header";
            begin
                IF lrc_TransferHeader.GET("NTO Document No.") THEN BEGIN
                    "NTO Transfer Doc. Subtype Code" := lrc_TransferHeader."POI Transfer Doc. Subtype Code";
                    "NTO Transfer-From Loc." := lrc_TransferHeader."Transfer-from Code";
                    "NTO Transfer-To Loc." := lrc_TransferHeader."Transfer-to Code";
                    "NTO Shipment Date" := lrc_TransferHeader."Shipment Date";
                    "NTO Receipt Date" := lrc_TransferHeader."Receipt Date";
                    "NTO Shipping Agent Code" := lrc_TransferHeader."Shipping Agent Code";
                END;
            end;
        }
        field(568; "FTO Document Line No."; Integer)
        {
            Caption = 'FTO Document Line No.';
            TableRelation = "Transfer Line"."Line No." WHERE("Document No." = FIELD("FTO Document No."),
                                                              "Derived From Line No." = CONST(0));

            trigger OnValidate()
            var
                lrc_TransferLine: Record "Transfer Line";
            begin
                IF lrc_TransferLine.GET("FTO Document No.", "FTO Document Line No.") THEN
                    "NTO Splitt Qty." := lrc_TransferLine.Quantity - lrc_TransferLine."Quantity Shipped";
            end;
        }
        field(571; "NTO Document No."; Code[20])
        {
            Caption = 'NTO Document No.';
            Description = 'NTO New Transfer Order';
            TableRelation = "Transfer Header";

            trigger OnValidate()
            var
                lrc_TransferHeader: Record "Transfer Header";
            begin
                IF lrc_TransferHeader.GET("NTO Document No.") THEN BEGIN
                    "NTO Transfer Doc. Subtype Code" := lrc_TransferHeader."POI Transfer Doc. Subtype Code";
                    "NTO Transfer-From Loc." := lrc_TransferHeader."Transfer-from Code";
                    "NTO Transfer-To Loc." := lrc_TransferHeader."Transfer-to Code";
                    "NTO Shipment Date" := lrc_TransferHeader."Shipment Date";
                    "NTO Receipt Date" := lrc_TransferHeader."Receipt Date";
                    "NTO Shipping Agent Code" := lrc_TransferHeader."Shipping Agent Code";
                END;
            end;
        }
        field(572; "NTO Document Line No."; Integer)
        {
            Caption = 'NTO Document Line No.';
            TableRelation = "Transfer Line"."Line No." WHERE("Document No." = FIELD("NTO Document No."),
                                                              "Derived From Line No." = CONST(0));

            trigger OnValidate()
            var
                lrc_TransferLine: Record "Transfer Line";
                lrc_TransferLine2: Record "Transfer Line";
                AgilesText001Txt: Label 'Die Generierungsart muss %1 oder %2 sein !', Comment = '%1 %2';
            begin
                IF lrc_TransferLine.GET("FTO Document No.", "FTO Document Line No.") THEN
                    IF lrc_TransferLine2.GET("NTO Document No.", "NTO Document Line No.") THEN BEGIN

                        // Merkmale müssen passen
                        lrc_TransferLine2.TESTFIELD("POI Automatically Generated", TRUE);
                        // lrc_TransferLine2.TESTFIELD( "Generation Type", lrc_TransferLine2."Generation Type"::"New Item" );
                        IF (lrc_TransferLine2."POI Generation Type" <> lrc_TransferLine2."POI Generation Type"::"New Item") AND
                           (lrc_TransferLine2."POI Generation Type" <> lrc_TransferLine2."POI Generation Type"::"Additional Quantity") THEN
                            ERROR(AgilesText001Txt, lrc_TransferLine2."POI Generation Type"::"New Item", lrc_TransferLine2."POI Generation Type"::"Additional Quantity");

                        lrc_TransferLine2.TESTFIELD("Item No.", lrc_TransferLine."Item No.");

                        IF lrc_TransferLine."POI Country of Origin Code" <> '' THEN
                            lrc_TransferLine2.TESTFIELD("POI Country of Origin Code", lrc_TransferLine."POI Country of Origin Code");


                        IF lrc_TransferLine."POI Variety Code" <> '' THEN
                            lrc_TransferLine2.TESTFIELD("POI Variety Code", lrc_TransferLine."POI Variety Code");


                        IF lrc_TransferLine."POI Item Attribute 4" <> '' THEN
                            lrc_TransferLine2.TESTFIELD("POI Item Attribute 4", lrc_TransferLine."POI Item Attribute 4");


                        IF lrc_TransferLine."POI Trans Unit of Measure (TU)" <> '' THEN
                            lrc_TransferLine2.TESTFIELD("POI Trans Unit of Measure (TU)", lrc_TransferLine."POI Trans Unit of Measure (TU)");

                        IF lrc_TransferLine."POI Qty.(Unit) per Transp.(TU)" <> 0 THEN
                            lrc_TransferLine2.TESTFIELD("POI Qty.(Unit) per Transp.(TU)", lrc_TransferLine."POI Qty.(Unit) per Transp.(TU)");
                    end;
            end;
        }
        field(573; "NTO Transfer Doc. Subtype Code"; Code[10])
        {
            Caption = 'NTO Transfer Doc. Subtype Code';
            Description = 'NTO New Transfer Order';
            TableRelation = "POI Transfer Doc. Subtype";

            trigger OnValidate()
            var
                lrc_TransferDocSubtype: Record "POI Transfer Doc. Subtype";
            begin
                IF lrc_TransferDocSubtype.GET("NTO Transfer Doc. Subtype Code") THEN BEGIN
                    "NTO Transfer-From Loc." := lrc_TransferDocSubtype."From Location Code";
                    "NTO Transfer-To Loc." := lrc_TransferDocSubtype."To Location Code";

                    IF lrc_TransferDocSubtype."Shipping Agent Code" <> '' THEN
                        "NTO Shipping Agent Code" := lrc_TransferDocSubtype."Shipping Agent Code";
                END;
            end;
        }
        field(574; "NTO Transfer-From Loc."; Code[10])
        {
            Caption = 'NTO Transfer-From Loc.';
            TableRelation = Location;
        }
        field(575; "NTO Transfer-To Loc."; Code[10])
        {
            Caption = 'NTO Transfer-To Loc.';
            TableRelation = Location;
        }
        field(576; "NTO Splitt Qty."; Decimal)
        {
            Caption = 'NTO Splitt Quantity';
            MinValue = 0;

            trigger OnValidate()
            var
                lrc_TransferLine: Record "Transfer Line";
            begin
                IF lrc_TransferLine.GET("FTO Document No.", "FTO Document Line No.") THEN
                    IF "NTO Splitt Qty." > (lrc_TransferLine.Quantity - lrc_TransferLine."Quantity Shipped") THEN
                        ERROR('Splittmenge %1 darf nicht größer als Restauftragsmenge %2 sein !',
                           "NTO Splitt Qty.", lrc_TransferLine.Quantity - lrc_TransferLine."Quantity Shipped");
            end;
        }
        field(580; "NTO Shipment Date"; Date)
        {
            Caption = 'NTO Shipment Date';
            Description = 'NTO New Transfer Order';
        }
        field(581; "NTO Receipt Date"; Date)
        {
            Caption = 'NTO Receipt Date';
            Description = 'NTO New Transfer Order';
        }
        field(585; "NTO Shipping Agent Code"; Code[10])
        {
            Caption = 'NTO Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(586; "-- NEW RESERVATION ORDER --"; Integer)
        {
        }
        field(587; "NRO Document No."; Code[20])
        {
            Caption = 'Reservation Document No.';
            Description = 'NRO New Reservation Order';
            //TableRelation = "Reservation Header"; //TODO: reservation Header
        }
        field(588; "NRO Typ of Reservation"; Option)
        {
            Caption = 'Typ of Reservation';
            OptionCaption = 'Sale,Transfer,Packerei,Feature Assortment,Block Goods,User Internal,Other';
            OptionMembers = Sale,Transfer,Packerei,"Feature Assortment","Block Goods","User Internal",Other;
        }
        field(589; "NRO No. of Reservation"; Code[20])
        {
            Caption = 'NRO No. of Reservation';
            TableRelation = IF ("NRO Typ of Reservation" = CONST(Sale)) Customer
            ELSE
            IF ("NRO Typ of Reservation" = CONST(Transfer)) Location;
        }
        field(590; "NRO Reserved Up To Date"; Date)
        {
            Caption = 'Reserved Up To Date';
        }
        field(591; "NRO Reserved Up To Time"; Time)
        {
            Caption = 'Reserved Up To Time';
        }
        field(592; "NRO Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(593; "NRO Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(594; "NRO Your Reference"; Text[70])
        {
            Caption = 'Your Reference';
        }
        field(595; "NRO From Location"; Code[10])
        {
            Caption = 'NRO From Location';
        }
        field(600; "-- LOC  BATCH VAR --"; Integer)
        {
        }
        field(601; "LB Batch Variant Code"; Code[20])
        {
            Caption = 'Batch Variant Code';
        }
        field(602; "LB Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
        field(603; "LB Location Name"; Text[30])
        {
            Caption = 'Location Name';
        }
        field(608; "LB Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(610; "LB Qty. Avail. Colli"; Decimal)
        {
            Caption = 'Qty. Avail. Colli';
        }
        field(612; "LB Qty. Exp. Avail. Colli"; Decimal)
        {
            Caption = 'Qty. Exp. Avail. Colli';
        }
        field(613; "LB Qty. Avail. Pallets"; Decimal)
        {
            Caption = 'Qty. Avail. Pallets';
        }
        field(614; "LB Qty. Exp. Avail. Pallets"; Decimal)
        {
            Caption = 'Qty. Avail. Pallets';
        }
        field(700; "AGGBATCH Item No."; Code[20])
        {
        }
        field(701; "AGGBATCH Caliber Code"; Code[10])
        {
        }
        field(702; "AGGBATCH Trademark Code"; Code[20])
        {
        }
        field(703; "AGGBATCH Unit of Measure Code"; Code[10])
        {
        }
        field(704; "AGGBATCH Variety Code"; Code[10])
        {
        }
        field(705; "AGGBATCH Country Code"; Code[10])
        {
        }
        field(720; "AGGBATCH Batch No."; Code[20])
        {
        }
        field(750; "PD Vendor No."; Code[20])
        {
            Description = 'PD=Per Document';
        }
        field(754; "PD Transaction No."; Integer)
        {
            Description = 'PD=Per Document';
        }
        field(755; "PD Posting Date"; Date)
        {
            Description = 'PD=Per Document';
        }
        field(756; "PD Document No."; Code[20])
        {
            Description = 'PD=Per Document';
        }
        field(757; "PD Ext. Document No."; Code[20])
        {
            Description = 'PD=Per Document';
        }
        field(760; "PD Amount (LCY)"; Decimal)
        {
            Description = 'PD=Per Document';
        }
        field(5110435; "Info 1"; Code[30])
        {
            CaptionClass = '5110300,1,1';
            Caption = 'Info 1';
            Description = 'PAL';
        }
        field(5110436; "Info 2"; Code[30])
        {
            CaptionClass = '5110300,1,2';
            Caption = 'Info 2';
            Description = 'PAL';
        }
        field(5110437; "Info 3"; Code[20])
        {
            CaptionClass = '5110300,1,3';
            Caption = 'Info 3';
            Description = 'PAL';
        }
        field(5110438; "Info 4"; Code[20])
        {
            CaptionClass = '5110300,1,4';
            Caption = 'Info 4';
            Description = 'PAL';
        }
        field(5110450; "Qty Lines"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "User ID", "Entry Type", "Entry No.")
        {
        }
        key(Key2; "KL Item No.")
        {
        }
        key(Key3; "Variety Code", "Caliber Code")
        {
        }
        key(Key4; "AGGBATCH Item No.", "AGGBATCH Caliber Code", "AGGBATCH Trademark Code", "AGGBATCH Unit of Measure Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Entry No." = 0 THEN BEGIN
            lrc_FruitVisionTempI.SETRANGE("User ID", USERID());
            lrc_FruitVisionTempI.SETRANGE("Entry Type", "Entry Type");
            IF lrc_FruitVisionTempI.FIND('+') THEN
                "Entry No." := lrc_FruitVisionTempI."Entry No." + 1
            ELSE
                "Entry No." := 1;
        END;
    end;

    var
        lrc_FruitVisionTempI: Record "POI ADF Temp I";
}

