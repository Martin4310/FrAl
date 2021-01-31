table 50953 "POI Quality Mgt Detail"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Nr.';
            DataClassification = CustomerContent;
        }
        field(2; "Source Type"; Option)
        {
            Caption = 'Herkunft Typ';
            OptionCaption = 'Vendor,Vendor Group,Customer,Customer Group';
            OptionMembers = Vendor,"Vendor Group",Customer,"Customer Group";
            DataClassification = CustomerContent;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Zeilennr.';
            DataClassification = CustomerContent;
        }
        field(10; Mandant; Code[50])
        {
            Caption = 'Mandant';
            DataClassification = CustomerContent;
            //Editable = false;
            TableRelation = "POI Company".Mandant;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(50953, 10, 2) then
                    ERROR(ERR_NoPermissionTxt);
            end;
        }
        field(20; Refund; Decimal)
        {
            Caption = 'Rückvergütung';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(50953, 20, 2) then
                    ERROR(ERR_NoPermissionTxt);
            end;
        }
        field(21; "Refund Approved"; Boolean)
        {
            Caption = 'Rückvergütung genehmigt';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunction.UserInRoleForCompany('GL', Mandant) then
                    Error('Keine Berechtigung für diesen Mandanten.');
            end;
        }
        field(30; "Credit Limit"; Decimal)
        {
            Caption = 'Kreditlimit';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(50953, 30, 2) then
                    ERROR(ERR_NoPermissionTxt);
                if "Credit Limit" <> xRec."Credit Limit" then begin
                    "Credit Limit Approved" := false;
                    "Credit Limit Valid To" := CalcDate('<+3M>', Today());
                end;
            end;
        }
        field(31; "Credit Limit Approved"; Boolean)
        {
            Caption = 'Kreditlimit genehmigt';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if POIFunction.UserInRoleForCompany('GL', Mandant) then begin
                    if "Credit Limit Approved" and ("Credit Limit Valid To" = 0D) then
                        Error('"Befristung bis:" muss gefüllt sein.');
                end else
                    Error('Keine Berechtigung für diesen Mandanten.');
            end;
        }
        field(32; "Credit Limit Valid To"; Date)
        {
            Caption = 'Befristung bis';
            DataClassification = CustomerContent;
        }
        field(40; "Person in Charge"; Code[20])
        {
            Caption = 'Sachbearbeiter';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser".Code where("POI Is Person in Charge" = const(true));
        }
        field(41; "Sales Person"; Code[20])
        {
            Caption = 'Verkäufer';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser".Code where("POI Is Salesperson" = const(true));
        }
        field(50; "Payment Terms"; Code[10])
        {
            Caption = 'Zahlungsbedingung';
            DataClassification = CustomerContent;
            TableRelation = "Payment Terms".Code;
        }
        field(60; "Internal Credit Limit"; Decimal)
        {
            Caption = 'Internes Kreditlimit';
            DataClassification = CustomerContent;
        }
        field(61; "Internal Credit limit approved"; Boolean)
        {
            Caption = 'Internes Kreditlimit und Befristung genehmigt';
            DataClassification = CustomerContent;
        }
        field(62; "Int. Credit limit valid until"; Date)
        {
            Caption = 'Internes Kreditlimit gültig bis:';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.", "Source Type", Mandant)
        {
            Clustered = true;
        }
    }

    var
        POIFunction: Codeunit POIFunction;
        ERR_NoPermissionTxt: Label 'Keine Berechtigung für Änderungen.';
}