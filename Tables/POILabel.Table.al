table 5110702 "POI Label"
{
    Caption = 'Label';
    // DrillDownFormID = Form5110718;
    // LookupFormID = Form5110718;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(15; Usage; Option)
        {
            Caption = 'Usage';
            OptionCaption = ' ,Packing,,,Kollo,,,Transport,,,,,,,,,,,Other';
            OptionMembers = " ",Packing,,,Kollo,,,Transport,,,,,,,,,,,Other;
        }
        field(20; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(100; "Picture I"; BLOB)
        {
            Caption = 'Picture I';
        }
        field(101; "Picture II"; BLOB)
        {
            Caption = 'Picture II';
        }
        field(102; "Picture III"; BLOB)
        {
            Caption = 'Picture III';
        }
        field(103; "Picture IV"; BLOB)
        {
            Caption = 'Picture IV';
        }
        field(104; "Picture V"; BLOB)
        {
            Caption = 'Picture V';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    trigger OnDelete()
    var
    //lrc_RecipeLabels: Record "5110700";
    begin
        // lrc_RecipeLabels.Reset();//TODO: receipe labels
        // lrc_RecipeLabels.SETCURRENTKEY( "Doc. Line No. Output", "Label Code" );
        // lrc_RecipeLabels.SETRANGE( "Label Code", Code );
        // IF lrc_RecipeLabels.FIND('-') THEN
        //    lrc_RecipeLabels.DELETEALL( TRUE );
    end;
}

