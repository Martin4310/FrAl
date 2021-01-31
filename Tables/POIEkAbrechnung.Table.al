table 50936 "POI EK-Abrechnung"
{

    fields
    {
        field(50000; Bestellnummer; Code[20])
        {
            TableRelation = "Purchase Header"."No.";
        }
        field(50001; Zeilennummer; Integer)
        {
        }
        field(50006; Positionsnummer; Code[20])
        {
            TableRelation = "POI Batch"."No." WHERE("Master Batch No." = FIELD(Bestellnummer));

            trigger OnValidate()
            var
                batchno: Record "POI Batch";
            begin
                batchno.GET(Positionsnummer);
                Beschreibung := batchno."Item Description";
                IF PurchaseLine.GET(PurchaseLine."Document Type"::Order, batchno."Source No.", batchno."Source Line No.") THEN
                    "keinRg-Rabatt" := NOT PurchaseLine."Allow Invoice Disc.";
            end;
        }
        field(50007; Beschreibung; Text[100])
        {
        }
        field(50010; "keinRg-Rabatt"; Boolean)
        {

            trigger OnValidate()
            begin
                Gesamtpreis := Abrechnungspreis * Abrechnungsmenge;
                IF "keinRg-Rabatt" THEN BEGIN
                    "FAS Line Disc. Amount" := 0;
                    "FAS Line Amount" := Gesamtpreis;
                END ELSE BEGIN
                    PurchLine.RESET();
                    PurchLine.SETRANGE("Document No.", Bestellnummer);
                    PurchLine.SETRANGE("POI Batch Variant No.", Positionsnummer);
                    IF PurchLine.FIND('-') THEN
                        IF PurchLine."Line Amount" <> 0 THEN
                            "FAS Line Disc. Amount" := Gesamtpreis * (PurchLine."Inv. Discount Amount" / PurchLine."Line Amount");
                    "FAS Line Amount" := Gesamtpreis - "FAS Line Disc. Amount";
                END;
                FASTotalAmount := 0;
                IF NOT "keinRg-Rabatt" THEN BEGIN
                    EKAbrechnung.RESET();
                    EKAbrechnung.SETRANGE(Bestellnummer, Bestellnummer);
                    IF EKAbrechnung.FINDSET() THEN
                        REPEAT
                            PurchLine.RESET();
                            PurchLine.SETRANGE("Document No.", Bestellnummer);
                            PurchLine.SETRANGE("POI Batch Variant No.", Positionsnummer);
                            IF PurchLine.FIND('-') THEN;
                            IF PurchLine."Line Amount" <> 0 THEN
                                EKAbrechnung."FAS Line Disc. Amount" :=
                                  EKAbrechnung.Gesamtpreis * (PurchLine."Inv. Discount Amount" / PurchLine."Line Amount");
                            FASTotalAmount := FASTotalAmount + (EKAbrechnung.Gesamtpreis - EKAbrechnung."FAS Line Disc. Amount");
                        UNTIL EKAbrechnung.NEXT() = 0
                END ELSE BEGIN
                    EKAbrechnung.RESET();
                    EKAbrechnung.SETRANGE(Bestellnummer, Bestellnummer);
                    IF EKAbrechnung.FINDSET() THEN
                        REPEAT
                            FASTotalAmount := FASTotalAmount + (EKAbrechnung.Gesamtpreis);
                        UNTIL EKAbrechnung.NEXT() = 0;
                END;
                "FAS Line Amount" := FASTotalAmount;
            end;
        }
        field(50020; Abrechnungsmenge; Decimal)
        {

            trigger OnValidate()
            begin
                IF Abrechnungsmenge < 0 THEN
                    "keinRg-Rabatt" := TRUE;
                Gesamtpreis := Abrechnungspreis * Abrechnungsmenge;
                IF "keinRg-Rabatt" THEN BEGIN
                    "FAS Line Disc. Amount" := 0;
                    "FAS Line Amount" := Gesamtpreis;
                END ELSE BEGIN
                    PurchLine.RESET();
                    PurchLine.SETRANGE("Document No.", Bestellnummer);
                    PurchLine.SETRANGE("POI Batch Variant No.", Positionsnummer);
                    IF PurchLine.FIND('-') THEN
                        IF PurchLine."Line Amount" <> 0 THEN
                            "FAS Line Disc. Amount" := Gesamtpreis * (PurchLine."Inv. Discount Amount" / PurchLine."Line Amount");
                    "FAS Line Amount" := Gesamtpreis - "FAS Line Disc. Amount";
                END;
            end;
        }
        field(50021; Abrechnungspreis; Decimal)
        {

            trigger OnValidate()
            begin
                IF Abrechnungspreis < 0 THEN
                    "keinRg-Rabatt" := TRUE;
                Gesamtpreis := Abrechnungspreis * Abrechnungsmenge;
                IF "keinRg-Rabatt" THEN BEGIN
                    "FAS Line Disc. Amount" := 0;
                    "FAS Line Amount" := Gesamtpreis;
                END ELSE BEGIN
                    PurchLine.RESET();
                    PurchLine.SETRANGE("Document No.", Bestellnummer);
                    PurchLine.SETRANGE("POI Batch Variant No.", Positionsnummer);
                    IF PurchLine.FIND('-') THEN
                        IF PurchLine."Line Amount" <> 0 THEN
                            "FAS Line Disc. Amount" := Gesamtpreis * (PurchLine."Inv. Discount Amount" / PurchLine."Line Amount");
                    "FAS Line Amount" := Gesamtpreis - "FAS Line Disc. Amount";
                END;
            end;
        }
        field(50023; Gesamtpreis; Decimal)
        {
        }
        field(50024; "FAS Line Disc. Amount"; Decimal)
        {
            Caption = 'Zeilenrabattbetrag';
        }
        field(50025; "FAS Line Amount"; Decimal)
        {
            Caption = 'Zeilenbetrag';
        }
    }

    keys
    {
        key(Key1; Bestellnummer, Zeilennummer)
        {
        }
    }

    var
        PurchLine: Record "Purchase Line";
        EKAbrechnung: Record "POI EK-Abrechnung";
        PurchaseLine: Record "Purchase Line";
        FASTotalAmount: Decimal;
}

