codeunit 5110301 "POI Base Data Mgt"
{

    var
        lrc_Customer: Record Customer;
        lrc_Vendor: Record Vendor;
        lrc_Item: Record Item;
        lrc_ProductGroupUnitOfMeasure: Record "POI Product Group - Unit";
        lrc_UnitOfMeasure: Record "Unit of Measure";
        lrc_CaliberVendorCaliber: Record "POI Caliber - Vendor Caliber";
        lrc_CompanyInformation: Record "Company Information";
        lrc_Company: Record Company;

    //     procedure ShowCustomerCard(vco_CustNo: Code[20];vbn_Modal: Boolean)
    //     var
    //         lrc_ADFSetup: Record "5110302";
    //         lrc_Customer: Record "Customer";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Debitorenkarte
    //         // ------------------------------------------------------------------------------------

    //         lrc_ADFSetup.GET();
    //         lrc_ADFSetup.TESTFIELD("Customer Card Form ID");

    //         lrc_Customer.GET(vco_CustNo);
    //         IF vbn_Modal THEN
    //           FORM.RUNMODAL(lrc_ADFSetup."Customer Card Form ID",lrc_Customer)
    //         ELSE
    //           FORM.RUN(lrc_ADFSetup."Customer Card Form ID",lrc_Customer);
    //     end;

    //     procedure CustomerNoSearch(vco_CustomerNo: Code[20];var rco_CustomerNo: Code[20]): Boolean
    //     var
    //         lrc_ADFSetup: Record "5110302";
    //         lrc_Customer: Record "Customer";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Suche der Debitorennummer
    //         // ------------------------------------------------------------------------------------

    //         // Suche nach Debitorennummer
    //         lrc_Customer.Reset();
    //         IF lrc_Customer.GET(vco_CustomerNo) THEN BEGIN
    //           rco_CustomerNo := lrc_Customer."No.";
    //           EXIT(TRUE);
    //         END;

    //         lrc_ADFSetup.GET();
    //         lrc_ADFSetup.TESTFIELD("Customer Search Form ID");

    //         // Suche nach Debitorensuchbegriff
    //         lrc_Customer.Reset();
    //         lrc_Customer.SETCURRENTKEY("Search Name");

    //         IF FORM.RUNMODAL(lrc_ADFSetup."Customer Search Form ID",lrc_Customer) <> ACTION::LookupOK THEN
    //           EXIT(FALSE);

    //         rco_CustomerNo := lrc_Customer."No.";
    //         EXIT(TRUE);
    //     end;

    procedure CustomerNoValidate(var rco_CustNo: Code[20]): Boolean
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lfm_CustomerList: Page "Customer List";
    begin
        // -----------------------------------------------------------
        // Funktion zur Validierung der Debitorennummer
        // -----------------------------------------------------------

        IF rco_CustNo = '' THEN
            EXIT(TRUE);
        IF lrc_Customer.GET(rco_CustNo) THEN
            EXIT(TRUE);

        lrc_FruitVisionSetup.GET();

        // Suche nach Nummer 2 wenn erstes Zeichen ein Plus
        IF COPYSTR(rco_CustNo, 1, 1) = '+' THEN BEGIN
            rco_CustNo := COPYSTR(rco_CustNo, 2, 20);
            lrc_Customer.RESET();
            lrc_Customer.SETRANGE("POI No. 2", rco_CustNo);
            IF lrc_Customer.FIND('-') THEN BEGIN
                rco_CustNo := lrc_Customer."No.";
                EXIT(TRUE);
            END;
        END;

        lrc_Customer.RESET();
        lrc_Customer.SETCURRENTKEY("Search Name");
        lrc_Customer.SETFILTER("Search Name", '%1', ('*' + rco_CustNo + '*'));
        IF lrc_Customer.FIND('-') THEN BEGIN
            IF lrc_Customer.COUNT() = 1 THEN BEGIN
                rco_CustNo := lrc_Customer."No.";
                EXIT(TRUE);
            END ELSE
                IF lrc_FruitVisionSetup."Customer Search Page ID" <> 0 THEN BEGIN
                    IF Page.RUNMODAL(lrc_FruitVisionSetup."Customer Search Page ID", lrc_Customer) <> ACTION::LookupOK THEN
                        EXIT(FALSE);
                    rco_CustNo := lrc_Customer."No.";
                    EXIT(TRUE);
                END ELSE BEGIN
                    lfm_CustomerList.LOOKUPMODE := TRUE;
                    lfm_CustomerList.SETTABLEVIEW(lrc_Customer);
                    IF lfm_CustomerList.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                        lrc_Customer.RESET();
                        lfm_CustomerList.GETRECORD(lrc_Customer);
                        rco_CustNo := lrc_Customer."No.";
                        EXIT(TRUE);
                    END ELSE
                        EXIT(FALSE);
                END;
        END ELSE
            EXIT(FALSE);
    end;

    //     procedure CustomerGroupValidate(var rco_CustGroup: Code[20]): Boolean
    //     var
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //         lrc_CustomerGroup: Record "5110398";
    //         lfm_CustomerGroup: Form "5110309";
    //     begin
    //         // -----------------------------------------------------------
    //         // Funktion zur Validierung der Debitorennummer
    //         // -----------------------------------------------------------

    //         IF rco_CustGroup = '' THEN
    //           EXIT(TRUE);
    //         IF lrc_CustomerGroup.GET(rco_CustGroup) THEN
    //           EXIT(TRUE);

    //         lrc_FruitVisionSetup.GET();

    //         lrc_CustomerGroup.Reset();
    //         lrc_CustomerGroup.SETFILTER(Code,'%1',('*' + rco_CustGroup + '*'));
    //         IF lrc_CustomerGroup.FIND('-') THEN BEGIN
    //           IF lrc_CustomerGroup.COUNT = 1 THEN BEGIN
    //             rco_CustGroup := lrc_CustomerGroup.Code;
    //             EXIT(TRUE);
    //           END ELSE BEGIN
    //             lfm_CustomerGroup.LOOKUPMODE := TRUE;
    //             lfm_CustomerGroup.SETTABLEVIEW(lrc_CustomerGroup);
    //             IF lfm_CustomerGroup.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //               lrc_CustomerGroup.Reset();
    //               lfm_CustomerGroup.GETRECORD(lrc_CustomerGroup);
    //               rco_CustGroup := lrc_CustomerGroup.Code;
    //               EXIT(TRUE);
    //             END ELSE
    //               EXIT(FALSE);
    //           END;
    //         END ELSE
    //           EXIT(FALSE);
    //     end;

    //     procedure "-- VENDOR --"()
    //     begin
    //     end;

    //     procedure ShowVendorCard(vco_VendNo: Code[20];vbn_Modal: Boolean)
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_Vendor: Record "Vendor";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Kreditorenkarte
    //         // ------------------------------------------------------------------------------------

    //         lrc_FruitVisionSetup.GET();
    //         lrc_FruitVisionSetup.TESTFIELD("Vendor Card Form ID");

    //         lrc_Vendor.GET(vco_VendNo);
    //         IF vbn_Modal THEN
    //           FORM.RUNMODAL(lrc_FruitVisionSetup."Vendor Card Form ID",lrc_Vendor)
    //         ELSE
    //           FORM.RUN(lrc_FruitVisionSetup."Vendor Card Form ID",lrc_Vendor);
    //     end;

    //     procedure VendorNoSearch(vco_VendorNo: Code[20];var rco_VendorNo: Code[20]): Boolean
    //     var
    //         lrc_Vendor: Record "Vendor";
    //         lfm_FVVendorSearchList: Form "5110341";
    //         lco_SearchDescription: Code[20];
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Suche der Kreditorennummer
    //         // ------------------------------------------------------------------------------------

    //         // -------------------------------------------------------------------------
    //         // Suche nach Kreditorennr.
    //         // -------------------------------------------------------------------------
    //         lrc_Vendor.Reset();
    //         IF lrc_Vendor.GET(vco_VendorNo) THEN BEGIN
    //           rco_VendorNo := lrc_Vendor."No.";
    //           EXIT(TRUE);
    //         END;

    //         // -------------------------------------------------------------------------
    //         // Suche nach Kreditorensuchbegriff
    //         // -------------------------------------------------------------------------
    //         lrc_Vendor.Reset();
    //         lrc_Vendor.SETCURRENTKEY("Search Name");

    //         lfm_FVVendorSearchList.LOOKUPMODE := TRUE;
    //         lfm_FVVendorSearchList.SETTABLEVIEW(lrc_Vendor);
    //         IF lfm_FVVendorSearchList.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //           lrc_Vendor.Reset();
    //           lfm_FVVendorSearchList.GETRECORD(lrc_Vendor);
    //           rco_VendorNo := lrc_Vendor."No.";
    //           EXIT(TRUE);
    //         END ELSE BEGIN
    //           EXIT(FALSE);
    //         END;
    //     end;

    procedure VendorValidate(var rco_VendNo: Code[20]): Boolean
    var
        lfm_VendorList: Page "Vendor List";
    begin
        // -----------------------------------------------------------
        // Funktion zur Validierung der Kreditorennummer
        // -----------------------------------------------------------

        IF rco_VendNo = '' THEN
            EXIT(TRUE);
        IF lrc_Vendor.GET(rco_VendNo) THEN
            EXIT(TRUE);

        // Suche nach Nummer 2 wenn erstes Zeichen ein Plus
        IF COPYSTR(rco_VendNo, 1, 1) = '+' THEN BEGIN
            rco_VendNo := COPYSTR(rco_VendNo, 2, 20);
            lrc_Vendor.RESET();
            lrc_Vendor.SETRANGE("No. 2", rco_VendNo);
            IF lrc_Vendor.FIND('-') THEN BEGIN
                rco_VendNo := lrc_Vendor."No.";
                EXIT(TRUE);
            END;
        END;

        lrc_Vendor.RESET();
        lrc_Vendor.SETCURRENTKEY("Search Name");
        lrc_Vendor.SETFILTER("Search Name", '%1', ('*' + rco_VendNo + '*'));
        IF lrc_Vendor.FIND('-') THEN BEGIN
            IF lrc_Vendor.COUNT() = 1 THEN BEGIN
                rco_VendNo := lrc_Vendor."No.";
                EXIT(TRUE);
            END ELSE BEGIN
                lfm_VendorList.LOOKUPMODE := TRUE;
                lfm_VendorList.SETTABLEVIEW(lrc_Vendor);
                IF lfm_VendorList.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                    lrc_Vendor.RESET();
                    lfm_VendorList.GETRECORD(lrc_Vendor);
                    rco_VendNo := lrc_Vendor."No.";
                    EXIT(TRUE);
                END ELSE
                    EXIT(FALSE);
            END;
        END ELSE
            EXIT(FALSE);
    end;

    //     procedure "-- ITEM --"()
    //     begin
    //     end;

    //     procedure ShowItemCard(vco_ItemNo: Code[20];vbn_Modal: Boolean)
    //     var
    //         lcu_CompanyDefinedFormMgt: Codeunit "5110381";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_Item: Record Item;
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Artikelkarte
    //         // ------------------------------------------------------------------------------------

    //         //lcu_CompanyDefinedFormMgt.OnCardItemNo(vco_ItemNo,vbn_Modal);

    //         //{--- ERSETZT DURCH NEUE FUNKTION
    //         lrc_FruitVisionSetup.GET();
    //         lrc_FruitVisionSetup.TESTFIELD("Item Card Form ID");

    //         lrc_Item.GET(vco_ItemNo);
    //         IF vbn_Modal THEN
    //           FORM.RUNMODAL(lrc_FruitVisionSetup."Item Card Form ID",lrc_Item)
    //         ELSE
    //           FORM.RUN(lrc_FruitVisionSetup."Item Card Form ID",lrc_Item);
    //         //----}
    //     end;

    //     procedure ItemDescriptionInArray(vco_ItemNo: Code[20];var rtx_ArrItemDecription: array [5] of Text[100])
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_Customer: Record "Customer";
    //         lrc_Item: Record Item;
    //         lrc_Color: Record "5110310";
    //         lrc_Country: Record "9";
    //         lrc_Variety: Record "5110303";
    //         lrc_Caliber: Record "5110304";
    //         lrc_Packing: Record "5110313";
    //         lrc_ProperName: Record "5110478";
    //         lrc_Treatment: Record "5110314";
    //         lrc_Quality: Record "5110311";
    //         lrc_Trademark: Record "5110306";
    //         lrc_Conservation: Record "5110309";
    //         lrc_PriceCalculation: Record "5110320";
    //         lrc_ItemUnitofMeasure: Record "5404";
    //         lrc_UnitofMeasure: Record "204";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------

    //         // Werte in eine Variable übergeben
    //         CLEAR(rtx_ArrItemDecription);
    //         // Artikelstammsatz lesen
    //         IF NOT lrc_Item.GET(vco_ItemNo) THEN
    //           EXIT;

    //         lrc_FruitVisionSetup.GET();
    //         CASE lrc_FruitVisionSetup."Item Search Desc. Template" OF

    //           // ------------------------------------------------------------------------------------
    //           //
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 1":
    //             BEGIN
    //             END;

    //           // ------------------------------------------------------------------------------------
    //           // Schablone 2 -> Fruchthof Northeim
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 2":
    //             BEGIN

    //               // Zeile Eins ----------------------------------------------------------------

    //               // Artikelbeschreibung + Farbe + Sorte + Caliber
    //               rtx_ArrItemDecription[1] := lrc_Item.Description;
    //               IF lrc_Color.GET(lrc_Item."Item Attribute 2") THEN BEGIN
    //                 rtx_ArrItemDecription[1] := rtx_ArrItemDecription[1] + ' ' + lrc_Color.Description;
    //               END;
    //               IF lrc_Variety.GET(lrc_Item."Variety Code") THEN BEGIN
    //                 rtx_ArrItemDecription[1] := rtx_ArrItemDecription[1] + ' ' + lrc_Variety.Description;
    //               END;
    //               IF lrc_Item."Caliber Code" <> '' THEN BEGIN
    //                 rtx_ArrItemDecription[1] := rtx_ArrItemDecription[1] + ' ' + lrc_Item."Caliber Code";
    //               END;

    //               // Zeile Zwei -----------------------------------------------------------------

    //               IF lrc_Item."Item Attribute 6" <> '' THEN BEGIN
    //                 IF lrc_ProperName.GET(lrc_Item."Item Attribute 6") THEN BEGIN
    //                   IF rtx_ArrItemDecription[2] = '' THEN
    //                     rtx_ArrItemDecription[2] := lrc_ProperName.Description
    //                   ELSE
    //                     rtx_ArrItemDecription[2] := rtx_ArrItemDecription[2] + lrc_ProperName.Description;
    //                 END;
    //               END;

    //               IF lrc_Item."Item Attribute 5" <> '' THEN BEGIN
    //                 IF lrc_Treatment.GET(lrc_Item."Item Attribute 5") THEN BEGIN
    //                   IF rtx_ArrItemDecription[2] = '' THEN
    //                     rtx_ArrItemDecription[2] := lrc_Treatment.Description
    //                   ELSE
    //                     rtx_ArrItemDecription[2] := rtx_ArrItemDecription[2] + ' ' + lrc_Treatment.Description;
    //                 END;
    //               END;

    //               IF lrc_Item."Item Attribute 3" <> '' THEN BEGIN
    //                 IF lrc_Quality.GET(lrc_Item."Item Attribute 3") THEN BEGIN
    //                   IF rtx_ArrItemDecription[2] = '' THEN
    //                     rtx_ArrItemDecription[2] := lrc_Quality.Description
    //                   ELSE
    //                     rtx_ArrItemDecription[2] := rtx_ArrItemDecription[2] + ' ' + lrc_Quality.Description;
    //                 END;
    //               END;

    //               IF lrc_Item."Trademark Code" <> '' THEN BEGIN
    //                 IF lrc_Trademark.GET(lrc_Item."Trademark Code") THEN BEGIN
    //                   IF rtx_ArrItemDecription[2] = '' THEN
    //                     rtx_ArrItemDecription[2] := lrc_Trademark.Description
    //                   ELSE
    //                     rtx_ArrItemDecription[2] := rtx_ArrItemDecription[2] + ' ' + lrc_Trademark.Description;
    //                 END;
    //               END;


    //               // Zeile Drei -----------------------------------------------------------------

    //               // Kolloeinheit
    //               IF lrc_UnitofMeasure.GET(lrc_Item."Purch. Unit of Measure") THEN BEGIN

    //                 IF COPYSTR(lrc_UnitofMeasure.Description,1,6) = 'Kollo ' THEN BEGIN
    //                   IF rtx_ArrItemDecription[3] = '' THEN
    //                     rtx_ArrItemDecription[3] := COPYSTR(lrc_UnitofMeasure.Description,7,30)
    //                   ELSE
    //                     rtx_ArrItemDecription[3] := rtx_ArrItemDecription[3] + ' ' + COPYSTR(lrc_UnitofMeasure.Description,7,30)
    //                 END ELSE BEGIN
    //                   IF rtx_ArrItemDecription[3] = '' THEN
    //                     rtx_ArrItemDecription[3] := lrc_UnitofMeasure.Description
    //                   ELSE
    //                     rtx_ArrItemDecription[3] := rtx_ArrItemDecription[3] + ' ' + lrc_UnitofMeasure.Description;
    //                 END;

    //               END ELSE BEGIN

    //                 // Einheit
    //                 IF COPYSTR(lrc_Item."Purch. Unit of Measure",1,6) = 'Kollo ' THEN BEGIN
    //                   IF rtx_ArrItemDecription[3] = '' THEN
    //                     rtx_ArrItemDecription[3] := COPYSTR(lrc_Item."Purch. Unit of Measure",7,30)
    //                   ELSE
    //                     rtx_ArrItemDecription[3] := rtx_ArrItemDecription[3] + ' ' + COPYSTR(lrc_Item."Purch. Unit of Measure",7,30)
    //                 END ELSE BEGIN
    //                   IF rtx_ArrItemDecription[3] = '' THEN
    //                     rtx_ArrItemDecription[3] := lrc_Item."Purch. Unit of Measure"
    //                   ELSE
    //                     rtx_ArrItemDecription[3] := rtx_ArrItemDecription[3] + ' ' + lrc_Item."Purch. Unit of Measure";
    //                 END;
    //               END;

    //               // Abpackung
    //               IF lrc_Packing.GET(lrc_Item."Item Attribute 4") THEN BEGIN
    //                 IF rtx_ArrItemDecription[3] = '' THEN
    //                   rtx_ArrItemDecription[3] := lrc_Packing.Description
    //                 ELSE
    //                   rtx_ArrItemDecription[3] := rtx_ArrItemDecription[3] + ' ' + lrc_Packing.Description;
    //               END;

    //               // Leergut
    //               IF lrc_Item."Empties Item No." <> '' THEN BEGIN
    //                 IF lrc_Item.GET(lrc_Item."Empties Item No.") THEN BEGIN
    //                   IF rtx_ArrItemDecription[3] = '' THEN
    //                     rtx_ArrItemDecription[3] := '<' + lrc_Item.Description + '>'
    //                   ELSE
    //                     rtx_ArrItemDecription[3] := rtx_ArrItemDecription[3] + ' <' + lrc_Item.Description + '>';
    //                 END;
    //               END;

    //               // Konservierung
    //               IF lrc_Item."Item Attribute 7" <> '' THEN BEGIN
    //                 IF rtx_ArrItemDecription[3] = '' THEN
    //                   rtx_ArrItemDecription[3] := lrc_Item."Item Attribute 7"
    //                 ELSE
    //                   rtx_ArrItemDecription[3] := rtx_ArrItemDecription[3] + ' ' + lrc_Item."Item Attribute 7";
    //               END;


    //               // Falls Beschreibung 2 leer ist, dann Beschreibung 3 dort einsetzen
    //               IF rtx_ArrItemDecription[2] = '' THEN BEGIN
    //                 rtx_ArrItemDecription[2] := rtx_ArrItemDecription[3];
    //                 rtx_ArrItemDecription[3] := '';
    //               END;

    //             END;

    //           // ------------------------------------------------------------------------------------
    //           // Schablone 5 -> Im Einsatz bei Biotropic
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 5":
    //             BEGIN

    //               rtx_ArrItemDecription[1] := lrc_Item.Description;

    //               IF (lrc_Item."Item Main Category Code" = '2') OR
    //                  (lrc_Item."Item Main Category Code" = '8') OR
    //                  (lrc_Item."Item Main Category Code" = '9') THEN BEGIN
    //               END ELSE BEGIN

    //                 IF lrc_Item."Variety Code" <> '' THEN BEGIN
    //                   lrc_Variety.GET(lrc_Item."Variety Code");
    //                   IF rtx_ArrItemDecription[1] <> '' THEN
    //                     rtx_ArrItemDecription[1] := rtx_ArrItemDecription[1] + ', ' + lrc_Variety.Description
    //                   ELSE
    //                     rtx_ArrItemDecription[1] := lrc_Variety.Description;
    //                 END;

    //                 IF lrc_Item."Country/Region of Origin Code" <> '' THEN BEGIN
    //                   lrc_Country.GET(lrc_Item."Country of Origin Code (Fruit)");
    //                   IF rtx_ArrItemDecription[2] <> '' THEN
    //                     rtx_ArrItemDecription[2] := rtx_ArrItemDecription[2] + ', ' + lrc_Country.Name
    //                   ELSE
    //                     rtx_ArrItemDecription[2] := lrc_Country.Name;
    //                 END;

    //                 IF lrc_Item."Caliber Code" <> '' THEN BEGIN
    //                   lrc_Caliber.GET(lrc_Item."Caliber Code");
    //                   IF rtx_ArrItemDecription[2] <> '' THEN
    //                     rtx_ArrItemDecription[2] := rtx_ArrItemDecription[2] + ', ' + lrc_Caliber.Description
    //                   ELSE
    //                     rtx_ArrItemDecription[2] := lrc_Caliber.Description;
    //                 END;

    //                 IF lrc_Item."Item Attribute 3" <> '' THEN BEGIN
    //                   lrc_Quality.GET(lrc_Item."Item Attribute 3");
    //                   IF rtx_ArrItemDecription[2] <> '' THEN
    //                     rtx_ArrItemDecription[2] := rtx_ArrItemDecription[2] + ', ' + lrc_Quality.Description
    //                   ELSE
    //                     rtx_ArrItemDecription[2] := lrc_Quality.Description;
    //                 END;
    //               END;

    //             END;

    //           // ------------------------------------------------------------------------------------
    //           // Schablone 12 -> Im Einsatz bei INTERWeichert
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 12":
    //             BEGIN
    //             END;

    //           // ------------------------------------------------------------------------------------
    //           // Schablone 17 -> Im Einsatz bei Del Monte Fresh
    //           // ------------------------------------------------------------------------------------
    //           // DMG 002 DMG50090.s
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 17":
    //             BEGIN
    //             END;
    //           // DMG 002 DMG50090.e
    //         END;
    //     end;

    //     procedure GetItemSearchDescription(vco_ItemNo: Code[20]): Code[100]
    //     var
    //         lrc_Item: Record Item;
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zum Lesen des Suchbegriffes
    //         // ------------------------------------------------------------------------------------

    //         IF lrc_Item.GET(vco_ItemNo) THEN
    //           EXIT(lrc_Item."Search Description")
    //         ELSE
    //           EXIT('');
    //     end;

    procedure ItemNoSearch(vco_ItemNo: Code[20]; vop_Source: Option " ",Purchase,Sales,Transfer; vco_CustomerNo: Code[20]; vdt_OrderDate: Date; vbn_SearchInAssortment: Boolean; vco_AssortmentVersionNo: Code[20]; var rco_ItemNo: Code[20]): Boolean
    var

        lrc_FruitVisionSetup: Record "POI ADF Setup";
        //lrc_AssortmentVersionLine: Record "5110340";
        lcu_GlobalVariablesMgt: Codeunit "POI Global Variables Mgt.";
        lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
        //lfm_FVItemSearchList: Form "5110338";
        lco_SearchDescription: Code[50];
        lco_ProductGroup: Code[20];
        lbn_Plus: Boolean;
    begin
        // -------------------------------------------------------------------------------------------------
        // Funktion zur Suche der Artikelnummer
        // -------------------------------------------------------------------------------------------------
        // vco_ItemNo
        // vop_Source ( ,Purchase,Sales,Transfer)
        // vco_CustomerNo
        // vdt_OrderDate
        // rco_ItemNo
        // -------------------------------------------------------------------------------------------------


        // -------------------------------------------------------------------------------------------------
        // Suche im Artikelstamm
        // -------------------------------------------------------------------------------------------------
        IF vbn_SearchInAssortment = FALSE THEN BEGIN

            // -------------------------------------------------------------------------
            // Suche nach Artikelnr.
            // -------------------------------------------------------------------------
            lrc_Item.RESET();
            IF lrc_Item.GET(vco_ItemNo) THEN BEGIN
                rco_ItemNo := lrc_Item."No.";
                EXIT(TRUE);
            END;

            // Einrichtung Fruitvision lesen
            lrc_FruitVisionSetup.GET();
            //lrc_FruitVisionSetup.TESTFIELD("Item Search List Form ID");

            // -------------------------------------------------------------------------
            // Suche nach 2. Artikelnr.
            // -------------------------------------------------------------------------
            IF lrc_FruitVisionSetup."Item No. 2 Activ" THEN BEGIN

                // Kontrolle auf führendes Plus als Kennzeichen für Artikelnummer 2, wenn es Überschneidungen mit Nummern 1 gibt
                IF COPYSTR(vco_ItemNo, 1, 1) = '+' THEN BEGIN
                    vco_ItemNo := COPYSTR(vco_ItemNo, 2, 20);
                    lbn_Plus := TRUE;
                END;

                IF ((STRLEN(vco_ItemNo) = lrc_FruitVisionSetup."Item No. 2 Length") AND
                   (lcu_GlobalFunctions.IsTextNumber(vco_ItemNo))) OR
                   (lbn_Plus) THEN BEGIN
                    lrc_Item.RESET();
                    lrc_Item.SETCURRENTKEY("No. 2");
                    lrc_Item.SETRANGE("No. 2", vco_ItemNo);
                    lrc_Item.SETRANGE("POI Activ in Sales", TRUE);
                    IF lrc_Item.COUNT() > 1 THEN BEGIN
                        lcu_GlobalVariablesMgt.ItemSearchSetGlobalValues(vco_CustomerNo, vdt_OrderDate, vdt_OrderDate, vdt_OrderDate, '', '', vco_ItemNo, '', TRUE, vop_Source);
                        IF Page.RUNMODAL(lrc_FruitVisionSetup."Item Search List Page ID", lrc_Item) = ACTION::LookupOK THEN BEGIN
                            rco_ItemNo := lrc_Item."No.";
                            EXIT(TRUE);
                        END ELSE BEGIN
                            rco_ItemNo := '';
                            EXIT(FALSE);
                        END;
                    END ELSE
                        IF lrc_Item.FIND('-') THEN begin
                            rco_ItemNo := lrc_Item."No.";
                            EXIT(TRUE);
                        end;
                END;
            END;

            // -------------------------------------------------------------------------
            // Suche nach Produktgruppe
            // -------------------------------------------------------------------------
            IF ((lrc_FruitVisionSetup."String Length Product Group" = 0) OR
               (STRLEN(vco_ItemNo) = lrc_FruitVisionSetup."String Length Product Group")) AND
               (
               ((lrc_FruitVisionSetup."String Character Product Group" =
                  lrc_FruitVisionSetup."String Character Product Group"::Numeric) AND
                 (lcu_GlobalFunctions.IsTextNumber(vco_ItemNo)))
               OR
               ((lrc_FruitVisionSetup."String Character Product Group" =
                  lrc_FruitVisionSetup."String Character Product Group"::Alpha) AND
                 (lcu_GlobalFunctions.IsTextText(vco_ItemNo)))
               OR
               ((lrc_FruitVisionSetup."String Character Product Group" =
                 lrc_FruitVisionSetup."String Character Product Group"::Alphanumeric))
              ) THEN BEGIN

                lco_ProductGroup := copystr('*' + vco_ItemNo + '*', 1, 20);

                lrc_Item.RESET();
                //  lrc_Item.SETCURRENTKEY("Product Group Code");
                //lrc_Item.SETFILTER("Product Group Code", '%1', lco_ProductGroup); //TODO: product group code in Item
                IF lrc_Item.FIND('-') THEN
                    IF lrc_Item.COUNT() > 1 THEN BEGIN
                        lcu_GlobalVariablesMgt.ItemSearchSetGlobalValues(vco_CustomerNo, vdt_OrderDate, vdt_OrderDate, vdt_OrderDate, '', lco_ProductGroup, '', '', TRUE, vop_Source);
                        IF Page.RUNMODAL(lrc_FruitVisionSetup."Item Search List Page ID", lrc_Item) = ACTION::LookupOK THEN BEGIN
                            rco_ItemNo := lrc_Item."No.";
                            EXIT(TRUE);
                        END ELSE BEGIN
                            rco_ItemNo := '';
                            EXIT(FALSE);
                        END;
                    END ELSE BEGIN
                        rco_ItemNo := lrc_Item."No.";
                        EXIT(TRUE);
                    END;
            END;

            // -------------------------------------------------------------------------
            // Suche nach Teil der Artikelnr.
            // -------------------------------------------------------------------------
            IF (lcu_GlobalFunctions.IsTextNumber(vco_ItemNo)) THEN BEGIN
                lrc_Item.RESET();
                lrc_Item.SETCURRENTKEY("No.");

                lrc_Item.SETFILTER("No.", (vco_ItemNo + '*'));
                IF lrc_Item.FIND('-') THEN
                    IF lrc_Item.COUNT() > 1 THEN BEGIN
                        lcu_GlobalVariablesMgt.ItemSearchSetGlobalValues(vco_CustomerNo, vdt_OrderDate, vdt_OrderDate, vdt_OrderDate,
                                                             '', '', '', (vco_ItemNo + '*'), TRUE, vop_Source);
                        IF Page.RUNMODAL(lrc_FruitVisionSetup."Item Search List Page ID", lrc_Item) = ACTION::LookupOK THEN BEGIN
                            rco_ItemNo := lrc_Item."No.";
                            EXIT(TRUE);
                        END ELSE BEGIN
                            rco_ItemNo := '';
                            EXIT(FALSE);
                        END;
                    END ELSE BEGIN
                        rco_ItemNo := lrc_Item."No.";
                        EXIT(TRUE);
                    END;
            END;

            // -------------------------------------------------------------------------
            // Suche nach Suchbegriff
            // -------------------------------------------------------------------------
            lco_SearchDescription := vco_ItemNo;

            lrc_Item.RESET();
            lrc_Item.SETCURRENTKEY("Search Description");
            lco_SearchDescription := CreateItemSearchString(lco_SearchDescription);
            lrc_Item.SETFILTER("Search Description", lco_SearchDescription);
            IF lrc_Item.FIND('-') THEN BEGIN
                IF lrc_Item.COUNT() > 1 THEN BEGIN
                    lcu_GlobalVariablesMgt.ItemSearchSetGlobalValues(vco_CustomerNo, vdt_OrderDate, vdt_OrderDate,
                                                                     vdt_OrderDate, lco_SearchDescription, '',
                                                                     '', '', TRUE, vop_Source);
                    IF Page.RUNMODAL(lrc_FruitVisionSetup."Item Search List Page ID", lrc_Item) = ACTION::LookupOK THEN BEGIN
                        rco_ItemNo := lrc_Item."No.";
                        EXIT(TRUE);
                    END ELSE BEGIN
                        rco_ItemNo := '';
                        EXIT(FALSE);
                    END;
                END ELSE BEGIN
                    rco_ItemNo := lrc_Item."No.";
                    EXIT(TRUE);
                END;
            END ELSE BEGIN
                rco_ItemNo := '';
                EXIT(FALSE);
            END;

            // -------------------------------------------------------------------------------------------------
            // Suche im Sortiment
            // -------------------------------------------------------------------------------------------------
        END ELSE BEGIN

            // Einrichtung Fruitvision lesen
            lrc_FruitVisionSetup.GET();

            // -------------------------------------------------------------------------
            // Suche nach Artikelnr.
            // -------------------------------------------------------------------------
            // IF lrc_Item.GET(vco_ItemNo) THEN BEGIN //wird bei Port nicht benutzt -> bisher
            //     // Kontrolle ob Artikel im Sortiment
            //     lrc_AssortmentVersionLine.RESET();
            //     lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.", vco_AssortmentVersionNo);
            //     lrc_AssortmentVersionLine.SETRANGE("Item No.", vco_ItemNo);
            //     IF lrc_AssortmentVersionLine.FIND('-') THEN BEGIN
            //         rco_ItemNo := lrc_Item."No.";
            //         EXIT(TRUE);
            //     END ELSE BEGIN
            //         rco_ItemNo := '';
            //         EXIT(FALSE);
            //     END;
            // END;


            // -------------------------------------------------------------------------
            // Suche nach Suchbegriff
            // -------------------------------------------------------------------------
            lco_SearchDescription := vco_ItemNo;
            lco_SearchDescription := CreateItemSearchString(lco_SearchDescription);

            // lrc_AssortmentVersionLine.RESET();
            // lrc_AssortmentVersionLine.SETCURRENTKEY("Search Description");
            // lrc_AssortmentVersionLine.FILTERGROUP(2);
            // lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.", vco_AssortmentVersionNo);
            // lrc_AssortmentVersionLine.FILTERGROUP(0);
            // lrc_AssortmentVersionLine.SETFILTER("Search Description", lco_SearchDescription);
            // IF lrc_AssortmentVersionLine.FIND('-') THEN BEGIN
            //     IF lrc_AssortmentVersionLine.COUNT() > 1 THEN BEGIN
            //         IF Page.RUNMODAL(5110785, lrc_AssortmentVersionLine) = ACTION::LookupOK THEN BEGIN
            //             rco_ItemNo := lrc_AssortmentVersionLine."Item No.";
            //             EXIT(TRUE);
            //         END ELSE BEGIN
            //             rco_ItemNo := '';
            //             EXIT(FALSE);
            //         END;
            //     END ELSE BEGIN
            //         rco_ItemNo := lrc_AssortmentVersionLine."Item No.";
            //         EXIT(TRUE);
            //     END;
            // END ELSE BEGIN
            //     rco_ItemNo := '';
            //     EXIT(FALSE);
            // END;

        END;
    end;

    //     procedure CreateItemDiscGrpFromProdGrp()
    //     var
    //         lrc_ProductGroup: Record "5723";
    //         lrc_ItemDiscountGroup: Record "341";
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zur Anlage Artikelrabattgruppe gemäß Produktgruppe
    //         // ---------------------------------------------------------------------------------

    //         lrc_ProductGroup.Reset();
    //         IF lrc_ProductGroup.FIND('-') THEN
    //           REPEAT
    //             IF NOT lrc_ItemDiscountGroup.GET(lrc_ProductGroup.Code) THEN BEGIN
    //               lrc_ItemDiscountGroup.Reset();
    //               lrc_ItemDiscountGroup.INIT();
    //               lrc_ItemDiscountGroup.Code := lrc_ProductGroup.Code;
    //               lrc_ItemDiscountGroup.Description := lrc_ProductGroup.Description;
    //               lrc_ItemDiscountGroup.insert();
    //             END;
    //           UNTIL lrc_ProductGroup.NEXT() = 0;
    //     end;

    //     procedure ItemCheckIfItemIsInUse(vco_ItemNo: Code[20])
    //     var
    //         lrc_AssortmentVersionLine: Record "5110340";
    //         lrc_SalesLine: Record "37";
    //         lrc_PurchaseLine: Record "39";
    //         AGILES_LT_TEXT001: Label 'Artikel ist bereits in einem Sortiment!';
    //         AGILES_LT_TEXT002: Label 'Artikel ist bereits in einem Einkauf!';
    //         AGILES_LT_TEXT003: Label 'Artikel ist bereits in einem Verkauf!';
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         AGILES_LT_TEXT004: Label 'Artikel ist bereits in einem Packauftrag Output!';
    //     begin
    //         // ------------------------------------------------------------------------------------------
    //         // Funktion zur Prüfung ob der Artikel bereits in Verwendung ist
    //         // ------------------------------------------------------------------------------------------

    //         lrc_AssortmentVersionLine.SETCURRENTKEY("Item No.","Assortment Version No.");
    //         lrc_AssortmentVersionLine.SETRANGE("Item No.",vco_ItemNo);
    //         IF lrc_AssortmentVersionLine.FIND('-') THEN
    //           // Artikel ist bereits in einem Sortiment!
    //           ERROR(AGILES_LT_TEXT001);

    //         lrc_PurchaseLine.SETCURRENTKEY(Type,"No.","Variant Code","Drop Shipment","Location Code","Document Type","Expected Receipt Date");
    //         lrc_PurchaseLine.SETRANGE(Type,lrc_PurchaseLine.Type::Item);
    //         lrc_PurchaseLine.SETRANGE("No.",vco_ItemNo);
    //         IF lrc_PurchaseLine.FIND('-') THEN
    //           // Artikel ist bereits in einem Einkauf!
    //           ERROR(AGILES_LT_TEXT002);

    //         lrc_SalesLine.SETCURRENTKEY(Type,"No.","Variant Code","Drop Shipment","Location Code","Document Type","Shipment Date");
    //         lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //         lrc_SalesLine.SETRANGE("No.",vco_ItemNo);
    //         IF lrc_SalesLine.FIND('-') THEN
    //           // Artikel ist bereits in einem Verkauf!
    //           ERROR(AGILES_LT_TEXT003);

    //         lrc_PackOrderOutputItems.SETCURRENTKEY("Item No.","Variant Code","Batch Variant No.","Location Code");
    //         lrc_PackOrderOutputItems.SETRANGE("Item No.",vco_ItemNo);
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN
    //           // Artikel ist bereits in einem Packauftrag Output
    //           ERROR(AGILES_LT_TEXT004);
    //     end;

    //     procedure ItemUOfMCheckExistingEntryLine(vco_ItemNo: Code[20];vco_UnitOfMeasure: Code[10])
    //     var
    //         lrc_ItemLedgerEntry: Record "32";
    //         lrc_SalesLine: Record "37";
    //         lrc_PurchaseLine: Record "39";
    //         lrc_BatchVariantEntry: Record "5110368";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         Agilestext001: Label 'Die Einheit %1, Artikel %2 existiert bereits in der Tabelle %3, Änderung / Löschung nicht zulässig !';
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------

    //         // F40 004 FV400009.s
    //         lrc_BatchVariantEntry.Reset();
    //         lrc_BatchVariantEntry.SETCURRENTKEY("Unit of Measure Code", "Item No.");
    //         lrc_BatchVariantEntry.SETRANGE("Unit of Measure Code",vco_UnitOfMeasure);
    //         lrc_BatchVariantEntry.SETRANGE("Item No.",vco_ItemNo);
    //         IF lrc_BatchVariantEntry.FIND('-') THEN
    //           ERROR(Agilestext001, vco_UnitOfMeasure, vco_ItemNo, lrc_BatchVariantEntry.TABLECAPTION());

    //         lrc_ItemLedgerEntry.Reset();
    //         lrc_ItemLedgerEntry.SETCURRENTKEY("Item No.",Open,"Variant Code","Unit of Measure Code",Positive,
    //            "Location Code","Posting Date","Expiration Date","Lot No.","Serial No.");
    //         lrc_ItemLedgerEntry.SETRANGE("Item No.", vco_ItemNo);
    //         lrc_ItemLedgerEntry.SETRANGE("Unit of Measure Code",vco_UnitOfMeasure);
    //         IF lrc_ItemLedgerEntry.FIND('-') THEN
    //           // Die Einheit %1, Artikel %2 existiert bereits in der Tabelle %3, Änderung / Löschung nicht zulässig !
    //           ERROR(Agilestext001,vco_UnitOfMeasure,vco_ItemNo,lrc_ItemLedgerEntry.TABLECAPTION());

    //         lrc_PurchaseLine.Reset();
    //         lrc_PurchaseLine.SETCURRENTKEY("Unit of Measure Code", Type, "No.");
    //         lrc_PurchaseLine.SETRANGE("Unit of Measure Code",vco_UnitOfMeasure);
    //         lrc_PurchaseLine.SETRANGE(Type,lrc_PurchaseLine.Type::Item);
    //         lrc_PurchaseLine.SETRANGE("No.",vco_ItemNo);
    //         IF lrc_PurchaseLine.FIND('-') THEN
    //           ERROR(Agilestext001, vco_UnitOfMeasure,vco_ItemNo, lrc_PurchaseLine.TABLECAPTION());

    //         lrc_PackOrderOutputItems.Reset();
    //         lrc_PackOrderOutputItems.SETCURRENTKEY("Unit of Measure Code", "Item No.");
    //         lrc_PackOrderOutputItems.SETRANGE("Unit of Measure Code",vco_UnitOfMeasure);
    //         lrc_PackOrderOutputItems.SETRANGE("Item No.",vco_ItemNo);
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN
    //           ERROR(Agilestext001,vco_UnitOfMeasure,vco_ItemNo, lrc_PackOrderOutputItems.TABLECAPTION());

    //         lrc_SalesLine.Reset();
    //         //lrc_SalesLine.SETCURRENTKEY(Type,"No.","Variant Code","Location Code","Unit of Measure Code","Created From Sales Line Pallet");
    //         lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
    //         lrc_SalesLine.SETRANGE("No.",vco_ItemNo);
    //         lrc_SalesLine.SETRANGE("Unit of Measure Code",vco_UnitOfMeasure);
    //         IF lrc_SalesLine.FIND('-') THEN
    //           ERROR(Agilestext001,vco_UnitOfMeasure,vco_ItemNo,lrc_SalesLine.TABLECAPTION());
    //         // F40 004 FV400009.e
    //     end;

    //     procedure "-- ITEM HIERARCHY --"()
    //     begin
    //     end;

    //     procedure CreateItemHierarchy()
    //     var
    //         lrc_ItemHierarchy: Record "5110402";
    //         lrc_ItemMainCategory: Record "5110401";
    //         lrc_ItemCategory: Record "5722";
    //         lrc_ProductGroup: Record "5723";
    //         lrc_Item: Record Item;
    //         lrc_ItemVariant: Record "5401";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktion zur Erstellung der Artikelhierarchie
    //         // -------------------------------------------------------------------------------------

    //         lrc_ItemHierarchy.Reset();
    //         lrc_ItemHierarchy.DELETEALL();

    //         lrc_ItemMainCategory.Reset();
    //         lrc_ItemMainCategory.SETFILTER(Code,'<>%1','');
    //         IF lrc_ItemMainCategory.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_ItemHierarchy.Reset();
    //             lrc_ItemHierarchy.INIT();
    //             lrc_ItemHierarchy."Item Main Category Code" := lrc_ItemMainCategory.Code;
    //             lrc_ItemHierarchy."Item Category Code" := '';
    //             lrc_ItemHierarchy."Product Group Code" := '';
    //             lrc_ItemHierarchy."Item No." := '';
    //             lrc_ItemHierarchy."Variant Code" := '';
    //             lrc_ItemHierarchy.Description := lrc_ItemMainCategory.Description;
    //             lrc_ItemHierarchy."Search Description" := lrc_ItemHierarchy.Description;
    //             lrc_ItemHierarchy.Indentation := 0;
    //             IF NOT lrc_ItemHierarchy.INSERT THEN;

    //             lrc_ItemCategory.Reset();
    //             lrc_ItemCategory.SETFILTER(Code,'<>%1','');
    //             lrc_ItemCategory.SETRANGE("Item Main Category Code",lrc_ItemMainCategory.Code);
    //             IF lrc_ItemCategory.FIND('-') THEN BEGIN
    //               REPEAT

    //                 lrc_ItemHierarchy.Reset();
    //                 lrc_ItemHierarchy.INIT();
    //                 lrc_ItemHierarchy."Item Main Category Code" := lrc_ItemMainCategory.Code;
    //                 lrc_ItemHierarchy."Item Category Code" := lrc_ItemCategory.Code;
    //                 lrc_ItemHierarchy."Product Group Code" := '';
    //                 lrc_ItemHierarchy."Item No." := '';
    //                 lrc_ItemHierarchy."Variant Code" := '';
    //                 lrc_ItemHierarchy.Description := COPYSTR(lrc_ItemCategory.Description + '  [' +
    //                                                  lrc_ItemCategory.Code + ']', 1, 50);
    //                 lrc_ItemHierarchy."Search Description" := lrc_ItemHierarchy.Description;
    //                 lrc_ItemHierarchy.Indentation := 1;
    //                 IF NOT lrc_ItemHierarchy.INSERT THEN;

    //                 lrc_ProductGroup.Reset();
    //                 lrc_ProductGroup.SETFILTER(Code,'<>%1','');
    //                 lrc_ProductGroup.SETRANGE("Item Category Code",lrc_ItemCategory.Code);
    //                 IF lrc_ProductGroup.FIND('-') THEN BEGIN
    //                   REPEAT

    //                     lrc_ItemHierarchy.Reset();
    //                     lrc_ItemHierarchy.INIT();
    //                     lrc_ItemHierarchy."Item Main Category Code" := lrc_ItemMainCategory.Code;
    //                     lrc_ItemHierarchy."Item Category Code" := lrc_ItemCategory.Code;
    //                     lrc_ItemHierarchy."Product Group Code" := lrc_ProductGroup.Code;
    //                     lrc_ItemHierarchy."Item No." := '';
    //                     lrc_ItemHierarchy."Variant Code" := '';
    //                     lrc_ItemHierarchy.Description := lrc_ProductGroup.Description;
    //                     IF lrc_ProductGroup."Search Description" <> '' THEN
    //                       lrc_ItemHierarchy."Search Description" := lrc_ProductGroup."Search Description"
    //                     ELSE
    //                       lrc_ItemHierarchy."Search Description" := lrc_ItemHierarchy.Description;
    //                     lrc_ItemHierarchy.Indentation := 2;
    //                     IF NOT lrc_ItemHierarchy.INSERT THEN;

    //                     lrc_Item.SETRANGE("Product Group Code",lrc_ProductGroup.Code);
    //                     IF lrc_Item.FIND('-') THEN BEGIN
    //                       REPEAT

    //                         lrc_ItemHierarchy.Reset();
    //                         lrc_ItemHierarchy.INIT();
    //                         lrc_ItemHierarchy."Item Main Category Code" := lrc_ItemMainCategory.Code;
    //                         lrc_ItemHierarchy."Item Category Code" := lrc_ItemCategory.Code;
    //                         lrc_ItemHierarchy."Product Group Code" := lrc_ProductGroup.Code;
    //                         lrc_ItemHierarchy."Item No." := lrc_Item."No.";
    //                         lrc_ItemHierarchy."Variant Code" := '';
    //                         lrc_ItemHierarchy.Description := COPYSTR(lrc_Item.Description,1,40);
    //                         lrc_ItemHierarchy.Description := lrc_ItemHierarchy.Description + ' (' + lrc_Item."No." + ')';
    //                         lrc_ItemHierarchy."Search Description" := lrc_Item."Search Description";
    //                         lrc_ItemHierarchy.Indentation := 3;
    //                         IF NOT lrc_ItemHierarchy.INSERT THEN;

    //                         lrc_ItemVariant.SETRANGE("Item No.",lrc_Item."No.");
    //                         IF lrc_ItemVariant.FIND('-') THEN BEGIN
    //                           REPEAT
    //                             lrc_ItemHierarchy.Reset();
    //                             lrc_ItemHierarchy.INIT();
    //                             lrc_ItemHierarchy."Item Main Category Code" := lrc_ItemMainCategory.Code;
    //                             lrc_ItemHierarchy."Item Category Code" := lrc_ItemCategory.Code;
    //                             lrc_ItemHierarchy."Product Group Code" := lrc_ProductGroup.Code;
    //                             lrc_ItemHierarchy."Item No." := lrc_Item."No.";
    //                             lrc_ItemHierarchy."Variant Code" := lrc_ItemVariant.Code;
    //                             lrc_ItemHierarchy.Description := COPYSTR(lrc_Item.Description,1,40);
    //                             lrc_ItemHierarchy.Description := lrc_ItemHierarchy.Description + ' (' + lrc_Item."No." + ')';
    //                             lrc_ItemHierarchy."Search Description" := lrc_Item."Search Description";
    //                             lrc_ItemHierarchy.Indentation := 4;
    //                             IF NOT lrc_ItemHierarchy.INSERT THEN;
    //                           UNTIL lrc_ItemVariant.NEXT() = 0;
    //                         END;

    //                       UNTIL lrc_Item.NEXT() = 0;
    //                     END;
    //                   UNTIL lrc_ProductGroup.NEXT() = 0;
    //                 END;
    //               UNTIL lrc_ItemCategory.NEXT() = 0;
    //             END;
    //           UNTIL lrc_ItemMainCategory.NEXT() = 0;
    //         END;
    //     end;

    //     procedure ItemInsertHierarchy(vrc_ItemHierarchy: Record "5110402")
    //     var
    //         lcu_BDTBaseDataTemplateMgt: Codeunit "5087929";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_Item: Record Item;
    //         lrc_ItemLast: Record Item;
    //         lrc_ItemOld: Record Item;
    //         lrc_ItemUnitofMeasure: Record "5404";
    //         lrc_ProductGroup: Record "5723";
    //         lrc_ItemCategory: Record "5722";
    //         AGILES_LT_TEXT001: Label 'Nicht zulässig!';
    //         lco_NewItemNo: Code[20];
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Neuanlage Artikel über Hierarchiestruktur
    //         // ---------------------------------------------------------------------------------------------

    //         lrc_FruitVisionSetup.GET();

    //         CASE lrc_FruitVisionSetup."Item Insert Template" OF

    //           // ------------------------------------------------------------------------------------
    //           // Schablone 1 -> Rothenburger Marktfrisch Frucht
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 1":
    //             BEGIN

    //               lrc_FruitVisionSetup.TESTFIELD("Item Card Form ID");
    //               vrc_ItemHierarchy.TESTFIELD("Item Main Category Code");
    //               vrc_ItemHierarchy.TESTFIELD("Item Category Code");
    //               vrc_ItemHierarchy.TESTFIELD("Product Group Code");

    //               lrc_Item.Reset();
    //               lrc_Item.INIT();

    //               lrc_ItemLast.INIT();
    //               lrc_ItemLast.Reset();
    //               lrc_ItemLast.SETCURRENTKEY("Item Main Category Code","Item Category Code","Product Group Code");
    //               lrc_ItemLast.SETRANGE("Item Main Category Code",vrc_ItemHierarchy."Item Main Category Code");
    //               lrc_ItemLast.SETRANGE("Item Category Code",vrc_ItemHierarchy."Item Category Code");
    //               lrc_ItemLast.SETRANGE(lrc_ItemLast."Product Group Code",vrc_ItemHierarchy."Product Group Code");
    //               IF NOT lrc_ItemLast.FIND('+') THEN BEGIN
    //                 lrc_Item."No." := vrc_ItemHierarchy."Product Group Code" + '01';
    //               END ELSE BEGIN
    //                 lrc_Item."No." := INCSTR(lrc_ItemLast."No.");
    //               END;

    //               lrc_Item."Item Main Category Code" := vrc_ItemHierarchy."Item Main Category Code";
    //               lrc_Item."Item Category Code" := vrc_ItemHierarchy."Item Category Code";
    //               lrc_Item."Product Group Code" := vrc_ItemHierarchy."Product Group Code";
    //               lrc_Item.INSERT(TRUE);

    //               lrc_ItemUnitofMeasure.INIT();
    //               lrc_ItemUnitofMeasure.Reset();
    //               lrc_ItemUnitofMeasure.SETRANGE("Item No.",lrc_Item."No.");
    //               IF NOT lrc_ItemUnitofMeasure.FIND('-') THEN BEGIN
    //                 lrc_ItemUnitofMeasure.INIT();
    //                 lrc_ItemUnitofMeasure.VALIDATE("Item No.",lrc_Item."No.");
    //                 lrc_ItemUnitofMeasure.VALIDATE( Code, 'KG');
    //                 lrc_ItemUnitofMeasure.INSERT(TRUE);
    //               END;

    //               COMMIT;

    //               lrc_Item.SETRANGE("No.",lrc_Item."No.");
    //               FORM.RUNMODAL(lrc_FruitVisionSetup."Item Card Form ID",lrc_Item);

    //             END;

    //           // ------------------------------------------------------------------------------------
    //           // Schablone 2 -> Fruchthof Northeim
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 2":
    //             BEGIN

    //               lrc_FruitVisionSetup.TESTFIELD("Item Card Form ID");

    //               vrc_ItemHierarchy.TESTFIELD("Item Main Category Code");
    //               vrc_ItemHierarchy.TESTFIELD("Item Category Code");
    //               vrc_ItemHierarchy.TESTFIELD("Product Group Code");

    //               IF vrc_ItemHierarchy."Item No." <> '' THEN
    //                 // Nicht zulässig!
    //                 ERROR(AGILES_LT_TEXT001);

    //               lrc_Item.Reset();
    //               lrc_Item.INIT();

    //               lrc_ItemLast.SETFILTER("No.",'%1',(vrc_ItemHierarchy."Product Group Code" + '????'));
    //               IF NOT lrc_ItemLast.FIND('+') THEN BEGIN
    //                 lrc_Item."No." := vrc_ItemHierarchy."Product Group Code" + '0001';
    //               END ELSE BEGIN
    //                 lrc_Item."No." := INCSTR(lrc_ItemLast."No.");
    //               END;
    //               lrc_Item.INSERT(TRUE);
    //               COMMIT;

    //               lrc_Item.SETRANGE("No.",lrc_Item."No.");
    //               FORM.RUNMODAL(lrc_FruitVisionSetup."Item Card Form ID",lrc_Item);

    //             END;

    //           // ------------------------------------------------------------------------------------
    //           // Schablone 3 -> Rothenburger Marktfrisch Getränke
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 3":
    //             BEGIN

    //               lrc_FruitVisionSetup.TESTFIELD("Item Card Form ID");
    //               vrc_ItemHierarchy.TESTFIELD("Item Main Category Code");
    //               vrc_ItemHierarchy.TESTFIELD("Item Category Code");
    //               vrc_ItemHierarchy.TESTFIELD("Product Group Code");

    //               lrc_Item.Reset();
    //               lrc_Item.INIT();

    //               lrc_ItemLast.INIT();
    //               lrc_ItemLast.Reset();
    //               lrc_ItemLast.SETCURRENTKEY("Item Main Category Code","Item Category Code","Product Group Code");
    //               lrc_ItemLast.SETRANGE("Item Main Category Code",vrc_ItemHierarchy."Item Main Category Code");
    //               lrc_ItemLast.SETRANGE("Item Category Code",vrc_ItemHierarchy."Item Category Code");
    //               //lrc_ItemLast.SETRANGE(lrc_ItemLast."Product Group Code",vrc_ItemHierarchy."Product Group Code");
    //               IF NOT lrc_ItemLast.FIND('+') THEN BEGIN
    //                 lrc_Item."No." := vrc_ItemHierarchy."Item Category Code" + '001';   //!!!!!!
    //               END ELSE BEGIN
    //                 lrc_Item."No." := INCSTR(lrc_ItemLast."No.");
    //               END;

    //               lrc_Item."Item Main Category Code" := vrc_ItemHierarchy."Item Main Category Code";
    //               lrc_Item."Item Category Code" := vrc_ItemHierarchy."Item Category Code";
    //               lrc_Item."Product Group Code" := vrc_ItemHierarchy."Product Group Code";
    //               //lrc_Item.INSERT(TRUE);

    //               IF NOT lrc_Item.INSERT(TRUE) THEN REPEAT
    //                 lrc_Item."No." := INCSTR(lrc_Item."No.");
    //               UNTIL lrc_Item.INSERT(TRUE);

    //               lrc_ItemUnitofMeasure.INIT();
    //               lrc_ItemUnitofMeasure.Reset();
    //               lrc_ItemUnitofMeasure.SETRANGE("Item No.",lrc_Item."No.");
    //               IF NOT lrc_ItemUnitofMeasure.FIND('-') THEN BEGIN
    //                 lrc_ItemUnitofMeasure.INIT();
    //                 lrc_ItemUnitofMeasure.VALIDATE("Item No.",lrc_Item."No.");
    //                 lrc_ItemUnitofMeasure.VALIDATE( Code, 'LI');
    //                 lrc_ItemUnitofMeasure.INSERT(TRUE);
    //               END;

    //               COMMIT;

    //               lrc_Item.SETRANGE("No.",lrc_Item."No.");
    //               FORM.RUNMODAL(lrc_FruitVisionSetup."Item Card Form ID",lrc_Item);

    //             END;

    //           // ------------------------------------------------------------------------------------
    //           // Schablone 5 -> Biotropic
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 5":
    //             BEGIN

    //               lrc_FruitVisionSetup.TESTFIELD("Item Card Form ID");
    //               vrc_ItemHierarchy.TESTFIELD("Item Main Category Code");
    //               vrc_ItemHierarchy.TESTFIELD("Item Category Code");
    //               vrc_ItemHierarchy.TESTFIELD("Product Group Code");

    //               lrc_ProductGroup.SETRANGE("Item Category Code",vrc_ItemHierarchy."Item Category Code");
    //               lrc_ProductGroup.SETRANGE(Code,vrc_ItemHierarchy."Product Group Code");
    //               IF lrc_ProductGroup.FIND('-') THEN BEGIN

    //                 lrc_Item.Reset();
    //                 lrc_Item.INIT();

    //                 lrc_ItemLast.Reset();
    //                 lrc_ItemLast.SETCURRENTKEY("Item Main Category Code","Item Category Code","Product Group Code");
    //                 lrc_ItemLast.SETRANGE("Item Main Category Code",vrc_ItemHierarchy."Item Main Category Code");
    //                 lrc_ItemLast.SETRANGE("Item Category Code",vrc_ItemHierarchy."Item Category Code");
    //                 IF NOT lrc_ItemLast.FIND('+') THEN BEGIN
    //                   lrc_Item."No." := vrc_ItemHierarchy."Item Category Code" + '001';   //!!!!!!
    //                 END ELSE BEGIN
    //                   lrc_Item."No." := INCSTR(lrc_ItemLast."No.");
    //                 END;

    //                 lrc_Item."Item Main Category Code" := vrc_ItemHierarchy."Item Main Category Code";
    //                 lrc_Item."Item Category Code" := vrc_ItemHierarchy."Item Category Code";
    //                 lrc_Item."Product Group Code" := vrc_ItemHierarchy."Product Group Code";

    //                 lrc_ItemCategory.Reset();
    //                 lrc_ItemCategory.SETRANGE(Code,lrc_ProductGroup."Item Category Code");
    //                 lrc_ItemCategory.FIND('-');

    //                 lrc_Item.VALIDATE("Item Category Code", lrc_ProductGroup."Item Category Code");
    //                 lrc_Item.VALIDATE("Item Main Category Code", lrc_ItemCategory."Item Main Category Code");
    //                 lrc_Item.VALIDATE("Base Unit of Measure", lrc_ItemCategory."Def. Base Unit of Measure");
    //                 lrc_Item."Batch Item" := lrc_ProductGroup."Def. Batch Item";

    //                 lrc_Item."Gen. Prod. Posting Group" := lrc_ItemCategory."Def. Gen. Prod. Posting Group";
    //                 lrc_Item."VAT Prod. Posting Group" := lrc_ItemCategory."Def. VAT Prod. Posting Group";
    //                 lrc_Item."Inventory Posting Group" := lrc_ItemCategory."Def. Inventory Posting Group";

    //                 lrc_Item.Description := COPYSTR(lrc_ProductGroup.Description,1,30);

    //                 lrc_Item."Search Description" := lcu_BDTBaseDataTemplateMgt.GenerateItemSearchDesc(lrc_Item);
    //                 lrc_Item."Description 2" := lcu_BDTBaseDataTemplateMgt.GenerateItemDesc2(lrc_Item);

    //                 IF NOT lrc_Item.INSERT(TRUE) THEN REPEAT
    //                   lrc_Item."No." := INCSTR(lrc_Item."No.");
    //                 UNTIL lrc_Item.INSERT(TRUE);

    //                 COMMIT;

    //                 lrc_Item.SETRANGE("No.",lrc_Item."No.");
    //                 FORM.RUNMODAL(lrc_FruitVisionSetup."Item Card Form ID",lrc_Item);

    //               END;

    //             END;
    //           // ------------------------------------------------------------------------------------
    //           // Schablone 12 -> INTERWeichert
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 12":
    //             BEGIN

    //               lrc_FruitVisionSetup.TESTFIELD("Item Card Form ID");
    //               vrc_ItemHierarchy.TESTFIELD("Item Main Category Code");
    //               vrc_ItemHierarchy.TESTFIELD("Item Category Code");
    //               vrc_ItemHierarchy.TESTFIELD("Product Group Code");

    //               lrc_ProductGroup.SETRANGE("Item Category Code",vrc_ItemHierarchy."Item Category Code");
    //               lrc_ProductGroup.SETRANGE(Code,vrc_ItemHierarchy."Product Group Code");
    //               IF lrc_ProductGroup.FIND('-') THEN BEGIN

    //                 lrc_Item.Reset();
    //                 lrc_Item.INIT();
    //                 lco_NewItemNo := '';

    //                 lrc_ItemLast.Reset();
    //                 lrc_ItemLast.SETCURRENTKEY("Item Main Category Code","Item Category Code","Product Group Code");
    //                 lrc_ItemLast.SETRANGE("Item Main Category Code",vrc_ItemHierarchy."Item Main Category Code");
    //                 lrc_ItemLast.SETRANGE("Item Category Code",vrc_ItemHierarchy."Item Category Code");
    //                 lrc_ItemLast.SETRANGE("Product Group Code",vrc_ItemHierarchy."Product Group Code");
    //                 IF NOT lrc_ItemLast.FIND('+') THEN BEGIN

    //                   // Zuweisung einer komplett neuen Nummer, da noch kein entsprechender Artikel vorhanden
    //                   lco_NewItemNo := vrc_ItemHierarchy."Item Main Category Code" +
    //                                    vrc_ItemHierarchy."Item Category Code" +
    //                                    vrc_ItemHierarchy."Product Group Code" +
    //                                    '001';
    //                 END ELSE BEGIN

    //                   // Erhöhung um eine Stelle
    //                   lco_NewItemNo := INCSTR(lrc_ItemLast."No.");

    //                   // Prüfung auf schon vorhandene Artikel
    //                   IF lrc_ItemOld.GET(lco_NewItemNo) THEN BEGIN
    //                     REPEAT
    //                       lco_NewItemNo := INCSTR(lco_NewItemNo);
    //                     UNTIL NOT lrc_ItemOld.GET(lco_NewItemNo);
    //                   END;

    //                 END;

    //                 // Zuweisung der ermittelten Artikelnr.
    //                 lrc_Item."No." := lco_NewItemNo;

    //                 lrc_Item."Item Main Category Code" := vrc_ItemHierarchy."Item Main Category Code";
    //                 lrc_Item."Item Category Code" := vrc_ItemHierarchy."Item Category Code";
    //                 lrc_Item."Product Group Code" := vrc_ItemHierarchy."Product Group Code";

    //                 lrc_ItemCategory.Reset();
    //                 lrc_ItemCategory.SETRANGE(Code,lrc_ProductGroup."Item Category Code");
    //                 lrc_ItemCategory.FIND('-');

    //                 lrc_Item.VALIDATE("Item Category Code", lrc_ProductGroup."Item Category Code");
    //                 lrc_Item.VALIDATE("Item Main Category Code", lrc_ItemCategory."Item Main Category Code");
    //                 lrc_Item.VALIDATE("Base Unit of Measure", lrc_ItemCategory."Def. Base Unit of Measure");
    //                 lrc_Item."Batch Item" := lrc_ProductGroup."Def. Batch Item";

    //                 lrc_Item."Gen. Prod. Posting Group" := lrc_ItemCategory."Def. Gen. Prod. Posting Group";
    //                 lrc_Item."VAT Prod. Posting Group" := lrc_ItemCategory."Def. VAT Prod. Posting Group";
    //                 lrc_Item."Inventory Posting Group" := lrc_ItemCategory."Def. Inventory Posting Group";

    //                 lrc_Item.Description := COPYSTR(lrc_ProductGroup.Description,1,30);

    //                 lrc_Item."Search Description" := lcu_BDTBaseDataTemplateMgt.GenerateItemSearchDesc(lrc_Item);
    //                 lrc_Item.Description := lcu_BDTBaseDataTemplateMgt.GenerateItemDesc1(lrc_Item);
    //                 lrc_Item."Description 2" := lcu_BDTBaseDataTemplateMgt.GenerateItemDesc2(lrc_Item);

    //                 // IF lrc_ItemOld.GET(lrc_Item."No.") THEN REPEAT
    //                 //   lrc_Item."No." := INCSTR(lrc_Item."No.");
    //                 // UNTIL NOT lrc_ItemOld.GET(lrc_Item."No.");

    //                 lrc_Item.INSERT(TRUE);

    //                 COMMIT;

    //                 lrc_Item.SETRANGE("No.",lrc_Item."No.");
    //                 FORM.RUNMODAL(lrc_FruitVisionSetup."Item Card Form ID",lrc_Item);

    //               END;
    //             END;
    //           // DMG 002 DMG50090.s
    //           // ------------------------------------------------------------------------------------
    //           // Schablone 17 -> Del Monte Fresh
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 17":
    //             BEGIN

    //               lrc_FruitVisionSetup.TESTFIELD("Item Card Form ID");
    //               vrc_ItemHierarchy.TESTFIELD("Item Main Category Code");
    //               vrc_ItemHierarchy.TESTFIELD("Item Category Code");
    //               vrc_ItemHierarchy.TESTFIELD("Product Group Code");

    //               lrc_ProductGroup.SETRANGE("Item Category Code",vrc_ItemHierarchy."Item Category Code");
    //               lrc_ProductGroup.SETRANGE(Code,vrc_ItemHierarchy."Product Group Code");
    //               IF lrc_ProductGroup.FIND('-') THEN BEGIN

    //                 lrc_Item.Reset();
    //                 lrc_Item.INIT();

    //                 lrc_ItemLast.Reset();
    //                 lrc_ItemLast.SETCURRENTKEY("Item Main Category Code","Item Category Code","Product Group Code");
    //                 lrc_ItemLast.SETRANGE("Item Main Category Code",vrc_ItemHierarchy."Item Main Category Code");
    //                 lrc_ItemLast.SETRANGE("Item Category Code",vrc_ItemHierarchy."Item Category Code");
    //                 IF NOT lrc_ItemLast.FIND('+') THEN BEGIN
    //                   lrc_Item."No." := vrc_ItemHierarchy."Item Category Code" + '001';   //!!!!!!
    //                 END ELSE BEGIN
    //                   lrc_Item."No." := INCSTR(lrc_ItemLast."No.");
    //                 END;

    //                 lrc_Item."Item Main Category Code" := vrc_ItemHierarchy."Item Main Category Code";
    //                 lrc_Item."Item Category Code" := vrc_ItemHierarchy."Item Category Code";
    //                 lrc_Item."Product Group Code" := vrc_ItemHierarchy."Product Group Code";

    //                 lrc_ItemCategory.Reset();
    //                 lrc_ItemCategory.SETRANGE(Code,lrc_ProductGroup."Item Category Code");
    //                 lrc_ItemCategory.FIND('-');

    //                 lrc_Item.VALIDATE("Item Category Code", lrc_ProductGroup."Item Category Code");
    //                 lrc_Item.VALIDATE("Item Main Category Code", lrc_ItemCategory."Item Main Category Code");
    //                 lrc_Item.VALIDATE("Base Unit of Measure", lrc_ItemCategory."Def. Base Unit of Measure");
    //                 lrc_Item."Batch Item" := lrc_ProductGroup."Def. Batch Item";

    //                 lrc_Item."Gen. Prod. Posting Group" := lrc_ItemCategory."Def. Gen. Prod. Posting Group";
    //                 lrc_Item."VAT Prod. Posting Group" := lrc_ItemCategory."Def. VAT Prod. Posting Group";
    //                 lrc_Item."Inventory Posting Group" := lrc_ItemCategory."Def. Inventory Posting Group";

    //                 lrc_Item.Description := COPYSTR(lrc_ProductGroup.Description,1,30);

    //                 lrc_Item."Search Description" := lcu_BDTBaseDataTemplateMgt.GenerateItemSearchDesc(lrc_Item);

    //                 IF NOT lrc_Item.INSERT(TRUE) THEN REPEAT
    //                   lrc_Item."No." := INCSTR(lrc_Item."No.");
    //                 UNTIL lrc_Item.INSERT(TRUE);

    //                 COMMIT;

    //                 lrc_Item.SETRANGE("No.",lrc_Item."No.");
    //                 FORM.RUNMODAL(lrc_FruitVisionSetup."Item Card Form ID",lrc_Item);

    //               END;

    //             END;

    //           // DMG 002 DMG50090.e
    //           ELSE
    //             // Nicht zulässig!
    //             ERROR(AGILES_LT_TEXT001);
    //         END;
    //     end;

    //     procedure ItemHierarchyIndentation()
    //     var
    //         lrc_ItemHierarchy: Record "5110402";
    //         AGILES_LT_TEXT001: Label 'Einrückung, #1#################';
    //         ldc_Dialog: Dialog;
    //         lin_Indentation: Integer;
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktion zur Einrückung der Artikelhierarchie
    //         // -------------------------------------------------------------------------------------

    //         ldc_Dialog.OPEN(AGILES_LT_TEXT001);

    //         IF lrc_ItemHierarchy.FIND('-') THEN
    //           REPEAT
    //             ldc_Dialog.UPDATE(1,lrc_ItemHierarchy."Item Main Category Code");

    //             CASE TRUE OF
    //                 ((lrc_ItemHierarchy."Item Main Category Code" <> '') AND
    //                 (lrc_ItemHierarchy."Item Category Code" = '') AND
    //                 (lrc_ItemHierarchy."Product Group Code" = '')):
    //                   BEGIN
    //                     lin_Indentation := 0;
    //                     lrc_ItemHierarchy.Indentation := lin_Indentation;
    //                   END;

    //                 ((lrc_ItemHierarchy."Item Main Category Code" <> '') AND
    //                 (lrc_ItemHierarchy."Item Category Code" <> '') AND
    //                 (lrc_ItemHierarchy."Product Group Code" = '')):
    //                   BEGIN
    //                     lin_Indentation := lin_Indentation + 1;
    //                     lrc_ItemHierarchy.Indentation := lin_Indentation;
    //                   END;

    //                 ((lrc_ItemHierarchy."Item Main Category Code" <> '') AND
    //                 (lrc_ItemHierarchy."Item Category Code" <> '') AND
    //                 (lrc_ItemHierarchy."Product Group Code" <> '')):
    //                   BEGIN
    //                     lin_Indentation := lin_Indentation + 1;
    //                     lrc_ItemHierarchy.Indentation := lin_Indentation;
    //                   END;

    //                 ((lrc_ItemHierarchy."Item Main Category Code" <> '') AND
    //                 (lrc_ItemHierarchy."Item Category Code" <> '') AND
    //                 (lrc_ItemHierarchy."Product Group Code" <> '')):
    //                   BEGIN
    //                     lin_Indentation := lin_Indentation + 1;
    //                     lrc_ItemHierarchy.Indentation := lin_Indentation;
    //                   END;

    //             END;
    //             lrc_ItemHierarchy.Modify();
    //           UNTIL lrc_ItemHierarchy.NEXT() = 0;

    //         ldc_Dialog.CLOSE;
    //     end;

    //     procedure "-- ITEM MULTIPLE HIERARCHY --"()
    //     begin
    //     end;

    //     procedure ActualItemFields(var vrc_Item: Record Item)
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_ItemMainCategory: Record "5110401";
    //         lrc_ItemCategory: Record "5722";
    //         lrc_ProductGroup: Record "5723";
    //         lrc_ItemMultipleLevelHierarchy: Record "5087959";
    //         lco_ItemMainCategoryCode: Code[10];
    //         lco_ItemCategoryCode: Code[10];
    //         lco_ItemProductGroupCode: Code[10];
    //         ltx_ItemMainCategoryCodeDescr: Text[50];
    //         ltx_ItemCategoryCodeDescr: Text[50];
    //         ltx_ItemProductGroupCodeDescr: Text[50];
    //         lbn_FirstLevel: Boolean;
    //     begin
    //         /*
    //         // DMG 001 DMG50021.s
    //         lrc_FruitVisionSetup.GET();
    //         IF (lrc_FruitVisionSetup."Item Main Categ Hierarchylevel" <> 0) OR
    //            (lrc_FruitVisionSetup."Item Categorie Hierarchylevel" <> 0) OR
    //            (lrc_FruitVisionSetup."Item Productgrp Hierarchylevel" <> 0) THEN BEGIN
    //            IF vrc_Item."Item Hierarchy Code" <> '' THEN BEGIN

    //             lco_ItemMainCategoryCode := '';
    //             lco_ItemCategoryCode := '';
    //             lco_ItemProductGroupCode := '';

    //             ltx_ItemMainCategoryCodeDescr := '';
    //             ltx_ItemCategoryCodeDescr := '';
    //             ltx_ItemProductGroupCodeDescr := '';

    //             IF lrc_ItemMultipleLevelHierarchy.GET( vrc_Item."Item Hierarchy Code") THEN BEGIN
    //               lbn_FirstLevel := FALSE;
    //               REPEAT
    //                  IF (lrc_ItemMultipleLevelHierarchy.Level <> 0) AND
    //                     (lrc_ItemMultipleLevelHierarchy.Level = lrc_FruitVisionSetup."Item Productgrp Hierarchylevel") THEN BEGIN
    //                    lco_ItemProductGroupCode := lrc_ItemMultipleLevelHierarchy.Code;
    //                    ltx_ItemProductGroupCodeDescr := lrc_ItemMultipleLevelHierarchy.Description;
    //                  END;

    //                  IF (lrc_ItemMultipleLevelHierarchy.Level <> 0) AND
    //                     (lrc_ItemMultipleLevelHierarchy.Level = lrc_FruitVisionSetup."Item Categorie Hierarchylevel") THEN BEGIN
    //                    lco_ItemCategoryCode := lrc_ItemMultipleLevelHierarchy.Code;
    //                    ltx_ItemCategoryCodeDescr := lrc_ItemMultipleLevelHierarchy.Description;
    //                  END;

    //                  IF (lrc_ItemMultipleLevelHierarchy.Level <> 0) AND
    //                     (lrc_ItemMultipleLevelHierarchy.Level = lrc_FruitVisionSetup."Item Main Categ Hierarchylevel") THEN BEGIN
    //                   lco_ItemMainCategoryCode := lrc_ItemMultipleLevelHierarchy.Code;
    //                   ltx_ItemMainCategoryCodeDescr := lrc_ItemMultipleLevelHierarchy.Description;
    //                  END;

    //                  IF lrc_ItemMultipleLevelHierarchy."Reference to" = '' THEN BEGIN
    //                     lbn_FirstLevel := TRUE;
    //                  END ELSE BEGIN
    //                    IF NOT lrc_ItemMultipleLevelHierarchy.GET(lrc_ItemMultipleLevelHierarchy."Reference to") THEN BEGIN
    //                      lbn_FirstLevel := TRUE;
    //                    END;
    //                  END;

    //               UNTIL lbn_FirstLevel;


    //               IF lco_ItemMainCategoryCode <> '' THEN BEGIN
    //                 IF NOT lrc_ItemMainCategory.GET(lco_ItemMainCategoryCode) THEN BEGIN
    //                    lrc_ItemMainCategory.INIT();
    //                    lrc_ItemMainCategory.VALIDATE( Code, lco_ItemMainCategoryCode);
    //                    lrc_ItemMainCategory.VALIDATE( Description, ltx_ItemMainCategoryCodeDescr);
    //                    lrc_ItemMainCategory.INSERT( TRUE);
    //                 END;
    //                 vrc_Item.VALIDATE("Item Main Category Code", lco_ItemMainCategoryCode);
    //               END;

    //               IF lco_ItemCategoryCode <> '' THEN BEGIN
    //                 IF NOT lrc_ItemCategory.GET(lco_ItemCategoryCode) THEN BEGIN
    //                    lrc_ItemCategory.INIT();
    //                    lrc_ItemCategory.VALIDATE( Code, lco_ItemCategoryCode);
    //                    IF (lco_ItemMainCategoryCode <> '') THEN BEGIN
    //                      lrc_ItemCategory.VALIDATE("Item Main Category Code", lco_ItemMainCategoryCode);
    //                    END;
    //                    lrc_ItemCategory.VALIDATE( Description, ltx_ItemCategoryCodeDescr);
    //                    lrc_ItemCategory.INSERT( TRUE);
    //                 END;
    //                 vrc_Item.VALIDATE("Item Category Code", lco_ItemCategoryCode);
    //               END;

    //               IF lco_ItemProductGroupCode <> '' THEN BEGIN
    //                 IF NOT lrc_ProductGroup.GET(lco_ItemCategoryCode, lco_ItemProductGroupCode) THEN BEGIN
    //                    lrc_ProductGroup.INIT();
    //                    lrc_ProductGroup.VALIDATE("Item Category Code", lco_ItemCategoryCode);
    //                    lrc_ProductGroup.VALIDATE( Code, lco_ItemProductGroupCode);
    //                    lrc_ProductGroup.VALIDATE( Description, ltx_ItemProductGroupCodeDescr);
    //                    lrc_ProductGroup.INSERT( TRUE);
    //                 END;
    //                  vrc_Item.VALIDATE("Product Group Code", lco_ItemProductGroupCode);
    //               END;
    //              END;
    //            END;
    //         END;
    //         // DMG 001 DMG50021.e
    //         */

    //     end;

    //     procedure "-- UNIT OF MEASURE --"()
    //     begin
    //     end;

    //     procedure NewBaseItemUnit(vco_ItemNo: Code[20];vco_UnitOfMeasure: Code[10])
    //     var
    //         lrc_Item: Record Item;
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_ItemUnitofMeasure: Record "5404";
    //         AGILES_LT_TEXT001: Label 'Keine Artikelnummer übergeben!';
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Neuanlage Basiseinheit (Aufruf aus Artikelstamm)
    //         // ------------------------------------------------------------------------------------

    //         IF (vco_ItemNo = '') THEN
    //           // Keine Artikelnummer übergeben!
    //           ERROR(AGILES_LT_TEXT001);

    //         // Bestehende Einträge löschen
    //         lrc_ItemUnitofMeasure.SETRANGE("Item No.",vco_ItemNo);
    //         lrc_ItemUnitofMeasure.DELETEALL();

    //         IF vco_UnitOfMeasure = '' THEN
    //           EXIT;

    //         lrc_UnitofMeasure.GET(vco_UnitOfMeasure);
    //         lrc_UnitofMeasure.TESTFIELD("Is Base Unit of Measure");

    //         lrc_ItemUnitofMeasure.Reset();
    //         lrc_ItemUnitofMeasure.INIT();
    //         lrc_ItemUnitofMeasure."Item No." := vco_ItemNo;
    //         lrc_ItemUnitofMeasure.VALIDATE( Code, vco_UnitOfMeasure);
    //         lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := 1;
    //         lrc_ItemUnitofMeasure."Kind of Unit of Measure" := lrc_ItemUnitofMeasure."Kind of Unit of Measure"::"Base Unit";
    //         lrc_ItemUnitofMeasure.insert();
    //     end;

    //     procedure NewItemUnit(vco_ItemNo: Code[20];vco_UnitOfMeasure: Code[10])
    //     var
    //         lrc_Item: Record Item;
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_ItemUnitofMeasure: Record "5404";
    //         AGILES_LT_TEXT001: Label 'Die Basiseinheit Artikel ist abweichend von der Basiseinheit der Einheit!';
    //         AGILES_LT_TEXT002: Label 'Die Menge in Basiseinheit in der Artikeleinheitentabelle weicht von der Menge in der Einheitentabelle ab!';
    //         lrc_BaseItemUnitofMeasure: Record "5404";
    //         ldc_BaseFactor: Decimal;
    //         AGILES_LT_TEXT003: Label 'Einheit muss Kolloeinheit sein!';
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Kontrolle ob Artikel-Einheit vorhanden, ansonsten Neuanlage
    //         // ------------------------------------------------------------------------------------

    //         IF (vco_ItemNo = '') OR
    //            (vco_UnitOfMeasure = '') THEN
    //           EXIT;

    //         lrc_Item.GET(vco_ItemNo);
    //         lrc_Item.TESTFIELD("Base Unit of Measure");

    //         IF (lrc_Item."Item Typ" = lrc_Item."Item Typ"::"Empties Item") OR
    //            (lrc_Item."Item Typ" = lrc_Item."Item Typ"::"Transport Item") THEN
    //           EXIT;

    //         // Kontrolle ob Einheit der Basiseinheit entspricht
    //         IF vco_UnitOfMeasure = lrc_Item."Base Unit of Measure" THEN
    //           EXIT;

    //         lrc_UnitofMeasure.GET(vco_UnitOfMeasure);
    //         lrc_UnitofMeasure.TESTFIELD("Base Unit of Measure (BU)");
    //         IF lrc_UnitofMeasure."Is Collo Unit of Measure" = FALSE THEN
    //           // Einheit muss Kolloeinheit sein!
    //           ERROR(AGILES_LT_TEXT003);

    //         IF lrc_Item."Base Unit of Measure" <> lrc_UnitofMeasure."Base Unit of Measure (BU)" THEN
    //           // Die Basiseinheit Artikel ist abweichend von der Basiseinheit der Einheit!
    //           ERROR(AGILES_LT_TEXT001);

    //         // Bestehende Einheiten ausser der Basiseinheit löschen
    //         lrc_ItemUnitofMeasure.Reset();
    //         lrc_ItemUnitofMeasure.SETRANGE("Item No.",vco_ItemNo);
    //         lrc_ItemUnitofMeasure.SETFILTER(Code,'<>%1',lrc_Item."Base Unit of Measure");
    //         lrc_ItemUnitofMeasure.DELETEALL();

    //         // --------------------------------------------------------------------------------------------
    //         // Kolloeinheit anlegen
    //         // --------------------------------------------------------------------------------------------
    //         lrc_ItemUnitofMeasure.Reset();
    //         lrc_ItemUnitofMeasure.INIT();
    //         lrc_ItemUnitofMeasure.VALIDATE("Item No.", vco_ItemNo);
    //         lrc_ItemUnitofMeasure.VALIDATE( Code, vco_UnitOfMeasure);
    //         lrc_ItemUnitofMeasure."Kind of Unit of Measure" := lrc_ItemUnitofMeasure."Kind of Unit of Measure"::"Collo Unit";
    //         lrc_ItemUnitofMeasure.insert();

    //         ldc_BaseFactor := lrc_UnitofMeasure."Qty. (BU) per Unit of Measure";

    //         // --------------------------------------------------------------------------------------------
    //         // Gewicht Basiseinheit berechnen
    //         // --------------------------------------------------------------------------------------------
    //         lrc_BaseItemUnitofMeasure.Reset();
    //         lrc_BaseItemUnitofMeasure.SETRANGE("Item No.",vco_ItemNo);
    //         lrc_BaseItemUnitofMeasure.SETRANGE("Kind of Unit of Measure",lrc_BaseItemUnitofMeasure."Kind of Unit of Measure"::"Base Unit");
    //         lrc_BaseItemUnitofMeasure.FIND('-');
    //         lrc_BaseItemUnitofMeasure.VALIDATE("Gross Weight",
    //            lrc_UnitofMeasure."Gross Weight" / lrc_ItemUnitofMeasure."Qty. per Unit of Measure");
    //         lrc_BaseItemUnitofMeasure.VALIDATE("Net Weight",
    //            lrc_UnitofMeasure."Net Weight" / lrc_ItemUnitofMeasure."Qty. per Unit of Measure");
    //         lrc_BaseItemUnitofMeasure.Modify();

    //         // --------------------------------------------------------------------------------------------
    //         // Verpackungseinheit anlegen falls vorhanden und nicht der Basiseinheit entspricht
    //         // --------------------------------------------------------------------------------------------
    //         IF (lrc_UnitofMeasure."Packing Unit of Measure (PU)" <> '') AND
    //            (lrc_UnitofMeasure."Packing Unit of Measure (PU)" <> lrc_UnitofMeasure."Base Unit of Measure (BU)") THEN BEGIN

    //           lrc_UnitofMeasure.TESTFIELD("Qty. (BU) per Packing Unit");

    //           lrc_ItemUnitofMeasure.Reset();
    //           lrc_ItemUnitofMeasure.INIT();
    //           lrc_ItemUnitofMeasure.VALIDATE("Item No.", vco_ItemNo);
    //           lrc_ItemUnitofMeasure.VALIDATE( Code, lrc_UnitofMeasure."Packing Unit of Measure (PU)");
    //           lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := lrc_UnitofMeasure."Qty. (BU) per Packing Unit";
    //           lrc_ItemUnitofMeasure."Kind of Unit of Measure" := lrc_ItemUnitofMeasure."Kind of Unit of Measure"::"Packing Unit";
    //           lrc_ItemUnitofMeasure.VALIDATE("Gross Weight", lrc_UnitofMeasure."Gross Weight" / ldc_BaseFactor *
    //                                                    lrc_ItemUnitofMeasure."Qty. per Unit of Measure");
    //           lrc_ItemUnitofMeasure.VALIDATE("Net Weight", lrc_UnitofMeasure."Net Weight" / ldc_BaseFactor *
    //                                                    lrc_ItemUnitofMeasure."Qty. per Unit of Measure");
    //           lrc_ItemUnitofMeasure.insert();

    //           // --------------------------------------------------------------------------------------------
    //           // Inhaltseinheit der Verpackung anlegen
    //           // --------------------------------------------------------------------------------------------
    //           IF lrc_UnitofMeasure."Content Unit of Measure (CP)" <> '' THEN BEGIN

    //             lrc_UnitofMeasure.TESTFIELD("Qty. (PU) per Unit of Measure");
    //             lrc_UnitofMeasure.TESTFIELD("Qty. (CP) per Packing Unit");

    //             lrc_ItemUnitofMeasure.Reset();
    //             lrc_ItemUnitofMeasure.INIT();
    //             lrc_ItemUnitofMeasure.VALIDATE("Item No.", vco_ItemNo);
    //             lrc_ItemUnitofMeasure.VALIDATE( Code, lrc_UnitofMeasure."Content Unit of Measure (CP)");
    //             lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := lrc_UnitofMeasure."Qty. (BU) per Unit of Measure" /
    //                                                                 (lrc_UnitofMeasure."Qty. (CP) per Packing Unit" *
    //                                                                  lrc_UnitofMeasure."Qty. (PU) per Unit of Measure");
    //             lrc_ItemUnitofMeasure."Kind of Unit of Measure" := lrc_ItemUnitofMeasure."Kind of Unit of Measure"::"Content Unit";
    //             lrc_ItemUnitofMeasure.VALIDATE("Gross Weight", lrc_UnitofMeasure."Gross Weight" / ldc_BaseFactor *
    //                                                     lrc_ItemUnitofMeasure."Qty. per Unit of Measure");
    //             lrc_ItemUnitofMeasure.VALIDATE("Net Weight", lrc_UnitofMeasure."Net Weight" / ldc_BaseFactor *
    //                                                   lrc_ItemUnitofMeasure."Qty. per Unit of Measure");
    //             lrc_ItemUnitofMeasure.insert();

    //           END;

    //         END;
    //     end;

    //     procedure NewColloUnitCombinations(vco_ItemNo: Code[20];vco_UnitOfMeasure: Code[10])
    //     var
    //         lrc_ItemUnitofMeasure: Record "5404";
    //         lrc_UnitOfMeasureConnection: Record "5110331";
    //         lrc_UnitofMeasure: Record "204";
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Funktion zur Anlage der zusätzlich verbundenen Einheiten
    //         // ------------------------------------------------------------------------------------------------

    //         // F40 002 00000000.s
    //         lrc_UnitOfMeasureConnection.Reset();
    //         lrc_UnitOfMeasureConnection.SETRANGE("Unit Of Measure Code", vco_UnitOfMeasure);
    //         IF lrc_UnitOfMeasureConnection.FIND('-') THEN BEGIN
    //            REPEAT
    //               lrc_UnitofMeasure.GET(lrc_UnitOfMeasureConnection."Unit Of Measure Code Attached");
    //               lrc_UnitofMeasure.TESTFIELD("Base Unit of Measure (BU)");
    //               lrc_UnitofMeasure.TESTFIELD("Is Collo Unit of Measure");

    //               lrc_ItemUnitofMeasure.Reset();
    //               lrc_ItemUnitofMeasure.SETRANGE("Item No.", vco_ItemNo);
    //               lrc_ItemUnitofMeasure.SETRANGE( Code, lrc_UnitOfMeasureConnection."Unit Of Measure Code Attached");
    //               IF NOT lrc_ItemUnitofMeasure.FIND('-') THEN BEGIN
    //                  lrc_ItemUnitofMeasure.Reset();
    //                  lrc_ItemUnitofMeasure.INIT();
    //                  lrc_ItemUnitofMeasure.VALIDATE("Item No.", vco_ItemNo);
    //                  lrc_ItemUnitofMeasure.VALIDATE( Code, lrc_UnitofMeasure.Code);
    //                  lrc_ItemUnitofMeasure."Kind of Unit of Measure" := lrc_ItemUnitofMeasure."Kind of Unit of Measure"::"Collo Unit";
    //                  lrc_ItemUnitofMeasure.insert();
    //                END;

    //            UNTIL lrc_UnitOfMeasureConnection.NEXT() = 0;
    //         END;
    //         // F40 002 00000000.e
    //     end;

    procedure UnitOfMeasureValidate(vco_UnitOfMeasureCode: Code[10]; vco_ProductGroupCode: Code[20])
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";

        //lrc_ProductGroupUnitOfMeasure: Record "POI Product Group - Unit";
        LT_TEXT001Txt: Label 'Validierung Einheiten nicht möglich. Bitte zuerst Produktgruppe eingeben!';
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zur Validierung der Einheit
        // ---------------------------------------------------------------------------------------------

        IF vco_UnitOfMeasureCode = '' THEN
            EXIT;

        lrc_FruitVisionSetup.GET();

        CASE lrc_FruitVisionSetup."Item - Validate Unit" OF
            lrc_FruitVisionSetup."Item - Validate Unit"::"Item Unit of Measure":
                lrc_UnitOfMeasure.GET(vco_UnitOfMeasureCode);
            lrc_FruitVisionSetup."Item - Validate Unit"::"Product Group":
                //BEGIN
                IF vco_ProductGroupCode = '' THEN
                    ERROR(LT_TEXT001Txt);

        //lrc_ProductGroupUnitOfMeasure.RESET();
        //lrc_ProductGroupUnitOfMeasure.SETRANGE("Product Group Code",vco_ProductGroupCode);
        //lrc_ProductGroupUnitOfMeasure.SETRANGE("Unit of Measure Code",vco_UnitOfMeasureCode);
        //lrc_ProductGroupUnitOfMeasure.FIND('-');
        //END;

        END;
    end;

    procedure UnitOfMeasureLookUp(vco_ProductGroupCode: Code[20]; vco_ItemNo: Code[20]): Code[10]
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_ProductGroupUnit: Record "POI Product Group - Unit";
        lfm_UnitOfMeasure: Page "Units of Measure";
        //lfm_ProductGroupUnit: Form "5110317";
        AGILES_LT_TEXT001Txt: Label 'Lookup Einheiten nicht möglich. Bitte zuerst Produktgruppe eingeben!';

    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zum LookUp Unit of Measure
        // ---------------------------------------------------------------------------------------------

        lrc_FruitVisionSetup.GET();

        CASE lrc_FruitVisionSetup."Item - Validate Unit" OF

            // Artikeleinheit
            lrc_FruitVisionSetup."Item - Validate Unit"::"Item Unit of Measure":
                BEGIN

                    lrc_ItemUnitofMeasure.FILTERGROUP(2);
                    lrc_ItemUnitofMeasure.SETRANGE("Item No.", vco_ItemNo);
                    lrc_ItemUnitofMeasure.FILTERGROUP(0);
                END;

            // Einheit
            lrc_FruitVisionSetup."Item - Validate Unit"::"Unit of Measure":
                BEGIN
                    lfm_UnitOfMeasure.LOOKUPMODE := TRUE;
                    lfm_UnitOfMeasure.SETTABLEVIEW(lrc_UnitOfMeasure);
                    IF lfm_UnitOfMeasure.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                        lrc_UnitOfMeasure.RESET();
                        lfm_UnitOfMeasure.GETRECORD(lrc_UnitOfMeasure);
                        EXIT(lrc_UnitOfMeasure.Code);
                    END ELSE
                        EXIT('');
                END;

            // Produktgruppe - Einheit
            lrc_FruitVisionSetup."Item - Validate Unit"::"Product Group":
                BEGIN
                    IF vco_ProductGroupCode = '' THEN
                        ERROR(AGILES_LT_TEXT001Txt);
                    lrc_ProductGroupUnit.RESET();
                    lrc_ProductGroupUnit.FILTERGROUP(2);
                    lrc_ProductGroupUnit.SETRANGE("Product Group Code", vco_ProductGroupCode);
                    lrc_ProductGroupUnit.FILTERGROUP(0);

                    // lfm_ProductGroupUnit.LOOKUPMODE := TRUE; //TODO: Page
                    // lfm_ProductGroupUnit.SETTABLEVIEW(lrc_ProductGroupUnit);
                    // IF lfm_ProductGroupUnit.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    //     lrc_ProductGroupUnit.Reset();
                    //     lfm_ProductGroupUnit.GETRECORD(lrc_ProductGroupUnit);
                    //     EXIT(lrc_ProductGroupUnit."Unit of Measure Code");
                    // END ELSE
                    //     EXIT('');
                END;
        END;

        EXIT('');
    end;

    //     procedure PurchUnitOfMeasureValidate(vrc_PurchLine: Record "39"): Code[10]
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_UnitOfMeasure: Record "204";
    //         lrc_ItemUnitofMeasure: Record "5404";
    //         lrc_ProductGroupUnitOfMeasure: Record "5110317";
    //         AGILES_LT_TEXT001: Label 'Validierung Einheiten nicht möglich. Bitte zuerst Produktgruppe eingeben!';
    //         AGILES_LT_TEXT002: Label 'Validierung Einheiten nicht möglich. Bitte zuerst Artikelnr. eingeben!';
    //         lrc_Item: Record Item;
    //         lfm_UnitsofMeasure: Form "209";
    //         lco_UnitOfMeasure: Code[10];
    //         AGILES_LT_TEXT003: Label 'Einheit nicht vorhanden!';
    //         AGILES_LT_TEXT004: Label 'Es sind nur Kolloeinheiten zugelassen!';
    //         AGILES_LT_TEXT005: Label 'Die Basiseinheit Artikel ist abweichend!';
    //         AGILES_LT_TEXT006: Label 'Einheit ist für die Produktgruppe nicht zugelassen!';
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zur Validierung der Einheit in der Einkaufszeile
    //         // ---------------------------------------------------------------------------------------------

    //         IF vrc_PurchLine."Unit of Measure Code" = '' THEN
    //           EXIT(vrc_PurchLine."Unit of Measure Code");

    //         IF vrc_PurchLine."No." = '' THEN
    //           // Validierung Einheiten nicht möglich. Bitte zuerst Artikelnr. eingeben!
    //           ERROR(AGILES_LT_TEXT002);

    //         CASE vrc_PurchLine.Type OF

    //         vrc_PurchLine.Type::" ":
    //           BEGIN
    //           END;

    //         vrc_PurchLine.Type::"G/L Account":
    //           BEGIN
    //           END;

    //         vrc_PurchLine.Type::Item:
    //         BEGIN

    //           lrc_FruitVisionSetup.GET();
    //           CASE lrc_FruitVisionSetup."Purch. Validate Unit" OF

    //             // Validierung gegen Artikeleinheit
    //             lrc_FruitVisionSetup."Purch. Validate Unit"::"Item Unit of Measure":
    //             BEGIN
    //               lrc_ItemUnitofMeasure.GET(vrc_PurchLine."No.",vrc_PurchLine."Unit of Measure Code");
    //               EXIT(lrc_ItemUnitofMeasure.Code);
    //             END;

    //             // Validierung gegen Einheitentabelle
    //             lrc_FruitVisionSetup."Purch. Validate Unit"::"Unit of Measure":
    //             BEGIN
    //               IF lrc_UnitOfMeasure.GET(vrc_PurchLine."Unit of Measure Code") THEN BEGIN
    //                 IF lrc_UnitOfMeasure."Is Collo Unit of Measure" = FALSE THEN
    //                   // Es sind nur Kolloeinheiten zugelassen!
    //                   ERROR(AGILES_LT_TEXT004);
    //               END ELSE BEGIN

    //                 // Kontrolle ob es sich um einen Teilstring in der Eingabe handelte --> Auswahl anbieten
    //                 lrc_UnitOfMeasure.Reset();
    //                 lrc_UnitOfMeasure.FILTERGROUP(2);
    //                 lrc_UnitOfMeasure.SETFILTER(Code,'%1',(vrc_PurchLine."Unit of Measure Code" + '*'));
    //                 lrc_UnitOfMeasure.SETRANGE("Is Collo Unit of Measure",TRUE);
    //                 lrc_UnitOfMeasure.FILTERGROUP(0);
    //                 IF lrc_UnitOfMeasure.FIND('-') THEN BEGIN
    //                   lfm_UnitsofMeasure.SETTABLEVIEW(lrc_UnitOfMeasure);
    //                   lfm_UnitsofMeasure.LOOKUPMODE := TRUE;
    //                   IF lfm_UnitsofMeasure.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //                     lrc_UnitOfMeasure.Reset();
    //                     lfm_UnitsofMeasure.GETRECORD(lrc_UnitOfMeasure);
    //                   END ELSE BEGIN
    //                     EXIT('');
    //                   END;
    //                 END ELSE
    //                   // Artikeleinheit nicht vorhanden!
    //                   ERROR(AGILES_LT_TEXT003);

    //               END;

    //               // Kontrolle ob als Artikeleinheit angelegt
    //               IF NOT lrc_ItemUnitofMeasure.GET(vrc_PurchLine."No.",lrc_UnitOfMeasure.Code) THEN BEGIN
    //                 lrc_Item.GET(vrc_PurchLine."No.");
    //                 IF lrc_Item."Base Unit of Measure" <> lrc_UnitOfMeasure."Base Unit of Measure (BU)" THEN
    //                   // Die Basiseinheit Artikel ist abweichend!
    //                   ERROR(AGILES_LT_TEXT005);
    //                 // Neuanlage Artikeleinheit
    //                 lrc_ItemUnitofMeasure.Reset();
    //                 lrc_ItemUnitofMeasure.INIT();
    //                 lrc_ItemUnitofMeasure.VALIDATE("Item No.", vrc_PurchLine."No.");
    //                 lrc_ItemUnitofMeasure.VALIDATE( Code, lrc_UnitOfMeasure.Code);
    //                 lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := lrc_UnitOfMeasure."Qty. (BU) per Unit of Measure";
    //                 lrc_ItemUnitofMeasure."Kind of Unit of Measure" := lrc_ItemUnitofMeasure."Kind of Unit of Measure"::"Collo Unit";
    //                 lrc_ItemUnitofMeasure.insert();
    //               END;

    //               EXIT(lrc_UnitOfMeasure.Code);

    //             END;

    //             // Validierung gegen Produktgruppe - Einheiten
    //             lrc_FruitVisionSetup."Purch. Validate Unit"::"Product Group":
    //             BEGIN
    //               IF vrc_PurchLine."Product Group Code" = '' THEN
    //                 ERROR(AGILES_LT_TEXT001);

    //               lrc_ProductGroupUnitOfMeasure.Reset();
    //               lrc_ProductGroupUnitOfMeasure.SETRANGE("Product Group Code",vrc_PurchLine."Product Group Code");
    //               lrc_ProductGroupUnitOfMeasure.SETRANGE("Unit of Measure Code",vrc_PurchLine."Unit of Measure Code");
    //               IF NOT lrc_ProductGroupUnitOfMeasure.FIND('-') THEN
    //                 // Einheit ist für die Produktgruppe nicht zugelassen!
    //                 ERROR(AGILES_LT_TEXT006);

    //               lrc_UnitOfMeasure.GET(lrc_ProductGroupUnitOfMeasure."Unit of Measure Code");

    //               // Kontrolle ob als Artikeleinheit angelegt
    //               IF NOT lrc_ItemUnitofMeasure.GET(vrc_PurchLine."No.",lrc_ProductGroupUnitOfMeasure."Unit of Measure Code") THEN BEGIN
    //                 lrc_Item.GET(vrc_PurchLine."No.");
    //                 IF lrc_Item."Base Unit of Measure" <> lrc_UnitOfMeasure."Base Unit of Measure (BU)" THEN
    //                   // Die Basiseinheit Artikel ist abweichend!
    //                   ERROR(AGILES_LT_TEXT005);
    //                 // Neuanlage Artikeleinheit
    //                 lrc_ItemUnitofMeasure.Reset();
    //                 lrc_ItemUnitofMeasure.INIT();
    //                 lrc_ItemUnitofMeasure.VALIDATE("Item No.", vrc_PurchLine."No.");
    //                 lrc_ItemUnitofMeasure.VALIDATE( Code, lrc_UnitOfMeasure.Code);
    //                 lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := lrc_UnitOfMeasure."Qty. (BU) per Unit of Measure";
    //                 lrc_ItemUnitofMeasure."Kind of Unit of Measure" := lrc_ItemUnitofMeasure."Kind of Unit of Measure"::"Collo Unit";
    //                 lrc_ItemUnitofMeasure.insert();
    //               END;

    //               EXIT(lrc_UnitOfMeasure.Code);

    //             END;
    //           END;
    //         END;

    //         vrc_PurchLine.Type::"Fixed Asset":
    //           BEGIN
    //           END;

    //         vrc_PurchLine.Type::"Charge (Item)":
    //           BEGIN
    //           END;

    //         END;
    //     end;

    procedure PurchUnitOfMeasureLookUp(vco_ProductGroupCode: Code[10]; vco_ItemNo: Code[20]): Code[10]
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_ProductGroupUnit: Record "POI Product Group - Unit";
        lfm_UnitOfMeasure: Page "Units of Measure";
        lfm_ItemUnitsofMeasure: Page "Item Units of Measure";
        //lfm_ProductGroupUnit: Form "5110317"; //TODO: Productgroup unit page
        AGILES_LT_TEXT001Txt: Label 'Lookup Einheiten nicht möglich. Bitte zuerst Produktgruppe eingeben!';

    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zum LookUp Unit of Measure
        // ---------------------------------------------------------------------------------------------

        lrc_FruitVisionSetup.GET();
        CASE lrc_FruitVisionSetup."Purch. Validate Unit" OF

            // Artikeleinheit
            lrc_FruitVisionSetup."Purch. Validate Unit"::"Item Unit of Measure":
                BEGIN
                    lrc_ItemUnitofMeasure.FILTERGROUP(2);
                    lrc_ItemUnitofMeasure.SETRANGE("Item No.", vco_ItemNo);
                    lrc_ItemUnitofMeasure.FILTERGROUP(0);

                    lfm_ItemUnitsofMeasure.SETTABLEVIEW(lrc_ItemUnitofMeasure);
                    lfm_ItemUnitsofMeasure.LOOKUPMODE := TRUE;
                    IF lfm_ItemUnitsofMeasure.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                        lrc_ItemUnitofMeasure.RESET();
                        lfm_ItemUnitsofMeasure.GETRECORD(lrc_ItemUnitofMeasure);
                        EXIT(lrc_ItemUnitofMeasure.Code);
                    END ELSE
                        EXIT('');
                END;

            // Einheit
            lrc_FruitVisionSetup."Purch. Validate Unit"::"Unit of Measure":
                BEGIN
                    lfm_UnitOfMeasure.LOOKUPMODE := TRUE;
                    lfm_UnitOfMeasure.SETTABLEVIEW(lrc_UnitOfMeasure);
                    IF lfm_UnitOfMeasure.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                        lrc_UnitOfMeasure.RESET();
                        lfm_UnitOfMeasure.GETRECORD(lrc_UnitOfMeasure);
                        EXIT(lrc_UnitOfMeasure.Code);
                    END ELSE
                        EXIT('');
                END;

            // Produktgruppe - Einheit
            lrc_FruitVisionSetup."Purch. Validate Unit"::"Product Group":
                BEGIN
                    IF vco_ProductGroupCode = '' THEN
                        // Lookup Einheiten nicht möglich. Bitte zuerst Produktgruppe eingeben!
                        ERROR(AGILES_LT_TEXT001Txt);
                    ;

                    lrc_ProductGroupUnit.RESET();
                    lrc_ProductGroupUnit.FILTERGROUP(2);
                    lrc_ProductGroupUnit.SETRANGE("Product Group Code", vco_ProductGroupCode);
                    lrc_ProductGroupUnit.FILTERGROUP(0);

                    // lfm_ProductGroupUnit.LOOKUPMODE := TRUE; //TODO: product group page
                    // lfm_ProductGroupUnit.SETTABLEVIEW(lrc_ProductGroupUnit);
                    // IF lfm_ProductGroupUnit.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    //   lrc_ProductGroupUnit.Reset();
                    //   lfm_ProductGroupUnit.GETRECORD(lrc_ProductGroupUnit);
                    //   EXIT(lrc_ProductGroupUnit."Unit of Measure Code");
                    // END ELSE
                    //   EXIT('');
                END;

        END;

        EXIT('');
    end;

    procedure PackOutpUnitOfMeasureValidate(vrc_PackOrderOutputItems: Record "POI Pack. Order Output Items"): Code[10]
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lfm_UnitsofMeasure: Page "Units of Measure";
        //lco_UnitOfMeasure: Code[10];
        AGILES_LT_TEXT003Txt: Label 'Es sind nur Kolloeinheiten zugelassen!';
        AGILES_LT_TEXT004Txt: Label 'Die Basiseinheit Artikel ist abweichend!';
        AGILES_LT_TEXT005Txt: Label 'Artikeleinheit nicht vorhanden!';
        AGILES_LT_TEXT001Txt: Label 'Validierung Einheiten nicht möglich. Bitte zuerst Produktgruppe eingeben!';
        AGILES_LT_TEXT002Txt: Label 'Validierung Einheiten nicht möglich. Bitte zuerst Artikelnr. eingeben!';
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zur Validierung der Einheit in der Packerei Output Zeile
        // ---------------------------------------------------------------------------------------------

        IF vrc_PackOrderOutputItems."Unit of Measure Code" = '' THEN
            EXIT(vrc_PackOrderOutputItems."Unit of Measure Code");

        IF vrc_PackOrderOutputItems."Item No." = '' THEN
            // Validierung Einheiten nicht möglich. Bitte zuerst Artikelnr. eingeben!
            ERROR(AGILES_LT_TEXT002Txt);
        BEGIN

            lrc_FruitVisionSetup.GET();

            CASE lrc_FruitVisionSetup."Purch. Validate Unit" OF

                lrc_FruitVisionSetup."Purch. Validate Unit"::"Item Unit of Measure":
                    BEGIN
                        lrc_ItemUnitofMeasure.GET(vrc_PackOrderOutputItems."Item No.", vrc_PackOrderOutputItems."Unit of Measure Code");
                        EXIT(lrc_ItemUnitofMeasure.Code);
                    END;

                lrc_FruitVisionSetup."Purch. Validate Unit"::"Unit of Measure":
                    BEGIN
                        IF lrc_UnitOfMeasure.GET(vrc_PackOrderOutputItems."Unit of Measure Code") THEN BEGIN
                            IF lrc_UnitOfMeasure."POI Is Collo Unit of Measure" = FALSE THEN
                                // Es sind nur Kolloeinheiten zugelassen!
                                ERROR(AGILES_LT_TEXT003Txt);
                        END ELSE BEGIN

                            lrc_UnitOfMeasure.RESET();
                            lrc_UnitOfMeasure.FILTERGROUP(2);
                            lrc_UnitOfMeasure.SETFILTER(Code, '%1', (vrc_PackOrderOutputItems."Unit of Measure Code" + '*'));
                            lrc_UnitOfMeasure.SETRANGE("POI Is Collo Unit of Measure", TRUE);
                            lrc_UnitOfMeasure.FILTERGROUP(0);
                            IF lrc_UnitOfMeasure.FIND('-') THEN BEGIN

                                lfm_UnitsofMeasure.SETTABLEVIEW(lrc_UnitOfMeasure);
                                lfm_UnitsofMeasure.LOOKUPMODE := TRUE;
                                IF lfm_UnitsofMeasure.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                                    lrc_UnitOfMeasure.RESET();
                                    lfm_UnitsofMeasure.GETRECORD(lrc_UnitOfMeasure);
                                END ELSE
                                    EXIT('');
                            END ELSE
                                // Artikeleinheit nicht vorhanden!
                                ERROR(AGILES_LT_TEXT005Txt);
                        END;

                        // Kontrolle ob als Artikeleinheit angelegt
                        IF NOT lrc_ItemUnitofMeasure.GET(vrc_PackOrderOutputItems."Item No.", lrc_UnitOfMeasure.Code) THEN BEGIN
                            lrc_Item.GET(vrc_PackOrderOutputItems."Item No.");
                            IF lrc_Item."Base Unit of Measure" <> lrc_UnitOfMeasure."POI Base Unit of Measure (BU)" THEN
                                //   // Die Basiseinheit Artikel ist abweichend!
                                ERROR(AGILES_LT_TEXT004Txt);
                            // Neuanlage Artikeleinheit
                            lrc_ItemUnitofMeasure.RESET();
                            lrc_ItemUnitofMeasure.INIT();
                            lrc_ItemUnitofMeasure.VALIDATE("Item No.", vrc_PackOrderOutputItems."Item No.");
                            lrc_ItemUnitofMeasure.VALIDATE(Code, lrc_UnitOfMeasure.Code);
                            lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := lrc_UnitOfMeasure."POI Qty. (BU) per Unit of Meas";
                            lrc_ItemUnitofMeasure."POI Kind of Unit of Measure" := lrc_ItemUnitofMeasure."POI Kind of Unit of Measure"::"Collo Unit";
                            lrc_ItemUnitofMeasure.INSERT();
                        END;

                        EXIT(lrc_UnitOfMeasure.Code);

                    END;

                lrc_FruitVisionSetup."Purch. Validate Unit"::"Product Group":
                    BEGIN
                        IF vrc_PackOrderOutputItems."Product Group Code" = '' THEN
                            ERROR(AGILES_LT_TEXT001Txt);

                        lrc_ProductGroupUnitOfMeasure.RESET();
                        lrc_ProductGroupUnitOfMeasure.SETRANGE("Product Group Code", vrc_PackOrderOutputItems."Product Group Code");
                        lrc_ProductGroupUnitOfMeasure.SETRANGE("Unit of Measure Code", vrc_PackOrderOutputItems."Unit of Measure Code");
                        lrc_ProductGroupUnitOfMeasure.FIND('-');

                        lrc_UnitOfMeasure.GET(lrc_ProductGroupUnitOfMeasure."Unit of Measure Code");

                        // Kontrolle ob als Artikeleinheit angelegt
                        IF NOT lrc_ItemUnitofMeasure.GET(vrc_PackOrderOutputItems."Item No.",
                        lrc_ProductGroupUnitOfMeasure."Unit of Measure Code") THEN BEGIN
                            lrc_Item.GET(vrc_PackOrderOutputItems."Item No.");
                            IF lrc_Item."Base Unit of Measure" <> lrc_UnitOfMeasure."POI Base Unit of Measure (BU)" THEN
                                // Die Basiseinheit Artikel ist abweichend!
                                ERROR(AGILES_LT_TEXT004Txt);
                            // Neuanlage Artikeleinheit
                            lrc_ItemUnitofMeasure.RESET();
                            lrc_ItemUnitofMeasure.INIT();
                            lrc_ItemUnitofMeasure.VALIDATE("Item No.", vrc_PackOrderOutputItems."Item No.");
                            lrc_ItemUnitofMeasure.VALIDATE(Code, lrc_UnitOfMeasure.Code);
                            lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := lrc_UnitOfMeasure."POI Qty. (BU) per Unit of Meas";
                            lrc_ItemUnitofMeasure."POI Kind of Unit of Measure" := lrc_ItemUnitofMeasure."POI Kind of Unit of Measure"::"Collo Unit";
                            lrc_ItemUnitofMeasure.INSERT();
                        END;

                        EXIT(lrc_UnitOfMeasure.Code);
                    END;
            END;
        END;
    end;

    procedure PackOutpUnitOfMeasureLookUp(vco_ProductGroupCode: Code[10]; vco_ItemNo: Code[20]): Code[10]
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zum LookUp Unit of Measure
        // ---------------------------------------------------------------------------------------------

        EXIT(PurchUnitOfMeasureLookUp(vco_ProductGroupCode, vco_ItemNo));
    end;

    //     procedure RezOutpUnitOfMeasureValidate(vrc_RecipeOutputItems: Record "5110708"): Code[10]
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_UnitOfMeasure: Record "204";
    //         lrc_ItemUnitofMeasure: Record "5404";
    //         lrc_ProductGroupUnitOfMeasure: Record "5110317";
    //         AGILES_LT_TEXT001: Label 'Validierung Einheiten nicht möglich. Bitte zuerst Produktgruppe eingeben!';
    //         AGILES_LT_TEXT002: Label 'Validierung Einheiten nicht möglich. Bitte zuerst Artikelnr. eingeben!';
    //         lrc_Item: Record Item;
    //         lfm_UnitsofMeasure: Form "209";
    //         lco_UnitOfMeasure: Code[10];
    //         AGILES_LT_TEXT003: Label 'Es sind nur Kolloeinheiten zugelassen!';
    //         AGILES_LT_TEXT004: Label 'Artikeleinheit nicht vorhanden!';
    //         AGILES_LT_TEXT005: Label 'Die Basiseinheit Artikel ist abweichend!';
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zur Validierung der Einheit in der Rezeptur Output Zeile
    //         // ---------------------------------------------------------------------------------------------

    //         IF vrc_RecipeOutputItems."Unit of Measure Code" = '' THEN
    //           EXIT(vrc_RecipeOutputItems."Unit of Measure Code");

    //         IF vrc_RecipeOutputItems."Item No." = '' THEN
    //           // Validierung Einheiten nicht möglich. Bitte zuerst Artikelnr. eingeben!
    //           ERROR(AGILES_LT_TEXT002);
    //         BEGIN

    //           lrc_FruitVisionSetup.GET();

    //           CASE lrc_FruitVisionSetup."Purch. Validate Unit" OF

    //             lrc_FruitVisionSetup."Purch. Validate Unit"::"Item Unit of Measure":
    //             BEGIN
    //               lrc_ItemUnitofMeasure.GET(vrc_RecipeOutputItems."Item No.",vrc_RecipeOutputItems."Unit of Measure Code");
    //               EXIT(lrc_ItemUnitofMeasure.Code);
    //             END;

    //             lrc_FruitVisionSetup."Purch. Validate Unit"::"Unit of Measure":
    //             BEGIN
    //               IF lrc_UnitOfMeasure.GET(vrc_RecipeOutputItems."Unit of Measure Code") THEN BEGIN
    //                 IF lrc_UnitOfMeasure."Is Collo Unit of Measure" = FALSE THEN
    //                   // Es sind nur Kolloeinheiten zugelassen!
    //                   ERROR(AGILES_LT_TEXT003);
    //               END ELSE BEGIN

    //                 lrc_UnitOfMeasure.Reset();
    //                 lrc_UnitOfMeasure.FILTERGROUP(2);
    //                 lrc_UnitOfMeasure.SETFILTER(Code,'%1',(vrc_RecipeOutputItems."Unit of Measure Code" + '*'));
    //                 lrc_UnitOfMeasure.SETRANGE("Is Collo Unit of Measure",TRUE);
    //                 lrc_UnitOfMeasure.FILTERGROUP(0);
    //                 IF lrc_UnitOfMeasure.FIND('-') THEN BEGIN

    //                   lfm_UnitsofMeasure.SETTABLEVIEW(lrc_UnitOfMeasure);
    //                   lfm_UnitsofMeasure.LOOKUPMODE := TRUE;
    //                   IF lfm_UnitsofMeasure.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //                     lrc_UnitOfMeasure.Reset();
    //                     lfm_UnitsofMeasure.GETRECORD(lrc_UnitOfMeasure);
    //                   END ELSE BEGIN
    //                     EXIT('');
    //                   END;
    //                 END ELSE
    //                   // Artikeleinheit nicht vorhanden!
    //                   ERROR(AGILES_LT_TEXT004);
    //               END;

    //               // Kontrolle ob als Artikeleinheit angelegt
    //               IF NOT lrc_ItemUnitofMeasure.GET(vrc_RecipeOutputItems."Item No.",lrc_UnitOfMeasure.Code) THEN BEGIN
    //                 lrc_Item.GET(vrc_RecipeOutputItems."Item No.");
    //                 IF lrc_Item."Base Unit of Measure" <> lrc_UnitOfMeasure."Base Unit of Measure (BU)" THEN
    //                   // Die Basiseinheit Artikel ist abweichend!
    //                   ERROR(AGILES_LT_TEXT005);
    //                 // Neuanlage Artikeleinheit
    //                 lrc_ItemUnitofMeasure.Reset();
    //                 lrc_ItemUnitofMeasure.INIT();
    //                 lrc_ItemUnitofMeasure.VALIDATE("Item No.", vrc_RecipeOutputItems."Item No.");
    //                 lrc_ItemUnitofMeasure.VALIDATE( Code, lrc_UnitOfMeasure.Code);
    //                 lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := lrc_UnitOfMeasure."Qty. (BU) per Unit of Measure";
    //                 lrc_ItemUnitofMeasure."Kind of Unit of Measure" := lrc_ItemUnitofMeasure."Kind of Unit of Measure"::"Collo Unit";
    //                 lrc_ItemUnitofMeasure.insert();
    //               END;

    //               EXIT(lrc_UnitOfMeasure.Code);

    //             END;

    //             lrc_FruitVisionSetup."Purch. Validate Unit"::"Product Group":
    //             BEGIN
    //               IF vrc_RecipeOutputItems."Product Group Code" = '' THEN
    //                 ERROR(AGILES_LT_TEXT001);
    //               lrc_ProductGroupUnitOfMeasure.Reset();
    //               lrc_ProductGroupUnitOfMeasure.SETRANGE("Product Group Code",vrc_RecipeOutputItems."Product Group Code");
    //               lrc_ProductGroupUnitOfMeasure.SETRANGE("Unit of Measure Code",vrc_RecipeOutputItems."Unit of Measure Code");
    //               lrc_ProductGroupUnitOfMeasure.FIND('-');

    //               lrc_UnitOfMeasure.GET(lrc_ProductGroupUnitOfMeasure."Unit of Measure Code");

    //               // Kontrolle ob als Artikeleinheit angelegt
    //               IF NOT lrc_ItemUnitofMeasure.GET(vrc_RecipeOutputItems."Item No.",
    //                   lrc_ProductGroupUnitOfMeasure."Unit of Measure Code") THEN BEGIN
    //                 lrc_Item.GET(vrc_RecipeOutputItems."Item No.");
    //                 IF lrc_Item."Base Unit of Measure" <> lrc_UnitOfMeasure."Base Unit of Measure (BU)" THEN
    //                   // Die Basiseinheit Artikel ist abweichend!
    //                   ERROR(AGILES_LT_TEXT005);
    //                 // Neuanlage Artikeleinheit
    //                 lrc_ItemUnitofMeasure.Reset();
    //                 lrc_ItemUnitofMeasure.INIT();
    //                 lrc_ItemUnitofMeasure.VALIDATE("Item No.", vrc_RecipeOutputItems."Item No.");
    //                 lrc_ItemUnitofMeasure.VALIDATE( Code, lrc_UnitOfMeasure.Code);
    //                 lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := lrc_UnitOfMeasure."Qty. (BU) per Unit of Measure";
    //                 lrc_ItemUnitofMeasure."Kind of Unit of Measure" := lrc_ItemUnitofMeasure."Kind of Unit of Measure"::"Collo Unit";
    //                 lrc_ItemUnitofMeasure.insert();
    //               END;

    //               EXIT(lrc_UnitOfMeasure.Code);
    //             END;
    //           END;
    //         END;
    //     end;

    //     procedure "-- ITEM FEATURES --"()
    //     begin
    //     end;

    //     procedure VarietyCodeSearch(var rco_VarietyCode: Code[10]): Boolean
    //     var
    //         lrc_Variety: Record "5110303";
    //         lfm_Variety: Form "5110420";
    //         vco_SearchString: Code[30];
    //         lin_AnzTreffer: Integer;
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Suche der Sorte
    //         // ------------------------------------------------------------------------------------

    //         // -------------------------------------------------------------------------
    //         // Suche nach Sortencode
    //         // -------------------------------------------------------------------------
    //         lrc_Variety.Reset();
    //         IF lrc_Variety.GET(rco_VarietyCode) THEN BEGIN
    //           rco_VarietyCode := lrc_Variety.Code;
    //           EXIT(TRUE);
    //         END;

    //         IF rco_VarietyCode = '' THEN
    //           EXIT(TRUE);

    //         // -------------------------------------------------------------------------
    //         // Suche nach Suchbegriff Sortencode
    //         // -------------------------------------------------------------------------
    //         vco_SearchString := rco_VarietyCode;

    //         vco_SearchString := '*' + vco_SearchString + '*';
    //         WHILE STRPOS(vco_SearchString,' ') > 0 DO BEGIN
    //           vco_SearchString := COPYSTR(vco_SearchString, 1, (STRPOS(vco_SearchString,' ') - 1)) + '*&*' +
    //                               COPYSTR(vco_SearchString, (STRPOS(vco_SearchString,' ') + 1), 30);
    //         END;

    //         lrc_Variety.Reset();
    //         lrc_Variety.SETFILTER("Search Description",vco_SearchString);
    //         lin_AnzTreffer := lrc_Variety.COUNT();
    //         CASE lin_AnzTreffer OF
    //         0:
    //           BEGIN
    //             EXIT(FALSE);
    //           END;
    //         1:
    //           BEGIN
    //             lrc_Variety.FIND('-');
    //             rco_VarietyCode := lrc_Variety.Code;
    //             EXIT(TRUE);
    //           END;
    //         ELSE
    //           lfm_Variety.LOOKUPMODE := TRUE;
    //           lfm_Variety.SETTABLEVIEW(lrc_Variety);
    //           IF lfm_Variety.RUNMODAL <> ACTION::LookupOK THEN
    //             EXIT(FALSE);

    //           lrc_Variety.Reset();
    //           lfm_Variety.GETRECORD(lrc_Variety);
    //           rco_VarietyCode := lrc_Variety.Code;
    //           EXIT(TRUE);
    //         END;

    //         EXIT(FALSE);
    //     end;

    procedure CaliberValidate(vco_CaliberCode: Code[10]; vco_ProductGroupCode: Code[20])
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_Caliber: Record "POI Caliber";
        lrc_ProductGroupCaliber: Record "POI Product Group - Caliber";
        AGILES_LT_TEXT001Txt: Label 'Validierung Kaliber nicht möglich. Bitte zuerst Produktgruppe eingeben!';
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zur Validierung der Kalibereingabe
        // ---------------------------------------------------------------------------------------------

        IF vco_CaliberCode = '' THEN
            EXIT;

        lrc_FruitVisionSetup.GET();

        CASE lrc_FruitVisionSetup."Item - Validate Caliber" OF
            lrc_FruitVisionSetup."Item - Validate Caliber"::" ":
                lrc_Caliber.GET(vco_CaliberCode);
            lrc_FruitVisionSetup."Item - Validate Caliber"::"Product Group":
                BEGIN
                    IF vco_ProductGroupCode = '' THEN
                        ERROR(AGILES_LT_TEXT001Txt);
                    lrc_ProductGroupCaliber.RESET();
                    lrc_ProductGroupCaliber.SETRANGE("Product Group Code", vco_ProductGroupCode);
                    lrc_ProductGroupCaliber.SETRANGE("Caliber Code", vco_CaliberCode);
                    //lrc_ProductGroupCaliber.FIND('-'); //TODO: sinn klären
                END;

        END;
    end;

    procedure CaliberLookUp(vco_ProductGroup: Code[20]): Code[10]
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_Caliber: Record "POI Caliber";
        lrc_ProductGroupCaliber: Record "POI Product Group - Caliber";
    //lfm_Caliber: Form "5110421";
    //lfm_ProductGroupCaliber: Form "5110436";
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zum LookUp Caliber
        // ---------------------------------------------------------------------------------------------

        lrc_FruitVisionSetup.GET();

        CASE lrc_FruitVisionSetup."Item - Validate Caliber" OF
            lrc_FruitVisionSetup."Item - Validate Caliber"::" ":
                BEGIN
                    // lfm_Caliber.LOOKUPMODE := TRUE;
                    // lfm_Caliber.SETTABLEVIEW(lrc_Caliber);
                    // IF lfm_Caliber.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                    lrc_Caliber.RESET();
                    // lfm_Caliber.GETRECORD(lrc_Caliber);
                    //     EXIT(lrc_Caliber.Code);
                    // END ELSE
                    EXIT('');
                END;

            lrc_FruitVisionSetup."Item - Validate Caliber"::"Product Group":
                BEGIN
                    lrc_ProductGroupCaliber.RESET();
                    lrc_ProductGroupCaliber.FILTERGROUP(2);
                    lrc_ProductGroupCaliber.SETRANGE("Product Group Code", vco_ProductGroup);
                    lrc_ProductGroupCaliber.FILTERGROUP(0);

                    // lfm_ProductGroupCaliber.LOOKUPMODE := TRUE;
                    // lfm_ProductGroupCaliber.SETTABLEVIEW(lrc_ProductGroupCaliber);
                    // IF lfm_ProductGroupCaliber.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                    //     lrc_ProductGroupCaliber.RESET();
                    //     lfm_ProductGroupCaliber.GETRECORD(lrc_ProductGroupCaliber);
                    //     EXIT(lrc_ProductGroupCaliber."Caliber Code");
                    // END ELSE
                    //     EXIT('');
                END;
        END;

        EXIT('');
    end;

    procedure VendorCaliberInCaliber(vco_VendorNo: Code[20]; vco_VendorCaliberCode: Code[10]; vco_ProductGroupCode: Code[10]; vco_VarietyCode: Code[10]): Code[10]
    begin
        // -----------------------------------------------------------
        // Kreditor Kaliber in Kaliber übersetzen
        // vco_VendorNo
        // vco_VendorCaliberCode
        // vco_ProductGroupCode
        // vco_VarietyCode
        // -----------------------------------------------------------

        lrc_CaliberVendorCaliber.RESET();
        lrc_CaliberVendorCaliber.SETRANGE("Vendor No.", vco_VendorNo);
        lrc_CaliberVendorCaliber.SETRANGE("Vend. Caliber Code", vco_VendorCaliberCode);
        lrc_CaliberVendorCaliber.SETRANGE("Product Group Code", vco_ProductGroupCode);
        lrc_CaliberVendorCaliber.SETRANGE("Variety Code", vco_VarietyCode);
        IF NOT lrc_CaliberVendorCaliber.FIND('-') THEN BEGIN
            lrc_CaliberVendorCaliber.RESET();
            lrc_CaliberVendorCaliber.SETRANGE("Vendor No.", vco_VendorNo);
            lrc_CaliberVendorCaliber.SETRANGE("Vend. Caliber Code", vco_VendorCaliberCode);
            lrc_CaliberVendorCaliber.SETRANGE("Product Group Code", vco_ProductGroupCode);
            lrc_CaliberVendorCaliber.SETRANGE("Variety Code", '');
            IF NOT lrc_CaliberVendorCaliber.FIND('-') THEN BEGIN
                lrc_CaliberVendorCaliber.RESET();
                lrc_CaliberVendorCaliber.SETRANGE("Vendor No.", vco_VendorNo);
                lrc_CaliberVendorCaliber.SETRANGE("Vend. Caliber Code", vco_VendorCaliberCode);
                lrc_CaliberVendorCaliber.SETRANGE("Product Group Code", '');
                lrc_CaliberVendorCaliber.SETRANGE("Variety Code", '');
                IF lrc_CaliberVendorCaliber.FIND('-') THEN
                    EXIT(lrc_CaliberVendorCaliber."Caliber Code")
                ELSE
                    EXIT('');
            END ELSE
                EXIT(lrc_CaliberVendorCaliber."Caliber Code")
        END ELSE
            EXIT(lrc_CaliberVendorCaliber."Caliber Code");
    end;

    procedure VarietyValidate(vco_VarietyCode: Code[10]; vco_ProductGroupCode: Code[20]): Boolean
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_Variety: Record "POI Variety";
        AGILES_LT_TEXT001Txt: Label 'Validierung Sorten nicht möglich. Bitte zuerst Produktgruppe eingeben!';

    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zur Validierung der Sorteneingabe
        // ---------------------------------------------------------------------------------------------

        IF vco_VarietyCode = '' THEN
            EXIT(TRUE);

        lrc_FruitVisionSetup.GET();

        CASE lrc_FruitVisionSetup."Item - Validate Variety" OF
            lrc_FruitVisionSetup."Item - Validate Variety"::" ":
                BEGIN
                    lrc_Variety.GET(vco_VarietyCode);
                    EXIT(TRUE);
                END;
            lrc_FruitVisionSetup."Item - Validate Variety"::"Product Group":
                IF vco_ProductGroupCode = '' THEN
                    ERROR(AGILES_LT_TEXT001Txt);
        END;
    end;

    procedure VarietyLookUp(vco_ProductGroup: Code[20]): Code[10]
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_Variety: Record "POI Variety";
    //lfm_Variety: Form "5110420";
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zum LookUp Sorte
        // ---------------------------------------------------------------------------------------------

        lrc_FruitVisionSetup.GET();

        CASE lrc_FruitVisionSetup."Item - Validate Variety" OF

            lrc_FruitVisionSetup."Item - Validate Variety"::" ":
                BEGIN
                    // lfm_Variety.LOOKUPMODE := TRUE;
                    // lfm_Variety.SETTABLEVIEW(lrc_Variety);
                    // IF lfm_Variety.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    lrc_Variety.RESET();
                    //     lfm_Variety.GETRECORD(lrc_Variety);
                    //     EXIT(lrc_Variety.Code);
                    // END ELSE
                    EXIT('');
                END;

            lrc_FruitVisionSetup."Item - Validate Variety"::"Product Group":

                IF vco_ProductGroup <> '' THEN BEGIN
                    //     lfm_Variety.LOOKUPMODE := TRUE;
                    //     lrc_Variety.SETRANGE("Product Group Code", vco_ProductGroup);
                    //     lfm_Variety.SETTABLEVIEW(lrc_Variety);
                    //     IF lfm_Variety.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                    lrc_Variety.RESET();
                    //         lfm_Variety.GETRECORD(lrc_Variety);
                    //         EXIT(lrc_Variety.Code);
                    //     END ELSE
                    EXIT('');
                END;
        END;

        EXIT('');
    end;

    procedure CountryValidate(vco_CountryCode: Code[10]; vco_ProductGroupCode: Code[20])
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_Country: Record "Country/Region";
        lrc_ProductGroupCountry: Record "POI Product Grp-Country/Region";
        AGILES_LT_TEXT001Txt: Label 'Validierung Ursprungsland nicht möglich. Bitte zuerst Produktgruppe eingeben!';
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zur Validierung der Ländereingabe
        // ---------------------------------------------------------------------------------------------

        IF vco_CountryCode = '' THEN
            EXIT;

        lrc_FruitVisionSetup.GET();

        CASE lrc_FruitVisionSetup."Item - Validate Country" OF
            lrc_FruitVisionSetup."Item - Validate Country"::" ":
                lrc_Country.GET(vco_CountryCode);


            lrc_FruitVisionSetup."Item - Validate Country"::"Product Group":
                BEGIN
                    IF vco_ProductGroupCode = '' THEN
                        ERROR(AGILES_LT_TEXT001Txt);

                    lrc_ProductGroupCountry.RESET();
                    lrc_ProductGroupCountry.SETRANGE("Product Group Code", vco_ProductGroupCode);
                    lrc_ProductGroupCountry.SETRANGE("Country/Region Code", vco_CountryCode);
                    //lrc_ProductGroupCountry.FIND('-');
                END;
        END;
    end;

    procedure CountryLookUp(vco_ProductGroup: Code[20]): Code[10]
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_Country: Record "Country/Region";
        lrc_ProductGroupCountry: Record "POI Product Grp-Country/Region";
        lfm_Country: Page "Countries/Regions";
    //lfm_ProductGroupCountry: Form "5110438";
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zum LookUp Land
        // ---------------------------------------------------------------------------------------------

        lrc_FruitVisionSetup.GET();

        CASE lrc_FruitVisionSetup."Item - Validate Country" OF
            lrc_FruitVisionSetup."Item - Validate Country"::" ":
                BEGIN
                    lfm_Country.LOOKUPMODE := TRUE;
                    lfm_Country.SETTABLEVIEW(lrc_Country);
                    IF lfm_Country.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                        lrc_Country.RESET();
                        lfm_Country.GETRECORD(lrc_Country);
                        EXIT(lrc_Country.Code);
                    END ELSE
                        EXIT('');
                END;

            lrc_FruitVisionSetup."Item - Validate Country"::"Product Group":
                BEGIN

                    lrc_ProductGroupCountry.RESET();
                    lrc_ProductGroupCountry.FILTERGROUP(2);
                    lrc_ProductGroupCountry.SETRANGE("Product Group Code", vco_ProductGroup);
                    lrc_ProductGroupCountry.FILTERGROUP(0);

                    // lfm_ProductGroupCountry.LOOKUPMODE := TRUE; //TODO: Page
                    // lfm_ProductGroupCountry.SETTABLEVIEW(lrc_ProductGroupCountry);
                    // IF lfm_ProductGroupCountry.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    //   lrc_ProductGroupCountry.RESET();
                    //   lfm_ProductGroupCountry.GETRECORD(lrc_ProductGroupCountry);
                    //   EXIT(lrc_ProductGroupCountry."Country/Region Code");
                    // END ELSE
                    //   EXIT('');
                END;
        END;

        EXIT('');
    end;

    //     procedure ColorLookUp(vco_ProductGroup: Code[20]): Code[10]
    //     var
    //         lrc_Color: Record "5110310";
    //         lfm_Color: Form "5110310";
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zum LookUp Color
    //         // ---------------------------------------------------------------------------------------------

    //         lfm_Color.LOOKUPMODE := TRUE;
    //         lfm_Color.SETTABLEVIEW(lrc_Color);
    //         IF lfm_Color.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //           lrc_Color.Reset();
    //           lfm_Color.GETRECORD(lrc_Color);
    //           EXIT(lrc_Color.Code);
    //         END ELSE
    //           EXIT('');
    //     end;

    //     procedure CodingLookUp(vco_ProductGroup: Code[20]): Code[10]
    //     var
    //         lrc_Coding: Record "5110312";
    //         lfm_Coding: Form "5110312";
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zum LookUp Codierung
    //         // ---------------------------------------------------------------------------------------------

    //         // F40 001 00000000.s
    //         lfm_Coding.LOOKUPMODE := TRUE;
    //         lfm_Coding.SETTABLEVIEW(lrc_Coding);
    //         IF lfm_Coding.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //           lrc_Coding.Reset();
    //           lfm_Coding.GETRECORD(lrc_Coding);
    //           EXIT(lrc_Coding.Code);
    //         END ELSE
    //           EXIT('');
    //         // F40 001 00000000.e
    //     end;

    //     procedure ConservationLookUp(vco_ProductGroup: Code[20]): Code[10]
    //     var
    //         lrc_Conservation: Record "5110309";
    //         lfm_Conservation: Form "5110309";
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zum LookUp Conservation
    //         // ---------------------------------------------------------------------------------------------

    //         // F40 001 00000000.s
    //         lfm_Conservation.LOOKUPMODE := TRUE;
    //         lfm_Conservation.SETTABLEVIEW(lrc_Conservation);
    //         IF lfm_Conservation.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //           lrc_Conservation.Reset();
    //           lfm_Conservation.GETRECORD(lrc_Conservation);
    //           EXIT(lrc_Conservation.Code);
    //         END ELSE
    //           EXIT('');
    //         // F40 001 00000000.e
    //     end;

    //     procedure VendorCaliberLookUp(vco_ProductGroup: Code[20];vco_Caliber: Code[10]): Code[10]
    //     var
    //         lrc_CaliberVendorCaliber: Record "5110305";
    //         lfm_CaliberVendorCaliber: Form "5110435";
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zum LookUp VendorCaliber
    //         // ---------------------------------------------------------------------------------------------

    //         // F40 001 00000000.s
    //         lfm_CaliberVendorCaliber.LOOKUPMODE := TRUE;
    //         lfm_CaliberVendorCaliber.SETTABLEVIEW(lrc_CaliberVendorCaliber);
    //         IF lfm_CaliberVendorCaliber.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //           lrc_CaliberVendorCaliber.Reset();
    //           lfm_CaliberVendorCaliber.GETRECORD(lrc_CaliberVendorCaliber);
    //           EXIT(lrc_CaliberVendorCaliber."Vend. Caliber Code");
    //         END ELSE
    //           EXIT('');
    //         // F40 001 00000000.e
    //     end;

    //     procedure PackingLookUp(vco_ProductGroup: Code[20]): Code[10]
    //     var
    //         lrc_Packing: Record "5110313";
    //         lfm_Packing: Form "5110313";
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zum LookUp Packing
    //         // ---------------------------------------------------------------------------------------------

    //         // F40 001 00000000.s
    //         lfm_Packing.LOOKUPMODE := TRUE;
    //         lfm_Packing.SETTABLEVIEW(lrc_Packing);
    //         IF lfm_Packing.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //           lrc_Packing.Reset();
    //           lfm_Packing.GETRECORD(lrc_Packing);
    //           EXIT(lrc_Packing.Code);
    //         END ELSE
    //           EXIT('');
    //         // F40 001 00000000.e
    //     end;

    //     procedure TreatmentLookUp(vco_ProductGroup: Code[20]): Code[10]
    //     var
    //         lrc_Treatment: Record "5110314";
    //         lfm_Treatment: Form "5110314";
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zum LookUp Treatment
    //         // ---------------------------------------------------------------------------------------------

    //         // F40 001 00000000.s
    //         lfm_Treatment.LOOKUPMODE := TRUE;
    //         lfm_Treatment.SETTABLEVIEW(lrc_Treatment);
    //         IF lfm_Treatment.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //           lrc_Treatment.Reset();
    //           lfm_Treatment.GETRECORD(lrc_Treatment);
    //           EXIT(lrc_Treatment.Code);
    //         END ELSE
    //           EXIT('');
    //         // F40 001 00000000.e
    //     end;

    procedure TrademarkLookUp(vco_ProductGroup: Code[20]): Code[20]
    var
        lrc_Trademark: Record "POI Trademark";
    //lfm_Trademark: Form "5110422";
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zum LookUp Trademark
        // ---------------------------------------------------------------------------------------------

        // lfm_Trademark.LOOKUPMODE := TRUE;
        // lfm_Trademark.SETTABLEVIEW(lrc_Trademark);
        // IF lfm_Trademark.RUNMODAL = ACTION::LookupOK THEN BEGIN
        lrc_Trademark.RESET();
        //   lfm_Trademark.GETRECORD(lrc_Trademark);
        //   EXIT(lrc_Trademark.Code);
        // END ELSE
        EXIT('');
    end;

    //     procedure GradeOfGoodsLookUp(vco_ProductGroup: Code[20]): Code[10]
    //     var
    //         lrc_GradeOfGoods: Record "5110308";
    //         lfm_GradeOfGoods: Form "5110308";
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zum LookUp Grade Of Goods
    //         // ---------------------------------------------------------------------------------------------

    //         // F40 001 00000000.s
    //         lfm_GradeOfGoods.LOOKUPMODE := TRUE;
    //         lfm_GradeOfGoods.SETTABLEVIEW(lrc_GradeOfGoods);
    //         IF lfm_GradeOfGoods.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //           lrc_GradeOfGoods.Reset();
    //           lfm_GradeOfGoods.GETRECORD(lrc_GradeOfGoods);
    //           EXIT(lrc_GradeOfGoods.Code);
    //         END ELSE
    //           EXIT('');
    //         // F40 001 00000000.e
    //     end;

    procedure ProducerValidate(vco_ProducerNo: Code[20]; vco_VendorNo: Code[20])
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_Vendorlinks: Record "POI Vendor Links";
        AGILES_LT_TEXT001Txt: Label 'Validierung Produzent nicht möglich. Bitte zuerst den Kreditor eingeben!';

    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zur Validierung der Prodzenteneingabe
        // ---------------------------------------------------------------------------------------------

        IF vco_ProducerNo = '' THEN
            EXIT;

        lrc_FruitVisionSetup.GET();

        CASE lrc_FruitVisionSetup."Vendor - Validate Producer" OF
            lrc_FruitVisionSetup."Vendor - Validate Producer"::"All Producer":
                BEGIN
                    lrc_Vendor.GET(vco_ProducerNo);
                    lrc_Vendor.TESTFIELD("POI Is Manufacturer");
                END;

            lrc_FruitVisionSetup."Vendor - Validate Producer"::"Vendor - Producer":
                BEGIN
                    IF vco_VendorNo = '' THEN
                        ERROR(AGILES_LT_TEXT001Txt);
                    lrc_Vendorlinks.GET(lrc_Vendorlinks."Entry Type"::Producer, vco_VendorNo, vco_ProducerNo);
                    lrc_Vendor.GET(vco_ProducerNo);
                    lrc_Vendor.TESTFIELD("POI Is Manufacturer");
                END;
        END;
    end;

    procedure ProducerLookUp(vco_VendorNo: Code[20]): Code[20]
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_Vendorlinks: Record "POI Vendor Links";
        // lfm_Vendorlinks: Form "5087953";
        lfm_Vendorlist: Page "Vendor List";

        AGILES_LT_TEXT001Txt: Label 'Lookup Produzent nicht möglich. Bitte zuerst den Kreditor eingeben!';
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zum LookUp Produzent
        // ---------------------------------------------------------------------------------------------


        lrc_FruitVisionSetup.GET();

        CASE lrc_FruitVisionSetup."Vendor - Validate Producer" OF

            lrc_FruitVisionSetup."Vendor - Validate Producer"::"All Producer":
                BEGIN
                    lfm_Vendorlist.LOOKUPMODE := TRUE;
                    lrc_Vendor.RESET();
                    lrc_Vendor.SETRANGE("POI Is Manufacturer", TRUE);
                    lfm_Vendorlist.SETTABLEVIEW(lrc_Vendor);
                    IF lfm_Vendorlist.RUNMODAL() = ACTION::LookupOK THEN BEGIN
                        lrc_Vendor.RESET();
                        lfm_Vendorlist.GETRECORD(lrc_Vendor);
                        lrc_Vendor.TESTFIELD("POI Is Manufacturer");
                        EXIT(lrc_Vendor."No.");
                    END ELSE
                        EXIT('');
                END;

            lrc_FruitVisionSetup."Vendor - Validate Producer"::"Vendor - Producer":
                IF vco_VendorNo <> '' THEN BEGIN
                    // lfm_Vendorlinks.LOOKUPMODE := TRUE; //TODO: page
                    lrc_Vendorlinks.RESET();
                    lrc_Vendorlinks.SETRANGE("Entry Type", lrc_Vendorlinks."Entry Type"::Producer);
                    lrc_Vendorlinks.SETRANGE("Vendor No.", vco_VendorNo);
                    // lfm_Vendorlinks.SETTABLEVIEW(lrc_Vendorlinks); //TODO: page
                    // IF lfm_Vendorlinks.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    //     lrc_Vendorlinks.RESET();
                    //     lfm_Vendorlinks.GETRECORD(lrc_Vendorlinks);
                    //     lrc_Vendor.GET(lrc_Vendorlinks."Attached Vendor No.");
                    //     lrc_Vendor.TESTFIELD("Is Manufacturer");
                    //     EXIT(lrc_Vendor."No.");
                    // END ELSE
                    //     EXIT('');
                END ELSE
                    ERROR(AGILES_LT_TEXT001Txt);
        END;

        EXIT('');

    end;


    procedure GetPersonInCharge(): Code[20]
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung der Sachbearbeiternr auf Basis der USERID
        // -----------------------------------------------------------------------------

        lrc_SalesPurchaser.SETRANGE("POI Navision User ID Code", UserID());
        lrc_SalesPurchaser.SETRANGE("POI Is Person in Charge", TRUE);
        IF lrc_SalesPurchaser.FIND('-') THEN
            EXIT(lrc_SalesPurchaser.Code)
        ELSE
            EXIT('');
    end;

    procedure GetSalesman(): Code[20]
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung der Verkäufernr auf Basis der USERID
        // -----------------------------------------------------------------------------

        lrc_SalesPurchaser.SETRANGE("POI Navision User ID Code", UserID());
        lrc_SalesPurchaser.SETRANGE("POI Is Salesperson", TRUE);
        IF lrc_SalesPurchaser.FIND('-') THEN
            EXIT(lrc_SalesPurchaser.Code)
        ELSE
            EXIT('');
    end;

    //     procedure GetPurchaser(): Code[20]
    //     var
    //         lrc_SalesPurchaser: Record "13";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zur Ermittlung der Einkäufernr auf Basis der USERID
    //         // -----------------------------------------------------------------------------

    //         lrc_SalesPurchaser.SETRANGE("Navision User ID Code",UserID());
    //         lrc_SalesPurchaser.SETRANGE("Is Purchaser",TRUE);
    //         IF lrc_SalesPurchaser.FIND('-') THEN
    //           EXIT(lrc_SalesPurchaser.Code)
    //         ELSE
    //           EXIT('');
    //     end;

    procedure VoyageCodeSearch(var rco_VoyageCode: Code[20]): Boolean
    var
        lrc_Voyage: Record "POI Voyage";
        //lfm_Voyage: Form "5110325";
        lco_SearchDescription: Code[50];
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung der Reisenummer
        // -----------------------------------------------------------------------------

        IF rco_VoyageCode = '' THEN
            EXIT(TRUE);

        IF lrc_Voyage.GET(rco_VoyageCode) THEN
            EXIT(TRUE);

        lco_SearchDescription := rco_VoyageCode;
        lco_SearchDescription := CreateItemSearchString(lco_SearchDescription);

        lrc_Voyage.SETFILTER("Search Description", lco_SearchDescription);
        // IF lrc_Voyage.FIND('-') THEN BEGIN //TODO: page
        //   lfm_Voyage.LOOKUPMODE := TRUE;
        //   lfm_Voyage.SETTABLEVIEW(lrc_Voyage);
        //   IF lfm_Voyage.RUNMODAL() = ACTION::LookupOK THEN BEGIN
        //     lfm_Voyage.GETRECORD(lrc_Voyage);
        //     rco_VoyageCode := lrc_Voyage."No.";
        //     EXIT(TRUE);
        //   END ELSE
        //     EXIT(FALSE);
        // END;

        EXIT(FALSE);
    end;



    //     procedure GetGrossNetWeight(vco_UnitOfMeasureCode: Code[10];vin_GewVonEinheit: Integer;var vdc_GrossWeight: Decimal;var vdc_NetWeight: Decimal)
    //     var
    //         lrc_UnitofMeasure: Record "204";
    //         AGILES_LT_TEXT001: Label 'Gewicht von Einheit kann nicht zugeordnet werden!';
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zur Ermittlung Brutto- / Nettogewicht
    //         // -----------------------------------------------------------------------------
    //         // vco_UnitOfMeasureCode
    //         // vin_GewVonEinheit    1 = Kollo
    //         //                      2 = Verpackungseinheit
    //         //                      3 = Basiseinheit
    //         // -----------------------------------------------------------------------------

    //         IF NOT lrc_UnitofMeasure.GET(vco_UnitOfMeasureCode) THEN
    //           EXIT;

    //         CASE vin_GewVonEinheit OF
    //         1: // Kollo
    //           BEGIN
    //             vdc_GrossWeight := lrc_UnitofMeasure."Gross Weight";
    //             vdc_NetWeight := lrc_UnitofMeasure."Net Weight";
    //           END;
    //         2: // Verpackung
    //           BEGIN
    //             IF lrc_UnitofMeasure."Qty. (PU) per Unit of Measure" <> 0 THEN BEGIN
    //               vdc_GrossWeight := lrc_UnitofMeasure."Gross Weight" / lrc_UnitofMeasure."Qty. (PU) per Unit of Measure";
    //               vdc_NetWeight := lrc_UnitofMeasure."Net Weight" / lrc_UnitofMeasure."Qty. (PU) per Unit of Measure";
    //             END;
    //           END;
    //         3: // Basis
    //           BEGIN
    //             vdc_GrossWeight := lrc_UnitofMeasure."Gross Weight" / lrc_UnitofMeasure."Qty. (BU) per Unit of Measure";
    //             vdc_NetWeight := lrc_UnitofMeasure."Net Weight" / lrc_UnitofMeasure."Qty. (BU) per Unit of Measure";
    //           END;
    //         ELSE
    //           // Gewicht von Einheit kann nicht zugeordnet werden!
    //           ERROR(AGILES_LT_TEXT001);
    //         END;
    //     end;

    procedure CreateItemSearchString(vco_SearchString: Code[50]): Code[50]
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Erstellung eines Suchbegriffes
        // -----------------------------------------------------------------------------

        lrc_FruitVisionSetup.GET();

        CASE lrc_FruitVisionSetup."Item Search Desc. Template" OF

            // ------------------------------------------------------------------------------------
            // Schablone 2 -> Fruchthof Northeim
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 2":
                BEGIN
                    vco_SearchString := copystr(vco_SearchString + '*', 1, 50);
                    WHILE STRPOS(vco_SearchString, ' ') > 0 DO
                        vco_SearchString := COPYSTR(vco_SearchString, 1, (STRPOS(vco_SearchString, ' ') - 1)) + '*' + COPYSTR(vco_SearchString, (STRPOS(vco_SearchString, ' ') + 1), 50);

                END;


            // ------------------------------------------------------------------------------------
            // Schablone 8 -> Landlinie
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 8":
                BEGIN
                    vco_SearchString := copystr(vco_SearchString + '*', 1, 50);
                    WHILE STRPOS(vco_SearchString, ' ') > 0 DO
                        vco_SearchString := COPYSTR(vco_SearchString, 1, (STRPOS(vco_SearchString, ' ') - 1)) + '*&*' + COPYSTR(vco_SearchString, (STRPOS(vco_SearchString, ' ') + 1), 50);
                END;

            // ------------------------------------------------------------------------------------
            // Allgemein, falls nicht abweichend definiert
            // ------------------------------------------------------------------------------------
            ELSE BEGIN
                    vco_SearchString := copystr('*' + vco_SearchString + '*', 1, 50);
                    WHILE STRPOS(vco_SearchString, ' ') > 0 DO
                        vco_SearchString := COPYSTR(vco_SearchString, 1, (STRPOS(vco_SearchString, ' ') - 1)) + '*&*' + COPYSTR(vco_SearchString, (STRPOS(vco_SearchString, ' ') + 1), 50);

                END;
        END;

        EXIT(vco_SearchString);
    end;

    //     procedure VendContactList(vco_VendNo: Code[20])
    //     var
    //         ContBusRel: Record "5054";
    //         Cont: Record "5050";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktion Anzeige Kontaktübersicht Kreditor
    //         // -------------------------------------------------------------------------------------

    //         ContBusRel.SETCURRENTKEY("Link to Table","No.");
    //         ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
    //         ContBusRel.SETRANGE("No.",vco_VendNo);
    //         IF ContBusRel.FIND('-') THEN
    //           Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
    //         FORM.RUNMODAL(0,Cont);
    //     end;

    //     procedure CustContactList(vco_CustNo: Code[20])
    //     var
    //         ContBusRel: Record "5054";
    //         Cont: Record "5050";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktion Anzeige Kontaktübersicht Debitor
    //         // -------------------------------------------------------------------------------------

    //         ContBusRel.SETCURRENTKEY("Link to Table","No.");
    //         ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
    //         ContBusRel.SETRANGE("No.",vco_CustNo);
    //         IF ContBusRel.FIND('-') THEN
    //           Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
    //         FORM.RUNMODAL(0,Cont);
    //     end;

    //     procedure "--------"()
    //     begin
    //     end;

    //     procedure OnValidateEntryExitPoint(rco_RecEntryExitPoint: Code[10];rco_xRecEntryExitPoint: Code[10]): Code[10]
    //     var
    //         "-- SSP L INT 001": Integer;
    //         lrc_EntryExitPoint: Record "282";
    //         AGILES_LT_TEXT001: Label 'The Entry/Exit Point %1, Entry/Exit Point with Intrastat Code %1 does not exist !';
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------

    //         // INT 001 00000000.s
    //         lrc_EntryExitPoint.Reset();
    //         lrc_EntryExitPoint.SETRANGE( Code, rco_RecEntryExitPoint);
    //         IF lrc_EntryExitPoint.FIND('-') THEN BEGIN
    //           EXIT(lrc_EntryExitPoint."Intrastat Code");
    //         END ELSE BEGIN
    //           lrc_EntryExitPoint.Reset();
    //           lrc_EntryExitPoint.SETCURRENTKEY("Intrastat Code");
    //           lrc_EntryExitPoint.SETRANGE("Intrastat Code", rco_RecEntryExitPoint);
    //           IF lrc_EntryExitPoint.FIND('-') THEN BEGIN
    //             EXIT(lrc_EntryExitPoint."Intrastat Code");
    //           END ELSE BEGIN
    //             MESSAGE(AGILES_LT_TEXT001, rco_RecEntryExitPoint);
    //             EXIT(rco_xRecEntryExitPoint);
    //           END;
    //         END;
    //         // INT 001 00000000.e
    //     end;

    //     procedure OnLoockupEntryExitPoint(rco_EntryExitPoint: Code[10]): Code[10]
    //     var
    //         "-- SSP L INT 001": Integer;
    //         lrc_EntryExitPoint: Record "282";
    //         lfm_EntryExitPoints: Form "394";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------

    //         // INT 001 00000000.s
    //         lrc_EntryExitPoint.Reset();
    //         lfm_EntryExitPoints.LOOKUPMODE( TRUE);
    //         IF lfm_EntryExitPoints.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //           lfm_EntryExitPoints.GETRECORD(lrc_EntryExitPoint );
    //           EXIT(lrc_EntryExitPoint."Intrastat Code");
    //         END ELSE BEGIN
    //           EXIT( rco_EntryExitPoint);
    //         END;
    //         // INT 001 00000000.e
    //     end;

    //     procedure GetProductGroup(): Code[10]
    //     var
    //         lrc_ProductGroup: Record "5723";
    //         lfm_ProductGroups: Form "5731";
    //         lco_ProductGroupCode: Code[10];
    //     begin
    //         // --------------------------------------------------------------------------------
    //         // Funktion zur Auswahl der Produktgruppe bei Artikelanlage
    //         // --------------------------------------------------------------------------------

    //         lfm_ProductGroups.LOOKUPMODE := TRUE;
    //         IF lfm_ProductGroups.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //           lfm_ProductGroups.GETRECORD(lrc_ProductGroup);
    //           lco_ProductGroupCode := lrc_ProductGroup.Code;
    //         END;

    //         EXIT(lco_ProductGroupCode);
    //     end;

    //     procedure AnbruchSetzen(vco_ItemNo: Code[20])
    //     var
    //         ldl_Fenster: Dialog;
    //         lrc_ItemUnitofMeasure: Record "5404";
    //         lrc_ItemUnitofMeasureII: Record "5404";
    //         lrc_Item: Record Item;
    //         lrc_UnitofMeasure: Record "204";
    //     begin
    //         // --------------------------------------------------------------------------------
    //         // Funktion zur Auswahl der Produktgruppe bei Artikelanlage
    //         // --------------------------------------------------------------------------------


    //         ldl_Fenster.OPEN('Artikelnr. #1##########');


    //         IF vco_ItemNo <> '' THEN
    //           lrc_Item.SETRANGE("No.",vco_ItemNo);
    //         lrc_Item.SETRANGE("Item Typ",lrc_Item."Item Typ"::"Trade Item");
    //         IF lrc_Item.FIND('-') THEN BEGIN
    //           REPEAT
    //             ldl_Fenster.UPDATE(1,lrc_Item."No.");

    //             lrc_ItemUnitofMeasure.Reset();
    //             lrc_ItemUnitofMeasure.SETRANGE("Item No.",lrc_Item."No.");
    //             lrc_ItemUnitofMeasure.MODIFYALL("Partial Quantity",FALSE);
    //             COMMIT;

    //             lrc_ItemUnitofMeasure.Reset();
    //             lrc_ItemUnitofMeasure.SETRANGE("Item No.",lrc_Item."No.");
    //             IF lrc_ItemUnitofMeasure.FIND('-') THEN BEGIN
    //               REPEAT
    //                 IF lrc_UnitofMeasure.GET(lrc_ItemUnitofMeasure.Code) THEN BEGIN
    //                   IF lrc_UnitofMeasure."Partitial Qty. Unit of Measure" <> '' THEN BEGIN
    //                     IF lrc_ItemUnitofMeasureII.GET(lrc_Item."No.",lrc_UnitofMeasure."Partitial Qty. Unit of Measure") THEN BEGIN
    //                       lrc_ItemUnitofMeasureII."Partial Quantity" := TRUE;
    //                       lrc_ItemUnitofMeasureII.Modify();
    //                     END;
    //                   END;
    //                 END;
    //               UNTIL lrc_ItemUnitofMeasure.NEXT() = 0;
    //             END;

    //           UNTIL lrc_Item.NEXT() = 0;
    //         END;

    //         ldl_Fenster.CLOSE;
    //     end;

    //     procedure "-- IC COPY BASE DATA --"()
    //     begin
    //     end;

    //     procedure IC_CopyItem(vrc_Item: Record Item)
    //     var
    //         lrc_CompanyInformation: Record "79";
    //         lrc_Company: Record "2000000006";
    //         lrc_CC_Item: Record Item;
    //         lrc_ItemUnitofMeasure: Record "5404";
    //         lrc_CC_ItemUnitofMeasure: Record "5404";
    //     begin
    //         // --------------------------------------------------------------------------------
    //         // Artikelstammdatensatz und Artikeleinheitensätze kopieren
    //         // --------------------------------------------------------------------------------

    //         IF vrc_Item."No." = '' THEN
    //           EXIT;

    //         lrc_CompanyInformation.GET();
    //         IF lrc_CompanyInformation."Company Typ" <> lrc_CompanyInformation."Company Typ"::Master THEN
    //           EXIT;

    //         lrc_Company.SETFILTER(Name,'<>%1',COMPANYNAME);
    //         IF lrc_Company.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_CompanyInformation.CHANGECOMPANY(lrc_Company.Name);
    //             lrc_CompanyInformation.GET();
    //             IF lrc_CompanyInformation."Company Typ" = lrc_CompanyInformation."Company Typ"::Slave THEN BEGIN
    //               lrc_CC_Item.CHANGECOMPANY(lrc_Company.Name);
    //               lrc_CC_Item := vrc_Item;
    //               IF NOT lrc_CC_Item.INSERT THEN
    //                 lrc_CC_Item.Modify();
    //             END;

    //             // Artikeleinheitenstamm
    //             lrc_CC_ItemUnitofMeasure.CHANGECOMPANY(lrc_Company.Name);
    //             lrc_ItemUnitofMeasure.SETRANGE("Item No.",vrc_Item."No.");
    //             IF lrc_ItemUnitofMeasure.FIND('-') THEN BEGIN
    //               REPEAT
    //                 lrc_CC_ItemUnitofMeasure := lrc_ItemUnitofMeasure;
    //                 IF NOT lrc_CC_ItemUnitofMeasure.INSERT THEN
    //                   lrc_CC_ItemUnitofMeasure.Modify();
    //               UNTIL lrc_ItemUnitofMeasure.NEXT() = 0;
    //             END;

    //           UNTIL lrc_Company.NEXT() = 0;
    //         END;
    //     end;

    //     procedure IC_CopyUnitOfMeasure(vrc_UnitofMeasure: Record "204")
    //     var
    //         lrc_CompanyInformation: Record "79";
    //         lrc_Company: Record "2000000006";
    //         lrc_CC_UnitofMeasure: Record "204";
    //     begin
    //         // --------------------------------------------------------------------------------
    //         // Einheitensatz kopieren
    //         // --------------------------------------------------------------------------------

    //         IF vrc_UnitofMeasure.Code = '' THEN
    //           EXIT;

    //         lrc_CompanyInformation.GET();
    //         IF lrc_CompanyInformation."Company Typ" <> lrc_CompanyInformation."Company Typ"::Master THEN
    //           EXIT;

    //         lrc_Company.SETFILTER(Name,'<>%1',COMPANYNAME);
    //         IF lrc_Company.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_CompanyInformation.CHANGECOMPANY(lrc_Company.Name);
    //             lrc_CompanyInformation.GET();
    //             IF lrc_CompanyInformation."Company Typ" = lrc_CompanyInformation."Company Typ"::Slave THEN BEGIN
    //               lrc_CC_UnitofMeasure.CHANGECOMPANY(lrc_Company.Name);
    //               lrc_CC_UnitofMeasure := vrc_UnitofMeasure;
    //               IF NOT lrc_CC_UnitofMeasure.INSERT THEN
    //                 lrc_CC_UnitofMeasure.Modify();
    //             END;
    //           UNTIL lrc_Company.NEXT() = 0;
    //         END;
    //     end;

    procedure IC_CopyVariety(vrc_Variety: Record "POI Variety")
    var
        lrc_CC_Variety: Record "POI Variety";
    begin
        // --------------------------------------------------------------------------------
        // Sortensatz kopieren
        // --------------------------------------------------------------------------------

        IF vrc_Variety.Code = '' THEN
            EXIT;

        lrc_CompanyInformation.GET();
        // IF lrc_CompanyInformation."Company Typ" <> lrc_CompanyInformation."Company Typ"::Master THEN //TODO: Comapny
        //   EXIT;

        lrc_Company.SETFILTER(Name, '<>%1', COMPANYNAME());
        IF lrc_Company.FIND('-') THEN
            REPEAT
                lrc_CompanyInformation.CHANGECOMPANY(lrc_Company.Name);
                lrc_CompanyInformation.GET();
                //IF lrc_CompanyInformation."Company Typ" = lrc_CompanyInformation."Company Typ"::Slave THEN BEGIN
                lrc_CC_Variety.CHANGECOMPANY(lrc_Company.Name);
                lrc_CC_Variety := vrc_Variety;
                IF NOT lrc_CC_Variety.INSERT() THEN
                    lrc_CC_Variety.MODIFY();
            //END;
            UNTIL lrc_Company.NEXT() = 0;
    end;

    procedure IC_CopyCaliber(vrc_Caliber: Record "POI Caliber")
    var
        lrc_CC_Caliber: Record "POI Caliber";
    begin
        // --------------------------------------------------------------------------------
        // Kalibersatz kopieren
        // --------------------------------------------------------------------------------

        IF vrc_Caliber.Code = '' THEN
            EXIT;

        lrc_CompanyInformation.GET();
        // IF lrc_CompanyInformation."Company Typ" <> lrc_CompanyInformation."Company Typ"::Master THEN  //TODO: Company Master?
        //   EXIT;

        lrc_Company.SETFILTER(Name, '<>%1', COMPANYNAME());
        IF lrc_Company.FIND('-') THEN
            REPEAT
                lrc_CompanyInformation.CHANGECOMPANY(lrc_Company.Name);
                lrc_CompanyInformation.GET();
                //IF lrc_CompanyInformation."Company Typ" = lrc_CompanyInformation."Company Typ"::Slave THEN BEGIN
                lrc_CC_Caliber.CHANGECOMPANY(lrc_Company.Name);
                lrc_CC_Caliber := vrc_Caliber;
                IF NOT lrc_CC_Caliber.INSERT() THEN
                    lrc_CC_Caliber.MODIFY();
            //END;
            UNTIL lrc_Company.NEXT() = 0;
    end;

    //     procedure CheckLocCustDuty()
    //     begin
    //         // -------------------------------------------------------------------------------
    //         // Funktion zur Prüfung Location Customer Duty
    //         // -------------------------------------------------------------------------------
    //     end;

    //     procedure CalcUnitOfMeasureVariable(vco_ItemNo: Code[20];vin_QtyCollo: Decimal;vin_Qty: Decimal): Code[10]
    //     var
    //         lrc_Item: Record Item;
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_ItemUnitofMeasure: Record "5404";
    //         ldc_QtyPer: Decimal;
    //         lco_QtyPer: Code[10];
    //         AGILES_LT_TEXT001: Label 'Menge pro Einheit übersteigt die zulässige Grenze von 9999';
    //     begin
    //         // -------------------------------------------------------------------------------
    //         // Einheit aufgrund des gewogenen Gewichtes / Gesamtmenge ermitteln
    //         // -------------------------------------------------------------------------------

    //         IF (vin_QtyCollo = 0) OR (vin_Qty = 0) THEN
    //           EXIT('');

    //         lrc_Item.GET(vco_ItemNo);

    //         ldc_QtyPer := ROUND(vin_Qty / vin_QtyCollo,0.001,'<');
    //         IF ldc_QtyPer > 9999 THEN
    //           // Menge pro Einheit übersteigt die zulässige Grenze von 9999
    //           ERROR(AGILES_LT_TEXT001);

    //         lrc_UnitofMeasure.Reset();
    //         lrc_UnitofMeasure.SETRANGE("Base Unit of Measure (BU)",lrc_Item."Base Unit of Measure");
    //         lrc_UnitofMeasure.SETRANGE("Variable Unit of Measure",TRUE);
    //         lrc_UnitofMeasure.SETRANGE("Qty. (BU) per Unit of Measure",ldc_QtyPer);
    //         IF lrc_UnitofMeasure.FIND('-') THEN BEGIN

    //           // Kontrolle ob es die Artikeleinheit gibt --> Ansonsten Anlage
    //           lrc_ItemUnitofMeasure.Reset();
    //           lrc_ItemUnitofMeasure.SETRANGE("Item No.",lrc_Item."No.");
    //           lrc_ItemUnitofMeasure.SETRANGE(Code,lrc_UnitofMeasure.Code);
    //           IF NOT lrc_ItemUnitofMeasure.FIND('-') THEN BEGIN
    //             lrc_ItemUnitofMeasure.Reset();
    //             lrc_ItemUnitofMeasure.INIT();
    //             lrc_ItemUnitofMeasure."Item No." := lrc_Item."No.";
    //             lrc_ItemUnitofMeasure.Code := lrc_UnitofMeasure.Code;
    //             lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := ldc_QtyPer;
    //             lrc_ItemUnitofMeasure."Kind of Unit of Measure" := lrc_ItemUnitofMeasure."Kind of Unit of Measure"::"Collo Unit";
    //             lrc_ItemUnitofMeasure.insert();
    //           END;

    //           EXIT(lrc_UnitofMeasure.Code);

    //         END ELSE BEGIN

    //           // Führende Nullen vierstellig auffüllen
    //           IF ldc_QtyPer < 10 THEN BEGIN
    //             lco_QtyPer := '000' + FORMAT(ldc_QtyPer)
    //           END ELSE BEGIN
    //             IF ldc_QtyPer < 100 THEN BEGIN
    //               lco_QtyPer := '00' + FORMAT(ldc_QtyPer)
    //             END ELSE BEGIN
    //               IF ldc_QtyPer < 1000 THEN
    //                 lco_QtyPer := '0' + FORMAT(ldc_QtyPer)
    //               ELSE
    //                 lco_QtyPer := FORMAT(ldc_QtyPer);
    //             END;
    //           END;

    //           lrc_UnitofMeasure.Reset();
    //           lrc_UnitofMeasure.INIT();
    //           lrc_UnitofMeasure.Code := lrc_Item."Base Unit of Measure" + lco_QtyPer;
    //           lrc_UnitofMeasure.Description := FORMAT(ldc_QtyPer) + ' ' + lrc_Item."Base Unit of Measure";
    //           lrc_UnitofMeasure."Is Collo Unit of Measure" := TRUE;
    //           lrc_UnitofMeasure."Base Unit of Measure (BU)" := lrc_Item."Base Unit of Measure";
    //           lrc_UnitofMeasure."Qty. (BU) per Unit of Measure" := ldc_QtyPer;
    //           lrc_UnitofMeasure."Variable Unit of Measure" := TRUE;
    //           lrc_UnitofMeasure.insert();

    //           lrc_ItemUnitofMeasure.Reset();
    //           lrc_ItemUnitofMeasure.INIT();
    //           lrc_ItemUnitofMeasure."Item No." := lrc_Item."No.";
    //           lrc_ItemUnitofMeasure.Code := lrc_UnitofMeasure.Code;
    //           lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := ldc_QtyPer;
    //           lrc_ItemUnitofMeasure."Kind of Unit of Measure" := lrc_ItemUnitofMeasure."Kind of Unit of Measure"::"Collo Unit";
    //           lrc_ItemUnitofMeasure.insert();

    //           EXIT(lrc_UnitofMeasure.Code);

    //         END;
    //     end;

    //     procedure xxxxx()
    //     begin
    //     end;

    //     procedure ORG_ItemNoSearch(vco_ItemNo: Code[20];vco_CustumerNo: Code[20];vdt_OrderDate: Date;var rco_ItemNo: Code[20]): Boolean
    //     var
    //         lcu_GlobalVariablesMgt: Codeunit "5110358";
    //         lcu_GlobalFunctions: Codeunit "5110300";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_Item: Record Item;
    //         lfm_FVItemSearchList: Form "5110338";
    //         lco_SearchDescription: Code[40];
    //         lco_ProductGroup: Code[20];
    //         lbn_plus: Boolean;
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Suche der Artikelnr.
    //         // ------------------------------------------------------------------------------------
    //         // vco_ItemNo
    //         // vco_CustumerNo
    //         // vdt_OrderDate
    //         // rco_ItemNo
    //         // ------------------------------------------------------------------------------------

    //         /*-----

    //         // -------------------------------------------------------------------------
    //         // Suche nach Artikelnr.
    //         // -------------------------------------------------------------------------
    //         lrc_Item.Reset();
    //         IF lrc_Item.GET(vco_ItemNo) THEN BEGIN
    //           rco_ItemNo := lrc_Item."No.";
    //           EXIT(TRUE);
    //         END;

    //         lrc_FruitVisionSetup.GET();
    //         lrc_FruitVisionSetup.TESTFIELD("Item Search Form ID");

    //         // -------------------------------------------------------------------------
    //         // Suche nach 2. Artikelnr.
    //         // -------------------------------------------------------------------------
    //         IF lrc_FruitVisionSetup."Item No. 2 Activ" THEN BEGIN

    //           // Kontrolle auf führendes Plus als Kennzeichen für Artikelnummer 2 wenn es überschneidungen mit Nummern 1 gibt
    //           IF COPYSTR(vco_ItemNo,1,1) = '+' THEN BEGIN
    //             vco_ItemNo := COPYSTR(vco_ItemNo,2,20);
    //             lbn_plus := TRUE;
    //           END;

    //           IF ((STRLEN(vco_ItemNo) = lrc_FruitVisionSetup."Item No. 2 Length") AND
    //              (lcu_GlobalFunctions.IsTextNumber(vco_ItemNo))) OR
    //              (lbn_plus) THEN BEGIN
    //             lrc_Item.Reset();
    //             lrc_Item.SETCURRENTKEY("No. 2");
    //             lrc_Item.SETRANGE("No. 2",vco_ItemNo);
    //             lrc_Item.SETRANGE("Activ in Sales",TRUE);
    //             IF lrc_Item.COUNT > 1 THEN BEGIN
    //               lcu_GlobalVariablesMgt.ItemSearchSetGlobalValues(vco_CustumerNo,vdt_OrderDate,vdt_OrderDate,vdt_OrderDate,
    //                                                    '','',vco_ItemNo,'',TRUE);
    //               //lfm_FVItemSearchList.SetGlobalValues(vco_CustumerNo,vdt_OrderDate,vdt_OrderDate,vdt_OrderDate,
    //               //                                     '','',vco_ItemNo,'',TRUE);
    //               //lfm_FVItemSearchList.SetActiv(TRUE);
    //               //lfm_FVItemSearchList.SetNo2(vco_ItemNo);
    //               lfm_FVItemSearchList.SETTABLEVIEW(lrc_Item);
    //               lfm_FVItemSearchList.LOOKUPMODE := TRUE;
    //               IF lfm_FVItemSearchList.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //                 lrc_Item.Reset();
    //                 lfm_FVItemSearchList.GETRECORD(lrc_Item);
    //                 rco_ItemNo := lrc_Item."No.";
    //                 EXIT(TRUE);
    //               END ELSE BEGIN
    //                 rco_ItemNo := '';
    //                 EXIT(FALSE);
    //               END;
    //             END ELSE BEGIN
    //               IF lrc_Item.FIND('-') THEN BEGIN
    //                 rco_ItemNo := lrc_Item."No.";
    //                 EXIT(TRUE);
    //               END;
    //             END;

    //           END;
    //         END;

    //         // -------------------------------------------------------------------------
    //         // Suche nach Produktgruppe
    //         // -------------------------------------------------------------------------
    //         IF ((lrc_FruitVisionSetup."String Length Product Group" = 0) OR
    //            (STRLEN(vco_ItemNo) = lrc_FruitVisionSetup."String Length Product Group")) AND
    //            (
    //            ((lrc_FruitVisionSetup."String Character Product Group" =
    //               lrc_FruitVisionSetup."String Character Product Group"::Numeric) AND
    //              (lcu_GlobalFunctions.IsTextNumber(vco_ItemNo)))
    //            OR
    //            ((lrc_FruitVisionSetup."String Character Product Group" =
    //               lrc_FruitVisionSetup."String Character Product Group"::Alpha) AND
    //              (lcu_GlobalFunctions.IsTextText(vco_ItemNo)))
    //            OR
    //            ((lrc_FruitVisionSetup."String Character Product Group" =
    //              lrc_FruitVisionSetup."String Character Product Group"::Alphanumeric))
    //           ) THEN BEGIN

    //           lco_ProductGroup := '*' + vco_ItemNo + '*';

    //           lrc_Item.Reset();
    //         //  lrc_Item.SETCURRENTKEY("Product Group Code");
    //           lrc_Item.SETFILTER("Product Group Code",'%1',lco_ProductGroup);
    //           IF lrc_Item.FIND('-') THEN BEGIN
    //             IF lrc_Item.COUNT > 1 THEN BEGIN
    //               lcu_GlobalVariablesMgt.ItemSearchSetGlobalValues(vco_CustumerNo,vdt_OrderDate,vdt_OrderDate,vdt_OrderDate,
    //                                                    '',lco_ProductGroup,'','',TRUE);
    //               //lfm_FVItemSearchList.SetGlobalValues(vco_CustumerNo,vdt_OrderDate,vdt_OrderDate,vdt_OrderDate,
    //               //                                     '',lco_ProductGroup,'','',TRUE);
    //               //lfm_FVItemSearchList.SetActiv(TRUE);
    //               //lfm_FVItemSearchList.SetProductGroup(lco_ProductGroup);
    //               lfm_FVItemSearchList.SETTABLEVIEW(lrc_Item);
    //               lfm_FVItemSearchList.LOOKUPMODE := TRUE;
    //               IF lfm_FVItemSearchList.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //                 lrc_Item.Reset();
    //                 lfm_FVItemSearchList.GETRECORD(lrc_Item);
    //                 rco_ItemNo := lrc_Item."No.";
    //                 EXIT(TRUE);
    //               END ELSE BEGIN
    //                 rco_ItemNo := '';
    //                 EXIT(FALSE);
    //               END;
    //             END ELSE BEGIN
    //               rco_ItemNo := lrc_Item."No.";
    //               EXIT(TRUE);
    //             END;
    //           // END ELSE BEGIN
    //           //  rco_ItemNo := '';
    //           //  EXIT(FALSE);
    //           END;
    //         END;

    //         // -------------------------------------------------------------------------
    //         // Suche nach Teil der Artikelnr.
    //         // -------------------------------------------------------------------------
    //         IF (lcu_GlobalFunctions.IsTextNumber(vco_ItemNo)) THEN BEGIN
    //           lrc_Item.Reset();
    //           lrc_Item.SETCURRENTKEY("No.");

    //           lrc_Item.SETFILTER("No.",(vco_ItemNo + '*'));
    //           IF lrc_Item.FIND('-') THEN BEGIN
    //             IF lrc_Item.COUNT > 1 THEN BEGIN
    //               lcu_GlobalVariablesMgt.ItemSearchSetGlobalValues(vco_CustumerNo,vdt_OrderDate,vdt_OrderDate,vdt_OrderDate,
    //                                                    '','','',(vco_ItemNo + '*'),TRUE);
    //               //lfm_FVItemSearchList.SetGlobalValues(vco_CustumerNo,vdt_OrderDate,vdt_OrderDate,vdt_OrderDate,
    //               //                                     '','','',(vco_ItemNo + '*'),TRUE);
    //               //lfm_FVItemSearchList.SetActiv(TRUE);
    //               //lfm_FVItemSearchList.SetNo((vco_ItemNo + '*'));
    //               lfm_FVItemSearchList.SETTABLEVIEW(lrc_Item);
    //               lfm_FVItemSearchList.LOOKUPMODE := TRUE;
    //               IF lfm_FVItemSearchList.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //                 lrc_Item.Reset();
    //                 lfm_FVItemSearchList.GETRECORD(lrc_Item);
    //                 rco_ItemNo := lrc_Item."No.";
    //                 EXIT(TRUE);
    //               END ELSE BEGIN
    //                 rco_ItemNo := '';
    //                 EXIT(FALSE);
    //               END;
    //             END ELSE BEGIN
    //               rco_ItemNo := lrc_Item."No.";
    //               EXIT(TRUE);
    //             END;
    //           END;
    //         END;


    //         // -------------------------------------------------------------------------
    //         // Suche nach Suchbegriff
    //         // -------------------------------------------------------------------------
    //         lco_SearchDescription := vco_ItemNo;

    //         lrc_Item.Reset();
    //         lrc_Item.SETCURRENTKEY("Search Description");

    //         lco_SearchDescription := CreateItemSearchString(lco_SearchDescription);
    //         lrc_Item.SETFILTER("Search Description",lco_SearchDescription);
    //         IF lrc_Item.FIND('-') THEN BEGIN
    //           IF lrc_Item.COUNT > 1 THEN BEGIN
    //             lcu_GlobalVariablesMgt.ItemSearchSetGlobalValues(vco_CustumerNo,vdt_OrderDate,vdt_OrderDate,vdt_OrderDate,
    //                                                  lco_SearchDescription,'','','',TRUE);
    //             //lfm_FVItemSearchList.SetGlobalValues(vco_CustumerNo,vdt_OrderDate,vdt_OrderDate,vdt_OrderDate,
    //             //                                     lco_SearchDescription,'','','',TRUE);
    //             //lfm_FVItemSearchList.SetActiv(TRUE);
    //             //lfm_FVItemSearchList.SetSearchDescription(lco_SearchDescription);
    //             lfm_FVItemSearchList.SETTABLEVIEW(lrc_Item);
    //             lfm_FVItemSearchList.LOOKUPMODE := TRUE;
    //             IF lfm_FVItemSearchList.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //               lrc_Item.Reset();
    //               lfm_FVItemSearchList.GETRECORD(lrc_Item);
    //               rco_ItemNo := lrc_Item."No.";
    //               EXIT(TRUE);
    //             END ELSE BEGIN
    //               rco_ItemNo := '';
    //               EXIT(FALSE);
    //             END;
    //           END ELSE BEGIN
    //             rco_ItemNo := lrc_Item."No.";
    //             EXIT(TRUE);
    //           END;
    //         END ELSE BEGIN
    //           rco_ItemNo := '';
    //           EXIT(FALSE);
    //         END;
    //         --*/

    //     end;

    var

    var
        lrc_SalesPurchaser: Record "Salesperson/Purchaser";
}

