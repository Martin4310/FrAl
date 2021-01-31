table 5110712 "POI Pack. Order Header"
{
    Caption = 'Pack. Order Header';
    // DrillDownFormID = Form5110729;
    // LookupFormID = Form5110729;
    PasteIsValid = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(8; Priority; Code[10])
        {
            Caption = 'Priority';
        }
        field(9; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Packing Order,,,Sorting Order,,,Substitution Order';
            OptionMembers = "Packing Order",,,"Sorting Order",,,"Substitution Order";
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Item: Record Item;
                //FruitVisionSetup: Record "POI ADF Setup";
                BaseDataMgt: Codeunit "POI BDM Base Data Mgmt";
            //lco_No: Code[20];
            //lrc_RecipeHeader: Record "5110710";
            //AGILESText01Txt: Label 'Es existiert ein freigegebenes Rezept %1, soll dieses verwendet werden ?';
            //AGILESText02Txt: Label 'Es existieren %1 freigegebene Rezepte, Outputzeilen werden nicht generiert !';
            //AGILESText03Txt: Label 'Es werden keine Outputzeilen generiert !';
            begin

                SetItemAttributeForOutput();

                BaseDataMgt.ItemValidateSearch("Item No.", TRUE, 2, TODAY(), '', FALSE, '');
                IF "Item No." = '' THEN BEGIN
                    Description := '';
                    "Description 2" := '';
                    EXIT;
                END;


                IF Item.GET("Item No.") THEN BEGIN
                    Description := Item.Description;
                    "Description 2" := Item."Description 2";
                    VALIDATE("Unit of Measure Code", Item."Sales Unit of Measure");

                    //     IF ("Recipe Code" = '') THEN BEGIN
                    //         lrc_RecipeHeader.Reset();
                    //         lrc_RecipeHeader.SETRANGE("Item No.", "Item No.");
                    //         lrc_RecipeHeader.SETRANGE(Status, lrc_RecipeHeader.Status::Released);
                    //         IF lrc_RecipeHeader.FINDSET() THEN BEGIN
                    //             IF lrc_RecipeHeader.COUNT() = 1 THEN BEGIN
                    //                 IF FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE' THEN BEGIN
                    //                     VALIDATE("Recipe Code", lrc_RecipeHeader."No.");
                    //                     UpdateOutputLine();
                    //                 END ELSE BEGIN
                    //                     IF CONFIRM(AGILESText01Txt, TRUE, lrc_RecipeHeader."No.") THEN BEGIN
                    //                         VALIDATE("Recipe Code", lrc_RecipeHeader."No.");
                    //                         UpdateOutputLine();
                    //                     END ELSE BEGIN
                    //                         MESSAGE(AGILESText03Txt);
                    //                     END;
                    //                 END;
                    //             END ELSE BEGIN
                    //                 MESSAGE(AGILESText02Txt, lrc_RecipeHeader.COUNT());
                    //             END;
                    //         END ELSE
                    //             UpdateOutputLine();
                    //     END ELSE
                    //         UpdateOutputLine();
                END;

            end;
        }
        field(12; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(13; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(15; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                lrc_Customer: Record Customer;
            begin
                // Unternehmenskette zuordnen
                IF "Customer No." <> '' THEN BEGIN
                    lrc_Customer.GET("Customer No.");
                    "Chain Name" := lrc_Customer."Chain Name";
                END;
            end;
        }
        field(16; "Customer Name"; Text[50])
        {
            CalcFormula = Lookup (Customer.Name WHERE("No." = FIELD("Customer No.")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Pack. Doc. Type Code"; Code[10])
        {
            Caption = 'Pack. Doc. Type Code';
            //TableRelation = "Pack. Doc. Subtype".Code;
        }
        field(19; "Recipe Code"; Code[10])
        {
            Caption = 'Rezepturcode';
            //TableRelation = "Recipe Header";

            // trigger OnValidate()
            // var
            //     lrc_RecipeHeader: Record "5110710";
            //     lrc_RecipeOutputItems: Record "5110708";
            //     lrc_RecipeInputItems: Record "5110706";
            //     lrc_RecipeInputPackingItems: Record "5110704";
            //     lrc_RecipeLabels: Record "5110700";
            //     lrc_RecipeComment: Record "5110707";
            //     lrc_RecipeInputCost: Record "5110705";
            //     lrc_RecipeProductionLines: Record "5110709";
            //     lrc_PackOrderInputCosts: Record "5110716";
            //     lrc_PackOrderInputItems: Record "5110714";
            //     lrc_PackOrderOutputItems: Record "5110713";
            //     lrc_PackOrderComment: Record "5110719";
            //     lrc_PackOrderInputPackItems: Record "5110715";
            //     lrc_PackOrderLabels: Record "5110718";
            //     lrc_PackOrderProductionLines: Record "5110720";
            //     lin_LastLineNo: Integer;
            //     lin_LastLineNo2: Integer;
            //     lin_NextCommentLineNo: Integer;
            //     lrc_PrintCommentHeader: Record "5110746";
            //     lrc_PrintCommentLine: Record "5110747";
            //     lrc_PrintCommentDoc: Record "5110748";
            // begin
            //     IF ("Recipe Code" <> '') AND
            //        ("Recipe Code" <> xRec."Recipe Code") THEN BEGIN

            //         lrc_RecipeHeader.GET("Recipe Code");

            //         IF lrc_RecipeHeader."Pack.-by Vendor No." <> '' THEN BEGIN
            //             VALIDATE("Pack.-by Vendor No.", lrc_RecipeHeader."Pack.-by Vendor No.");
            //         END;
            //         //Automatik Karton übernehmen
            //         "Pack. Cost incl. Packing Item" := lrc_RecipeHeader."Pack. Cost incl. Packing Item";

            //         lrc_RecipeOutputItems.Reset();
            //         lrc_RecipeOutputItems.SETRANGE("Recipe No.", "Recipe Code");

            //         lrc_RecipeOutputItems.SETFILTER("Location Code", '<>%1', '');
            //         IF lrc_RecipeOutputItems.FIND('-') THEN BEGIN
            //             VALIDATE("Outp. Item Location Code", lrc_RecipeOutputItems."Location Code");
            //         END;

            //         lrc_RecipeInputPackingItems.Reset();
            //         lrc_RecipeInputPackingItems.SETRANGE("Recipe No.", "Recipe Code");
            //         lrc_RecipeInputPackingItems.SETFILTER("Customer No.", '%1|%2', "Customer No.", '');
            //         lrc_RecipeInputPackingItems.SETFILTER("Location Code", '<>%1', '');
            //         IF lrc_RecipeInputPackingItems.FIND('-') THEN BEGIN
            //             VALIDATE("Inp. Packing Item Loc. Code", lrc_RecipeInputPackingItems."Location Code");
            //         END;
            //         "Qty Items" := lrc_RecipeHeader."Qty Items";
            //         Modify();
            //         COMMIT;

            //         "Programm No." := lrc_RecipeHeader."Programm No.";

            //         // Produktionslinien kopieren
            //         lrc_RecipeProductionLines.Reset();
            //         lrc_RecipeProductionLines.SETRANGE("Recipe No.", "Recipe Code");
            //         IF lrc_RecipeProductionLines.FIND('-') THEN BEGIN
            //             lrc_RecipeProductionLines.SETRANGE(Default, TRUE);
            //             IF lrc_RecipeProductionLines.FIND('-') THEN BEGIN
            //                 VALIDATE("Production Line Code", lrc_RecipeProductionLines."Productionline Code");
            //             END ELSE BEGIN
            //                 lrc_RecipeProductionLines.SETRANGE(Default);
            //                 IF lrc_RecipeProductionLines.COUNT() = 1 THEN BEGIN
            //                     VALIDATE("Production Line Code", lrc_RecipeProductionLines."Productionline Code");
            //                 END;
            //             END;
            //         END;


            //         // Bemerkung Packereiauftrag
            //         lrc_RecipeComment.Reset();
            //         lrc_RecipeComment.SETRANGE("Recipe Code", "Recipe Code");
            //         lrc_RecipeComment.SETRANGE("Doc. Line No. Output", 0);
            //         lrc_RecipeComment.SETRANGE(Type, lrc_RecipeComment.Type::"Packing Order");
            //         lrc_RecipeComment.SETRANGE("Source Line No.", 0);
            //         IF lrc_RecipeComment.FIND('-') THEN BEGIN
            //             lrc_PackOrderComment.Reset();
            //             lrc_PackOrderComment.SETRANGE("Doc. No.", "No.");
            //             lrc_PackOrderComment.SETRANGE("Doc. Line No. Output", 0);
            //             lrc_PackOrderComment.SETRANGE(Type, lrc_PackOrderComment.Type::"Packing Order");
            //             lrc_PackOrderComment.SETRANGE("Source Line No.", 0);
            //             lin_NextCommentLineNo := 0;
            //             IF lrc_PackOrderComment.FIND('+') THEN
            //                 lin_NextCommentLineNo := lrc_PackOrderComment."Line No.";

            //             REPEAT
            //                 lin_NextCommentLineNo := lin_NextCommentLineNo + 10000;
            //                 lrc_PackOrderComment.Reset();
            //                 lrc_PackOrderComment.INIT();
            //                 lrc_PackOrderComment.VALIDATE("Doc. No.", "No.");
            //                 lrc_PackOrderComment.VALIDATE("Doc. Line No. Output", 0);
            //                 lrc_PackOrderComment.VALIDATE(Type, lrc_PackOrderComment.Type::"Packing Order");
            //                 lrc_PackOrderComment.VALIDATE("Source Line No.", lrc_RecipeComment."Source Line No.");
            //                 lrc_PackOrderComment.VALIDATE("Line No.", lin_NextCommentLineNo);
            //                 lrc_PackOrderComment.VALIDATE(Date, lrc_RecipeComment.Date);
            //                 lrc_PackOrderComment.VALIDATE(Comment, lrc_RecipeComment.Comment);
            //                 lrc_PackOrderComment.INSERT(TRUE);
            //             UNTIL lrc_RecipeComment.NEXT() = 0;
            //         END;


            //         //Bemerkungen Rezeptur
            //         lrc_PrintCommentHeader.Reset();
            //         lrc_PrintCommentHeader.SETRANGE(Source, lrc_PrintCommentHeader.Source::Recipie);
            //         lrc_PrintCommentHeader.SETRANGE("Source No.", "Recipe Code");

            //         IF lrc_PrintCommentHeader.FIND('-') THEN BEGIN
            //             lrc_PrintCommentLine.Reset();
            //             lrc_PrintCommentLine.SETRANGE("Print Comment Code", lrc_PrintCommentHeader."Print Comment Code");
            //             IF lrc_PrintCommentLine.FIND('-') THEN BEGIN
            //                 lin_NextCommentLineNo := 0;
            //                 REPEAT
            //                     lin_NextCommentLineNo := lin_NextCommentLineNo + 10000;
            //                     lrc_PackOrderComment.Reset();
            //                     lrc_PackOrderComment.INIT();
            //                     lrc_PackOrderComment.VALIDATE("Doc. No.", "No.");
            //                     lrc_PackOrderComment.VALIDATE("Doc. Line No. Output", 0);
            //                     lrc_PackOrderComment.VALIDATE(Type, lrc_PackOrderComment.Type::"Packing Order");
            //                     lrc_PackOrderComment.VALIDATE("Source Line No.", lrc_RecipeComment."Source Line No.");
            //                     lrc_PackOrderComment.VALIDATE("Line No.", lin_NextCommentLineNo);
            //                     lrc_PackOrderComment.VALIDATE(Date, lrc_RecipeComment.Date);
            //                     lrc_PackOrderComment.VALIDATE(Comment, lrc_PrintCommentLine.Comment);
            //                     lrc_PackOrderComment.INSERT(TRUE);

            //                 UNTIL lrc_PrintCommentLine.NEXT(1) = 0;
            //             END;
            //         END;


            //         // Produktionslinien kopieren
            //         lrc_RecipeProductionLines.Reset();
            //         lrc_RecipeProductionLines.SETRANGE("Recipe No.", "Recipe Code");
            //         IF lrc_RecipeProductionLines.FIND('-') THEN BEGIN

            //             lrc_PackOrderProductionLines.Reset();
            //             lrc_PackOrderProductionLines.SETRANGE("Doc. No.", "No.");
            //             IF lrc_PackOrderProductionLines.FIND('-') THEN BEGIN
            //                 REPEAT
            //                     IF lrc_PackOrderProductionLines.DELETE(TRUE) THEN;
            //                 UNTIL lrc_PackOrderProductionLines.NEXT() = 0;
            //             END;

            //             IF lrc_PackOrderProductionLines.FIND('+') THEN BEGIN
            //                 lin_LastLineNo := lrc_PackOrderProductionLines."Line No.";
            //             END ELSE BEGIN
            //                 lin_LastLineNo := 0;
            //             END;

            //             REPEAT

            //                 lin_LastLineNo := lin_LastLineNo + 10000;

            //                 lrc_PackOrderProductionLines.INIT();
            //                 lrc_PackOrderProductionLines.VALIDATE("Doc. No.", "No.");
            //                 lrc_PackOrderProductionLines.VALIDATE("Line No.", lin_LastLineNo);
            //                 lrc_PackOrderProductionLines.VALIDATE("Production Line Code", lrc_RecipeProductionLines."Productionline Code");
            //                 lrc_PackOrderProductionLines.VALIDATE("Production Line Description",
            //                                                        lrc_RecipeProductionLines."Productionline Description");
            //                 lrc_PackOrderProductionLines.VALIDATE(Default, lrc_RecipeProductionLines.Default);
            //                 lrc_PackOrderProductionLines.INSERT(TRUE);

            //                 // Bemerkung Produktionslinie
            //                 lrc_RecipeComment.Reset();
            //                 lrc_RecipeComment.SETRANGE("Recipe Code", "Recipe Code");
            //                 lrc_RecipeComment.SETRANGE("Doc. Line No. Output", 0);
            //                 lrc_RecipeComment.SETRANGE(Type, lrc_RecipeComment.Type::Productionlines);
            //                 lrc_RecipeComment.SETRANGE("Source Code", lrc_RecipeProductionLines."Productionline Code");
            //                 lrc_RecipeComment.SETRANGE("Source Line No.", 0);
            //                 IF lrc_RecipeComment.FIND('-') THEN BEGIN

            //                     lrc_PackOrderComment.Reset();
            //                     lrc_PackOrderComment.SETRANGE("Doc. No.", "No.");
            //                     lrc_PackOrderComment.SETRANGE("Doc. Line No. Output", 0);
            //                     lrc_PackOrderComment.SETRANGE(lrc_PackOrderComment."Doc. Line No. Output", lrc_RecipeComment."Doc. Line No. Output");
            //                     lrc_PackOrderComment.SETRANGE(Type, lrc_PackOrderComment.Type::Productionlines);
            //                     lrc_PackOrderComment.SETRANGE("Source Line No.", lin_LastLineNo);
            //                     lin_NextCommentLineNo := 0;
            //                     IF lrc_PackOrderComment.FIND('+') THEN
            //                         lin_NextCommentLineNo := lrc_PackOrderComment."Line No.";

            //                     REPEAT
            //                         lin_NextCommentLineNo := lin_NextCommentLineNo + 10000;
            //                         lrc_PackOrderComment.Reset();
            //                         lrc_PackOrderComment.INIT();
            //                         lrc_PackOrderComment.VALIDATE("Doc. No.", "No.");
            //                         lrc_PackOrderComment.VALIDATE("Doc. Line No. Output", 0);
            //                         lrc_PackOrderComment.VALIDATE(Type, lrc_PackOrderComment.Type::Productionlines);
            //                         lrc_PackOrderComment.VALIDATE("Source Line No.", lin_LastLineNo);
            //                         lrc_PackOrderComment.VALIDATE("Line No.", lin_NextCommentLineNo);
            //                         lrc_PackOrderComment.VALIDATE(Date, lrc_RecipeComment.Date);
            //                         lrc_PackOrderComment.VALIDATE(Comment, lrc_RecipeComment.Comment);
            //                         lrc_PackOrderComment.INSERT(TRUE);
            //                     UNTIL lrc_RecipeComment.NEXT() = 0;
            //                 END;
            //             UNTIL lrc_RecipeProductionLines.NEXT() = 0;
            //         END;

            //         // Verpackungen kopieren
            //         lrc_RecipeInputPackingItems.Reset();
            //         lrc_RecipeInputPackingItems.SETRANGE("Recipe No.", "Recipe Code");
            //         lrc_RecipeInputPackingItems.SETFILTER("Customer No.", '%1|%2', "Customer No.", '');
            //         lrc_RecipeInputPackingItems.SETFILTER("Item No.", '<>%1', '');
            //         IF lrc_RecipeInputPackingItems.FIND('-') THEN BEGIN

            //             lrc_PackOrderInputPackItems.Reset();
            //             lrc_PackOrderInputPackItems.SETRANGE("Doc. No.", "No.");
            //             IF lrc_PackOrderLabels.FIND('-') THEN BEGIN
            //                 REPEAT
            //                     IF lrc_PackOrderInputPackItems.DELETE(TRUE) THEN;
            //                 UNTIL lrc_PackOrderInputPackItems.NEXT() = 0;
            //             END;

            //             IF lrc_PackOrderInputPackItems.FIND('+') THEN BEGIN
            //                 lin_LastLineNo := lrc_PackOrderInputPackItems."Line No.";
            //             END ELSE BEGIN
            //                 lin_LastLineNo := 0;
            //             END;

            //             REPEAT
            //                 lin_LastLineNo := lin_LastLineNo + 10000;

            //                 lrc_PackOrderInputPackItems.INIT();
            //                 lrc_PackOrderInputPackItems.VALIDATE("Doc. No.", "No.");
            //                 lrc_PackOrderInputPackItems.VALIDATE("Doc. Line No. Output", 0);
            //                 lrc_PackOrderInputPackItems.VALIDATE("Line No.", lin_LastLineNo);
            //                 lrc_PackOrderInputPackItems.INSERT(TRUE);
            //                 lrc_PackOrderInputPackItems.VALIDATE("Item No.", lrc_RecipeInputPackingItems."Item No.");
            //                 lrc_PackOrderInputPackItems.VALIDATE("Variant Code", lrc_RecipeInputPackingItems."Variant Code");
            //                 lrc_PackOrderInputPackItems.VALIDATE("Item Description", lrc_RecipeInputPackingItems."Item Description");
            //                 lrc_PackOrderInputPackItems.VALIDATE("Item Description 2", lrc_RecipeInputPackingItems."Item Description 2");
            //                 lrc_PackOrderInputPackItems.VALIDATE("Item Typ", lrc_RecipeInputPackingItems."Item Typ");
            //                 lrc_PackOrderInputPackItems.VALIDATE("Unit of Measure Code", lrc_RecipeInputPackingItems."Unit of Measure Code");
            //                 lrc_PackOrderInputPackItems.VALIDATE("Qty. per Unit of Measure",
            //                    lrc_RecipeInputPackingItems."Qty. per Base Unit Of Measure");
            //                 lrc_PackOrderInputPackItems.VALIDATE("Base Unit of Measure Code",
            //                    lrc_RecipeInputPackingItems."Base Unit of Measure Code");

            //                 IF lrc_RecipeInputPackingItems."Location Code" <> '' THEN BEGIN
            //                     lrc_PackOrderInputPackItems.VALIDATE("Location Code", lrc_RecipeInputPackingItems."Location Code");
            //                 END ELSE BEGIN
            //                     CASE lrc_RecipeInputPackingItems."Location Reference" OF
            //                         lrc_RecipeInputPackingItems."Location Reference"::Packing:
            //                             BEGIN
            //                                 lrc_PackOrderInputPackItems.VALIDATE("Location Code", "Inp. Packing Item Loc. Code");
            //                             END;
            //                         lrc_RecipeInputPackingItems."Location Reference"::Empties:
            //                             BEGIN
            //                                 lrc_PackOrderInputPackItems.VALIDATE("Location Code", "Inp. Empties Item Loc. Code");
            //                             END;
            //                         lrc_RecipeInputPackingItems."Location Reference"::Output:
            //                             BEGIN
            //                                 lrc_PackOrderInputPackItems.VALIDATE("Location Code", "Outp. Item Location Code");
            //                             END;
            //                         lrc_RecipeInputPackingItems."Location Reference"::Input:
            //                             BEGIN
            //                                 // Manuelle Zuordnung, woher die Ware kommt
            //                             END;
            //                     END;
            //                 END;

            //                 CASE lrc_RecipeInputPackingItems."Way Of Process" OF
            //                     lrc_RecipeInputPackingItems."Way Of Process"::Packing:
            //                         BEGIN
            //                             lrc_PackOrderInputPackItems.VALIDATE(Quantity, lrc_RecipeInputPackingItems.Quantity);
            //                             lrc_PackOrderInputPackItems.VALIDATE("Quantity (Base)",
            //                                lrc_RecipeInputPackingItems."Quantity (Base)");
            //                             lrc_PackOrderInputPackItems.VALIDATE("Direct Unit Cost (LCY)",
            //                                                                   lrc_RecipeInputPackingItems."Direct Unit Cost (LCY)");
            //                             lrc_PackOrderInputPackItems.VALIDATE("Amount (LCY)",
            //                                                                  lrc_RecipeInputPackingItems."Amount (LCY)");
            //                         END;
            //                     lrc_RecipeInputPackingItems."Way Of Process"::"Empties Input":
            //                         BEGIN
            //                             lrc_PackOrderInputPackItems.VALIDATE(Quantity, lrc_RecipeInputPackingItems.Quantity);
            //                             lrc_PackOrderInputPackItems.VALIDATE("Quantity (Base)",
            //                                lrc_RecipeInputPackingItems."Quantity (Base)");
            //                             lrc_PackOrderInputPackItems.VALIDATE("Direct Unit Cost (LCY)",
            //                                                                   lrc_RecipeInputPackingItems."Direct Unit Cost (LCY)");
            //                             lrc_PackOrderInputPackItems.VALIDATE("Amount (LCY)",
            //                                                                   lrc_RecipeInputPackingItems."Amount (LCY)");
            //                         END;
            //                     lrc_RecipeInputPackingItems."Way Of Process"::"Empties Output":
            //                         BEGIN
            //                             lrc_PackOrderInputPackItems.VALIDATE(Quantity, lrc_RecipeInputPackingItems.Quantity * (-1));
            //                             lrc_PackOrderInputPackItems.VALIDATE("Quantity (Base)",
            //                                lrc_RecipeInputPackingItems."Quantity (Base)" * (-1));
            //                             lrc_PackOrderInputPackItems.VALIDATE("Direct Unit Cost (LCY)",
            //                                                                   lrc_RecipeInputPackingItems."Direct Unit Cost (LCY)" * (-1));
            //                         END;
            //                 END;

            //                 lrc_PackOrderInputPackItems.VALIDATE("Production Line Code", "Production Line Code");
            //                 lrc_PackOrderInputPackItems.VALIDATE("Created From Recipe Code", lrc_RecipeInputPackingItems."Recipe No.");
            //                 lrc_PackOrderInputPackItems.VALIDATE("Created From Customer No.", lrc_RecipeInputPackingItems."Customer No.");
            //                 lrc_PackOrderInputPackItems.VALIDATE("Created From Line No.", lrc_RecipeInputPackingItems."Line No.");

            //                 lrc_PackOrderInputPackItems.MODIFY(TRUE);

            //                 // Bemerkung Input Verpackung
            //                 lrc_RecipeComment.Reset();
            //                 lrc_RecipeComment.SETRANGE("Recipe Code", "Recipe Code");
            //                 lrc_RecipeComment.SETRANGE("Doc. Line No. Output", 0);
            //                 lrc_RecipeComment.SETRANGE(Type, lrc_RecipeComment.Type::"Input Packing Material");
            //                 lrc_RecipeComment.SETRANGE("Source Line No.", lrc_RecipeInputPackingItems."Line No.");
            //                 IF lrc_RecipeComment.FIND('-') THEN BEGIN
            //                     lrc_PackOrderComment.Reset();
            //                     lrc_PackOrderComment.SETRANGE("Doc. No.", "No.");
            //                     lrc_PackOrderComment.SETRANGE("Doc. Line No. Output", 0);
            //                     lrc_PackOrderComment.SETRANGE(Type, lrc_PackOrderComment.Type::"Input Packing Material");
            //                     lrc_PackOrderComment.SETRANGE("Source Line No.", lin_LastLineNo);
            //                     lin_NextCommentLineNo := 0;
            //                     IF lrc_PackOrderComment.FIND('+') THEN
            //                         lin_NextCommentLineNo := lrc_PackOrderComment."Line No.";

            //                     REPEAT
            //                         lin_NextCommentLineNo := lin_NextCommentLineNo + 10000;
            //                         lrc_PackOrderComment.Reset();
            //                         lrc_PackOrderComment.INIT();
            //                         lrc_PackOrderComment.VALIDATE("Doc. No.", "No.");
            //                         lrc_PackOrderComment.VALIDATE("Doc. Line No. Output", 0);
            //                         lrc_PackOrderComment.VALIDATE(Type, lrc_PackOrderComment.Type::"Input Packing Material");
            //                         lrc_PackOrderComment.VALIDATE("Source Line No.", lin_LastLineNo);
            //                         lrc_PackOrderComment.VALIDATE("Line No.", lin_NextCommentLineNo);
            //                         lrc_PackOrderComment.VALIDATE(Date, lrc_RecipeComment.Date);
            //                         lrc_PackOrderComment.VALIDATE(Comment, lrc_RecipeComment.Comment);
            //                         lrc_PackOrderComment.INSERT(TRUE);
            //                     UNTIL lrc_RecipeComment.NEXT() = 0;
            //                 END;

            //             UNTIL lrc_RecipeInputPackingItems.NEXT() = 0;
            //         END;

            //         IF lrc_RecipeHeader."Transfer Input Item Pack.Order" = TRUE THEN BEGIN
            //             // Rohware kopieren
            //             lrc_RecipeInputItems.Reset();
            //             lrc_RecipeInputItems.SETRANGE("Recipe No.", "Recipe Code");
            //             lrc_RecipeInputItems.SETFILTER("Item No.", '<>%1', '');
            //             IF lrc_RecipeInputItems.FIND('-') THEN BEGIN

            //                 lrc_PackOrderInputItems.Reset();
            //                 lrc_PackOrderInputItems.SETRANGE("Doc. No.", "No.");
            //                 IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
            //                     lrc_PackOrderInputItems.DELETEALL(TRUE);
            //                 END;

            //                 IF lrc_PackOrderInputItems.FIND('+') THEN BEGIN
            //                     lin_LastLineNo := lrc_PackOrderInputItems."Line No.";
            //                 END ELSE BEGIN
            //                     lin_LastLineNo := 0;
            //                 END;

            //                 REPEAT
            //                     lin_LastLineNo := lin_LastLineNo + 10000;

            //                     lrc_PackOrderInputItems.INIT();
            //                     lrc_PackOrderInputItems.VALIDATE("Doc. No.", "No.");
            //                     lrc_PackOrderInputItems.VALIDATE("Doc. Line No. Output", 0);
            //                     lrc_PackOrderInputItems.VALIDATE("Line No.", lin_LastLineNo);
            //                     lrc_PackOrderInputItems.INSERT(TRUE);
            //                     lrc_PackOrderInputItems.VALIDATE("Item No.", lrc_RecipeInputItems."Item No.");
            //                     lrc_PackOrderInputItems.VALIDATE("Variant Code", lrc_RecipeInputItems."Variant Code");
            //                     lrc_PackOrderInputItems.VALIDATE("Item Description", lrc_RecipeInputItems."Item Description");
            //                     lrc_PackOrderInputItems.VALIDATE("Item Description 2", lrc_RecipeInputItems."Item Description 2");
            //                     lrc_PackOrderInputItems.VALIDATE("Item Typ", lrc_RecipeInputItems."Item Typ");
            //                     lrc_PackOrderInputItems.VALIDATE("Unit of Measure Code", lrc_RecipeInputItems."Unit of Measure Code");
            //                     lrc_PackOrderInputItems.VALIDATE("Qty. per Unit of Measure",
            //                        lrc_RecipeInputItems."Qty. per Unit Of Measure");
            //                     lrc_PackOrderInputItems.VALIDATE("Base Unit of Measure Code",
            //                        lrc_RecipeInputItems."Base Unit of Measure Code");

            //                     IF lrc_RecipeInputItems."Location Code" <> '' THEN BEGIN
            //                         lrc_PackOrderInputItems.VALIDATE("Location Code", lrc_RecipeInputItems."Location Code");
            //                     END ELSE BEGIN
            //                         lrc_PackOrderInputItems.VALIDATE("Location Code", "Outp. Item Location Code");
            //                     END;

            //                     IF (lrc_RecipeInputItems."Packing Unit of Measure (PU)" <> '') THEN BEGIN
            //                         lrc_RecipeOutputItems.VALIDATE("Packing Unit of Measure (PU)", lrc_RecipeInputItems."Packing Unit of Measure (PU)");
            //                         lrc_RecipeOutputItems.VALIDATE("Qty. (PU) per Unit of Measure",
            //                                                         lrc_RecipeInputItems."Qty. (PU) per Unit of Measure");
            //                     END;
            //                     lrc_PackOrderInputItems.VALIDATE(Quantity, lrc_RecipeInputItems.Quantity);

            //                     lrc_PackOrderInputItems.VALIDATE("Production Line Code", "Production Line Code");
            //                     lrc_PackOrderInputItems.VALIDATE("Created From Recipe Code", lrc_RecipeInputItems."Recipe No.");
            //                     lrc_PackOrderInputItems.VALIDATE("Created From Line No.", lrc_RecipeInputItems."Line No.");
            //                     lrc_PackOrderInputItems.VALIDATE("Factor %", lrc_RecipeInputItems."Factor %");
            //                     lrc_PackOrderInputItems."Grab Items" := lrc_RecipeInputItems."Grab Items";

            //                     lrc_PackOrderInputItems.MODIFY(TRUE);

            //                     // Bemerkung Input Verpackung
            //                     lrc_RecipeComment.Reset();
            //                     lrc_RecipeComment.SETRANGE("Recipe Code", "Recipe Code");
            //                     lrc_RecipeComment.SETRANGE("Doc. Line No. Output", 0);
            //                     lrc_RecipeComment.SETRANGE(Type, lrc_RecipeComment.Type::"Input Trade Item");
            //                     lrc_RecipeComment.SETRANGE("Source Line No.", lrc_RecipeInputItems."Line No.");
            //                     IF lrc_RecipeComment.FIND('-') THEN BEGIN
            //                         lrc_PackOrderComment.Reset();
            //                         lrc_PackOrderComment.SETRANGE("Doc. No.", "No.");
            //                         lrc_PackOrderComment.SETRANGE("Doc. Line No. Output", 0);
            //                         lrc_PackOrderComment.SETRANGE(Type, lrc_PackOrderComment.Type::"Input Trade Item");
            //                         lrc_PackOrderComment.SETRANGE("Source Line No.", lin_LastLineNo);
            //                         lin_NextCommentLineNo := 0;
            //                         IF lrc_PackOrderComment.FIND('+') THEN
            //                             lin_NextCommentLineNo := lrc_PackOrderComment."Line No.";

            //                         REPEAT
            //                             lin_NextCommentLineNo := lin_NextCommentLineNo + 10000;
            //                             lrc_PackOrderComment.Reset();
            //                             lrc_PackOrderComment.INIT();
            //                             lrc_PackOrderComment.VALIDATE("Doc. No.", "No.");
            //                             lrc_PackOrderComment.VALIDATE("Doc. Line No. Output", 0);
            //                             lrc_PackOrderComment.VALIDATE(Type, lrc_PackOrderComment.Type::"Input Trade Item");
            //                             lrc_PackOrderComment.VALIDATE("Source Line No.", lin_LastLineNo);
            //                             lrc_PackOrderComment.VALIDATE("Line No.", lin_NextCommentLineNo);
            //                             lrc_PackOrderComment.VALIDATE(Date, lrc_RecipeComment.Date);
            //                             lrc_PackOrderComment.VALIDATE(Comment, lrc_RecipeComment.Comment);
            //                             lrc_PackOrderComment.INSERT(TRUE);
            //                         UNTIL lrc_RecipeComment.NEXT() = 0;
            //                     END;

            //                 UNTIL lrc_RecipeInputItems.NEXT() = 0;
            //             END;
            //         END;

            //         // Output Artikel
            //         lrc_RecipeOutputItems.Reset();
            //         lrc_RecipeOutputItems.SETRANGE("Recipe No.", "Recipe Code");
            //         lrc_RecipeOutputItems.SETFILTER("Item No.", '<>%1', '');
            //         IF lrc_RecipeOutputItems.FIND('-') THEN BEGIN

            //             lrc_PackOrderOutputItems.Reset();
            //             lrc_PackOrderOutputItems.SETRANGE("Doc. No.", "No.");
            //             IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
            //                 REPEAT
            //                     IF lrc_PackOrderOutputItems.DELETE(TRUE) THEN;
            //                 UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
            //             END;

            //             IF lrc_PackOrderOutputItems.FIND('+') THEN BEGIN
            //                 lin_LastLineNo := lrc_PackOrderOutputItems."Line No.";
            //             END ELSE BEGIN
            //                 lin_LastLineNo := 0;
            //             END;

            //             REPEAT
            //                 lin_LastLineNo := lin_LastLineNo + 10000;

            //                 lrc_PackOrderOutputItems.INIT();
            //                 lrc_PackOrderOutputItems.VALIDATE("Doc. No.", "No.");
            //                 lrc_PackOrderOutputItems.VALIDATE("Line No.", lin_LastLineNo);
            //                 lrc_PackOrderOutputItems.INSERT(TRUE);
            //                 lrc_PackOrderOutputItems.VALIDATE("Type of Packing Product", lrc_RecipeOutputItems."Type of Packing Product");
            //                 lrc_PackOrderOutputItems.VALIDATE("Item No.", lrc_RecipeOutputItems."Item No.");
            //                 lrc_PackOrderOutputItems.VALIDATE("Variant Code", lrc_RecipeOutputItems."Variant Code");
            //                 lrc_PackOrderOutputItems.VALIDATE("Item Description", lrc_RecipeOutputItems."Item Description");
            //                 lrc_PackOrderOutputItems.VALIDATE("Item Description 2", lrc_RecipeOutputItems."Item Description 2");
            //                 lrc_PackOrderOutputItems.VALIDATE("Item Typ", lrc_RecipeOutputItems."Item Typ");
            //                 lrc_PackOrderOutputItems.VALIDATE("Item Category Code", lrc_RecipeOutputItems."Item Category Code");
            //                 lrc_PackOrderOutputItems.VALIDATE("Product Group Code", lrc_RecipeOutputItems."Product Group Code");

            //                 IF lrc_RecipeOutputItems."Location Code" <> '' THEN BEGIN
            //                     lrc_PackOrderOutputItems.VALIDATE("Location Code", lrc_RecipeOutputItems."Location Code");
            //                 END ELSE BEGIN
            //                     lrc_PackOrderOutputItems.VALIDATE("Location Code", "Outp. Item Location Code");
            //                 END;

            //                 lrc_PackOrderOutputItems.VALIDATE("Location Group Code", "Outp. Item Location Group Code");
            //                 lrc_PackOrderOutputItems.VALIDATE("Country of Origin Code", lrc_RecipeOutputItems."Country of Origin Code");
            //                 lrc_PackOrderOutputItems.VALIDATE("Variety Code", lrc_RecipeOutputItems."Variety Code");
            //                 lrc_PackOrderOutputItems.VALIDATE("Trademark Code", lrc_RecipeOutputItems."Trademark Code");
            //                 lrc_PackOrderOutputItems.VALIDATE("Caliber Code", lrc_RecipeOutputItems."Caliber Code");
            //                 lrc_PackOrderOutputItems.VALIDATE("Grade of Goods Code", lrc_RecipeOutputItems."Grade of Goods Code");
            //                 lrc_PackOrderOutputItems.VALIDATE("Coding Code", lrc_RecipeOutputItems."Coding Code");
            //                 lrc_PackOrderOutputItems.VALIDATE("Base Unit of Measure (BU)", lrc_RecipeOutputItems."Base Unit of Measure (BU)");
            //                 lrc_PackOrderOutputItems.VALIDATE("Packing Unit of Measure (PU)", lrc_RecipeOutputItems."Packing Unit of Measure (PU)");
            //                 lrc_PackOrderOutputItems.VALIDATE("Qty. (PU) per Unit of Measure",
            //                                                   lrc_RecipeOutputItems."Qty. (PU) per Unit of Measure");
            //                 lrc_PackOrderOutputItems.VALIDATE("Quantity (PU)", lrc_RecipeOutputItems."Quantity (PU)");
            //                 lrc_PackOrderOutputItems.VALIDATE("Transport Unit of Measure (TU)",
            //                                                   lrc_RecipeOutputItems."Transport Unit of Measure (TU)");
            //                 lrc_PackOrderOutputItems.VALIDATE("Qty. (Unit) per Transp.(TU)", lrc_RecipeOutputItems."Qty. (Unit) per Pallet (TU)");
            //                 lrc_PackOrderOutputItems.VALIDATE("Quantity (TU)", lrc_RecipeOutputItems."Quantity (TU)");
            //                 lrc_PackOrderOutputItems.VALIDATE("Collo Unit of Measure (CU)", lrc_RecipeOutputItems."Collo Unit of Measure (CU)");
            //                 lrc_PackOrderOutputItems.VALIDATE("Content Unit of Measure (COU)",
            //                                                   lrc_RecipeOutputItems."Content Unit of Measure (COU)");
            //                 lrc_PackOrderOutputItems.VALIDATE("Qty. (COU) per Pack. Unit (PU)",
            //                                                   lrc_RecipeOutputItems."Qty. (COU) per Pack. Unit (PU)");
            //                 lrc_PackOrderOutputItems.VALIDATE("Unit of Measure Code", lrc_RecipeOutputItems."Unit of Measure Code");
            //                 lrc_PackOrderOutputItems.VALIDATE(Quantity, lrc_RecipeOutputItems.Quantity);
            //                 lrc_PackOrderOutputItems.VALIDATE("Quantity (Base)", lrc_RecipeOutputItems."Quantity (Base)");
            //                 lrc_PackOrderOutputItems.VALIDATE("Qty. per Unit of Measure", lrc_RecipeOutputItems."Qty. per Unit Of Measure");

            //                 lrc_PackOrderOutputItems.VALIDATE("Production Line Code", "Production Line Code");
            //                 lrc_PackOrderOutputItems.VALIDATE("Output (Filler)", lrc_RecipeOutputItems."Output ( Filler )");
            //                 lrc_PackOrderOutputItems.VALIDATE("Expected Receipt Date", "Expected Receipt Date");
            //                 lrc_PackOrderOutputItems.VALIDATE("Promised Receipt Date", "Promised Receipt Date");

            //                 // Bemerkung Output Artikel
            //                 lrc_RecipeComment.Reset();
            //                 lrc_RecipeComment.SETRANGE("Recipe Code", "Recipe Code");
            //                 lrc_RecipeComment.SETRANGE("Doc. Line No. Output", lrc_RecipeOutputItems."Line No.");
            //                 lrc_RecipeComment.SETRANGE(Type, lrc_RecipeComment."Doc. Line No. Output"::"16");
            //                 lrc_RecipeComment.SETRANGE("Source Line No.", lrc_RecipeOutputItems."Line No.");
            //                 IF lrc_RecipeComment.FIND('-') THEN BEGIN
            //                     lrc_PackOrderComment.Reset();
            //                     lrc_PackOrderComment.SETRANGE("Doc. No.", "No.");
            //                     lrc_PackOrderComment.SETRANGE(Type, lrc_PackOrderComment.Type::"Output Item");
            //                     lrc_PackOrderComment.SETRANGE("Source Line No.", lin_LastLineNo);
            //                     lin_NextCommentLineNo := 0;
            //                     IF lrc_PackOrderComment.FIND('+') THEN
            //                         lin_NextCommentLineNo := lrc_PackOrderComment."Line No.";

            //                     REPEAT
            //                         lin_NextCommentLineNo := lin_NextCommentLineNo + 10000;
            //                         lrc_PackOrderComment.Reset();
            //                         lrc_PackOrderComment.INIT();
            //                         lrc_PackOrderComment.VALIDATE("Doc. No.", "No.");
            //                         lrc_PackOrderComment.VALIDATE("Doc. Line No. Output", lrc_PackOrderOutputItems."Line No.");
            //                         lrc_PackOrderComment.VALIDATE(Type, lrc_PackOrderComment.Type::"Output Item");
            //                         lrc_PackOrderComment.VALIDATE("Source Line No.", lin_LastLineNo);
            //                         lrc_PackOrderComment.VALIDATE("Line No.", lin_NextCommentLineNo);
            //                         lrc_PackOrderComment.VALIDATE(Date, lrc_RecipeComment.Date);
            //                         lrc_PackOrderComment.VALIDATE(Comment, lrc_RecipeComment.Comment);
            //                         lrc_PackOrderComment.INSERT(TRUE);
            //                     UNTIL lrc_RecipeComment.NEXT() = 0;
            //                 END;

            //                 // Etiketten kopieren
            //                 lrc_RecipeLabels.Reset();
            //                 lrc_RecipeLabels.SETRANGE("Recipe Code", "Recipe Code");
            //                 lrc_RecipeLabels.SETRANGE("Doc. Line No. Output", lrc_RecipeOutputItems."Line No.");
            //                 lrc_RecipeLabels.SETFILTER("Customer No.", '%1|%2', "Customer No.", '');
            //                 IF lrc_RecipeLabels.FIND('-') THEN BEGIN

            //                     lrc_PackOrderLabels.Reset();
            //                     lrc_PackOrderLabels.SETRANGE("Doc. No.", "No.");
            //                     lrc_PackOrderLabels.SETRANGE("Doc. Line No. Output", lrc_RecipeOutputItems."Line No.");
            //                     IF lrc_PackOrderLabels.FIND('-') THEN BEGIN
            //                         REPEAT
            //                             IF lrc_PackOrderLabels.DELETE(TRUE) THEN;
            //                         UNTIL lrc_PackOrderLabels.NEXT() = 0;
            //                     END;

            //                     IF lrc_PackOrderLabels.FIND('+') THEN BEGIN
            //                         lin_LastLineNo2 := lrc_PackOrderLabels."Line No.";
            //                     END ELSE BEGIN
            //                         lin_LastLineNo2 := 0;
            //                     END;

            //                     REPEAT
            //                         lin_LastLineNo2 := lin_LastLineNo2 + 10000;

            //                         lrc_PackOrderLabels.INIT();
            //                         lrc_PackOrderLabels.VALIDATE("Doc. No.", "No.");
            //                         lrc_PackOrderLabels.VALIDATE("Doc. Line No. Output", lrc_PackOrderOutputItems."Line No.");
            //                         lrc_PackOrderLabels.VALIDATE("Line No.", lin_LastLineNo2);
            //                         lrc_PackOrderLabels.VALIDATE("Ref. Trade Item No.", lrc_RecipeLabels."Ref. Trade Item No.");
            //                         lrc_PackOrderLabels.VALIDATE("Label Code", lrc_RecipeLabels."Label Code");
            //                         lrc_PackOrderLabels.VALIDATE("Label Description", lrc_RecipeLabels."Label Description");
            //                         lrc_PackOrderLabels.VALIDATE("Label Usage", lrc_RecipeLabels."Label Usage");
            //                         lrc_PackOrderLabels.VALIDATE("Unit Of Measure Code", lrc_RecipeLabels."Unit Of Measure Code");
            //                         lrc_PackOrderLabels.VALIDATE("Production Line Code", "Production Line Code");

            //                         lrc_PackOrderLabels.INSERT(TRUE);

            //                         // Bemerkung Etikett
            //                         lrc_RecipeComment.Reset();
            //                         lrc_RecipeComment.SETRANGE("Recipe Code", "Recipe Code");
            //                         lrc_RecipeComment.SETRANGE("Doc. Line No. Output", lrc_RecipeLabels."Doc. Line No. Output");
            //                         lrc_RecipeComment.SETRANGE(Type, lrc_RecipeComment.Type::Label);
            //                         lrc_RecipeComment.SETRANGE("Source Code", lrc_RecipeLabels."Customer No.");

            //                         IF lrc_RecipeComment.FIND('-') THEN BEGIN
            //                             lrc_PackOrderComment.Reset();
            //                             lrc_PackOrderComment.SETRANGE("Doc. No.", "No.");
            //                             lrc_PackOrderComment.SETRANGE("Doc. Line No. Output", lrc_RecipeLabels."Doc. Line No. Output");
            //                             lrc_PackOrderComment.SETRANGE(Type, lrc_PackOrderComment.Type::Label);
            //                             lrc_PackOrderComment.SETRANGE("Source Line No.", lin_LastLineNo2);
            //                             lin_NextCommentLineNo := 0;
            //                             IF lrc_PackOrderComment.FIND('+') THEN
            //                                 lin_NextCommentLineNo := lrc_PackOrderComment."Line No.";

            //                             REPEAT
            //                                 lin_NextCommentLineNo := lin_NextCommentLineNo + 10000;
            //                                 lrc_PackOrderComment.Reset();
            //                                 lrc_PackOrderComment.INIT();
            //                                 lrc_PackOrderComment.VALIDATE("Doc. No.", "No.");
            //                                 lrc_PackOrderComment.VALIDATE("Doc. Line No. Output", lrc_RecipeLabels."Doc. Line No. Output");
            //                                 lrc_PackOrderComment.VALIDATE(Type, lrc_PackOrderComment.Type::Label);
            //                                 lrc_PackOrderComment.VALIDATE("Source Line No.", lin_LastLineNo2);
            //                                 lrc_PackOrderComment.VALIDATE("Line No.", lin_NextCommentLineNo);
            //                                 lrc_PackOrderComment.VALIDATE(Date, lrc_RecipeComment.Date);
            //                                 lrc_PackOrderComment.VALIDATE(Comment, lrc_RecipeComment.Comment);
            //                                 lrc_PackOrderComment.INSERT(TRUE);
            //                             UNTIL lrc_RecipeComment.NEXT() = 0;
            //                         END;

            //                     UNTIL lrc_RecipeLabels.NEXT() = 0;
            //                 END;


            //                 IF lrc_PackOrderOutputItems."Unit of Measure Code" <> '' THEN BEGIN
            //                     lrc_PackOrderOutputItems.FillCrossReferenceNo(
            //                         lrc_PackOrderOutputItems.FIELDNO("Unit of Measure Code"), lrc_PackOrderOutputItems);
            //                 END;

            //                 IF lrc_PackOrderOutputItems."Transport Unit of Measure (TU)" <> '' THEN BEGIN
            //                     lrc_PackOrderOutputItems.FillCrossReferenceNo(
            //                         lrc_PackOrderOutputItems.FIELDNO("Transport Unit of Measure (TU)"), lrc_PackOrderOutputItems);
            //                 END;

            //                 IF lrc_PackOrderOutputItems."Packing Unit of Measure (PU)" <> '' THEN BEGIN
            //                     lrc_PackOrderOutputItems.FillCrossReferenceNo(
            //                         lrc_PackOrderOutputItems.FIELDNO("Packing Unit of Measure (PU)"), lrc_PackOrderOutputItems);
            //                 END;

            //                 lrc_PackOrderOutputItems.MODIFY(TRUE);

            //             UNTIL lrc_RecipeOutputItems.NEXT() = 0;
            //         END;

            //         // Input Kosten
            //         lrc_RecipeInputCost.Reset();
            //         lrc_RecipeInputCost.SETRANGE("Recipe No.", "Recipe Code");
            //         IF "Production Line Code" <> '' THEN BEGIN
            //             lrc_RecipeInputCost.SETFILTER("Production Line Code", '%1|%2', "Production Line Code", '');
            //         END;
            //         lrc_RecipeInputCost.SETFILTER(Type, '%1|%2', lrc_RecipeInputCost.Type::Resource,
            //                                                       lrc_RecipeInputCost.Type::"Cost Category");
            //         lrc_RecipeInputCost.SETFILTER("No.", '<>%!', '');
            //         IF lrc_RecipeInputCost.FIND('-') THEN BEGIN

            //             lrc_PackOrderInputCosts.Reset();
            //             lrc_PackOrderInputCosts.SETRANGE("Doc. No.", "No.");
            //             IF lrc_PackOrderInputCosts.FIND('-') THEN BEGIN
            //                 REPEAT
            //                     IF lrc_PackOrderInputCosts.DELETE(TRUE) THEN;
            //                 UNTIL lrc_PackOrderInputCosts.NEXT() = 0;
            //             END;

            //             IF lrc_PackOrderInputCosts.FIND('+') THEN BEGIN
            //                 lin_LastLineNo := lrc_PackOrderInputCosts."Line No.";
            //             END ELSE BEGIN
            //                 lin_LastLineNo := 0;
            //             END;

            //             REPEAT
            //                 lin_LastLineNo := lin_LastLineNo + 10000;

            //                 lrc_PackOrderInputCosts.INIT();
            //                 lrc_PackOrderInputCosts.VALIDATE("Doc. No.", "No.");
            //                 lrc_PackOrderInputCosts.VALIDATE("Doc. Line No. Output", 0);
            //                 lrc_PackOrderInputCosts.VALIDATE("Line No.", lin_LastLineNo);
            //                 lrc_PackOrderInputCosts.INSERT(TRUE);
            //                 lrc_PackOrderInputCosts.VALIDATE(Type, lrc_RecipeInputCost.Type);
            //                 lrc_PackOrderInputCosts.VALIDATE("No.", lrc_RecipeInputCost."No.");
            //                 lrc_PackOrderInputCosts.VALIDATE("Work Type Code", lrc_RecipeInputCost."Work Type Code");
            //                 lrc_PackOrderInputCosts.VALIDATE(Description, lrc_RecipeInputCost.Description);
            //                 lrc_PackOrderInputCosts.VALIDATE("Description 2", lrc_RecipeInputCost."Description 2");
            //                 lrc_PackOrderInputCosts.VALIDATE("Unit of Measure Code", lrc_RecipeInputCost."Unit of Measure Code");
            //                 lrc_PackOrderInputCosts.VALIDATE(Quantity, lrc_RecipeInputCost.Quantity);
            //                 lrc_PackOrderInputCosts.VALIDATE("Allocation Batch No.", lrc_RecipeInputCost."Allocation Batch No.");
            //                 lrc_PackOrderInputCosts.VALIDATE("Qty. per Unit of Measure", lrc_RecipeInputCost."Qty. per Unit of Measure");
            //                 lrc_PackOrderInputCosts.VALIDATE("Allocation Price (LCY)", lrc_RecipeInputCost."Allocation Price (LCY)");
            //                 lrc_PackOrderInputCosts.VALIDATE("Amount (LCY)", lrc_RecipeInputCost."Amount (LCY)");
            //                 lrc_PackOrderInputCosts.VALIDATE("Production Line Code", "Production Line Code");
            //                 lrc_PackOrderInputCosts.VALIDATE("Allocation Base Costs", lrc_RecipeInputCost."Allocation Base Costs");
            //                 lrc_PackOrderInputCosts.VALIDATE("Chargeable Costs (LCY)", lrc_RecipeInputCost."Chargeable Costs (LCY)");

            //                 lrc_PackOrderInputCosts.MODIFY(TRUE);

            //                 // Bemerkung Input Kosten
            //                 lrc_RecipeComment.Reset();
            //                 lrc_RecipeComment.SETRANGE("Recipe Code", "Recipe Code");
            //                 lrc_RecipeComment.SETRANGE("Doc. Line No. Output", 0);
            //                 lrc_RecipeComment.SETRANGE(Type, lrc_RecipeComment.Type::"Input Cost");
            //                 lrc_RecipeComment.SETRANGE("Source Line No.", lrc_RecipeInputCost."Line No.");
            //                 IF lrc_RecipeComment.FIND('-') THEN BEGIN
            //                     lrc_PackOrderComment.Reset();
            //                     lrc_PackOrderComment.SETRANGE("Doc. No.", "No.");
            //                     lrc_PackOrderComment.SETRANGE("Doc. Line No. Output", 0);
            //                     lrc_PackOrderComment.SETRANGE(Type, lrc_PackOrderComment.Type::"Input Cost");
            //                     lrc_PackOrderComment.SETRANGE("Source Line No.", lin_LastLineNo);
            //                     lin_NextCommentLineNo := 0;
            //                     IF lrc_PackOrderComment.FIND('+') THEN
            //                         lin_NextCommentLineNo := lrc_PackOrderComment."Line No.";

            //                     REPEAT
            //                         lin_NextCommentLineNo := lin_NextCommentLineNo + 10000;
            //                         lrc_PackOrderComment.Reset();
            //                         lrc_PackOrderComment.INIT();
            //                         lrc_PackOrderComment.VALIDATE("Doc. No.", "No.");
            //                         lrc_PackOrderComment.VALIDATE("Doc. Line No. Output", 0);
            //                         lrc_PackOrderComment.VALIDATE(Type, lrc_PackOrderComment.Type::"Input Cost");
            //                         lrc_PackOrderComment.VALIDATE("Source Line No.", lin_LastLineNo);
            //                         lrc_PackOrderComment.VALIDATE("Line No.", lin_NextCommentLineNo);
            //                         lrc_PackOrderComment.VALIDATE(Date, lrc_RecipeComment.Date);
            //                         lrc_PackOrderComment.VALIDATE(Comment, lrc_RecipeComment.Comment);
            //                         lrc_PackOrderComment.INSERT(TRUE);
            //                     UNTIL lrc_RecipeComment.NEXT() = 0;
            //                 END;

            //             UNTIL lrc_RecipeInputCost.NEXT() = 0;
            //         END;

            //     END;
            // end;
        }
        field(20; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(21; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = "POI Batch";
        }
        field(24; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
        }
        field(25; "Outp. Item Location Code"; Code[10])
        {
            Caption = 'Outp. Item Location Code';
            TableRelation = Location;

            trigger OnValidate()
            var
                lrc_Location: Record Location;
            begin
                IF "Outp. Item Location Code" <> '' THEN BEGIN
                    lrc_Location.GET("Outp. Item Location Code");
                    ;
                    //"Outp. Item Location Group Code" := lrc_Location."Location Group Code"; //TODO: location
                    // IF lrc_Location."Quality Control Vendor No." <> '' THEN
                    //     "Quality Control Vendor No." := lrc_Location."Quality Control Vendor No.";
                END ELSE
                    "Outp. Item Location Group Code" := '';
            end;
        }
        field(26; "Outp. Item Location Group Code"; Code[10])
        {
            Caption = 'Outp. Item Location Group Code';
            //TableRelation = "Location Group";
        }
        field(27; "Inp. Packing Item Loc. Code"; Code[10])
        {
            Caption = 'Inp. Packing Item Loc. Code';
            TableRelation = Location;
        }
        field(28; "Inp. Empties Item Loc. Code"; Code[10])
        {
            Caption = 'Inp. Empties Item Loc. Code';
            TableRelation = Location;
        }
        field(29; "Inp. Item Loc. Code"; Code[10])
        {
            Caption = 'Inp. Item Loc. Code';
            TableRelation = Location;
        }
        field(30; "Promised Receipt Date"; Date)
        {
            Caption = 'Promised Receipt Date';

            trigger OnLookup()
            begin
                DateFieldsLookUp(FIELDNO("Promised Receipt Date"));
            end;

            trigger OnValidate()
            var
            //lcu_RecipePackingManagement: Codeunit "5110700";
            //lrc_PackOrderOutputItems: Record "5110713";
            begin
                // Wert in die Zeilen übertragen
                TransferToLines(copystr(FIELDCAPTION("Promised Receipt Date"), 1, 100));

                //lcu_RecipePackingManagement.ActualLotNoInAllLines(Rec);
            end;
        }
        field(31; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';

            trigger OnLookup()
            begin
                DateFieldsLookUp(FIELDNO("Expected Receipt Date"));
            end;

            trigger OnValidate()
            begin
                // Wert in die Zeilen übertragen
                TransferToLines(copystr(FIELDCAPTION("Expected Receipt Date"), 1, 100));
            end;
        }
        field(33; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnLookup()
            begin
                DateFieldsLookUp(FIELDNO("Posting Date"));
            end;
        }
        field(34; "Document Date"; Date)
        {
            Caption = 'Document Date';

            trigger OnLookup()
            begin
                DateFieldsLookUp(FIELDNO("Document Date"));
            end;
        }
        field(35; "Order Date"; Date)
        {
            Caption = 'Order Date';

            trigger OnLookup()
            begin
                DateFieldsLookUp(FIELDNO("Order Date"));
            end;
        }
        field(36; "Packing Date"; Date)
        {
            CaptionClass = '5110700,1,2';
            Caption = 'Packing Date';

            trigger OnLookup()
            begin
                DateFieldsLookUp(FIELDNO("Packing Date"));
            end;

            trigger OnValidate()
            var
            //lcu_RecipePackingManagement: Codeunit "5110700";
            begin
                //lcu_RecipePackingManagement.ActualLotNoInAllLines(Rec);
                TransferToLines(copystr(FIELDCAPTION("Packing Date"), 1, 100));
            end;
        }
        field(38; "Packing Start Time"; Time)
        {
            Caption = 'Packing Start Time';
        }
        field(40; "Pallet Entry ID"; Integer)
        {
            Caption = 'Pallet Entry ID';
            Description = 'PAL';
        }
        field(50; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            begin
                lrc_PackOrderOutputItems.SETRANGE("Doc. No.", "No.");
                lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
                                                  lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
                IF lrc_PackOrderOutputItems.FINDFIRST() THEN
                    IF lrc_PackOrderOutputItems."Quantity Produced" = 0 THEN BEGIN
                        lrc_PackOrderOutputItems.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
                        lrc_PackOrderOutputItems.MODIFY(TRUE);
                    END;
            end;
        }
        field(51; Quantity; Decimal)
        {
            Caption = 'Menge';

            trigger OnValidate()
            begin
                lrc_PackOrderOutputItems.SETRANGE("Doc. No.", "No.");
                lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
                                                  lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
                IF lrc_PackOrderOutputItems.FINDFIRST() THEN
                    IF lrc_PackOrderOutputItems."Quantity Produced" = 0 THEN BEGIN
                        lrc_PackOrderOutputItems.VALIDATE(Quantity, Quantity);
                        lrc_PackOrderOutputItems.MODIFY(TRUE);
                    END;
            end;
        }
        field(90; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(100; "Pack.-by Vendor No."; Code[20])
        {
            Caption = 'Pack.-by Vendor No.';
            TableRelation = Vendor."No." WHERE("POI Warehouse Keeper" = CONST(true));

            trigger OnValidate()
            var
                Vendor: Record Vendor;
                //lrc_RecipePackingSetup: Record "5110701";
                PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF "Pack.-by Vendor No." <> '' THEN BEGIN

                    Vendor.GET("Pack.-by Vendor No.");

                    "Pack.-by Name" := Vendor.Name;
                    "Pack.-by Name 2" := Vendor."Name 2";
                    "Pack.-by Address" := Vendor.Address;
                    "Pack.-by Address 2" := Vendor."Address 2";
                    "Pack.-by Country Code" := Vendor."Country/Region Code";
                    "Pack.-by Post Code" := Vendor."Post Code";
                    "Pack.-by City" := Vendor.City;
                    "Pack.-by Contact" := Vendor.Contact;

                    // lrc_RecipePackingSetup.GET();
                    // IF lrc_RecipePackingSetup."Default Loc. from Pack. Vendor" = TRUE THEN BEGIN
                    //     IF lrc_Vendor."Location Code" <> '' THEN BEGIN
                    //         VALIDATE("Outp. Item Location Code", lrc_Vendor."Location Code");
                    //         VALIDATE("Inp. Packing Item Loc. Code", lrc_Vendor."Location Code");
                    //         VALIDATE("Inp. Item Loc. Code", lrc_Vendor."Location Code");
                    //     END;
                    // END;

                END ELSE BEGIN

                    "Pack.-by Name" := '';
                    "Pack.-by Name 2" := '';
                    "Pack.-by Address" := '';
                    "Pack.-by Address 2" := '';
                    "Pack.-by Country Code" := '';
                    "Pack.-by Post Code" := '';
                    "Pack.-by City" := '';
                    "Pack.-by Contact" := '';

                END;

                IF "Pack.-by Vendor No." <> xRec."Pack.-by Vendor No." THEN
                    PalletManagement.ActualFieldsFromPackOrdHeader(copystr(FIELDCAPTION("Pack.-by Vendor No."), 1, 100), Rec, xRec);

                VALIDATE("Owner Vendor No.", "Pack.-by Vendor No.");
            end;
        }
        field(101; "Pack.-by Name"; Text[100])
        {
            Caption = 'Pack.-by Name';

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF "Pack.-by Name" <> xRec."Pack.-by Name" THEN
                    lcu_PalletManagement.ActualFieldsFromPackOrdHeader(copystr(FIELDCAPTION("Pack.-by Name"), 1, 100), Rec, xRec);
            end;
        }
        field(102; "Pack.-by Name 2"; Text[50])
        {
            Caption = 'Pack.-by Name 2';
        }
        field(105; "Pack.-by Address"; Text[100])
        {
            Caption = 'Pack.-by Address';
        }
        field(106; "Pack.-by Address 2"; Text[50])
        {
            Caption = 'Pack.-by Address 2';
        }
        field(107; "Pack.-by Country Code"; Code[10])
        {
            Caption = 'Pack.-by Country Code';
            TableRelation = "Country/Region";
        }
        field(108; "Pack.-by Post Code"; Code[20])
        {
            Caption = 'Pack.-by Post Code';
            TableRelation = "Post Code";
        }
        field(109; "Pack.-by City"; Text[30])
        {
            Caption = 'Pack.-by City';
        }
        field(112; "Pack.-by Contact"; Text[100])
        {
            Caption = 'Pack.-by Contact';
        }
        field(120; Reference; Text[80])
        {
            Caption = 'Reference';
        }
        field(122; "Person in Charge Code"; Code[10])
        {
            Caption = 'Person in Charge Code';
            TableRelation = "Salesperson/Purchaser".Code WHERE("POI Is Person in Charge" = FILTER(true));

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF "Person in Charge Code" <> xRec."Person in Charge Code" THEN
                    lcu_PalletManagement.ActualFieldsFromPackOrdHeader(copystr(FIELDCAPTION("Person in Charge Code"), 1, 100), Rec, xRec);
            end;
        }
        field(180; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(200; "Result Based on"; Option)
        {
            Caption = 'Result Based on';
            Description = 'Kostenkalkulation,Gebuchte Kosten,Abzurechnende Kosten';
            InitValue = "Settled Cost";
            OptionCaption = 'Cost Calculation,Posted Cost,Settled Cost';
            OptionMembers = "Cost Calculation","Posted Cost","Settled Cost";
        }
        field(290; "Tot. Qty. Units Input"; Decimal)
        {
            Caption = 'Total Qty. Units Input';
            Editable = false;
        }
        field(291; "Tot. Qty. Units Input Consumed"; Decimal)
        {
            Caption = 'Tot. Qty. Units Input Consumed';
        }
        field(300; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(301; Comment; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist ("POI Pack. Order Comment" WHERE("Doc. No." = FIELD("No."),
                                                             "Doc. Line No. Output" = FILTER(0),
                                                             Type = CONST("Packing Order")));
            Caption = 'Comment';
            Editable = false;

        }
        field(302; "Tot. Qty. Units Output"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Output Items".Quantity WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Qty. Units Output';
            Editable = false;
            FieldClass = FlowField;
        }
        field(303; "Tot. Qty. Packing Output"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Output Items"."Quantity (PU)" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Qty. Packing Output';
            Editable = false;
            FieldClass = FlowField;
        }
        field(304; "Tot. Qty. Output Produced"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Output Items"."Quantity Produced" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Qty. Output Produced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(305; "Tot. Sales Net Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Output Items"."Sales Net Net Amount (LCY)" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Tot. Sales Net Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(306; "Tot. Gross Weight Input"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Output Items"."Total Gross Weight" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Gross Weight Input';
            Editable = false;
            FieldClass = FlowField;
        }
        field(307; "Tot. Net Weight Input"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Input Items"."Total Net Weight" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Net Weight Input';
            Editable = false;
            FieldClass = FlowField;
        }
        field(308; "Tot. Gross Weight Output"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Output Items"."Total Gross Weight" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Gross Weight Output';
            Editable = false;
            FieldClass = FlowField;
        }
        field(309; "Tot. Net Weight Output"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Output Items"."Total Net Weight" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Net Weight Output';
            Editable = false;
            FieldClass = FlowField;
        }
        field(310; "Tot. Net Weight Inp. (Revenue)"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Input Items"."Total Net Weight" WHERE("Doc. No." = FIELD("No."),
                                                                                  "No Revenue" = CONST(true)));
            Caption = 'Total Net Weight Input (Erlös)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(312; "Tot. Loss (n.w.)"; Decimal)
        {
            Caption = 'Total Loss (n.w.)';
        }
        field(313; "Tot. Loss Perc. (n.w.)"; Decimal)
        {
            Caption = 'Total Loss Perc. (n.w.)';
        }
        field(315; "Tot. Calc. Costs"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Output Items"."Amount Cost Calculation (LCY)" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Calc. Costs';
            Editable = false;
            FieldClass = FlowField;
        }
        field(316; "Tot. Posted Costs"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Output Items"."Amount Posted Costs (LCY)" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Posted Costs';
            Editable = false;
            FieldClass = FlowField;
        }
        field(317; "Tot. Acc. Costs"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Output Items"."Amount Chargeable Costs (LCY)" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Acc. Costs';
            Editable = false;
            FieldClass = FlowField;
        }
        field(320; "Total Amount Result"; Decimal)
        {
            Caption = 'Total Amount Result';
        }
        field(325; "Total Result per Kilo"; Decimal)
        {
            Caption = 'Total Result per Kilo';
        }
        field(330; "Tot. Qty. A-Quality Outp. Base"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Output Items"."Quantity (Base)" WHERE("Doc. No." = FIELD("No."),
                                                                                  "Type of Packing Product" = FILTER("Finished Product")));
            Caption = 'Total Qty. Base A-Quality Output';
            Editable = false;
            FieldClass = FlowField;
        }
        field(331; "Tot. Qty. A-Quality Inp. Base"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Input Items"."A-Goods Quantity (Base)" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Qty. A-Quality Base Input';
            Editable = false;
            FieldClass = FlowField;
        }
        field(332; "Tot. Qty. Output (Base)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("POI Pack. Order Output Items"."Quantity (Base)" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Qty. Output (Base)';
            Editable = false;

        }
        field(333; "Tot. Qty. Input (Base)"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Input Items"."Quantity (Base)" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Qty. Input (Base)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(350; "Tot. Remain. Qty. Output"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Output Items"."Remaining Quantity" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Remain. Qty. Output';
            Editable = false;
            FieldClass = FlowField;
        }
        field(351; "Tot. Remain. Qty. Output Base"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Output Items"."Remaining Quantity" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Remain. Qty. Output Base';
            Editable = false;
            FieldClass = FlowField;
        }
        field(352; "Tot. Remain. Qty. Input"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Input Items"."Remaining Quantity" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Remain. Qty. Input';
            Editable = false;
            FieldClass = FlowField;
        }
        field(353; "Tot. Remain. Qty. Input Base"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("POI Pack. Order Input Items"."Remaining Quantity" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Remain. Qty. Input Base';
            Editable = false;

        }
        field(354; "Tot. Remain. Qty. Pack Input"; Decimal)
        {
            CalcFormula = Sum ("POI PO Input Pack. Items"."Remaining Quantity" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Remain. Qty. Pack Input';
            Editable = false;
            FieldClass = FlowField;
        }
        field(355; "Tot. Remain. Qty. PackInp Base"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Input Items"."Remaining Quantity" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Remaining Quantity Packing Input (Base)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(356; "Tot. Remain. Qty. Cost"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Input Costs"."Remaining Quantity" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Remaining Quantity Cost';
            Editable = false;
            FieldClass = FlowField;
        }
        field(357; "Tot. Remain. Qty. Cost (Base)"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Input Costs"."Remaining Quantity (Base)" WHERE("Doc. No." = FIELD("No.")));
            Caption = 'Total Remaining Quantity Cost (Base)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(400; "Chain Name"; Code[10])
        {
            Caption = 'Chain Name';
            //TableRelation = "Company Chain";
        }
        field(490; Blocked; Option)
        {
            Caption = 'Gesperrt';
            OptionCaption = ' ,Sperre wegen Output in Input';
            OptionMembers = " ","Sperre wegen Output in Input";
        }
        field(500; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Registered,Deleted,,,,,Produktion abgeschlossen';
            OptionMembers = Open,Registered,Deleted,,,,,"Produktion abgeschlossen";
        }
        field(600; "Cost Transfer"; Boolean)
        {
            Caption = 'Cost Transfer';
        }
        field(601; "Distribution Base Costs"; Option)
        {
            Caption = 'Distribution Base Costs';
            OptionCaption = 'Colli,Base Unit';
            OptionMembers = Colli,"Base Unit";
        }
        field(700; "Assortment Code"; Code[20])
        {
            Caption = 'Assortment Code';
            Description = 'MSO';
            Editable = false;
            NotBlank = true;
        }
        field(701; "Assortment Line No."; Integer)
        {
            Caption = 'Assortment Line No.';
            Description = 'MSO';
            Editable = false;
            NotBlank = true;
        }
        // field(705; "Recorded Quantity"; Decimal)
        // {
        //     CalcFormula = Lookup ("Feature Assort. Cust. Prices"."Recorded Quantity" WHERE("Pack. Order No." = FIELD("No."),
        //                                                                                    "Assortment Code" = FIELD("Assortment Code"),
        //                                                                                    "Assortment Line No." = FIELD("Assortment Line No.")));
        //     Caption = 'Planned Quantity';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(706; "Assigned Quantity"; Decimal)
        // {
        //     CalcFormula = Sum ("Feature Assortment CustLine"."Compare Quantity" WHERE("Assortment Code" = FIELD("Assortment Code"),
        //                                                                               "Assortment Line No." = FIELD("Assortment Line No."),
        //                                                                               "Shipment Date" = FIELD("Promised Receipt Date"),
        //                                                                               "Document No." = FILTER(''),
        //                                                                               "Document Line No." = FILTER(0)));
        //     Caption = 'Assigned Quantity';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(707; "Assigned Quantity Order"; Decimal)
        // {
        //     CalcFormula = Sum ("Feature Assortment CustLine"."Compare Quantity" WHERE("Assortment Code" = FIELD("Assortment Code"),
        //                                                                               "Assortment Line No." = FIELD("Assortment Line No."),
        //                                                                               "Shipment Date" = FIELD("Promised Receipt Date"),
        //                                                                               "Document No." = FILTER(<> ''),
        //                                                                               "Document Line No." = FILTER(<> 0)));
        //     Caption = 'Assigned Quantity Order';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(800; Inventory; Decimal)
        {
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Location Code" = FIELD("Location Filter"),
                                                                  "POI Batch Variant No." = FIELD("Batch Variant Filter")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(900; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(901; "Batch Variant Filter"; Code[20])
        {
            Caption = 'Batch Variant Filter';
            FieldClass = FlowFilter;
            TableRelation = "POI Batch Variant";
        }
        field(1000; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(1100; "Owner Vendor No."; Code[20])
        {
            Caption = 'Owner Vendor No.';
            Description = 'PAL';
            TableRelation = Vendor;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_Vendor: Record Vendor;
                lcu_PalletManagement: Codeunit "POI Pallet Management";

            begin
                IF lrc_Vendor.GET("Owner Vendor No.") THEN
                    VALIDATE(Owner, lrc_Vendor.Name);

                IF "Owner Vendor No." <> xRec."Owner Vendor No." THEN
                    lcu_PalletManagement.ActualFieldsFromPackOrdHeader(copystr(FIELDCAPTION("Owner Vendor No."), 1, 100), Rec, xRec);
            end;
        }
        field(1101; Owner; Text[50])
        {
            Caption = 'Owner';
            Description = 'PAL';

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF Owner <> xRec.Owner THEN
                    lcu_PalletManagement.ActualFieldsFromPackOrdHeader(copystr(FIELDCAPTION(Owner), 1, 100), Rec, xRec);
            end;
        }
        field(2000; "Licence Code"; Code[10])
        {
            Caption = 'Licence Code';
            Description = 'PVP';
            //TableRelation = "Import Licence"."Licence Code";
        }
        field(2001; "Disposition for Week"; Code[5])
        {
            Caption = 'Disposition for Week';
            Description = 'PVP';
        }
        field(2002; "Maturation Time"; DateFormula)
        {
            Caption = 'Maturation Time';
            Description = 'PVP';
        }
        field(55030; "Qty Items"; Integer)
        {
            Caption = 'Anzahl Artikel (für Display)';
        }
        field(55040; "Pack. Cost incl. Packing Item"; Boolean)
        {
            Caption = 'Pack. Kosten inkl. Karton';
        }
        field(5110310; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(5110311; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(5110312; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(5110313; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(5110364; "Print Sorting Code"; Code[10])
        {
            Caption = 'Print Sorting Code';
            //TableRelation = "Print Sorting";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        // key(Key2; "Document Type", Priority, "Production Line Code", "Programm No.", "Item No.")
        // {
        // }
        // key(Key3; "Document Type", "Production Line Code", "Programm No.", "Item No.")
        // {
        // }
        // key(Key4; "Document Type", "Production Line Code", Priority, "Programm No.", "Packing Start Time", "Item No.")
        // {
        // }
        // key(Key6; "Document Type", "Packing Date", "Production Line Code", Priority, "Programm No.", "Packing Start Time", "Item No.")
        // {
        // }
        key(Key8; "Document Type", Status, "Pack. Doc. Type Code", "Disposition for Week", "Packing Date", "Item No.", "Licence Code")
        {
        }
        key(Key9; "Document Type", "Pack. Doc. Type Code")
        {
        }
        key(Key10; "Pack.-by Vendor No.")
        {
        }
        key(Key11; "Packing Date")
        {
        }
    }

    trigger OnDelete()
    var
        lrc_PackOrderComment: Record "POI Pack. Order Comment";
        lrc_PackOrderInputItems: Record "POI Pack. Order Input Items";
        lrc_PackOrderInputPackItems: Record "POI PO Input Pack. Items";
        lrc_PackOrderInputCosts: Record "POI Pack. Order Input Costs";
        lrc_PackOrderLabels: Record "POI Pack. Order Labels";
    //lrc_PackOrderProductionLines: Record "5110720";
    //lrc_FeatureAssortmentCustoPric: Record "5110374";
    begin
        lrc_PackOrderComment.RESET();
        lrc_PackOrderComment.SETRANGE(lrc_PackOrderComment."Doc. No.", "No.");
        IF lrc_PackOrderComment.FIND('-') THEN
            lrc_PackOrderComment.DELETEALL(TRUE);

        lrc_PackOrderInputCosts.RESET();
        lrc_PackOrderInputCosts.SETRANGE("Doc. No.", "No.");
        IF lrc_PackOrderInputCosts.FIND('-') THEN
            lrc_PackOrderInputCosts.DELETEALL(TRUE);

        lrc_PackOrderOutputItems.RESET();
        lrc_PackOrderOutputItems.SETRANGE("Doc. No.", "No.");
        IF lrc_PackOrderOutputItems.FIND('-') THEN
            lrc_PackOrderOutputItems.DELETEALL(TRUE);

        lrc_PackOrderInputItems.RESET();
        lrc_PackOrderInputItems.SETRANGE("Doc. No.", "No.");
        IF lrc_PackOrderInputItems.FIND('-') THEN
            lrc_PackOrderInputItems.DELETEALL(TRUE);

        lrc_PackOrderInputPackItems.RESET();
        lrc_PackOrderInputPackItems.SETRANGE("Doc. No.", "No.");
        IF lrc_PackOrderInputPackItems.FIND('-') THEN
            lrc_PackOrderInputPackItems.DELETEALL(TRUE);

        lrc_PackOrderLabels.RESET();
        lrc_PackOrderLabels.SETRANGE("Doc. No.", "No.");
        IF lrc_PackOrderLabels.FIND('-') THEN
            lrc_PackOrderLabels.DELETEALL(TRUE);

        // lrc_PackOrderProductionLines.Reset();
        // lrc_PackOrderProductionLines.SETRANGE("Doc. No.", "No.");
        // IF lrc_PackOrderProductionLines.FIND('-') THEN
        //     lrc_PackOrderProductionLines.DELETEALL(TRUE);

        // IF ("Assortment Code" <> '') AND
        //    ("Assortment Line No." <> 0) THEN BEGIN
        //     lrc_FeatureAssortmentCustoPric.Reset();
        //     lrc_FeatureAssortmentCustoPric.SETCURRENTKEY("Pack. Order No.");
        //     lrc_FeatureAssortmentCustoPric.SETRANGE("Pack. Order No.", "No.");
        //     lrc_FeatureAssortmentCustoPric.SETRANGE("Assortment Code", "Assortment Code");
        //     lrc_FeatureAssortmentCustoPric.SETRANGE("Assortment Line No.", "Assortment Line No.");
        //     IF lrc_FeatureAssortmentCustoPric.FIND('-') THEN BEGIN
        //         lrc_FeatureAssortmentCustoPric."Pack.Order No." := '';
        //         lrc_FeatureAssortmentCustoPric.MODIFY(TRUE);
        //     END;
        // END;
    end;

    trigger OnInsert()
    var

        lrc_PackingSetup: Record "POI Recipe & Packing Setup";
        lrc_UserSetup: Record "User Setup";
        lrc_PackDocSubtype: Record "POI Pack. Doc. Subtype";
        //lcu_BatchManagement: Codeunit "POI BAM Batch Management";
        lcu_NoSeriesManagement: Codeunit NoSeriesManagement;
        //lco_BatchNo: Code[20];
        TEXT001Txt: Label 'Zuordnung Packereityp fehlgeschlagen!';
    begin
        "Posting Date" := WORKDATE();
        "Document Date" := "Posting Date";
        "Order Date" := "Posting Date";
        "Packing Date" := "Posting Date";
        "Expected Receipt Date" := "Posting Date" + 1;

        lrc_PackingSetup.GET();
        lrc_PackingSetup.TESTFIELD("Gen. Bus. Posting Group");
        "Gen. Bus. Posting Group" := lrc_PackingSetup."Gen. Bus. Posting Group";

        IF "No." = '' THEN BEGIN
            CASE "Document Type" OF
                "Document Type"::"Packing Order":
                    BEGIN
                        lrc_PackingSetup.TESTFIELD("Packing Order No. Series");
                        lcu_NoSeriesManagement.InitSeries(lrc_PackingSetup."Packing Order No. Series", xRec."No. Series",
                                                          "Posting Date", "No.", "No. Series");
                    END;
                "Document Type"::"Sorting Order":
                    BEGIN
                        lrc_PackingSetup.TESTFIELD("Sorting Order No. Series");
                        lcu_NoSeriesManagement.InitSeries(lrc_PackingSetup."Sorting Order No. Series", xRec."No. Series",
                                                          "Posting Date", "No.", "No. Series");
                    END;
                "Document Type"::"Substitution Order":
                    BEGIN
                        lrc_PackingSetup.TESTFIELD("Substitution Order No. Series");
                        lcu_NoSeriesManagement.InitSeries(lrc_PackingSetup."Substitution Order No. Series", xRec."No. Series",
                                                          "Posting Date", "No.", "No. Series");
                    END;
                ELSE
                    // Zuordnung Packereityp fehlgeschlagen!
                    ERROR(TEXT001Txt);
            END;

            // Sachbearbeiter über USER ID ermitteln
            IF lrc_UserSetup.GET(USERID()) THEN
                "Person in Charge Code" := lrc_UserSetup."POI Person in Charge Code";

            // Lagerorte aus Setup / Belegunterart vorbelegen
            IF ("Pack. Doc. Type Code" = '') OR (NOT lrc_PackDocSubtype.GET("Pack. Doc. Type Code")) THEN
                lrc_PackDocSubtype.INIT();



            IF "Outp. Item Location Code" = '' THEN
                IF lrc_PackDocSubtype."Default Output Location Code" <> '' THEN
                    VALIDATE("Outp. Item Location Code", lrc_PackDocSubtype."Default Output Location Code")
                ELSE
                    IF lrc_PackingSetup."Default Output Location Code" <> '' THEN
                        VALIDATE("Outp. Item Location Code", lrc_PackingSetup."Default Output Location Code");
            IF "Inp. Packing Item Loc. Code" = '' THEN
                IF lrc_PackDocSubtype."Default Packing Location Code" <> '' THEN
                    VALIDATE("Inp. Packing Item Loc. Code", lrc_PackDocSubtype."Default Packing Location Code")
                ELSE
                    IF lrc_PackingSetup."Default Packing Location Code" <> '' THEN
                        VALIDATE("Inp. Packing Item Loc. Code", lrc_PackingSetup."Default Packing Location Code");
            IF "Inp. Empties Item Loc. Code" = '' THEN
                IF lrc_PackDocSubtype."Default Empties Location Code" <> '' THEN
                    VALIDATE("Inp. Empties Item Loc. Code", lrc_PackDocSubtype."Default Empties Location Code")
                ELSE
                    IF lrc_PackingSetup."Default Empties Location Code" <> '' THEN
                        VALIDATE("Inp. Empties Item Loc. Code", lrc_PackingSetup."Default Empties Location Code");


            // Zuordnung Packkreditor aus Vorbelegung Setup
            // Achtung Zuordnung Packkreditor muss nach Lagerorten erfolgen, da das beim Kreditor hinterleget Lager
            // gezogen werden soll (falls eins hinterlegt ist)
            IF "Pack.-by Vendor No." = '' THEN
                IF lrc_PackingSetup."Default Pack.-by Vendor No." <> '' THEN
                    VALIDATE("Pack.-by Vendor No.", lrc_PackingSetup."Default Pack.-by Vendor No.");

            // Dimensionen belegen
            CreateDim();
        end;
    end;

    trigger OnModify()
    begin
        TestPackOrderHeaderOpen("No.");
    end;

    trigger OnRename()
    begin
        TestPackOrderHeaderOpen("No.");
    end;

    var
        //AGILESText001: Label 'Document %1 is the Next Doc. in the Planing.';
        //gde_Quantity: Decimal;
        "gco_Country of Origin Code": Code[10];
        "gco_Location Code": Code[10];
        //"gco_Grade of Goods Code": Code[10];
        //"gco_Trademark Code": Code[10];
        "gco_Caliber Code": Code[10];
    //"gco_Item Attribute 2": Code[10];

    procedure CreateDim()
    var
        lrc_PackDocSubtype: Record "POI Pack. Doc. Subtype";
    begin
        // -------------------------------------------------------------------------------------------
        // Dimensionen aus Belegunterart übernehmen
        // -------------------------------------------------------------------------------------------

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Shortcut Dimension 3 Code" := '';
        "Shortcut Dimension 4 Code" := '';

        IF "Pack. Doc. Type Code" <> '' THEN
            IF lrc_PackDocSubtype.GET("Pack. Doc. Type Code") THEN BEGIN
                IF (lrc_PackDocSubtype."Shortcut Dimension 1 Code" <> '') THEN
                    VALIDATE("Shortcut Dimension 1 Code", lrc_PackDocSubtype."Shortcut Dimension 1 Code");
                IF (lrc_PackDocSubtype."Shortcut Dimension 2 Code" <> '') THEN
                    VALIDATE("Shortcut Dimension 2 Code", lrc_PackDocSubtype."Shortcut Dimension 2 Code");
                IF (lrc_PackDocSubtype."Shortcut Dimension 3 Code" <> '') THEN
                    VALIDATE("Shortcut Dimension 3 Code", lrc_PackDocSubtype."Shortcut Dimension 3 Code");
                IF (lrc_PackDocSubtype."Shortcut Dimension 4 Code" <> '') THEN
                    VALIDATE("Shortcut Dimension 4 Code", lrc_PackDocSubtype."Shortcut Dimension 4 Code");
            END;
    end;

    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
    //lrc_PrintDocument: Record "5110471";
    //lcu_PrintFaxMailGlobals: Codeunit "5110311";
    begin
        WITH lrc_PackOrderHeader DO //TODO: print records
            COPY(Rec);
        // lrc_PrintDocument.RESET();
        // lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Packing);
        // case Rec."Document Type" of
        //     Rec."Document Type"::"Packing Order":
        //         lrc_PrintDocument.SETRANGE(Code, 'P POR');
        //     Rec."Document Type"::"Sorting Order":
        //         BEGIN
        //             lrc_PrintDocument.SETRANGE("Document Type", lrc_PrintDocument."Document Type"::"15");
        //             lrc_PrintDocument.SETRANGE(Code, 'P SOR');
        //         END ELSE BEGIN
        //                     lrc_PrintDocument.SETRANGE("Document Type", lrc_PrintDocument."Document Type"::"18");
        //                     lrc_PrintDocument.SETRANGE(Code, 'P EOR');
        //                 END;
        // end;
        // IF lrc_PrintDocument.FIND('-') THEN BEGIN
        //     REPEAT
        //         lcu_PrintFaxMailGlobals.ClearPrintDocRec();
        //         REPORT.RUNMODAL(lrc_PrintDocument."Report ID", ShowRequestForm, FALSE, lrc_PackOrderHeader);
        //     UNTIL lrc_PrintDocument.NEXT() = 0;
        //     lcu_PrintFaxMailGlobals.ClearPrintDocRec();
        // END;
    end;

    procedure TestPackOrderHeaderOpen(vco_PackOrderNo: Code[20])
    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
    begin
        lrc_PackOrderHeader.GET(vco_PackOrderNo);
        lrc_PackOrderHeader.TESTFIELD(Status, lrc_PackOrderHeader.Status::Open);
    end;

    procedure TransferToLines(ChangedFieldName: Text[100])
    var
    // lrc_PackOrderInputItems: Record "POI Pack. Order Input Items";
    // lrc_PackOrderInputPackItems: Record "POI PO Input Pack. Items";
    // lrc_PackOrderInputCosts: Record "POI Pack. Order Input Costs";
    begin
        // ----------------------------------------------------------------------------------
        // Felder aus dem Kopf auf die Zeilen übertragen
        // ----------------------------------------------------------------------------------

        CASE ChangedFieldName OF
            FIELDCAPTION("Promised Receipt Date"):
                BEGIN
                    // Wert in die Outputzeilen übertragen
                    lrc_PackOrderOutputItems.RESET();
                    lrc_PackOrderOutputItems.SETRANGE("Doc. No.", "No.");
                    IF lrc_PackOrderOutputItems.FIND('-') THEN
                        REPEAT
                            lrc_PackOrderOutputItems.VALIDATE("Promised Receipt Date", "Promised Receipt Date");
                            lrc_PackOrderOutputItems.MODIFY(TRUE);
                        UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
                END;
            FIELDCAPTION("Expected Receipt Date"):
                BEGIN
                    // Wert in die Outputzeilen übertragen
                    lrc_PackOrderOutputItems.RESET();
                    lrc_PackOrderOutputItems.SETRANGE("Doc. No.", "No.");
                    IF lrc_PackOrderOutputItems.FIND('-') THEN
                        REPEAT
                            lrc_PackOrderOutputItems.VALIDATE("Expected Receipt Date", "Expected Receipt Date");
                            lrc_PackOrderOutputItems.MODIFY(TRUE);
                        UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
                END;
            // FIELDCAPTION("Production Line Code"): //TODO: production line
            //     BEGIN
            //         // Wert in die Outputzeilen übertragen
            //         lrc_PackOrderOutputItems.RESET();
            //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.", "No.");
            //         lrc_PackOrderOutputItems.SETRANGE("Quantity Produced", 0);
            //         IF lrc_PackOrderOutputItems.FIND('-') THEN
            //             REPEAT
            //                 //lrc_PackOrderOutputItems.VALIDATE("Production Line Code", "Production Line Code");
            //                 lrc_PackOrderOutputItems.MODIFY(TRUE);
            //             UNTIL lrc_PackOrderOutputItems.NEXT() = 0;

            //         // Wert in Inputzeilen Rohware übertragen
            //         lrc_PackOrderInputItems.RESET();
            //         lrc_PackOrderInputItems.SETRANGE("Doc. No.", "No.");
            //         lrc_PackOrderInputItems.SETRANGE("Quantity Consumed", 0);
            //         IF lrc_PackOrderInputItems.FIND('-') THEN
            //             REPEAT
            //                 //lrc_PackOrderInputItems.VALIDATE("Production Line Code", "Production Line Code");
            //                 lrc_PackOrderInputItems.MODIFY(TRUE);
            //             UNTIL lrc_PackOrderInputItems.NEXT() = 0;

            //         // Wert in Inputzeilen Verpackungen übertragen
            //         lrc_PackOrderInputPackItems.RESET();
            //         lrc_PackOrderInputPackItems.SETRANGE("Doc. No.", "No.");
            //         lrc_PackOrderInputPackItems.SETRANGE("Quantity Consumed", 0);
            //         IF lrc_PackOrderInputPackItems.FIND('-') THEN
            //             REPEAT
            //                 //lrc_PackOrderInputPackItems.VALIDATE("Production Line Code", "Production Line Code");
            //                 lrc_PackOrderInputPackItems.MODIFY(TRUE);
            //             UNTIL lrc_PackOrderInputPackItems.NEXT() = 0;

            //         // Wert in Inputkosten übertragen
            //         lrc_PackOrderInputCosts.RESET();
            //         lrc_PackOrderInputCosts.SETRANGE("Doc. No.", "No.");
            //         lrc_PackOrderInputCosts.SETRANGE("Quantity Consumed", 0);
            //         IF lrc_PackOrderInputCosts.FIND('-') THEN
            //             REPEAT
            //                 //lrc_PackOrderInputCosts.VALIDATE("Production Line Code", "Production Line Code");
            //                 lrc_PackOrderInputCosts.MODIFY(TRUE);
            //             UNTIL lrc_PackOrderInputCosts.NEXT() = 0;
            //     END;
            FIELDCAPTION("Packing Date"):
                BEGIN
                    // Wert in die Outputzeilen übertragen
                    lrc_PackOrderOutputItems.RESET();
                    lrc_PackOrderOutputItems.SETRANGE("Doc. No.", "No.");
                    IF lrc_PackOrderOutputItems.FIND('-') THEN
                        REPEAT
                            lrc_PackOrderOutputItems.VALIDATE("Packing Date", "Packing Date");
                            lrc_PackOrderOutputItems.MODIFY(TRUE);
                        UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
                END;
        END;
    end;

    procedure GetVendorName(): Text[100]
    var
        lrc_Vendor: Record Vendor;
    begin
        // -----------------------------------------------------------------------
        // Funktion zum Lesen Kreditorenname
        // -----------------------------------------------------------------------

        IF lrc_Vendor.GET("Vendor No.") THEN
            EXIT(lrc_Vendor.Name)
        ELSE
            EXIT('');
    end;

    procedure UpdateOutputLine()
    begin
        // ---------------------------------------------------------------------------------
        // Funktion zur Anlage der Output Zeile nach Eingabe der Artikelnr. und Sorte
        // ---------------------------------------------------------------------------------

        lrc_PackOrderOutputItems.SETRANGE("Doc. No.", "No.");
        lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
                                          lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
        IF NOT lrc_PackOrderOutputItems.FINDFIRST() THEN BEGIN
            lrc_PackOrderOutputItems.RESET();
            lrc_PackOrderOutputItems.INIT();
            lrc_PackOrderOutputItems."Doc. No." := "No.";
            lrc_PackOrderOutputItems."Line No." := 10000;
            lrc_PackOrderOutputItems.INSERT(TRUE);
            lrc_PackOrderOutputItems."Type of Packing Product" :=
                              lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product";
            lrc_PackOrderOutputItems.VALIDATE("Item No.", "Item No.");
            //lrc_PackOrderOutputItems."Variety Code" := "Variety Code";
            lrc_PackOrderOutputItems.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
            lrc_PackOrderOutputItems.MODIFY(TRUE);
        END ELSE BEGIN
            //lrc_PackOrderOutputItems."Variety Code" := "Variety Code";
            lrc_PackOrderOutputItems.MODIFY();

            //Merke Attribute
            lrc_PackOrderOutputItems.VALIDATE("Item No.", "Item No.");
            lrc_PackOrderOutputItems.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
            lrc_PackOrderOutputItems.VALIDATE(Quantity, Quantity);
            IF "gco_Country of Origin Code" <> '' THEN
                lrc_PackOrderOutputItems.VALIDATE("Country of Origin Code", "gco_Country of Origin Code");  //Erzeugerland Code
            IF "gco_Location Code" <> '' THEN
                lrc_PackOrderOutputItems.VALIDATE("Location Code", "gco_Location Code");            //Lagerortcode
            // IF "gco_Grade of Goods Code" <> '' THEN
            //     lrc_PackOrderOutputItems.VALIDATE("Grade of Goods Code", "gco_Grade of Goods Code");//Handelsklasse Code
            // IF "gco_Trademark Code" <> '' THEN
            //     lrc_PackOrderOutputItems.VALIDATE("Trademark Code", "gco_Trademark Code");          //Markencode
            IF "gco_Caliber Code" <> '' THEN
                lrc_PackOrderOutputItems.VALIDATE("Caliber Code", "gco_Caliber Code");              //Kalibercode
            // IF "gco_Item Attribute 2" <> '' THEN
            //     lrc_PackOrderOutputItems.VALIDATE("Item Attribute 2", "gco_Item Attribute 2");      //Farbe Code
            // lrc_PackOrderOutputItems.MODIFY(TRUE);
        END;
    end;


    procedure IsNextDocPlaning(vbn_WithErrorMessage: Boolean): Boolean
    var
    //lrc_Dispolines: Record "5110492";
    begin
        // IF "No." = '' THEN BEGIN
        //     EXIT(FALSE);
        // END;

        // lrc_Dispolines.Reset();
        // lrc_Dispolines.SETCURRENTKEY("Document Type 2", "Document No. 2", "Document Line Line No. 2");
        // lrc_Dispolines.SETRANGE("Document Type 2", lrc_Dispolines."Document Type"::"Packing Order");
        // lrc_Dispolines.SETRANGE("Document No. 2", "No.");
        // lrc_Dispolines.SETRANGE("Document Line Line No. 2", 10000);
        // IF NOT lrc_Dispolines.isempty()THEN BEGIN
        //     IF vbn_WithErrorMessage THEN BEGIN
        //         ERROR(AGILESText001, "No.");
        //     END;
        //     EXIT(TRUE);
        // END;

        // lrc_Dispolines.Reset();
        // lrc_Dispolines.SETCURRENTKEY("Document Type 3", "Document No. 3", "Document Line Line No. 3");
        // lrc_Dispolines.SETRANGE("Document Type 3", lrc_Dispolines."Document Type"::"Packing Order");
        // lrc_Dispolines.SETRANGE("Document No. 3", "No.");
        // lrc_Dispolines.SETRANGE("Document Line Line No. 3", 10000);
        // IF NOT lrc_Dispolines.isempty()THEN BEGIN
        //     IF vbn_WithErrorMessage THEN BEGIN
        //         ERROR(AGILESText001, "No.");
        //     END;
        //     EXIT(TRUE);
        // END;

        // EXIT(FALSE);
    end;

    procedure DateFieldsLookUp(vin_FieldNo: Integer)
    var
        lcu_GlobalFunctionsMgt: Codeunit "POI GlobalFunctionsMgt";
    begin
        // -------------------------------------------------------------------------
        // Lookup Funktion für Datumsfelder
        // -------------------------------------------------------------------------

        CASE vin_FieldNo OF
            FIELDNO("Posting Date"):
                IF lcu_GlobalFunctionsMgt.SelectDateByCalendar("Posting Date") THEN
                    VALIDATE("Posting Date");
            FIELDNO("Order Date"):
                IF lcu_GlobalFunctionsMgt.SelectDateByCalendar("Order Date") THEN
                    VALIDATE("Order Date");
            FIELDNO("Promised Receipt Date"):
                IF lcu_GlobalFunctionsMgt.SelectDateByCalendar("Promised Receipt Date") THEN
                    VALIDATE("Promised Receipt Date");
            FIELDNO("Expected Receipt Date"):
                IF lcu_GlobalFunctionsMgt.SelectDateByCalendar("Expected Receipt Date") THEN
                    VALIDATE("Expected Receipt Date");
            FIELDNO("Packing Date"):
                IF lcu_GlobalFunctionsMgt.SelectDateByCalendar("Packing Date") THEN
                    VALIDATE("Packing Date");
        END;
    end;

    procedure SetItemAttributeForOutput()
    begin
        lrc_PackOrderOutputItems.SETRANGE("Doc. No.", "No.");
        IF lrc_PackOrderOutputItems.FINDSET() THEN BEGIN
            "gco_Country of Origin Code" := lrc_PackOrderOutputItems."Country of Origin Code"; //Erzeugerland Code
            "gco_Location Code" := lrc_PackOrderOutputItems."Location Code";            //Lagerortcode
            //"gco_Grade of Goods Code" := lrc_PackOrderOutputItems."Grade of Goods Code";  //Handelsklasse Code
            //"gco_Trademark Code" := lrc_PackOrderOutputItems."Trademark Code";            //Markencode
            "gco_Caliber Code" := lrc_PackOrderOutputItems."Caliber Code";          //Kalibercode
            //"gco_Item Attribute 2" := lrc_PackOrderOutputItems."Item Attribute 2";     //Farbe Code
        END;
    end;

    procedure "Fotos_anhängen"()
    var
        Filename: Text[250];
        ffile: File;
    begin
        CASE COMPANYNAME() OF
            'PI European Sourcing':
                BEGIN
                    Filename := '\\port-nav-01\NavClient\MakeDir\makeDir' + USERID() + '.bat';
                    IF EXISTS(Filename) THEN ERASE(Filename);
                    IF NOT (ffile.CREATE(Filename)) THEN //Hat das geklappt
                        ERROR('Datei %1 konnte nicht erstellt werden', Filename);
                    IF NOT (ffile.WRITEMODE(TRUE)) THEN           //sind Schreibrechte da ??
                        ERROR('In Datei %1 kann nicht auf Write-Mode geschaltet werden', Filename);
                    IF (NOT ffile.TEXTMODE(TRUE)) THEN                //True ist ASCII False ist Binary
                        ERROR('Datei %1 kann nicht in ASCII-Mode geschaltet werden', Filename);
                    ffile.WRITE('mkdir \\port-data-01\lwp\QS\Reklamationen\port-pies\Packerei\' + "No.");
                    ffile.WRITE('explorer \\port-data-01\lwp\QS\Reklamationen\port-pies\Packerei\' + "No.");
                    ffile.CLOSE();
                    //SHELL(Filename);
                END;
            'PI Fruit GmbH':
                BEGIN
                    Filename := '\\port-nav-01\NavClient\MakeDir\makeDir' + USERID() + '.bat';
                    IF EXISTS(Filename) THEN ERASE(Filename);
                    IF NOT (ffile.CREATE(Filename)) THEN //Hat das geklappt
                        ERROR('Datei %1 konnte nicht erstellt werden', Filename);
                    IF NOT (ffile.WRITEMODE(TRUE)) THEN           //sind Schreibrechte da ??
                        ERROR('In Datei %1 kann nicht auf Write-Mode geschaltet werden', Filename);
                    IF NOT (ffile.TEXTMODE(TRUE)) THEN                //True ist ASCII False ist Binary
                        ERROR('Datei %1 kann nicht in ASCII-Mode geschaltet werden', Filename);
                    ffile.WRITE('mkdir \\port-data-01\lwp\QS\Reklamationen\port-fruit\Packerei\' + "No.");
                    ffile.WRITE('explorer \\port-data-01\lwp\QS\Reklamationen\port-fruit\Packerei\' + "No.");
                    ffile.CLOSE();
                    //SHELL(Filename);
                END;
            'P I Dutch Growers':
                BEGIN
                    Filename := '\\port-nav-01\NavClient\MakeDir\makeDir' + USERID() + '.bat';
                    IF EXISTS(Filename) THEN ERASE(Filename);
                    IF NOT (ffile.CREATE(Filename)) THEN //Hat das geklappt
                        ERROR('Datei %1 konnte nicht erstellt werden', Filename);
                    IF NOT (ffile.WRITEMODE(TRUE)) THEN           //sind Schreibrechte da ??
                        ERROR('In Datei %1 kann nicht auf Write-Mode geschaltet werden', Filename);
                    IF NOT (ffile.TEXTMODE(TRUE)) THEN                //True ist ASCII False ist Binary
                        ERROR('Datei %1 kann nicht in ASCII-Mode geschaltet werden', Filename);
                    ffile.WRITE('mkdir \\port-data-01\lwp\QS\Reklamationen\port-dg\Packerei\' + "No.");
                    ffile.WRITE('explorer \\port-data-01\lwp\QS\Reklamationen\port-dg\Packerei\' + "No.");
                    ffile.CLOSE();
                    //SHELL(Filename);
                END;
            ELSE
                EXIT;
        END;
    end;

    procedure Foto_exist(): Boolean
    var
        lrc_CompanyInfo: Record "Company Information";
        currpath: Text[250];
    begin
        CASE COMPANYNAME() OF
            'PI European Sourcing':
                BEGIN
                    currpath := '\\port-data-01\lwp\QS\Reklamationen\port-pies\Packerei\';
                    tabfile.SETFILTER(Path, currpath);
                    tabfile.SETRANGE(Name, 'xxx');
                    IF NOT tabfile.FIND('-') THEN;

                    tabfile.SETFILTER(Path, currpath);
                    tabfile.SETRANGE(Name, "No.");
                    IF tabfile.FIND('-') THEN BEGIN
                        tabfile.SETFILTER(Path, STRSUBSTNO('%1\%2', currpath, "No."));
                        tabfile.SETRANGE("Is a file", TRUE);
                        tabfile.SETRANGE(Name);
                        IF tabfile.FIND('-') THEN
                            EXIT(TRUE);
                    END;

                    EXIT(FALSE);
                END;
            'P I Dutch Growers':
                BEGIN
                    lrc_CompanyInfo.GET();
                    currpath := '\\port-data-01\lwp\QS\Reklamationen\port-dg\Packerei\';
                    tabfile.SETFILTER(Path, currpath);
                    tabfile.SETRANGE(Name, 'xxx');
                    IF NOT tabfile.FIND('-') THEN;

                    tabfile.SETFILTER(Path, currpath);
                    tabfile.SETRANGE(Name, "No.");
                    IF tabfile.FIND('-') THEN BEGIN
                        tabfile.SETFILTER(Path, STRSUBSTNO('%1\%2', currpath, "No."));
                        tabfile.SETRANGE("Is a file", TRUE);
                        tabfile.SETRANGE(Name);
                        IF not tabfile.IsEmpty() THEN
                            EXIT(TRUE);
                    END;
                    EXIT(FALSE);
                END;
            ELSE
                EXIT;
        END;
    end;

    var
        lrc_PackOrderOutputItems: Record "POI Pack. Order Output Items";
        tabfile: Record File;
}

