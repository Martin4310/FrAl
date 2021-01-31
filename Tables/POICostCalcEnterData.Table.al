table 5110564 "POI Cost Calc. - Enter Data"
{
    Caption = 'Cost Calc. - Enter Data';
    // DrillDownFormID = Form5087950;
    // LookupFormID = Form5087950;

    fields
    {
        field(1; "Document No."; Integer)
        {
            Caption = 'Document No.';
        }
        field(2; "Cost Category Code"; Code[20])
        {
            Caption = 'Cost Category Code';
            TableRelation = "POI Cost Category";

            trigger OnValidate()
            var
                //lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
                lrc_CostCategory: Record "POI Cost Category";
            //AGILES_LT_TEXT001Txt: Label 'Cost Category is already inserted!';
            begin

                CASE "Entry Type" OF
                    "Entry Type"::"Enter Data":
                        BEGIN

                            IF "Cost Category Code" <> '' THEN BEGIN
                                lrc_CostCategory.GET("Cost Category Code");
                                IF lrc_CostCategory."Allocation Type" = lrc_CostCategory."Allocation Type"::" " THEN
                                    // Verteilungsart darf nicht leer sein!
                                    ERROR(ADF_GT_TEXT001Txt);
                                "Allocation Type" := lrc_CostCategory."Allocation Type";
                            END ELSE
                                "Allocation Type" := "Allocation Type"::" ";

                            "Last Change by" := copystr(USERID(), 1, 50);
                            "Last Change Date" := TODAY();
                            Allocated := FALSE;
                            CheckAllocBatch(TRUE);
                            IF (("Master Batch No." <> '') AND ("Batch No." = '')) THEN
                                CalcQtyByMasterBatch("Master Batch No.");

                        END;
                END;
            end;
        }
        field(4; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = IF ("Voyage No." = FILTER(<> '')) "POI Master Batch" WHERE("Voyage No." = FIELD("Voyage No."))
            ELSE
            IF ("Voyage No." = FILTER('')) "POI Master Batch";

            trigger OnValidate()
            var
                lrc_MasterBatch: Record "POI Master Batch";
            //lrc_Batch: Record "POI Batch Variant";
            //lrc_CostCalcAllocBatch: Record "POI Cost Calc. - Alloc. Batch";
            begin
                CASE "Entry Type" OF
                    "Entry Type"::"Enter Data":
                        BEGIN
                            IF "Entry Level" <> "Entry Level"::"Master Batch" THEN
                                // Satzebene muss Partie sein!
                                ERROR(ADF_GT_TEXT002Txt);

                            "Last Change by" := copystr(USERID(), 1, 50);
                            "Last Change Date" := TODAY();

                            IF "Master Batch No." <> '' THEN BEGIN
                                lrc_MasterBatch.GET("Master Batch No.");
                                "Voyage No." := lrc_MasterBatch."Voyage No.";
                                "Container No." := lrc_MasterBatch."Container Code";
                                "Batch No." := '';
                                "Batch Variant No." := '';
                            END ELSE BEGIN
                                "Voyage No." := '';
                                "Container No." := '';
                                "Batch No." := '';
                                "Batch Variant No." := '';
                            END;

                            Allocated := FALSE;
                            CheckAllocBatch(TRUE);
                            IF (("Master Batch No." <> '') AND ("Batch No." = '')) THEN
                                CalcQtyByMasterBatch("Master Batch No.");

                        END;
                END;
            end;
        }
        field(5; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = "POI Batch" WHERE("Master Batch No." = FIELD("Master Batch No."));

            trigger OnValidate()
            var
                lrc_Batch: Record "POI Batch";

            begin
                CASE "Entry Type" OF
                    "Entry Type"::"Enter Data":
                        BEGIN
                            IF ("Entry Level" <> "Entry Level"::"Master Batch") AND
                               ("Entry Level" <> "Entry Level"::Batch) THEN
                                ERROR('Satzebene muss Position sein!');

                            "Last Change by" := copystr(USERID(), 1, 50);
                            "Last Change Date" := TODAY();

                            IF "Batch No." <> '' THEN BEGIN
                                lrc_Batch.GET("Batch No.");
                                "Master Batch No." := lrc_Batch."Master Batch No.";
                                "Voyage No." := lrc_Batch."Voyage No.";
                                "Container No." := lrc_Batch."Container No.";
                                "Batch Variant No." := '';
                                lr_PurchLine.RESET();
                                lr_PurchLine.SETRANGE("Document Type", lr_PurchLine."Document Type"::Order);
                                lr_PurchLine.SETRANGE("Document No.", lrc_Batch."Source No.");
                                lr_PurchLine.SETRANGE("POI Batch Variant No.", "Batch No.");
                                IF lr_PurchLine.FIND('-') THEN
                                    "Location Code" := lr_PurchLine."Location Code";


                                CalcQtyColliPallets();

                            END ELSE
                                "Batch Variant No." := '';

                            Allocated := FALSE;
                            CheckAllocBatch(TRUE);
                            IF (("Master Batch No." <> '') AND ("Batch No." = '')) THEN
                                CalcQtyByMasterBatch("Master Batch No.");
                        END;
                END;
            end;
        }
        field(6; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = "POI Batch Variant" WHERE("Master Batch No." = FIELD("Master Batch No."),
                                                   "Batch No." = FIELD("Batch No."));
        }
        field(8; "Entry Level"; Option)
        {
            Caption = 'Entry Level';
            Description = ' ,Voyage,Container,Master Batch,Batch';
            OptionCaption = ' ,Voyage,Container,Master Batch,Batch';
            OptionMembers = " ",Voyage,Container,"Master Batch",Batch;

            trigger OnValidate()
            begin
                CASE "Entry Type" OF
                    "Entry Type"::"Enter Data":
                        CASE "Entry Level" OF
                            "Entry Level"::Voyage:
                                BEGIN
                                    "Container No." := '';
                                    "Master Batch No." := '';
                                    "Batch No." := '';
                                END;
                            "Entry Level"::Container:
                                BEGIN
                                    "Voyage No." := '';
                                    "Master Batch No." := '';
                                    "Batch No." := '';
                                END;
                            "Entry Level"::"Master Batch":
                                BEGIN
                                    "Voyage No." := '';
                                    "Container No." := '';
                                    "Batch No." := '';
                                END;
                            "Entry Level"::Batch:
                                BEGIN
                                    "Voyage No." := '';
                                    "Container No." := '';
                                    "Master Batch No." := '';
                                END;
                            ELSE BEGIN
                                    "Voyage No." := '';
                                    "Container No." := '';
                                    "Master Batch No." := '';
                                    "Batch No." := '';
                                END;
                        END;
                END;
            end;
        }
        field(9; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            Description = ' ,Cost Category,Enter Data,,,,,Detail Batch,Detail Batchvariant';
            OptionCaption = ' ,Cost Category,Enter Data,,,,,Detail Batch,Detail Batch Variant';
            OptionMembers = " ","Cost Category","Enter Data",,,,,"Detail Batch","Detail Batch Variant";

            trigger OnValidate()
            begin
                IF "Entry Type" <> "Entry Type"::"Enter Data" THEN
                    // Satzart %1 nicht zulässig!
                    ERROR(ADF_GT_TEXT003Txt, "Entry Type");
            end;
        }
        field(10; "Document No. 2"; Code[20])
        {
            Caption = 'Document No. 2';
        }
        field(12; "Reduce Cost from Turnover"; Boolean)
        {
            Caption = 'Reduce Cost from Turnover';
        }
        field(14; "Indirect Cost (Purchase)"; Boolean)
        {
            Caption = 'Indirect Cost (Purchase)';
        }
        field(18; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;
        }
        field(20; "Cost Schema Name"; Code[10])
        {
            Caption = 'Cost Schema Name';
            TableRelation = "POI Cost Schema Name";
        }
        field(44; "Means of Transport Code"; Code[20])
        {
            Caption = 'Means of Transport Code';
        }
        field(45; "Voyage No."; Code[20])
        {
            Caption = 'Voyage No.';
            TableRelation = "POI Voyage";

            trigger OnValidate()
            var
                lrc_Voyage: Record "POI Voyage";
            // lrc_MasterBatch: Record "POI Master Batch";
            // lrc_Batch: Record "POI Batch";
            // lrc_CostCalcAllocBatch: Record "POI Cost Calc. - Alloc. Batch";
            begin
                CASE "Entry Type" OF
                    "Entry Type"::"Enter Data":
                        BEGIN
                            IF "Entry Level" <> "Entry Level"::Voyage THEN
                                ERROR('Satzebene muss Reise sein!');

                            "Last Change by" := copystr(USERID(), 1, 50);
                            "Last Change Date" := TODAY();

                            IF "Voyage No." <> '' THEN BEGIN
                                lrc_Voyage.GET("Voyage No.");
                                "Means of Transport Code" := lrc_Voyage."Means of Transp. Code Arrival";
                                "Container No." := '';
                                "Master Batch No." := '';
                                "Batch No." := '';
                                "Batch Variant No." := '';
                            END ELSE BEGIN
                                "Container No." := '';
                                "Master Batch No." := '';
                                "Batch No." := '';
                                "Batch Variant No." := '';
                            END;

                            Allocated := FALSE;
                            CheckAllocBatch(TRUE);
                            IF (("Master Batch No." <> '') AND ("Batch No." = '')) THEN
                                CalcQtyByMasterBatch("Master Batch No.");

                        END;
                END;
            end;
        }
        field(46; "Container No."; Code[20])
        {
            Caption = 'Container No.';
            TableRelation = "POI Container";

            trigger OnValidate()
            begin
                CASE "Entry Type" OF
                    "Entry Type"::"Enter Data":
                        BEGIN
                            IF "Entry Level" <> "Entry Level"::Container THEN
                                ERROR('Satzebene muss Container sein!');

                            "Voyage No." := '';
                            "Master Batch No." := '';
                            "Batch No." := '';
                            "Batch Variant No." := '';

                        END;
                END;
            end;
        }
        field(50; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_Vendor: Record Vendor;
                lcu_BDMBaseDataMgt: Codeunit "POI BDM Base Data Mgmt";
            begin
                CASE "Entry Type" OF
                    "Entry Type"::"Enter Data":
                        BEGIN
                            IF CurrFieldNo <> 0 THEN
                                IF NOT lrc_Vendor.GET("Vendor No.") THEN
                                    lcu_BDMBaseDataMgt.GlobalValidateSearch(5110564, FIELDNO("Vendor No."), "Vendor No.", (CurrFieldNo = FIELDNO("Vendor No.")));
                            "Last Change by" := copystr(USERID(), 1, 50);
                            "Last Change Date" := TODAY();
                            "Vendor Name" := '';
                            IF lrc_Vendor."No." <> "Vendor No." THEN
                                IF lrc_Vendor.GET("Vendor No.") THEN
                                    "Vendor Name" := lrc_Vendor.Name;
                        END;
                END;
            end;
        }
        field(52; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(53; "Vendor External Doc. No."; Code[20])
        {
            Caption = 'Vendor External Doc. No.';
        }
        field(54; "Expected Posting Date"; Date)
        {
            Caption = 'Expected Posting Date';

            trigger OnValidate()
            begin
                IF "Expected Posting Date" <> xRec."Expected Posting Date" THEN BEGIN
                    UpdateCurrencyFactor();
                    VALIDATE(Amount);
                END;
            end;
        }
        field(55; "Qty. Colli"; Decimal)
        {
            Caption = 'Qty. Colli';
        }
        field(56; "Qty. Pallet"; Decimal)
        {
            Caption = 'Qty. Pallet';
        }
        field(57; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                    UpdateCurrencyFactor();
                    VALIDATE(Amount);
                END;
            end;
        }
        field(58; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';

            trigger OnValidate()
            begin
                IF "Currency Factor" <> xRec."Currency Factor" THEN
                    VALIDATE(Amount);
            end;
        }
        field(60; Amount; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            var
                lrc_Currency: Record Currency;
                lrc_CurrExchRate: Record "Currency Exchange Rate";
            //lrc_CostCalcAllocBatch: Record "POI Cost Calc. - Alloc. Batch";
            //lrc_Batch: Record "POI Batch";
            begin
                IF "Currency Code" = '' THEN
                    "Currency Factor" := 1;
                TESTFIELD("Currency Factor");

                lrc_Currency.InitRoundingPrecision();
                IF "Currency Code" <> '' THEN BEGIN
                    IF "Expected Posting Date" = 0D THEN
                        "Expected Posting Date" := WORKDATE();
                    "Amount (LCY)" := ROUND(lrc_CurrExchRate.ExchangeAmtFCYToLCY("Expected Posting Date", "Currency Code", Amount, "Currency Factor"),
                        lrc_Currency."Amount Rounding Precision")
                END ELSE
                    "Amount (LCY)" := ROUND(Amount, lrc_Currency."Amount Rounding Precision");


                CalcQtyColliPallets();
                VALIDATE("Amount (LCY)");

                "Last Change by" := copystr(USERID(), 1, 50);
                "Last Change Date" := TODAY();

                // IF CurrFieldNo <> FIELDNO(Amount) THEN BEGIN
                // END;
            end;
        }
        field(61; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                "Cost per Collo" := 0;
                IF "Qty. Colli" <> 0 THEN
                    "Cost per Collo" := "Amount (LCY)" / "Qty. Colli";

                "Cost per Pallet" := 0;
                IF "Qty. Pallet" <> 0 THEN
                    "Cost per Pallet" := "Amount (LCY)" / "Qty. Pallet";
            end;
        }
        field(63; "Allocation Error"; Boolean)
        {
            Caption = 'Allocation Error';
        }
        field(64; "Allocation Level"; Option)
        {
            Caption = 'Allocation Level';
            Description = ' ,Voyage No.,Master Batch No.,Batch No.,Container No.';
            OptionCaption = ' ,Voyage No.,Master Batch No.,Batch No.,Container No.';
            OptionMembers = " ","Voyage No.","Master Batch No.","Batch No.","Container No.";

            trigger OnValidate()
            begin
                IF "Allocation Level" <> "Allocation Level"::"Batch No." THEN
                    ERROR('Als Verteilungsebene ist zur Zeit nur Position definiert');
            end;
        }
        field(65; "Allocation Type"; Option)
        {
            Caption = 'Allocation Type';
            Description = ' ,Pallets,Kolli,Net Weight,Gross Weight,Lines,Amount';
            OptionCaption = ' ,Pallets,Kolli,Net Weight,Gross Weight,Lines,Amount';
            OptionMembers = " ",Pallets,Kolli,"Net Weight","Gross Weight",Lines,Amount;

            trigger OnValidate()
            begin
                CheckAllocBatch(TRUE);
                IF (("Master Batch No." <> '') AND ("Batch No." = '')) THEN
                    CalcQtyByMasterBatch("Master Batch No.");
            end;
        }
        field(67; Allocated; Boolean)
        {
            Caption = 'Allocated';
        }
        field(68; "Einmal Umlage"; Boolean)
        {
            Caption = 'Einmal Umlage';
        }
        field(70; Released; Boolean)
        {
            Caption = 'Released';

            trigger OnValidate()
            var
                lcu_CostCalcMgt: Codeunit "POI CCM Cost Calc. Mgt";
            begin
                IF "Entry Type" = "Entry Type"::"Enter Data" THEN BEGIN
                    IF Released = TRUE THEN BEGIN
                        lcu_CostCalcMgt.AllocateCostPerEnterDataRec(Rec);

                        "Released by" := copystr(USERID(), 1, 50);
                        "Released Date" := TODAY();

                    END ELSE BEGIN
                        "Released by" := '';
                        "Released Date" := 0D;
                    END;
                END ELSE BEGIN
                    "Released by" := '';
                    "Released Date" := 0D;
                END;
            end;
        }
        field(71; "Released by"; Code[50])
        {
            Caption = 'Released by';
        }
        field(72; "Released Date"; Date)
        {
            Caption = 'Released Date';
        }
        field(75; "Last Change by"; Code[50])
        {
            Caption = 'Last Change by';
        }
        field(76; "Last Change Date"; Date)
        {
            Caption = 'Last Change Date';
        }
        field(80; Price; Decimal)
        {
            Caption = 'Price';

            trigger OnValidate()
            begin
                CalcQtyColliPallets();

                CASE "Reference Price" OF
                    "Reference Price"::Amount:
                        VALIDATE(Amount, Price);
                    "Reference Price"::Colli:
                        VALIDATE(Amount, (Price * "Qty. Colli"));
                    "Reference Price"::Pallet:
                        VALIDATE(Amount, (Price * "Qty. Pallet"));
                    "Reference Price"::"Net Weight":
                        ERROR('');
                    "Reference Price"::"Gross Weight":
                        ERROR('');
                    ELSE
                        ERROR('');
                END;
            end;
        }
        field(81; "Reference Price"; Option)
        {
            Caption = 'Reference Price';
            Description = 'Amount,Pallet,Colli,Net Weight,Gross Weight';
            OptionCaption = 'Amount,Pallet,Colli,Net Weight,Gross Weight';
            OptionMembers = Amount,Pallet,Colli,"Net Weight","Gross Weight";

            trigger OnValidate()
            begin
                VALIDATE(Price);
            end;
        }
        field(83; "Via Location Code"; Code[10])
        {
            Caption = 'Via Location Code';
        }
        field(84; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
        field(85; "Departure Region"; Code[10])
        {
            Caption = 'Abgangsregion Code';
        }
        field(87; "Arrival Region Code"; Code[10])
        {
            Caption = 'Zugangsregion Code';
        }
        field(88; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Zusteller Code';
        }
        field(90; Comment; Text[50])
        {
            Caption = 'Comment';
        }
        field(95; "Generated by System"; Boolean)
        {
            Caption = 'Generated by System';
        }
        field(96; "Generated by"; Option)
        {
            Caption = 'Generiert durch';
            Description = ' ,Standard Cost Calculation';
            OptionCaption = ' ,Standard Cost Calculation';
            OptionMembers = " ","Standard Cost Calculation";
        }
        field(100; "Entered Amount (LCY) (FF)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Cost Calc. - Enter Data"."Amount (LCY)" WHERE("Cost Category Code" = FIELD("Cost Category Code"),
                                                                              "Voyage No." = FILTER(''),
                                                                              "Master Batch No." = FIELD("Master Batch No."),
                                                                              "Entry Type" = CONST("Enter Data")));
            Caption = 'Entered Amount (LCY) (FF)';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Calc. Posted Amount (LCY)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Kalk. Geb. Betrag (MW)';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(102; "Released Amount (LCY) (FF)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Cost Calc. - Enter Data"."Amount (LCY)" WHERE("Cost Category Code" = FIELD("Cost Category Code"),
                                                                              "Master Batch No." = FIELD("Master Batch No."),
                                                                              "Entry Type" = CONST("Enter Data"),
                                                                              Released = CONST(true)));
            Caption = 'Released Amount (LCY) (FF)';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(103; "Entered Amount (LCY)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Entered Amount (LCY)';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(104; "Released Amount (LCY)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Released Amount (LCY)';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(105; "Cost per Collo"; Decimal)
        {
            Caption = 'Cost per Collo';
            DecimalPlaces = 4 : 4;
        }
        field(106; "Cost per Pallet"; Decimal)
        {
            Caption = 'Cost per Pallet';
        }
        field(110; "Cost Category Description"; Text[50])
        {
            CalcFormula = Lookup ("POI Cost Category".Description WHERE(Code = FIELD("Cost Category Code")));
            Caption = 'Kostenkategorie Beschreibung';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(123; "Invoice Currency Code"; Code[10])
        {
            Caption = 'Invoice Currency Code';
            TableRelation = Currency;
        }
        field(124; "Invoice Currency Factor"; Decimal)
        {
            Caption = 'Invoice Currency Factor';
        }
        field(125; "Invoice Amount"; Decimal)
        {
            Caption = 'Invoice Amount';
        }
        field(130; "Posted Amount (LCY)"; Decimal)
        {
            Caption = 'Posted Amount (LCY)';
            Editable = false;
        }
        field(150; "Attached to Entry No."; Integer)
        {
            Caption = 'Attached to Entry No.';
        }
        field(151; "Attached to Doc. No."; Code[20])
        {
            Caption = 'Attached to Doc. No.';
        }
        field(152; "Attached Entry Subtype"; Option)
        {
            Caption = 'Attached Entry Subtype';
            Description = ' ,Voyage,Container,Master Batch,Batch';
            OptionCaption = ' ,Voyage,Container,Master Batch,Batch';
            OptionMembers = " ",Voyage,Container,"Master Batch",Batch;
        }
        field(190; "No. of Loadings in Doc."; Integer)
        {
            Caption = 'No. of Loadings in Doc.';
        }
        field(200; "No. of Lines Entered"; Integer)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Count ("POI Cost Calc. - Enter Data" WHERE("Cost Category Code" = FIELD("Cost Category Code"),
                                                                 "Master Batch No." = FIELD("Master Batch No."),
                                                                 "Entry Type" = CONST("Enter Data")));
            Caption = 'No. of Lines Entered';
            Editable = false;
            FieldClass = FlowField;
        }
        field(202; "No. of Lines Released"; Integer)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Count ("POI Cost Calc. - Enter Data" WHERE("Cost Category Code" = FIELD("Cost Category Code"),
                                                                 "Master Batch No." = FIELD("Master Batch No."),
                                                                 "Entry Type" = CONST("Enter Data"),
                                                                 Released = CONST(true)));
            Caption = 'No. of Lines Released';
            Editable = false;
            FieldClass = FlowField;
        }
        field(210; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,,,,,Closed';
            OptionMembers = Open,,,,,Closed;
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
        }
        key(Key2; "Entry Type", "Voyage No.", "Master Batch No.", "Cost Category Code")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key3; "Entry Type", "Master Batch No.", "Batch No.", "Cost Category Code")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key4; "Entry Type", "Master Batch No.", "Cost Category Code", Released)
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key5; "Entry Type", "Master Batch No.", "Batch No.", "Cost Category Code", Released)
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key6; "Attached to Entry No.")
        {
        }
        key(Key7; "Entry Type", "Master Batch No.", "Batch No.", "Batch Variant No.", "Vendor No.")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key8; "Entry Type", "Batch No.", "Reduce Cost from Turnover")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key9; "Master Batch No.", "Batch No.", "Batch Variant No.")
        {
        }
        key(Key10; "Entry Type", "Vendor No.", Released, "No. of Loadings in Doc.")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key11; "Entry Type", "Entry Level", "Cost Category Code", "Voyage No.", "Container No.", "Master Batch No.", "Batch No.")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key12; "Entry Type", "Attached to Entry No.")
        {
        }
        key(Key13; "Entry Type", "Batch No.", "Cost Category Code")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key14; "Batch Variant No.", "Indirect Cost (Purchase)", "Entry Type")
        {
            SumIndexFields = "Cost per Collo";
        }
        key(Key15; "Batch No.", "Indirect Cost (Purchase)", "Entry Type")
        {
            SumIndexFields = "Cost per Collo";
        }
        key(Key16; "Cost Category Code", "Master Batch No.")
        {
            SumIndexFields = "Amount (LCY)", "Released Amount (LCY)", "Posted Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lrc_CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
        lrc_CostCalcAllocData: Record "POI Cost Calc. - Alloc. Data";
        ADF_LT_TEXT001Txt: Label 'Delete not allowed. General Ledger entries exist!';
    begin
        // -------------------------------------------------------------------------------------------------------
        // Zugehörige Sätze löschen in Abhängigkeit der Ausgangssatzart
        // -------------------------------------------------------------------------------------------------------

        CASE "Entry Type" OF
            "Entry Type"::"Cost Category":
                ;
            "Entry Type"::"Enter Data":
                BEGIN

                    IF Status = Status::Closed THEN
                        ERROR(ADF_LT_TEXT001Txt);

                    lrc_CostCalcAllocBatch.RESET();
                    lrc_CostCalcAllocBatch.SETRANGE("Document No.", "Document No.");
                    lrc_CostCalcAllocBatch.SETRANGE("Document No. 2", "Document No. 2");
                    lrc_CostCalcAllocBatch.DELETEALL();

                    lrc_CostCalcEnterData.RESET();
                    lrc_CostCalcEnterData.SETCURRENTKEY("Entry Type", "Attached to Entry No.");
                    lrc_CostCalcEnterData.SETRANGE("Cost Category Code", "Cost Category Code");
                    lrc_CostCalcEnterData.SETRANGE("Entry Type", "Entry Type"::"Detail Batch Variant");
                    lrc_CostCalcEnterData.SETRANGE("Attached to Entry No.", "Document No.");
                    lrc_CostCalcEnterData.SETRANGE("Document No. 2", "Document No. 2");
                    lrc_CostCalcEnterData.DELETEALL();

                    lrc_CostCalcEnterData.RESET();
                    lrc_CostCalcEnterData.SETCURRENTKEY("Entry Type", "Attached to Entry No.");
                    lrc_CostCalcEnterData.SETRANGE("Cost Category Code", "Cost Category Code");
                    lrc_CostCalcEnterData.SETRANGE("Entry Type", "Entry Type"::"Detail Batch");
                    lrc_CostCalcEnterData.SETRANGE("Attached to Entry No.", "Document No.");
                    lrc_CostCalcEnterData.SETRANGE("Document No. 2", "Document No. 2");
                    lrc_CostCalcEnterData.DELETEALL();

                    lrc_CostCalcAllocData.RESET();
                    lrc_CostCalcAllocData.SETCURRENTKEY("Document No. 2");
                    lrc_CostCalcAllocData.SETRANGE("Document No. 2", "Document No. 2");
                    IF NOT lrc_CostCalcAllocData.ISEMPTY() THEN
                        lrc_CostCalcAllocData.DELETEALL();
                END;
        END;
    end;

    trigger OnInsert()
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
        //lrc_CostCategory: Record "POI Cost Category";
        lcu_NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        IF lrc_CostCalculation.FINDLAST() THEN
            "Document No." := lrc_CostCalculation."Document No." + 1
        ELSE
            "Document No." := 1;

        lrc_FruitVisionSetup.GET();
        lrc_FruitVisionSetup.TESTFIELD("Plan Cost No. Series");
        "Document No. 2" := lcu_NoSeriesMgt.GetNextNo(lrc_FruitVisionSetup."Plan Cost No. Series", TODAY(), TRUE);
        TESTFIELD("Document No. 2");

        "Last Change by" := copystr(USERID(), 1, 50);
        "Last Change Date" := TODAY();
        CheckAllocBatch(TRUE);
        IF ((Rec."Master Batch No." <> '') AND (Rec."Batch No." = '')) THEN
            CalcQtyByMasterBatch("Master Batch No.");
        IF "Cost Category Code" <> '' THEN
            VALIDATE("Cost Category Code");
    end;

    trigger OnModify()
    var
        lrc_CostCategory: Record "POI Cost Category";
    begin
        CASE "Entry Type" OF
            "Entry Type"::"Enter Data":
                BEGIN
                    IF "Cost Category Code" <> '' THEN BEGIN
                        lrc_CostCategory.GET("Cost Category Code");
                        //"Allocation Type" := lrc_CostCategory."Allocation Type";
                        "Reduce Cost from Turnover" := lrc_CostCategory."Reduce Cost from Turnover";
                        "Indirect Cost (Purchase)" := lrc_CostCategory."Indirect Cost (Purchase)";
                    END;

                    "Last Change by" := copystr(USERID(), 1, 50);
                    "Last Change Date" := TODAY();

                    Allocated := FALSE;
                    CheckAllocBatch(FALSE);
                    IF (("Master Batch No." <> '') AND ("Batch No." = '')) THEN
                        CalcQtyByMasterBatch("Master Batch No.");
                END;

        END;
    end;

    var
        ADF_GT_TEXT001Txt: Label 'Allocation Type has to be filled!';
        ADF_GT_TEXT002Txt: Label 'Entry Level must be Master Batch!';
        ADF_GT_TEXT003Txt: Label 'Entry Type %1 not allowed!', Comment = '%1';

    local procedure UpdateCurrencyFactor()
    var
        lrc_CurrExchRate: Record "Currency Exchange Rate";
    begin
        IF "Currency Code" <> '' THEN BEGIN
            IF "Expected Posting Date" = 0D THEN
                "Expected Posting Date" := WORKDATE();
            "Currency Factor" := lrc_CurrExchRate.ExchangeRate("Expected Posting Date", "Currency Code");
        END ELSE
            "Currency Factor" := 1;
    end;

    procedure CheckAllocBatch(vbn_Delete: Boolean)

    begin
        // --------------------------------------------------------------------------------
        // Prüfung Zuordnung Positionen
        // --------------------------------------------------------------------------------

        IF ("Entry Type" <> "Entry Type"::"Enter Data") OR
           ("Document No." = 0) THEN
            EXIT;

        // Zugeordnete Positionsnummern für die Verteilung löschen
        IF vbn_Delete = TRUE THEN BEGIN
            lrc_CostCalcAllocBatch.RESET();
            lrc_CostCalcAllocBatch.SETRANGE("Document No.", "Document No.");
            lrc_CostCalcAllocBatch.SETRANGE("Document No. 2", "Document No. 2");
            IF NOT lrc_CostCalcAllocBatch.ISEMPTY() THEN
                lrc_CostCalcAllocBatch.DELETEALL();
        END;

        // Zuordnung Positionsnummern für Verteilung aufbauen
        lrc_CostCalcAllocBatch.RESET();
        lrc_CostCalcAllocBatch.SETRANGE("Document No.", "Document No.");
        lrc_CostCalcAllocBatch.SETRANGE("Document No. 2", "Document No. 2");
        IF NOT lrc_CostCalcAllocBatch.FINDFIRST() THEN BEGIN //Neuanlage Datensätze in lrc_CostCalcAllocBatch
            lrc_Batch.RESET();
            IF "Batch No." <> '' THEN
                lrc_Batch.SETRANGE("No.", "Batch No.");
        END ELSE BEGIN
            IF "Master Batch No." <> '' THEN
                lrc_Batch.SETRANGE("Master Batch No.", "Master Batch No.")
            ELSE
                IF "Voyage No." <> '' THEN
                    lrc_Batch.SETRANGE("Voyage No.", "Voyage No.")
                ELSE
                    EXIT;


            IF lrc_Batch.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    lrc_CostCalcAllocBatch.RESET();
                    lrc_CostCalcAllocBatch.INIT();
                    lrc_CostCalcAllocBatch."Document No." := "Document No.";
                    lrc_CostCalcAllocBatch."Batch No." := lrc_Batch."No.";
                    lrc_CostCalcAllocBatch."Document No. 2" := "Document No. 2";
                    lrc_CostCalcAllocBatch."Master Batch No." := lrc_Batch."Master Batch No.";
                    lrc_CostCalcAllocBatch."Without Allocation" := FALSE;
                    lrc_CostCalcAllocBatch."Cost Category Code" := "Cost Category Code";
                    CASE "Allocation Type" OF
                        "Allocation Type"::Pallets:
                            lrc_CostCalcAllocBatch."Allocation Key" := lrc_CostCalcAllocBatch."Allocation Key"::Pallets;
                        "Allocation Type"::Kolli:
                            lrc_CostCalcAllocBatch."Allocation Key" := lrc_CostCalcAllocBatch."Allocation Key"::Colli;
                        "Allocation Type"::"Net Weight":
                            lrc_CostCalcAllocBatch."Allocation Key" := lrc_CostCalcAllocBatch."Allocation Key"::"Net Weight";
                        "Allocation Type"::"Gross Weight":
                            lrc_CostCalcAllocBatch."Allocation Key" := lrc_CostCalcAllocBatch."Allocation Key"::"Gross Weight";
                        "Allocation Type"::Lines:
                            lrc_CostCalcAllocBatch."Allocation Key" := lrc_CostCalcAllocBatch."Allocation Key"::Lines;
                        "Allocation Type"::Amount:
                            lrc_CostCalcAllocBatch."Allocation Key" := lrc_CostCalcAllocBatch."Allocation Key"::Amount;
                    END;
                    lrc_CostCalcAllocBatch.INSERT();
                UNTIL lrc_Batch.NEXT() = 0
            ELSE BEGIN //RS wenn Datensätze vorhanden, dann Prüfung ob für alle Batch Zeilen vorhanden
                lrc_Batch.RESET();
                IF "Batch No." <> '' THEN
                    lrc_Batch.SETRANGE("No.", "Batch No.")
                ELSE
                    IF "Master Batch No." <> '' THEN
                        lrc_Batch.SETRANGE("Master Batch No.", "Master Batch No.")
                    ELSE
                        EXIT;
                IF lrc_Batch.FINDSET(FALSE, FALSE) THEN
                    REPEAT
                        IF NOT lrc_CostCalcAllocBatch.GET("Document No.", lrc_Batch."No.") THEN BEGIN
                            lrc_CostCalcAllocBatch.RESET();
                            lrc_CostCalcAllocBatch.INIT();
                            lrc_CostCalcAllocBatch."Document No." := "Document No.";
                            lrc_CostCalcAllocBatch."Batch No." := lrc_Batch."No.";
                            lrc_CostCalcAllocBatch."Document No. 2" := "Document No. 2";
                            lrc_CostCalcAllocBatch."Master Batch No." := lrc_Batch."Master Batch No.";
                            lrc_CostCalcAllocBatch."Without Allocation" := FALSE;
                            lrc_CostCalcAllocBatch."Cost Category Code" := "Cost Category Code";
                            CASE "Allocation Type" OF
                                "Allocation Type"::Pallets:
                                    lrc_CostCalcAllocBatch."Allocation Key" := lrc_CostCalcAllocBatch."Allocation Key"::Pallets;
                                "Allocation Type"::Kolli:
                                    lrc_CostCalcAllocBatch."Allocation Key" := lrc_CostCalcAllocBatch."Allocation Key"::Colli;
                                "Allocation Type"::"Net Weight":
                                    lrc_CostCalcAllocBatch."Allocation Key" := lrc_CostCalcAllocBatch."Allocation Key"::"Net Weight";
                                "Allocation Type"::"Gross Weight":
                                    lrc_CostCalcAllocBatch."Allocation Key" := lrc_CostCalcAllocBatch."Allocation Key"::"Gross Weight";
                                "Allocation Type"::Lines:
                                    lrc_CostCalcAllocBatch."Allocation Key" := lrc_CostCalcAllocBatch."Allocation Key"::Lines;
                                "Allocation Type"::Amount:
                                    lrc_CostCalcAllocBatch."Allocation Key" := lrc_CostCalcAllocBatch."Allocation Key"::Amount;
                            END;
                            lrc_CostCalcAllocBatch.INSERT();
                        END;
                    UNTIL lrc_Batch.NEXT() = 0;
            end;
        END;

    end;

    procedure CalcQtyColliPallets()
    var
        OK: Boolean;
    begin
        "Qty. Colli" := 0;
        "Qty. Pallet" := 0;

        // PORT 009.s
        /*IF "Batch No." = '' THEN
          EXIT;
        
        lrc_Batch.GET("Batch No.");
        lrc_Batch.CALCFIELDS("Purch. Order (Qty) (Base)","Purch. Rec. (Qty) (Base)");
        IF lrc_Batch."Qty. per Unit of Measure" <> 0 THEN
          "Qty. Colli" := ROUND((lrc_Batch."Purch. Order (Qty) (Base)" + lrc_Batch."Purch. Rec. (Qty) (Base)") /
                           lrc_Batch."Qty. per Unit of Measure",0.00001);
        
        IF lrc_Batch."Qty. (CU) per Pallet (TU)" <> 0 THEN
          "Qty. Pallet" := ROUND("Qty. Colli" / lrc_Batch."Qty. (CU) per Pallet (TU)",0.00001);*/

        CASE "Entry Level" OF
            "Entry Level"::"Master Batch":
                BEGIN
                    IF "Master Batch No." = '' THEN
                        EXIT;
                    OK := lrc_Batch.SETCURRENTKEY("Master Batch No.");
                    lrc_Batch.SETRANGE("Master Batch No.", "Master Batch No.");
                END;
            ELSE BEGIN
                    IF "Batch No." = '' THEN
                        EXIT;
                    lrc_Batch.SETRANGE("No.", "Batch No.");
                END;
        END;

        //RS Qty Colli nur Zeile, wenn Batch No. vorhanden
        IF lrc_Batch.FINDSET() THEN
            IF "Batch No." <> '' THEN BEGIN
                lrc_Batch.GET("Batch No.");
                lrc_Batch.CALCFIELDS("Purch. Order (Qty) (Base)", "Purch. Rec. (Qty) (Base)");
                IF lrc_Batch."Qty. per Unit of Measure" <> 0 THEN
                    "Qty. Colli" := ROUND((lrc_Batch."Purch. Order (Qty) (Base)" + lrc_Batch."Purch. Rec. (Qty) (Base)") /
                                           lrc_Batch."Qty. per Unit of Measure", 0.00001);
                IF ((lrc_Batch."Qty. (Unit) per Transp. (TU)" <> 0) AND ("Qty. Colli" <> 0)) THEN
                    "Qty. Pallet" := ROUND("Qty. Colli" / lrc_Batch."Qty. (Unit) per Transp. (TU)", 0.00001);
            END;

    end;

    procedure CalcQtyByMasterBatch(vco_MasterBatch: Code[20])
    begin
        //RS Funktion zur Ermittlung der Kollimenge und Palettenanzahl
        "Qty. Colli" := 0;
        "Qty. Pallet" := 0;
        lrc_CostCalcAllocBatch.Reset();
        lrc_CostCalcAllocBatch.SETRANGE("Master Batch No.", "Master Batch No.");
        lrc_CostCalcAllocBatch.SETRANGE("Without Allocation", FALSE);
        lrc_CostCalcAllocBatch.SETRANGE("Document No.", "Document No.");
        IF lrc_CostCalcAllocBatch.FIND('-') THEN
            REPEAT
                lrc_Batch.GET(lrc_CostCalcAllocBatch."Batch No.");
                lrc_Batch.CALCFIELDS("Purch. Order (Qty) (Base)", "Purch. Rec. (Qty) (Base)");
                IF lrc_Batch."Qty. per Unit of Measure" <> 0 THEN
                    "Qty. Colli" := "Qty. Colli" + ROUND((lrc_Batch."Purch. Order (Qty) (Base)" + lrc_Batch."Purch. Rec. (Qty) (Base)") /
                                    lrc_Batch."Qty. per Unit of Measure", 0.00001);
                IF lrc_Batch."Qty. (Unit) per Transp. (TU)" <> 0 THEN
                    "Qty. Pallet" := "Qty. Pallet" + ROUND("Qty. Colli" / lrc_Batch."Qty. (Unit) per Transp. (TU)", 0.00001);
            UNTIL lrc_CostCalcAllocBatch.NEXT() = 0
        ELSE BEGIN
            lrc_Batch.SETRANGE("Master Batch No.", "Master Batch No.");
            IF lrc_Batch.FIND('-') THEN
                REPEAT
                    IF lrc_Batch."Qty. per Unit of Measure" <> 0 THEN
                        "Qty. Colli" := "Qty. Colli" + ROUND((lrc_Batch."Purch. Order (Qty) (Base)" + lrc_Batch."Purch. Rec. (Qty) (Base)") /
                                        lrc_Batch."Qty. per Unit of Measure", 0.00001);
                    IF lrc_Batch."Qty. (Unit) per Transp. (TU)" <> 0 THEN
                        "Qty. Pallet" := "Qty. Pallet" + ROUND("Qty. Colli" / lrc_Batch."Qty. (Unit) per Transp. (TU)", 0.00001);

                UNTIL lrc_Batch.NEXT() = 0;
        END;
        "Cost per Collo" := 0;
        IF "Qty. Colli" <> 0 THEN
            "Cost per Collo" := "Amount (LCY)" / "Qty. Colli";

        "Cost per Pallet" := 0;
        IF "Qty. Pallet" <> 0 THEN
            "Cost per Pallet" := "Amount (LCY)" / "Qty. Pallet";
    end;

    var

        lr_PurchLine: Record "Purchase Line";
        lrc_CostCalcAllocBatch: Record "POI Cost Calc. - Alloc. Batch";
        lrc_Batch: Record "POI Batch";
}

