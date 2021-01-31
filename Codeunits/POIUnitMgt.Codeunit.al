codeunit 5110703 "POI Unit Mgt"
{
    procedure GetItemVendorUnitPalletFactor(vco_ItemNo: Code[20]; vop_ReferenceTyp: Option " ",Vendor,Customer,"Customer Group"; vco_ReferenceNo: Code[20]; vco_UnitOfMeasureCode: Code[10]; vdc_QtyperUnitofMeasure: Decimal; vco_EmptyItemNo: Code[20]; vco_TransportUnitOfMeasureCode: Code[10]; var rdc_PalletFactor: Decimal): Boolean

    begin
        rdc_PalletFactor := 0;
        IF vco_TransportUnitOfMeasureCode = '' THEN
            EXIT(TRUE);
        lrc_ItemTransportUnitFaktor.RESET();
        lrc_ItemTransportUnitFaktor.SETCURRENTKEY("Item No.", "Reference Typ",
                                                  "Reference No.", "Unit of Measure Code", "Transport Unit of Measure (TU)");
        lrc_ItemTransportUnitFaktor.SETFILTER("Item No.", '%1|%2', vco_ItemNo, '');
        lrc_ItemTransportUnitFaktor.SETFILTER("Reference Typ", '%1|%2', vop_ReferenceTyp,
                                              lrc_ItemTransportUnitFaktor."Reference Typ"::" ");
        lrc_ItemTransportUnitFaktor.SETFILTER("Reference No.", '%1|%2', vco_ReferenceNo, '');
        lrc_ItemTransportUnitFaktor.SETFILTER("Unit of Measure Code", '%1|%2', vco_UnitOfMeasureCode, '');
        lrc_ItemTransportUnitFaktor.SETFILTER("Empty Item No.", '%1|%2', vco_EmptyItemNo, '');
        lrc_ItemTransportUnitFaktor.SETRANGE("Transport Unit of Measure (TU)",
                                             vco_TransportUnitOfMeasureCode);
        IF lrc_ItemTransportUnitFaktor.FINDLAST() THEN
            rdc_PalletFactor := lrc_ItemTransportUnitFaktor."Qty. (Unit) per Transp. Unit"
        ELSE BEGIN
            lrc_ItemTransportUnitFaktor.SETRANGE("Reference Typ", lrc_ItemTransportUnitFaktor."Reference Typ"::All);
            lrc_ItemTransportUnitFaktor.SETFILTER("Reference No.", '%1', '');
            IF lrc_ItemTransportUnitFaktor.FINDLAST() THEN
                rdc_PalletFactor := lrc_ItemTransportUnitFaktor."Qty. (Unit) per Transp. Unit"
            ELSE
                IF vco_UnitOfMeasureCode <> '' THEN BEGIN
                    lrc_ItemUnitOfMeasure.RESET();
                    lrc_ItemUnitOfMeasure.SETRANGE("Item No.", vco_ItemNo);
                    lrc_ItemUnitOfMeasure.SETRANGE(Code, vco_TransportUnitOfMeasureCode);
                    IF lrc_ItemUnitOfMeasure.FINDFIRST() THEN
                        rdc_PalletFactor := lrc_ItemUnitOfMeasure."Qty. per Unit of Measure" / vdc_QtyperUnitofMeasure
                    ELSE
                        IF lrc_UnitofMeasure.GET(vco_UnitOfMeasureCode) THEN
                            IF lrc_UnitofMeasure."POI Transp. Unit of Meas (TU)" = vco_TransportUnitOfMeasureCode THEN BEGIN
                                IF lrc_UnitofMeasure."POI Qty. per Transp. Unit (TU)" <> 0 THEN
                                    rdc_PalletFactor := lrc_UnitofMeasure."POI Qty. per Transp. Unit (TU)"
                                ELSE
                                    IF lrc_UnitofMeasure.GET(vco_TransportUnitOfMeasureCode) THEN
                                        IF lrc_UnitofMeasure."POI Number of Tiers" * lrc_UnitofMeasure."POI Number of Units per Tier" <> 0 THEN
                                            rdc_PalletFactor := lrc_UnitofMeasure."POI Number of Tiers" * lrc_UnitofMeasure."POI Number of Units per Tier";
                            END ELSE
                                IF lrc_UnitofMeasure.GET(vco_TransportUnitOfMeasureCode) THEN
                                    IF lrc_UnitofMeasure."POI Number of Tiers" * lrc_UnitofMeasure."POI Number of Units per Tier" <> 0 THEN
                                        rdc_PalletFactor := lrc_UnitofMeasure."POI Number of Tiers" * lrc_UnitofMeasure."POI Number of Units per Tier";
                END;
        END;

        IF rdc_PalletFactor = 0 THEN
            EXIT(FALSE)
        ELSE
            EXIT(TRUE);
    end;

    procedure GetItemCustomerTransportUnit(vco_ItemNo: Code[20]; vop_ReferenceTyp: Option " ",Vendor,Customer,"Customer Group"; vco_ReferenceNo: Code[20]; vco_UnitOfMeasureCode: Code[10]; var rco_TransportUnitOfMeasureCode: Code[10])
    begin

        lrc_ItemTransportUnitFaktor.RESET();
        lrc_ItemTransportUnitFaktor.SETCURRENTKEY("Item No.", "Reference Typ",
                                                   "Reference No.", "Unit of Measure Code", "Transport Unit of Measure (TU)");
        IF vco_ItemNo <> '' THEN
            lrc_ItemTransportUnitFaktor.SETFILTER("Item No.", '%1|%2', vco_ItemNo, '');
        lrc_ItemTransportUnitFaktor.SETFILTER("Reference Typ", '%1|%2', vop_ReferenceTyp,
                                              lrc_ItemTransportUnitFaktor."Reference Typ"::" ");
        lrc_ItemTransportUnitFaktor.SETFILTER("Reference No.", '%1|%2', vco_ReferenceNo, '');
        lrc_ItemTransportUnitFaktor.SETFILTER("Unit of Measure Code", '%1|%2', vco_UnitOfMeasureCode, '');
        IF lrc_ItemTransportUnitFaktor.FINDLAST() THEN
            rco_TransportUnitOfMeasureCode := lrc_ItemTransportUnitFaktor."Transport Unit of Measure (TU)"
        ELSE BEGIN
            lrc_ItemTransportUnitFaktor.SETRANGE("Reference Typ", lrc_ItemTransportUnitFaktor."Reference Typ"::All);
            lrc_ItemTransportUnitFaktor.SETFILTER("Reference No.", '%1', '');
            IF lrc_ItemTransportUnitFaktor.FIND('+') THEN
                rco_TransportUnitOfMeasureCode := lrc_ItemTransportUnitFaktor."Transport Unit of Measure (TU)"
            ELSE
                IF vco_UnitOfMeasureCode <> '' THEN
                    IF lrc_UnitofMeasure.GET(vco_UnitOfMeasureCode) THEN
                        IF lrc_UnitofMeasure."POI Transp. Unit of Meas (TU)" <> '' THEN
                            rco_TransportUnitOfMeasureCode := lrc_UnitofMeasure."POI Transp. Unit of Meas (TU)";
        END;
    end;

    procedure GetEmptyItemPalletFactor(vco_TransportUnit: Code[10]; vco_ItemNo: Code[20]; vco_EmptyItemNo: Code[20]): Decimal

    begin
        lrc_ColliFactorTranspUnit.SETRANGE("Transport Unit of Measure (TU)", vco_TransportUnit);
        lrc_ColliFactorTranspUnit.SETFILTER("Item No.", '%1|%2', vco_ItemNo, '');
        lrc_ColliFactorTranspUnit.SETRANGE("Empty Item No.", vco_EmptyItemNo);
        IF lrc_ColliFactorTranspUnit.FINDFIRST() THEN
            EXIT(lrc_ColliFactorTranspUnit."Qty. (Unit) per Transp. Unit");
        EXIT(0);
    end;

    var
        lrc_ItemUnitOfMeasure: Record "Item Unit of Measure";
        lrc_UnitofMeasure: Record "Unit of Measure";
        lrc_ItemTransportUnitFaktor: Record "POI Factor Transport Unit";
        lrc_ColliFactorTranspUnit: Record "POI Factor Transport Unit";
}

