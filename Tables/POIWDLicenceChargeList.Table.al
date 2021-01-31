table 50921 "POI W.D. Licence Charge List"
{
    Caption = 'W.D. Licence Charge List';
    //LookupPageId = Form5087903;//TODO:lookupageID

    fields
    {
        field(1; "Category Code"; Code[20])
        {
            Caption = 'Category Code';
            TableRelation = "POI W.D. Category";

            trigger OnValidate()
            begin
                lrc_DSDKategorie.SETRANGE(lrc_DSDKategorie.Code, "Category Code");
                IF lrc_DSDKategorie.FIND('-') THEN BEGIN
                    Description := lrc_DSDKategorie.Description;
                    CASE lrc_DSDKategorie.Type OF
                        lrc_DSDKategorie.Type::Gewicht:
                            "Charge Type" := "Charge Type"::"Gewichtsentgelt (Kg)";
                        lrc_DSDKategorie.Type::Volumen:
                            "Charge Type" := "Charge Type"::"Stückentgelt Volumen (Stk.)";
                        lrc_DSDKategorie.Type::Fläche:
                            "Charge Type" := "Charge Type"::"Stückentgelt Fläche (Stk.)";
                    END;
                END;
            end;
        }
        field(2; "Valid from"; Date)
        {
            Caption = 'Valid from';
        }
        field(3; "Charge Type"; Option)
        {
            Caption = 'Charge Type';
            OptionCaption = 'Gewichtsentgelt (Kg),Stückentgelt Volumen (Stk.),Stückentgelt Fläche (Stk.)';
            OptionMembers = "Gewichtsentgelt (Kg)","Stückentgelt Volumen (Stk.)","Stückentgelt Fläche (Stk.)";
        }
        field(4; "Cent per Kg or Piece"; Decimal)
        {
            Caption = 'Cent per Kg or Piece';
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(10; "Disposal Company"; Option)
        {
            Caption = 'Disposal Company';
            OptionCaption = ' ,DSD,BellandVision,Interseroh,Edeka,Fruitness,Belland Ratio,Belland Tegut,ARA,METRO';
            OptionMembers = " ",DSD,BellandVision,Interseroh,Edeka,Fruitness,"Belland Ratio","Belland Tegut",ARA,METRO;
        }
    }

    keys
    {
        key(Key1; "Disposal Company", "Category Code", "Charge Type", "Valid from")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Valid from" = 0D THEN
            ERROR(text0004Txt);
    end;

    var
        lrc_DSDKategorie: Record "POI W.D. Category";
        //text0003Txt: Label 'Sie haben einen weiteren Datensatz mit der Kategorie %1 angelegt. \Bitte füllen Sie erst das Feld "Gültig bis" des alten Datensatzes. ';
        text0004Txt: Label 'Bitte Feld "gültig ab" füllen';
}

