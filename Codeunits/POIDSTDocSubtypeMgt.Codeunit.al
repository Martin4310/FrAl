codeunit 5087912 "POI DST Doc. Subtype Mgt"
{
    procedure GetDefaultSalesDocType(vop_SalesType: Option "0","1","2","3","4","5","6","7","8","9"): Code[10]
    var
        POI_LT_TEXT001Txt: Label 'There exist no sales document type for document type %1 !', Comment = '%1';
    begin
        // ----------------------------------------------------------------------------------
        // Funktion zur Default Belegung der Belegart falls keine vorhanden
        // ----------------------------------------------------------------------------------

        lrc_SalesDocSubtype.RESET();
        lrc_SalesDocSubtype.SETRANGE("Document Type", vop_SalesType);
        lrc_SalesDocSubtype.SETRANGE("Default Subtype", TRUE);
        IF lrc_SalesDocSubtype.FINDFIRST() THEN
            EXIT(lrc_SalesDocSubtype.Code)
        ELSE
            // Es gibt keine Belegunterart für die Belegart!
            ERROR(POI_LT_TEXT001Txt);
    end;

    procedure SetFilterSalesDocType(var rrc_SalesHeader: Record "Sales Header")
    var
    //ldc_SalesDocSubTypeCode: Code[10];
    begin
    end;

    procedure SelectSalesDocType(vop_DocType: Option "0","1","2","3","4","5","6","7","8","9"; vop_DocSubType: Option "0","1","2","3","4","5","6","7","8","9"): Code[10]
    var
        lfm_SalesDocTypeList: Page "POI Sales Doc. Type List";
        lco_SalesDocTypeFilter: Code[250];
        lin_NoOfResults: Integer;
        ADF_LT_TEXT001Txt: Label 'No Doc. Subtype for Doc. Type %1 and/or User %2 available!', Comment = '%1 %2';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Auswahl der Belegart
        // -----------------------------------------------------------------------------
        // vop_DocType
        // -----------------------------------------------------------------------------

        lrc_SalesDocType.FILTERGROUP(2);
        lrc_SalesDocType.SETRANGE("Document Type", vop_DocType);
        lrc_SalesDocType.SETRANGE("In Selection", TRUE);

        lco_SalesDocTypeFilter := '';
        lrc_SalesDocSubtypeFilter.RESET();
        lrc_SalesDocSubtypeFilter.SETRANGE("Document Type", vop_DocType);
        lrc_SalesDocSubtypeFilter.SETRANGE(Source, lrc_SalesDocSubtypeFilter.Source::UserID);
        lrc_SalesDocSubtypeFilter.SETRANGE("Source No.", USERID());
        lrc_SalesDocSubtypeFilter.SETRANGE("Not Allowed", FALSE);
        // Es gibt definierte Belegunterarten für diesen User, dann diese filtern
        IF lrc_SalesDocSubtypeFilter.FINDSET(FALSE, FALSE) THEN BEGIN
            REPEAT
                IF lco_SalesDocTypeFilter = '' THEN
                    lco_SalesDocTypeFilter := lrc_SalesDocSubtypeFilter."Sales Doc. Subtype Code"
                ELSE
                    lco_SalesDocTypeFilter := copystr(lco_SalesDocTypeFilter + '|' + lrc_SalesDocSubtypeFilter."Sales Doc. Subtype Code", 1, 250);

            UNTIL lrc_SalesDocSubtypeFilter.NEXT() = 0;
            // Filter setzen
            IF lco_SalesDocTypeFilter <> '' THEN
                lrc_SalesDocType.SETFILTER(Code, lco_SalesDocTypeFilter);
        END ELSE BEGIN
            lrc_SalesDocSubtypeFilter.RESET();
            lrc_SalesDocSubtypeFilter.SETRANGE("Document Type", vop_DocType);
            lrc_SalesDocSubtypeFilter.SETRANGE(Source, lrc_SalesDocSubtypeFilter.Source::UserID);
            lrc_SalesDocSubtypeFilter.SETRANGE("Source No.", USERID());
            lrc_SalesDocSubtypeFilter.SETRANGE("Not Allowed", TRUE);
            // Es gibt keine definierte Belegunterarten für diesen User, gibt es welche für die
            // er ausgeschlossen ist, dann nur zulässige filtern
            IF lrc_SalesDocSubtypeFilter.FINDSET(FALSE, FALSE) THEN BEGIN
                REPEAT
                    IF lco_SalesDocTypeFilter = '' THEN
                        lco_SalesDocTypeFilter := '<>' + lrc_SalesDocSubtypeFilter."Sales Doc. Subtype Code"
                    ELSE
                        lco_SalesDocTypeFilter := copystr(lco_SalesDocTypeFilter + '&<>' + lrc_SalesDocSubtypeFilter."Sales Doc. Subtype Code", 1, 250);
                UNTIL lrc_SalesDocSubtypeFilter.NEXT() = 0;
                // Filter setzen
                IF lco_SalesDocTypeFilter <> '' THEN
                    lrc_SalesDocType.SETFILTER(Code, lco_SalesDocTypeFilter);
            END;
        END;
        lrc_SalesDocType.FILTERGROUP(0);
        lin_NoOfResults := lrc_SalesDocType.COUNT();
        IF lin_NoOfResults = 0 THEN
            // Keine Belegunterart für Belegart %1 und/oder Anwender %2 vorhanden!
            ERROR(ADF_LT_TEXT001Txt, vop_DocType, USERID());

        IF lin_NoOfResults > 1 THEN BEGIN
            lfm_SalesDocTypeList.LOOKUPMODE := TRUE;
            lfm_SalesDocTypeList.SETTABLEVIEW(lrc_SalesDocType);
            IF lfm_SalesDocTypeList.RUNMODAL() <> ACTION::LookupOK THEN
                ERROR('');
            lrc_SalesDocType.RESET();
            lfm_SalesDocTypeList.GETRECORD(lrc_SalesDocType);
        END ELSE
            lrc_SalesDocType.FINDFIRST();

        // Belegunterart zurückgeben
        EXIT(lrc_SalesDocType.Code);
    end;

    procedure CheckCustSalesDocTyp(vrc_SalesHeader: Record "Sales Header"; vbn_ErrrorMessage: Boolean): Boolean
    var
        lrc_Customer: Record "Customer";
        ADF_LT_TEXT001Txt: Label 'Customer for Sales Document Type %1 not allowed!', Comment = '%1';
    begin
        // ---------------------------------------------------------------------------------
        // Funktion zur Prüfung ob Debitor für Belegunterart zulässig
        // ---------------------------------------------------------------------------------

        IF vrc_SalesHeader."Sell-to Customer No." = '' THEN
            EXIT(TRUE);

        // Belegart lesen
        lrc_SalesDocType.GET(vrc_SalesHeader."Document Type", vrc_SalesHeader."POI Sales Doc. Subtype Code");

        IF (lrc_SalesDocType."Restrict Customers" = FALSE) THEN
            EXIT(TRUE);

        // Prüfung auf Debitorennummer
        lrc_SalesDocTypeFilter.RESET();
        lrc_SalesDocTypeFilter.SETRANGE("Document Type", lrc_SalesDocType."Document Type");
        lrc_SalesDocTypeFilter.SETRANGE("Sales Doc. Subtype Code", lrc_SalesDocType.Code);
        lrc_SalesDocTypeFilter.SETRANGE(Source, lrc_SalesDocTypeFilter.Source::Customer);
        lrc_SalesDocTypeFilter.SETRANGE("Source No.", vrc_SalesHeader."Sell-to Customer No.");
        IF lrc_SalesDocTypeFilter.FINDFIRST() THEN BEGIN
            IF lrc_SalesDocTypeFilter."Not Allowed" = TRUE THEN BEGIN
                IF vbn_ErrrorMessage = TRUE THEN
                    ERROR(ADF_LT_TEXT001Txt)
                ELSE
                    EXIT(FALSE);
            END ELSE
                EXIT(TRUE);

        END ELSE BEGIN

            // Prüfung auf Unternehmenskette
            lrc_Customer.GET(vrc_SalesHeader."Sell-to Customer No.");
            IF lrc_Customer."Chain Name" = '' THEN
                EXIT(FALSE);

            lrc_SalesDocTypeFilter.RESET();
            lrc_SalesDocTypeFilter.SETRANGE("Document Type", lrc_SalesDocType."Document Type");
            lrc_SalesDocTypeFilter.SETRANGE("Sales Doc. Subtype Code", lrc_SalesDocType.Code);
            lrc_SalesDocTypeFilter.SETRANGE(Source, lrc_SalesDocTypeFilter.Source::"Customer Chain");
            lrc_SalesDocTypeFilter.SETRANGE("Source No.", lrc_Customer."Chain Name");
            IF lrc_SalesDocTypeFilter.FINDFIRST() THEN BEGIN
                IF lrc_SalesDocTypeFilter."Not Allowed" = TRUE THEN BEGIN
                    IF vbn_ErrrorMessage = TRUE THEN
                        ERROR(ADF_LT_TEXT001Txt)
                    ELSE
                        EXIT(FALSE)
                END ELSE
                    EXIT(TRUE);
            END ELSE
                IF vbn_ErrrorMessage = TRUE THEN
                    ERROR(ADF_LT_TEXT001Txt)
                ELSE
                    EXIT(FALSE);
        END;

        // Debitor nicht zugelassen für Belegart!
        ERROR(ADF_LT_TEXT001Txt);
    end;

    procedure CheckLocationSalesDocTyp(vop_DocTyp: Option "0","1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; vco_DocTypCode: Code[10]; vco_LocationCode: Code[10])
    var
        lrc_SalesHeader: Record "Sales Header";
        ADF_LT_TEXT001Txt: Label 'Location not allowed with Doc. Subtyp!';
        ADF_LT_TEXT002Txt: Label 'Location must be the same as in sales header!';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Prüfen ob Lagerort für Belegunterart zulässig
        // -----------------------------------------------------------------------------

        IF vco_DocTypCode = '' THEN
            EXIT;

        lrc_SalesDocType.GET(vop_DocTyp, vco_DocTypCode);
        CASE lrc_SalesDocType."Restrict Locations" OF
            lrc_SalesDocType."Restrict Locations"::Vorgabe:
                ;

            lrc_SalesDocType."Restrict Locations"::"Feste Eingrenzung":
                BEGIN
                    lrc_SalesDocTypeFilter.RESET();
                    lrc_SalesDocTypeFilter.SETRANGE("Document Type", vop_DocTyp);
                    lrc_SalesDocTypeFilter.SETRANGE("Sales Doc. Subtype Code", vco_DocTypCode);
                    lrc_SalesDocTypeFilter.SETRANGE(Source, lrc_SalesDocTypeFilter.Source::Location);
                    lrc_SalesDocTypeFilter.SETRANGE("Source No.", vco_LocationCode);
                    IF lrc_SalesDocTypeFilter.ISEMPTY() THEN
                        // Lager für Belegart nicht zulässig!
                        ERROR(ADF_LT_TEXT001Txt);
                END;
            lrc_SalesDocType."Restrict Locations"::Belegkopf:
                IF lrc_SalesHeader.GET(vop_DocTyp, vco_DocNo) THEN
                    IF lrc_SalesHeader."Location Code" <> vco_LocationCode THEN
                        // Lager ist nicht identisch mit Lager in Verkaufskopf!
                        ERROR(ADF_LT_TEXT002Txt);
        END;
    end;

    procedure CheckItemSalesDocTyp(vop_DocTyp: Option "0","1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; vco_DocTypCode: Code[10]; vco_ItemNo: Code[20]): Boolean
    var
        lrc_SalesHeader: Record "Sales Header";
        lrc_Customer: Record "Customer";
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Prüfen ob Artikel für Belegunterart zulässig
        // -----------------------------------------------------------------------------

        IF vco_DocNo = '' THEN
            EXIT(TRUE);
        IF vco_DocTypCode = '' THEN
            EXIT(TRUE);
        IF vco_ItemNo = '' THEN
            EXIT(TRUE);

        lrc_SalesDocType.GET(vop_DocTyp, vco_DocTypCode);
        lrc_SalesDocTypeFilter.RESET();
        lrc_SalesDocTypeFilter.SETRANGE("Document Type", vop_DocTyp);
        lrc_SalesDocTypeFilter.SETRANGE("Sales Doc. Subtype Code", vco_DocTypCode);
        lrc_SalesDocTypeFilter.SETRANGE(Source, lrc_SalesDocTypeFilter.Source::"Item Chain");
        lrc_SalesDocTypeFilter.SETRANGE("Source No.", '');
        IF lrc_SalesDocTypeFilter.FINDSET(FALSE, FALSE) THEN BEGIN
            lrc_SalesHeader.GET(vop_DocTyp, vco_DocNo);
            lrc_Customer.GET(lrc_SalesHeader."Sell-to Customer No.");
            REPEAT


            UNTIL lrc_SalesDocTypeFilter.NEXT() = 0;
        END;
    end;

    procedure CheckPermittedWithDocTyp(vrc_SalesHeader: Record "Sales Header"; vrc_Item: Record Item)
    var
        AGILES_LT_TEXT001Txt: Label 'Artikel ist für die Belegunterart nicht zulässig!';
    begin
        // ---------------------------------------------------------------------------------
        // Prüfung ob der Artikel für die Auftragsart zulässig ist
        // ---------------------------------------------------------------------------------

        lrc_SalesDocTypeFilter.RESET();
        lrc_SalesDocTypeFilter.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesDocTypeFilter.SETRANGE("Sales Doc. Subtype Code", vrc_SalesHeader."POI Sales Doc. Subtype Code");
        lrc_SalesDocTypeFilter.SETRANGE(Source, lrc_SalesDocTypeFilter.Source::Item);
        lrc_SalesDocTypeFilter.SETRANGE("Source No.", vrc_Item."No.");
        IF lrc_SalesDocTypeFilter.FINDFIRST() THEN
            IF lrc_SalesDocTypeFilter."Not Allowed" = TRUE THEN
                // Artikel ist für die Belegunterart nicht zulässig!
                ERROR(AGILES_LT_TEXT001Txt)
            ELSE
                EXIT;

        lrc_SalesDocTypeFilter.RESET();
        lrc_SalesDocTypeFilter.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesDocTypeFilter.SETRANGE("Sales Doc. Subtype Code", vrc_SalesHeader."POI Sales Doc. Subtype Code");
        lrc_SalesDocTypeFilter.SETRANGE(Source, lrc_SalesDocTypeFilter.Source::"Item Chain");
        lrc_SalesDocTypeFilter.SETRANGE("Source No.", vrc_Item."POI Only for Company Chain");
        IF lrc_SalesDocTypeFilter.FINDFIRST() THEN
            IF lrc_SalesDocTypeFilter."Not Allowed" = TRUE THEN
                // Artikel ist für die Belegunterart nicht zulässig!
                ERROR(AGILES_LT_TEXT001Txt)
            ELSE
                EXIT;

        lrc_SalesDocTypeFilter.RESET();
        lrc_SalesDocTypeFilter.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesDocTypeFilter.SETRANGE("Sales Doc. Subtype Code", vrc_SalesHeader."POI Sales Doc. Subtype Code");
        lrc_SalesDocTypeFilter.SETRANGE(Source, lrc_SalesDocTypeFilter.Source::"Product Group");
        lrc_SalesDocTypeFilter.SETRANGE("Source No.", vrc_Item."POI Product Group Code");
        IF lrc_SalesDocTypeFilter.FINDFIRST() THEN
            IF lrc_SalesDocTypeFilter."Not Allowed" = TRUE THEN
                // Artikel ist für die Belegunterart nicht zulässig!
                ERROR(AGILES_LT_TEXT001Txt)
            ELSE
                EXIT;

        lrc_SalesDocTypeFilter.RESET();
        lrc_SalesDocTypeFilter.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesDocTypeFilter.SETRANGE("Sales Doc. Subtype Code", vrc_SalesHeader."POI Sales Doc. Subtype Code");
        lrc_SalesDocTypeFilter.SETRANGE(Source, lrc_SalesDocTypeFilter.Source::"Item Category");
        lrc_SalesDocTypeFilter.SETRANGE("Source No.", vrc_Item."Item Category Code");
        IF lrc_SalesDocTypeFilter.FINDFIRST() THEN
            IF lrc_SalesDocTypeFilter."Not Allowed" = TRUE THEN
                // Artikel ist für die Belegunterart nicht zulässig!
                ERROR(AGILES_LT_TEXT001Txt)
            ELSE
                EXIT;
    end;

    procedure GetReferenceSalesDocTyp(vrc_SalesHeader: Record "Sales Header"; var rco_CustPriceGroup: Code[20]; var rco_ShippingAgent: Code[20]; var rco_Location: Code[20]; var rco_PaymentTerms: Code[20]; var rco_ShipmentMethod: Code[20]; var rco_ArrivalRegion: Code[20]): Boolean
    var
        lbn_Treffer: Boolean;
    begin
        // -------------------------------------------------------------------------------
        // Funktion zur Ermittlung von Belegarten Abhängigen Debitoren Stammdaten
        // -------------------------------------------------------------------------------

        // Rückgabewerte mit Ausgangswerten belegen
        rco_CustPriceGroup := vrc_SalesHeader."Customer Price Group";
        rco_ShippingAgent := vrc_SalesHeader."Shipping Agent Code";
        rco_Location := vrc_SalesHeader."Location Code";
        rco_PaymentTerms := vrc_SalesHeader."Payment Terms Code";
        rco_ShipmentMethod := vrc_SalesHeader."Shipment Method Code";
        rco_ArrivalRegion := vrc_SalesHeader."POI Arrival Region Code";

        IF vrc_SalesHeader."Sell-to Customer No." = '' THEN
            EXIT(FALSE);

        lrc_PurchSalesDocReference.SETRANGE(Source, lrc_PurchSalesDocReference.Source::Sales);
        lrc_PurchSalesDocReference.SETRANGE("Document Type", lrc_PurchSalesDocReference."Document Type"::None);
        lrc_PurchSalesDocReference.SETRANGE("Doc. Subtype Code", vrc_SalesHeader."POI Sales Doc. Subtype Code");
        IF vrc_SalesHeader."Sell-to Customer No." = vrc_SalesHeader."Bill-to Customer No." THEN
            lrc_PurchSalesDocReference.SETRANGE("Reference Source Code", vrc_SalesHeader."Sell-to Customer No.")
        ELSE
            lrc_PurchSalesDocReference.SETRANGE("Reference Source Code", vrc_SalesHeader."Bill-to Customer No.");
        IF lrc_PurchSalesDocReference.FINDSET(FALSE, FALSE) THEN BEGIN
            lbn_Treffer := TRUE;
            REPEAT
                CASE lrc_PurchSalesDocReference."Reference Type" OF
                    lrc_PurchSalesDocReference."Reference Type"::"Cust. Price Group":
                        rco_CustPriceGroup := lrc_PurchSalesDocReference."Reference Code";
                    lrc_PurchSalesDocReference."Reference Type"::"Shipping Agent":
                        rco_ShippingAgent := lrc_PurchSalesDocReference."Reference Code";
                    lrc_PurchSalesDocReference."Reference Type"::Location:
                        rco_Location := lrc_PurchSalesDocReference."Reference Code";
                    lrc_PurchSalesDocReference."Reference Type"::"Payment Term":
                        rco_PaymentTerms := lrc_PurchSalesDocReference."Reference Code";
                    lrc_PurchSalesDocReference."Reference Type"::"Shipment Method":
                        rco_ShipmentMethod := lrc_PurchSalesDocReference."Reference Code";
                    lrc_PurchSalesDocReference."Reference Type"::"Arrival Region":
                        rco_ArrivalRegion := lrc_PurchSalesDocReference."Reference Code";
                END;
            UNTIL lrc_PurchSalesDocReference.NEXT() = 0;
        END;

        EXIT(lbn_Treffer);
    end;


    procedure GetDefaultPurchDocType(vop_PurchType: Option "0","1","2","3","4","5","6","7","8","9"): Code[10]
    var
        POI_LT_TEXT001Txt: Label 'There exist no sales document type for document type %1 !', Comment = '%1';
    begin
        // ----------------------------------------------------------------------------------
        // Funktion zur Default Belegung der Belegart falls keine vorhanden
        // ----------------------------------------------------------------------------------

        lrc_PurchDocSubtype.RESET();
        lrc_PurchDocSubtype.SETRANGE("Document Type", vop_PurchType);
        lrc_PurchDocSubtype.SETRANGE("Default Subtype", TRUE);
        IF lrc_PurchDocSubtype.FINDFIRST() THEN
            EXIT(lrc_PurchDocSubtype.Code)
        ELSE
            // Es gibt keine Belegunterart für die Belegart!
            ERROR(POI_LT_TEXT001Txt);
    end;

    procedure SetFilterPurchDocType(vop_DocType: Option "0","1","2","3","4","5","6","7","8","9"; vop_DocSubType: Option "0","1","2","3","4","5","6","7","8","9"; vop_DocSubTypeDetail: Option "0","1","2","3","4","5","6"; var rrc_PurchaseHeader: Record "Purchase Header"; var rco_PurchSocSubTypeCode: Code[10])
    var
        ldc_PurchDocSubTypeCode: Code[10];
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Auswahl der Belegunterart und setzen des Filters
        // -----------------------------------------------------------------------------

        ldc_PurchDocSubTypeCode := SelectPurchDocType(vop_DocType, vop_DocSubType, vop_DocSubTypeDetail);
        lrc_PurchDocSubtype.GET(vop_DocType, ldc_PurchDocSubTypeCode);

        rrc_PurchaseHeader.RESET();
        rrc_PurchaseHeader.FILTERGROUP(2);
        rrc_PurchaseHeader.SETRANGE("Document Type", vop_DocType);
        rrc_PurchaseHeader.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchDocSubtype.Code);
        rrc_PurchaseHeader.SETRANGE("POI Purch. Doc. Subtype Detail", lrc_PurchDocSubtype."Doc. Subtype Detail");

        IF (UPPERCASE(USERID()) <> 'LESS') AND (UPPERCASE(USERID()) <> 'RLAU') AND (UPPERCASE(USERID()) <> 'WESSEL') THEN
            rrc_PurchaseHeader.SETFILTER("Order Date", '>=%1|%2', CALCDATE('<LJ-3J+1T>', WORKDATE()), 0D)
        ELSE
            rrc_PurchaseHeader.SETFILTER("Order Date", '>=%1|%2', CALCDATE('<LJ-5J+1T>', WORKDATE()), 0D);

        rrc_PurchaseHeader.FILTERGROUP(0);
        rrc_PurchaseHeader.SETRANGE("POI Document Status", 0, lrc_PurchDocSubtype."Show in List till Doc. Status");

        rco_PurchSocSubTypeCode := ldc_PurchDocSubTypeCode;
    end;

    procedure SelectPurchDocType(vop_DocType: Option "0","1","2","3","4","5","6","7","8","9"; vop_DocSubType: Option "0","1","2","3","4","5","6","7","8","9"; vop_DocSubTypeDetail: Option "0","1","2","3","4","5","6"): Code[10]
    var
        lfm_PurchDocTypeList: Page "POI Purch. Doc. Type List";
        lco_PurchDocTypeFilter: Code[240];
        lin_NoOfResults: Integer;
        ADF_LT_TEXT001Txt: Label 'Keine Belegunterart für Belegart %1 und Anwender %2 vorhanden!', Comment = '%1 %2';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Auswahl der Belegunterart
        // -----------------------------------------------------------------------------

        lrc_PurchDocType.FILTERGROUP(2);
        lrc_PurchDocType.SETRANGE("Document Type", vop_DocType);
        lrc_PurchDocType.SETRANGE("Doc. Subtype Detail", vop_DocSubTypeDetail);
        IF vop_DocSubType <> 0 THEN
            lrc_PurchDocType.SETRANGE("Doc. Subtype Detail", vop_DocSubType);
        lrc_PurchDocType.SETRANGE("In Selection", TRUE);

        lco_PurchDocTypeFilter := '';
        lrc_PurchDocSubtypeFilter.RESET();
        lrc_PurchDocSubtypeFilter.SETRANGE("Document Type", vop_DocType);
        lrc_PurchDocSubtypeFilter.SETRANGE(Source, lrc_PurchDocSubtypeFilter.Source::UserID);
        lrc_PurchDocSubtypeFilter.SETRANGE("Source No.", USERID());
        lrc_PurchDocSubtypeFilter.SETRANGE("Not Allowed", FALSE);
        // Es gibt definierte Belegunterarten für diesen User, dann diese filtern
        IF lrc_PurchDocSubtypeFilter.FINDSET(FALSE, FALSE) THEN BEGIN
            REPEAT
                IF lco_PurchDocTypeFilter = '' THEN
                    lco_PurchDocTypeFilter := lrc_PurchDocSubtypeFilter."Purch. Doc. Subtype Code"
                ELSE
                    lco_PurchDocTypeFilter := copystr(lco_PurchDocTypeFilter + '|' + lrc_PurchDocSubtypeFilter."Purch. Doc. Subtype Code", 1, 240);
            UNTIL lrc_PurchDocSubtypeFilter.NEXT() = 0;
            // Filter setzen
            IF lco_PurchDocTypeFilter <> '' THEN
                lrc_PurchDocType.SETFILTER(Code, lco_PurchDocTypeFilter);
        END ELSE BEGIN
            lrc_PurchDocSubtypeFilter.RESET();
            lrc_PurchDocSubtypeFilter.SETRANGE("Document Type", vop_DocType);
            lrc_PurchDocSubtypeFilter.SETRANGE(Source, lrc_PurchDocSubtypeFilter.Source::UserID);
            lrc_PurchDocSubtypeFilter.SETRANGE("Source No.", USERID());
            lrc_PurchDocSubtypeFilter.SETRANGE("Not Allowed", TRUE);
            // Es gibt keine definierte Belegunterarten für diesen User, gibt es welche für die
            // er ausgeschlossen ist, dann nur zulässige filtern
            IF lrc_PurchDocSubtypeFilter.FINDSET(FALSE, FALSE) THEN BEGIN
                REPEAT
                    IF lco_PurchDocTypeFilter = '' THEN
                        lco_PurchDocTypeFilter := '<>' + lrc_PurchDocSubtypeFilter."Purch. Doc. Subtype Code"
                    ELSE
                        lco_PurchDocTypeFilter := copystr(lco_PurchDocTypeFilter + '&<>' + lrc_PurchDocSubtypeFilter."Purch. Doc. Subtype Code", 1, 240);
                UNTIL lrc_PurchDocSubtypeFilter.NEXT() = 0;
                // Filter setzen
                IF lco_PurchDocTypeFilter <> '' THEN
                    lrc_PurchDocType.SETFILTER(Code, lco_PurchDocTypeFilter);
            END;
        END;
        lrc_PurchDocType.FILTERGROUP(0);

        lin_NoOfResults := lrc_PurchDocType.COUNT();

        IF lin_NoOfResults = 0 THEN
            // Keine Belegunterart für Belegart %1 und Anwender %2 vorhanden!
            ERROR(ADF_LT_TEXT001Txt, vop_DocType, USERID());

        IF lrc_PurchDocType.COUNT() > 1 THEN BEGIN
            lfm_PurchDocTypeList.LOOKUPMODE := TRUE;
            lfm_PurchDocTypeList.SETTABLEVIEW(lrc_PurchDocType);
            IF lfm_PurchDocTypeList.RUNMODAL() <> ACTION::LookupOK THEN
                ERROR('');
            lrc_PurchDocType.RESET();
            lfm_PurchDocTypeList.GETRECORD(lrc_PurchDocType);
        END ELSE
            lrc_PurchDocType.FINDFIRST();

        EXIT(lrc_PurchDocType.Code);
    end;

    procedure CheckVendPurchDocTyp(vrc_PurchHeader: Record "Purchase Header"; vbn_ErrrorMessage: Boolean): Boolean
    var
        lrc_Vendor: Record Vendor;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Prüfen ob Kreditor für Belegunterart zulässig
        // -----------------------------------------------------------------------------

        IF vrc_PurchHeader."Buy-from Vendor No." = '' THEN
            EXIT(TRUE);

        // Belegart muss vorhanden sein
        vrc_PurchHeader.TESTFIELD("POI Purch. Doc. Subtype Code");

        lrc_PurchDocType.GET(vrc_PurchHeader."Document Type", vrc_PurchHeader."POI Purch. Doc. Subtype Code");
        IF (lrc_PurchDocType."Restriction Vendors" = FALSE) THEN
            EXIT(TRUE);

        // Prüfung auf Kreditorennummer
        lrc_PurchDocTypeFilter.RESET();
        lrc_PurchDocTypeFilter.SETRANGE("Document Type", lrc_PurchDocType."Document Type");
        lrc_PurchDocTypeFilter.SETRANGE("Purch. Doc. Subtype Code", lrc_PurchDocType.Code);
        lrc_PurchDocTypeFilter.SETRANGE(Source, lrc_PurchDocTypeFilter.Source::Vendor);
        lrc_PurchDocTypeFilter.SETRANGE("Source No.", vrc_PurchHeader."Buy-from Vendor No.");
        IF lrc_PurchDocTypeFilter.FINDFIRST() THEN BEGIN
            IF lrc_PurchDocTypeFilter."Not Allowed" = TRUE THEN
                EXIT(FALSE)
            ELSE
                EXIT(TRUE);
        END ELSE BEGIN

            // Prüfung auf Unternehmenskette
            lrc_Vendor.GET(vrc_PurchHeader."Buy-from Vendor No.");
            IF lrc_Vendor."POI Chain Name" = '' THEN
                EXIT(FALSE);

            lrc_PurchDocTypeFilter.RESET();
            lrc_PurchDocTypeFilter.SETRANGE("Document Type", lrc_PurchDocType."Document Type");
            lrc_PurchDocTypeFilter.SETRANGE("Purch. Doc. Subtype Code", lrc_PurchDocType.Code);
            lrc_PurchDocTypeFilter.SETRANGE(Source, lrc_PurchDocTypeFilter.Source::"Vendor Chain");
            lrc_PurchDocTypeFilter.SETRANGE("Source No.", lrc_Vendor."POI Chain Name");
            IF lrc_PurchDocTypeFilter.FINDFIRST() THEN BEGIN

                IF lrc_PurchDocTypeFilter."Not Allowed" = TRUE THEN
                    EXIT(FALSE)
                ELSE
                    EXIT(TRUE);

            END ELSE
                EXIT(FALSE);

        END;

        // Zur Sicherheit
        EXIT(FALSE);
    end;

    procedure CheckLocationPurchDocTyp(vop_DocTyp: Option "0","1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; vco_DocTypCode: Code[10]; vco_LocationCode: Code[10])
    var
        lrc_PurchHdr: Record "Purchase Header";
        POI_TEXT001Txt: Label 'Lager für Belegart nicht zulässig!';
        POI_TEXT002Txt: Label 'Lager ist nicht identisch mit Lager in Einkaufskopf!';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Prüfen ob Lager für Belegunterart zulässig
        // -----------------------------------------------------------------------------

        IF (vco_DocTypCode = '') OR
           (vco_LocationCode = '') THEN
            EXIT;

        lrc_PurchDocType.GET(vop_DocTyp, vco_DocTypCode);
        CASE lrc_PurchDocType."Restrict Locations" OF
            lrc_PurchDocType."Restrict Locations"::"Feste Eingrenzung":
                BEGIN
                    lrc_PurchDocTypeFilter.SETRANGE("Document Type", vop_DocTyp);
                    lrc_PurchDocTypeFilter.SETRANGE("Purch. Doc. Subtype Code", vco_DocTypCode);
                    lrc_PurchDocTypeFilter.SETRANGE(Source, lrc_PurchDocTypeFilter.Source::Location);
                    lrc_PurchDocTypeFilter.SETRANGE("Source No.", vco_LocationCode);
                    IF lrc_PurchDocTypeFilter.ISEMPTY() THEN
                        // Lager für Belegart nicht zulässig!
                        ERROR(POI_TEXT001Txt);
                END;

            lrc_PurchDocType."Restrict Locations"::Belegkopf:
                BEGIN
                    lrc_PurchHdr.GET(vop_DocTyp, vco_DocNo);
                    IF lrc_PurchHdr."Location Code" <> vco_LocationCode THEN
                        // Lager ist nicht identisch mit Lager in Einkaufskopf!
                        ERROR(POI_TEXT002Txt);
                END;
        END;
    end;

    procedure CheckItemPurchDocTyp(vop_DocTyp: Option "0","1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; vco_ItemNo: Code[20]): Boolean
    var
        lrc_PurchaseHeader: Record "Purchase Header";
        lrc_Item: Record "Item";
        ADF_LT_TEXT001Txt: Label 'Artikel ist nicht aktiv im Verkauf! Einkauf nicht zulässig.';
        ADF_LT_TEXT002Txt: Label 'Artikel ist nicht aktiv im Einkauf! Einkauf nicht zulässig.';
        ADF_LT_TEXT003Txt: Label 'Artikel ist nicht aktiv im Einkauf und Verkauf! Einkauf nicht zulässig.';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Prüfen ob Artikel für Belegunterart zulässig
        // -----------------------------------------------------------------------------

        IF (vco_DocNo = '') OR
           (vco_ItemNo = '') THEN
            EXIT(TRUE);

        lrc_PurchaseHeader.GET(vop_DocTyp, vco_DocNo);
        lrc_PurchDocSubtype.GET(lrc_PurchaseHeader."Document Type", lrc_PurchaseHeader."POI Purch. Doc. Subtype Code");
        lrc_Item.GET(vco_ItemNo);

        // ## ADF.s ## - Kontrolle ob Eingrenzung über Belegunterart
        lrc_PurchDocSubtype.GET(lrc_PurchaseHeader."Document Type", lrc_PurchaseHeader."POI Purch. Doc. Subtype Code");
        CASE lrc_PurchDocSubtype."Restriction Items" OF
            lrc_PurchDocSubtype."Restriction Items"::"Only Items Activ in Sales":
                IF lrc_Item."POI Activ in Sales" = FALSE THEN
                    // Artikel ist nicht aktiv im Verkauf! Einkauf nicht zulässig.
                    ERROR(ADF_LT_TEXT001Txt);
            lrc_PurchDocSubtype."Restriction Items"::"Only Items Activ in Purchase":
                IF lrc_Item."POI Activ in Purchase" = FALSE THEN
                    // Artikel ist nicht aktiv im Einkauf! Einkauf nicht zulässig.
                    ERROR(ADF_LT_TEXT002Txt);
            lrc_PurchDocSubtype."Restriction Items"::"Only Items Activ in Purchase and Sales":
                IF (lrc_Item."POI Activ in Sales" = FALSE) OR
                   (lrc_Item."POI Activ in Purchase" = FALSE) THEN
                    // Artikel ist nicht aktiv im Einkauf und Verkauf! Einkauf nicht zulässig.
                    ERROR(ADF_LT_TEXT003Txt);
        END;


        // Prüfung auf Eingrenzung über Artikelnr.
        lrc_PurchDocSubtypeFilter.RESET();
        lrc_PurchDocSubtypeFilter.SETRANGE("Document Type", vop_DocTyp);
        lrc_PurchDocSubtypeFilter.SETRANGE("Purch. Doc. Subtype Code", lrc_PurchaseHeader."POI Purch. Doc. Subtype Code");
        lrc_PurchDocSubtypeFilter.SETRANGE(Source, lrc_PurchDocSubtypeFilter.Source::Item);
        lrc_PurchDocSubtypeFilter.SETRANGE("Source No.", lrc_Item."No.");
        IF lrc_PurchDocSubtypeFilter.FINDSET(FALSE, FALSE) THEN
            REPEAT
            UNTIL lrc_PurchDocSubtypeFilter.NEXT() = 0;

        // Prüfung auf Eingrenzung über Artikelkategorie
        IF lrc_Item."Item Category Code" <> '' THEN BEGIN
            lrc_PurchDocSubtypeFilter.RESET();
            lrc_PurchDocSubtypeFilter.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type");
            lrc_PurchDocSubtypeFilter.SETFILTER("Purch. Doc. Subtype Code", '%1|%2',
                                                lrc_PurchaseHeader."POI Purch. Doc. Subtype Code", '');
            lrc_PurchDocSubtypeFilter.SETRANGE(Source, lrc_PurchDocSubtypeFilter.Source::"Item Category");
            lrc_PurchDocSubtypeFilter.SETRANGE("Source No.", lrc_Item."Item Category Code");
            lrc_PurchDocSubtypeFilter.SETRANGE("Not Allowed", TRUE);
            IF lrc_PurchDocSubtypeFilter.FINDLAST() THEN
                ERROR('AGILES_TEXT031 %1 %2', lrc_Item."Item Category Code", lrc_PurchaseHeader."POI Purch. Doc. Subtype Code")
            ELSE BEGIN
                lrc_PurchDocSubtypeFilter.SETRANGE("Not Allowed", FALSE);
                lrc_PurchDocSubtypeFilter.SETRANGE("Source No.");
                // gibt es überhaupt eine Einschränkung auf Artikelkategorie Ebene
                IF lrc_PurchDocSubtypeFilter.FINDFIRST() THEN BEGIN
                    lrc_PurchDocSubtypeFilter.SETRANGE("Source No.", lrc_Item."Item Category Code");
                    IF NOT lrc_PurchDocSubtypeFilter.FINDLAST() THEN
                        ERROR('AGILES_TEXT031 %1 %2', lrc_Item."Item Category Code", lrc_PurchaseHeader."POI Purch. Doc. Subtype Code");
                END;
            END;
        END;

        // Prüfung auf Eingrenzung über Produktgruppe
        IF lrc_Item."POI Product Group Code" <> '' THEN BEGIN
            lrc_PurchDocSubtypeFilter.RESET();
            lrc_PurchDocSubtypeFilter.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type");
            lrc_PurchDocSubtypeFilter.SETFILTER("Purch. Doc. Subtype Code", '%1|%2', lrc_PurchaseHeader."POI Purch. Doc. Subtype Code", '');
            lrc_PurchDocSubtypeFilter.SETRANGE(Source, lrc_PurchDocSubtypeFilter.Source::"Product Group");
            lrc_PurchDocSubtypeFilter.SETRANGE("Source No.", lrc_Item."POI Product Group Code");
            lrc_PurchDocSubtypeFilter.SETRANGE("Not Allowed", TRUE);
            IF lrc_PurchDocSubtypeFilter.FINDLAST() THEN
                ERROR('AGILES_TEXT032 %1 %2', lrc_Item."POI Product Group Code", lrc_PurchaseHeader."POI Purch. Doc. Subtype Code")
            ELSE BEGIN
                lrc_PurchDocSubtypeFilter.SETRANGE("Not Allowed", FALSE);
                lrc_PurchDocSubtypeFilter.SETRANGE("Source No.");
                // gibt es überhaupt eine Einschränkung auf Produktgruppen Ebene
                IF lrc_PurchDocSubtypeFilter.FINDFIRST() THEN BEGIN
                    lrc_PurchDocSubtypeFilter.SETRANGE("Source No.", lrc_Item."POI Product Group Code");
                    IF lrc_PurchDocSubtypeFilter.IsEmpty() THEN
                        ERROR('AGILES_TEXT032 %1 %2', lrc_Item."POI Product Group Code", lrc_PurchaseHeader."POI Purch. Doc. Subtype Code");
                END;
            END;
        END;
    end;

    procedure GetReferencePurchDocTyp(vrc_PurchHeader: Record "Purchase Header"; var rco_ShippingAgent: Code[10]; var rco_Location: Code[10]; var rco_PaymentTerms: Code[10]; var rco_ShipmentMethod: Code[10]): Boolean
    var
        lbn_Treffer: Boolean;
    begin
        // -------------------------------------------------------------------------------
        // Funktion zur Ermittlung von Belegarten Abhängigen Kreditoren Stammdaten
        // -------------------------------------------------------------------------------

        // Rückgabewerte mit Ausgangswerten belegen
        rco_ShippingAgent := vrc_PurchHeader."POI Shipping Agent Code";
        rco_Location := vrc_PurchHeader."Location Code";
        rco_PaymentTerms := vrc_PurchHeader."Payment Terms Code";
        rco_ShipmentMethod := vrc_PurchHeader."Shipment Method Code";

        IF vrc_PurchHeader."Buy-from Vendor No." = '' THEN
            EXIT(FALSE);

        lrc_PurchSalesDocReference.SETRANGE(Source, lrc_PurchSalesDocReference.Source::Purchase);
        lrc_PurchSalesDocReference.SETRANGE("Document Type", lrc_PurchSalesDocReference."Document Type"::None);
        lrc_PurchSalesDocReference.SETRANGE("Doc. Subtype Code", vrc_PurchHeader."POI Purch. Doc. Subtype Code");
        IF vrc_PurchHeader."Buy-from Vendor No." = vrc_PurchHeader."Pay-to Vendor No." THEN
            lrc_PurchSalesDocReference.SETRANGE("Reference Source Code", vrc_PurchHeader."Buy-from Vendor No.")
        ELSE
            lrc_PurchSalesDocReference.SETRANGE("Reference Source Code", vrc_PurchHeader."Pay-to Vendor No.");
        IF lrc_PurchSalesDocReference.FINDSET(FALSE, FALSE) THEN BEGIN
            lbn_Treffer := TRUE;
            REPEAT
                CASE lrc_PurchSalesDocReference."Reference Type" OF
                    lrc_PurchSalesDocReference."Reference Type"::"Shipping Agent":
                        rco_ShippingAgent := copystr(lrc_PurchSalesDocReference."Reference Code", 1, MaxStrLen(rco_ShippingAgent));
                    lrc_PurchSalesDocReference."Reference Type"::Location:
                        rco_Location := copystr(lrc_PurchSalesDocReference."Reference Code", 1, MaxStrLen(rco_Location));
                    lrc_PurchSalesDocReference."Reference Type"::"Payment Term":
                        rco_PaymentTerms := copystr(lrc_PurchSalesDocReference."Reference Code", 1, MaxStrLen(rco_PaymentTerms));
                    lrc_PurchSalesDocReference."Reference Type"::"Shipment Method":
                        rco_ShipmentMethod := copystr(lrc_PurchSalesDocReference."Reference Code", 1, MaxStrLen(rco_ShipmentMethod));
                END;
            UNTIL lrc_PurchSalesDocReference.NEXT() = 0;
        END;

        EXIT(lbn_Treffer);
    end;

    var
        lrc_SalesDocSubtype: Record "POI Sales Doc. Subtype";
        lrc_SalesDocSubtypeFilter: Record "POI Sales Doc. Subtype Filter";
        lrc_SalesDocType: Record "POI Sales Doc. Subtype";
        lrc_SalesDocTypeFilter: Record "POI Sales Doc. Subtype Filter";
        lrc_PurchSalesDocReference: Record "POI Purch./Sales Doc. Refer.";
        lrc_PurchDocSubtype: Record "POI Purch. Doc. Subtype";
        lrc_PurchDocType: Record "POI Purch. Doc. Subtype";
        lrc_PurchDocSubtypeFilter: Record "POI Purch. Doc. Subtype Filter";
        lrc_PurchDocTypeFilter: Record "POI Purch. Doc. Subtype Filter";

}

