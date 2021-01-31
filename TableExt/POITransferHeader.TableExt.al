tableextension 50032 "POI Transfer Header" extends "Transfer Header"
{
    fields
    {
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
        field(50001; "POI Arrival Region Code"; Code[20])
        {
            Caption = 'Arrival Region Code';
            TableRelation = "POI Departure Region" where(RegionType = const(Arrival));
            trigger OnValidate()
            begin
                if "POI Departure Region Code" <> xRec."POI Departure Region Code" then
                    HandleTour();
            end;
        }
        field(50004; "POI Tour"; Code[20])
        {
            Caption = 'Tour';
            DataClassification = CustomerContent;
            TableRelation = "POI Tour"."Tour Code";
        }
        field(5110310; "POI Transfer Doc. Subtype Code"; Code[10])
        {
            Caption = 'Transfer Doc. Subtype Code';
            TableRelation = "POI Transfer Doc. Subtype".Code WHERE("In Selection" = CONST(true));

            trigger OnValidate()
            var
                lrc_TransferLine: Record "Transfer Line";
                lrc_TransferDocType: Record "POI Transfer Doc. Subtype";
            begin
                //gcu_TransferMgt.CheckIfManualEditable("No.", "POI Transfer Doc. Subtype Code"); //TODO: Transfer Management

                TESTFIELD("No.");
                lrc_TransferLine.SETRANGE("Document No.", "No.");
                lrc_TransferLine.SETFILTER("Item No.", '<>%1', '');
                IF not lrc_TransferLine.IsEmpty() THEN
                    // Es sind bereits Umlagerungszeilen vorhanden!
                    ERROR(AGILES_TEXT002Txt);

                IF "POI Transfer Doc. Subtype Code" <> '' THEN BEGIN
                    lrc_TransferDocType.GET("POI Transfer Doc. Subtype Code");
                    lrc_TransferDocType.TESTFIELD("From Location Code");
                    lrc_TransferDocType.TESTFIELD("To Location Code");
                    lrc_TransferDocType.TESTFIELD("Transit Location Code");
                    VALIDATE("Transfer-from Code", lrc_TransferDocType."From Location Code");
                    VALIDATE("Transfer-to Code", lrc_TransferDocType."To Location Code");
                    VALIDATE("In-Transit Code", lrc_TransferDocType."Transit Location Code");
                    // Erneut setzen da teilweise das Transitlager wieder leer ist
                    "In-Transit Code" := lrc_TransferDocType."Transit Location Code";
                    VALIDATE("Shipping Agent Code", lrc_TransferDocType."Shipping Agent Code");
                    // Lieferbedingung aus Umlagerungsbelegunterart vorbelegen
                    VALIDATE("Shipment Method Code", lrc_TransferDocType."Shipment Method Code");
                END ELSE BEGIN
                    VALIDATE("Transfer-from Code", '');
                    VALIDATE("Transfer-to Code", '');
                    VALIDATE("In-Transit Code", '');
                    VALIDATE("Shipping Agent Code", '');
                    VALIDATE("Shipment Method Code", '');
                END;
            end;
        }
        field(5110650; "POI Scanner User ID"; Code[20])
        {
            Caption = 'Scanner User ID';
        }
    }
    procedure HandleTour()
    var
        Tour: Record "POI Tour";
    begin
        if ("POI Departure Region Code" <> '') and ("POI Arrival Region Code" <> '') then
            Tour.UpdateTour("POI Tour");
    end;

    var
        AGILES_TEXT002Txt: Label 'Es sind bereits Umlagerungszeilen vorhanden!';
}