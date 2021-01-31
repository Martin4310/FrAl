table 5110718 "POI Pack. Order Labels"
{

    Caption = 'Packing Order Labels';

    fields
    {
        field(1; "Doc. No."; Code[20])
        {
            Caption = 'Doc. No.';
            TableRelation = "POI Pack. Order Header"."No.";
        }
        field(2; "Doc. Line No. Output"; Integer)
        {
            Caption = 'Doc. Line No. Output';
            TableRelation = "POI Pack. Order Output Items"."Line No." WHERE("Doc. No." = FIELD("Doc. No."));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Label Code"; Code[10])
        {
            Caption = 'Label Code';
            TableRelation = "POI Label".Code;

            trigger OnValidate()
            var
                lrc_Label: Record "POI Label";
            begin
                IF lrc_Label.GET("Label Code") THEN BEGIN
                    "Label Description" := lrc_Label.Description;
                    "Label Usage" := lrc_Label.Usage;
                END ELSE BEGIN
                    "Label Description" := '';
                    "Label Usage" := "Label Usage"::" ";
                END;
            end;
        }
        field(10; "Label Description"; Text[50])
        {
            Caption = 'Label Description';
        }
        field(15; "Label Usage"; Option)
        {
            Caption = 'Label Usage';
            OptionCaption = ' ,Packing,,,Kollo,,,Transport,,,,,,,,,,,Other';
            OptionMembers = " ",Packing,,,Kollo,,,Transport,,,,,,,,,,,Other;
        }
        field(20; "Unit Of Measure Code"; Code[10])
        {
            Caption = 'Unit Of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Ref. Trade Item No."));
        }
        field(21; "Base Unit of Measure"; Boolean)
        {
            CalcFormula = Lookup ("Unit of Measure"."POI Is Base Unit of Measure" WHERE(Code = FIELD("Unit Of Measure Code")));
            Caption = 'Base Unit of Measure';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Packing Unit of Measure"; Boolean)
        {
            CalcFormula = Lookup ("Unit of Measure"."POI Is Packing Unit of Measure" WHERE(Code = FIELD("Unit Of Measure Code")));
            Caption = 'Packing Unit of Measure';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Collo Unit of Measure"; Boolean)
        {
            CalcFormula = Lookup ("Unit of Measure"."POI Is Collo Unit of Measure" WHERE(Code = FIELD("Unit Of Measure Code")));
            Caption = 'Collo Unit of Measure';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Transport Unit of Measure"; Boolean)
        {
            CalcFormula = Lookup ("Unit of Measure"."POI Is Transportation Unit" WHERE(Code = FIELD("Unit Of Measure Code")));
            Caption = 'Transport Unit of Measure';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Freight Unit of Measure"; Boolean)
        {
            CalcFormula = Lookup ("Unit of Measure"."POI Is Freight Unit of Measure" WHERE(Code = FIELD("Unit Of Measure Code")));
            Caption = 'Freight Unit of Measure';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        // field(26;"SAN-13 Unit of Measure";Boolean)
        // {
        //     CalcFormula = Lookup("Unit of Measure"."Is SAN-13 Unit of Measure" WHERE (Code=FIELD("Unit Of Measure Code")));
        //     Caption = 'SAN-13 Unit of Measure';
        //     Description = 'Flowfield';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(99; "Ref. Trade Item No."; Code[20])
        {
            Caption = 'Reference Trade Item No.';
            Editable = false;
            //TableRelation = Item."No." WHERE ("Item Typ"=CONST("Trade Item"));
        }
        field(200; Comment; Boolean)
        {
            CalcFormula = Exist ("POI Pack. Order Comment" WHERE("Doc. No." = FIELD("Doc. No."),
                                                             Type = CONST(Label),
                                                             "Source Line No." = FIELD("Line No.")));
            Caption = 'Comment';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        // field(250;"Production Line Code";Code[10])
        // {
        //     Caption = 'Production Line Code';
        //     TableRelation = "Production Lines".Code;

        //     trigger OnValidate()
        //     var
        //         lcu_RecipePackingManagement: Codeunit "5110700";
        //     begin
        //         lcu_RecipePackingManagement.CheckExistingPaProductionLine( "Doc. No.", "Production Line Code" );
        //     end;
        // }
    }

    keys
    {
        key(Key1; "Doc. No.", "Doc. Line No. Output", "Line No.")
        {
        }
        key(Key2; "Label Code")
        {
        }
        key(Key3; "Unit Of Measure Code")
        {
        }
    }

    trigger OnDelete()
    var
        lrc_PackOrderComment: Record "POI Pack. Order Comment";
    begin
        lrc_PackOrderComment.RESET();
        lrc_PackOrderComment.SETRANGE("Doc. No.", "Doc. No.");
        lrc_PackOrderComment.SETRANGE("Doc. Line No. Output", 0);
        lrc_PackOrderComment.SETRANGE(Type, lrc_PackOrderComment.Type::Label);
        lrc_PackOrderComment.SETRANGE("Source Line No.", "Line No.");
        IF lrc_PackOrderComment.FIND('-') THEN
            lrc_PackOrderComment.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");

        TESTFIELD("Doc. No.");
        lrc_PackOrderHeader.GET("Doc. No.");

        // IF "Production Line Code" = '' THEN
        //     "Production Line Code" := lrc_PackOrderHeader."Production Line Code"  //TODO: production line code
    end;

    trigger OnModify()
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");
    end;

    trigger OnRename()
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");
    end;

    // procedure ActualFromRecipeHeader(rrc_RecipeHeader: Record "5110710") //TODO: receipt labels
    // var
    //     lrc_RecipeLabels: Record "5110700";
    // begin
    //     lrc_RecipeLabels.Reset();
    //     lrc_RecipeLabels.SETRANGE("Recipe Code", rrc_RecipeHeader."No.");
    //     IF lrc_RecipeLabels.FIND('-') THEN
    //         REPEAT
    //             lrc_RecipeLabels.VALIDATE("Ref. Trade Item No.", rrc_RecipeHeader."Item No.");
    //             lrc_RecipeLabels.MODIFY(TRUE);
    //         UNTIL lrc_RecipeLabels.NEXT() = 0;
    // end;

    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
}

