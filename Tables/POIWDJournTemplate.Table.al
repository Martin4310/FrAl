table 50925 "POI W.D. Journ. Template"
{
    Caption = 'W.D. Journ. Template';
    //LookupFormID = Form5087910; //TODO: lookup page id

    fields
    {
        field(1; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(5; "Test Report ID"; Integer)
        {
            Caption = 'Test Report ID';
            TableRelation = Object.ID WHERE(Type = CONST(Report));
        }
        field(6; "Formular ID"; Integer)
        {
            Caption = 'Formular ID';
            TableRelation = Object.ID WHERE(Type = CONST(Page));

            // trigger OnValidate() //TODO: pages
            // begin
            //     IF "Formular ID" = 0 THEN
            //       "Formular ID" := FORM::"W.D. Journal";
            //     "Test Report ID" := REPORT::"W.D. Testreport";
            // end;
        }
        field(11; "Disposal of Waste Company"; Option)
        {
            Caption = 'Entsorgungsunternehmen';
            Description = 'DSD';
            OptionCaption = ' ,DSD,BellandVision,Interseroh,,,,,ARA';
            OptionMembers = " ",DSD,BellandVision,Interseroh,Edeka,Fruitness,"Belland Ratio","Belland Tegut",ARA,METRO;
        }
        field(15; "Name Test Report"; Text[30])
        {
            CalcFormula = Lookup (Object.Name WHERE(Type = CONST(Report),
                                                    ID = FIELD("Test Report ID")));
            Caption = 'Name Test Report';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Page Name"; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Object.Name WHERE(Type = CONST(Page),
                                                    ID = FIELD("Formular ID")));
            Caption = 'Page Name';
            Editable = false;

        }
    }

    keys
    {
        key(Key1; Name)
        {
        }
    }

    trigger OnDelete()
    begin
        DSDBuchBlZeile.SETRANGE("Journal Template Name", Name);
        DSDBuchBlZeile.DELETEALL();
        DSDBuchBlName.SETRANGE("Journal Template Name", Name);
        DSDBuchBlName.DELETEALL();
    end;

    trigger OnInsert()
    begin
        VALIDATE("Formular ID");
    end;

    var
        DSDBuchBlName: Record "POI W.D. Journ. Name";
        DSDBuchBlZeile: Record "POI W.D. Journ. Line Entry";
}

