table 50901 "POI Dispolines"
{
    Caption = 'Dispolines';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,,,,Packing Order,,,,Position,,,,Reduced Purchase Order,,,,,Transfer Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,,,,"Packing Order",,,,Position,,,,"Reduced Purchase Order",,,,,"Transfer Order";
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            // TableRelation = IF ("Document Type"=CONST(Order)) "Sales Header"."No." WHERE ("Document Type"=FIELD("Document Type"))
            //                 ELSE IF ("Document Type"=CONST("Packing Order")) "Pack. Order Header"."No." WHERE ("Document Type"=CONST("Packing Order"))
            //                 ELSE IF ("Document Type"=CONST("Reduced Purchase Order")) "Purchase Header"."No." WHERE ("Document Type"=CONST(Order))
            //                 ELSE IF ("Document Type"=CONST("Transfer Order")) "Transfer Header"."No.";
        }
        field(3; "Document Line Line No."; Integer)
        {
            Caption = 'Document Line Line No.';
            DataClassification = CustomerContent;
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(5; "Departure Date"; Date)
        {
            Caption = 'Departure Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lrc_Batch: Record "POI Batch";
                lInt_DayOfTheWeek: Integer;
                lco_DispositionForWeek: Code[5];

            begin
                clear(lco_DispositionForWeek);
                IF "Departure Date" <> 0D THEN BEGIN
                    lInt_DayOfTheWeek := DATE2DWY("Departure Date", 1);

                    CASE lInt_DayOfTheWeek OF
                        1:
                            "Departure Datetext" := 'MO';
                        2:
                            "Departure Datetext" := 'DI';
                        3:
                            "Departure Datetext" := 'MI';
                        4:
                            "Departure Datetext" := 'DO';
                        5:
                            "Departure Datetext" := 'FR';
                        6:
                            "Departure Datetext" := 'SA';
                        7:
                            "Departure Datetext" := 'SO';
                    END;

                END;

                // Bei manueller EingabeAbgangsdatum darf nicht vor dem ersten Tag der Palanungswoche liegen
                IF "Departure Date" <> 0D THEN BEGIN
                    TestDateBeforeFirstWeekday();
                    lrc_Batch.GET("Batch No.");
                    IF "Disposition For Week" = '' THEN
                        ///???lco_DispositionForWeek := lcu_PositionPlanning.GeneratePlanningWeek("Departure Date", lrc_Batch."Voyage No.");
                        IF lco_DispositionForWeek <> lrc_Batch."Disposition Week" THEN
                            VALIDATE("Disposition For Week", lco_DispositionForWeek);
                END ELSE
                    "Departure Datetext" := '';

                IF CurrFieldNo = FIELDNO("Departure Date") THEN
                    CalcReceiptDate();
            end;
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

            // trigger OnValidate()
            // var
            //     lrc_FruitVisionSetup: Record "ADF Setup";
            //     lrc_PositionPlanningSetup: Record "5110488";
            //     lcu_PurchaseDispoMgt: Codeunit "5110380";
            // begin
            //     ///???CalcQuantity(FIELDNO(Quantity));

            //     IF CurrFieldNo <> 0 THEN BEGIN
            //         lrc_FruitVisionSetup.GET();
            //         IF lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE' THEN
            //             TESTFIELD("Document Type", "Document Type"::Position);
            //     END;

            //     IF NOT gbn_IndirectCall THEN
            //         IF lrc_PositionPlanningSetup.GET() THEN
            //             IF lrc_PositionPlanningSetup."Update Assigned Document Lines" THEN BEGIN
            //                 MODIFY();
            //                 lcu_PurchaseDispoMgt.UpdateAssignedLines(Rec, xRec, DATABASE::Dispolines, FIELDNO(Quantity));
            //             END;
            // end;
        }
        field(7; "Licence Code"; Code[20])
        {
            Caption = 'Licence Code';
            DataClassification = CustomerContent;
            //TableRelation = "Import Licence"."Licence Code";
        }
        field(8; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(9; "Departure Datetext"; Text[30])
        {
            Caption = 'Departure Datetext';
            DataClassification = CustomerContent;
        }
        field(10; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure".Code;
        }
        field(15; "Code Description"; Code[2])
        {
            Caption = 'Code Description';
            DataClassification = CustomerContent;
            //TableRelation = "Description Dispolines".Code;

            // trigger OnValidate()
            // var
            //     lrc_DescriptionDispolines: Record "5110491";
            // begin
            //     IF "Code Description" <> xRec."Code Description" THEN
            //         IF "Code Description" <> '' THEN BEGIN
            //             lrc_DescriptionDispolines.Reset();
            //             IF lrc_DescriptionDispolines.GET("Code Description") THEN
            //                 Description := lrc_DescriptionDispolines.Description;
            //         END;
            // end;
        }
        field(20; "Batch Variant No. Document"; Code[20])
        {
            // CalcFormula = Lookup("Sales Line"."Batch Variant No." WHERE ("Document Type"=FIELD("Document Type"),
            //                                                              "Document No."=FIELD("Document No."),
            //                                                              "Line No."=FIELD("Document Line Line No.")));
            Caption = 'Batch Variant No. Document';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Unit of Measure Code Document"; Code[10])
        {
            CalcFormula = Lookup ("Sales Line"."Unit of Measure Code" WHERE("Document Type" = FIELD("Document Type"),
                                                                            "Document No." = FIELD("Document No."),
                                                                            "Line No." = FIELD("Document Line Line No.")));
            Caption = 'Unit of Measure Code Document';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Master Batch No. Document"; Code[20])
        {
            // CalcFormula = Lookup("Sales Line"."Master Batch No." WHERE ("Document Type"=FIELD("Document Type"),
            //                                                             "Document No."=FIELD("Document No."),
            //                                                             "Line No."=FIELD("Document Line Line No.")));
            Caption = 'Master Batch No. Document';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Batch No. Document"; Code[20])
        {
            // CalcFormula = Lookup("Sales Line"."Batch No." WHERE ("Document Type"=FIELD("Document Type"),
            //                                                      "Document No."=FIELD("Document No."),
            //                                                      "Line No."=FIELD("Document Line Line No.")));
            Caption = 'Batch No. Document';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            DataClassification = CustomerContent;
            //TableRelation = Batch.No.;
        }
        field(31; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            DataClassification = CustomerContent;
            NotBlank = true;
            //TableRelation = "Batch Variant";
        }
        field(32; "Target No"; Code[20])
        {
            Caption = 'Target No';
            DataClassification = CustomerContent;
            // TableRelation = IF ("Target Type" = CONST(Customer)) Customer."No."
            // ELSE
            // IF ("Target Type" = CONST("Customer Group")) "Customer Group".Code
            // ELSE
            // IF ("Target Type" = CONST("PreMaturation for Customer")) Customer."No."
            // ELSE
            // IF ("Target Type" = CONST(Location)) Location.Code WHERE("Vendor No." = FILTER(<> ''))
            // ELSE
            // IF ("Target Type" = CONST("PreMaturation for Location")) Location.Code WHERE("Vendor No." = FILTER(<> ''))
            // ELSE
            // IF ("Target Type" = CONST("Maturation at Location")) Location.Code WHERE("Vendor No." = FILTER(<> ''));
            // ValidateTableRelation = false;

            trigger OnValidate()
            // var
            //     lrc_Customer: Record Customer;
            //     lrc_CustomerGroup: Record "5110398";
            //     lcu_BaseData: Codeunit "5110301";
            //     lrc_Location: Record Location;
            begin
                CASE "Target Type" OF
                //  "Target Type"::Customer:
                //      IF NOT lcu_BaseData.CustomerNoValidate("Target No") THEN
                //          ERROR(AgilesText001Txt, "Target No");
                //         "Target Type"::"Customer Group":
                //             IF NOT lcu_BaseData.CustomerGroupValidate("Target No") THEN
                //                 ERROR(AgilesText002Txt, "Target No");
                //         "Target Type"::Location:
                //             IF NOT lrc_Location.GET("Target No") THEN
                //                 ERROR(AgilesText004Txt, "Target No");
                //         "Target Type"::"Maturation at Location":
                //             IF NOT lrc_Location.GET("Target No") THEN
                //                 ERROR(AgilesText004Txt, "Target No");
                //         "Target Type"::"PreMaturation for Location":
                //             IF NOT lrc_Location.GET("Target No") THEN
                //                 ERROR(AgilesText004Txt, "Target No");
                //         "Target Type"::"PreMaturation for Customer":
                //             IF NOT lcu_BaseData.CustomerNoValidate("Target No") THEN
                //                 ERROR(AgilesText001Txt, "Target No");
                END;

                //     IF (Rec."Target No" <> '') AND
                //        (xRec."Target No" <> Rec."Target No") THEN BEGIN
                //         IF "Target Type" = "Target Type"::Customer THEN BEGIN
                //             IF lrc_Customer.GET("Target No") THEN BEGIN
                //                 IF lrc_Customer."Licence Code" <> '' THEN
                //                     "Licence Code" := lrc_Customer."Licence Code";

                //                 "Gen. Bus. Posting Group" := lrc_Customer."Gen. Bus. Posting Group";
                //                 "Currency Code" := lrc_Customer."Currency Code";
                //                 "Target Name" := lrc_Customer.Name;
                //             END ELSE
                //                 "Target Name" := '';
                //         END ELSE BEGIN
                //             IF "Target Type" = "Target Type"::"Customer Group" THEN
                //                 lrc_CustomerGroup.GET("Target No");
                //             "Target Name" := lrc_CustomerGroup.Description;
                //             lrc_CustomerGroup.TESTFIELD("Main Customer No.");
                //             "Planning Customer" := lrc_CustomerGroup."Main Customer No.";
                //             "Customer Group" := "Target No";
                //             IF lrc_Customer.GET(lrc_CustomerGroup."Main Customer No.") THEN BEGIN
                //                 IF lrc_Customer."Licence Code" <> '' THEN
                //                     "Licence Code" := lrc_Customer."Licence Code";
                //                 "Gen. Bus. Posting Group" := lrc_Customer."Gen. Bus. Posting Group";
                //                 "Currency Code" := lrc_Customer."Currency Code";
                //             END;
                //         END ELSE
                //         IF "Target Type" = "Target Type"::Location THEN BEGIN
                //             lrc_Location.GET("Target No");
                //             "Target Name" := lrc_Location.Name;
                //         END ELSE
                //             IF "Target Type" = "Target Type"::"Maturation at Location" THEN BEGIN
                //                 lrc_Location.GET("Target No");
                //                 "Target Name" := lrc_Location.Name;
                //             END ELSE
                //                 IF "Target Type" = "Target Type"::"PreMaturation for Location" THEN BEGIN
                //                     lrc_Location.GET("Target No");
                //                     "Target Name" := lrc_Location.Name;
                //                 END ELSE
                //                     IF "Target Type" = "Target Type"::"PreMaturation for Customer" THEN
                //                         IF lrc_Customer.GET("Target No") THEN BEGIN
                //                             IF lrc_Customer."Licence Code" <> '' THEN
                //                                 "Licence Code" := lrc_Customer."Licence Code";
                //                             "Gen. Bus. Posting Group" := lrc_Customer."Gen. Bus. Posting Group";
                //                             "Currency Code" := lrc_Customer."Currency Code";
                //                             "Target Name" := lrc_Customer.Name;
                //                         END ELSE
                //                             "Target Name" := '';
                //         TransferfromBatchVar_Item(Rec);


                //         // Zusteller, Transportzeit für "Target No." vorschlagen
                //         SuggestShippingInfoForTargetNo();
                //         // Reifungszeit für "Target No." vorschlagen
                //         SuggestMaturatTimeForTargetNo();
                //         // Eingangsdatum berechnen
                //         CalcReceiptDate();

                //     END ELSE
                //         IF "Target No" = '' THEN BEGIN
                //             "Target Name" := '';
                //             "Customer Group" := '';
                //             "Planning Customer" := '';
                //         END;
            end;
        }
        field(33; "Planning Customer"; Code[20])
        {
            Caption = 'Planning Customer';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                lrc_Customer: Record Customer;
            begin
                TESTFIELD("Target Type", "Target Type"::Customer);

                IF (Rec."Planning Customer" <> '') AND
                   (xRec."Planning Customer" <> Rec."Planning Customer") THEN
                    IF lrc_Customer.GET("Planning Customer") THEN
                        IF lrc_Customer."POI Licence Code" <> '' THEN
                            "Licence Code" := lrc_Customer."POI Licence Code";
            end;
        }
        field(34; "Target Type"; Option)
        {
            Caption = 'Target Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Customer,Customer Group,Location,Maturation at Location,PreMaturation for Location,PreMaturation for Customer';
            OptionMembers = Customer,"Customer Group",Location,"Maturation at Location","PreMaturation for Location","PreMaturation for Customer";

            trigger OnValidate()
            begin
                IF "Target Type" <> xRec."Target Type" THEN BEGIN
                    "Maturation Location" := '';
                    "Bill-to Customer No." := '';
                    "Ship-to Code" := '';

                    TransferfromBatchVar_Item(Rec);

                    // Einige Felder abhängig vom "Target Type" zurücksetzen
                    ResetFieldsOnTargetType();

                    // Feld "Beleg nach Reiferei erstellen" abhängig vom "Empfänger Art" vorbelegen
                    SetCreateDocAfterPreMaturat();
                    // Bei Artikel muss das Feld "Umsetzung Artikelnr. In-/Output" abhängig vom "Empfänger Art" vorbelegt werden
                    TestTransformationItemNoInOut();
                END;
            end;
        }
        field(35; "Customer Group"; Code[10])
        {
            Caption = 'Customer Group';
            DataClassification = CustomerContent;
            //TableRelation = "Customer Group".Code;
        }
        field(39; "Price Base (Sales Price)"; Code[10])
        {
            Caption = 'Price Base (Sales Price)';
            DataClassification = CustomerContent;
            // TableRelation = "Price Base".Code WHERE("Purch./Sales Price Calc."=CONST("Sales Price"),
            //                                          Blocked=CONST(No));

        }
        field(40; "Sales Price (Price Base)"; Decimal)
        {
            Caption = 'Sales Price (Price Base)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                SSPText0001Txt: Label 'Do you want tol fill the price in alle Lines for customer %1 ?', Comment = '%1';
                SSPText0002Txt: Label 'Wollen Sie den Preis in alle Zeilen des gleichen Debitorgruppe %1 mit Währungscode %2 übertragen ?', Comment = '%1 %2';
                ltx_ConfirmText: Text[100];
            begin
                IF "Target No" <> '' THEN
                    IF ("Target Type" <> "Target Type"::Location) AND ("Target Type" <> "Target Type"::"Maturation at Location") AND ("Target Type" <> "Target Type"::"PreMaturation for Location") THEN
                        IF "Document Type" = "Document Type"::Position THEN
                            IF "Sales Price (Price Base)" <> xRec."Sales Price (Price Base)" THEN BEGIN
                                lrc_Dispolines.RESET();
                                lrc_Dispolines.SETCURRENTKEY("Batch No.", "Batch Variant No.", "Target No");
                                lrc_Dispolines.SETRANGE("Batch No.", "Batch No.");
                                lrc_Dispolines.SETRANGE("Batch Variant No.", "Batch Variant No.");
                                lrc_Dispolines.SETRANGE("Target No", "Target No");
                                lrc_Dispolines.SETRANGE("Target Type", "Target Type");
                                lrc_Dispolines.SETRANGE("Currency Code", "Currency Code");
                                IF lrc_Dispolines.FIND('-') THEN
                                    IF lrc_Dispolines.COUNT() > 1 THEN BEGIN
                                        IF ("Target Type" = "Target Type"::Customer) OR
                                           ("Target Type" = "Target Type"::"PreMaturation for Customer") THEN
                                            ltx_ConfirmText := SSPText0001Txt
                                        ELSE
                                            IF "Target Type" = "Target Type"::"Customer Group" THEN
                                                ltx_ConfirmText := SSPText0002Txt;
                                        IF CONFIRM(ltx_ConfirmText, TRUE, "Target No", "Currency Code") THEN
                                            REPEAT
                                                IF not ((lrc_Dispolines."Document Type" = "Document Type") AND (lrc_Dispolines."Document No." = "Document No.") AND
                                                   (lrc_Dispolines."Document Line Line No." = "Document Line Line No.") AND (lrc_Dispolines."Line No." = "Line No.")) THEN BEGIN
                                                    lrc_Dispolines."Sales Price (Price Base)" := "Sales Price (Price Base)";
                                                    lrc_Dispolines.MODIFY();
                                                END;
                                            UNTIL lrc_Dispolines.NEXT() = 0;
                                    END;

                            END;


            end;
        }
        field(60; "Maturation Location"; Code[10])
        {
            Caption = 'Maturation Location';
            DataClassification = CustomerContent;
            //TableRelation = Location.Code WHERE ("Vendor No."=FILTER(<>''));

            // trigger OnValidate()
            // var
            //     lrc_Location: Record Location;
            //     ReifText001Txt: Label 'Ein Reiferei Lagerort darf nur bei Herkunftsart ''Vorreifung für Lagerort'' oder ''Vorreifung für Kunde'' werden !';

            // begin
            //     IF ("Maturation Location" <> xRec."Maturation Location") AND
            //        ("Maturation Location" <> '') THEN BEGIN
            //         IF ("Target Type" = "Target Type"::"PreMaturation for Location") OR
            //            ("Target Type" = "Target Type"::"PreMaturation for Customer") THEN BEGIN
            //         END ELSE
            //             ERROR(ReifText001Txt);

            //         lrc_Location.GET("Maturation Location");
            //         lrc_Location.TESTFIELD("Pack. Doc. Subtype Code");
            //     END;
            //     // Transportzeit Reiferei Lagerort vorschlagen
            //     SuggestShippingInfoForMatLocat();
            //     // Reifungszeit Reiferei Lagerort vorschlagen
            //     SuggestMaturatTimeForMatLocat();
            //     // PVP 007 DMG50027.e
            // end;
        }
        field(88; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Business Posting Group";
        }
        field(91; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
            TableRelation = Currency;
        }
        field(99; "Created From Dispoline"; Date)
        {
            Caption = 'Created From Dispoline';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(100; "Planning Flag"; Option)
        {
            Caption = 'Planning Flag';
            DataClassification = CustomerContent;
            OptionCaption = 'Planning,Consultation,Reservation,Confirmation';
            OptionMembers = Planning,Consultation,Reservation,Confirmation;

            trigger OnValidate()
            var
                POIText001Txt: Label 'Soll das Planungskennzeichen in allen Datensätzen der Planungswoche %1 für %2 %3 aktualisiert werden ?', Comment = '%1 %2 %3';
                lco_DispositionForWeek: Code[5];
                AgilesText002Txt: Label 'Es konnte keine Planungswoche ermittelt werden !';
                lco_ReferenzNo: Code[20];
            begin
                IF ("Target No" <> '') THEN BEGIN

                    lco_DispositionForWeek := "Disposition For Week";
                    IF lco_DispositionForWeek = '' THEN
                        IF lrc_Batch.GET("Batch No.") THEN
                            lco_DispositionForWeek := lrc_Batch."Disposition Week";

                    IF "Target Type" = "Target Type"::"Customer Group" THEN
                        lco_ReferenzNo := "Customer Group"
                    ELSE
                        lco_ReferenzNo := "Target No";
                    IF lco_DispositionForWeek <> '' THEN BEGIN
                        IF CONFIRM(POIText001Txt, FALSE, lco_DispositionForWeek, FORMAT("Target Type"), lco_ReferenzNo) THEN BEGIN

                            // Planungszeilen dieser Woche
                            lrc_Batch.RESET();
                            lrc_Batch.SETCURRENTKEY("Disposition Week");
                            lrc_Batch.SETRANGE("Disposition Week", lco_DispositionForWeek);
                            IF lrc_Batch.FIND('-') THEN
                                REPEAT
                                    lrc_Dispolines.RESET();
                                    lrc_Dispolines.SETCURRENTKEY("Disposition For Week", "Target Type", "Target No", "Customer Group",
                                                                  "Batch No.", "Batch Variant No.");
                                    lrc_Dispolines.SETRANGE("Disposition For Week", '');
                                    lrc_Dispolines.SETRANGE("Target Type", "Target Type");
                                    IF "Target Type" = "Target Type"::"Customer Group" THEN
                                        lrc_Dispolines.SETRANGE("Customer Group", "Customer Group")
                                    ELSE
                                        lrc_Dispolines.SETRANGE("Target No", "Target No");
                                    lrc_Dispolines.SETRANGE("Batch No.", lrc_Batch."No.");
                                    IF lrc_Dispolines.FIND('-') THEN
                                        REPEAT
                                            IF not ((lrc_Dispolines."Document Type" = "Document Type") AND
                                               (lrc_Dispolines."Document No." = "Document No.") AND
                                               (lrc_Dispolines."Document Line Line No." = "Document Line Line No.") AND
                                               (lrc_Dispolines."Line No." = "Line No.")) THEN BEGIN
                                                lrc_Dispolines."Planning Flag" := "Planning Flag";
                                                lrc_Dispolines.MODIFY();
                                            END;
                                        UNTIL lrc_Dispolines.NEXT() = 0;
                                UNTIL lrc_Batch.NEXT() = 0;
                        END;

                        // verschobene Mengen => Planungszeilen
                        lrc_Dispolines.RESET();
                        lrc_Dispolines.SETCURRENTKEY("Disposition For Week", "Target Type", "Target No", "Customer Group",
                                                      "Batch No.", "Batch Variant No.");
                        lrc_Dispolines.SETRANGE("Disposition For Week", lco_DispositionForWeek);
                        lrc_Dispolines.SETRANGE("Target Type", "Target Type");
                        IF "Target Type" = "Target Type"::"Customer Group" THEN
                            lrc_Dispolines.SETRANGE("Customer Group", "Customer Group")
                        ELSE
                            lrc_Dispolines.SETRANGE("Target No", "Target No");
                        IF lrc_Dispolines.FIND('-') THEN
                            REPEAT
                                IF not ((lrc_Dispolines."Document Type" = "Document Type") AND
                                   (lrc_Dispolines."Document No." = "Document No.") AND
                                   (lrc_Dispolines."Document Line Line No." = "Document Line Line No.") AND
                                   (lrc_Dispolines."Line No." = "Line No.")) THEN BEGIN
                                    lrc_Dispolines."Planning Flag" := "Planning Flag";
                                    lrc_Dispolines.MODIFY();
                                END;
                            UNTIL lrc_Dispolines.NEXT() = 0;
                    END;
                END ELSE
                    MESSAGE(AgilesText002Txt);
            end;
        }
        field(101; "Target Name"; Text[100])
        {
            Caption = 'Target Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(110; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
            begin
                IF ("Bill-to Customer No." <> xRec."Bill-to Customer No.") AND ("Bill-to Customer No." <> '') THEN
                    IF ("Target Type" <> "Target Type"::Customer) AND ("Target Type" <> "Target Type"::"PreMaturation for Customer") THEN
                        ERROR(AgilesText011Txt);
            end;
        }
        field(120; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            DataClassification = CustomerContent;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Target No"));

            trigger OnValidate()
            begin
                IF ("Ship-to Code" <> xRec."Ship-to Code") AND ("Ship-to Code" <> '') THEN
                    IF ("Target Type" <> "Target Type"::Customer) AND ("Target Type" <> "Target Type"::"PreMaturation for Customer") THEN
                        ERROR(AgilesText011Txt);
            end;
        }
        field(150; "Your Reference"; Text[70])
        {
            Caption = 'Your Reference';
            DataClassification = CustomerContent;
        }
        field(200; "Loading Confirmed"; Boolean)
        {
            Caption = 'Loading Confirmed';
            DataClassification = CustomerContent;
        }
        field(201; "Quantity Zero Confirmed"; Boolean)
        {
            Caption = 'Quantity Zero Confirmed';
            DataClassification = CustomerContent;
        }
        field(250; "Original Planning Line Qty"; Decimal)
        {
            Caption = 'Original Planning Line Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(300; "No Document Generation"; Boolean)
        {
            Caption = 'No Document Generation';
            DataClassification = CustomerContent;
        }
        field(302; "Disposition For Week"; Code[5])
        {
            Caption = 'Disposition For Week';
            DataClassification = CustomerContent;

            // trigger OnValidate()
            // var
            //     lrc_Batch: Record Batch;
            //     SSPText01Txt: Label 'Die Planungswoche %1 ist bereits in der Positionskarte gesetzt !';
            //     lcu_PositionPlanning: Codeunit "5110345";
            // begin
            //     IF "Disposition For Week" <> '' THEN BEGIN
            //         Check_DispoKW("Disposition For Week");
            //         lrc_Batch.Reset();
            //         lrc_Batch.SETRANGE("No.", "Batch No.");
            //         IF lrc_Batch.FIND('-') THEN BEGIN
            //             IF (lrc_Batch."Disposition Week" <> '') AND
            //                (lrc_Batch."Disposition Week" = "Disposition For Week") THEN BEGIN
            //                 ERROR(SSPText01Txt, "Disposition For Week");
            //             END;
            //         END;
            //     END;

            //     // Die manuell eingegebene Planungswoche darf nicht vor der Planungswoche der Position liegen
            //     IF CurrFieldNo = FIELDNO("Disposition For Week") THEN BEGIN
            //         IF "Disposition For Week" = xRec."Disposition For Week" THEN BEGIN
            //             EXIT;
            //         END;

            //         lrc_Batch.GET("Batch No.");
            //         IF "Disposition For Week" <> '' THEN BEGIN
            //             TestDispoWeekBeforPosDispoWeek();
            //             // Abgansdatum auf den ersten Wochentag setzen, wenn noch nicht gefüllt
            //             IF "Departure Date" = 0D THEN BEGIN
            //                 VALIDATE("Departure Date", lcu_PositionPlanning.CalculateFirstWeekDay("Disposition For Week", lrc_Batch."Voyage No."));
            //             END ELSE BEGIN
            //                 // Prüfen, ob Datum in der Planungswoche liegt
            //                 lcu_PositionPlanning.TestDateBelongToDispoWeek("Departure Date", "Disposition For Week", lrc_Batch."Voyage No.");
            //             END;
            //         END ELSE BEGIN
            //             // Abgangsdatum auf den ersten Tag der Palanungswoche der Position setzen
            //             VALIDATE("Departure Date", lcu_PositionPlanning.CalculateFirstWeekDay(GetDispositionForWeek(), lrc_Batch."Voyage No."));
            //         END;
            //         // Eingangsdatum berechnen
            //         CalcReceiptDate();
            //     END;
            // end;
        }
        field(400; "Transport Unit of Measure (TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            DataClassification = CustomerContent;
            //TableRelation = "Unit of Measure" WHERE("Is Transport Unit of Measure"=CONST(Yes));

            // trigger OnValidate()
            // var
            //     lcu_UnitMgt: Codeunit "5110703";
            //     lrc_PurchaseLine: Record "Purchase Line";
            //     lrc_ItemTransportUnitFactor: Record "5087912";
            //     lrc_BatchVariant: Record "5110366";
            //     ldc_PalletFactor: Decimal;
            // begin
            //     IF "Transport Unit of Measure (TU)" <> '' THEN BEGIN

            //         IF ("Transport Unit of Measure (TU)" <> '') AND
            //            (CurrFieldNo <> 0) THEN BEGIN

            //             IF "Batch Variant No." <> '' THEN BEGIN
            //                 lrc_BatchVariant.GET("Batch Variant No.");
            //                 CASE "Target Type" OF
            //                     "Target Type"::Customer:
            //                         BEGIN
            //                             lcu_UnitMgt.GetItemVendorUnitPalletFactor(lrc_BatchVariant."Item No.",
            //                                                                       lrc_ItemTransportUnitFactor."Reference Typ"::Customer,
            //                                                                       "Target No",
            //                                                                       "Unit of Measure Code",
            //                                                                       0,
            //                                                                       "Transport Unit of Measure (TU)",
            //                                                                       '',
            //                                                                       ldc_PalletFactor);
            //                         END;
            //                     "Target Type"::"Customer Group":
            //                         BEGIN
            //                             lcu_UnitMgt.GetItemVendorUnitPalletFactor(lrc_BatchVariant."Item No.",
            //                                                                       lrc_ItemTransportUnitFactor."Reference Typ"::"Customer Group",
            //                                                                       "Target No",
            //                                                                       "Unit of Measure Code",
            //                                                                       0,
            //                                                                       "Transport Unit of Measure (TU)",
            //                                                                       '',
            //                                                                       ldc_PalletFactor);
            //                         END;
            //                 END;
            //             END;

            //             IF ldc_PalletFactor <> 0 THEN BEGIN
            //                 "Qty. (Unit) per Transp. Unit" := ldc_PalletFactor;
            //                 // Menge Paletten berechnen
            //                 IF "Qty. (Unit) per Transp. Unit" <> 0 THEN BEGIN
            //                     "Quantity (TU)" := Quantity / "Qty. (Unit) per Transp. Unit"
            //                 END ELSE BEGIN
            //                     "Quantity (TU)" := 0;
            //                 END;
            //             END;
            //         END;

            //     END ELSE BEGIN
            //         "Qty. (Unit) per Transp. Unit" := 0;
            //         "Quantity (TU)" := 0;
            //     END;

            // end;
        }
        field(401; "Qty. (Unit) per Transp. Unit"; Decimal)
        {
            Caption = 'Qty. (Unit) per Transp. Unit';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalcQuantity(FIELDNO("Qty. (Unit) per Transp. Unit"));
            end;
        }
        field(402; "Quantity (TU)"; Decimal)
        {
            Caption = 'Quantity (TU)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CalcQuantity(FIELDNO("Quantity (TU)"));
            end;
        }
        field(405; "Transport Temperature"; Decimal)
        {
            BlankZero = true;
            Caption = 'Transport Temperature';
            DataClassification = CustomerContent;
        }
        field(406; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            DataClassification = CustomerContent;
            Description = 'Zusteller für Debitor bzw. für Umlagerung nach Lagerort ("Source No.")';
            TableRelation = "Shipping Agent";
        }
        field(407; "Ship. Agent Maturat. Location"; Code[10])
        {
            Caption = 'Ship. Agent Maturat. Location';
            DataClassification = CustomerContent;
            Description = 'Zusteller für Umlagerung nach Reiferei Lagerort ("Maturation Location")';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                IF ("Target Type" <> "Target Type"::"PreMaturation for Location") AND
                   ("Target Type" <> "Target Type"::"PreMaturation for Customer") THEN
                    ERROR(AgilesText005Txt);
            end;
        }
        field(408; "Create Doc. After PreMaturat."; Boolean)
        {
            Caption = 'Create Doc. After PreMaturat.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF ("Target Type" <> "Target Type"::"PreMaturation for Location") AND
                   ("Target Type" <> "Target Type"::"PreMaturation for Customer")
                THEN
                    ERROR(AgilesText005Txt);
            end;
        }
        field(409; "Shipping Time"; DateFormula)
        {
            Caption = 'Shipping Time';
            Description = 'Transportzeit für Umlagerung nach Reiferei im Lagerort ("Source No.")';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                // Prüfen nur bei manueller Eingabe
                IF CurrFieldNo = FIELDNO("Shipping Time") THEN
                    TESTFIELD("Target No");
                // Eingangsdatum berechnen
                CalcReceiptDate();
            end;
        }
        field(410; "Ship. Time Maturat. Location"; DateFormula)
        {
            Caption = 'Shipping Time Maturat. Location';
            DataClassification = CustomerContent;
            Description = 'Transportzeit für Umlagerung nach Reiferei Lagerort ("Maturation Location")';

            trigger OnValidate()
            begin
                // PVP 007 DMG50027.s

                // Prüfen nur bei manueller Eingabe
                IF CurrFieldNo = FIELDNO("Ship. Time Maturat. Location") THEN
                    TESTFIELD("Target No");

                // Das Feld darf nur bei "Source Type" "PreMaturation for Location", "PreMaturation for Customer" editiert werden
                IF ("Target Type" <> "Target Type"::"PreMaturation for Location") AND
                   ("Target Type" <> "Target Type"::"PreMaturation for Customer")
                THEN
                    ERROR(AgilesText008Txt);


                // Prüfen nur bei manueller Eingabe im Feld
                IF CurrFieldNo = FIELDNO("Ship. Time Maturat. Location") THEN
                    TESTFIELD("Maturation Location");


                // Eingangsdatum berechnen
                CalcReceiptDate();

                // PVP 007 DMG50027.e
            end;
        }
        field(411; "Maturation Time"; DateFormula)
        {
            Caption = 'Maturation Time';
            DataClassification = CustomerContent;
            Description = 'Reifungszeit';

            trigger OnValidate()
            begin
                // Prüfen nur bei manueller Eingabe
                IF CurrFieldNo = FIELDNO("Maturation Time") THEN
                    TESTFIELD("Target No");

                // Das Feld darf nur bei "Source Type" "Maturation at Location", "PreMaturation for Location",
                //                       "PreMaturation for Customer" editiert werden
                IF ("Target Type" <> "Target Type"::"PreMaturation for Location") AND
                   ("Target Type" <> "Target Type"::"PreMaturation for Customer") AND
                   ("Target Type" <> "Target Type"::"Maturation at Location")
                THEN
                    ERROR(AgilesText009Txt);

                IF ("Target Type" = "Target Type"::"PreMaturation for Location") OR
                   ("Target Type" = "Target Type"::"PreMaturation for Customer")
                THEN
                    // Prüfen nur bei manueller Eingabe
                    IF CurrFieldNo = FIELDNO("Maturation Time") THEN
                        TESTFIELD("Maturation Location");



                // Eingangsdatum berechnen
                CalcReceiptDate();
            end;
        }
        field(419; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            DataClassification = CustomerContent;
            TableRelation = "Shipment Method";
        }
        field(420; "Receipt Date"; Date)
        {
            Caption = 'Receipt Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lin_DayOfTheWeek: Integer;
            begin
                IF "Receipt Date" <> 0D THEN BEGIN
                    lin_DayOfTheWeek := DATE2DWY("Receipt Date", 1);

                    CASE lin_DayOfTheWeek OF
                        1:
                            "Receipt Datetext" := 'MO';
                        2:
                            "Receipt Datetext" := 'DI';
                        3:
                            "Receipt Datetext" := 'MI';
                        4:
                            "Receipt Datetext" := 'DO';
                        5:
                            "Receipt Datetext" := 'FR';
                        6:
                            "Receipt Datetext" := 'SA';
                        7:
                            "Receipt Datetext" := 'SO';
                    END;

                    IF CurrFieldNo = FIELDNO("Receipt Date") THEN
                        CalcDepartureDate();

                END ELSE
                    "Receipt Datetext" := '';
            end;
        }
        field(421; "Receipt Datetext"; Text[30])
        {
            Caption = 'Receipt Datetext';
            DataClassification = CustomerContent;
        }
        field(422; "Intermed. Receipt Date 1"; Date)
        {
            Caption = 'Intermed. Receipt Date 1';
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate()
            var
                lin_DayOfTheWeek: Integer;
            begin
                IF "Intermed. Receipt Date 1" <> 0D THEN BEGIN
                    lin_DayOfTheWeek := DATE2DWY("Intermed. Receipt Date 1", 1);

                    CASE lin_DayOfTheWeek OF
                        1:
                            "Intermed. Receipt Datetext 1" := 'MO';
                        2:
                            "Intermed. Receipt Datetext 1" := 'DI';
                        3:
                            "Intermed. Receipt Datetext 1" := 'MI';
                        4:
                            "Intermed. Receipt Datetext 1" := 'DO';
                        5:
                            "Intermed. Receipt Datetext 1" := 'FR';
                        6:
                            "Intermed. Receipt Datetext 1" := 'SA';
                        7:
                            "Intermed. Receipt Datetext 1" := 'SO';
                    END;

                END ELSE
                    "Intermed. Receipt Datetext 1" := '';
            end;
        }
        field(423; "Intermed. Receipt Datetext 1"; Text[30])
        {
            Caption = 'Intermed. Receipt Datetext 1';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(424; "Intermed. Receipt Date 2"; Date)
        {
            Caption = 'Intermed. Receipt Date 2';
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate()
            var
                lin_DayOfTheWeek: Integer;
            begin
                IF "Intermed. Receipt Date 2" <> 0D THEN BEGIN
                    lin_DayOfTheWeek := DATE2DWY("Intermed. Receipt Date 2", 1);

                    CASE lin_DayOfTheWeek OF
                        1:
                            "Intermed. Receipt Datetext 2" := 'MO';
                        2:
                            "Intermed. Receipt Datetext 2" := 'DI';
                        3:
                            "Intermed. Receipt Datetext 2" := 'MI';
                        4:
                            "Intermed. Receipt Datetext 2" := 'DO';
                        5:
                            "Intermed. Receipt Datetext 2" := 'FR';
                        6:
                            "Intermed. Receipt Datetext 2" := 'SA';
                        7:
                            "Intermed. Receipt Datetext 2" := 'SO';
                    END;

                END ELSE
                    "Intermed. Receipt Datetext 2" := '';
            end;
        }
        field(425; "Intermed. Receipt Datetext 2"; Text[30])
        {
            Caption = 'Intermed. Receipt Datetext 2';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(500; Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Notification,Reservation';
            OptionMembers = " ",Notification,Reservation;
        }
        field(600; "Nos. Released as Print"; Integer)
        {
            Caption = 'Nos. Released as Print';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(601; "Last Date of Print"; DateTime)
        {
            Caption = 'Last Date of Print';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(610; "Nos. Released as Fax"; Integer)
        {
            Caption = 'Nos. Released as Fax';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(611; "Last Date of Fax"; DateTime)
        {
            Caption = 'Last Date of Fax';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(620; "Nos. Released as Mail"; Integer)
        {
            Caption = 'Nos. Released as Mail';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(621; "Last Date of Mail"; DateTime)
        {
            Caption = 'Last Date of Mail';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(630; Comment; Text[100])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(631; "Source Type Comment"; Text[100])
        {
            Caption = 'Source Type Comment';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                lrc_Dispolines.RESET();
                lrc_Dispolines.SETRANGE("Document Type", "Document Type");
                lrc_Dispolines.SETRANGE("Document No.", "Document No.");
                lrc_Dispolines.SETRANGE("Document Line Line No.", "Document Line Line No.");
                lrc_Dispolines.SETRANGE("Target Type", "Target Type");
                lrc_Dispolines.SETRANGE("Target No", "Target No");
                lrc_Dispolines.SETFILTER("Line No.", '<>%1', "Line No.");
                IF lrc_Dispolines.FIND('-') THEN
                    IF CONFIRM(AgilesText003Txt, TRUE, "Target Type", "Target No") THEN
                        REPEAT
                            lrc_Dispolines."Source Type Comment" := "Source Type Comment";
                            lrc_Dispolines.MODIFY(TRUE);
                        UNTIL lrc_Dispolines.NEXT() = 0;
            end;
        }
        field(651; "Document Type 2"; Option)
        {
            Caption = 'Document Type 2';
            DataClassification = CustomerContent;
            Editable = false;
            InitValue = Position;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,,,,Packing Order,,,,Position,,,,Reduced Purchase Order,,,,,Transfer Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,,,,"Packing Order",,,,Position,,,,"Reduced Purchase Order",,,,,"Transfer Order";
        }
        field(652; "Document No. 2"; Code[20])
        {
            Caption = 'Document No. 2';
            DataClassification = CustomerContent;
            Editable = false;
            // TableRelation = IF ("Document Type" = CONST(Order)) "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type"))
            // ELSE
            // IF ("Document Type" = CONST("Packing Order")) "Pack. Order Header"."No." WHERE ("Document Type"=CONST("Packing Order"))
            //                 ELSE IF ("Document Type"=CONST("Reduced Purchase Order")) "Purchase Header"."No." WHERE ("Document Type"=CONST(Order))
            //                 ELSE IF ("Document Type"=CONST("Transfer Order")) "Transfer Header"."No.";
        }
        field(653; "Document Line Line No. 2"; Integer)
        {
            Caption = 'Document Line Line No. 2';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(654; "Document Type 3"; Option)
        {
            Caption = 'Document Type 3';
            DataClassification = CustomerContent;
            Editable = false;
            InitValue = Position;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,,,,Packing Order,,,,Position,,,,Reduced Purchase Order,,,,,Transfer Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,,,,"Packing Order",,,,Position,,,,"Reduced Purchase Order",,,,,"Transfer Order";
        }
        field(655; "Document No. 3"; Code[20])
        {
            Caption = 'Document No. 3';
            DataClassification = CustomerContent;
            Editable = false;
            // TableRelation = IF ("Document Type" = CONST(Order)) "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type"))
            // ELSE
            // IF ("Document Type" = CONST("Packing Order")) "Pack. Order Header".No. WHERE ("Document Type"=CONST("Packing Order"))
            //                 ELSE IF ("Document Type"=CONST("Reduced Purchase Order")) "Purchase Header"."No." WHERE ("Document Type"=CONST(Order))
            //                 ELSE IF ("Document Type"=CONST("Transfer Order")) "Transfer Header"."No.";
        }
        field(656; "Document Line Line No. 3"; Integer)
        {
            Caption = 'Document Line Line No. 3';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Document Line Line No.", "Line No.")
        {
        }
        key(Key2; "Batch No.", "Batch Variant No.", "Document Line Line No.", "Target Type")
        {
            SumIndexFields = Quantity;
        }
        key(Key3; "Batch No.", "Batch Variant No.", "Target No")
        {
        }
        key(Key4; "Batch No.", "Target No", "Batch Variant No.")
        {
        }
        key(Key5; "Batch No.", "Planning Customer", "Batch Variant No.")
        {
        }
        key(Key6; "Batch No.", "Batch Variant No.", "Planning Customer")
        {
        }
        key(Key7; "Batch No.", "Target No", "Batch Variant No.", "Disposition For Week")
        {
        }
        key(Key8; "Batch No.", "Planning Customer", "Batch Variant No.", "Disposition For Week")
        {
        }
        key(Key9; "Batch No.", "Batch Variant No.", "Target No", "Disposition For Week")
        {
        }
        key(Key10; "Disposition For Week", "Target Type", "Target No", "Batch No.", "Batch Variant No.")
        {
        }
        key(Key11; "Disposition For Week", "Target Type", "Target No", "Customer Group", "Batch No.", "Batch Variant No.")
        {
        }
        key(Key12; "Document Type 2", "Document No. 2", "Document Line Line No. 2")
        {
        }
        key(Key13; "Document Type 3", "Document No. 3", "Document Line Line No. 3")
        {
        }
        key(Key14; "Batch No.", "Batch Variant No.", "Line No.")
        {
        }
    }



    trigger OnDelete()
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
    begin
        lrc_FruitVisionSetup.GET();
        IF lrc_FruitVisionSetup."Internal Customer Code" = 'INTERWEICHERT' THEN
            TESTFIELD("Document Type", "Document Type"::Position);
    end;

    trigger OnInsert()
    begin
        InitTransportTemperature();

        IF "Line No." = 0 THEN BEGIN
            lrc_Dispolines.RESET();
            lrc_Dispolines.SETCURRENTKEY("Batch No.", "Batch Variant No.", "Line No.");
            lrc_Dispolines.SETRANGE("Batch No.", "Batch No.");
            lrc_Dispolines.SETRANGE("Batch Variant No.", "Batch Variant No.");
            IF lrc_Dispolines.FIND('+') THEN
                "Line No." := lrc_Dispolines."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;
    end;

    trigger OnModify()
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
    begin
        lrc_FruitVisionSetup.GET();
        // IF lrc_FruitVisionSetup."Internal Customer Code" = 'INTERWEICHERT' THEN
        //     TESTFIELD("Document Type","Document Type"::Position);
        ResetFieldsOnTargetType();
        TestLocationsOnModify();
    end;

    procedure Check_DispoKW(var vCod_DispoKW: Code[5]) lOK: Boolean
    var

        lCod_KalenderWeek: Code[2];
        lInt_KalenderWeek: Integer;
        lCod_Year: Code[2];
        lInt_Year: Integer;
        SSPText0001Txt: Label 'The planning week doesn''t include the character _ !';
        SSPText0002Txt: Label 'The calendarweek couldn'' t  be generated !';
        SSPText0003Txt: Label 'The year couldn'' t  be generated !';
        lInt_StrPos_: Integer;
    begin
        lOK := TRUE;

        lInt_StrPos_ := STRPOS(vCod_DispoKW, '_');

        IF lInt_StrPos_ = 0 THEN BEGIN
            MESSAGE(SSPText0001Txt);
            lOK := FALSE;
        END ELSE BEGIN
            lCod_KalenderWeek := CopyStr(COPYSTR(vCod_DispoKW, 1, lInt_StrPos_ - 1), 1, 2);
            IF NOT EVALUATE(lInt_KalenderWeek, lCod_KalenderWeek) THEN BEGIN
                MESSAGE(SSPText0002Txt);
                lOK := FALSE;
            END;
            IF STRLEN(lCod_KalenderWeek) = 1 THEN
                lCod_KalenderWeek := CopyStr('0' + lCod_KalenderWeek, 1, 2);

            lCod_Year := COPYSTR(vCod_DispoKW, lInt_StrPos_ + 1, 2);
            IF NOT EVALUATE(lInt_Year, lCod_Year) THEN BEGIN
                MESSAGE(SSPText0003Txt);
                lOK := FALSE;
            END;
            IF STRLEN(lCod_Year) = 1 THEN
                lCod_Year := CopyStr('0' + lCod_Year, 1, 2);
        END;
        IF lOK = TRUE THEN
            vCod_DispoKW := lCod_KalenderWeek + '_' + lCod_Year
        ELSE
            vCod_DispoKW := '';


        EXIT(lOK);
    end;

    procedure TransferfromBatchVar_Item(var vrc_Dispolines: Record "POI Dispolines")
    // var
    //     lcu_UnitMgt: Codeunit "5110703";
    //     lrc_BatchVariant: Record "5110366";
    //     lrc_Item: Record Item;
    //     lrc_ItemTransportUnitFactor: Record "5087912";
    //     lrc_CustomerGroup: Record "5110398";
    //     lco_CustomerNo: Code[20];
    //     lco_BatchVariantFilter: Code[20];
    //     lrc_DispositionSetup: Record "5110488";
    begin
        //     IF vrc_Dispolines."Batch Variant No." <> '' THEN BEGIN
        //         lco_BatchVariantFilter := vrc_Dispolines."Batch Variant No.";
        //     END ELSE BEGIN
        //         IF vrc_Dispolines.GETFILTER("Batch Variant No.") <> '' THEN BEGIN
        //             lco_BatchVariantFilter := vrc_Dispolines.GETFILTER("Batch Variant No.");
        //         END;
        //     END;

        //     // Vorbelegung von Feldern aus Positionsvariante / Artikel
        //     lrc_BatchVariant.Reset();
        //     lrc_BatchVariant.SETFILTER("No.", lco_BatchVariantFilter);
        //     IF lrc_BatchVariant.FIND('-') THEN BEGIN
        //         IF lrc_BatchVariant.COUNT() = 1 THEN BEGIN
        //             vrc_Dispolines."Transport Unit of Measure (TU)" := lrc_BatchVariant."Transport Unit of Measure (TU)";
        //             vrc_Dispolines."Qty. (Unit) per Transp. Unit" := lrc_BatchVariant."Qty. (Unit) per Transp. (TU)";

        //             IF (lrc_BatchVariant."Sales Price (Price Base)" <> 0) AND
        //                (lrc_BatchVariant."Price Base (Sales Price)" <> '') THEN BEGIN
        //                 vrc_Dispolines."Price Base (Sales Price)" := lrc_BatchVariant."Price Base (Sales Price)";
        //                 vrc_Dispolines."Sales Price (Price Base)" := lrc_BatchVariant."Sales Price (Price Base)";
        //             END ELSE BEGIN
        //                 IF lrc_Item.GET(lrc_BatchVariant."Item No.") THEN BEGIN
        //                     vrc_Dispolines."Price Base (Sales Price)" := lrc_Item."Price Base (Sales Price)";
        //                     vrc_Dispolines."Sales Price (Price Base)" := lrc_Item."Unit Price";
        //                 END;
        //             END;
        //             IF "Transport Unit of Measure (TU)" = '' THEN BEGIN
        //                 IF lrc_Item.GET(lrc_BatchVariant."Item No.") THEN BEGIN
        //                     //vrc_Dispolines."Transport Unit of Measure (TU)" := lrc_Item."Transport Unit of Measure (TU)";
        //                 END;
        //             END;

        //             lco_CustomerNo := '';
        //             IF vrc_Dispolines."Target Type" = vrc_Dispolines."Target Type"::"Customer Group" THEN BEGIN
        //                 IF "Target No" <> '' THEN BEGIN
        //                     IF lrc_CustomerGroup.GET("Target No") THEN BEGIN
        //                         lco_CustomerNo := lrc_CustomerGroup."Main Customer No.";
        //                     END;
        //                 END;
        //             END ELSE BEGIN
        //                 lco_CustomerNo := "Target No";
        //             END;

        //             // kundenspezifische Felder vorbelegen
        //             IF ("Target Type" = "Target Type"::Location) OR
        //                ("Target Type" = "Target Type"::"Maturation at Location") OR
        //                ("Target Type" = "Target Type"::"PreMaturation for Location") OR
        //                ("Target Type" = "Target Type"::"PreMaturation for Customer") THEN BEGIN


        //             END ELSE BEGIN
        //                 IF lco_CustomerNo <> '' THEN BEGIN
        //                     lcu_UnitMgt.GetItemCustomerTransportUnit(lrc_BatchVariant."Item No.",
        //                                                              lrc_ItemTransportUnitFactor."Reference Typ"::Customer,
        //                                                              lco_CustomerNo,
        //                                                              "Unit of Measure Code",
        //                                                              "Transport Unit of Measure (TU)");
        //                 END;
        //             END;

        //             vrc_Dispolines.VALIDATE("Transport Unit of Measure (TU)");
        //             vrc_Dispolines.VALIDATE("Departure Date", lrc_BatchVariant."Date of Delivery");
        //             lrc_DispositionSetup.GET();
        //             vrc_Dispolines.VALIDATE("Shipment Method Code", lrc_DispositionSetup."Shipment Method");


        //         END;
        //     END;

    end;

    procedure CalcQuantity(vin_FieldNo: Integer)
    begin
        // --------------------------------------------------------------------------------------
        // Funktion zur Berechnung der Mengen
        // --------------------------------------------------------------------------------------

        IF CurrFieldNo <> vin_FieldNo THEN
            EXIT;

        CASE vin_FieldNo OF

            // -----------------------------------------------------------
            // Keine explizite Eingabe
            // -----------------------------------------------------------
            0:
                // Menge Transporteinheit berechnen
                IF "Qty. (Unit) per Transp. Unit" <> 0 THEN
                    "Quantity (TU)" := Quantity / "Qty. (Unit) per Transp. Unit"
                ELSE
                    "Quantity (TU)" := 0;

            // -----------------------------------------------------------
            // Eingabe Menge Verkaufseinheit
            // -----------------------------------------------------------
            FIELDNO(Quantity):

                // Menge Paletten berechnen
                IF "Qty. (Unit) per Transp. Unit" <> 0 THEN
                    "Quantity (TU)" := Quantity / "Qty. (Unit) per Transp. Unit"
                ELSE
                    "Quantity (TU)" := 0;


            // -----------------------------------------------------------
            // Eingabe Menge Transporteinheit
            // -----------------------------------------------------------
            FIELDNO("Quantity (TU)"):

                // Menge Kolli berechnen
                VALIDATE(Quantity, ("Quantity (TU)" * "Qty. (Unit) per Transp. Unit"));

            // -----------------------------------------------------------
            // Eingabe Menge Einheiten pro Transporteinheit
            // -----------------------------------------------------------
            FIELDNO("Qty. (Unit) per Transp. Unit"):

                // Menge Paletten berechnen
                IF "Qty. (Unit) per Transp. Unit" <> 0 THEN
                    "Quantity (TU)" := Quantity / "Qty. (Unit) per Transp. Unit"
                ELSE
                    "Quantity (TU)" := 0;
        END;
    end;

    procedure SuggestShippingInfoForCustomer(vco_CustomerNo: Code[20]; var rco_ShippingAgentCode: Code[10]; var rdf_ShippingTime: DateFormula)
    var
        lrc_Customer: Record Customer;
    begin
        rco_ShippingAgentCode := '';
        EVALUATE(rdf_ShippingTime, '');

        IF vco_CustomerNo = '' THEN
            EXIT;

        lrc_Customer.GET(vco_CustomerNo);
        rco_ShippingAgentCode := lrc_Customer."Shipping Agent Code";
        rdf_ShippingTime := lrc_Customer."Shipping Time";
    end;

    // procedure SuggestShippingInfoForTargetNo()
    // var

    //     lrc_Customer: Record Customer;
    //     lrc_CustomerGroup: Record "5110398";
    //     ldf_ShippingTime: DateFormula;
    //     lco_ShippingAgentCode: Code[10];

    // begin
    //     // ------------------------------------------------
    //     // Transportzeit und Zusteller werden vorgeschlagen
    //     // ------------------------------------------------
    //     IF "Target No" = '' THEN BEGIN
    //         EVALUATE("Shipping Time", '');
    //         "Shipping Agent Code" := '';
    //         EXIT;
    //     END;

    //     CASE "Target Type" OF
    //         "Target Type"::"Customer Group":
    //             BEGIN
    //                 lrc_CustomerGroup.GET("Target No");
    //                 SuggestShippingInfoForCustomer(lrc_CustomerGroup."Main Customer No.", lco_ShippingAgentCode, ldf_ShippingTime);
    //                 VALIDATE("Shipping Time", ldf_ShippingTime);
    //                 "Shipping Agent Code" := lco_ShippingAgentCode;
    //             END;
    //         "Target Type"::Customer, "Target Type"::"PreMaturation for Customer":
    //             BEGIN
    //                 SuggestShippingInfoForCustomer("Target No", lco_ShippingAgentCode, ldf_ShippingTime);
    //                 VALIDATE("Shipping Time", ldf_ShippingTime);
    //                 "Shipping Agent Code" := lco_ShippingAgentCode;
    //             END;
    //         "Target Type"::Location, "Target Type"::"Maturation at Location":
    //             BEGIN
    //                 SuggestShippingInfoForTransfer(GetBatchVariantLocationCode2, "Target No", lco_ShippingAgentCode, ldf_ShippingTime);
    //                 VALIDATE("Shipping Time", ldf_ShippingTime);
    //                 "Shipping Agent Code" := lco_ShippingAgentCode;
    //             END;
    //         "Target Type"::"PreMaturation for Location":
    //             BEGIN
    //                 SuggestShippingInfoForTransfer("Maturation Location", "Target No", lco_ShippingAgentCode, ldf_ShippingTime);
    //                 VALIDATE("Shipping Time", ldf_ShippingTime);
    //                 IF lco_ShippingAgentCode <> '' THEN BEGIN
    //                     "Shipping Agent Code" := lco_ShippingAgentCode;
    //                 END;
    //             END;
    //     END;
    // end;

    // procedure SuggestShippingInfoForMatLocat()
    // var
    //     lco_ShippingAgentCode: Code[10];
    //     ldf_ShippingTime: DateFormula;
    // begin
    //     // ------------------------------------------------------------------
    //     // Transportzeit und Zusteller Reiferei Lagerort werden vorgeschlagen
    //     // ------------------------------------------------------------------
    //     CASE "Target Type" OF
    //         "Target Type"::"PreMaturation for Location":
    //             BEGIN
    //                 IF "Maturation Location" = '' THEN BEGIN
    //                     EVALUATE("Ship. Time Maturat. Location", '');
    //                     "Ship. Agent Maturat. Location" := '';
    //                 END ELSE BEGIN
    //                     SuggestShippingInfoForTransfer(GetBatchVariantLocationCode2, "Maturation Location", lco_ShippingAgentCode, ldf_ShippingTime);
    //                     VALIDATE("Ship. Time Maturat. Location", ldf_ShippingTime);
    //                     "Ship. Agent Maturat. Location" := lco_ShippingAgentCode;
    //                 END;

    //                 IF "Target No" = '' THEN BEGIN
    //                     EVALUATE("Shipping Time", '');
    //                     "Shipping Agent Code" := '';
    //                 END ELSE BEGIN
    //                     SuggestShippingInfoForTransfer("Maturation Location", "Target No", lco_ShippingAgentCode, ldf_ShippingTime);
    //                     VALIDATE("Shipping Time", ldf_ShippingTime);
    //                     "Shipping Agent Code" := lco_ShippingAgentCode;
    //                 END;
    //             END;
    //         "Target Type"::"PreMaturation for Customer":
    //             BEGIN
    //                 IF "Maturation Location" = '' THEN BEGIN
    //                     EVALUATE("Ship. Time Maturat. Location", '');
    //                     "Ship. Agent Maturat. Location" := '';
    //                 END ELSE BEGIN
    //                     SuggestShippingInfoForTransfer(GetBatchVariantLocationCode2, "Maturation Location", lco_ShippingAgentCode, ldf_ShippingTime);
    //                     VALIDATE("Ship. Time Maturat. Location", ldf_ShippingTime);
    //                     "Ship. Agent Maturat. Location" := lco_ShippingAgentCode;
    //                 END;
    //             END;
    //     END;
    // end;

    // procedure SuggestShippingInfoForTransfer(vco_TransferFromCode: Code[10]; vco_TransferToCode: Code[10]; var rco_ShippingAgentCode: Code[10]; var rdf_ShippingTime: DateFormula)
    // var
    //     lrc_TransferDocSubtype: Record "5110412";
    //     lrc_Location: Record Location;
    // begin
    //     // Zusteller Code wird auch aus der Belegunterart ermittellt und zurückgegeben
    //     rco_ShippingAgentCode := '';
    //     EVALUATE(rdf_ShippingTime(), '');

    //     IF (vco_TransferFromCode = '') OR (vco_TransferToCode = '') THEN BEGIN
    //         EXIT;
    //     END;

    //     lrc_TransferDocSubtype.Reset();
    //     lrc_TransferDocSubtype.SETRANGE("From Location Code", vco_TransferFromCode);
    //     lrc_TransferDocSubtype.SETRANGE("To Location Code", vco_TransferToCode);
    //     IF lrc_TransferDocSubtype.FIND('-') THEN BEGIN
    //         rco_ShippingAgentCode := lrc_TransferDocSubtype."Shipping Agent Code";
    //         rdf_ShippingTime := lrc_TransferDocSubtype."Shipping Time";
    //     END;
    // end;

    // procedure SuggestMaturatTimeForTargetNo()
    // var
    //     ldf_MaturationTime: DateFormula;
    // begin
    //     // ---------------------------------------
    //     // Reifungszeit wird vorgeschlagen
    //     // ---------------------------------------
    //     CASE "Target Type" OF
    //         "Target Type"::Customer, "Target Type"::"Customer Group", "Target Type"::Location:
    //             BEGIN
    //                 EVALUATE("Maturation Time", '');
    //             END;
    //         "Target Type"::"Maturation at Location":
    //             BEGIN
    //                 IF "Target No" = '' THEN BEGIN
    //                     EVALUATE("Maturation Time", '');
    //                 END ELSE BEGIN
    //                     SuggestMaturatTimeForLocation("Target No", ldf_MaturationTime);
    //                     VALIDATE("Maturation Time", ldf_MaturationTime);
    //                 END;
    //             END;
    //     END;
    // end;

    // procedure SuggestMaturatTimeForMatLocat()
    // var
    //     ldf_MaturationTime: DateFormula;
    // begin
    //     // ---------------------------------------
    //     // Reifungszeit wird vorgeschlagen
    //     // ---------------------------------------
    //     CASE "Target Type" OF
    //         "Target Type"::"PreMaturation for Location", "Target Type"::"PreMaturation for Customer":
    //             BEGIN
    //                 SuggestMaturatTimeForLocation("Maturation Location", ldf_MaturationTime);
    //                 VALIDATE("Maturation Time", ldf_MaturationTime);
    //             END;
    //     END;
    // end;

    // procedure SuggestMaturatTimeForLocation(vco_LocationCode: Code[10]; var rdf_MaturationTime: DateFormula)
    // var
    //     lrc_Location: Record Location;
    //     lrc_Vendor: Record Vendor;
    //     lrc_RecipePackingSetup: Record "5110701";
    // begin
    //     EVALUATE(rdf_MaturationTime(), '');

    //     IF vco_LocationCode = '' THEN BEGIN
    //         EXIT;
    //     END;
    //     IF NOT lrc_Location.GET(vco_LocationCode) THEN
    //         EXIT;


    //     IF lrc_Location."Vendor No." <> '' THEN
    //         IF lrc_Vendor.GET(lrc_Location."Vendor No.") THEN
    //             rdf_MaturationTime := lrc_Vendor."Maturation Time";


    //     // Einrichtung untersuchen, wenn die Reifungszeit noch nicht ermittelt wurde
    //     IF CALCDATE(rdf_MaturationTime(), TODAY) = TODAY THEN BEGIN
    //         lrc_RecipePackingSetup.GET();
    //         IF lrc_RecipePackingSetup."Default Pack.-by Vendor No." <> '' THEN BEGIN
    //             IF lrc_Vendor.GET(lrc_RecipePackingSetup."Default Pack.-by Vendor No.") THEN BEGIN
    //                 rdf_MaturationTime := lrc_Vendor."Maturation Time";
    //             END;
    //         END;
    //     END;

    // end;

    // procedure GetBatchVariantLocationCode(): Code[20]
    // var
    //     lrc_BatchVariant: Record "5110366";
    //     lrc_PurchaseLine: Record "Purchase Line";
    //     lco_LocationCode: Code[10];
    // begin
    //     lrc_BatchVariant.GET("Batch Variant No.");
    //     IF lrc_PurchaseLine.GET(lrc_BatchVariant.Source, lrc_BatchVariant."Source No.", lrc_BatchVariant."Source Line No.") THEN BEGIN
    //         lrc_PurchaseLine.TESTFIELD("Location Code");
    //         lco_LocationCode := lrc_PurchaseLine."Location Code"
    //     END ELSE BEGIN
    //         lrc_BatchVariant.TESTFIELD("Entry Location Code");
    //         lco_LocationCode := lrc_BatchVariant."Entry Location Code";
    //     END;
    //     EXIT(lco_LocationCode);
    // end;

    // procedure GetBatchVariantLocationCode2(): Code[20]
    // var
    //     lrc_BatchVariant: Record "5110366";
    // begin
    //     lrc_BatchVariant.GET("Batch Variant No.");
    //     EXIT(lrc_BatchVariant."Entry Location Code");
    // end;

    procedure ResetFieldsOnTargetType()
    begin
        // -------------------------------------------------------------------------------
        // Einige Felder sind von anderen abhängig und müssen evtl. zurückgesetzt werden
        // -------------------------------------------------------------------------------
        CASE "Target Type" OF
            "Target Type"::Customer, "Target Type"::"Customer Group", "Target Type"::Location, "Target Type"::"Maturation at Location":
                BEGIN
                    "Create Doc. After PreMaturat." := FALSE;
                    "Ship. Agent Maturat. Location" := '';
                    EVALUATE("Ship. Time Maturat. Location", '');
                END;
        END;

        CASE "Target Type" OF
            "Target Type"::Customer, "Target Type"::"Customer Group", "Target Type"::Location:
                EVALUATE("Maturation Time", '');
        END;

        IF "Target No" = '' THEN BEGIN
            "Shipping Agent Code" := '';
            EVALUATE("Shipping Time", '');
            IF "Target Type" = "Target Type"::"Maturation at Location" THEN
                EVALUATE("Maturation Time", '');
            "Shipment Method Code" := '';
        END;

        IF "Maturation Location" = '' THEN BEGIN
            "Ship. Agent Maturat. Location" := '';
            EVALUATE("Ship. Time Maturat. Location", '');
            IF "Target Type" <> "Target Type"::"Maturation at Location" THEN
                EVALUATE("Maturation Time", '');
        END;
    end;

    procedure TestLocationsOnModify()
    // var
    //     lco_LocationCodeBatchVariant: Code[20];
    begin
        //     // -------------------------------------------------------------------------------
        //     // Für eine evtl. Umlagerung die Lagerorte dürfen nicht identisch sein
        //     // -------------------------------------------------------------------------------
        //     lco_LocationCodeBatchVariant := GetBatchVariantLocationCode();
        //     CASE "Target Type" OF
        //         "Target Type"::Location, "Target Type"::"Maturation at Location":
        //             BEGIN
        //                 IF ("Target No" <> '') AND ("Target No" = lco_LocationCodeBatchVariant) THEN BEGIN
        //                     ERROR(AgilesText006Txt, "Line No.");
        //                 END;
        //             END;

        //         "Target Type"::"PreMaturation for Location":
        //             BEGIN
        //                 IF ("Maturation Location" <> '') AND ("Maturation Location" = lco_LocationCodeBatchVariant) THEN BEGIN
        //                     ERROR(AgilesText006Txt, "Line No.");
        //                 END;
        //                 IF ("Maturation Location" <> '') AND ("Target No" <> '') AND ("Maturation Location" = "Target No") THEN BEGIN
        //                     ERROR(AgilesText006Txt, "Line No.");
        //                 END;

        //             END;

        //         "Target Type"::"PreMaturation for Customer":
        //             BEGIN
        //                 IF ("Maturation Location" <> '') AND ("Maturation Location" = lco_LocationCodeBatchVariant) THEN BEGIN
        //                     ERROR(AgilesText006Txt, "Line No.");
        //                 END;
        //             END;

        //     END;
    end;

    procedure InitTransportTemperature()
    // var
    //     lrc_BatchVariant: Record "5110366";
    //     lrc_Item: Record Item;
    //     lrc_ProductGroup: Record "5723";
    begin
        //     lrc_BatchVariant.GET("Batch Variant No.");
        //     lrc_Item.GET(lrc_BatchVariant."Item No.");
        //     "Transport Temperature" := lrc_Item."Transport Temperature";

        //     IF "Transport Temperature" = 0 THEN BEGIN
        //         IF (lrc_Item."Product Group Code" <> '') AND (lrc_Item."Item Category Code" <> '') THEN BEGIN
        //             IF lrc_ProductGroup.GET(lrc_Item."Product Group Code") THEN BEGIN
        //                 "Transport Temperature" := lrc_ProductGroup."Transport Temperature";
        //             END;
        //         END;
        //     END;
    end;

    procedure ShowDocument2()
    var
        lrc_SalesHeader: Record "Sales Header";
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
        lrc_TransferHeader: Record "Transfer Header";
        lcu_RecipePackingManagement: Codeunit "POI ADF Recipe & Packing Mgt";
        lcu_TransferManagement: Codeunit "POI Transfer Management";
        lcu_sales: Codeunit "POI Sales Mgt";
    begin
        IF "Document Type 2" = "Document Type 2"::Position THEN
            FIELDERROR("Document Type 2");
        TESTFIELD("Document No. 2");
        IF ("Document Type 2" = "Document Type 2"::Order) THEN BEGIN
            lrc_SalesHeader.GET(lrc_SalesHeader."Document Type"::Order, "Document No. 2");
            lcu_Sales.ShowSalesOrder(lrc_SalesHeader."Document Type", "Document No. 2", FALSE, FALSE);
            EXIT;
        END;
        IF ("Document Type 2" = "Document Type 2"::"Packing Order") THEN BEGIN
            lrc_PackOrderHeader.GET("Document No. 2");
            lcu_RecipePackingManagement.PackShowOrder(lrc_PackOrderHeader."No.");
            EXIT;
        END;
        IF ("Document Type 2" = "Document Type 2"::"Transfer Order") THEN BEGIN
            lrc_TransferHeader.GET("Document No. 2");
            lcu_TransferManagement.ShowTransferOrder("Document No. 2", '');
            EXIT;
        END;
    end;

    procedure ShowDocument3()
    // var
    //     lrc_SalesHeader: Record "Sales Header";
    //     lcu_Sales: Codeunit "5110324";
    //     lrc_PackOrderHeader: Record "5110712";
    //     lrc_PurchMgt: Codeunit "5110323";
    //     lcu_RecipePackingManagement: Codeunit "5110700";
    //     lrc_TransferHeader: Record "Transfer Header";
    //     lcu_TransferManagement: Codeunit "5110322";
    begin
        //     IF "Document Type 3" = "Document Type 3"::Position THEN BEGIN
        //         FIELDERROR("Document Type 3");
        //     END;
        //     TESTFIELD("Document No. 3");

        //     IF ("Document Type 3" = "Document Type 3"::Order) THEN BEGIN
        //         lrc_SalesHeader.GET(lrc_SalesHeader."Document Type"::Order, "Document No. 3");
        //         lcu_Sales.ShowSalesOrder(lrc_SalesHeader."Document Type", "Document No. 3", FALSE, FALSE);
        //         EXIT;
        //     END;

        //     IF ("Document Type 3" = "Document Type 3"::"Packing Order") THEN BEGIN
        //         lrc_PackOrderHeader.GET("Document No. 3");
        //         lcu_RecipePackingManagement.PackShowOrder(lrc_PackOrderHeader."No.");
        //         EXIT;
        //     END;

        //     IF ("Document Type 3" = "Document Type 3"::"Transfer Order") THEN BEGIN
        //         lrc_TransferHeader.GET("Document No. 3");
        //         lcu_TransferManagement.ShowTransferOrder("Document No. 3", '');
        //         EXIT;
        //     END;
    end;

    procedure SetCreateDocAfterPreMaturat()
    begin
        // -------------------------------------------------------------------------------
        // Feld "Beleg nach Reiferei erstellen" abhängig vom "Empfänger Art" vorbelegen
        // -------------------------------------------------------------------------------
        CASE "Target Type" OF

            "Target Type"::Customer, "Target Type"::"Customer Group", "Target Type"::Location, "Target Type"::"Maturation at Location":
                "Create Doc. After PreMaturat." := FALSE;

            "Target Type"::"PreMaturation for Location", "Target Type"::"PreMaturation for Customer":
                "Create Doc. After PreMaturat." := TRUE;
        END;
    end;

    procedure TestTransformationItemNoInOut()
    // var
    //     lrc_Item: Record Item;
    //     lrc_BatchVariant: Record "5110366";
    begin
        //     // ----------------------------------------------------------------------------------------------------------
        //     // Bei Artikel muss das Feld "Umsetzung Artikelnr. In-/Output" abhängig vom "Empfänger Art" vorbelegt werden
        //     // ----------------------------------------------------------------------------------------------------------
        //     IF "Batch Variant No." = '' THEN BEGIN
        //         EXIT;
        //     END;

        //     CASE "Target Type" OF

        //         "Target Type"::Customer, "Target Type"::"Customer Group":
        //             BEGIN
        //                 EXIT;
        //             END;

        //         "Target Type"::Location:
        //             BEGIN
        //                 lrc_BatchVariant.GET("Batch Variant No.");
        //                 lrc_Item.GET(lrc_BatchVariant."Item No.");
        //                 IF lrc_Item."Transformation Item No In-/Out" <> '' THEN BEGIN
        //                     MESSAGE(STRSUBSTNO(AgilesText012Txt, FIELDCAPTION("Target Type"), FORMAT("Target Type"), lrc_Item."No.",
        //                                        lrc_Item.FIELDCAPTION("Transformation Item No In-/Out"), lrc_Item."Transformation Item No In-/Out"));
        //                 END;
        //                 EXIT;
        //             END;

        //         "Target Type"::"Maturation at Location", "Target Type"::"PreMaturation for Location", "Target Type"::"PreMaturation for Customer":
        //             BEGIN
        //                 lrc_BatchVariant.GET("Batch Variant No.");
        //                 lrc_Item.GET(lrc_BatchVariant."Item No.");
        //                 lrc_Item.TESTFIELD("Transformation Item No In-/Out");
        //             END;

        //     END;
    end;

    procedure TestDateBeforeFirstWeekday(): Boolean
    // var
    //     ldt_DateHelp: Date;
    //     lcu_PositionPlanning: Codeunit "5110345";
    //     lrc_Batch: Record "Batch";
    begin
        //     IF "Departure Date" = 0D THEN BEGIN
        //         EXIT;
        //     END;

        //     lrc_Batch.GET("Batch No.");
        //     ldt_DateHelp := lcu_PositionPlanning.CalculateFirstWeekDay(GetDispositionForWeek(), lrc_Batch."Voyage No.");
        //     IF "Departure Date" < ldt_DateHelp THEN BEGIN
        //         FIELDERROR("Departure Date");
        //     END;
    end;

    procedure GetDispositionForWeek(): Code[5]
    begin
        IF "Disposition For Week" <> '' THEN
            EXIT("Disposition For Week");

        lrc_Batch.GET("Batch No.");
        EXIT(lrc_Batch."Disposition Week");
    end;

    procedure SetDispositionForWeek()
    begin

    end;

    procedure TestDispoWeekBeforPosDispoWeek()
    // var
    //     lrc_Batch: Record Batch;
    //     lcu_PositionPlanning: Codeunit "5110345";
    begin
        //     // Die manuell eingegebene Planungswoche darf nicht vor der Planungswoche der Position liegen

        //     IF "Disposition For Week" = '' THEN BEGIN
        //         EXIT;
        //     END;

        //     lrc_Batch.GET("Batch No.");

        //     IF lcu_PositionPlanning.CalculateFirstWeekDay("Disposition For Week", lrc_Batch."Voyage No.") <
        //        lcu_PositionPlanning.CalculateFirstWeekDay(lrc_Batch."Disposition Week", lrc_Batch."Voyage No.")
        //     THEN BEGIN
        //         FIELDERROR("Disposition For Week");
        //     END;
    end;

    procedure CalcReceiptDate()
    begin
        IF "Departure Date" = 0D THEN BEGIN
            VALIDATE("Intermed. Receipt Date 1", 0D);
            VALIDATE("Intermed. Receipt Date 2", 0D);
            VALIDATE("Receipt Date", 0D);
            EXIT;
        END;

        CASE "Target Type" OF

            "Target Type"::Customer, "Target Type"::"Customer Group", "Target Type"::Location:
                BEGIN
                    VALIDATE("Intermed. Receipt Date 1", 0D);
                    VALIDATE("Intermed. Receipt Date 2", 0D);
                    VALIDATE("Receipt Date", CALCDATE("Shipping Time", "Departure Date"));
                END;

            "Target Type"::"Maturation at Location":
                BEGIN
                    VALIDATE("Intermed. Receipt Date 2", 0D);
                    VALIDATE("Intermed. Receipt Date 1", CALCDATE("Shipping Time", "Departure Date"));
                    VALIDATE("Receipt Date", CALCDATE("Maturation Time", "Intermed. Receipt Date 1"));
                END;

            "Target Type"::"PreMaturation for Location", "Target Type"::"PreMaturation for Customer":
                BEGIN
                    VALIDATE("Intermed. Receipt Date 1", CALCDATE("Ship. Time Maturat. Location", "Departure Date"));
                    VALIDATE("Intermed. Receipt Date 2", CALCDATE("Maturation Time", "Intermed. Receipt Date 1"));
                    VALIDATE("Receipt Date", CALCDATE("Shipping Time", "Intermed. Receipt Date 2"));
                END;

        END;

        IF "Receipt Date" < "Departure Date" THEN
            ERROR(AgilesText010Txt, "Receipt Date", "Departure Date");
    end;

    procedure CalcDepartureDate()
    var
        ldt_DateHelp: Date;
    begin
        IF "Receipt Date" = 0D THEN
            EXIT;


        CASE "Target Type" OF

            "Target Type"::Customer, "Target Type"::"Customer Group", "Target Type"::Location:
                BEGIN
                    VALIDATE("Intermed. Receipt Date 1", 0D);
                    VALIDATE("Intermed. Receipt Date 2", 0D);
                    ldt_DateHelp := CALCDATE("Shipping Time", "Receipt Date");
                    VALIDATE("Departure Date", "Receipt Date" - (ldt_DateHelp - "Receipt Date"));
                END;

            "Target Type"::"Maturation at Location":
                BEGIN
                    VALIDATE("Intermed. Receipt Date 2", 0D);
                    ldt_DateHelp := CALCDATE("Maturation Time", "Receipt Date");
                    VALIDATE("Intermed. Receipt Date 1", "Receipt Date" - (ldt_DateHelp - "Receipt Date"));
                    ldt_DateHelp := CALCDATE("Shipping Time", "Intermed. Receipt Date 1");
                    VALIDATE("Departure Date", "Intermed. Receipt Date 1" - (ldt_DateHelp - "Intermed. Receipt Date 1"));
                END;

            "Target Type"::"PreMaturation for Location", "Target Type"::"PreMaturation for Customer":
                BEGIN
                    ldt_DateHelp := CALCDATE("Shipping Time", "Receipt Date");
                    VALIDATE("Intermed. Receipt Date 2", "Receipt Date" - (ldt_DateHelp - "Receipt Date"));
                    ldt_DateHelp := CALCDATE("Maturation Time", "Intermed. Receipt Date 2");
                    VALIDATE("Intermed. Receipt Date 1", "Intermed. Receipt Date 2" - (ldt_DateHelp - "Intermed. Receipt Date 2"));
                    ldt_DateHelp := CALCDATE("Ship. Time Maturat. Location", "Intermed. Receipt Date 1");
                    VALIDATE("Departure Date", "Intermed. Receipt Date 1" - (ldt_DateHelp - "Intermed. Receipt Date 1"));
                END;

        END;

        IF "Receipt Date" < "Departure Date" THEN
            ERROR(AgilesText010Txt, "Receipt Date", "Departure Date");
    end;

    procedure UpdateAssignLineFromDispoline(vin_FieldNo: Integer; vin_DocumentLevel: Integer)
    // var
    //     lrc_SalesLine: Record "Sales Line";
    //     lrc_TransferLine: Record "Transfer Line";
    //     lrc_PackOrderInputItems: Record "5110714";
    //     lrc_PackOrderOutputItems: Record "5110713";
    //     lrc_Dispolines: Record Dispolines;
    begin
        //     CASE vin_DocumentLevel OF
        //         1:
        //             BEGIN
        //                 IF ("Document No." = '') OR ("Document Line Line No." = 0) THEN BEGIN
        //                     EXIT;
        //                 END;
        //                 CASE "Document Type" OF
        //                     "Document Type"::Order:
        //                         BEGIN

        //                             // Verkaufszeile
        //                             lrc_SalesLine.GET(lrc_SalesLine."Document Type"::Order,
        //                                               "Document No.",
        //                                               "Document Line Line No.");
        //                             lrc_SalesLine.ADF_SetIndirectCall(TRUE);
        //                             CASE vin_FieldNo OF
        //                                 FIELDNO(Quantity):
        //                                     lrc_SalesLine.VALIDATE(Quantity, Quantity);
        //                             END;
        //                             lrc_SalesLine.MODIFY(TRUE);

        //                         END;
        //                     "Document Type"::"Packing Order":
        //                         BEGIN

        //                             // Outputzeile
        //                             lrc_PackOrderOutputItems.GET("Document No.", "Document Line Line No.");
        //                             lrc_PackOrderOutputItems.SetIndirectCall(TRUE);
        //                             CASE vin_FieldNo OF
        //                                 FIELDNO(Quantity):
        //                                     lrc_PackOrderOutputItems.VALIDATE(Quantity, Quantity);
        //                             END;
        //                             lrc_PackOrderOutputItems.MODIFY(TRUE);

        //                             // Inputzeile
        //                             lrc_PackOrderInputItems.GET("Document No.", 0, "Document Line Line No.");
        //                             lrc_PackOrderInputItems.SetIndirectCall(TRUE);
        //                             CASE vin_FieldNo OF
        //                                 FIELDNO(Quantity):
        //                                     lrc_PackOrderInputItems.VALIDATE(Quantity, Quantity);
        //                             END;
        //                             lrc_PackOrderInputItems.MODIFY(TRUE);

        //                         END;
        //                     "Document Type"::"Transfer Order":
        //                         BEGIN

        //                             // Umlagerungszeile
        //                             lrc_TransferLine.GET("Document No.", "Document Line Line No.");
        //                             lrc_TransferLine.ADF_SetIndirectCall(TRUE);
        //                             lrc_TransferLine.ADF_CalledFromCreatingPlanLine(TRUE);
        //                             CASE vin_FieldNo OF
        //                                 FIELDNO(Quantity):
        //                                     lrc_TransferLine.VALIDATE(Quantity, Quantity);
        //                             END;
        //                             lrc_TransferLine.MODIFY(TRUE);

        //                         END;
        //                 END;
        //             END;
        //         2:
        //             BEGIN
        //                 IF ("Document No. 2" = '') OR ("Document Line Line No. 2" = 0) THEN BEGIN
        //                     EXIT;
        //                 END;
        //                 CASE "Document Type 2" OF
        //                     "Document Type 2"::Order:
        //                         BEGIN

        //                             // Verkaufszeile
        //                             lrc_SalesLine.GET(lrc_SalesLine."Document Type"::Order,
        //                                               "Document No. 2",
        //                                               "Document Line Line No. 2");
        //                             lrc_SalesLine.ADF_SetIndirectCall(TRUE);
        //                             CASE vin_FieldNo OF
        //                                 FIELDNO(Quantity):
        //                                     lrc_SalesLine.VALIDATE(Quantity, Quantity);
        //                             END;
        //                             lrc_SalesLine.MODIFY(TRUE);

        //                         END;
        //                     "Document Type 2"::"Packing Order":
        //                         BEGIN

        //                             // Outputzeile
        //                             lrc_PackOrderOutputItems.GET("Document No. 2", "Document Line Line No. 2");
        //                             lrc_PackOrderOutputItems.SetIndirectCall(TRUE);
        //                             CASE vin_FieldNo OF
        //                                 FIELDNO(Quantity):
        //                                     lrc_PackOrderOutputItems.VALIDATE(Quantity, Quantity);
        //                             END;
        //                             lrc_PackOrderOutputItems.MODIFY(TRUE);

        //                             // Inputzeile
        //                             lrc_PackOrderInputItems.GET("Document No. 2", 0, "Document Line Line No. 2");
        //                             lrc_PackOrderInputItems.SetIndirectCall(TRUE);
        //                             CASE vin_FieldNo OF
        //                                 FIELDNO(Quantity):
        //                                     lrc_PackOrderInputItems.VALIDATE(Quantity, Quantity);
        //                             END;
        //                             lrc_PackOrderInputItems.MODIFY(TRUE);

        //                         END;
        //                     "Document Type 2"::"Transfer Order":
        //                         BEGIN

        //                             // Umlagerungszeile
        //                             lrc_TransferLine.GET("Document No. 2", "Document Line Line No. 2");
        //                             lrc_TransferLine.ADF_SetIndirectCall(TRUE);
        //                             lrc_TransferLine.ADF_CalledFromCreatingPlanLine(TRUE);
        //                             CASE vin_FieldNo OF
        //                                 FIELDNO(Quantity):
        //                                     lrc_TransferLine.VALIDATE(Quantity, Quantity);
        //                             END;
        //                             lrc_TransferLine.MODIFY(TRUE);

        //                         END;
        //                 END;
        //             END;
        //         3:
        //             BEGIN
        //                 IF ("Document No. 2" = '') OR ("Document Line Line No. 2" = 0) THEN BEGIN
        //                     EXIT;
        //                 END;
        //                 CASE "Document Type 3" OF
        //                     "Document Type 3"::Order:
        //                         BEGIN

        //                             // Verkaufszeile
        //                             lrc_SalesLine.GET(lrc_SalesLine."Document Type"::Order,
        //                                               "Document No. 3",
        //                                               "Document Line Line No. 3");
        //                             lrc_SalesLine.ADF_SetIndirectCall(TRUE);
        //                             CASE vin_FieldNo OF
        //                                 FIELDNO(Quantity):
        //                                     lrc_SalesLine.VALIDATE(Quantity, Quantity);
        //                             END;
        //                             lrc_SalesLine.MODIFY(TRUE);

        //                         END;
        //                     "Document Type 3"::"Packing Order":
        //                         BEGIN

        //                             // Outputzeile
        //                             lrc_PackOrderOutputItems.GET("Document No. 3", "Document Line Line No. 3");
        //                             lrc_PackOrderOutputItems.SetIndirectCall(TRUE);
        //                             CASE vin_FieldNo OF
        //                                 FIELDNO(Quantity):
        //                                     lrc_PackOrderOutputItems.VALIDATE(Quantity, Quantity);
        //                             END;
        //                             lrc_PackOrderOutputItems.MODIFY(TRUE);

        //                             // Inputzeile
        //                             lrc_PackOrderInputItems.GET("Document No. 3", 0, "Document Line Line No. 3");
        //                             lrc_PackOrderInputItems.SetIndirectCall(TRUE);
        //                             CASE vin_FieldNo OF
        //                                 FIELDNO(Quantity):
        //                                     lrc_PackOrderInputItems.VALIDATE(Quantity, Quantity);
        //                             END;
        //                             lrc_PackOrderInputItems.MODIFY(TRUE);

        //                         END;
        //                     "Document Type 3"::"Transfer Order":
        //                         BEGIN

        //                             // Umlagerungszeile
        //                             lrc_TransferLine.GET("Document No. 3", "Document Line Line No. 3");
        //                             lrc_TransferLine.ADF_SetIndirectCall(TRUE);
        //                             lrc_TransferLine.ADF_CalledFromCreatingPlanLine(TRUE);
        //                             CASE vin_FieldNo OF
        //                                 FIELDNO(Quantity):
        //                                     lrc_TransferLine.VALIDATE(Quantity, Quantity);
        //                             END;
        //                             lrc_TransferLine.MODIFY(TRUE);

        //                         END;
        //                 END;
        //             END;
        //     END;
    end;

    procedure SetIndirectCall(vbn_IndirectCall: Boolean)
    begin
        // -------------------------------
        // Globale Set-Funktion, die nur innerhalb der aktiven Variablen gilt. (Setzt sich bei Abbruch von Funktionen
        // automatisch wieder zurück, daher besser als SingleInstance)
        // -------------------------------
        gbn_IndirectCall := vbn_IndirectCall;
    end;

    var
        lrc_Dispolines: Record "POI Dispolines";
        lrc_Batch: Record "POI Batch";
        // AgilesText001Txt: Label 'Customer No. %1 does not exist.';
        // AgilesText002Txt: Label 'Customer Group %1 does not exist.';
        AgilesText003Txt: Label 'There are other Lines for %1 %2. Would you like to update these Lines?', Comment = '%1 %2';
        // AgilesText004Txt: Label 'Lagerort %1 nicht vorhanden.';
        AgilesText005Txt: Label 'Source Type must be ''PreMaturation for Location'' or ''PreMaturation for Customer''';
        // AgilesText006Txt: Label 'The Locations for the Transfer Order cann''t be the same in the line %1';
        // AgilesText007Txt: Label 'Source Type must be:\''Customer'',\''Location'',\''Maturation at Location'',\''PreMaturation for Location'',\''PreMaturation for Customer''.';
        AgilesText008Txt: Label 'Source Type must be:\''PreMaturation for Location''\''PreMaturation for Customer''.';
        AgilesText009Txt: Label 'Source Type must be:\''Maturation at Location'',\''PreMaturation for Location'',\''PreMaturation for Customer''.';
        AgilesText010Txt: Label 'Receipt Date %1 couldn''t be before the Departure Date %2.', Comment = '%1 %2';
        gbn_IndirectCall: Boolean;
        AgilesText011Txt: Label 'Source Type must be:\''Customer'',\''PreMaturation for Customer''.';
    // AgilesText012Txt: Label 'No one Packing Order will be created for %1 ''%2''.\Item %3 has as %4 the Item %5.  ';
}

