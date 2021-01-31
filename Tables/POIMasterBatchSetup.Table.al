table 50027 "POI Master Batch Setup"
{
    Caption = 'Master Batch Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(10; "Dim. Code Batch No."; Code[20])
        {
            Caption = 'Dim. Code Batch No.';
            DataClassification = CustomerContent;
            TableRelation = Dimension;

            trigger OnValidate()
            var
                lrc_GeneralLedgerSetup: Record "General Ledger Setup";
            begin
                lrc_GeneralLedgerSetup.GET();
                CASE "Dim. Code Batch No." OF
                    '':
                        "Dim. No. Batch No." := 0;
                    lrc_GeneralLedgerSetup."Global Dimension 1 Code":
                        "Dim. No. Batch No." := 1;
                    lrc_GeneralLedgerSetup."Global Dimension 2 Code":
                        "Dim. No. Batch No." := 2;
                    lrc_GeneralLedgerSetup."POI Global Dimension 3 Code":
                        "Dim. No. Batch No." := 3;
                    lrc_GeneralLedgerSetup."POI Global Dimension 4 Code":
                        "Dim. No. Batch No." := 4;
                    ELSE
                        "Dim. No. Batch No." := 0;
                END;
            end;
        }
        field(11; "Dim. No. Batch No."; Option)
        {
            Caption = 'Dim. No. Batch No.';
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = ' ,1. Dimension,2. Dimension,3. Dimension,4. Dimension,5. Dimension,6. Dimension,7. Dimension,8. Dimension';
            OptionMembers = " ","1. Dimension","2. Dimension","3. Dimension","4. Dimension","5. Dimension","6. Dimension","7. Dimension","8. Dimension";
        }
        field(12; "Dim. Code Cost Category"; Code[20])
        {
            Caption = 'Dim. Code Cost Category';
            DataClassification = CustomerContent;
            TableRelation = Dimension;

            trigger OnValidate()
            var
                lrc_GeneralLedgerSetup: Record "General Ledger Setup";
                lrc_FruitVisionSetup: Record "POI ADF Setup";
            begin
                lrc_GeneralLedgerSetup.GET();
                CASE "Dim. Code Cost Category" OF
                    '':
                        "Dim. No. Cost Category" := 0;
                    lrc_GeneralLedgerSetup."Global Dimension 1 Code":
                        "Dim. No. Cost Category" := 1;
                    lrc_GeneralLedgerSetup."Global Dimension 2 Code":
                        "Dim. No. Cost Category" := 2;
                    lrc_GeneralLedgerSetup."POI Global Dimension 3 Code":
                        "Dim. No. Cost Category" := 3;
                    lrc_GeneralLedgerSetup."POI Global Dimension 4 Code":
                        "Dim. No. Cost Category" := 4;
                    ELSE
                        "Dim. No. Cost Category" := 0;
                END;

                // Wert in Fruitvision Setup muss identisch laufen
                lrc_FruitVisionSetup.GET();
                lrc_FruitVisionSetup."Dim. Code Cost Category" := "Dim. Code Cost Category";
                lrc_FruitVisionSetup."Dim. No. Cost Category" := "Dim. No. Cost Category";
                lrc_FruitVisionSetup.MODIFY();
            end;
        }
        field(13; "Dim. No. Cost Category"; Option)
        {
            Caption = 'Dim. No. Cost Category';
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = ' ,1. Dimension,2. Dimension,3. Dimension,4. Dimension,5. Dimension,6. Dimension,7. Dimension,8. Dimension';
            OptionMembers = " ","1. Dimension","2. Dimension","3. Dimension","4. Dimension","5. Dimension","6. Dimension","7. Dimension","8. Dimension";
        }
        field(15; "Feature Level"; Option)
        {
            Caption = 'Feature Level';
            DataClassification = CustomerContent;
            Description = 'Item,Batch Variant';
            OptionCaption = 'Item,Batch Variant';
            OptionMembers = Item,"Batch Variant";

            trigger OnValidate()
            var
                lrc_FruitVisionSetup: Record "POI ADF Setup";
                AGILES_TEXT001Txt: Label 'The Batch Assignment %1 in the table Batch Setup is not allowed !', Comment = '%1';
            begin
                IF "Feature Level" = "Feature Level"::"Batch Variant" THEN
                    IF "Sales Batch Assignment" = "Sales Batch Assignment"::"Manual Multiple Line" THEN
                        ERROR(AGILES_TEXT001Txt, "Sales Batch Assignment");

                // Feld ist auch in FruitVision Setup enthalten
                lrc_FruitVisionSetup.GET();
                lrc_FruitVisionSetup."Feature Level" := "Feature Level";
                lrc_FruitVisionSetup.MODIFY();
            end;
        }
        field(16; "Sales Batch Assignment"; Option)
        {
            Caption = 'Sales Batch Assignment';
            DataClassification = CustomerContent;
            Description = ' ,Automatic from System,,,,Manual Single Line,,Manual Multiple Line,,,Depend on Doc. Type';
            InitValue = "Manual Single Line";
            OptionCaption = ' ,Automatic from System,Dummy and Batch Job,,,Manual Single Line,,Manual Multiple Line,,,Depend on Doc. Type';
            OptionMembers = " ","Automatic from System","Dummy and Batch Job",,,"Manual Single Line",,"Manual Multiple Line",,,"Depend on Doc. Type";

            trigger OnValidate()
            var
                lrc_FruitVisionSetup: Record "POI ADF Setup";
                SSPText01Txt: Label 'The choice %1 ist not allowed !', Comment = '%1';
            begin
                IF "Sales Batch Assignment" = "Sales Batch Assignment"::" " THEN
                    ERROR(SSPText01Txt, "Sales Batch Assignment");

                IF "Sales Batch Assignment" = "Sales Batch Assignment"::"Manual Multiple Line" THEN BEGIN
                    lrc_FruitVisionSetup.GET();
                    lrc_FruitVisionSetup.TESTFIELD("Feature Level", lrc_FruitVisionSetup."Feature Level"::Item);
                END;
            end;
        }
        field(17; "Batch Stockout Warning"; Option)
        {
            Caption = 'Batch Stockout Warning';
            DataClassification = CustomerContent;
            Description = ' ,Warning,Blocking';
            OptionCaption = ' ,Warning,Blocking';
            OptionMembers = " ",Warning,Blocking;
        }
        field(18; "Batchsystem activ"; Boolean)
        {
            Caption = 'Batchsystem activ';
            DataClassification = CustomerContent;
        }
        field(19; "Purch. Alloc. thru Doc. Type"; Boolean)
        {
            Caption = 'Purch. Alloc. thru Doc. Type';
            DataClassification = CustomerContent;
        }
        field(20; "Purch. Source Master Batch"; Option)
        {
            Caption = 'Purch. Source Master Batch';
            DataClassification = CustomerContent;
            Description = ' ,No. Series,,,Purchase Order No.,,,Manuel,,,Customer';
            OptionCaption = ' ,No. Series,,,Purchase Order No.,,,Manuel,,,Customer';
            OptionMembers = " ","No. Series",,,"Purchase Order No.",,,Manuel,,,Customer;
        }
        field(25; "Purch. Master Batch No. Series"; Code[10])
        {
            Caption = 'Purch. Master Batch No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(26; "Purch. Batch No. Series"; Code[10])
        {
            Caption = 'Purch. Batch No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(30; "Purch. Allocation Batch No."; Option)
        {
            Caption = 'Purch. Allocation Batch No.';
            DataClassification = CustomerContent;
            Description = ' ,One Batch No per Order,Multiple Batch Nos per Order';
            OptionCaption = ' ,One Batch No per Order,Multiple Batch Nos per Order,New Batch No. per Line';
            OptionMembers = " ","One Batch No per Order","Multiple Batch Nos per Order","New Batch No. per Line";
        }
        field(31; "Purch. Source Batch No."; Option)
        {
            Caption = 'Purch. Source Batch No.';
            DataClassification = CustomerContent;
            Description = ' ,No. Series,,,Purchase Order No.,Master Batch Code,,Manuel,,,Customer';
            OptionCaption = ' ,No. Series,,,Purchase Order No.,Master Batch No.,,Manuel,,,Customer,,Master Batch No. + Postfix';
            OptionMembers = " ","No. Series",,,"Purchase Order No.","Master Batch No.",,Manuel,,,Customer,,"Master Batch No. + Postfix";
        }
        field(33; "Purch. Source Batch Variant"; Option)
        {
            Caption = 'Purch. Source Batch Variant';
            DataClassification = CustomerContent;
            Description = ' ,No. Series,,,Batch Code + Postfix';
            OptionCaption = ' ,No. Series,,,Batch No. + Postfix,,Batch No.';
            OptionMembers = " ","No. Series",,,"Batch No. + Postfix",,"Batch No.";
        }
        field(34; "Purch. Batch Variant No Series"; Code[10])
        {
            Caption = 'Purch. Batch Variant No Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(36; "Batch Separator"; Code[1])
        {
            Caption = 'Batch Separator';
            DataClassification = CustomerContent;
        }
        field(37; "Batch Postfix Places"; Integer)
        {
            Caption = 'Batch Postfix Places';
            DataClassification = CustomerContent;
        }
        field(38; "Batch Variant Separator"; Code[1])
        {
            Caption = 'Batch Variant Separator';
            DataClassification = CustomerContent;
        }
        field(39; "Batch Variant Postfix Places"; Integer)
        {
            Caption = 'Batch Variant Postfix Places';
            DataClassification = CustomerContent;
            InitValue = 2;
            MaxValue = 5;
            MinValue = 1;
        }
        field(41; "Dummy Batch Variant No."; Code[20])
        {
            Caption = 'Dummy Pos.-Var. Nr.';
            DataClassification = CustomerContent;
        }
        field(42; "Sales Open Batch Selection"; Boolean)
        {
            Caption = 'Sales Open Batch Selection';
            DataClassification = CustomerContent;
        }
        field(43; "Sales Page ID Sales Line"; Integer)
        {
            Caption = 'Sales Page ID Sales Line';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(44; "Sales Batch Var. all Companies"; Boolean)
        {
            Caption = 'Sales Batch Var. all Companies';
            DataClassification = CustomerContent;
        }
        field(45; "Pack. Batch Var. all Companies"; Boolean)
        {
            Caption = 'Pack. Batch Var. all Companies';
            DataClassification = CustomerContent;
        }
        field(46; "Sales Page ID Batch Var. List"; Integer)
        {
            Caption = 'Sales Page ID Batch Var. List';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(47; "Sales Page ID Matrix"; Integer)
        {
            Caption = 'Sales Page ID Matrix';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(48; "Additional Search for Lot No."; Boolean)
        {
            Caption = 'Additional Search for Lot No.';
            DataClassification = CustomerContent;
        }
        field(49; "Sales Page ID Matrix Criteria"; Integer)
        {
            Caption = 'Sales Page ID Matrix Criteria';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(50; "Pack. Master Batch No. Series"; Code[10])
        {
            Caption = 'Packing Order No. Series Master Batch';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(51; "Pack. Batch No. Series"; Code[10])
        {
            Caption = 'Packing Order No. Series Batch No.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(52; "Pack. Allocation Batch No."; Option)
        {
            Caption = 'Packing Order Allocation Batch No.';
            DataClassification = CustomerContent;
            Description = ' ,One Batch No. per Order,New Batch No. per Line';
            OptionCaption = 'One Batch No. per Order,New Batch No. per Line';
            OptionMembers = "One Batch No. per Order","New Batch No. per Line";
        }
        field(54; "P. Cr.Memo Page ID Purch. Line"; Integer)
        {
            Caption = 'P. Cr.Memo Page ID Purch. Line';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(55; "Dummy Batch Var. Activ"; Boolean)
        {
            Caption = 'Dummy Batch Var. Activ';
            DataClassification = CustomerContent;
        }
        field(57; "Purch. Plan Master Batch No."; Code[20])
        {
            Caption = 'Purch. Plan Master Batch No.';
            DataClassification = CustomerContent;
            //TableRelation = "Master Batch";
        }
        field(58; "Purch. Plan Batch No. Series"; Code[10])
        {
            Caption = 'Purch. Plan Batch No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(60; "Sort. Master Batch No. Series"; Code[10])
        {
            Caption = 'Sort. Master Batch No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(61; "Sort. Batch No. Series"; Code[10])
        {
            Caption = 'Sort. Batch No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(62; "Sort. Allocation Batch No."; Option)
        {
            Caption = 'Sorting Order Allocation Batch No.';
            DataClassification = CustomerContent;
            Description = ' ,One Batch No. per Order,New Batch No. per Line';
            OptionCaption = 'One Batch No. per Order,New Batch No. per Line';
            OptionMembers = "One Batch No. per Order","New Batch No. per Line";
        }
        field(65; "Subst. Master Batch No. Series"; Code[10])
        {
            Caption = 'Substitution Master Batch No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(66; "Subst. Batch No. Series"; Code[10])
        {
            Caption = 'Substitution Batch No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(67; "Subst. Allocation Batch No."; Option)
        {
            Caption = 'Substitution Order Allocation Batch No.';
            DataClassification = CustomerContent;
            Description = ' ,One Batch No. per Order,New Batch No. per Line';
            OptionCaption = 'One Batch No. per Order,New Batch No. per Line';
            OptionMembers = "One Batch No. per Order","New Batch No. per Line";
        }
        field(71; "Sales Loc. equal Entry Loc."; Boolean)
        {
            Caption = 'Sales Loc. equal Entry Loc.';
            DataClassification = CustomerContent;
        }
        field(72; "Sales Martix Save Filters"; Boolean)
        {
            Caption = 'Matrix Filterkriterien speichern';
            DataClassification = CustomerContent;
        }
        field(79; "IJnlLi Allocation Master Batch"; Option)
        {
            Caption = 'Item Journal Line Allocation Master Batch No.';
            DataClassification = CustomerContent;
            Description = ' ,One Master Batch No per Journal Batch Name,New Master Batch No. per Line';
            OptionCaption = ' ,One Master Batch No per Journal Batch Name,New Master Batch No. per Line';
            OptionMembers = " ","One Master Batch No per Journal Batch Name","New Master Batch No. per Line";
        }
        field(80; "IJnlLi Source Master Batch"; Option)
        {
            Caption = 'Item Journal Line Source Master Batch No.';
            DataClassification = CustomerContent;
            Description = 'No. Series';
            OptionCaption = 'No. Series';
            OptionMembers = "No. Series";
        }
        field(81; "IJnlLi Master Batch No. Series"; Code[10])
        {
            Caption = 'Item Journal Line No. Series Master Batch';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(82; "IJnlLi Allocation Batch No."; Option)
        {
            Caption = 'Item Journal Line Allocation Batch No.';
            DataClassification = CustomerContent;
            Description = ' ,One Batch No per Journal Batch Name,New Batch No. per Line';
            OptionCaption = ' ,One Batch No per Order,Multiple Batch Nos per Order,New Batch No. per Line';
            OptionMembers = " ","One Batch No per Journal Batch Name","New Batch No. per Line";

            trigger OnValidate()
            var
                SSPText01Txt: Label 'The choosen value is not possible !';
            begin
                IF ("IJnlLi Source Batch Variant" = "IJnlLi Source Batch Variant"::"Batch No.") AND
                   ("IJnlLi Allocation Batch No." =
                     "IJnlLi Allocation Batch No."::"One Batch No per Journal Batch Name") THEN
                    // Kombination nicht erlaubt
                    ERROR(SSPText01Txt);
            end;
        }
        field(83; "IJnlLi Source Batch No."; Option)
        {
            Caption = 'Item Journal Line Source Batch No.';
            DataClassification = CustomerContent;
            Description = ' ,No. Series,,,Master Batch No.,,Master Batch No. + Postfix';
            OptionCaption = ' ,No. Series,,,Master Batch No.,,Master Batch No. + Postfix';
            OptionMembers = " ","No. Series",,,"Master Batch No.",,"Master Batch No. + Postfix";
        }
        field(84; "IJnlLi Batch No. Series"; Code[10])
        {
            Caption = 'Item Journal Line No. Series Batch';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(85; "IJnlLi Source Batch Variant"; Option)
        {
            Caption = 'Item Journal Line Source Batch Variant No.';
            DataClassification = CustomerContent;
            Description = ' ,No. Series,,,Batch No.,,Batch No. + Postfix';
            OptionCaption = ' ,No. Series,,,Batch No.,,Batch No. + Postfix';
            OptionMembers = " ","No. Series",,,"Batch No.",,"Batch No. + Postfix";

            trigger OnValidate()
            var
                SSPText01Txt: Label 'The choosen value is not possible !';
            begin
                IF ("IJnlLi Source Batch Variant" = "IJnlLi Source Batch Variant"::"Batch No.") AND
                   ("IJnlLi Allocation Batch No." =
                     "IJnlLi Allocation Batch No."::"One Batch No per Journal Batch Name") THEN
                    // Kombination nicht erlaubt
                    ERROR(SSPText01Txt);
            end;
        }
        field(86; "IJnlLi Batch Variant No Series"; Code[10])
        {
            Caption = 'Item Journal Line No. Series Batch Variant No.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(91; "Batch Var. Detail No. Series"; Code[10])
        {
            Caption = 'Batch Var. Detail No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(92; "Batch Var. No. Series"; Code[10])
        {
            Caption = 'Batch Var. No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(95; "Put Batch Var. Changes to Sale"; Option)
        {
            Caption = 'Put Batch Var. Changes to Sale';
            DataClassification = CustomerContent;
            OptionCaption = 'No Transfer,Transfer Always,Transfer with Confirm';
            OptionMembers = "No Transfer","Transfer Always","Transfer with Confirm";
        }
        field(101; "Last Item Application Entry"; Integer)
        {
            Caption = 'Last Item Application Entry';
            DataClassification = CustomerContent;
        }
        field(110; "Page ID Batch Var. Detail Stat"; Integer)
        {
            Caption = 'Page ID Batch Var. Detail Stat';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(111; "Page ID Batch Detail Stat"; Integer)
        {
            Caption = 'Page ID Batch Detail Stat';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(112; "Page ID Mast.Batch Detail Stat"; Integer)
        {
            Caption = 'Page ID Mast.Batch Detail Stat';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(121; "Assort. Master Batch No."; Code[20])
        {
            Caption = 'Assort. Master Batch No.';
            DataClassification = CustomerContent;
            //TableRelation = "Master Batch";
        }
        field(123; "Assort. Batch No. Series"; Code[10])
        {
            Caption = 'Assort. Batch No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(125; "Assort. Source Batch Variant"; Option)
        {
            Caption = 'Assort. Source Batch Variant';
            DataClassification = CustomerContent;
            Description = ' ,No. Series,,,Batch Code + Postfix';
            OptionCaption = ' ,No. Series,,,Batch No. + Postfix,,Batch No.';
            OptionMembers = " ","No. Series",,,"Batch No. + Postfix",,"Batch No.";
        }
        field(126; "Assort. Batch Var. No Series"; Code[10])
        {
            Caption = 'Assort. Batch Var. No Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(127; "Assort. Batch Var. Separator"; Code[1])
        {
            Caption = 'Assort. Batch Var. Separator';
            DataClassification = CustomerContent;
        }
        field(128; "Assort. Batch V. PostfixPlaces"; Integer)
        {
            Caption = 'Assort. Batch V. PostfixPlaces';
            DataClassification = CustomerContent;
            InitValue = 2;
            MaxValue = 5;
            MinValue = 1;
        }
        field(151; "Trans. Page ID Transfer Line"; Integer)
        {
            Caption = 'Trans. Page ID Transfer Line';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(152; "Trans. Page ID Batch Var. List"; Integer)
        {
            Caption = 'Trans. Page ID Batch Var. List';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(153; "Trans. Page ID Matrix"; Integer)
        {
            Caption = 'Trans. Page ID Matrix';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(154; "Trans. Page ID Matrix Criteria"; Integer)
        {
            Caption = 'Trans. Page ID Matrix Criteria';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(161; "P.O. Page ID Pack. Inp. Line"; Integer)
        {
            Caption = 'P.O. Page ID Pack. Inp. Line';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(162; "P.O. Page ID Batch Var. List"; Integer)
        {
            Caption = 'P.O. Page ID Batch Var. List';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(163; "P.O. Page ID Matrix"; Integer)
        {
            Caption = 'P.O. Page ID Matrix';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(164; "P.O. Page ID Matrix Criteria"; Integer)
        {
            Caption = 'P.O. Page ID Matrix Criteria';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(498; "Acc. Sales Post Acc. Sales"; Boolean)
        {
            Caption = 'Acc. Sales Post Acc. Sales';
            DataClassification = CustomerContent;
        }
        field(499; "Acc. Sales Write Back in P.Ord"; Boolean)
        {
            Caption = 'Acc. Sales Write Back in P.Ord';
            DataClassification = CustomerContent;
        }
        field(501; "Acc. Sales No. Series"; Code[10])
        {
            Caption = 'Acc. Sales No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(502; "Acc. Sales Posted No. Series"; Code[10])
        {
            Caption = 'Acc. Sales Posted No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(503; "Acc. Sales Default Quantity"; Option)
        {
            Caption = 'Acc. Sales Default Quantity';
            DataClassification = CustomerContent;
            Description = ' ,Purchase Quantity,Sales Quantity';
            OptionCaption = ' ,Purchase Quantity,Sales Quantity';
            OptionMembers = " ","Purchase Quantity","Sales Quantity";
        }
        field(505; "Acc. Sales Qty of Sales"; Option)
        {
            Caption = 'Acc. Sales Qty of Sales';
            DataClassification = CustomerContent;
            Description = 'Offen+Geliefert+Fakturiert,Geliefert+Fakturiert,Fakturiert';
            OptionCaption = 'Open+Shipped+Invoiced,Shipped+Invoiced,Invoiced';
            OptionMembers = "Open+Shipped+Invoiced","Shipped+Invoiced",Invoiced;
        }
        field(506; "Acc. Sales Qty of Purchase"; Option)
        {
            Caption = 'Acc. Sales Qty of Purchase';
            DataClassification = CustomerContent;
            Description = 'Offen+Geliefert,Geliefert';
            OptionCaption = 'Open+Shipped,Shipped';
            OptionMembers = "Open+Shipped",Shipped;
        }
        field(507; "Acc. Sales Purch. Qty. Rec."; Boolean)
        {
            Caption = 'Set Purchase Quantity to Receive manuell';
            DataClassification = CustomerContent;
        }
        field(508; "Acc. Sales Cost Category Com 1"; Code[20])
        {
            Caption = 'Cost Category Commission 1';
            DataClassification = CustomerContent;
            TableRelation = "POI Cost Category".Code WHERE("Cost Type General" = CONST(Commission));
        }
        field(509; "Acc. Sales Cost Category Com 2"; Code[20])
        {
            Caption = 'Cost Category Commission 2';
            DataClassification = CustomerContent;
            TableRelation = "POI Cost Category".Code WHERE("Cost Type General" = CONST(Commission));
        }
        field(510; "Acc. Sales Cost Category Com 3"; Code[20])
        {
            Caption = 'Cost Category Commission 3';
            DataClassification = CustomerContent;
            TableRelation = "POI Cost Category".Code WHERE("Cost Type General" = CONST(Commission));
        }
        field(511; "Acc. Sales Cr.Memo Inland"; Code[10])
        {
            Caption = 'Acc. Sales Cr.Memo Inland';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(512; "Acc. Sales Cr.Memo EU"; Code[10])
        {
            Caption = 'Acc. Sales Cr.Memo EU';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(513; "Acc. Sales Cr.Memo Ausland"; Code[10])
        {
            Caption = 'Acc. Sales Cr.Memo Ausland';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(514; "Posting Type Neg. Acc. Sales"; Option)
        {
            Caption = 'Posting Type Neg. Acc. Sales';
            DataClassification = CustomerContent;
            OptionCaption = 'Cr. Memo Journal Line,Credit Memo Purchase Document';
            OptionMembers = "Cr. Memo Journal Line","Credit Memo Purchase Document";
        }
        field(515; "CrM. ItemCharge neg. Acc.Sales"; Code[20])
        {
            Caption = 'CrM. ItemCharge neg. Acc.Sales';
            DataClassification = CustomerContent;
            //TableRelation = "Item Charge".No.;
        }
        field(516; "Acc. Sales Cost Cat. Refund"; Code[20])
        {
            Caption = 'Kostenkategorie Rückvergütung Agent';
            DataClassification = CustomerContent;
            TableRelation = "POI Cost Category".Code;
        }
        field(517; "Acc. Sales No. Series Refund"; Code[10])
        {
            Caption = 'Acc. Sales No. Series Refund';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(518; "Gen. Jnl. Temp. Name Refund"; Code[10])
        {
            Caption = 'Buch.Bl.Vorl. Rückstellungen';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }
        field(519; "Gen. Jnl. Batch Refund"; Code[10])
        {
            Caption = 'Buch.Bl.Name Rückstellungen';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Gen. Jnl. Temp. Name Refund"));
        }
        field(520; "Acc. Sales Cost Schema"; Code[10])
        {
            Caption = 'Acc. Sales Cost Schema';
            DataClassification = CustomerContent;
            TableRelation = "POI Cost Schema Name";
        }
        field(525; "Acc. Sales Print Post. P.Order"; Boolean)
        {
            Caption = 'Acc. Sales Print Post. P.Order';
            DataClassification = CustomerContent;
        }
        field(526; "Acc. Sales Print Post. C.Memo"; Boolean)
        {
            Caption = 'Acc. Sales Print Post. C.Memo';
            DataClassification = CustomerContent;
        }
        field(530; "Acc. S. Kind of Pur.Price Calc"; Option)
        {
            Caption = 'Acc. S. Kind of Pur.Price Calc';
            DataClassification = CustomerContent;
            OptionCaption = 'Cost depending on Turnover,Cost per Batch and Difference depending on Turnover,Cost per Batch and Difference depending on Base Quantity';
            OptionMembers = "Cost depending on Turnover","Cost per Batch and Difference depending on Turnover","Cost per Batch and Difference depending on Base Quantity";
        }
        field(531; "Acc. Sales No. Series Profit S"; Code[10])
        {
            Caption = 'Acc. Sales No. Series Profit S';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(532; "Gen. Jnl. Temp. Name Prof.Spli"; Code[10])
        {
            Caption = 'Gen. Jnl. Temp. Name Prof.Spli';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }
        field(533; "Gen. Jnl. Batch Prof. Split"; Code[10])
        {
            Caption = 'Gen. Jnl. Batch Prof. Split';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Gen. Jnl. Temp. Name Prof.Spli"));
        }
        field(600; "Sales Stat. No. Series"; Code[10])
        {
            Caption = 'Sales Stat. No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(601; "Sales Stat. Posted No. Series"; Code[10])
        {
            Caption = 'Sales Stat. Posted No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(602; "Sales Stat. Sales"; Option)
        {
            Caption = 'Sales Statement Sales';
            DataClassification = CustomerContent;
            Description = 'Offen+Geliefert+Fakturiert,Geliefert+Fakturiert,Fakturiert';
            OptionCaption = 'Open+Shipped+Invoiced,Shipped+Invoiced,Invoiced';
            OptionMembers = "Open+Shipped+Invoiced","Shipped+Invoiced",Invoiced;
        }
        field(603; "Sales Stat. Purchase"; Option)
        {
            Caption = 'Sales Statement Purchase';
            DataClassification = CustomerContent;
            Description = 'Offen+Geliefert,Geliefert';
            OptionCaption = 'Open+Shipped,Shipped';
            OptionMembers = "Open+Shipped",Shipped;
        }
        field(604; "Sales Stat. Line not Del. Qty0"; Boolean)
        {
            Caption = 'Not Delete Sales Statement Line if Quantity Total Sales Statement Capable is 0';
            DataClassification = CustomerContent;
        }
        field(605; "Sa. Stat. Line not Del. AfterP"; Boolean)
        {
            Caption = 'Sa. Stat. Line not Del. AfterP';
            DataClassification = CustomerContent;
        }
        field(606; "Sales Stat. Econ. Can"; Option)
        {
            Caption = 'Sales Stat. Econ. Can';
            DataClassification = CustomerContent;
            OptionCaption = ' ,,,,,,Without Econ. Can';
            OptionMembers = " ",,,,,,"Without Econ. Can";
        }
        field(620; "Acc. Sales Card Page ID"; Integer)
        {
            Caption = 'Acc. Sales Card Page ID';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(624; "Acc. Sales Cost Split Page ID"; Integer)
        {
            Caption = 'Acc. Sales Cost Split Page ID';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(701; "Res. Page ID Reservation Line"; Integer)
        {
            Caption = 'Res. Page ID Reservation Line';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(702; "Res. Page ID Batch Var. List"; Integer)
        {
            Caption = 'Trans. Page ID Batch Var. List';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(703; "Res. Page ID Matrix"; Integer)
        {
            Caption = 'Trans. Page ID Matrix';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(801; "ExpAvail. Stock incl. SalesCrM"; Boolean)
        {
            Caption = 'Exp. Avail. Stock incl. Sales Cr. M';
            DataClassification = CustomerContent;
        }
        field(802; "ExpAvail. Stock incl. PurchCrM"; Boolean)
        {
            Caption = 'Exp. Avail. Stock incl. Purch Cr. M';
            DataClassification = CustomerContent;
        }
        field(803; "Avail. Stock incl. Sales Cr. M"; Boolean)
        {
            Caption = 'Avail. Stock incl. Sales Cr. M';
            DataClassification = CustomerContent;
        }
        field(804; "Avail. Stock incl. Purch Cr. M"; Boolean)
        {
            Caption = 'Avail. Stock incl. Purch Cr. M';
            DataClassification = CustomerContent;
        }
        field(810; "Set Batch Var. Closed when"; Option)
        {
            Caption = 'Set Batch Var. Closed when';
            DataClassification = CustomerContent;
            OptionCaption = 'Mge erw. verfg. Null,Mge erh. und gelief. Null';
            OptionMembers = "Mge erw. verfg. Null","Mge erh. und gelief. Null";
        }
        field(901; "B.I.S. Page ID"; Integer)
        {
            Caption = 'B.I.S. Page ID';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(905; "B.I.S. Cust. Pr.-Grp. 1"; Code[10])
        {
            Caption = 'B.I.S. Cust. Pr.-Grp. 1';
            DataClassification = CustomerContent;
            TableRelation = "Customer Price Group";
        }
        field(906; "B.I.S. Cust. Pr.-Grp. 2"; Code[10])
        {
            Caption = 'B.I.S. Cust. Pr.-Grp. 2';
            DataClassification = CustomerContent;
            TableRelation = "Customer Price Group";
        }
        field(907; "B.I.S. Cust. Pr.-Grp. 3"; Code[10])
        {
            Caption = 'B.I.S. Cust. Pr.-Grp. 3';
            DataClassification = CustomerContent;
            TableRelation = "Customer Price Group";
        }
        field(910; "B.I.S. Marge 1"; Decimal)
        {
            Caption = 'B.I.S. Marge 1';
            DataClassification = CustomerContent;
        }
        field(911; "B.I.S. Marge 2"; Decimal)
        {
            Caption = 'B.I.S. Marge 2';
            DataClassification = CustomerContent;
        }
        field(912; "B.I.S. Marge 3"; Decimal)
        {
            Caption = 'B.I.S. Marge 3';
            DataClassification = CustomerContent;
        }
        field(951; "Page ID Pos.-Var. List"; Integer)
        {
            Caption = 'Page ID Pos.-Var. List';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(952; "Page ID Pos.-Var. Serach List"; Integer)
        {
            Caption = 'Page ID Pos.-Var. Serach List';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }
}

