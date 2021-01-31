table 50943 "POI Item Unit of Meas Detail"
{
    Caption = 'POI Item Unit of Measure Detail';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
        field(2; "Unit of Measure"; Code[20])
        {
            Caption = 'Unit of Measure';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }
        field(4; "Overpacking Unit"; Code[20])
        {
            Caption = 'Overpacking Unit';
            DataClassification = CustomerContent;
            //TableRelation = "Unit of Measure".Code where("POI is Overpacking Unit" = const(true));
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
            trigger OnValidate()
            begin
                if ("Overpacking Unit" <> '') and ("Units per Overpacking Unit" = 0) then begin
                    ItemUnitOfMeasureOVP.Get("Item No.", "Overpacking Unit");
                    ItemUnitOfMeasure.Get("Item No.", "Unit of Measure");
                    "Units per Overpacking Unit" := Round(ItemUnitOfMeasureOVP."Qty. per Unit of Measure" / ItemUnitOfMeasure."Qty. per Unit of Measure", 1, '<');
                    "OVP Empties Item No." := ItemUnitOfMeasureOVP."POI Empties Item No.";
                end;
            end;
        }
        field(5; "Units per Overpacking Unit"; Integer)
        {
            Caption = 'Units per Overpacking Unit';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; "OVP Empties Item No."; Code[20])
        {
            Caption = 'Overpacking Empties Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item."No." where("POI Item Typ" = const("Empties Item"));
        }
        field(7; "Palet Code"; Code[20])
        {
            Caption = 'Palettencode';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure".Code where("POI Is Transportation Unit" = const(true));
            trigger OnValidate()
            begin
                if "Palet Code" <> '' then begin
                    if ItemUnitOfMeasure.Get("Item No.", "Palet Code") then
                        "Units per Palet" := POIFunction.CountUnitPerPalet("Palet Code", "Unit of Measure", ItemUnitOfMeasure.Height)
                end else
                    "Units per Palet" := 0;
            end;
        }
        field(8; "Units per Palet"; Integer)
        {
            Caption = 'Einheiten pro Palette';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Item No.", "Unit of Measure", "Overpacking Unit")
        {
            Clustered = true;
        }
    }
    var
        ItemUnitOfMeasureOVP: Record "Item Unit of Measure";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        POIFunction: Codeunit POIFunction;

}
