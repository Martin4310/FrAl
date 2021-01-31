table 5110554 "POI Cost Calc. - Alloc. Batch"
{
    Caption = 'Cost Calc. - Alloc. Batch';

    fields
    {
        field(1; "Document No."; Integer)
        {
            Caption = 'Document No.';
        }
        field(8; "Document No. 2"; Code[20])
        {
            Caption = 'Document No. 2';
        }
        field(9; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
        }
        field(10; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
        }
        field(20; "Without Allocation"; Boolean)
        {
            Caption = 'Without Allocation';
        }
        field(21; "Allocation Key"; Option)
        {
            Caption = 'Allocation Key';
            OptionCaption = ' ,Colli,Pallets,Gross Weight,Lines,Net Weight,Amount';
            OptionMembers = " ",Colli,Pallets,"Gross Weight",Lines,"Net Weight",Amount;
        }
        field(50000; "Cost Category Code"; Code[20])
        {
            Caption = 'Kostenkategorie Code';
            TableRelation = "POI Cost Category";
        }
    }

    keys
    {
        key(Key1; "Document No.", "Batch No.")
        {
        }
    }


    trigger OnInsert()
    var
        lrc_CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
    begin
        //Kostenkategorie laden
        lrc_CostCalcEnterData.GET("Document No.");
        "Cost Category Code" := lrc_CostCalcEnterData."Cost Category Code";
    end;

    trigger OnModify()
    var
        lrc_CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
    begin
        //Kostenkategorie laden
        lrc_CostCalcEnterData.GET("Document No.");
        "Cost Category Code" := lrc_CostCalcEnterData."Cost Category Code";
    end;
}

