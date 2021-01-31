tableextension 50002 "POI SalespersonExt" extends "Salesperson/Purchaser"
{
    fields
    {
        field(50000; "POI Is Purchaser"; Boolean)
        {
            Caption = 'Is Purchaser';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                DimCode: Code[20];
            begin
                DimCode := 'EINKÄUFER';
                if "POI Is Purchaser" then
                    CheckAndCreateDimension(DimCode, Code);
                AccCompSynch.SynchTableField(13, FieldNo("POI Is Purchaser"), Code, "POI Is Purchaser", false, true);
            end;
        }
        field(50002; "POI Is Salesperson"; Boolean)
        {
            Caption = 'Is Salesperson';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                DimCode: Code[20];
            begin
                DimCode := 'VERKÄUFER';
                if "POI Is Salesperson" then
                    CheckAndCreateDimension(DimCode, Code);
                AccCompSynch.SynchTableField(13, FieldNo("POI Is Salesperson"), Code, "POI Is Salesperson", false, true);
            end;
        }
        field(50003; "POI Is Sales Agent Person"; Boolean)
        {
            Caption = 'Is Sales Agent Person';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                AccCompSynch.SynchTableField(13, FieldNo("POI Is Sales Agent Person"), Code, "POI Is Sales Agent Person", false, true);
            end;
        }
        field(50004; "POI Navision User ID Code"; Code[50])
        {
            Caption = 'Navision User ID Code';
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID";
            trigger OnValidate()
            begin
                AccCompSynch.SynchTableField(13, FieldNo("POI Navision User ID Code"), Code, "POI Navision User ID Code", false, true);
            end;
        }
        field(50005; "POI Is Person in Charge"; Boolean)
        {
            Caption = 'Is Person in Charge';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                AccCompSynch.SynchTableField(13, FieldNo("POI Is Person in Charge"), Code, "POI Is Person in Charge", false, true);
            end;
        }
        field(50006; "POI Department"; enum "POI Department")
        {
            Caption = 'Abteilung';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                AccCompSynch.SynchTableField(13, FieldNo("POI Department"), Code, "POI Department", false, true);
            end;
        }
        field(50007; "POI Company System Filter"; Code[50])
        {
            Caption = 'Company System Filter';
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                AccCompSynch.SynchTableField(13, FieldNo("POI Company System Filter"), Code, "POI Company System Filter", false, true);
            end;
        }
        modify("E-Mail")
        {
            trigger OnAfterValidate()
            begin
                AccCompSynch.SynchTableField(13, FieldNo("E-Mail"), Code, "E-Mail", false, true);
            end;
        }
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                AccCompSynch.SynchTableField(13, FieldNo(Name), Code, Name, false, true);
            end;
        }
        modify("Phone No.")
        {
            trigger OnAfterValidate()
            begin
                AccCompSynch.SynchTableField(13, FieldNo("Phone No."), Code, "Phone No.", false, true);
            end;
        }
        modify("Commission %")
        {
            trigger OnAfterValidate()
            begin
                AccCompSynch.SynchTableField(13, FieldNo("Commission %"), Code, "Commission %", false, true);
            end;
        }
    }

    trigger OnAfterInsert()
    var
        POICompany: Record "POI Company";
        TypeEnum: enum "POI VendorCustomer";

    begin
        AccCompSynch.SynchAccount(Code, TypeEnum::Salesperson, POICompany.Mandant);
    end;


    procedure CheckAndCreateDimension(DimCode: Code[20]; DimValue: Code[20])
    var
        Dimensionvalue: Record "Dimension Value";
    begin
        if not DimensionValue.Get(DimCode, Code) then begin
            DimensionValue.Init();
            DimensionValue."Dimension Code" := DimCode;
            DimensionValue.Code := DimValue;
            DimensionValue.Name := Name;
            DimensionValue.Insert();
        end;
    end;

    var
        AccCompSynch: Codeunit "POI Account Synchronisation";
}