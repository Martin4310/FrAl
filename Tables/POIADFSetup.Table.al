table 50100 "POI ADF Setup"
{
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Internal Customer Code"; Code[20])
        {
            Caption = 'Internal Customer Code';
            DataClassification = CustomerContent;
        }
        field(11; "String Length Product Group"; Integer)
        {
            Caption = 'String Length Product Group';
        }
        field(12; "String Character Product Group"; Option)
        {
            Caption = 'String Character Product Group';
            OptionCaption = 'Numeric,Alphanumeric,Alpha';
            OptionMembers = Numeric,Alphanumeric,Alpha;
        }
        field(14; "Item No. 2 Activ"; Boolean)
        {
            Caption = 'Item No. 2 Activ';
            DataClassification = CustomerContent;
        }
        field(16; "Item No. 2 Length"; Integer)
        {
            Caption = 'Item No. 2 Length';
        }
        field(305; "Lookup Calendar Date Fields"; Option)
        {
            Caption = 'Lookup Calendar Date Fields';
            OptionCaption = ' ,Calendar I,Calendar II';
            OptionMembers = " ","Calendar I","Calendar II";
        }
        field(392; "Dim. No. Batch No."; Option)
        {
            Caption = 'Dim. No. Batch No.';
            Editable = false;
            OptionCaption = ' ,1. Dimension,2. Dimension,3. Dimension,4. Dimension,5. Dimension,6. Dimension,7. Dimension,8. Dimension';
            OptionMembers = " ","1. Dimension","2. Dimension","3. Dimension","4. Dimension","5. Dimension","6. Dimension","7. Dimension","8. Dimension";
        }
        field(401; "Dim. Code Cost Category"; Code[20])
        {
            Caption = 'Dim. Code Cosr Category';
            DataClassification = CustomerContent;
        }
        field(402; "Dim. No. Cost Category"; Option)
        {
            Caption = 'Dim. No. Cost Category';
            DataClassification = CustomerContent;
            OptionMembers = ,"1.Dimension","2.Dimension","3.Dimension","4.Dimension","5.Dimension","6.Dimension","7.Dimension","8.Dimension";
            OptionCaption = ',1.Dimension,2.Dimension,3.Dimension,4.Dimension,5.Dimension,6.Dimension,7.Dimension,8.Dimension';
        }
        field(405; "Cost Category Calc. Type"; Option)
        {
            Caption = 'Cost Category Calc. Type';
            OptionCaption = 'Standard,Rekursiv von Zeile';
            OptionMembers = Standard,"Rekursiv von Zeile";
        }
        field(451; "Plan Cost No. Series"; Code[10])
        {
            Caption = 'Plan Cost No. Series';
            TableRelation = "No. Series";
        }
        field(1015; "Item Insert Template"; Option)
        {
            Caption = 'Item Insert Template';
            OptionCaption = ' ,Schablone 1,Schablone 2,Schablone 3,Schablone 4,Schablone 5,Schablone 6,Schablone 7,Schablone 8,Schablone 9,Schablone 10,Schablone 11,Schablone 12,Schablone 13,Schablone 14,Schablone 15,Schablone 16,Schablone 17';
            OptionMembers = " ","Schablone 1","Schablone 2","Schablone 3","Schablone 4","Schablone 5","Schablone 6","Schablone 7","Schablone 8","Schablone 9","Schablone 10","Schablone 11","Schablone 12","Schablone 13","Schablone 14","Schablone 15","Schablone 16","Schablone 17";
        }
        field(1020; "Item Search Desc. Template"; Option)
        {
            Caption = 'Item Search Desc. Template';
            OptionCaption = ' ,Schablone 1,Schablone 2,Schablone 3,Schablone 4,Schablone 5,Schablone 6,Schablone 7,Schablone 8,Schablone 9,Schablone 10,Schablone 11,Schablone 12,Schablone 13,Schablone 14,Schablone 15,Schablone 16,Schablone 17,,,,,,,,,,,,,,,,,,agiles dynamics food';
            OptionMembers = " ","Schablone 1","Schablone 2","Schablone 3","Schablone 4","Schablone 5","Schablone 6","Schablone 7","Schablone 8","Schablone 9","Schablone 10","Schablone 11","Schablone 12","Schablone 13","Schablone 14","Schablone 15","Schablone 16","Schablone 17",,,,,,,,,,,,,,,,,,"agiles dynamics food";
        }
        field(1022; "Feature Level"; Option)
        {
            Caption = 'Feature Level';
            DataClassification = CustomerContent;
            OptionMembers = Item,"Batch Variant";
            OptionCaption = 'Item,Batch Variant';
        }
        field(1025; "Item Hierarchy"; Option)
        {
            Caption = 'Item Hierarchy';
            OptionCaption = 'Depending,Not Depending';
            OptionMembers = Depending,"Not Depending";
        }
        field(1026; "Item Hierarchy Def. Level"; Option)
        {
            Caption = 'Item Hierarchy Def. Level';
            OptionCaption = ' ,Item main Category,Item Category,Product Group';
            OptionMembers = " ","Item main Category","Item Category","Product Group";
        }
        field(1030; "Item - Validate Unit"; Option)
        {
            Caption = 'Item - Validate Unit';
            OptionCaption = 'Item Unit of Measure,Product Group,Unit of Measure';
            OptionMembers = "Item Unit of Measure","Product Group","Unit of Measure";
        }
        field(1031; "Item - Validate Caliber"; Option)
        {
            Caption = 'Item - Validate Caliber';
            OptionCaption = ' ,Product Group';
            OptionMembers = " ","Product Group";
        }
        field(1032; "Item - Validate Variety"; Option)
        {
            Caption = 'Item - Validate Variety';
            OptionCaption = ' ,Product Group';
            OptionMembers = " ","Product Group";
        }
        field(1033; "Item - Validate Country"; Option)
        {
            Caption = 'Item - Validate Country';
            OptionCaption = ' ,Product Group';
            OptionMembers = " ","Product Group";
        }
        field(1034; "Item - Validate Trademark"; Option)
        {
            Caption = 'Item - Validate Trademark';
            OptionCaption = ' ,Product Group';
            OptionMembers = " ","Product Group";
        }
        field(1042; "Item Search List Page ID"; Integer)
        {
            Caption = 'Item Search List Form ID';
            DataClassification = CustomerContent;
        }
        field(1050; "Vendor - Validate Producer"; Option)
        {
            Caption = 'Vendor - Validate Producer';
            OptionCaption = 'All Producer,Vendor - Producer';
            OptionMembers = "All Producer","Vendor - Producer";
        }
        field(1901; "Prod. Stat. Cost Schema Name"; Code[10])
        {
            Caption = 'Prod. Stat. Cost Schema Name';
            TableRelation = "POI Cost Schema Name";
        }
        field(2101; "Empties Location Code"; Code[10])
        {
            Caption = 'Empties Location Code';
            TableRelation = Location;
        }
        field(2102; "Empties/Transport Type"; Option)
        {
            Caption = 'Empties/Transport Type';
            OptionCaption = 'Systematik 1,Systematik 2';
            OptionMembers = "Systematik 1","Systematik 2";
        }
        field(2130; "POI PurchInv Empties Doc. Typ"; Code[10])
        {
            Caption = 'Purchase Invoice Empties Doc. Typ Code';
            TableRelation = "POI Purch. Doc. Subtype".Code WHERE("Document Type" = CONST(Invoice));
        }
        field(2131; "POI PurchCrM Empties Doc. Typ"; Code[10])
        {
            Caption = 'Purchase Credit Memo Empties Doc. Typ Code';
            TableRelation = "POI Purch. Doc. Subtype".Code WHERE("Document Type" = CONST("Credit Memo"));
        }
        field(2249; "Vendor Search List Page ID"; Integer)
        {
            Caption = 'Vendor Search List Page ID';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(2252; "POI Purch. Find Bus. Post. Grp"; Boolean)
        {
            Caption = 'Purch. Find Bus. Posting Group';
        }
        field(2270; "Purch. Inv. Load Cost Category"; Option)
        {
            Caption = 'Purch. Inv. Load Cost Category';
            OptionCaption = ' ,G/L Account - Show Cost Cat.,Cost Cat. - Show G/L Account,Both,Cost Cat - Show allways G/L Accounts';
            OptionMembers = " ","G/L Account - Show Cost Cat.","Cost Cat. - Show G/L Account",Both,"Cost Cat - Show allways G/L Accounts";
        }
        field(2324; "Market Unit Price activ"; Boolean)
        {
            Caption = 'Market Unit Price activ';
            Description = 'MEK';
        }
        field(2325; "Calc Market Unit Price"; Option)
        {
            Caption = 'Calc Market Unit Price';
            Description = 'MEK';
            OptionCaption = 'Immer bei Preisänderung,Nur wenn Markteinkaufspreis Null';
            OptionMembers = "Immer bei Preisänderung","Nur wenn Markteinkaufspreis Null";
        }
        field(2330; "Purch. Validate Unit"; Option)
        {
            Caption = 'Purch. Validate Unit';
            OptionCaption = 'Item Unit of Measure,Product Group,Unit of Measure';
            OptionMembers = "Item Unit of Measure","Product Group","Unit of Measure";
        }
        field(2360; "POI Trans Changes Purch./Sales"; Option)
        {
            Caption = 'Transfer changes from purchase to sales line';
            OptionCaption = 'No Transfer,Transfer Always,Transfer with Confirm';
            OptionMembers = "No Transfer","Transfer Always","Transfer with Confirm";
        }
        field(2391; "Vend. Discount not Activ"; Boolean)
        {
            Caption = 'Vend. Discount not Activ';
        }
        field(2393; "Purch. Price Diff. Account"; Code[20])
        {
            Caption = 'Purch. Price Diff. Account';
            TableRelation = "G/L Account";
        }
        field(2406; "Create Search No from BatchVar"; Boolean)
        {
            Caption = 'Create Search No from BatchVar';
        }
        field(2410; "No. Series Certificate Entries"; Integer)
        {
            Caption = 'No. Series Certificate Entries';
            DataClassification = CustomerContent;
        }
        field(2455; "No. Series Planing"; Code[10])
        {
            Caption = 'No. Series Planing';
            TableRelation = "No. Series";
        }
        field(2549; "Customer Search Page ID"; Integer)
        {
            Caption = 'Customer Search Page ID';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(2688; "Message Selling Exp. Stock"; Boolean)
        {
            Caption = 'Message Selling Exp. Stock';
        }
        field(2710; "Sales Beep if Item not found"; Boolean)
        {
            Caption = 'Sales Beep if Item not found';
            DataClassification = CustomerContent;
        }
        field(2730; "Sales Disc. Line G.B. Grp."; Option)
        {
            Caption = 'Sales Disc. Line G.B. Grp.';
            OptionCaption = 'Equal to Source Line,Editable,Editable with Confirm';
            OptionMembers = "Equal to Source Line",Editable,"Editable with Confirm";
        }
        field(3001; "No. Series Tour Order"; Code[10])
        {
            Caption = 'No. Series Tour Order';
            TableRelation = "No. Series";
        }
        field(3301; "No. Series Assortment Version"; Code[10])
        {
            Caption = 'No. Series Assortment Version';
            TableRelation = "No. Series";
        }
        field(3401; "No. Series Reservation"; Code[10])
        {
            Caption = 'No. Series Reservation';
            TableRelation = "No. Series";
        }
        field(8050; "No. Series Voyage"; Code[10])
        {
            Caption = 'No. Series Voyage';
            TableRelation = "No. Series";
        }
        field(8500; "Type of Pallet Systematic"; Option)
        {
            Caption = 'Art der Palettensystematik';
            OptionCaption = 'Systematik 1,Systematik 2';
            OptionMembers = "Systematik 1","Systematik 2";
        }
        field(8504; "Pallet No. No. Serie"; Code[10])
        {
            Caption = 'Pallet No. No. Serie';
            Description = 'PAL';
            TableRelation = "No. Series";
        }
        field(8505; "Default Pallet Unit Code"; Code[10])
        {
            Caption = 'Default Pallet Unit Code';
            Description = 'PAL';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));
        }
        field(8506; "Default Pallet Freight Unit"; Code[10])
        {
            Caption = 'Default Pallet Freight Unit';
            Description = 'PAL';
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));
        }
        field(8507; "Only Incoming Pallets"; Boolean)
        {
            Caption = 'Only Incoming Pallets';
            Description = 'PAL';
        }
        field(20005; "Sales Claim CrM. only Value"; Option)
        {
            Caption = 'Sales Claim CrM. only Value';
            OptionCaption = 'Item Charge,Qty In and Out';
            OptionMembers = "Item Charge","Qty In and Out";
        }
        field(20008; "Sales Claim Check Dupplex"; Option)
        {
            Caption = 'Sales Claim Check Dupplex';
            OptionCaption = ' ,One per Shipment Line';
            OptionMembers = " ","One per Shipment Line";
        }
        field(5110310; "FREI 5110310"; Option)
        {
            Caption = 'Info 1 Refers To';
            Description = 'BSI';
            InitValue = "Batch No.";
            OptionCaption = 'Batch No.,Batch Variant No.';
            OptionMembers = "Batch No.","Batch Variant No.";
        }
        field(5110311; "FREI 5110311"; Option)
        {
            Caption = 'Info 2 Refers To';
            Description = 'BSI';
            InitValue = "Batch Variant No.";
            OptionCaption = 'Batch No.,Batch Variant No.';
            OptionMembers = "Batch No.","Batch Variant No.";
        }
        field(5110312; "FREI 5110312"; Option)
        {
            Caption = 'Info 3 Refers To';
            Description = 'BSI';
            InitValue = "Batch Variant No.";
            OptionCaption = 'Batch No.,Batch Variant No.';
            OptionMembers = "Batch No.","Batch Variant No.";
        }
        field(5110313; "FREI 5110313"; Option)
        {
            Caption = 'Info 4 Refers To';
            Description = 'BSI';
            InitValue = "Batch Variant No.";
            OptionCaption = 'Batch No.,Batch Variant No.';
            OptionMembers = "Batch No.","Batch Variant No.";
        }
        field(5110670; "Purch. Claim No. Series"; Code[10])
        {
            Caption = 'Purch. Claim No. Series';
            Description = 'EKR';
            TableRelation = "No. Series";
        }
        field(5110671; "Sales Claim No. Series"; Code[10])
        {
            Caption = 'Sales Claim No. Series';
            Description = 'VKR';
            TableRelation = "No. Series";
        }


    }

    keys
    {
        key(PK; "Primary Key")
        {
        }
    }

}