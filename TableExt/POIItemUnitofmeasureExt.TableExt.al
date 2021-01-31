tableextension 50038 "POI Item Unit of measure Ext" extends "Item Unit of Measure"
{
    fields
    {
        field(50000; "POI Material"; Code[10])
        {
            Caption = 'Material';
            DataClassification = CustomerContent;
        }
        field(50006; "POI Net Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Net Weight';
        }
        field(50007; "POI Gross Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Gross Weight';
        }
        field(50008; "POI Overpackaging"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Umverpackungscode';
            TableRelation = "Unit of Measure".Code where("POI Is Collo Unit of Measure" = const(true));
            trigger OnValidate()
            begin
                if UnitOfMeasure.Get("POI Overpackaging") then
                    "POI Weight of Packaging" := UnitOfMeasure."POI Weight of Packaging";
            end;
        }
        field(50009; "POI Overpckaging Content"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Anzahl Einheiten in Umverpackung';
        }
        field(5110302; "POI Weight of Packaging"; Decimal)
        {
            Caption = 'Gewicht der Verpackung';

            trigger OnValidate()
            begin
                IF "POI Weight of Packaging" <> 0 THEN
                    IF ("POI Net Weight" = 0) AND ("POI Gross Weight" <> 0) THEN
                        "POI Net Weight" := "POI Gross Weight" - "POI Weight of Packaging"
                    ELSE
                        IF ("POI Net Weight" <> 0) AND ("POI Gross Weight" = 0) THEN
                            "POI Gross Weight" := "POI Net Weight" + "POI Weight of Packaging";

            end;
        }
        field(5110310; "POI Kind of Unit of Measure"; Option)
        {
            Caption = 'Kind of Unit of Measure';
            Description = ' ,Base Unit,Content Unit,Packing Unit,Collo Unit,Transport Unit,,,Weight Unit';
            OptionCaption = ' ,Base Unit,Content Unit,Packing Unit,Collo Unit,Transport Unit,,,Weight Unit';
            OptionMembers = " ","Base Unit","Content Unit","Packing Unit","Collo Unit","Transport Unit",,,"Weight Unit";
        }
        field(5110335; "POI Empties Item No."; Code[20])
        {
            Caption = 'Empties Item No.';
            TableRelation = Item WHERE("POI Item Typ" = FILTER("Empties Item" | "Transport Item"));

            trigger OnValidate()
            begin
                IF "POI Empties Item No." <> xRec."POI Empties Item No." then
                    IF "POI Empties Item No." <> '' THEN
                        "POI Empties Quantity" := 1
                    ELSE
                        "POI Empties Quantity" := 0;
            end;
        }
        field(5110336; "POI Empties Quantity"; Decimal)
        {
            Caption = 'Empties Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                if "POI Empties Quantity" > 0 then
                    TESTFIELD("POI Empties Item No.");
            end;
        }
    }

    var
        UnitOfMeasure: Record "Unit of Measure";
}