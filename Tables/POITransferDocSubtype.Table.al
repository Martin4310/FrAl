table 5110412 "POI Transfer Doc. Subtype"
{

    Caption = 'Transfer Doc. Subtype';
    // DrillDownFormID = Form5110410;
    // LookupFormID = Form5110410;

    fields
    {
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(17; "In Selection List"; Boolean)
        {
            Caption = 'In Selection List';
        }
        field(18; "In Selection"; Boolean)
        {
            Caption = 'In Selection';
        }
        field(20; "From Location Code"; Code[10])
        {
            Caption = 'From Location Code';
            TableRelation = Location;
        }
        field(21; "To Location Code"; Code[10])
        {
            Caption = 'To Location Code';
            TableRelation = Location;
        }
        field(22; "Transit Location Code"; Code[10])
        {
            Caption = 'Transit Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(true));
        }
        field(24; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(25; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(27; "From Loc. QC Vendor No."; Code[20])
        {
            Caption = 'From Loc. QC Vendor No.';
            //TableRelation = Vendor WHERE ("POI Is Quality Controller"=CONST(true));
        }
        field(28; "To Loc. QC Vendor No."; Code[20])
        {
            Caption = 'To Loc. QC Vendor No.';
            //TableRelation = Vendor WHERE (Is Quality Controller=CONST(Yes));
        }
        field(50; "Page ID Transfer Order Card"; Integer)
        {
            Caption = 'Page ID Transfer Order Card';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(52; "Page ID Empties Card"; Integer)
        {
            Caption = 'Page ID Empties Card';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(55; "Scroll in Card"; Boolean)
        {
            Caption = 'Scroll in Card';
        }
        field(70; "Pallet Movement Lines"; Option)
        {
            Caption = 'Pallet Movement Lines';
            OptionCaption = 'No Pallet Movement,Pallet Movement';
            OptionMembers = "No Pallet Movement","Pallet Movement";
        }
        field(77; "Open Print Window on Close"; Boolean)
        {
            Caption = 'Open Print Window on Close';
        }
        field(80; "Only Items from Assortment"; Code[10])
        {
            Caption = 'Only Items from Assortment';
            //TableRelation = "POI Assortment"; //TODO: assortment
        }
        field(81; "Delete only when no Lines"; Boolean)
        {
            Caption = 'Delete only when no Lines';
        }
        field(82; "Transfer Order Editable"; Option)
        {
            Caption = 'Not Manual Editable';
            OptionCaption = ' ,Not editable';
            OptionMembers = " ","Not editable";
        }
        field(89; "Transfer Freight Cost"; Option)
        {
            Caption = 'Transfer Freight Cost';
            OptionCaption = ' ,Pflicht,Pflicht und Buchen';
            OptionMembers = " ",Pflicht,"Pflicht und Buchen";
        }
        field(90; "Enter Freight Costs"; Option)
        {
            Caption = 'Enter Freight Costs';
            OptionCaption = ' ,Pflichteingabe';
            OptionMembers = " ",Pflichteingabe;
        }
        field(91; "Posting Freight Costs"; Boolean)
        {
            Caption = 'Posting Freight Costs';
        }
        field(300; "Info 1 Visible"; Boolean)
        {
            Caption = 'Info 1 Visible';
            Description = 'BSI';
        }
        field(301; "Info 2 Visible"; Boolean)
        {
            Caption = 'Info 2 Visible';
            Description = 'BSI';
        }
        field(302; "Info 3 Visible"; Boolean)
        {
            Caption = 'Info 3 Visible';
            Description = 'BSI';
        }
        field(303; "Info 4 Visible"; Boolean)
        {
            Caption = 'Info 4 Visible';
            Description = 'BSI';
        }
        field(500; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
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
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
                MODIFY();
            end;
        }
        field(503; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,1,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
                MODIFY();
            end;
        }
        field(510; "Shipping Time"; DateFormula)
        {
            Caption = 'Transfer Time';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        //lcu_DimMgt: Codeunit "408";
        lrc_BatchSetup: Record "POI Master Batch Setup";
        SSPText01Txt: Label 'This dimension could not be defined !';
    begin
        IF ShortcutDimCode <> '' THEN BEGIN
            lrc_BatchSetup.GET();
            CASE lrc_BatchSetup."Dim. No. Batch No." OF
                lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
                    IF FieldNumber = 1 THEN
                        // Diese Dimension kann nicht vorbelegt werden !
                        ERROR(SSPText01Txt);
                lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
                    IF FieldNumber = 2 THEN
                        // Diese Dimension kann nicht vorbelegt werden !
                        ERROR(SSPText01Txt);
                lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
                    IF FieldNumber = 3 THEN
                        // Diese Dimension kann nicht vorbelegt werden !
                        ERROR(SSPText01Txt);
                lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
                    IF FieldNumber = 4 THEN
                        // Diese Dimension kann nicht vorbelegt werden !
                        ERROR(SSPText01Txt);
            END;
        END;

        //lcu_DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode); //TODO: dim Management
        MODIFY();
    end;
}

