table 50010 "POI Sales Doc. Subtype"
{

    Caption = 'Sales Doc. Subtype';
    // DrillDownPageId = Form5110405;
    // LookupPageId = Form5110405;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,,,,,,,,Picking Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,,,,,,,,"Picking Order";
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(11; "Document No. Series"; Code[10])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(12; "Combine Invoice No. Series"; Code[10])
        {
            Caption = 'Combine Invoice No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(13; "Inv./Credit Memo No. Series"; Code[10])
        {
            Caption = 'Inv./Credit Memo No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(16; "Default Subtype"; Boolean)
        {
            Caption = 'Default Subtype';
            DataClassification = CustomerContent;
        }
        field(20; "In Selection"; Boolean)
        {
            Caption = 'In Selection';
            DataClassification = CustomerContent;
        }
        field(21; "Show all Doc. Subtypes"; Boolean)
        {
            Caption = 'Show all Doc. Subtypes';
            DataClassification = CustomerContent;
        }
        field(22; "Direct Delivery (Agency)"; Boolean)
        {
            Caption = 'Direct Delivery (Agency)';
            DataClassification = CustomerContent;
        }
        field(30; "-"; Integer)
        {
            Enabled = false;
            DataClassification = CustomerContent;
        }
        field(31; "Sales Batch Assignment"; Option)
        {
            Caption = 'Sales Batch Assignment';
            DataClassification = CustomerContent;
            InitValue = "Manual Single Line";
            OptionCaption = ' ,Automatic from System,,,,Manual Single Line,,Manual Multiple Line';
            OptionMembers = " ","Automatic from System",,,,"Manual Single Line",,"Manual Multiple Line";

            trigger OnValidate()
            var
            //lrc_BatchSetup: Record "5110363";
            begin
                //lrc_BatchSetup.GET();
            end;
        }
        field(49; "--"; Integer)
        {
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;
            Editable = false;
            Enabled = false;
        }
        field(50; "Form ID List"; Integer)
        {
            Caption = 'Form ID List';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(51; "Form ID Card"; Integer)
        {
            Caption = 'Form ID Card';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(52; "Form ID Sortiment"; Integer)
        {
            Caption = 'Form ID Sortiment';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(53; "Form ID Fone Sales Card"; Integer)
        {
            Caption = 'Form ID Fone Sales Card';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(54; "Form ID Empties Card"; Integer)
        {
            Caption = 'Form ID Empties Card';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(55; "Allow Scrolling in Card"; Boolean)
        {
            Caption = 'Allow Scrolling in Card';
            DataClassification = CustomerContent;
        }
        field(56; "Form ID Global Card"; Integer)
        {
            Caption = 'Form ID Global Card';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(57; "Form ID Matrix Sales Line"; Integer)
        {
            Caption = 'Form ID Matrix Sales Line';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(58; "Form ID Line Card"; Integer)
        {
            Caption = 'Form ID Line Card';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(59; "Form ID Card in Whse."; Integer)
        {
            Caption = 'Form ID Card in Whse.';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(60; "Restrict Locations"; Option)
        {
            Caption = 'Restrict Locations';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Vorgabe,Feste Eingrenzung,Belegkopf';
            OptionMembers = " ",Vorgabe,"Feste Eingrenzung",Belegkopf;
        }
        field(61; "Default Location Code"; Code[10])
        {
            Caption = 'Default Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(63; "Restrict Customers"; Boolean)
        {
            Caption = 'Restrict Customers';
            DataClassification = CustomerContent;
        }
        field(64; "Default Customer No."; Code[20])
        {
            Caption = 'Default Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(65; "Default Means of Transp. Type"; Option)
        {
            Caption = 'Default Means of Transp. Type';
            DataClassification = CustomerContent;
            Description = ' ,Truck,Train,Ship,Airplane';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;
        }
        field(69; "Default Value for Weighting"; Option)
        {
            Caption = 'Default Value for Weighting';
            DataClassification = CustomerContent;
            OptionCaption = 'Weight from Unit of Measure,No Weight,Weight from Batch Variant';
            OptionMembers = "Weight from Unit of Measure","No Weight","Weight from Batch Variant";
        }
        field(70; "Quality Control Vendor No."; Code[20])
        {
            Caption = 'Quality Control Vendor No.';
            DataClassification = CustomerContent;
            //TableRelation = Vendor WHERE ("Is Quality Controller"=CONST(Yes));
        }
        field(71; "Pallet Movement Lines"; Option)
        {
            Caption = 'Pallet Movement Lines';
            DataClassification = CustomerContent;
            OptionCaption = 'No Pallet Movement,Pallet Movement';
            OptionMembers = "No Pallet Movement","Pallet Movement";
        }
        field(72; "Item Charge Assignment"; Option)
        {
            Caption = 'Item Charge Assignment';
            DataClassification = CustomerContent;
            OptionCaption = ' ,One to One';
            OptionMembers = " ","Eins zu Eins";
        }
        field(74; "Set Status to Open"; Boolean)
        {
            Caption = 'Set Status to Open';
            DataClassification = CustomerContent;
        }
        field(75; "Allow Multiple Shipping Agents"; Boolean)
        {
            Caption = 'Allow Multiple Shipping Agents';
            DataClassification = CustomerContent;
        }
        field(76; "Use VAT Evaluation"; Boolean)
        {
            Caption = 'Use VAT Evaluation';
            DataClassification = CustomerContent;
        }
        field(77; "Open Print Window on Close"; Boolean)
        {
            Caption = 'Open Print Window on Close';
            DataClassification = CustomerContent;
        }
        field(78; "Kind of Settlement"; Option)
        {
            Caption = 'Kind of Settlement';
            DataClassification = CustomerContent;
            Description = 'Fix Price,Commission';
            OptionCaption = 'Fix Price,Commission';
            OptionMembers = "Fix Price",Commission;
        }
        field(79; "Invoice of Sales Order"; Option)
        {
            Caption = 'Invoice of Sales Order';
            DataClassification = CustomerContent;
            Description = ' ,Release has to be set,No open Claim,,,Release and no open Claim';
            OptionCaption = ' ,Release has to be set,No open Claim,,,Release and no open Claim';
            OptionMembers = " ","Release has to be set","No open Claim",,,"Release and no open Claim";
        }
        field(80; "Max. No. of Lines in Document"; Integer)
        {
            Caption = 'Max. No. of Lines in Document';
            DataClassification = CustomerContent;
        }
        field(81; "Delete only when no Lines"; Boolean)
        {
            Caption = 'Delete only when no Lines';
            DataClassification = CustomerContent;
        }
        field(83; "Order Doc. Subtype Code"; Code[10])
        {
            Caption = 'Order Doc. Subtype Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Sales Doc. Subtype".Code WHERE("Document Type" = CONST(Order));
        }
        field(84; "Return Doc. Subtype Code"; Code[10])
        {
            Caption = 'Return Doc. Subtype Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("Document Type" = FILTER(Order | Invoice)) "POI Sales Doc. Subtype".Code WHERE("Document Type" = CONST("Return Order"));
        }
        field(85; "Cr. Memo Doc. Subtype Code"; Code[10])
        {
            Caption = 'Cr. Memo Doc. Subtype Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("Document Type" = FILTER(Order | Invoice)) "POI Sales Doc. Subtype".Code WHERE("Document Type" = CONST("Credit Memo"));
        }
        field(86; "Invoice Doc. Subtype Code"; Code[10])
        {
            Caption = 'Invoice Doc. Subtype Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("Document Type" = CONST("Credit Memo")) "POI Sales Doc. Subtype".Code WHERE("Document Type" = CONST(Invoice));
        }
        field(88; "Purch. Order Doc. Subtype Code"; Code[10])
        {
            Caption = 'Purch. Order Doc. Subtype Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Purch. Doc. Subtype".Code WHERE("Document Type" = CONST(Order));
        }
        field(89; "Pack. Doc. Subtype Code"; Code[10])
        {
            Caption = 'Pack. Doc. Subtype Code';
            DataClassification = CustomerContent;
            //TableRelation = "Pack. Doc. Subtype".Code;
        }
        field(90; "Enter Freight Costs"; Option)
        {
            Caption = 'Enter Freight Costs';
            DataClassification = CustomerContent;
            Description = ' ,Compulsory Entry';
            OptionCaption = ' ,Compulsory Entry';
            OptionMembers = " ","Compulsory Entry";
        }
        field(91; "Posting Freight Costs"; Boolean)
        {
            Caption = 'Posting Freight Costs';
            DataClassification = CustomerContent;
        }
        field(92; "Default Freight Calculation"; Option)
        {
            Caption = 'Default Freight Calculation';
            DataClassification = CustomerContent;
            OptionCaption = 'Standard,Manual in Line';
            OptionMembers = Standard,"Manual in Line";
        }
        field(93; "Show in List till Doc. Status"; Option)
        {
            Caption = 'Show in List till Doc. Status';
            DataClassification = CustomerContent;
            OptionCaption = 'Offen,Prüfung erforderlich,Erfassung abgeschlossen,,,Freigabe Kommissionierung,,Fehlerhafte Kommissionierung,Kommissionierung,,,Rückerfassung erfolgt,,,Lieferschein erstellt,,,Freigabe Fakturierung,,,,Faktura erstellt,,,,Abgeschlossen,,,Manuell Abgeschlossen,,,Storniert,,,Gelöscht';
            OptionMembers = Offen,"Prüfung erforderlich","Erfassung abgeschlossen",,,"Freigabe Kommissionierung",,"Fehlerhafte Kommissionierung",Kommissionierung,,,"Rückerfassung erfolgt",,,"Lieferschein erstellt",,,"Freigabe Fakturierung",,,,"Faktura erstellt",,,,Abgeschlossen,,,"Manuell Abgeschlossen",,,Storniert,,,"Gelöscht";
        }
        field(94; "Is IC Doc. Subtype"; Boolean)
        {
            Caption = 'Is IC Doc. Subtype';
            DataClassification = CustomerContent;
        }
        field(95; "IC Document Type"; Option)
        {
            Caption = 'IC Document Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(96; "IC Doc. Subtype Code"; Code[10])
        {
            Caption = 'IC Belegunterarten Code';
            DataClassification = CustomerContent;
        }
        field(100; "---"; Integer)
        {
            Enabled = false;
            DataClassification = CustomerContent;
        }
        field(101; "G/L Account Cash"; Code[20])
        {
            Caption = 'G/L Account Cash';
            DataClassification = CustomerContent;
            //TableRelation = "G/L Account" WHERE ("Allowed in Cash Sales"=CONST(Yes));

            trigger OnValidate()
            begin
                IF "Cash/Cheque Sales" = FALSE THEN
                    ERROR('Nur für Barverkauf zugelassen!');
            end;
        }
        field(102; "G/L Account Cheque"; Code[20])
        {
            Caption = 'G/L Account Cheque';
            DataClassification = CustomerContent;
            //TableRelation = "G/L Account" WHERE ("Allowed in Cash Sales"=CONST(Yes));

            trigger OnValidate()
            begin
                IF not "Cash/Cheque Sales" THEN
                    ERROR('Nur für Barverkauf zugelassen!');
            end;
        }
        field(110; "Cash/Cheque Sales"; Boolean)
        {
            Caption = 'Cash/Cheque Sales';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF "Cash/Cheque Sales" = FALSE THEN BEGIN
                    "G/L Account Cash" := '';
                    "G/L Account Cheque" := '';
                END;
            end;
        }
        field(121; "Post Delivery with fut. Date"; Boolean)
        {
            Caption = 'Post Delivery with fut. Date';
            DataClassification = CustomerContent;
        }
        field(122; "Post Invoice with fut. Date"; Boolean)
        {
            Caption = 'Post Invoice with fut. Date';
            DataClassification = CustomerContent;
        }
        field(123; "Released for Invoice"; Option)
        {
            Caption = 'Released for Invoice';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Check for Shipment';
            OptionMembers = " ","Check for Shipment";
        }
        field(130; "-----"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(131; "Promised Delivery Date"; Option)
        {
            Caption = 'Zugesagtes Lieferdatum';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Warenausg.-Datum,Warenausg.-Datum + 1 Tag,Warenausg.-Datum + Transportzeit Debitor,Warenausg.-Datum + Transportzeit Belegunterart';
            OptionMembers = " ","Warenausg.-Datum","Warenausg.-Datum + 1 Tag","Warenausg.-Datum + Transportzeit Debitor","Warenausg.-Datum + Transportzeit Belegunterart";
        }
        field(133; "Shipment Date"; Option)
        {
            Caption = 'Shipment Date';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Order Date,Next Working Day,No Date';
            OptionMembers = " ","Order Date","Next Working Day","No Date";
        }
        field(134; "Posting Date Shipment"; Option)
        {
            Caption = 'Posting Date Shipment';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Shipment Date,Promised Delivery Date,Work Date,Work Date + Question,,,,,Question';
            OptionMembers = " ","Shipment Date","Promised Delivery Date","Work Date","Work Date + Question",,,,,Question;
        }
        field(135; "Posting Date Invoice"; Option)
        {
            Caption = 'Posting Date Invoice';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Shipment Date,Promised Delivery Date,Work Date,Work Date + Question,,,,,Question';
            OptionMembers = " ","Shipment Date","Promised Delivery Date","Work Date","Work Date + Question",,,,,Question;
        }
        field(136; "Document Date Invoice"; Option)
        {
            Caption = 'Document Date Invoice';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Posting Date,Work Date';
            OptionMembers = " ","Posting Date","Work Date";
        }
        field(140; "Ship. Date Inv. is Blocked"; Option)
        {
            Caption = 'Ship. Date Inv. is Blocked';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Next possible Date,Ignore Blocking';
            OptionMembers = " ","Next possible Date","Ignore Blocking";
        }
        field(141; "Post. Date Inv. is Blocked"; Option)
        {
            Caption = 'Post. Date Inv. is Blocked';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Next possible Date';
            OptionMembers = " ","Next possible Date";
        }
        field(142; "Doc.Status After Post.Shipment"; Option)
        {
            Caption = 'Document Status After Posting Shipment';
            DataClassification = CustomerContent;
            OptionCaption = 'Offen,Prüfung erforderlich,Erfassung abgeschlossen,,,Freigabe Kommissionierung,,Fehlerhafte Kommissionierung,Kommissionierung,,,Rückerfassung erfolgt,,,Lieferschein erstellt,,,Freigabe Fakturierung,,,,Faktura erstellt,,,,Abgeschlossen,,,Manuell Abgeschlossen,,,Storniert,,,Gelöscht';
            OptionMembers = Offen,"Prüfung erforderlich","Erfassung abgeschlossen",,,"Freigabe Kommissionierung",,"Fehlerhafte Kommissionierung",Kommissionierung,,,"Rückerfassung erfolgt",,,"Lieferschein erstellt",,,"Freigabe Fakturierung",,,,"Faktura erstellt",,,,Abgeschlossen,,,"Manuell Abgeschlossen",,,Storniert,,,"Gelöscht";
        }
        field(200; "------"; Integer)
        {
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;
            Editable = false;
            Enabled = false;
        }
        field(201; "Report ID Picking Order"; Integer)
        {
            Caption = 'Report ID Picking Order';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(202; "Form ID Picking Order List"; Integer)
        {
            Caption = 'Form ID Picking Order List';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(203; "Form ID Picking Order Card"; Integer)
        {
            Caption = 'Form ID Picking Order Card';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(241; "No Check if Item is activ"; Boolean)
        {
            Caption = 'No Check if Item is activ';
            DataClassification = CustomerContent;
        }
        field(242; "Sales Price Zero"; Option)
        {
            Caption = 'Sales Price Zero';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Not Allowed,With Request,Not Allowed for Trade Items';
            OptionMembers = " ","Not Allowed","With Request","Not Allowed for Trade Items";
        }
        field(243; "Confirmation Sales Qty. over"; Decimal)
        {
            Caption = 'Confirmation Sales Qty. over';
            DataClassification = CustomerContent;
        }
        field(250; "-------"; Integer)
        {
            Enabled = false;
            DataClassification = CustomerContent;
        }
        field(251; "Shipping Time"; DateFormula)
        {
            Caption = 'Shipping Time';
            DataClassification = CustomerContent;
        }
        field(252; "Calendar Week"; DateFormula)
        {
            Caption = 'Calendar Week';
            DataClassification = CustomerContent;
            Description = 'IFW 03.04.08';
        }
        field(299; "--------"; Integer)
        {
            Enabled = false;
            DataClassification = CustomerContent;
        }
        field(300; "Info 1 Visible"; Boolean)
        {
            Caption = 'Info 1 Visible';
            DataClassification = CustomerContent;
            Description = 'BSI';
        }
        field(301; "Info 2 Visible"; Boolean)
        {
            Caption = 'Info 2 Visible';
            DataClassification = CustomerContent;
            Description = 'BSI';
        }
        field(302; "Info 3 Visible"; Boolean)
        {
            Caption = 'Info 3 Visible';
            DataClassification = CustomerContent;
            Description = 'BSI';
        }
        field(303; "Info 4 Visible"; Boolean)
        {
            Caption = 'Info 4 Visible';
            DataClassification = CustomerContent;
            Description = 'BSI';
        }
        field(305; "---------"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(351; "Posted ShipNo Equal OrderNo"; Boolean)
        {
            Caption = 'Posted ShipNo Equal OrderNo';
            DataClassification = CustomerContent;
        }
        field(352; "Posted PostNo Equal OrderNo"; Boolean)
        {
            Caption = 'Posted PostNo Equal OrderNo';
            DataClassification = CustomerContent;
        }
        field(399; "Posted Nos. Series"; Integer)
        {
            Caption = 'Posted Nos. Series';
            DataClassification = CustomerContent;
        }
        field(400; "Posted Invoice Nos."; Code[10])
        {
            Caption = 'Posted Invoice Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(401; "Posted Credit Memo Nos."; Code[10])
        {
            Caption = 'Posted Credit Memo Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(402; "Posted Shipment Nos."; Code[10])
        {
            Caption = 'Posted Shipment Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(403; "Posted Return Receipt Nos."; Code[10])
        {
            Caption = 'Posted Return Receipt Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(499; "----------"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(500; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                MODIFY();
            end;
        }
        field(501; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                MODIFY();
            end;
        }
        field(502; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,1,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
                MODIFY();
            end;
        }
        field(503; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,1,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
                MODIFY();
            end;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Code")
        {
        }
    }

    fieldgroups
    {
    }

    // procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    // var
    //     lcu_DimMgt: Codeunit DimensionManagement;
    //     lrc_BatchSetup: Record "5110363";
    //     SSPText01: Label 'This dimension could not be defined !';
    // begin
    //     IF ShortcutDimCode <> '' THEN BEGIN
    //        lrc_BatchSetup.GET();
    //        CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //             lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //               IF FieldNumber = 1 THEN
    //                  // Diese Dimension kann nicht vorbelegt werden !
    //                  ERROR(SSPText01);
    //             lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //               IF FieldNumber = 2 THEN
    //                  // Diese Dimension kann nicht vorbelegt werden !
    //                  ERROR(SSPText01);
    //             lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //               IF FieldNumber = 3 THEN
    //                  // Diese Dimension kann nicht vorbelegt werden !
    //                  ERROR(SSPText01);
    //             lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //               IF FieldNumber = 4 THEN
    //                  // Diese Dimension kann nicht vorbelegt werden !
    //                  ERROR(SSPText01);
    //           END;
    //     END;

    //     lcu_DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
    //     MODIFY();
    // end;
}

