codeunit 50015 "POI BDM Base Data Mgmt"
{
    procedure ItemValidateSearch(var ItemNo: Code[20]; vbn_Search: Boolean; vop_Source: Option " ",Purchase,Sales,Transfer; vdt_OrderDate: Date; vco_CustomerNo: Code[20]; vbn_SearchInAssortment: Boolean; vco_AssortmentVersionNo: Code[20])
    var

        ADFSetup: Record "POI ADF Setup";
        // AssortmentVersionLine: Record "5110340";
        GlobalFunctionsMgt: Codeunit "POI GlobalFunctionsMgt";
        SearchName: Code[30];
        PageIDList: Integer;
        NoOfResults: Integer;
        ADF_LT_TEXT001Txt: Label 'Artikelnr. %1 nicht vorhanden!', Comment = '%1';
        ADF_LT_TEXT002Txt: Label 'Suche nach %1 ohne Ergebnis!', Comment = '%1';
        ADF_LT_TEXT003Txt: Label 'Es wurde keine Sortimentsversionsnr. übergeben!';
        ADF_LT_TEXT004Txt: Label 'Suche nach Artikelnr 2 ist fehlgeschlagen!';
        ShowAll: Boolean;
    begin
        // -----------------------------------------------------------------------------------
        // Funktion zur Suche eines Artikels
        // -----------------------------------------------------------------------------------
        // rco_ItemNo
        // vbn_Search
        // vop_Source ( ,Purchase,Sales,Transfer)
        // vdt_OrderDate
        // vco_CustomerNo
        // vbn_SearchInAssortment
        // vco_AssortmentVersionNo
        // -----------------------------------------------------------------------------------

        IF ItemNo = '' THEN
            EXIT;

        // Einrichtung lesen
        ADFSetup.GET();
        PageIDList := ADFSetup."Item Search List Page ID";

        IF vbn_SearchInAssortment = FALSE THEN BEGIN

            IF Item.GET(ItemNo) THEN
                EXIT;

            IF vbn_Search = FALSE THEN
                IF ADFSetup."Sales Beep if Item not found" = TRUE THEN
                    ERROR('')
                ELSE
                    // Artikelnr. %1 nicht vorhanden!
                    ERROR(ADF_LT_TEXT001Txt, ItemNo);


            // Suche nach Artikelnummer 2
            IF (ADFSetup."Item No. 2 Activ" = TRUE) AND
               (COPYSTR(ItemNo, 1, 1) = '+') THEN BEGIN

                ItemNo := COPYSTR(ItemNo, 2, 20);

                Item.RESET();
                Item.SETCURRENTKEY("No. 2");
                Item.SETRANGE("No. 2", ItemNo);
                Item.SETRANGE("POI Activ in Sales", TRUE);
                IF Item.FINDFIRST() THEN BEGIN
                    ItemNo := Item."No.";
                    EXIT;
                END ELSE
                    IF ADFSetup."Sales Beep if Item not found" = TRUE THEN
                        ERROR('')
                    ELSE
                        // Suche nach Artikelnr 2 ist fehlgeschlagen!
                        ERROR(ADF_LT_TEXT004Txt);
            END;

            IF COPYSTR(ItemNo, 1, 1) = '+' THEN BEGIN
                ShowAll := TRUE;
                ItemNo := COPYSTR(ItemNo, 2, 20);
            END;

            // Suche nach Teil der Artikelnummer
            IF GlobalFunctionsMgt.IsTextNumber(ItemNo) = TRUE THEN BEGIN
                SearchName := ItemNo + '*';
                Item.RESET();
                Item.FILTERGROUP(2);
                Item.SETFILTER("No.", SearchName);
                Item.FILTERGROUP(0);
                // Suche nach Suchbegriff
            END ELSE BEGIN
                SearchName := CreateSearchString(ItemNo);
                Item.RESET();
                Item.SETCURRENTKEY("Search Description");
                Item.FILTERGROUP(2);
                Item.SETFILTER("Search Description", SearchName);
                Item.FILTERGROUP(0);
            END;

            NoOfResults := Item.COUNT();

            CASE NoOfResults OF
                0:
                    IF ADFSetup."Sales Beep if Item not found" = TRUE THEN
                        ERROR('')
                    ELSE
                        // Suche nach %1 ohne Ergebnis!
                        ERROR(ADF_LT_TEXT002Txt, ItemNo);
                1:
                    BEGIN
                        Item.FINDFIRST();
                        ItemNo := Item."No.";
                        EXIT;
                    END;
                ELSE
                    IF Page.RUNMODAL(PageIDList, Item) = ACTION::LookupOK THEN BEGIN
                        ItemNo := Item."No.";
                        EXIT;
                    END ELSE
                        ERROR('');
            END;

        END;
        ///ELSE BEGIN

        // Prüfung Sortimentsversionsnummer
        IF vco_AssortmentVersionNo = '' THEN
            // Es wurde keine Sortimentsversionsnr. übergeben!
            ERROR(ADF_LT_TEXT003Txt);

        // -------------------------------------------------------------------------
        // Suche nach Artikelnr.
        // -------------------------------------------------------------------------
        // IF Item.GET(rco_ItemNo) THEN BEGIN
        //     // Kontrolle ob Artikel im Sortiment
        //     AssortmentVersionLine.Reset();
        //     AssortmentVersionLine.SETRANGE("Assortment Version No.", vco_AssortmentVersionNo);
        //     AssortmentVersionLine.SETRANGE("Item No.", rco_ItemNo);
        //     IF AssortmentVersionLine.FINDFIRST() THEN BEGIN
        //         rco_ItemNo := Item."No.";
        //         EXIT;
        //     END ELSE
        //         IF ADFSetup."Sales Beep if Item not found" = TRUE THEN
        //             ERROR('');
        // END ELSE
        //     ERROR('Artikelnr. %1 ist nicht im Sortiment %2 vorhanden!', rco_ItemNo, vco_AssortmentVersionNo);


        // -------------------------------------------------------------------------
        // Suche nach Suchbegriff
        // -------------------------------------------------------------------------
        // SearchName := CreateSearchString(rco_ItemNo);

        // AssortmentVersionLine.Reset();
        // AssortmentVersionLine.SETCURRENTKEY("Search Description");
        // AssortmentVersionLine.FILTERGROUP(2);
        // AssortmentVersionLine.SETRANGE("Assortment Version No.", vco_AssortmentVersionNo);
        // AssortmentVersionLine.FILTERGROUP(0);
        // AssortmentVersionLine.SETFILTER("Search Description", SearchName);

        // lin_NoOfResults := AssortmentVersionLine.COUNT();

        // CASE lin_NoOfResults OF
        //     0:
        //         IF ADFSetup."Sales Beep if Item not found" = TRUE THEN
        //             ERROR('')
        //         ELSE
        //             // Suche nach %1 im Sortiment %2 ohne Ergebnis!
        //             ERROR('Suche nach %1 im Sortiment %2 ohne Ergebnis!');
        //     1:
        //         BEGIN
        //             Item.FINDFIRST();
        //             rco_ItemNo := Item."No.";
        //             EXIT;
        //         END;
        //     ELSE
        //         IF Page.RUNMODAL(5110785, AssortmentVersionLine) = ACTION::LookupOK THEN BEGIN
        //             rco_ItemNo := Item."No.";
        //             EXIT;
        //         END ELSE
        //             ERROR('');
        // END;

        // END;
    end;

    procedure CreateSearchString(vco_OrgSearchString: Code[30]): Code[30]
    var
        lco_SearchString: Code[30];
        lco_StartSign: Code[10];
        lco_EndSign: Code[10];
        lco_EmptySign: Code[10];
    begin
        // --------------------------------------------------------------------------------------
        // Funktion zur Erstellung des Suchstrings
        // --------------------------------------------------------------------------------------

        // Führendes Zeichen setzen
        lco_StartSign := '@*';
        // Nachgelagertes Zeichen setzen
        lco_EndSign := '*';
        // Zwischen Leerzeichen mit * oder *&* auffüllen
        lco_EmptySign := '*&*';

        lco_SearchString := copystr(lco_StartSign + vco_OrgSearchString + lco_EndSign, 1, 30);

        IF lco_EmptySign <> '' THEN
            WHILE STRPOS(lco_SearchString, ' ') > 0 DO
                lco_SearchString := COPYSTR(lco_SearchString, 1, (STRPOS(lco_SearchString, ' ') - 1)) + lco_EmptySign + COPYSTR(lco_SearchString, (STRPOS(lco_SearchString, ' ') + 1), 30);

        EXIT(lco_SearchString);
    end;

    procedure ProductGrpValidateSearch(var rco_ProductGrpCode: Code[20]; vbn_Search: Boolean)
    var
        lco_SearchDescription: Code[30];
        lin_NoOfResults: Integer;
        lin_FormIDList: Integer;
        ADF_LT_001Txt: Label 'Produktgruppe %1 nicht vorhanden!', Comment = '%1';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung der Produktgruppe
        // -----------------------------------------------------------------------------
        lin_FormIDList := 0;
        IF rco_ProductGrpCode = '' THEN
            EXIT;

        lrc_ProductGroup.RESET();
        lrc_ProductGroup.SETRANGE(Code, rco_ProductGrpCode);
        IF lrc_ProductGroup.FINDFIRST() THEN
            EXIT;

        IF vbn_Search = FALSE THEN
            // Produktgruppe %1 nicht vorhanden!
            ERROR(ADF_LT_001Txt, rco_ProductGrpCode);

        lco_SearchDescription := CreateSearchString(rco_ProductGrpCode);
        lrc_ProductGroup.RESET();
        lrc_ProductGroup.SETFILTER("Search Description", lco_SearchDescription);
        lin_NoOfResults := lrc_ProductGroup.COUNT();

        CASE lin_NoOfResults OF
            0:
                // Produktgruppe %1 nicht vorhanden!
                ERROR(ADF_LT_001Txt, rco_ProductGrpCode);
            1:
                BEGIN
                    lrc_ProductGroup.FINDFIRST();
                    rco_ProductGrpCode := lrc_ProductGroup.Code;
                    EXIT;
                END;
            ELSE

                IF Page.RUNMODAL(lin_FormIDList, lrc_ProductGroup) = ACTION::LookupOK THEN BEGIN
                    rco_ProductGrpCode := lrc_ProductGroup.Code;
                    EXIT;
                END ELSE
                    ERROR('');
        END;
    end;

    procedure TrademarkLookup(var TrademarkCode: Code[20]; ProductGrpCode: Code[20]): Boolean
    var
        FoodSetup: Record "POI ADF Setup";
        Trademark: Record "POI Trademark";
        ProdGrpTrademark: Record "POI Product Group - Trademark";
        OK: Boolean;
    begin
        FoodSetup.GET();

        CASE FoodSetup."Item - Validate Trademark" OF
            FoodSetup."Item - Validate Trademark"::" ":
                BEGIN
                    IF TrademarkCode <> '' THEN
                        OK := Trademark.GET(TrademarkCode);
                    IF Page.RUNMODAL(0, Trademark) = ACTION::LookupOK THEN BEGIN
                        TrademarkCode := Trademark.Code;
                        EXIT(TRUE);
                    END;
                END;
            FoodSetup."Item - Validate Trademark"::"Product Group":
                BEGIN
                    IF ProductGrpCode = '' THEN
                        ERROR('');
                    ProdGrpTrademark.FILTERGROUP(2);
                    ProdGrpTrademark.SETRANGE("Product Group Code", ProductGrpCode);
                    ProdGrpTrademark.FILTERGROUP(0);
                    IF Page.RUNMODAL(0, ProdGrpTrademark) = ACTION::LookupOK THEN BEGIN
                        TrademarkCode := ProdGrpTrademark."Trademark Code";
                        EXIT(TRUE);
                    END;
                END;
        END;

        EXIT(FALSE);
    end;

    procedure AttributeTrademarkValidate(var TrademarkCode: Code[20]; ProductGrpCode: Code[20])
    var
        FoodSetup: Record "POI ADF Setup";
        Trademark: Record "POI Trademark";
        ProdGrpTrademark: Record "POI Product Group - Trademark";
        ProductGrp: Record "POI Product Group";
    begin
        IF TrademarkCode = '' THEN
            EXIT;

        FoodSetup.GET();
        CASE FoodSetup."Item - Validate Trademark" OF
            FoodSetup."Item - Validate Trademark"::" ":
                Trademark.GET(TrademarkCode);
            FoodSetup."Item - Validate Trademark"::"Product Group":
                BEGIN
                    IF ProductGrpCode = '' THEN
                        ERROR(Text000Txt, ProductGrp.TABLECAPTION());
                    IF NOT ProductGrp.GET(ProductGrpCode) THEN
                        ERROR(Text001Txt, ProductGrp.TABLECAPTION(), ProductGrpCode);
                    ProdGrpTrademark.GET(ProductGrpCode, TrademarkCode);
                END;
        END;
    end;

    procedure CaliberLookUp(var rco_CaliberNo: Code[10]; vco_ProductGroupCode: Code[20]): Boolean
    var
        lrc_ADFSetup: Record "POI ADF Setup";
        lin_FormIDList: Integer;
    begin
        // -----------------------------------------------------------------------------------
        // Funktion Lookup Kaliber
        // -----------------------------------------------------------------------------------

        lin_FormIDList := 0;

        lrc_ADFSetup.GET();
        CASE lrc_ADFSetup."Item - Validate Caliber" OF
            lrc_ADFSetup."Item - Validate Caliber"::" ":
                BEGIN
                    IF rco_CaliberNo <> '' THEN
                        IF lrc_Caliber.GET(rco_CaliberNo) THEN;
                    IF Page.RUNMODAL(lin_FormIDList, lrc_Caliber) = ACTION::LookupOK THEN BEGIN
                        rco_CaliberNo := lrc_Caliber.Code;
                        EXIT(TRUE);
                    END ELSE
                        EXIT(FALSE);
                END;

            lrc_ADFSetup."Item - Validate Caliber"::"Product Group":
                BEGIN
                    IF vco_ProductGroupCode = '' THEN
                        ERROR('');
                    lrc_ProductGroupCaliber.FILTERGROUP(2);
                    lrc_ProductGroupCaliber.SETRANGE("Product Group Code", vco_ProductGroupCode);
                    lrc_ProductGroupCaliber.FILTERGROUP(0);
                    IF Page.RUNMODAL(0, lrc_ProductGroupCaliber) = ACTION::LookupOK THEN BEGIN
                        rco_CaliberNo := lrc_ProductGroupCaliber."Caliber Code";
                        EXIT(TRUE);
                    END ELSE
                        EXIT(FALSE);
                END;
        END;
    end;

    procedure VarietyLookUp(var rco_VarietyNo: Code[10]; vco_ProductGroupCode: Code[20]): Boolean
    var
        lrc_ADFSetup: Record "POI ADF Setup";
        lin_FormIDList: Integer;
    begin
        // -----------------------------------------------------------------------------------
        // Funktion Lookup Sorte
        // -----------------------------------------------------------------------------------

        lin_FormIDList := 0;

        lrc_ADFSetup.GET();
        CASE lrc_ADFSetup."Item - Validate Variety" OF
            lrc_ADFSetup."Item - Validate Variety"::" ":
                BEGIN
                    IF rco_VarietyNo <> '' THEN
                        IF lrc_Variety.GET(rco_VarietyNo) THEN;

                    IF Page.RUNMODAL(lin_FormIDList, lrc_Variety) = ACTION::LookupOK THEN BEGIN
                        rco_VarietyNo := lrc_Variety.Code;
                        EXIT(TRUE);
                    END ELSE
                        EXIT(FALSE);
                END;

            lrc_ADFSetup."Item - Validate Variety"::"Product Group":
                BEGIN
                    IF vco_ProductGroupCode = '' THEN
                        ERROR('');

                    lrc_ProductGroupVariety.FILTERGROUP(2);
                    lrc_ProductGroupVariety.SETRANGE("Product Group Code", vco_ProductGroupCode);
                    lrc_ProductGroupVariety.FILTERGROUP(0);

                    IF Page.RUNMODAL(0, lrc_ProductGroupVariety) = ACTION::LookupOK THEN BEGIN
                        rco_VarietyNo := lrc_ProductGroupVariety."Variety Code";
                        EXIT(TRUE);
                    END ELSE
                        EXIT(FALSE);
                END;
        END;
    end;

    procedure TrademarkValidateSearch(var rco_TrademarkCode: Code[20]; vbn_Search: Boolean)
    var
        lco_SearchDescription: Code[30];
        lin_NoOfResults: Integer;
        lin_FormIDList: Integer;
        ADF_LT_TEXT001Txt: Label 'Trademark %1 not found!', Comment = '%1';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung der Marke
        // -----------------------------------------------------------------------------
        lin_FormIDList := 0;
        IF rco_TrademarkCode = '' THEN
            EXIT;

        IF lrc_Trademark.GET(rco_TrademarkCode) THEN
            EXIT;

        IF vbn_Search = FALSE THEN
            // Marke %1 nicht vorhanden!
            ERROR(ADF_LT_TEXT001Txt, rco_TrademarkCode);

        lco_SearchDescription := CreateSearchString(rco_TrademarkCode);
        lrc_Trademark.RESET();
        lrc_Trademark.SETFILTER("Search Description", lco_SearchDescription);
        lin_NoOfResults := lrc_Trademark.COUNT();
        CASE lin_NoOfResults OF
            0:
                // Marke %1 nicht vorhanden!
                ERROR(ADF_LT_TEXT001Txt, rco_TrademarkCode);
            1:
                BEGIN
                    lrc_Trademark.FINDFIRST();
                    rco_TrademarkCode := lrc_Trademark.Code;
                    EXIT;
                END;
            ELSE
                IF Page.RUNMODAL(lin_FormIDList, lrc_Trademark) = ACTION::LookupOK THEN BEGIN
                    rco_TrademarkCode := lrc_Trademark.Code;
                    EXIT;
                END ELSE
                    ERROR('');
        END;
    end;

    procedure CaliberValidateSearch(var rco_CaliberCode: Code[10]; vco_ProductGroupCode: Code[20]; vbn_Search: Boolean)
    var
        lrc_ADFSetup: Record "POI ADF Setup";
        lco_SearchDescription: Code[30];
        lin_NoOfResults: Integer;
        lin_FormIDList: Integer;
        ADF_LT_TEXT001Txt: Label 'Kaliber %1 nicht vorhanden!', Comment = '%1';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung der Kaliber
        // -----------------------------------------------------------------------------
        lin_FormIDList := 0;
        IF rco_CaliberCode = '' THEN
            EXIT;

        lrc_ADFSetup.GET();
        CASE lrc_ADFSetup."Item - Validate Caliber" OF
            lrc_ADFSetup."Item - Validate Caliber"::" ":
                BEGIN
                    IF lrc_Caliber.GET(rco_CaliberCode) THEN
                        EXIT;

                    IF vbn_Search = FALSE THEN
                        // Kaliber %1 nicht vorhanden!
                        ERROR(ADF_LT_TEXT001Txt, rco_CaliberCode);

                    lco_SearchDescription := CreateSearchString(rco_CaliberCode);
                    lrc_Caliber.RESET();
                    lrc_Caliber.SETFILTER(Code, lco_SearchDescription);
                    lin_NoOfResults := lrc_Caliber.COUNT();
                    CASE lin_NoOfResults OF
                        0:
                            // Kaliber %1 nicht vorhanden!
                            ERROR(ADF_LT_TEXT001Txt, rco_CaliberCode);
                        1:
                            BEGIN
                                lrc_Caliber.FINDFIRST();
                                rco_CaliberCode := lrc_Caliber.Code;
                                EXIT;
                            END;
                        ELSE
                            IF Page.RUNMODAL(lin_FormIDList, lrc_Caliber) = ACTION::LookupOK THEN BEGIN
                                rco_CaliberCode := lrc_Caliber.Code;
                                EXIT;
                            END ELSE
                                ERROR('');
                    END;
                END;

            lrc_ADFSetup."Item - Validate Caliber"::"Product Group":
                BEGIN

                    IF vco_ProductGroupCode = '' THEN
                        ERROR('');

                    lrc_ProductGroupCaliber.RESET();
                    lrc_ProductGroupCaliber.SETRANGE("Product Group Code", vco_ProductGroupCode);
                    lrc_ProductGroupCaliber.SETRANGE("Caliber Code", rco_CaliberCode);
                    IF lrc_ProductGroupCaliber.FINDFIRST() THEN
                        EXIT;

                    IF vbn_Search = FALSE THEN
                        // Kaliber %1 nicht vorhanden!
                        ERROR(ADF_LT_TEXT001Txt, rco_CaliberCode);

                    lco_SearchDescription := CreateSearchString(rco_CaliberCode);
                    lrc_ProductGroupCaliber.RESET();
                    lrc_ProductGroupCaliber.SETRANGE("Product Group Code", vco_ProductGroupCode);
                    lrc_ProductGroupCaliber.SETFILTER("Caliber Description", lco_SearchDescription);
                    lin_NoOfResults := lrc_ProductGroupCaliber.COUNT();
                    CASE lin_NoOfResults OF
                        0:
                            // Kaliber %1 nicht vorhanden!
                            ERROR(ADF_LT_TEXT001Txt, rco_CaliberCode);
                        1:
                            BEGIN
                                lrc_ProductGroupCaliber.FINDFIRST();
                                rco_CaliberCode := lrc_ProductGroupCaliber."Caliber Code";
                                EXIT;
                            END;
                        ELSE
                            IF Page.RUNMODAL(0, lrc_ProductGroupCaliber) = ACTION::LookupOK THEN BEGIN
                                rco_CaliberCode := lrc_ProductGroupCaliber."Caliber Code";
                                EXIT;
                            END ELSE
                                ERROR('');
                    END;
                END;

        END;
    end;

    procedure CountryValidateSearch(var rco_CountryCode: Code[10]; vco_ProductGroupCode: Code[10]; vbn_Search: Boolean)
    var
        lrc_ADFSetup: Record "POI ADF Setup";
        ADF_LT_TEXT001Txt: Label 'Country/Region %1 not found!', Comment = '%1';
        lco_SearchDescription: Code[30];
        lin_NoOfResults: Integer;
        lin_FormIDList: Integer;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung der Sorte
        // -----------------------------------------------------------------------------

        lin_FormIDList := 0;

        IF rco_CountryCode = '' THEN
            EXIT;

        lrc_ADFSetup.GET();
        CASE lrc_ADFSetup."Item - Validate Country" OF
            lrc_ADFSetup."Item - Validate Country"::" ":
                BEGIN
                    IF lrc_CountryRegion.GET(rco_CountryCode) THEN
                        EXIT;
                    IF vbn_Search = FALSE THEN
                        // Land/Region %1 nicht vorhanden!
                        ERROR(ADF_LT_TEXT001Txt, rco_CountryCode);

                    lco_SearchDescription := CreateSearchString(rco_CountryCode);
                    lrc_CountryRegion.SETFILTER(Name, lco_SearchDescription);
                    lin_NoOfResults := lrc_CountryRegion.COUNT();
                    CASE lin_NoOfResults OF
                        0:
                            // Land/Region %1 nicht vorhanden!
                            ERROR(ADF_LT_TEXT001Txt, rco_CountryCode);
                        1:
                            BEGIN
                                lrc_CountryRegion.FINDFIRST();
                                rco_CountryCode := lrc_CountryRegion.Code;
                                EXIT;
                            END;
                        ELSE

                            IF Page.RUNMODAL(lin_FormIDList, lrc_CountryRegion) = ACTION::LookupOK THEN BEGIN
                                rco_CountryCode := lrc_CountryRegion.Code;
                                EXIT;
                            END ELSE
                                ERROR('');
                    END;

                END;

            lrc_ADFSetup."Item - Validate Country"::"Product Group":
                BEGIN
                    IF vco_ProductGroupCode = '' THEN
                        ERROR(ADF_LT_TEXT001Txt);

                    lrc_ProductGroupCountryRegion.RESET();
                    lrc_ProductGroupCountryRegion.SETRANGE("Product Group Code", vco_ProductGroupCode);
                    lrc_ProductGroupCountryRegion.SETRANGE("Country/Region Code", rco_CountryCode);
                    IF lrc_ProductGroupCountryRegion.FINDFIRST() THEN
                        EXIT;

                    IF vbn_Search = FALSE THEN
                        // Land/Region %1 nicht vorhanden!
                        ERROR(ADF_LT_TEXT001Txt, rco_CountryCode);

                    lco_SearchDescription := CreateSearchString(rco_CountryCode);
                    lrc_ProductGroupCountryRegion.RESET();
                    lrc_ProductGroupCountryRegion.FILTERGROUP(2);
                    lrc_ProductGroupCountryRegion.SETRANGE("Product Group Code", vco_ProductGroupCode);
                    lrc_ProductGroupCountryRegion.SETFILTER("Country/Region Name", lco_SearchDescription);
                    lrc_ProductGroupCountryRegion.FILTERGROUP(0);
                    lin_NoOfResults := lrc_ProductGroupCountryRegion.COUNT();
                    CASE lin_NoOfResults OF
                        0:
                            // Land/Region %1 nicht vorhanden!
                            ERROR(ADF_LT_TEXT001Txt, rco_CountryCode);
                        1:
                            BEGIN
                                lrc_ProductGroupCountryRegion.FINDFIRST();
                                rco_CountryCode := lrc_ProductGroupCountryRegion."Country/Region Code";
                                EXIT;
                            END;
                        ELSE
                            IF Page.RUNMODAL(0, lrc_ProductGroupCountryRegion) = ACTION::LookupOK THEN BEGIN
                                rco_CountryCode := lrc_ProductGroupCountryRegion."Country/Region Code";
                                EXIT;
                            END ELSE
                                ERROR('');
                    END;
                END;
        END;
    end;

    procedure VarietyValidateSearch(var rco_VarietyCode: Code[10]; vco_ProductGroupCode: Code[10]; vbn_Search: Boolean)
    var
        lrc_ADFSetup: Record "POI ADF Setup";
        ADF_LT_TEXT001Txt: Label 'Sorte %1 nicht vorhanden!', Comment = '%1';
        lco_SearchDescription: Code[30];
        lin_NoOfResults: Integer;
        lin_FormIDList: Integer;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung der Sorte
        // -----------------------------------------------------------------------------

        lin_FormIDList := 0;

        IF rco_VarietyCode = '' THEN
            EXIT;

        lrc_ADFSetup.GET();
        CASE lrc_ADFSetup."Item - Validate Variety" OF
            lrc_ADFSetup."Item - Validate Variety"::" ":
                BEGIN
                    IF lrc_Variety.GET(rco_VarietyCode) THEN
                        EXIT;
                    IF vbn_Search = FALSE THEN
                        // Sorte %1 nicht vorhanden!
                        ERROR(ADF_LT_TEXT001Txt, rco_VarietyCode);

                    lco_SearchDescription := CreateSearchString(rco_VarietyCode);
                    lrc_Variety.SETFILTER("Search Description", lco_SearchDescription);
                    lin_NoOfResults := lrc_Variety.COUNT();

                    CASE lin_NoOfResults OF
                        0:
                            // Sorte %1 nicht vorhanden!
                            ERROR(ADF_LT_TEXT001Txt, rco_VarietyCode);
                        1:
                            BEGIN
                                lrc_Variety.FINDFIRST();
                                rco_VarietyCode := lrc_Variety.Code;
                                EXIT;
                            END;
                        ELSE
                            IF Page.RUNMODAL(lin_FormIDList, lrc_Variety) = ACTION::LookupOK THEN BEGIN
                                rco_VarietyCode := lrc_Variety.Code;
                                EXIT;
                            END ELSE
                                ERROR('');
                    END;

                END;

            lrc_ADFSetup."Item - Validate Variety"::"Product Group":
                BEGIN
                    IF vco_ProductGroupCode = '' THEN
                        ERROR(ADF_LT_TEXT001Txt);

                    lrc_ProductGroupVariety.RESET();
                    lrc_ProductGroupVariety.SETRANGE("Product Group Code", vco_ProductGroupCode);
                    lrc_ProductGroupVariety.SETRANGE("Variety Code", rco_VarietyCode);
                    IF lrc_ProductGroupVariety.FINDFIRST() THEN
                        EXIT;

                    IF vbn_Search = FALSE THEN
                        // Sorte %1 nicht vorhanden!
                        ERROR(ADF_LT_TEXT001Txt, rco_VarietyCode);

                    lco_SearchDescription := CreateSearchString(rco_VarietyCode);
                    lrc_ProductGroupVariety.RESET();
                    lrc_ProductGroupVariety.FILTERGROUP(2);
                    lrc_ProductGroupVariety.SETRANGE("Product Group Code", vco_ProductGroupCode);
                    lrc_ProductGroupVariety.SETFILTER("Variety Search Description", lco_SearchDescription);
                    lrc_ProductGroupVariety.FILTERGROUP(0);
                    lin_NoOfResults := lrc_ProductGroupVariety.COUNT();
                    CASE lin_NoOfResults OF
                        0:
                            // Sorte %1 nicht vorhanden!
                            ERROR(ADF_LT_TEXT001Txt, rco_VarietyCode);
                        1:
                            BEGIN
                                lrc_ProductGroupVariety.FINDFIRST();
                                rco_VarietyCode := lrc_ProductGroupVariety."Variety Code";
                                EXIT;
                            END;
                        ELSE
                            IF Page.RUNMODAL(0, lrc_ProductGroupVariety) = ACTION::LookupOK THEN BEGIN
                                rco_VarietyCode := lrc_ProductGroupVariety."Variety Code";
                                EXIT;
                            END ELSE
                                ERROR('');
                    END;
                END;
        END;
    end;

    procedure GlobalValidateSearch(TableID: Integer; vin_FieldNo: Integer; var rco_Code: Code[20]; vbn_Search: Boolean)
    var
        lrc_Field: Record Field;
        ADF_LT_001Txt: Label 'Keine Tabellenrelation für Tabelle %1 und Feld %2 definiert!', Comment = '%1 %2';
    begin
        // -----------------------------------------------------------------------------------
        // Funktion zur Suche Global
        // -----------------------------------------------------------------------------------
        // vtx_TableName
        // vin_FieldNo
        // rco_Code
        // vbn_Search
        // -----------------------------------------------------------------------------------

        lrc_Field.Get(TableID, vin_FieldNo);
        // lrc_Field.SETRANGE(TableNo, TableID);
        // lrc_Field.SETRANGE("No.", vin_FieldNo);
        // lrc_Field.FINDFIRST();

        IF lrc_Field.RelationTableNo = 0 THEN
            // Keine Tabellenrelation für Tabelle %1 und Feld %2 definiert!
            ERROR(ADF_LT_001Txt, TableID, vin_FieldNo);

        CASE lrc_Field.RelationTableNo OF
            18:
                CustValidateSearch(rco_Code, vbn_Search);
            23:
                VendValidateSearch(rco_Code, vbn_Search);
            5723:
                ProductGrpValidateSearch(rco_Code, vbn_Search);
            5110325:
                VoyageValidateSearch(rco_Code, vbn_Search);
        END;
    end;

    procedure CustValidateSearch(var rco_CustomerNo: Code[20]; vbn_Search: Boolean)
    var
        lrc_ADFSetup: Record "POI ADF Setup";
        lco_SearchName: Code[30];
        lin_FormIDList: Integer;
        lin_NoOfResults: Integer;
        ADF_L_001Txt: Label 'Debitorennr. %1 nicht vorhanden!', Comment = '%1';
        ADF_L_002Txt: Label 'Suche nach %1 ohne Ergebnis!', Comment = '%1';
    begin
        // -----------------------------------------------------------------------------------
        // Funktion zur Suche eines Debitoren
        // -----------------------------------------------------------------------------------

        lrc_ADFSetup.GET();
        lin_FormIDList := lrc_ADFSetup."Customer Search Page ID";

        IF rco_CustomerNo = '' THEN
            EXIT;
        IF lrc_Customer.GET(rco_CustomerNo) THEN
            EXIT;

        // Suche nach Nummer 2 wenn erstes Zeichen ein Plus
        IF COPYSTR(rco_CustomerNo, 1, 1) = '+' THEN BEGIN
            rco_CustomerNo := COPYSTR(rco_CustomerNo, 2, 20);
            lrc_Customer.RESET();
            lrc_Customer.SETRANGE("POI No. 2", rco_CustomerNo);
            IF lrc_Customer.FINDFIRST() THEN BEGIN
                rco_CustomerNo := lrc_Customer."No.";
                EXIT;
            END ELSE
                ERROR('');
        END;

        IF vbn_Search = FALSE THEN
            // Debitorennr. %1 nicht vorhanden!
            ERROR(ADF_L_001Txt, rco_CustomerNo);

        lco_SearchName := CreateSearchString(rco_CustomerNo);
        lrc_Customer.RESET();
        lrc_Customer.FILTERGROUP(2);
        lrc_Customer.SETFILTER("Search Name", lco_SearchName);
        lrc_Customer.FILTERGROUP(0);
        lin_NoOfResults := lrc_Customer.COUNT();

        CASE lin_NoOfResults OF
            0:
                // Suche nach %1 ohne Ergebnis!
                ERROR(ADF_L_002Txt, rco_CustomerNo);
            1:
                BEGIN
                    lrc_Customer.FINDFIRST();
                    rco_CustomerNo := lrc_Customer."No.";
                    EXIT;
                END;
            ELSE
                IF Page.RUNMODAL(lin_FormIDList, lrc_Customer) = ACTION::LookupOK THEN BEGIN
                    rco_CustomerNo := lrc_Customer."No.";
                    EXIT;
                END ELSE
                    ERROR('');
        END;
    end;

    procedure VendValidateSearch(var rco_VendorNo: Code[20]; vbn_Search: Boolean)
    var
        lrc_ADFSetup: Record "POI ADF Setup";
        lco_SearchName: Code[30];
        lin_FormIDList: Integer;
        lin_NoOfResults: Integer;
        ADF_L_001Txt: Label 'Kreditorennr. %1 nicht vorhanden!', Comment = '%1';
        ADF_L_002Txt: Label 'Suche nach %1 ohne Ergebnis!', Comment = '%1';
    begin
        // -----------------------------------------------------------------------------------
        // Funktion zur Suche eines Kreditoren
        // -----------------------------------------------------------------------------------

        lrc_ADFSetup.GET();
        lin_FormIDList := lrc_ADFSetup."Vendor Search List Page ID";

        IF rco_VendorNo = '' THEN
            EXIT;
        IF lrc_Vendor.GET(rco_VendorNo) THEN
            EXIT;

        // Suche nach Nummer 2 wenn erstes Zeichen ein Plus
        IF COPYSTR(rco_VendorNo, 1, 1) = '+' THEN BEGIN
            rco_VendorNo := COPYSTR(rco_VendorNo, 2, 20);
            lrc_Vendor.RESET();
            lrc_Vendor.SETRANGE("No. 2", rco_VendorNo);
            IF lrc_Vendor.FINDFIRST() THEN BEGIN
                rco_VendorNo := lrc_Vendor."No.";
                EXIT;
            END ELSE
                ERROR('');
        END;

        IF vbn_Search = FALSE THEN
            // Kreditorennr. %1 nicht vorhanden!
            ERROR(ADF_L_001Txt, rco_VendorNo);

        lco_SearchName := CreateSearchString(rco_VendorNo);
        lrc_Vendor.RESET();
        lrc_Vendor.FILTERGROUP(2);
        lrc_Vendor.SETFILTER("Search Name", lco_SearchName);
        lrc_Vendor.FILTERGROUP(0);
        lin_NoOfResults := lrc_Vendor.COUNT();

        CASE lin_NoOfResults OF
            0:
                // Suche nach %1 ohne Ergebnis!
                ERROR(ADF_L_002Txt, rco_VendorNo);
            1:
                BEGIN
                    lrc_Vendor.FINDFIRST();
                    rco_VendorNo := lrc_Vendor."No.";
                    EXIT;
                END;
            ELSE
                IF Page.RUNMODAL(lin_FormIDList, lrc_Vendor) = ACTION::LookupOK THEN BEGIN
                    rco_VendorNo := lrc_Vendor."No.";
                    EXIT;
                END ELSE
                    ERROR('');
        END;
    end;

    procedure VoyageValidateSearch(var rco_VoyageCode: Code[20]; vbn_Search: Boolean)
    var
        lco_SearchDescription: Code[30];
        lin_NoOfResults: Integer;
        lin_FormIDList: Integer;
        ADF_LT_001Txt: Label 'Reise %1 nicht vorhanden!', Comment = '%1';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung der Reisenummer
        // -----------------------------------------------------------------------------

        lin_FormIDList := 50011;

        IF rco_VoyageCode = '' THEN
            EXIT;
        IF lrc_Voyage.GET(rco_VoyageCode) THEN
            EXIT;
        IF vbn_Search = FALSE THEN
            // Reise %1 nicht vorhanden!
            ERROR(ADF_LT_001Txt, rco_VoyageCode);

        lco_SearchDescription := CreateSearchString(rco_VoyageCode);
        lrc_Voyage.SETFILTER("Search Description", lco_SearchDescription);
        lin_NoOfResults := lrc_Voyage.COUNT();

        CASE lin_NoOfResults OF
            0:
                // Reise %1 nicht vorhanden!
                ERROR(ADF_LT_001Txt, rco_VoyageCode);
            1:
                BEGIN
                    lrc_Voyage.FINDFIRST();
                    rco_VoyageCode := lrc_Voyage."No.";
                    EXIT;
                END;
            ELSE

                IF Page.RUNMODAL(lin_FormIDList, lrc_Voyage) = ACTION::LookupOK THEN BEGIN
                    rco_VoyageCode := lrc_Voyage."No.";
                    EXIT;
                END ELSE
                    ERROR('');
        END;
    end;

    procedure UOMValidateSearch(var rco_UnitOfMeasureCode: Code[10]; vco_ItemNo: Code[20]; vbn_Search: Boolean; vbn_InsertItemUnitRelation: Boolean)
    var
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_Item: Record Item;
        lco_SearchDescription: Code[30];
        lin_NoOfResults: Integer;
        lin_FormIDList: Integer;
        ADF_LT_001Txt: Label 'Einheit %1 nicht vorhanden!', Comment = '%1';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung der Einheit
        // -----------------------------------------------------------------------------

        IF rco_UnitOfMeasureCode = '' THEN
            EXIT;

        IF lrc_UnitofMeasure.GET(rco_UnitOfMeasureCode) THEN BEGIN
            IF lrc_Item.GET(vco_ItemNo) THEN
                IF lrc_UnitofMeasure."POI Base Unit of Measure (BU)" <> '' THEN
                    IF lrc_UnitofMeasure."POI Base Unit of Measure (BU)" <> lrc_Item."Base Unit of Measure" THEN
                        // Basiseinheit Artikel %1 ist abweichend von Einheit %2!
                        ERROR('Basiseinheit Artikel %1 ist abweichend von Einheit %2!',
                      lrc_Item."Base Unit of Measure",
                      lrc_UnitofMeasure."POI Base Unit of Measure (BU)");
        END ELSE BEGIN

            IF vbn_Search = FALSE THEN
                // Einheit %1 nicht vorhanden!
                ERROR(ADF_LT_001Txt, rco_UnitOfMeasureCode);

            lin_FormIDList := 0;
            lco_SearchDescription := CreateSearchString(rco_UnitOfMeasureCode);
            lrc_UnitofMeasure.RESET();
            lrc_UnitofMeasure.FILTERGROUP(2);
            lrc_UnitofMeasure.SETFILTER("POI Search Description", lco_SearchDescription);
            //xxlrc_UnitofMeasure.SETRANGE("Base Unit of Measure (BU)",lrc_Item."Base Unit of Measure");
            lrc_UnitofMeasure.FILTERGROUP(0);
            lin_NoOfResults := lrc_UnitofMeasure.COUNT();
            CASE lin_NoOfResults OF
                0:
                    // Einheit %1 nicht vorhanden!
                    ERROR(ADF_LT_001Txt, rco_UnitOfMeasureCode);
                1:
                    BEGIN
                        lrc_UnitofMeasure.FINDFIRST();
                        rco_UnitOfMeasureCode := lrc_UnitofMeasure.Code;
                    END;
                ELSE
                    IF Page.RUNMODAL(lin_FormIDList, lrc_UnitofMeasure) = ACTION::LookupOK THEN
                        rco_UnitOfMeasureCode := lrc_UnitofMeasure.Code
                    ELSE
                        ERROR('');
            END;
        END;


        // Prüfung ob Artikeleinheit existiert
        IF (vco_ItemNo <> '') AND
           (rco_UnitOfMeasureCode <> '') AND
           (vbn_InsertItemUnitRelation = TRUE) THEN BEGIN

            lrc_ItemUnitofMeasure.RESET();
            lrc_ItemUnitofMeasure.SETRANGE("Item No.", lrc_Item."No.");
            lrc_ItemUnitofMeasure.SETRANGE(Code, lrc_UnitofMeasure.Code);
            IF lrc_ItemUnitofMeasure.ISEMPTY() THEN BEGIN
                lrc_UnitofMeasure.TESTFIELD("POI Qty. (BU) per Unit of Meas");
                // Artikeleinheit anlegen
                lrc_ItemUnitofMeasure.RESET();
                lrc_ItemUnitofMeasure.INIT();
                lrc_ItemUnitofMeasure."Item No." := lrc_Item."No.";
                lrc_ItemUnitofMeasure.Code := lrc_UnitofMeasure.Code;
                lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas";
                lrc_ItemUnitofMeasure."POI Kind of Unit of Measure" := lrc_UnitofMeasure."POI Kind of Unit of Measure";
                lrc_ItemUnitofMeasure."POI Gross Weight" := lrc_UnitofMeasure."POI Gross Weight";
                lrc_ItemUnitofMeasure."POI Net Weight" := lrc_UnitofMeasure."POI Net Weight";
                lrc_ItemUnitofMeasure."POI Weight of Packaging" := lrc_UnitofMeasure."POI Weight of Packaging";
                lrc_ItemUnitofMeasure.INSERT();

                // Eventuelle Verpackungseinheit anlegen
                IF lrc_UnitofMeasure."POI Packing Unit of Meas (PU)" <> '' THEN BEGIN
                    lrc_ItemUnitofMeasure.RESET();
                    lrc_ItemUnitofMeasure.SETRANGE("Item No.", lrc_Item."No.");
                    lrc_ItemUnitofMeasure.SETRANGE(Code, lrc_UnitofMeasure."POI Packing Unit of Meas (PU)");
                    IF lrc_ItemUnitofMeasure.ISEMPTY() THEN BEGIN

                        lrc_UnitofMeasure.TESTFIELD("POI Qty. (BU) per Packing Unit");

                        // Verpackungseinheit anlegen
                        lrc_ItemUnitofMeasure.RESET();
                        lrc_ItemUnitofMeasure.INIT();
                        lrc_ItemUnitofMeasure."Item No." := lrc_Item."No.";
                        lrc_ItemUnitofMeasure.Code := lrc_UnitofMeasure."POI Packing Unit of Meas (PU)";
                        lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := lrc_UnitofMeasure."POI Qty. (BU) per Packing Unit";
                        lrc_ItemUnitofMeasure."POI Kind of Unit of Measure" := lrc_ItemUnitofMeasure."POI Kind of Unit of Measure"::"Packing Unit";
                        lrc_ItemUnitofMeasure."POI Gross Weight" := lrc_UnitofMeasure."POI Gross Weight" /
                                                                lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas" *
                                                                lrc_UnitofMeasure."POI Qty. (BU) per Packing Unit";
                        lrc_ItemUnitofMeasure."POI Net Weight" := lrc_UnitofMeasure."POI Net Weight" /
                                                                lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas" *
                                                                lrc_UnitofMeasure."POI Qty. (BU) per Packing Unit";
                        lrc_ItemUnitofMeasure."POI Weight of Packaging" := lrc_ItemUnitofMeasure."POI Gross Weight" -
                                                                       lrc_ItemUnitofMeasure."POI Net Weight";
                        lrc_ItemUnitofMeasure.INSERT();
                    END;
                END;
            END;

        END;
    end;

    procedure LocationValidateSearch(var rco_LocationCode: Code[10]; vbn_Search: Boolean)
    var

        lco_SearchDescription: Code[30];
        lin_NoOfResults: Integer;
        lin_FormIDList: Integer;
        POI_LT_TEXT001Txt: Label 'Lagerort %1 nicht vorhanden!', Comment = '%1';
        POI_LT_TEXT002Txt: Label 'Lagerort %1 gesperrt!', Comment = '%1';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung des Lagerortes
        // -----------------------------------------------------------------------------
        lin_FormIDList := 0;
        IF rco_LocationCode = '' THEN
            EXIT;

        IF lrc_Location.GET(rco_LocationCode) THEN BEGIN
            IF lrc_Location."POI Blocked" = lrc_Location."POI Blocked"::Blocked THEN
                // Lagerort %1 gesperr!
                ERROR(POI_LT_TEXT002Txt, rco_LocationCode);
            EXIT;
        END;

        IF vbn_Search = FALSE THEN
            // Lagerort %1 nicht vorhanden!
            ERROR(POI_LT_TEXT001Txt, rco_LocationCode);

        lco_SearchDescription := CreateSearchString(rco_LocationCode);
        lrc_Location.SETFILTER("POI Search Name", lco_SearchDescription);
        lrc_Location.SETRANGE("POI Blocked", lrc_Location."POI Blocked"::" ");
        lrc_Location.SETRANGE("Use As In-Transit", FALSE);
        lin_NoOfResults := lrc_Location.COUNT();

        CASE lin_NoOfResults OF
            0:
                // Lagerort %1 nicht vorhanden!
                ERROR(POI_LT_TEXT001Txt, rco_LocationCode);
            1:
                BEGIN
                    lrc_Location.FINDFIRST();
                    rco_LocationCode := lrc_Location.Code;
                    EXIT;
                END;
            ELSE
                IF Page.RUNMODAL(lin_FormIDList, lrc_Location) = ACTION::LookupOK THEN BEGIN
                    rco_LocationCode := lrc_Location.Code;
                    EXIT;
                END ELSE
                    ERROR('');
        END;
    end;

    procedure UOMPurchLineValidateSearch(vrc_PurchaseLine: Record "Purchase Line"; vbn_Search: Boolean; var rco_UnitOfMeasureCode: Code[10])
    var
        lrc_ADFSetup: Record "POI ADF Setup";
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_Item: Record Item;
        lco_SearchDescription: Code[30];
        lin_NoOfResults: Integer;
        lin_FormIDList: Integer;
        ADF_LT_TEXT002Txt: Label 'Basiseinheit Artikel %1 ist abweichend von Einheit %2!', Comment = '%1 %2';
        ADF_LT_TEXT001Txt: Label 'Einheit %1 nicht vorhanden!', Comment = '%1';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung der Einheit in Einkaufszeile
        // -----------------------------------------------------------------------------

        CASE vrc_PurchaseLine.Type OF
            vrc_PurchaseLine.Type::Item:
                BEGIN

                    IF rco_UnitOfMeasureCode = '' THEN
                        EXIT;
                    lrc_Item.GET(vrc_PurchaseLine."No.");
                    lrc_ADFSetup.GET();
                    CASE lrc_ADFSetup."Purch. Validate Unit" OF
                        lrc_ADFSetup."Purch. Validate Unit"::"Item Unit of Measure":
                            lrc_ItemUnitofMeasure.GET(vrc_PurchaseLine."No.", rco_UnitOfMeasureCode);
                        lrc_ADFSetup."Purch. Validate Unit"::"Product Group":
                            BEGIN
                                IF vrc_PurchaseLine."POI Product Group Code" = '' THEN
                                    ERROR('');
                                lrc_ProductGroupUnit.RESET();
                                lrc_ProductGroupUnit.SETRANGE("Product Group Code", vrc_PurchaseLine."POI Product Group Code");
                                lrc_ProductGroupUnit.SETRANGE("Unit of Measure Code", rco_UnitOfMeasureCode);
                                IF lrc_ProductGroupUnit.FINDFIRST() THEN BEGIN
                                    lrc_UnitofMeasure.GET(rco_UnitOfMeasureCode);
                                    IF lrc_UnitofMeasure."POI Base Unit of Measure (BU)" <> lrc_Item."Base Unit of Measure" THEN
                                        // Basiseinheit Artikel %1 ist abweichend von Einheit %2!
                                        ERROR(ADF_LT_TEXT002Txt,
                      lrc_Item."Base Unit of Measure",
                      lrc_UnitofMeasure."POI Base Unit of Measure (BU)");
                                END ELSE BEGIN
                                    IF vbn_Search = FALSE THEN
                                        // Einheit %1 nicht vorhanden!
                                        ERROR(ADF_LT_TEXT001Txt, rco_UnitOfMeasureCode);
                                    lco_SearchDescription := CreateSearchString(rco_UnitOfMeasureCode);
                                    lrc_ProductGroupUnit.RESET();
                                    lrc_ProductGroupUnit.FILTERGROUP(2);
                                    lrc_ProductGroupUnit.SETRANGE("Product Group Code", vrc_PurchaseLine."POI Product Group Code");
                                    lrc_ProductGroupUnit.SETFILTER("Unit of Measure Description", lco_SearchDescription);
                                    lrc_ProductGroupUnit.FILTERGROUP(0);
                                    lin_NoOfResults := lrc_ProductGroupUnit.COUNT();
                                    CASE lin_NoOfResults OF
                                        0:
                                            // Einheit %1 nicht vorhanden!
                                            ERROR(ADF_LT_TEXT001Txt, rco_UnitOfMeasureCode);
                                        1:
                                            BEGIN
                                                lrc_ProductGroupUnit.FINDFIRST();
                                                rco_UnitOfMeasureCode := lrc_ProductGroupUnit."Unit of Measure Code";
                                            END;
                                        ELSE
                                            IF Page.RUNMODAL(0, lrc_ProductGroupUnit) = ACTION::LookupOK THEN
                                                rco_UnitOfMeasureCode := lrc_ProductGroupUnit."Unit of Measure Code"
                                            ELSE
                                                ERROR('');
                                    END;
                                END;
                            END;
                        lrc_ADFSetup."Purch. Validate Unit"::"Unit of Measure":
                            IF lrc_UnitofMeasure.GET(rco_UnitOfMeasureCode) THEN BEGIN
                                IF lrc_UnitofMeasure."POI Base Unit of Measure (BU)" <> lrc_Item."Base Unit of Measure" THEN
                                    // Basiseinheit Artikel %1 ist abweichend von Einheit %2!
                                    ERROR(ADF_LT_TEXT002Txt, lrc_Item."Base Unit of Measure", lrc_UnitofMeasure."POI Base Unit of Measure (BU)");
                            END ELSE BEGIN
                                IF vbn_Search = FALSE THEN
                                    // Einheit %1 nicht vorhanden!
                                    ERROR(ADF_LT_TEXT001Txt, rco_UnitOfMeasureCode);

                                lin_FormIDList := 0;
                                lco_SearchDescription := CreateSearchString(rco_UnitOfMeasureCode);
                                lrc_UnitofMeasure.RESET();
                                lrc_UnitofMeasure.FILTERGROUP(2);
                                lrc_UnitofMeasure.SETFILTER("POI Search Description", lco_SearchDescription);
                                lrc_UnitofMeasure.SETRANGE("POI Base Unit of Measure (BU)", lrc_Item."Base Unit of Measure");
                                lrc_UnitofMeasure.FILTERGROUP(0);
                                lin_NoOfResults := lrc_UnitofMeasure.COUNT();
                                CASE lin_NoOfResults OF
                                    0:

                                        // Einheit %1 nicht vorhanden!
                                        ERROR(ADF_LT_TEXT001Txt, rco_UnitOfMeasureCode);
                                    1:
                                        BEGIN
                                            lrc_UnitofMeasure.FINDFIRST();
                                            rco_UnitOfMeasureCode := lrc_UnitofMeasure.Code;
                                        END;
                                    ELSE
                                        IF Page.RUNMODAL(lin_FormIDList, lrc_UnitofMeasure) = ACTION::LookupOK THEN
                                            rco_UnitOfMeasureCode := lrc_UnitofMeasure.Code
                                        ELSE
                                            ERROR('');
                                END;
                            END;

                    END;


                    // Prüfung ob Artikeleinheit existiert
                    lrc_ItemUnitofMeasure.SETRANGE("Item No.", lrc_Item."No.");
                    lrc_ItemUnitofMeasure.SETRANGE(Code, rco_UnitOfMeasureCode);
                    IF lrc_ItemUnitofMeasure.IsEmpty() THEN begin
                        // Prüfung ob Werte identsich sind
                        lrc_UnitofMeasure.GET(rco_UnitOfMeasureCode);
                        lrc_UnitofMeasure.TESTFIELD("POI Qty. (BU) per Unit of Meas");
                        // Artikeleinheit anlegen
                        lrc_ItemUnitofMeasure.RESET();
                        lrc_ItemUnitofMeasure.INIT();
                        lrc_ItemUnitofMeasure."Item No." := lrc_Item."No.";
                        lrc_ItemUnitofMeasure.Code := lrc_UnitofMeasure.Code;
                        lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas";
                        lrc_ItemUnitofMeasure."POI Kind of Unit of Measure" := lrc_UnitofMeasure."POI Kind of Unit of Measure";
                        lrc_ItemUnitofMeasure."POI Gross Weight" := lrc_UnitofMeasure."POI Gross Weight";
                        lrc_ItemUnitofMeasure."POI Net Weight" := lrc_UnitofMeasure."POI Net Weight";
                        lrc_ItemUnitofMeasure."POI Weight of Packaging" := lrc_UnitofMeasure."POI Weight of Packaging";
                        lrc_ItemUnitofMeasure.INSERT();

                        // Eventuelle Verpackungseinheit anlegen
                        IF lrc_UnitofMeasure."POI Packing Unit of Meas (PU)" <> '' THEN BEGIN
                            lrc_ItemUnitofMeasure.SETRANGE("Item No.", lrc_Item."No.");
                            lrc_ItemUnitofMeasure.SETRANGE(Code, lrc_UnitofMeasure."POI Packing Unit of Meas (PU)");
                            IF lrc_ItemUnitofMeasure.isempty() THEN Begin
                                // Prüfung ob Werte identisch sind 
                                lrc_UnitofMeasure.TESTFIELD("POI Qty. (BU) per Packing Unit");
                                // Verpackungseinheit anlegen
                                lrc_ItemUnitofMeasure.RESET();
                                lrc_ItemUnitofMeasure.INIT();
                                lrc_ItemUnitofMeasure."Item No." := lrc_Item."No.";
                                lrc_ItemUnitofMeasure.Code := lrc_UnitofMeasure."POI Packing Unit of Meas (PU)";
                                lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := lrc_UnitofMeasure."POI Qty. (BU) per Packing Unit";
                                lrc_ItemUnitofMeasure."POI Kind of Unit of Measure" := lrc_ItemUnitofMeasure."POI Kind of Unit of Measure"::"Packing Unit";
                                lrc_ItemUnitofMeasure."POI Gross Weight" := lrc_UnitofMeasure."POI Gross Weight" /
                                                                        lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas" *
                                                                        lrc_UnitofMeasure."POI Qty. (BU) per Packing Unit";
                                lrc_ItemUnitofMeasure."POI Net Weight" := lrc_UnitofMeasure."POI Net Weight" /
                                                                        lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas" *
                                                                        lrc_UnitofMeasure."POI Qty. (BU) per Packing Unit";
                                lrc_ItemUnitofMeasure."POI Weight of Packaging" := lrc_ItemUnitofMeasure."POI Gross Weight" -
                                                                               lrc_ItemUnitofMeasure."POI Net Weight";
                                lrc_ItemUnitofMeasure.INSERT();
                            END;
                        END;
                    END;

                END;

            // Alle anderen Arten
            ELSE BEGIN

                    IF rco_UnitOfMeasureCode = '' THEN
                        EXIT;

                    IF lrc_UnitofMeasure.GET(rco_UnitOfMeasureCode) THEN
                        EXIT;

                    IF vbn_Search = FALSE THEN
                        // Einheit %1 nicht vorhanden!
                        ERROR(ADF_LT_TEXT001Txt, rco_UnitOfMeasureCode);

                    lin_FormIDList := 0;

                    lco_SearchDescription := CreateSearchString(rco_UnitOfMeasureCode);
                    lrc_UnitofMeasure.RESET();
                    lrc_UnitofMeasure.SETFILTER("POI Search Description", lco_SearchDescription);
                    lin_NoOfResults := lrc_UnitofMeasure.COUNT();

                    CASE lin_NoOfResults OF
                        0:
                            // Einheit %1 nicht vorhanden!
                            ERROR(ADF_LT_TEXT001Txt, rco_UnitOfMeasureCode);
                        1:
                            BEGIN
                                lrc_UnitofMeasure.FINDFIRST();
                                rco_UnitOfMeasureCode := lrc_UnitofMeasure.Code;
                                EXIT;
                            END;
                        ELSE
                            IF Page.RUNMODAL(lin_FormIDList, lrc_UnitofMeasure) = ACTION::LookupOK THEN BEGIN
                                rco_UnitOfMeasureCode := lrc_UnitofMeasure.Code;
                                EXIT;
                            END ELSE
                                ERROR('');
                    END;
                END;
        END;
    end;



    var
        Item: Record Item;
        lrc_ProductGroup: Record "POI Product Group";
        lrc_Trademark: Record "POI Trademark";
        lrc_Caliber: Record "POI Caliber";
        lrc_ProductGroupCaliber: Record "POI Product Group - Caliber";
        lrc_Variety: Record "POI Variety";
        lrc_ProductGroupVariety: Record "POI Product Group - Variety";
        lrc_ProductGroupUnit: Record "POI Product Group - Unit";
        lrc_UnitofMeasure: Record "Unit of Measure";
        lrc_Voyage: Record "POI Voyage";
        lrc_Customer: Record Customer;
        lrc_Vendor: Record Vendor;
        lrc_Location: Record Location;
        lrc_CountryRegion: Record "Country/Region";
        lrc_ProductGroupCountryRegion: Record "POI Product Grp-Country/Region";
        Text000Txt: Label 'The %1 is empty.', Comment = '%1';
        Text001Txt: Label '%1 %2 does not exist.', Comment = '%1 %2';

}