table 5110398 "POI Customer Group"
{
    Caption = 'Customer Group';
    // DrillDownFormID = Form5110308;
    // LookupFormID = Form5110308;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = false;
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(20; "Customer Main Group Code"; Code[10])
        {
            Caption = 'Customer Main Group Code';
            NotBlank = true;
            TableRelation = "POI Customer Main Group";
        }
        field(30; "Main Customer No."; Code[20])
        {
            Caption = 'Main Customer No.';
            Description = 'PVP';
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                IF "Main Customer No." <> '' THEN BEGIN
                    lrc_Customer.GET("Main Customer No.");
                    IF lrc_Customer."POI Customer Group Code" <> Code THEN BEGIN
                        lrc_Customer.VALIDATE("POI Customer Group Code", Code);
                        lrc_Customer.MODIFY(TRUE);
                    END;
                END;
            end;
        }
        field(40; "Control Indicator Dispolines"; Option)
        {
            Caption = 'Control Indicator Dispolines';
            Description = 'PVP';
            OptionCaption = 'Create Order,Reduce Purchase Order';
            OptionMembers = "Create Order","Reduce Purchase Order";
        }
        field(41; "Sales Doc. Subtype Code"; Code[10])
        {
            Caption = 'Sales Doc. Subtype Code';
            Description = 'PVP';
            TableRelation = "POI Sales Doc. Subtype".Code WHERE("Document Type" = CONST(Order));
        }
        field(42; "Sales Doc. Subtype Code OrdSpl"; Code[10])
        {
            Caption = 'Sales Doc. Subtype Code Order Splitting';
            Description = 'PVP';
            TableRelation = "POI Sales Doc. Subtype".Code WHERE("Document Type" = CONST(Order));
        }
        field(50; "Add. Value to Sales Price"; Decimal)
        {
        }
        field(51; "Add. Kind of Value"; Option)
        {
            OptionCaption = ' ,Amount,Percentage';
            OptionMembers = " ",Amount,Percentage;
        }
        field(50001; "E-Mail to Port"; Text[200])
        {
            Description = 'port.jst 20.2.12 5-SammelRG';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    trigger OnInsert()
    var
        lrc_DimensionValue: Record "Dimension Value";
    begin
        lrc_DimensionValue.INIT();
        lrc_DimensionValue."Dimension Code" := 'Debitorenhauptgruppe';
        lrc_DimensionValue.Code := Code;
        lrc_DimensionValue.Name := Description;
        lrc_DimensionValue.INSERT();
    end;

    trigger OnRename()
    begin
        ERROR('Sie dürfen die Debitorenhauptgruppe nicht umbenennen');
    end;

    var
        lrc_Customer: Record Customer;
}

