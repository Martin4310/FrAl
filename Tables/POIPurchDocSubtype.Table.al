table 50009 "POI Purch. Doc. Subtype"
{
    Caption = 'Purch. Doc. Subtype';
    //DrillDownPageId = Form5110400;
    //LookupPageId= Form5110400;

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
        field(12; "Batchsystem activ"; Boolean)
        {
            Caption = 'Batchsystem activ';
            DataClassification = CustomerContent;
        }
        field(13; "Source Master Batch"; Option)
        {
            Caption = 'Source Master Batch';
            DataClassification = CustomerContent;
            Description = ' ,No. Series,,,Purchase Order No.,,,Manuel,,,Vendor';
            OptionCaption = ' ,No. Series,,,Purchase Order No.,,,Manuel,,,Vendor';
            OptionMembers = " ","No. Series",,,"Purchase Order No.",,,Manuel,,,Vendor;
        }
        field(14; "Master Batch No. Series"; Code[10])
        {
            Caption = 'Master Batch No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(15; "Allocation BatchNo. by Doc.Typ"; Boolean)
        {
            Caption = 'Allocation BatchNo. by Doc.Typ';
            DataClassification = CustomerContent;
        }
        field(16; "Default Subtype"; Boolean)
        {
            Caption = 'Default Subtype';
            DataClassification = CustomerContent;
        }
        field(17; "Direct Delivery (Agency)"; Boolean)
        {
            Caption = 'Direct Delivery (Agency)';
            DataClassification = CustomerContent;
        }
        field(18; "In Selection"; Boolean)
        {
            Caption = 'In Selection';
            DataClassification = CustomerContent;
        }
        field(19; "-"; Integer)
        {
            Caption = '-';
            DataClassification = CustomerContent;
            Enabled = false;
        }
        field(20; "Allocation Batch No."; Option)
        {
            Caption = 'Allocation Batch No.';
            DataClassification = CustomerContent;
            Description = ' ,One Batch No per Order,Multiple Batch Nos per Order,New Batch No. per Line';
            OptionCaption = ' ,One Batch No per Order,Multiple Batch Nos per Order,New Batch No. per Line';
            OptionMembers = " ","One Batch No per Order","Multiple Batch Nos per Order","New Batch No. per Line";
        }
        field(21; "Source Batch No."; Option)
        {
            Caption = 'Source Batch No.';
            DataClassification = CustomerContent;
            Description = ' ,No. Series,,,Purchase Order No.,Master Batch No.,,Manuel,,,Vendor,,Master Batch No. + Postfix';
            OptionCaption = ' ,No. Series,,,Purchase Order No.,Master Batch No.,,Manuel,,,Vendor,,Master Batch No. + Postfix';
            OptionMembers = " ","No. Series",,,"Purchase Order No.","Master Batch No.",,Manuel,,,Vendor,,"Master Batch No. + Postfix";
        }
        field(22; "Batch Series No."; Code[10])
        {
            Caption = 'Batch Series No.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(24; "Allocate Batch No. per Batch"; Boolean)
        {
            Caption = 'Allocate Batch No. per Batch';
            DataClassification = CustomerContent;
        }
        field(25; "--"; Integer)
        {
            Caption = '--';
            DataClassification = CustomerContent;
            Enabled = false;
        }
        field(26; "Source Batch Variant"; Option)
        {
            Caption = 'Source Batch Variant';
            DataClassification = CustomerContent;
            Description = ' ,No. Series,,,Batch No. + Postfix,,Batch No.';
            OptionCaption = ' ,No. Series,,,Batch No. + Postfix,,Batch No.';
            OptionMembers = " ","No. Series",,,"Batch No. + Postfix",,"Batch No.";
        }
        field(27; "Batch Variant No. Series"; Code[10])
        {
            Caption = 'Batch Variant No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(35; "---"; Integer)
        {
            Caption = '---';
            DataClassification = CustomerContent;
            Enabled = false;
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
        }
        field(49; "----"; Integer)
        {
            Caption = '----';
            DataClassification = CustomerContent;
            Enabled = false;
        }
        field(50; "Form ID List"; Integer)
        {
            Caption = 'Form ID List';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(51; "Page ID Card"; Integer)
        {
            Caption = 'Form ID Card';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(52; "Form ID Line Card"; Integer)
        {
            Caption = 'Form ID Line Card';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(53; "Form ID Card in Whse."; Integer)
        {
            Caption = 'Form ID Card in Whse.';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(54; "Form ID Empties Card"; Integer)
        {
            Caption = 'Form ID Empties Card';
            DataClassification = CustomerContent;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(55; "Allow scrolling in Card"; Boolean)
        {
            Caption = 'Allow scrolling in Card';
            DataClassification = CustomerContent;
        }
        field(60; "Restrict Locations"; Option)
        {
            Caption = 'Restrict Locations';
            DataClassification = CustomerContent;
            Description = ' ,Vorgabe,Feste Eingrenzung,Belegkopf';
            OptionCaption = ' ,Vorgabe,Feste Eingrenzung,Belegkopf';
            OptionMembers = " ",Vorgabe,"Feste Eingrenzung",Belegkopf;
        }
        field(61; "Default Location Code"; Code[10])
        {
            Caption = 'Default Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(62; "Default Vendor"; Code[10])
        {
            Caption = 'Default Vendor';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(63; "Restriction Vendors"; Boolean)
        {
            Caption = 'Restriction Vendors';
            DataClassification = CustomerContent;
        }
        field(64; "Default Purchaser Code"; Code[10])
        {
            Caption = 'Default Purchaser Code';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
        }
        field(65; "Default Means of Transp. Type"; Option)
        {
            Caption = 'Default Means of Transp. Type';
            DataClassification = CustomerContent;
            Description = ' ,Truck,Train,Ship,Airplane';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;
        }
        field(67; "Restriction Items"; Option)
        {
            Caption = 'Restriction Items';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Only Items Activ in Sales,Only Items Activ in Purchase,,Only Items Activ in Purchase and Sales';
            OptionMembers = " ","Only Items Activ in Sales","Only Items Activ in Purchase",,"Only Items Activ in Purchase and Sales";
        }
        field(69; "Default Value for Weighting"; Option)
        {
            Caption = 'Default Value for Weighting';
            DataClassification = CustomerContent;
            OptionCaption = 'Weight from Unit of Measure,No Weight';
            OptionMembers = "Weight from Unit of Measure","No Weight";
        }
        field(70; "Quality Control Vendor No."; Code[20])
        {
            Caption = 'Quality Control Vendor No.';
            DataClassification = CustomerContent;
            //TableRelation = Vendor WHERE("Is Quality Controller" = CONST(Yes));
        }
        field(72; "Clearing by Ship. Agent Code"; Code[20])
        {
            Caption = 'Clearing by Ship. Agent Code';
            DataClassification = CustomerContent;
            //TableRelation = "Shipping Agent" WHERE("Is Custom Clearing Agent" = CONST(Yes));
        }
        field(74; "Set Status to Open"; Boolean)
        {
            Caption = 'Set Status to Open';
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
        field(79; "Invoice of Purch. Order"; Option)
        {
            Caption = 'Invoice of Purch. Order';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Release has to be set,No open Claim,,,Release and no open Claim';
            OptionMembers = " ","Release has to be set","No open Claim",,,"Release and no open Claim";
        }
        field(80; "Pallet Movement Lines"; Option)
        {
            Caption = 'Pallet Movement Lines';
            DataClassification = CustomerContent;
            OptionCaption = 'No Pallet Movement,Pallet Movement';
            OptionMembers = "No Pallet Movement","Pallet Movement";
        }
        field(81; "Delete only when no Lines"; Boolean)
        {
            Caption = 'Delete only when no Lines';
            DataClassification = CustomerContent;
        }
        field(82; "No Check if Admitted Vendor"; Boolean)
        {
            Caption = 'No Check if Admitted Vendor';
            DataClassification = CustomerContent;
        }
        field(83; "Create R.Order from P.Receipt"; Boolean)
        {
            Caption = 'Create R.Order from P.Receipt';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TESTFIELD("Document Type", "Document Type"::Order);
            end;
        }
        field(85; "Cr. Memo Doc. Subtype Code"; Code[10])
        {
            Caption = 'Cr. Memo Doc. Subtype Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("Document Type" = FILTER(Order | Invoice)) "POI Purch. Doc. Subtype".Code WHERE("Document Type" = CONST("Credit Memo"));
        }
        field(86; "Invoice Doc. Subtype Code"; Code[10])
        {
            Caption = 'Invoice Doc. Subtype Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("Document Type" = CONST("Credit Memo")) "POI Purch. Doc. Subtype".Code WHERE("Document Type" = CONST(Invoice));
        }
        field(87; "Return Order Doc. Subtype Code"; Code[10])
        {
            Caption = 'Return Order Doc. Subtype Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Purch. Doc. Subtype".Code WHERE("Document Type" = CONST("Return Order"));
        }
        field(88; "Default Last Unit Price"; Boolean)
        {
            Caption = 'Default Last Unit Price';
            DataClassification = CustomerContent;
        }
        field(90; "Show in List till Doc. Status"; Option)
        {
            Caption = 'Show in List till Doc. Status';
            DataClassification = CustomerContent;
            OptionCaption = 'Offen,Avis Export to Whse.,,Freigabe Wareneingang,,,Eingangskommissionierung,,,Lieferschein,,,Rückerfassung,,,Freigabe Fakturierung,,,,Abgeschlossen,,,Manuell Abgeschlossen,,,Storniert,,,Gelöscht';
            OptionMembers = Offen,"Avis Export to Whse.",,"Freigabe Wareneingang",,,Eingangskommissionierung,,,Lieferschein,,,"Rückerfassung",,,"Freigabe Fakturierung",,,,Abgeschlossen,,,"Manuell Abgeschlossen",,,Storniert,,,"Gelöscht";
        }
        field(91; "Is IC Doc. Subtype"; Boolean)
        {
            Caption = 'Is IC Doc. Subtype';
            DataClassification = CustomerContent;
        }
        field(92; "IC Document Type"; Option)
        {
            Caption = 'IC Document Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(93; "IC Doc. Subtype Code"; Code[10])
        {
            Caption = 'IC Belegunterarten Code';
            DataClassification = CustomerContent;
        }
        field(99; "-----"; Integer)
        {
            Caption = '-----';
            DataClassification = CustomerContent;
            Enabled = false;
        }
        field(100; "Doc. Subtype Detail"; Option)
        {
            Caption = 'Doc. Subtype Detail';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Invoice of Expences,Credit Memo of Expences';
            OptionMembers = " ","Invoice of Expences","Credit Memo of Expences";
        }
        field(134; "Posting Date Receive"; Option)
        {
            Caption = 'Posting Date Receive';
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
        field(140; "Ship. Date Inv. is Blocked"; Option)
        {
            Caption = 'Ship. Date Inv. is Blocked';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Next possible Date,Ignore Blocking';
            OptionMembers = " ","Next possible Date","Ignore Blocking";
        }
        field(199; "-- INFO FIELDS --"; Integer)
        {
            Caption = '-- INFO FIELDS --';
            DataClassification = CustomerContent;
            Enabled = false;
        }
        field(200; "Info 1 Visible"; Boolean)
        {
            Caption = 'Info 1 Visible';
            DataClassification = CustomerContent;
            Description = 'BSI';
        }
        field(201; "Info 2 Visible"; Boolean)
        {
            Caption = 'Info 2 Visible';
            DataClassification = CustomerContent;
            Description = 'BSI';
        }
        field(202; "Info 3 Visible"; Boolean)
        {
            Caption = 'Info 3 Visible';
            DataClassification = CustomerContent;
            Description = 'BSI';
        }
        field(203; "Info 4 Visible"; Boolean)
        {
            Caption = 'Info 4 Visible';
            DataClassification = CustomerContent;
            Description = 'BSI';
        }
        field(252; "Calendar Week"; DateFormula)
        {
            Caption = 'Calendar Week';
            DataClassification = CustomerContent;
        }
        field(398; "-- NO. SERIES --"; Integer)
        {
            Caption = '-- NO. SERIES --';
            DataClassification = CustomerContent;
            Enabled = false;
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
        field(402; "Posted Receipt Nos."; Code[10])
        {
            Caption = 'Posted Receipt Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(403; "Posted Return Shpt. Nos."; Code[10])
        {
            Caption = 'Posted Return Shpt. Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(500; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
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
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
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
                // GDM 001 FV400008.s
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
                MODIFY();
                // GDM 001 FV400008.e
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
                // GDM 001 FV400008.s
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
                MODIFY();
                // GDM 001 FV400008.e
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

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    // var
    //     lcu_DimMgt: Codeunit DimensionManagement;
    //     lrc_BatchSetup: Record "5110363";
    //     SSPText01: Label 'This dimension could not be defined !';
    begin
        //     IF ShortcutDimCode <> '' THEN BEGIN
        //         lrc_BatchSetup.GET();
        //         CASE lrc_BatchSetup."Dim. No. Batch No." OF
        //             lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
        //                 IF FieldNumber = 1 THEN
        //                     // Diese Dimension kann nicht vorbelegt werden !
        //                     ERROR(SSPText01);
        //             lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
        //                 IF FieldNumber = 2 THEN
        //                     // Diese Dimension kann nicht vorbelegt werden !
        //                     ERROR(SSPText01);
        //             lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
        //                 IF FieldNumber = 3 THEN
        //                     // Diese Dimension kann nicht vorbelegt werden !
        //                     ERROR(SSPText01);
        //             lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
        //                 IF FieldNumber = 4 THEN
        //                     // Diese Dimension kann nicht vorbelegt werden !
        //                     ERROR(SSPText01);
        //         END;
        //     END;

        // lcu_DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        // MODIFY();
    end;
}

