tableextension 50009 "POI Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(50000; "POI Adv. Pay. Rem. Amt (LCY)"; Decimal)
        {
            CalcFormula = - Sum ("POI Adv. Pay. Vendor"."Remaining Amount (LCY)" WHERE("Vendor No." = FIELD("Buy-from Vendor No."),
                                                                                  "Master Batch No." = FIELD("POI Master Batch No.")));
            Caption = 'Adv. Pay. Rem. Amount (LCY)';
            Description = 'VFI';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "POI Einkaufsfracht"; Decimal)
        {

            trigger OnValidate()
            var
                ldc_DocNo: Integer;
            begin
                //RS Plankostensatz für LKW-Fracht anlegen
                IF xRec."POI Einkaufsfracht" = 0 THEN BEGIN
                    IF lrc_CostCalcEnterData.FINDLAST() THEN
                        ldc_DocNo := lrc_CostCalcEnterData."Document No." + 1;
                    lrc_CostCalcEnterData.RESET();
                    lrc_CostCalcEnterData.INit();
                    lrc_CostCalcEnterData."Document No." := ldc_DocNo;
                    lrc_CostCalcEnterData.INSERT();
                    lrc_CostCalcEnterData.VALIDATE("Cost Category Code", 'LKWFRACHT');
                    lrc_CostCalcEnterData.VALIDATE("Master Batch No.", "No.");
                    lrc_CostCalcEnterData.VALIDATE("Entry Level", lrc_CostCalcEnterData."Entry Level"::"Master Batch");
                    lrc_CostCalcEnterData.VALIDATE("Entry Type", lrc_CostCalcEnterData."Entry Type"::"Enter Data");
                    lrc_CostCalcEnterData.VALIDATE(Amount, "POI Einkaufsfracht");
                    lrc_CostCalcEnterData.MODIFY();
                END ELSE BEGIN
                    //Plankostensatz aktualisieren
                    lrc_CostCalcEnterData.SETRANGE("Master Batch No.", "No.");
                    lrc_CostCalcEnterData.SETRANGE(lrc_CostCalcEnterData."Cost Category Code", 'LKWFRACHT');
                    lrc_CostCalcEnterData.SETRANGE(lrc_CostCalcEnterData."Amount (LCY)", xRec."POI Einkaufsfracht");
                    IF lrc_CostCalcEnterData.FINDSET(TRUE, FALSE) THEN BEGIN
                        lrc_CostCalcEnterData.VALIDATE(Amount, "POI Einkaufsfracht");
                        lrc_CostCalcEnterData.MODIFY();
                    END;
                END;
            end;
        }
        field(50010; "POI Released for Claim"; Boolean)
        {
            Caption = 'Claim abgerechnet';
            Description = 'Port.jst 27.7. Zusatz';
        }
        field(50011; "POI Claim Document Date"; Date)
        {
            CalcFormula = Lookup ("POI Purch. Claim Notify Header"."Document Date" WHERE("Purch. Order No." = FIELD("No.")));
            Caption = 'Claim Belegdatum';
            FieldClass = FlowField;
        }
        field(50012; "POI Avise"; Boolean)
        {
        }
        field(50020; "POI Gutschriftsverfahren"; Boolean)
        {
        }
        field(50050; "POI Destination Country Code"; Code[10])
        {
            Caption = 'Zielland';
            TableRelation = "Country/Region" WHERE("POI EU Standard" = FILTER(true));

            trigger OnValidate()  //TODO: Zielland prüfen
            var
                CompInfo: Record "Company Information";
                Location: Record Location;
                LTXT_DestCountryCodeTxt: Label 'ACHTUNG!\Bei P I Dutch Growers muss das Zielland - NL - sein.';
                lint_no: Integer;
            begin
                IF COMPANYNAME() = 'P I Dutch Growers' THEN
                    IF "POI Destination Country Code" <> 'NL' THEN
                        ERROR(LTXT_DestCountryCodeTxt);

                IF Rec."POI Destination Country Code" <> xRec."POI Destination Country Code" THEN BEGIN
                    PurchLine.SETRANGE("Document Type", "Document Type");
                    PurchLine.SETRANGE("Document No.", "No.");
                    IF PurchLine.FIND('-') THEN BEGIN
                        IF PurchLine."Location Code" <> '' THEN
                            Location.GET(PurchLine."Location Code");
                        IF "POI Destination Country Code" <> Location."Country/Region Code" THEN BEGIN
                            REPEAT
                                PurchLine.VALIDATE("Location Code", '');
                                PurchLine.MODIFY(TRUE);
                                lint_no += 1;
                            UNTIL PurchLine.NEXT() = 0;
                            IF lint_no > 1 THEN BEGIN
                                MESSAGE('Sie müssen die Ziellagerorte in den Einkaufszeilen aktualisieren, die bisherigen Lagerorte sind gelöscht');
                                MESSAGE('Sie müssen den Lieferanten informieren, dass die Rechnung aus steuerlichen Gründen anders gestellt werden muss!');
                            END ELSE BEGIN
                                MESSAGE('Sie müssen den Ziellagerort in der Einkaufszeile aktualisieren, der bisherige Lagerort ist gelöscht');
                                MESSAGE('Sie müssen den Lieferanten informieren, dass die Rechnung aus steuerlichen Gründen anders gestellt werden muss!');
                            END;
                        END;
                    END;
                END;

                IF CompInfo.GET("POI Destination Country Code") THEN
                    "POI Our VAT Registration No." := CompInfo."VAT Registration No.";
            end;
        }
        field(50051; "POI EU Dreiecksgeschäft"; Boolean)
        {
        }
        field(50060; "POI Departure Location Code"; Code[10])
        {
            Caption = 'Abgangslager';
            TableRelation = Location;

            trigger OnValidate()
            var
                Location: Record Location;
                LocationHELP: Record Location;

                Vend: Record Vendor;
                CountryRegion: Record "Country/Region";
                LTXT50000Txt: Label 'Der Lieferant ist im Land %1 nicht registriert. Bitte überprüfen Sie ob der Abgangslager korrekt ist.', Comment = '%1';
            begin
                //länderspezifische USt-ID
                IF "POI Departure Location Code" <> '' THEN BEGIN
                    Location.GET("POI Departure Location Code");
                    IF Location."POI Blocked" > Location."POI Blocked"::" " THEN
                        ERROR('Der Lagerort %1 ist gesperrt.', "POI Departure Location Code");
                    IF CountryRegion.GET(Location."Country/Region Code") AND (CountryRegion."EU Country/Region Code" <> '') THEN BEGIN
                        VATRegNoVendCust.RESET();
                        VATRegNoVendCust.SETRANGE("Vendor/Customer", "Buy-from Vendor No.");
                        VATRegNoVendCust.SETRANGE("Country Code", Location."Country/Region Code");
                        IF VATRegNoVendCust.FINDFIRST() THEN
                            "VAT Registration No." := VATRegNoVendCust."VAT Registration No."
                        ELSE
                            ERROR(LTXT50000Txt, Location."Country/Region Code");
                    END;
                END ELSE BEGIN
                    Vend.GET("Pay-to Vendor No.");
                    "VAT Registration No." := Vend."VAT Registration No.";
                END;

                IF ((xRec."POI Departure Location Code" <> '') AND
                  (xRec."POI Departure Location Code" <> Rec."POI Departure Location Code"))
                THEN BEGIN
                    Location.GET(xRec."POI Departure Location Code");
                    LocationHELP.GET(Rec."POI Departure Location Code");
                    IF Location."Country/Region Code" <> LocationHELP."Country/Region Code" THEN BEGIN
                        IF NOT CONFIRM('Achtung Abgangsland geändert! Bitte Lieferanten informieren, dass steuerlich anders abgerechnet werden muss.',
                          FALSE)
                        THEN
                            ERROR('Abgangslager nicht geändert.')
                        ELSE BEGIN
                            PurchLine.RESET();
                            PurchLine.SETRANGE("Document Type", "Document Type");
                            PurchLine.SETRANGE("Document No.", "No.");
                            IF PurchLine.FINDSET() THEN
                                REPEAT
                                    GGNBatch.RESET();
                                    GGNBatch.SETRANGE(GGNBatch."Batch No.", PurchLine."POI Batch Variant No.");
                                    IF GGNBatch.FINDFIRST() THEN BEGIN
                                        GGNBatch."Departure Location Code" := "POI Departure Location Code";
                                        GGNBatch.MODIFY();
                                    END;
                                UNTIL PurchLine.NEXT() = 0;
                        END;
                    END ELSE BEGIN
                        PurchLine.RESET();
                        PurchLine.SETRANGE("Document Type", "Document Type");
                        PurchLine.SETRANGE("Document No.", "No.");
                        IF PurchLine.FINDSET() THEN
                            REPEAT
                                GGNBatch.RESET();
                                GGNBatch.SETRANGE(GGNBatch."Batch No.", PurchLine."POI Batch Variant No.");
                                IF GGNBatch.FINDFIRST() THEN BEGIN
                                    GGNBatch."Departure Location Code" := "POI Departure Location Code";
                                    GGNBatch.MODIFY();
                                END;
                            UNTIL PurchLine.NEXT() = 0;
                    END;
                END;
            end;
        }
        field(50070; "POI Our VAT Registration No."; Code[20])
        {
            Caption = 'Unsere USt-IdNr.';

            trigger OnLookup()
            var
                CompInfo: Record "Company Information";

                l_Company: Text[50];
            begin
                IF NOT POIFunction.CheckUserInRole('FB KREDITOR W', 0) THEN
                    ERROR(ERR_NoPermissionTxt);

                IF CompInfo.GET("POI Destination Country Code") THEN BEGIN //TODO: Mandanten???

                    IF STRPOS(CompInfo.Name, 'International GmbH') <> 0 THEN
                        l_Company := 'Port International GmbH';

                    IF STRPOS(CompInfo.Name, 'Dutch') <> 0 THEN
                        l_Company := 'Port International Dutch Growers B.V.';

                    IF STRPOS(CompInfo.Name, 'Organics') <> 0 THEN
                        l_Company := 'Port International Organics GmbH';

                    IF STRPOS(CompInfo.Name, 'Bananas') <> 0 THEN
                        l_Company := 'Port International Bananas GmbH';

                    IF STRPOS(CompInfo.Name, 'Sourcing') <> 0 THEN
                        l_Company := 'Port International European';

                    IF STRPOS(CompInfo.Name, 'Fruit') <> 0 THEN
                        l_Company := 'Port International Fruit GmbH';

                    IF l_Company <> '' THEN BEGIN
                        Cust.RESET();
                        Cust.SETRANGE(Name, l_Company);
                        IF Cust.FINDFIRST() THEN BEGIN
                            VATRegNoVendCust.RESET();
                            VATRegNoVendCust.SETRANGE(VATRegNoVendCust."Vendor/Customer", Cust."No.");
                            IF VATRegNoVendCust.FINDSET() THEN
                                IF Page.RUNMODAL(Page::"POI VAT Registr. No. Vend/Cust", VATRegNoVendCust) = ACTION::LookupOK THEN
                                    "POI Our VAT Registration No." := VATRegNoVendCust."VAT Registration No.";
                        END;
                    END;
                END;
            end;
        }
        field(50100; "POI Original Invoice Amount"; Decimal)
        {
        }
        field(50101; "POI Reason Code"; Option)
        {
            OptionMembers = " ","falsche Firmierung","fehlende oder falsche UST-ID Lieferant","fehlende oder falsche USt-ID Port","fehlende o. falsche Steuertexte",Preisdifferenz,"Kosten nicht abgezogen",Mengendifferenz,"fehlende Rabatte","Auflösung","Teilauflösung";
            trigger OnValidate()
            begin
                CASE "POI Reason Code" OF
                    "POI Reason Code"::"falsche Firmierung":
                        "On Hold" := 'FFI';
                    "POI Reason Code"::"fehlende oder falsche UST-ID Lieferant":
                        "On Hold" := 'FUL';
                    "POI Reason Code"::"fehlende oder falsche USt-ID Port":
                        "On Hold" := 'FUP';
                    "POI Reason Code"::"fehlende o. falsche Steuertexte":
                        "On Hold" := 'FTX';
                    "POI Reason Code"::Preisdifferenz:
                        "On Hold" := 'PDI';
                    "POI Reason Code"::"Kosten nicht abgezogen":
                        "On Hold" := 'KNA';
                    "POI Reason Code"::Mengendifferenz:
                        "On Hold" := 'QTY';
                    "POI Reason Code"::"fehlende Rabatte":
                        "On Hold" := 'FRA';
                    "POI Reason Code"::Auflösung:
                        "On Hold" := 'AUF';
                    "POI Reason Code"::Teilauflösung:
                        "On Hold" := 'TAU';
                    ELSE
                        "On Hold" := '';
                END;
            end;
        }
        field(50105; "POI Applies to Difference"; Code[20])
        {
            Caption = 'Ausgleich mit Differenz';

            trigger OnLookup()
            var
                lfm_DiffPosten: Page "POI Difference Entry List";
            begin
                lrc_DiffPosten.SETCURRENTKEY(CustomerVendorNo, Source);
                lrc_DiffPosten.SETRANGE(CustomerVendorNo, "Buy-from Vendor No.");
                lrc_DiffPosten.SETRANGE(Source, lrc_DiffPosten.Source::Vendor);
                lrc_DiffPosten.SETRANGE(open, TRUE);
                IF "POI Applies to Difference" <> '' THEN BEGIN
                    lrc_DiffPosten.SETRANGE(DocumentNo, "POI Applies to Difference");
                    lrc_DiffPosten.FINDFIRST();
                END;

                lfm_DiffPosten.SETTABLEVIEW(lrc_DiffPosten);
                lfm_DiffPosten.SETRECORD(lrc_DiffPosten);
                lfm_DiffPosten.LOOKUPMODE(TRUE);
                IF lfm_DiffPosten.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                    lfm_DiffPosten.GetDiffLedgEntry(lrc_DiffPosten);
                    "POI Applies to Difference" := lrc_DiffPosten.DocumentNo;
                END;
                CLEAR(lfm_DiffPosten);
            end;

            trigger OnValidate()
            begin
                IF "POI Applies to Difference" <> xRec."POI Applies to Difference" THEn
                    IF "POI Applies to Difference" <> '' THEN BEGIN
                        lrc_DiffPosten.Reset();
                        lrc_Diffposten.SETRANGE(Source, lrc_Diffposten.Source::Vendor);
                        lrc_Diffposten.SETRANGE(CustomerVendorNo, "Buy-from Vendor No.");
                        lrc_Diffposten.SETRANGE(open, TRUE);
                        lrc_Diffposten.SETRANGE(DocumentNo, "POI Applies to Difference");
                        IF lrc_Diffposten.FINDSET(TRUE, FALSE) THEN BEGIN
                            lrc_Diffposten.AppliesToID := "No.";
                            lrc_Diffposten.MODIFY();
                        END ELSE
                            "POI Applies to Difference" := '';
                    END ELSE BEGIN
                        lrc_DiffPosten.Reset();
                        lrc_Diffposten.SETRANGE(Source, lrc_Diffposten.Source::Vendor);
                        lrc_Diffposten.SETRANGE(CustomerVendorNo, "Buy-from Vendor No.");
                        lrc_Diffposten.SETRANGE(AppliesToID, "No.");
                        IF lrc_Diffposten.FINDSET(TRUE, FALSE) THEN BEGIN
                            lrc_Diffposten.AppliesToID := '';
                            lrc_Diffposten.MODIFY();
                        END ELSE
                            "POI Applies to Difference" := '';
                    END;
            end;
        }
        field(50110; "POI open Differences"; Decimal)
        {
            CalcFormula = Sum ("POI Difference Entry".RemainingAmountLCY WHERE(Source = CONST(Vendor),
                                                                        CustomerVendorNo = FIELD("Buy-from Vendor No.")));
            Editable = false;
            FieldClass = FlowField;
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
        field(5110305; "POI Document Status"; Option)
        {
            Caption = 'Document Status';
            OptionCaption = 'Offen,Avis Export to Whse.,,Freigabe Wareneingang,,,Eingangskommissionierung,,,Lieferschein,,,Rückerfassung,,,Freigabe Fakturierung,,,,Abgeschlossen,Dimensionen gesperrt,,Manuell Abgeschlossen,,,Storniert,,,Gelöscht';
            OptionMembers = Offen,"Avis Export to Whse.",,"Freigabe Wareneingang",,,Eingangskommissionierung,,,Lieferschein,,,"Rückerfassung",,,"Freigabe Fakturierung",,,,Abgeschlossen,"Dimensionen gesperrt",,"Manuell Abgeschlossen",,,Storniert,,,"Gelöscht";

            trigger OnValidate()
            var
                L_tab39: Record "Purchase Line";
            begin
                IF xRec."POI Document Status" = "POI Document Status"::Abgeschlossen THEN BEGIN
                    L_tab39.SETCURRENTKEY("Document Type", "Document No.", "Quantity Invoiced");
                    L_tab39.SETRANGE("Document Type", "Document Type");
                    L_tab39.SETRANGE("Document No.", "No.");
                    L_tab39.SETFILTER("Quantity Invoiced", '<>0');
                    IF not L_tab39.isempty() THEN
                        ERROR('Keine Änderung am Status, ist schon abgeschlossen ;)');
                END;
            end;
        }
        field(5110306; "POI Person in Charge Code"; Code[20])
        {
            Caption = 'Person in Charge Code';
            TableRelation = "Salesperson/Purchaser"; //WHERE ("inactive NAV User"=FILTER(No));

            trigger OnLookup()
            var
                lr_SalesPurch: Record "Salesperson/Purchaser";
            begin
                lr_SalesPurch.FILTERGROUP(2);
                lr_SalesPurch.SETRANGE("POI Is Person in Charge", TRUE);
                lr_SalesPurch.FILTERGROUP(0);
                IF Page.RUNMODAL(0, lr_SalesPurch) = ACTION::LookupOK THEN
                    VALIDATE("POI Person in Charge Code", lr_SalesPurch.Code);
            end;

            trigger OnValidate()
            var
                lr_SalesPurch: Record "Salesperson/Purchaser";
            begin
                IF lr_SalesPurch.GET("POI Person in Charge Code") THEN;
            end;
        }
        field(5110307; "POI Kind of Settlement"; Option)
        {
            Caption = 'Kind of Settlement';
            Description = 'Fix Price(Invoice),Commission,Fix Price(Credit Memo)';
            OptionCaption = 'Fix Price(Invoice),Commission,Fix Price(Credit Memo)';
            OptionMembers = "Fix Price(Invoice)",Commission,"Fix Price(Credit Memo)";

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("POI Kind of Settlement") THEN
                    UpdatePurchLines(Copystr(FIELDCAPTION("POI Kind of Settlement"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110308; "POI Cost Schema Name Code"; Code[20])
        {
            Caption = 'Cost Schema Name Code';
            TableRelation = "POI Cost Schema Name";

            trigger OnValidate()
            var
                lrc_MasterBatch: Record "POI Master Batch";
            begin
                IF "POI Master Batch No." <> '' THEN BEGIN
                    lrc_MasterBatch.GET("POI Master Batch No.");
                    lrc_MasterBatch."Cost Schema Name Code" := "POI Cost Schema Name Code";
                    lrc_MasterBatch.MODIFY();
                END;
            end;
        }
        field(5110309; "POI Purch. Doc. Subtype Detail"; Option)
        {
            Caption = 'Purch. Doc. Subtype Detail';
            OptionCaption = ' ,Invoice of Expences,Credit Memo of Expences';
            OptionMembers = " ","Invoice of Expences","Credit Memo of Expences";
        }
        field(5110311; "POI Waste Disposal Duty"; Option)
        {
            Caption = 'Waste Disposal Duty';
            Description = 'DSD';
            OptionCaption = ' ,Green Point Duty';
            OptionMembers = " ","Green Point Duty";

            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Waste Disposal Duty"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110312; "POI Waste Disposal Paymt Thru"; Option)
        {
            Caption = 'Waste Disposal Payment Thru';
            Description = 'DSD';
            OptionCaption = 'Us,Vendor';
            OptionMembers = Us,Vendor;

            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Waste Disposal Paymt Thru"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110318; "POI Company Season Code"; Code[10])
        {
            Caption = 'Company Season Code';
            //TableRelation = "POI Company Season";
        }
        field(5110320; "POI Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;

            trigger OnValidate()
            var
                lrc_Vendor: Record Vendor;
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Manufacturer Code"), 1, 100), CurrFieldNo <> 0);

                IF "POI Manufacturer Code" <> '' THEN BEGIN
                    lrc_Vendor.GET("POI Manufacturer Code");
                    "POI Producer Name" := lrc_Vendor.Name;
                END ELSe
                    "POI Producer Name" := '';


                lrc_PurchaseLine.RESET();
                lrc_PurchaseLine.SETRANGE("Document Type", "Document Type");
                lrc_PurchaseLine.SETRANGE("Document No.", "No.");
                lrc_PurchaseLine.SETFILTER("No.", '<>%1', '');
                IF lrc_PurchaseLine.FINDSET(TRUE, FALSE) THEN
                    REPEAT
                        IF "POI Manufacturer Code" <> '' THEN
                            lrc_PurchaseLine."POI Member State Companionship" := lrc_Vendor."POI Member State Companionship"
                        ELSE
                            lrc_PurchaseLine."POI Member State Companionship" := lrc_PurchaseLine."POI Member State Companionship"::" ";
                        lrc_PurchaseLine.MODIFY();
                    UNTIL lrc_PurchaseLine.NEXT() = 0;
            end;
        }
        field(5110319; "POI Manufacturer Lot No."; Code[20])
        {
            Caption = 'Manufacturer Lot No.';

            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Manufacturer Lot No."), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110321; "POI Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            NotBlank = true;
            TableRelation = "POI Master Batch";
        }
        field(5110324; "POI Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            Description = 'EIA';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Country of Origin Code"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110325; "POI Cultivation Associat. Code"; Code[10])
        {
            Caption = 'Cultivation Association Code';
            TableRelation = "POI Cultivation Association";

            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Cultivation Associat. Code"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110340; "POI Total Gross Weight"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("Purchase Line"."POI Total Gross Weight" WHERE("Document Type" = FIELD("Document Type"),
                                                                          "Document No." = FIELD("No.")));
            Caption = 'Total Gross Weight';
            DecimalPlaces = 0 : 3;
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110354; "POI Fiscal Agent Code"; Code[10])
        {
            Caption = 'Fiscal Agent Code';
            TableRelation = "POI Fiscal Agent";
        }
        field(5110355; "POI Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            OptionCaption = ' ,Payed,Not Payed';
            OptionMembers = " ",Payed,"Not Payed";

            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Status Customs Duty"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110356; "POI Clearing by Vendor No."; Code[20])
        {
            Caption = 'Clearing by Vendor No.';
            TableRelation = Vendor WHERE("POI Customs Agent" = CONST(true));
        }
        field(5110357; "POI Entry via Transf Loc. Code"; Code[10])
        {
            Caption = 'Entry via Transfer Loc. Code';
            TableRelation = Location;

            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Entry via Transf Loc. Code"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110358; "POI Ship-Agent Code to Tra Loc"; Code[10])
        {
            Caption = 'Ship-Agent Code to Transf. Loc';
            TableRelation = "Shipping Agent" where("POI Blocked" = const(false));

            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Ship-Agent Code to Tra Loc"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110361; "POI Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent".Code WHERE("POI Blocked" = CONST(false));

            trigger OnValidate()
            var
                ShippingAgent: Record "Shipping Agent";
                Vend: Record Vendor;
                ShipMethod: Record "Shipment Method";
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Shipping Agent Code"), 1, 100), CurrFieldNo <> 0);

                IF "POI Shipping Agent Code" <> '' THEN
                    IF ShipMethod.GET("Shipment Method Code") AND (NOT ShipMethod."POI Incl. Freig to Final Loc.") AND
                      (NOT ShipMethod."POI Incl. Freig to Transf Loc.")
                    THEN BEGIN
                        IF (ShippingAgent.GET("POI Shipping Agent Code") AND (NOT ShippingAgent."POI Blocked")) THEN
                            IF Vend.GET(ShippingAgent."POI Ship.-Ag. Vendor No.") AND (Vend.Blocked = Vend.Blocked::All) THEN
                                ERROR('Kreditor (Zusteller) %1 %2 ist gesperrt.\BItte an FIBU wenden.', Vend."No.", Vend.Name)
                            ELSE
                                IF (Vend.GET(ShippingAgent."POI Ship.-Ag. Vendor No.")) AND (Vend.Blocked <> Vend.Blocked::All) THEN
                                    IF NOT Vend."POI Carrier" THEN
                                        ERROR('Kreditor (Zusteller) %1 %2 ist nicht als Spediteur deklariert.\BItte an FIBU wenden.', Vend."No.", Vend.Name)
                                    ELSE
                                        ERROR('Zusteller %1 %2 ist gesperrt.\BItte an FIBU wenden.', ShippingAgent.Code, ShippingAgent.Name);
                    END ELSE
                        IF ShipMethod.GET("Shipment Method Code") AND (ShipMethod."POI Incl. Freig to Final Loc.") AND
                 (ShipMethod."POI Incl. Freig to Transf Loc.")
               THEN
                            IF (ShippingAgent.GET("POI Shipping Agent Code") AND (NOT ShippingAgent."POI Blocked")) THEN
                                IF ShippingAgent."POI Ship.-Ag. Vendor No." <> '' THEN
                                    IF Vend.GET(ShippingAgent."POI Ship.-Ag. Vendor No.") AND (Vend.Blocked = Vend.Blocked::All) THEN
                                        ERROR('Zusteller %1 %2 ist gesperrt.\BItte an FIBU wenden.', Vend."No.", Vend.Name);
            end;
        }
        field(5110362; "POI No. of Containers"; Decimal)
        {
            Caption = 'No. of Containers';
            DecimalPlaces = 0 : 1;
        }
        field(5110363; "POI Voyage No."; Code[20])
        {
            Caption = 'Voyage No.';
            TableRelation = "POI Voyage";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_Voyage: Record "POI Voyage";
            begin
                ADF_VoyageCodeValidate();

                TESTFIELD(Status, Status::Open);
                IF "POI Voyage No." <> '' THEN BEGIN

                    lrc_Voyage.GET("POI Voyage No.");
                    VALIDATE("POI Company Season Code", lrc_Voyage."Company Season Code");
                    VALIDATE("POI Means of Transport Type", lrc_Voyage."Means of Transp. Type Arrival");
                    VALIDATE("POI Means of TransCode(Arriva)", lrc_Voyage."Means of Transp. Code Arrival");
                    VALIDATE("POI Means of Transport Info", lrc_Voyage."Means of Transp. Info Arrival");
                    VALIDATE("POI Kind of Loading", lrc_Voyage."Kind of Loading");
                    VALIDATE("POI Port of Disch. Code (UDE)", lrc_Voyage."Port of Discharge Code (UDE)");
                    "POI Means of Transp.Code(Dep.)" := lrc_Voyage."Means of Transp. Code Depart.";

                    IF lrc_Voyage."Date of Discharge" <> 0D THEN
                        VALIDATE("POI Expected Discharge Date", lrc_Voyage."Date of Discharge");
                    IF lrc_Voyage."Time of Discharge" <> 0T THEN
                        VALIDATE("POI Expected Discharge Time", lrc_Voyage."Time of Discharge");

                    VALIDATE("Expected Receipt Date", lrc_Voyage.ETA);

                    VALIDATE("POI Departure Date", lrc_Voyage.ETD);
                    IF lrc_Voyage."Date of Departure" <> 0D THEN
                        VALIDATE("POI Departure Date", lrc_Voyage."Date of Departure");

                    IF lrc_Voyage."Date of Arrival" <> 0D THEN
                        VALIDATE("Promised Receipt Date", lrc_Voyage."Date of Arrival");

                    VALIDATE("POI Shipping Agent Code", lrc_Voyage."Shipping Agent Code");


                    IF (CurrFieldNo <> 0) AND
                       ("Currency Code" <> '') AND
                       ("Currency Factor" <> 0) THEN BEGIN
                        IF (lrc_Voyage."Currency Code" <> '') AND
                           (lrc_Voyage."Currency Factor" <> 0) THEN
                            IF CONFIRM(ADF_GT_TEXT001Txt) THEN BEGIN
                                VALIDATE("Currency Code", lrc_Voyage."Currency Code");
                                VALIDATE("Currency Factor", lrc_Voyage."Currency Factor");
                            END;
                    END ELSE
                        IF (lrc_Voyage."Currency Code" <> '') AND
                           (lrc_Voyage."Currency Factor" <> 0) THEN BEGIN
                            VALIDATE("Currency Code", lrc_Voyage."Currency Code");
                            VALIDATE("Currency Factor", lrc_Voyage."Currency Factor");
                        END;
                END;

                UpdatePurchLines(copystr(FIELDCAPTION("POI Voyage No."), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110364; "POI Container No."; Code[20])
        {
            Caption = 'Container No.';

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                UpdatePurchLines(copystr(FIELDCAPTION("POI Container No."), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110365; "POI Means of Transport Type"; Option)
        {
            Caption = 'Means of Transport Type';
            Description = ' ,Truck,Train,Ship,Airplane';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;

            trigger OnValidate()
            begin
                IF "POI Means of Transport Type" <> xRec."POI Means of Transport Type" THEN
                    "POI Means of TransCode(Arriva)" := '';
            end;
        }
        field(5110366; "POI Means of TransCode(Arriva)"; Code[20])
        {
            Caption = 'Means of Transp. Code (Arriva)';
            TableRelation = "POI Means of Transport".Code WHERE(Type = FIELD("POI Means of Transport Type"));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_MeansofTransport: Record "POI Means of Transport";
                lcu_PurchMgt: Codeunit "POI Purch. Mgt";
            begin
                lcu_PurchMgt.ValidateMeansOfTransport(Rec);
                IF lrc_MeansofTransport.GET("POI Means of Transport Type", "POI Means of TransCode(Arriva)") THEN
                    IF lrc_MeansofTransport."Means of Transport Info" <> '' THEN
                        VALIDATE("POI Means of Transport Info", lrc_MeansofTransport."Means of Transport Info");

                IF "POI Means of Transp.Code(Dep.)" = '' THEN
                    "POI Means of Transp.Code(Dep.)" := "POI Means of TransCode(Arriva)";
                //RS
                UpdatePurchLines(copystr(FIELDCAPTION("POI Means of TransCode(Arriva)"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110367; "POI Means of Transport Info"; Code[30])
        {
            Caption = 'Means of Transport Info';
            TableRelation = "POI Means of Transport Info".Code;
            ValidateTableRelation = false;
        }
        field(5110369; "POI Port of Disch. Code (UDE)"; Code[10])
        {
            Caption = 'Port of Discharge Code (UDE)';
            TableRelation = "Entry/Exit Point";

            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Port of Disch. Code (UDE)"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110370; "POI Location Reference No."; Code[20])
        {
            Caption = 'Location Reference No.';

            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Location Reference No."), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110371; "POI Departure Date"; Date)
        {
            Caption = 'Departure Date';
            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Departure Date"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110372; "POI Planned Receipt Date"; Date)
        {
            Caption = 'Planned Receipt Date';
            Description = '=Erwartetes Entladedatum';

            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Planned Receipt Date"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110373; "POI Expected Receipt Time"; Time)
        {
            Caption = 'Expected Receipt Time';
        }
        field(5110374; "POI Kind of Loading"; Option)
        {
            Caption = 'Kind of Loading';
            Description = ' ,Container,Reefer Vessel,Container and Reefer Vessel,,Konventionell';
            OptionCaption = ' ,Container,Reefer Vessel,Container and Reefer Vessel,,Konventionell';
            OptionMembers = " ",Container,"Reefer Vessel","Container and Reefer Vessel",,Konventionell;

            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Kind of Loading"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110375; "POI Quality Control Vendor No."; Code[20])
        {
            Caption = 'Quality Control Vendor No.';
            //TableRelation = Vendor WHERE ("POI Is Quality Controller"=CONST(true));
        }
        field(5110377; "POI Expected Discharge Date"; Date)
        {
            Caption = 'Expected Discharge Date';

            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Expected Discharge Date"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110378; "POI Expected Discharge Time"; Time)
        {
            Caption = 'Expected Discharge Time';

            trigger OnValidate()
            begin
                UpdatePurchLines(copystr(FIELDCAPTION("POI Expected Discharge Time"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110380; "POI Appendix Shipment Method"; Text[30])
        {
            Caption = 'Appendix Shipment Method';
        }
        field(5110382; "POI Receipt Info"; Text[30])
        {
            Caption = 'Receipt Info';
        }
        field(5110391; "POI Port of Loading Code"; Code[10])
        {
            Caption = 'Port of Loading Code';
            TableRelation = "POI Harbour";
        }
        field(5110392; "POI Means of Transp.Code(Dep.)"; Code[20])
        {
            Caption = 'Means of Transp. Code (Depart)';
            TableRelation = "POI Means of Transport".Code WHERE(Type = FIELD("POI Means of Transport Type"));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                IF ("POI Means of TransCode(Arriva)" = '') AND
                   ("POI Means of Transp.Code(Dep.)" <> '') THEN
                    VALIDATE("POI Means of TransCode(Arriva)", "POI Means of Transp.Code(Dep.)")
            end;
        }
        field(5110393; "POI Shipping Comp. Vendor No."; Code[20])
        {
            Caption = 'Shipping Company Vendor No.';
            TableRelation = Vendor WHERE("POI Is Shipping Company" = CONST(true));
        }
        field(5110460; "POI Released for Invoice"; Boolean)
        {
            Caption = 'Released for Invoice';
        }
        field(5110470; "POI Expected Receipt Time Till"; Time)
        {
            Caption = 'Expected Receipt Time Till';
        }
        field(5110472; "POI Departure Time From"; Time)
        {
            Caption = 'Departure Time From';
        }
        field(5110473; "POI Departure Time Till"; Time)
        {
            Caption = 'Departure Time Till';
        }
        field(5110513; "POI Blanket Order Valid from"; Date)
        {
            Caption = 'Blanket Order Valid from';
            Description = 'DIS';

            trigger OnValidate()
            var
                lcu_PurchaseContractManagement: Codeunit "POI Purch. Contract Mgt";
            begin
                IF ("POI Blanket Order Valid from" > "POI Blanket Order Valid till") AND
                   ("POI Blanket Order Valid from" <> 0D) AND
                   ("POI Blanket Order Valid till" <> 0D) THEN
                    ERROR(ADF_GT_TEXT006Txt, "POI Blanket Order Valid from", "POI Blanket Order Valid till");
                IF xRec."POI Blanket Order Valid from" <> 0D THEN
                    lcu_PurchaseContractManagement.UserTestValidBlnktOrderHeDeact(Rec);
                IF "POI Blanket Order Valid from" <> xRec."POI Blanket Order Valid from" THEN
                    UpdatePurchLines(copystr(FIELDCAPTION("POI Blanket Order Valid from"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110514; "POI Blanket Order Valid till"; Date)
        {
            Caption = 'Blanket Order Valid till';
            Description = 'DIS';

            trigger OnValidate()
            var
                lcu_PurchaseContractManagement: Codeunit "POI Purch. Contract Mgt";
            begin
                IF ("POI Blanket Order Valid from" > "POI Blanket Order Valid till") AND
                   ("POI Blanket Order Valid from" <> 0D) AND
                   ("POI Blanket Order Valid till" <> 0D) THEN
                    ERROR(ADF_GT_TEXT007Txt, "POI Blanket Order Valid from", "POI Blanket Order Valid till");
                IF xRec."POI Blanket Order Valid from" <> 0D THEN
                    lcu_PurchaseContractManagement.UserTestValidBlnktOrderHeDeact(Rec);
                IF "POI Blanket Order Valid till" <> xRec."POI Blanket Order Valid till" THEN
                    UpdatePurchLines(copystr(FIELDCAPTION("POI Blanket Order Valid till"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        field(5110623; "POI Producer Name"; Text[100])
        {
            Caption = 'Producer Name';
        }
        field(5110624; "POI Last Document Date"; Date)
        {
            Caption = 'Last Document Date';
            Description = 'ERZ';
        }
        field(5110630; "POI Order Type"; Option)
        {
            Caption = 'Auftragsart';
            OptionCaption = ' ,Wholesaler-To-Client,Agency';
            OptionMembers = " ","Wholesaler-To-Client",Agency;
        }
        field(50401; "POI Pallet number"; Decimal)
        {
            Caption = 'Palettenanzahl';
            FieldClass = FlowField;
            CalcFormula = sum ("Purchase Line"."POI Pallet number" where("Document No." = field("No."), "Document Type" = field("Document Type")));
            Editable = false;
        }
        field(50402; "POI Logistic Cost"; Decimal)
        {
            Caption = 'Transportkosten';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50002; "POI Departure Region Code"; Code[20])
        {
            Caption = 'Departure Region Code';
            TableRelation = "POI Departure Region" where(RegionType = const(Departure));
            trigger OnValidate()
            begin
                if "POI Departure Region Code" <> xRec."POI Departure Region Code" then
                    HandleTour();
            end;
        }
        field(50005; "POI Arrival Region Code"; Code[20])
        {
            Caption = 'Arrival Region Code';
            TableRelation = "POI Departure Region" where(RegionType = const(Arrival));
            trigger OnValidate()
            begin
                if "POI Departure Region Code" <> xRec."POI Departure Region Code" then
                    HandleTour();
            end;
        }
        field(50003; "POI Transfer Region Code"; Code[20])
        {
            Caption = 'Transfer Region Code';
            TableRelation = "POI Departure Region" where(RegionType = const(Transfer));
            trigger OnValidate()
            begin
                if "POI Transfer Region Code" <> xRec."POI Transfer Region Code" then
                    HandleTour();
            end;
        }
        field(50004; "POI Tour"; Code[20])
        {
            Caption = 'Tour';
            DataClassification = CustomerContent;
            TableRelation = "POI Tour"."Tour Code";
        }
        field(5110310; "POI Purch. Doc. Subtype Code"; Code[10])
        {
            Caption = 'Purch. Doc. Subtype Code';
            Description = 'EDM';
            TableRelation = "POI Purch. Doc. Subtype".Code WHERE("Document Type" = FIELD("Document Type"));
        }
        field(5110345; "POI Pallets Entry No."; Integer)
        {
            Caption = 'Pallets Entry No.';
            Description = 'PAL';
        }
        field(5110650; "POI Vendor Invoice Amount"; Decimal)
        {
            Caption = 'Vendor Invoice Amount';
            Description = 'Nur in Bestellkopf';
        }
        modify("Buy-from Vendor No.")
        {
            trigger OnBeforeValidate()
            var
                POIQSFunctions: Codeunit "POI QS Functions";
            begin
                POIQSFunctions.CheckVendBeforePurchOrder(Rec);
                BaseDataMgt.GlobalValidateSearch(38, FIELDNO("Buy-from Vendor No."),
                                                           "Buy-from Vendor No.",
                                                           (CurrFieldNo = FIELDNO("Buy-from Vendor No.")));
                DSTDocSubtypeMgt.CheckVendPurchDocTyp(Rec, TRUE);

                //copystr(TABLENAME(), 1, 30)
            end;

            trigger OnAfterValidate()
            begin
                "POI Purch. Doc. Subtype Code" := xRec."POI Purch. Doc. Subtype Code";
                "POI Master Batch No." := xRec."POI Master Batch No.";
                Vendor.get("Buy-from Vendor No.");
                VALIDATE("POI Shipping Agent Code", Vendor."Shipping Agent Code");
                VALIDATE("POI Entry via Transf Loc. Code", Vendor."POI Entry via Transf Loc. Code");
                VALIDATE("POI Departure Region Code", Vendor."POI Departure Region Code");
                VendDiffCurrency();
                POI_BuyFromVendorNoValidate();
                //RS Vorbelegung Abgangslager wenn Lager-Kreditornummer mit buy-from Vendor übereinstimmt
                Location.SETRANGE("POI Vendor No.", "Buy-from Vendor No.");
                IF Location.FINDFIRST() THEN
                    IF "POI Departure Location Code" = '' THEN
                        VALIDATE("POI Departure Location Code", Location.Code);

                //RS Fiskalvertreter vom Kreditor holen
                IF Vendor."POI Fiscal Agent" <> '' THEN
                    VALIDATE("POI Fiscal Agent Code", Vendor."POI Fiscal Agent");

            end;
        }
        modify("Pay-to Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                BaseDataMgt.GlobalValidateSearch(38, FIELDNO("Pay-to Vendor No."), "Pay-to Vendor No.", (CurrFieldNo = FIELDNO("Pay-to Vendor No.")));
                //Einkäufer Code setzen
                IF Vendor."Purchaser Code" <> '' THEN
                    "Purchaser Code" := Vendor."Purchaser Code";
                // Lieferbedingung Validieren statt nur zuweisen
                IF Vendor."Shipment Method Code" <> '' THEN BEGIN
                    VALIDATE("Shipment Method Code", Vendor."Shipment Method Code");
                    "POI Appendix Shipment Method" := Vendor."POI Appendix Shipment Method";
                END;
            end;
        }
        modify("Ship-to Code")
        {
            trigger OnAfterValidate()
            begin
                //Lieferbedingung Validieren statt nur zuweisen
                IF ShipToAddr."Shipment Method Code" <> '' THEN BEGIN
                    VALIDATE("Shipment Method Code", ShipToAddr."Shipment Method Code");
                    "POI Appendix Shipment Method" := ShipToAddr."POI Appendix Shipment Method";
                END;
                //Lieferbedingung Validieren statt nur zuweisen
                IF "Ship-to Code" = '' THEN BEGIN
                    TESTFIELD("Sell-to Customer No.");
                    Customer.GET("Sell-to Customer No.");
                    IF Customer."Shipment Method Code" <> '' THEN BEGIN
                        VALIDATE("Shipment Method Code", Customer."Shipment Method Code");
                        "POI Appendix Shipment Method" := Customer."POI Appendix Shipment Method";
                    END;
                end;
            end;
        }
        modify("Posting Date")
        {
            trigger OnBeforeValidate()
            begin
                IF "POI Document Status" = "POI Document Status"::Abgeschlossen THEN
                    ERROR('Das Buchungsdatum kann nicht mehr verändert werden.');
            end;

            trigger OnAfterValidate()
            begin
                IF NOT cu60004.DMS_Aktive_Check() THEN
                    VALIDATE("Document Date", "Posting Date");
            end;
        }
        modify("Expected Receipt Date")
        {
            trigger OnafterValidate()
            begin
                ADF_ExpReceiptDateValidate();
            end;
        }
        modify("Location Code")
        {
            trigger OnafterValidate()
            var
                Location: Record Location;
                lcu_DocSubtypeMgt: Codeunit "POI DST Doc. Subtype Mgt";
            begin
                if "Location Code" <> xRec."Location Code" then
                    if "Location Code" <> '' then begin
                        Location.Get("Location Code");
                        Validate("POI Departure Region Code", Location."POI Departure Region");
                    end;
                BaseDataMgt.LocationValidateSearch("Location Code", TRUE);

                // Kontrolle ob Lagerort für die Belegart zugelassen ist
                lcu_DocSubtypeMgt.CheckLocationPurchDocTyp("Document Type", "No.", "POI Purch. Doc. Subtype Code", "Location Code");

                VALIDATE("POI Quality Control Vendor No.", Location."POI Quality Control Vendor No.");
                IF Location."POI Port of Disch. Code (UDE)" <> '' THEN
                    VALIDATE("POI Port of Disch. Code (UDE)", Location."POI Port of Disch. Code (UDE)");
            end;
        }
        modify("Applies-to Doc. No.")
        {
            trigger OnBeforeValidate()
            var
                lr_PurchInvHeader: Record "Purch. Inv. Header";
            begin
                IF "Document Type" = "Document Type"::"Credit Memo" THEN
                    IF "Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice THEN
                        IF lr_PurchInvHeader.GET("Applies-to Doc. No.") THEN
                            "Expected Receipt Date" := lr_PurchInvHeader."Expected Receipt Date";
            end;
        }
        modify("Posting No.")
        {
            trigger OnAfterValidate()
            var
                lcu_IncomingInvLedgerMgt: Codeunit "POI Incoming Inv. Ledger Mgt";
            begin
                //Kontrolle ob Rechnungseingangsbuch, wenn ja dann Werte laden
                lcu_IncomingInvLedgerMgt.LoadInInvDoc(Rec);
            end;
        }
        modify("Vendor Invoice No.")
        {
            trigger OnAfterValidate()
            var
                PurchSetup: Record "Purchases & Payables Setup";

            begin
                IF "Vendor Invoice No." = xRec."Vendor Invoice No." THEN
                    EXIT;
                PurchSetup.GET();
                IF (PurchSetup."Ext. Doc. No. Mandatory" = TRUE) OR
                   ("Vendor Invoice No." <> '') THEN BEGIN
                    VendorLedgerEntry.RESET();
                    VendorLedgerEntry.SETCURRENTKEY("External Document No.", "Document Type", "Vendor No.");
                    VendorLedgerEntry.SETRANGE("Document Type", "Document Type");
                    VendorLedgerEntry.SETRANGE("External Document No.", "Vendor Invoice No.");
                    VendorLedgerEntry.SETRANGE("Vendor No.", "Pay-to Vendor No.");
                    // Nur den vorgegebenen Zeitraum abprüfen
                    IF FORMAT(PurchSetup."POI Period Check Ext. Doc. No.") <> '' THEN
                        VendorLedgerEntry.SETFILTER("Posting Date", '>%1', CALCDATE(PurchSetup."POI Period Check Ext. Doc. No.", TODAY()));
                    IF VendorLedgerEntry.FIND('-') THEN
                        MESSAGE(ADF_GT_TEXT008Txt, VendorLedgerEntry."Document Type", "Vendor Invoice No.");
                END;

                //RS Prüfung ob GS Verfahren und Ausgabe Warnmeldung
                IF "POI Gutschriftsverfahren" THEN
                    IF NOT CONFIRM('Achtung Gutschriftsverfahren! Wollen Sie wirklich eine Kreditorenrechnungsnummer eingeben?', FALSE) THEN
                        ERROR('');
            end;
        }
        modify("VAT Registration No.")
        {
            trigger OnBeforeValidate()
            begin
                IF NOT POIFunction.CheckUserInRole('FB_KREDITOR_W', 0) THEN
                    ERROR(ERR_NoPermissionTxt);
            end;
        }
        modify("Gen. Bus. Posting Group")
        {
            trigger OnBeforeValidate()
            begin
                TESTFIELD(Status, Status::Open);
                Port_Purchase.Purchase_Head_OnModify(Rec, xRec, copystr(FIELDNAME("Gen. Bus. Posting Group"), 1, 250));
            end;

            trigger OnAfterValidate()
            begin
                ADF_IntrastatPreAllocation();
            end;
        }
        modify("Order Address Code")
        {
            trigger OnAfterValidate()
            var
                Vend: Record Vendor;
            begin
                Vend.Get("Buy-from Vendor No.");
                VALIDATE("POI Departure Region Code", Vend."POI Departure Region Code");
                UpdatePurchLines(copystr(FIELDCAPTION("Order Address Code"), 1, 100), CurrFieldNo <> 0);
            end;
        }
        modify("VAT Bus. Posting Group")
        {
            trigger OnBeforeValidate()
            begin
                Port_Purchase.Purchase_Head_OnModify(Rec, xRec, copystr(FIELDNAME("VAT Bus. Posting Group"), 1, 250));
            end;
        }
    }

    trigger OnDelete()
    begin
        IF "Document Type" IN ["Document Type"::Order, "Document Type"::"Blanket Order"] THEN
            IF (UPPERCASE(USERID()) <> ('WESSEL')) THEN
                ERROR('Bitte an Admin wenden, der Einkaufskopf darf nicht gelöscht werden');
    end;



    trigger OnInsert()
    var
    // DimMgt: Codeunit DimensionManagement;
    begin
        ADF_PurchDocSubTypeInit();

        IF NOT POIFunction.CheckUserInRole('FIBUBUCHEN', 0) THEN
            IF WORKDATE() <> 20191001D THEN
                WORKDATE := TODAY();
        InitRecord();
        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Purchase Header", "Document Type", "No.");
        // DimMgt.EDM_InsertDocDim(  //TODO: Dimensionen
        //   DATABASE::"Purchase Header", "Document Type", "No.", 0,
        //   "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
        //   "POI Shortcut Dimension 3 Code", "POI Shortcut Dimension 4 Code");
        ADF_RecOnInsert();
        Dimensionsanlage();
    end;

    trigger OnModify()
    begin
        ADF_RecOnModify();
    end;

    procedure HandleTour()
    var
        Tour: Record "POI Tour";
    begin
        if ("POI Departure Region Code" <> '') and ("POI Arrival Region Code" <> '') then
            if "POI Tour" = '' then
                Tour.CreateTour("No.")
            else
                Tour.UpdateTour("POI Tour");
    end;

    procedure ADF_VoyageCodeValidate()
    var
        lcu_BaseDataMgt: Codeunit "POI Base Data Mgt";
        lco_VoyageCode: Code[20];
        AGILES_LT_TEXT001Txt: Label 'Entry not valid!';
    begin
        // -------------------------------------------------------------------------
        // Validierung des Reisecodes mit Suchmöglichkeit
        // -------------------------------------------------------------------------

        IF "POI Voyage No." = '' THEN
            EXIT;
        lco_VoyageCode := "POI Voyage No.";
        IF NOT lcu_BaseDataMgt.VoyageCodeSearch(lco_VoyageCode) THEN
            // Eingabe nicht zulässig!
            ERROR(AGILES_LT_TEXT001Txt);
        "POI Voyage No." := lco_VoyageCode;
    end;

    procedure ADF_PurchDocSubTypeInit()
    var
        lrc_PurchDocSubtype: Record "POI Purch. Doc. Subtype";
        lcu_DSTDocSubtypeMgt: Codeunit "POI DST Doc. Subtype Mgt";
    begin
        // ----------------------------------------------------------------------------------
        // Funktion zur Ermittlung der Belegart falls keine übergeben wurde
        // ----------------------------------------------------------------------------------

        // Belegunterart auswählen
        IF "POI Purch. Doc. Subtype Code" = '' THEN
            "POI Purch. Doc. Subtype Code" := lcu_DSTDocSubtypeMgt.SelectPurchDocType("Document Type", 0, 0);

        // Belegunterart lesen
        lrc_PurchDocSubtype.GET("Document Type", "POI Purch. Doc. Subtype Code");
        "POI Purch. Doc. Subtype Detail" := lrc_PurchDocSubtype."Doc. Subtype Detail";

        // Belegnummer vergeben
        IF ("No." = '') AND (lrc_PurchDocSubtype."Document No. Series" <> '') THEN
            NoSeriesMgt.InitSeries(lrc_PurchDocSubtype."Document No. Series", xRec."No. Series", "Posting Date", "No.", "No. Series");
    end;

    procedure Dimensionsanlage()
    var
        lrc_BatchSetup: Record "POI Master Batch Setup";
        //lrc_DocDim: Record "357";
        lrc_DimValue: Record "Dimension Value";
    begin
        //RS
        lrc_BatchSetup.GET();
        IF ((lrc_BatchSetup."Batchsystem activ") AND
           ("Document Type" <> "Document Type"::"Blanket Order")) THEN // BEGIN
            IF NOT lrc_DimValue.GET('PARTIE', "No.") THEN BEGIN
                //Anlage Dimension Partie
                lrc_DimValue.INIT();
                lrc_DimValue."Dimension Code" := 'PARTIE';
                lrc_DimValue.Code := "No.";
                lrc_DimValue.Name := "No.";
                lrc_DimValue."Dimension Value Type" := lrc_DimValue."Dimension Value Type"::Standard;
                lrc_DimValue.INSERT();
            END;
        //Hinterlegung Header Dimension;
        //   lrc_DocDim.INIT();
        //   lrc_DocDim."Table ID" := 38;
        //   lrc_DocDim."Document Type" := "Document Type";
        //   lrc_DocDim."Document No." := "No.";
        //   lrc_DocDim."Line No." := 0;
        //   lrc_DocDim."Dimension Code" := 'PARTIE';
        //   lrc_DocDim.VALIDATE("Dimension Value Code", "No.");
        //   lrc_DocDim.INSERT();
        // END;
    end;

    procedure ADF_RecOnInsert()
    var
        lrc_UserSetup: Record "User Setup";
        lrc_PurchDocSubtype: Record "POI Purch. Doc. Subtype";
        lcu_BatchMgt: Codeunit "POI BAM Batch Management";
    begin
        // ----------------------------------------------------------------------------------
        // Funktion für Trigger OnInsert
        // ----------------------------------------------------------------------------------

        // Belegunterart lesen
        lrc_PurchDocSubtype.GET("Document Type", "POI Purch. Doc. Subtype Code");
        // Vorbelegung Transportart aus Belegunterart
        "POI Means of Transport Type" := lrc_PurchDocSubtype."Default Means of Transp. Type";
        // Vorbelegung Rechnungsrabattkalkulation mit Betrag
        "Invoice Discount Calculation" := "Invoice Discount Calculation"::Amount;
        // Sachbearbeiter, Einkäufer und Sachgebiet über Anwender ID ermitteln
        lrc_UserSetup.GET(USERID());
        IF lrc_UserSetup."POI Person in Charge Code" <> '' THEN
            "POI Person in Charge Code" := lrc_UserSetup."POI Person in Charge Code";
        IF lrc_UserSetup."POI Purchaser Code" <> '' THEN
            "Purchaser Code" := lrc_UserSetup."POI Purchaser Code";
        // Partie, Position anlegen
        lcu_BatchMgt.MasterBatchNewFromPurchHdr(Rec, "POI Master Batch No.");
    end;

    procedure ADF_RecOnModify()
    var
        lcu_BatchMgt: Codeunit "POI BAM Batch Management";
    begin
        // ----------------------------------------------------------------------------------
        // Funktion für Trigger OnModify
        // ----------------------------------------------------------------------------------

        // Partiesatz aktualisieren
        lcu_BatchMgt.MasterBatchUpdFromPurchHdr(Rec);
        // Positionssatz aktualisieren
        lcu_BatchMgt.BatchUpdFromPurchHdr('', Rec);
        // Positionsvariantensatz aktualisieren
        lcu_BatchMgt.BatchVarUpdFromPurchHeader(Rec);
    end;

    procedure VendDiffCurrency()
    var
        Vend: Record Vendor;
        DiffCurrency: Code[50];
        lfdnr: Integer;
        Selection: Integer;
        //Text002Txt: Label '&Receive,&Invoice,Receive &and Invoice';
        CurrArray: array[10] of Code[10];
        Currcode: Integer;
        i: Integer;
    begin
        Buffer.SETRANGE("User-ID", USERID());
        Buffer.DELETEALL();
        lfdnr := 1;
        i := 1;
        DiffCurrency := '';

        IF "Buy-from Vendor No." <> xRec."Buy-from Vendor No." THEN BEGIN
            VendBankAcc.RESET();
            VendBankAcc.SETRANGE("Vendor No.", "Buy-from Vendor No.");
            IF VendBankAcc.FINDSET() THEN
                IF VendBankAcc.COUNT() > 1 THEN
                    REPEAT
                        Buffer.RESET();
                        Buffer.SETRANGE(code2, VendBankAcc."Currency Code");
                        Buffer.SETRANGE("User-ID", USERID());
                        IF NOT Buffer.FINDFIRST() THEN BEGIN
                            Buffer.Init();
                            Buffer.LineNo := lfdnr;
                            Buffer."User-ID" := copystr(USERID(), 1, 20);
                            IF VendBankAcc."Currency Code" = '' THEN BEGIN
                                Buffer.code1 := 'EUR';
                                Buffer.code2 := VendBankAcc."Currency Code";
                            END ELSE BEGIN
                                Buffer.code1 := VendBankAcc."Currency Code";
                                Buffer.code2 := VendBankAcc."Currency Code";
                            END;
                            Buffer.INSERT();
                            lfdnr += 1;
                        END;
                    UNTIL VendBankAcc.NEXT() = 0;
        END;
        Buffer.RESET();
        Buffer.SETRANGE("User-ID", USERID());
        Buffer.SETCURRENTKEY(code1, code2, code3);
        IF Buffer.FINDSET() THEN
            IF Buffer.COUNT() > 1 THEN
                REPEAT
                    IF DiffCurrency = '' THEN BEGIN
                        DiffCurrency := copystr(DiffCurrency + Buffer.code1, 1, 50);
                        CurrArray[i] := copystr(Buffer.code1, 1, 10);
                    END ELSE BEGIN
                        DiffCurrency := copystr(DiffCurrency + ',' + Buffer.code1, 1, 50);
                        CurrArray[i] := copystr(Buffer.code1, 1, 10);
                    END;
                    i += 1;
                UNTIL Buffer.NEXT() = 0;
        IF DiffCurrency <> '' THEN BEGIN
            IF Vend.GET("Buy-from Vendor No.") THEN
                IF Vend."Currency Code" = '' THEN BEGIN
                    FOR i := 1 TO ARRAYLEN(CurrArray) DO
                        IF CurrArray[i] = 'EUR' THEN
                            Currcode := i;
                    Selection := STRMENU(DiffCurrency, Currcode);
                END ELSE BEGIN
                    FOR i := 1 TO ARRAYLEN(CurrArray) DO
                        IF CurrArray[i] = Vend."Currency Code" THEN
                            Currcode := i;
                    Selection := STRMENU(DiffCurrency, Currcode);
                END;
            IF Selection = 0 THEN
                EXIT;
            IF CurrArray[Selection] = 'AUD' THEN
                VALIDATE("Currency Code", 'AUD');
            IF CurrArray[Selection] = 'CAD' THEN
                VALIDATE("Currency Code", 'CAD');
            IF CurrArray[Selection] = 'CHF' THEN
                VALIDATE("Currency Code", 'CHF');
            IF CurrArray[Selection] = 'GBP' THEN
                VALIDATE("Currency Code", 'GBP');
            IF CurrArray[Selection] = 'PLN' THEN
                VALIDATE("Currency Code", 'PLN');
            IF CurrArray[Selection] = 'USD' THEN
                VALIDATE("Currency Code", 'USD');
        END;
    end;

    procedure POI_BuyFromVendorNoValidate()
    var
        lcu_DiscountMgt: Codeunit "POI Discount Management";
        lcu_DocSubtypeMgt: Codeunit "POI DST Doc. Subtype Mgt";
        lcu_CommentMgt: Codeunit "POI ECM Ext. Comment Mgt";
        lcu_PurchMgt: Codeunit "POI Purch. Mgt";
    begin
        // ----------------------------------------------------------------------------------
        // Funktion Validierung Buy-from Vendor No.
        // ----------------------------------------------------------------------------------

        IF "Buy-from Vendor No." <> '' THEN
            IF Vendor."No." <> "Buy-from Vendor No." THEN
                Vendor.GET("Buy-from Vendor No.");

        VALIDATE("POI Waste Disposal Duty", Vendor."POI Waste Disposal Duty");
        VALIDATE("POI Waste Disposal Paymt Thru", Vendor."POI Waste Disposal Paymt Thru");
        "POI Kind of Settlement" := Vendor."POI A.S. Kind of Settlement";
        VALIDATE("POI Cost Schema Name Code", Vendor."POI A.S. Cost Schema Name Code");
        "POI Country of Origin Code" := Vendor."POI Country of Origin Code";
        "POI Cultivation Associat. Code" := Vendor."POI Cultivation Associat. Code";

        // Belegabhängige Kreditorenstammdaten laden
        IF lcu_DocSubtypeMgt.GetReferencePurchDocTyp(Rec, "POI Shipping Agent Code", "Location Code",
                                                     "Payment Terms Code", "Shipment Method Code") THEN BEGIN
            VALIDATE("POI Shipping Agent Code");
            VALIDATE("Location Code");
            VALIDATE("Payment Terms Code");
            VALIDATE("Shipment Method Code");
        END;

        // Rabatte laden
        lcu_DiscountMgt.PurchDiscLoad(Rec, FALSE);
        // Intrastat Vorbelegung
        ADF_IntrastatPreAllocation();
        // Bemerkungen laden
        lcu_CommentMgt.PurchCommentTransferToDoc(Rec);
        // Importdokumente laden
        lcu_PurchMgt.ImpDocLoadInPurchOrder("Document Type", "No.", "Buy-from Vendor No.");
        FindVATRegNo();
    end;

    procedure ADF_IntrastatPreAllocation()
    begin
        // ----------------------------------------------------------------------------------
        // Funktion zur Vorbelegung der Intrastat Daten
        // ----------------------------------------------------------------------------------
        lrc_IntrastatDefaultValues.Reset();
        lrc_IntrastatDefaultValues.SETRANGE("Gen. Bus. Posting Group", "Gen. Bus. Posting Group");
        IF ("Document Type" = "Document Type"::Quote) OR
           ("Document Type" = "Document Type"::Order) OR
           ("Document Type" = "Document Type"::Invoice) OR
           ("Document Type" = "Document Type"::"Blanket Order") THEN
            lrc_IntrastatDefaultValues.SETRANGE("Business Transaction Type",
                                                lrc_IntrastatDefaultValues."Business Transaction Type"::Purchase)
        ELSE
            lrc_IntrastatDefaultValues.SETRANGE("Business Transaction Type",
                                                lrc_IntrastatDefaultValues."Business Transaction Type"::"Purchase Credit Memo");

        IF lrc_IntrastatDefaultValues.FINDFIRST() THEN BEGIN
            VALIDATE("Transaction Type", lrc_IntrastatDefaultValues."Transaction Type");
            VALIDATE("Transaction Specification", lrc_IntrastatDefaultValues."Transaction Specification");
            VALIDATE("Transport Method", lrc_IntrastatDefaultValues."Transport Method");
            VALIDATE(Area, lrc_IntrastatDefaultValues.Area);
        END ELSE BEGIN
            VALIDATE("Transaction Type", '');
            VALIDATE("Transaction Specification", '');
            VALIDATE("Transport Method", '');
            VALIDATE(Area, '');
        END;
    end;

    procedure FindVATRegNo()
    var
        CompInfo: Record "Company Information";
    begin
        IF COMPANYNAME() = 'P I Dutch Growers' THEN //TODO: VAT No.
            CompInfo.GET('NL')
        ELSE
            IF NOT CompInfo.GET('DE') THEN
                CompInfo.GET('');
        "POI Our VAT Registration No." := CompInfo."VAT Registration No.";
    end;

    procedure ADF_ExpReceiptDateValidate()
    var
        lrc_PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        lrc_PurchasesPayablesSetup.GET();
        IF lrc_PurchasesPayablesSetup."POI Auto Upd. Exp.Rec. Date Li" THEN
            UpdatePurchLines(copystr(FIELDCAPTION("Expected Receipt Date"), 1, 100), FALSE)
        ELSE
            UpdatePurchLines(copystr(FIELDCAPTION("Expected Receipt Date"), 1, 100), CurrFieldNo <> 0);
    end;


    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        ShipToAddr: Record "Ship-to Address";
        Cust: Record Customer;
        VATRegNoVendCust: Record "POI VAT Registr. No. Vend/Cust";
        lrc_CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
        PurchLine: Record "Purchase Line";
        GGNBatch: Record "POI GGN - Batch";
        lrc_DiffPosten: Record "POI Difference Entry";
        lrc_PurchaseLine: Record "Purchase Line";
        VendBankAcc: Record "Vendor Bank Account";
        VendorLedgerEntry: Record "Vendor ledger Entry";
        Location: Record Location;
        lrc_IntrastatDefaultValues: Record "POI Intrastat Default Values";
        Buffer: Record "POI temp Buffer" temporary;
        Port_Purchase: Codeunit "POI Port_Purchase";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        POIFunction: Codeunit POIFunction;
        //DimMgt: Codeunit DimensionManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
        BaseDataMgt: Codeunit "POI BDM Base Data Mgmt";
        DSTDocSubtypeMgt: Codeunit "POI DST Doc. Subtype Mgt";
        cu60004: Codeunit "POI Port Mapping Management";
        ADF_GT_TEXT001Txt: Label 'A currency code is present in the selected voyage. Do you want to use this currency data?';
        ADF_GT_TEXT006Txt: Label 'Valid from %1 must be earlier as Valid to %2.', Comment = '%1 %2';
        ADF_GT_TEXT007Txt: Label 'Valid from %1 must be earlier as Valid to %2.', Comment = '%1 %2';
        ADF_GT_TEXT008Txt: Label 'Purchase %1 %2 already exists for this vendor.', Comment = '%1 %2';
        ERR_NoPermissionTxt: Label 'Sie haben keine Berechtigung zum Ändern der Angaben.\Bitte an FIBU wenden.';
    // Text001Txt: Label 'Do you want to print invoice %1?';
    // Text002Txt: Label 'Do you want to print credit memo %1?';
    // Text023Txt: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
    // Text000Txt: Label 'Do you want to print receipt %1?';
}