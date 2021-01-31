table 50000 "POI Company"
{
    DataPerCompany = false;
    fields
    {
        field(1; "Mandant"; Code[50])
        {
            Caption = 'Mandant';
            DataClassification = CustomerContent;
            TableRelation = Company.Name;
        }

        field(2; "Synch Masterdata"; Boolean)
        {
            Caption = 'Synch Masterdata';
            DataClassification = CustomerContent;
        }
        field(3; "Company System ID"; Code[1])
        {
            Caption = 'Company System ID';
            DataClassification = CustomerContent;
        }
        field(4; "Diverse"; Boolean)
        {
            Caption = 'Diverse';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF CheckSingleAllowed(CurrFieldNo) then Error(ErrDiverseTxt);
            end;
        }
        field(5; "Small Vendor"; Boolean)
        {
            Caption = 'Small Vendor';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF CheckSingleAllowed(CurrFieldNo) then Error(ErrSmallCompanyTxt);
            end;
        }
        field(6; "Basic Company"; Boolean)
        {
            Caption = 'Basic Company';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF CheckSingleAllowed(CurrFieldNo) then Error(ErrBasicCompanyTxt);
            end;
        }
        field(7; Visible; Boolean)
        {
            Caption = 'Visible';
            DataClassification = CustomerContent;
        }
        field(8; "DMS aktiv"; Boolean)
        {
            Caption = 'DMS aktiv';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Mandant; "Mandant") { }
        key(Basic; "Basic Company") { }
    }

    procedure CheckSingleAllowed(FieldNo: Integer): Boolean
    var
        POICompany: Record "POI Company";
    begin
        case FieldNo of
            6:
                POICompany.SetRange("Basic Company", true);
            5:
                POICompany.SetRange("Small Vendor", true);
            4:
                POICompany.SetRange(Diverse, true);
            else
                exit(false)
        end;
        exit(POICompany.Count() > 0);
    end;

    procedure GetBasicCompany(): Text[50]
    begin
        Reset();
        SetCurrentKey("Basic Company");
        SetRange("Basic Company", true);
        if FindFirst() then
            exit(Mandant)
        else
            Error('kein Stamm Mandant vorhanden');
    end;

    var
        ErrDiverseTxt: Label 'Diverse Company kann nur einmal genutzt werden.';
        ErrSmallCompanyTxt: Label 'Small Company Company kann nur einmal genutzt werden.';
        ErrBasicCompanyTxt: Label 'Basic Company kann nur einmal genutzt werden.';
}