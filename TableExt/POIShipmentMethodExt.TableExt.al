tableextension 50042 "POI Shipment Method Ext" extends "Shipment Method"
{
    fields
    {
        field(50000; "POI Abholung"; Boolean)
        {
            Caption = 'Abholung';
            DataClassification = CustomerContent;
        }
        field(50001; "POI geliefert"; Boolean)
        {
            Caption = 'geliefert';
            DataClassification = CustomerContent;
        }
        field(50002; "POI verzollt"; Boolean)
        {
            Caption = 'verzollt';
            DataClassification = CustomerContent;
        }
        field(50003; "POI aktiv"; Boolean)
        {
            Caption = 'aktiv';
            DataClassification = CustomerContent;
        }
        field(5110301; "POI Incl. Freig to Final Loc."; Boolean)
        {
            Caption = 'Incl. Freight to Final Loc.';
            Description = 'FV';
        }
        field(5110302; "POI Duty Paid"; Boolean)
        {
            Caption = 'Duty Paid';
            Description = 'FV';
        }
        field(5110303; "POI Self-Collector"; Boolean)
        {
            Caption = 'Self-Collector';
            Description = 'FV';

            trigger OnValidate()
            begin
                "POI Incl. Freig to Final Loc." := FALSE;
                "POI Incl. Freig to Transf Loc." := FALSE;
            end;
        }
        field(5110305; "POI Incl. Freig to Transf Loc."; Boolean)
        {
            Caption = 'Incl. Freight to Transfer Loc.';
        }
    }
    trigger OnBeforeInsert()
    begin
        IF not POIFunction.UserInWindowsRole('FIBU') then
            Error(NoPermissionTxt);
    end;

    trigger OnBeforeModify()
    begin
        IF not POIFunction.UserInWindowsRole('FIBU') then
            Error(NoPermissionTxt);
    end;

    var

        POIFunction: Codeunit POIFunction;
        NoPermissionTxt: Label 'Keine Berechtigung zum Anlegen oder Ändern von Daten.';

}