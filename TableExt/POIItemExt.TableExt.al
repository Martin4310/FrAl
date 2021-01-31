tableextension 50000 "POI Item Ext" extends Item
{
    fields
    {
        field(50000; "POI Searchcode"; Text[100])
        {
            Caption = 'SearchcodePOI';
            DataClassification = CustomerContent;
        }
        field(50002; "POI GGN Tracking"; Boolean)
        {
            Caption = 'GGN Verfolgung';
            DataClassification = CustomerContent;
        }
        field(5110321; "POI Batch Item"; Boolean)
        {
            Caption = 'Batch Item';
            DataClassification = CustomerContent;
        }
        field(50003; "POI Product Group Code"; Code[20])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lcu_BDMBaseDataMgt: Codeunit "POI BDM Base Data Mgmt";
            begin
                lcu_BDMBaseDataMgt.ProductGrpValidateSearch("POI Product Group Code", (CurrFieldNo = FIELDNO("POI Product Group Code")));
                ADF_ItemStructureValidate(FIELDNO("POI Product Group Code"));
            end;
        }
        field(50004; "POI Bill of Materials"; Boolean)
        {
            CalcFormula = Exist ("BOM Component" WHERE("Parent Item No." = FIELD("No.")));
            Caption = 'Bill of Materials';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "POI Trademarks"; Text[100])
        {
            Caption = 'Marken';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                ItemAttribute.SetRange("Item No.", "No.");
                ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::Trademark);
                ItemAttributePage.setItemNo("No.");
                ItemAttributePage.SetTableView(ItemAttribute);
                ItemAttributePage.Run();
            end;
        }
        field(50006; "POI Tariff Description"; Text[100])
        {
            Caption = 'Zolltarifnr. Beschreibung';
            FieldClass = FlowField;
            CalcFormula = lookup ("Tariff Number".Description where("No." = field("Tariff No.")));
        }
        field(50007; "POI Country of Origin"; Code[50])
        {
            Caption = 'Herkunftsland';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                ItemCountry.SetRange("Item No.", "No.");
                page.RunModal(Page::"POI Item Country", ItemCountry);
            end;
        }
        field(50008; "POI Wizzard Status"; Code[20])
        {
            Caption = 'Status Assistent';
            DataClassification = CustomerContent;
            TableRelation = "POI Wizzard Status".Status where(Type = const(Item));
            //Editable = false;
        }
        field(50009; "POI Base Item Code"; code[20])
        {
            Caption = 'Basisartikel-Nr.';
            DataClassification = CustomerContent;
            TableRelation = Item."No.";
        }
        field(50010; "POI Is Base Item"; Boolean)
        {
            Caption = 'Is Base Item';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "POI Is Base Item" then
                    "POI Base Item Code" := "No."
                else
                    "POI Base Item Code" := '';
            end;
        }
        field(50011; "POI Color Codes"; Text[100])
        {
            Caption = 'Color Codes';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                ItemAttribute.SetRange("Item No.", "No.");
                ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::Color);
                ItemAttributePage.setItemNo("No.");
                ItemAttributePage.SetTableView(ItemAttribute);
                ItemAttributePage.Run();
            end;
        }
        field(50012; "POI Caliber Codes"; Text[100])
        {
            Caption = 'Caliber Codes';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                ItemAttribute.SetRange("Item No.", "No.");
                ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::Caliber);
                ItemAttributePage.setItemNo("No.");
                ItemAttributePage.SetTableView(ItemAttribute);
                ItemAttributePage.Run();
            end;
        }
        field(50013; "POI Quality Codes"; Text[100])
        {
            Caption = 'Quality Codes';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                ItemAttribute.SetRange("Item No.", "No.");
                ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::"Grade of Goods");
                ItemAttributePage.setItemNo("No.");
                ItemAttributePage.SetTableView(ItemAttribute);
                ItemAttributePage.Run();
            end;
        }
        field(50014; "POI Grade of Goods Codes"; Text[100])
        {
            Caption = 'Quality Codes';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                ItemAttribute.SetRange("Item No.", "No.");
                ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::"Grade of Goods");
                ItemAttributePage.setItemNo("No.");
                ItemAttributePage.SetTableView(ItemAttribute);
                ItemAttributePage.Run();
            end;
        }
        field(50015; "POI Variety Codes"; Text[100])
        {
            Caption = 'Variety Codes';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                ItemAttribute.SetRange("Item No.", "No.");
                ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::Variety);
                ItemAttributePage.setItemNo("No.");
                ItemAttributePage.SetTableView(ItemAttribute);
                ItemAttributePage.Run();
            end;
        }
        field(50016; "POI Coding Codes"; Text[100])
        {
            Caption = 'Coding Codes';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                ItemAttribute.SetRange("Item No.", "No.");
                ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::Coding);
                ItemAttributePage.setItemNo("No.");
                ItemAttributePage.SetTableView(ItemAttribute);
                ItemAttributePage.Run();
            end;
        }
        field(50017; "POI Cultivation Types"; Text[100])
        {
            Caption = 'Coding Codes';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                ItemAttribute.SetRange("Item No.", "No.");
                ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::Cultivation);
                ItemAttributePage.setItemNo("No.");
                ItemAttributePage.SetTableView(ItemAttribute);
                ItemAttributePage.Run();
            end;
        }
        field(50018; "POI PLU-Codes"; Text[100])
        {
            Caption = 'PLU-Codes';
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                ItemAttribute.SetRange("Item No.", "No.");
                ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::"PLU-Code");
                ItemAttributePage.setItemNo("No.");
                ItemAttributePage.SetTableView(ItemAttribute);
                ItemAttributePage.Run();
            end;
        }
        field(50391; "POI Price Base (Sales Price)"; Code[10])
        {
            Caption = 'Price Base (Sales Price)';
            DataClassification = CustomerContent;
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Sales Price"),
                                                     Blocked = CONST(false));
        }
        field(50435; "POI Transform. Item No In-/Out"; Code[20])
        {
            Caption = 'Transformation Item No In-/Out';
            DataClassification = CustomerContent;
            TableRelation = Item."No.";
        }
        field(5110313; "POI Last User ID Modified"; Code[20])
        {
            Caption = 'Last User ID Modified';
            Editable = false;
        }
        field(5110314; "POI Activ in Purchase"; Boolean)
        {
            Caption = 'Activ in Purchase';
        }
        field(5110315; "POI Activ in Sales"; Boolean)
        {
            Caption = 'Activ in Sales';

            trigger OnValidate()
            begin
                //ADF_ActivInSalesValidate();
            end;
        }
        field(5110320; "POI Item Typ"; Option)
        {
            Caption = 'Item Typ';
            Description = 'Trade Item,,Empties Item,Transport Item,,Packing Material,,,Spare Parts,,Insurance Item,Freight Item,Dummy Item';
            OptionCaption = 'Trade Item,Raw Materials,Empties Item,Transport Item,Verbrauchsmaterial,Packing Material,,,Spare Parts,,Insurance Item,Freight Item,Dummy Item,Transportleistungen,,,Dienstleistungen';
            OptionMembers = "Trade Item","Raw Materials","Empties Item","Transport Item",Verbrauchsmaterial,"Packing Material",,,"Spare Parts",,"Insurance Item","Freight Item","Dummy Item",Transportleistungen,,,Dienstleistungen;
        }
        field(5110322; "POI No. of Cross References"; Integer)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Count ("Item Cross Reference" WHERE("Item No." = FIELD("No.")));
            Caption = 'No. of Cross References';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110323; "POI Batch Variant Filter"; Code[20])
        {
            Caption = 'Batch Variant Filter';
            FieldClass = FlowFilter;
            TableRelation = "POI Batch Variant";
        }
        field(5110325; "POI Only for Company Chain"; Code[10])
        {
            Caption = 'Only for Company Chain';
            TableRelation = "POI Company Chain";
        }
        field(5110326; "POI Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(5110327; "POI Description Base"; Text[30])
        {
            Caption = 'Description Base';
        }
        field(5110330; "POI Item Main Category Code"; Code[10])
        {
            Caption = 'Item Main Category Code';
            TableRelation = "POI Item Main Category";

            trigger OnValidate()
            begin

                ADF_ItemStructureValidate(FIELDNO("POI Item Main Category Code"));

                //RS Vorgabedimension anlegen/ändern
                lrc_DefaultDimension.SETRANGE("Table ID", 27);
                lrc_DefaultDimension.SETRANGE("No.", "No.");
                lrc_DefaultDimension.SETRANGE("Dimension Code", 'ARTIKELHAUPTKAT');
                IF lrc_DefaultDimension.FINDSET() THEN BEGIN
                    lrc_DefaultDimension."Dimension Value Code" := "POI Item Main Category Code";
                    lrc_DefaultDimension.MODIFY();
                END ELSE BEGIN
                    lrc_DefaultDimension.INIT();
                    lrc_DefaultDimension."Table ID" := 27;
                    lrc_DefaultDimension."No." := "No.";
                    lrc_DefaultDimension."Dimension Code" := 'ARTIKELHAUPTKAT';
                    lrc_DefaultDimension."Dimension Value Code" := "POI Item Main Category Code";
                    lrc_DefaultDimension.INSERT();
                END;
            end;
        }
        field(5110331; "POI Main Product Group Code"; Code[10])
        {
            Caption = 'Main Product Group Code';
            TableRelation = "POI Main Product Groups";
        }
        field(5110332; "POI Purch. Order Sign"; Option)
        {
            Caption = 'Purch. Order Sign';
            Description = ' ,Noch nicht lieferbar,,,Lagerware,,,Vorbestellung in Preisliste,,,Sonderbestellung nix Preisliste,,,Nur Aktion,Nur Saison,,,Nur MHD,,,Auslaufartikel';
            OptionCaption = ' ,Noch nicht lieferbar,,,Lagerware,,,Vorbestellung in Preisliste,,,Sonderbestellung nix Preisliste,,,Nur Aktion,Nur Saison,,,Nur MHD,,,Auslaufartikel';
            OptionMembers = " ","Noch nicht lieferbar",,,Lagerware,,,"Vorbestellung in Preisliste",,,"Sonderbestellung nix Preisliste",,,"Nur Aktion","Nur Saison",,,"Nur MHD",,,Auslaufartikel;
        }
        field(5110378; "POI Grundpreisfaktor"; Decimal)
        {
            Caption = 'Grundpreisfaktor';
        }
        field(5110383; "POI Date of Expiry Mandatory"; Option)
        {
            Caption = 'Date of Expiry Mandatory';
            OptionCaption = ' ,MHD Pflicht,MHD Pflicht mit Variante';
            OptionMembers = " ","MHD Pflicht","MHD Pflicht mit Variante";

            trigger OnValidate()
            var
                lrc_ItemVariant: Record "Item Variant";
            begin
                CASE "POI Date of Expiry Mandatory" OF
                    "POI Date of Expiry Mandatory"::" ":
                        // Eventuell bestehende Varianten löschen
                        ;
                    "POI Date of Expiry Mandatory"::"MHD Pflicht":
                        // Eventuell bestehende Varianten löschen
                        ;
                    "POI Date of Expiry Mandatory"::"MHD Pflicht mit Variante":
                        BEGIN
                            // MHD Varianten anlegen
                            lrc_ItemVariant.RESET();
                            IF NOT lrc_ItemVariant.GET("No.", '001') THEN BEGIN
                                lrc_ItemVariant.RESET();
                                lrc_ItemVariant.INIT();
                                lrc_ItemVariant."Item No." := "No.";
                                lrc_ItemVariant.Code := '001';
                                lrc_ItemVariant.Description := Description;
                                lrc_ItemVariant."Description 2" := "Description 2";
                                lrc_ItemVariant."POI MHD Variant" := TRUE;
                                lrc_ItemVariant.INSERT();
                            END;
                            lrc_ItemVariant.RESET();
                            IF NOT lrc_ItemVariant.GET("No.", '002') THEN BEGIN
                                lrc_ItemVariant.RESET();
                                lrc_ItemVariant.INIT();
                                lrc_ItemVariant."Item No." := "No.";
                                lrc_ItemVariant.Code := '002';
                                lrc_ItemVariant.Description := Description;
                                lrc_ItemVariant."Description 2" := "Description 2";
                                lrc_ItemVariant."POI MHD Variant" := TRUE;
                                lrc_ItemVariant.INSERT();
                            END;
                        END;
                END;
            end;
        }
        field(5110385; "POI Indirect Cost Calculation"; Option)
        {
            Caption = 'Indirect Cost Calculation';
            OptionMembers = Prozentsatz,"Schema",Sonstiges;
        }
        field(5110390; "POI Price Base (Purch. Price)"; Code[10])
        {
            Caption = 'Price Base (Purch. Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Purch. Price"),
                                                     Blocked = CONST(false));
        }
        field(5110392; "POI Add Charge Partitial Qty"; Option)
        {
            Caption = 'Add Charge Partitial Qty';
            OptionCaption = ' ,Percentage,Amount';
            OptionMembers = " ",Percentage,Amount;

            trigger OnValidate()
            begin
                TESTFIELD("POI Allow Partial Quantity", TRUE);
            end;
        }
        field(5110393; "POI Add Charge Value Part. Qty"; Decimal)
        {
            Caption = 'Add Charge Value Partitial Qty';

            trigger OnValidate()
            begin
                TESTFIELD("POI Allow Partial Quantity", TRUE);
            end;
        }
        field(5110394; "POI Weight"; Option)
        {
            Caption = 'Weight';
            Description = ' ,Net Weight,Gross Weight';
            OptionCaption = ' ,Net Weight,Gross Weight';
            OptionMembers = " ","Net Weight","Gross Weight";
        }

        field(5110395; "POI Empties Item No."; Code[20])
        {
            Caption = 'Empties Item No.';
            Description = 'LVW';
            TableRelation = Item WHERE("POI Item Typ" = FILTER("Empties Item" | "Transport Item"));

            trigger OnValidate()
            var
                lrc_FruitVisionSetup: Record "POI ADF Setup";
            begin
                IF "POI Empties Item No." <> '' THEN BEGIN
                    lrc_FruitVisionSetup.GET();
                    CASE lrc_FruitVisionSetup."Item Insert Template" OF
                        lrc_FruitVisionSetup."Item Insert Template"::"Schablone 2":
                            "POI Empties Quantity" := 0;
                        lrc_FruitVisionSetup."Item Insert Template"::"Schablone 3":
                            "POI Empties Quantity" := 0;
                        ELSE
                            "POI Empties Quantity" := 1;
                    END;
                END ELSE
                    "POI Empties Quantity" := 0;
            end;
        }
        field(5110396; "POI Empties Quantity"; Decimal)
        {
            Caption = 'Empties Quantity';
            DecimalPlaces = 0 : 5;
            Description = 'LVW';
        }
        field(5110397; "POI Empties Shipm Sale (Qty.)"; Decimal)
        {
            CalcFormula = - Sum ("Item Ledger Entry".Quantity WHERE("Entry Type" = FILTER(Sale | Transfer),
                                                                   "Item No." = FIELD("No."),
                                                                   Positive = CONST(false),
                                                                   "Source Type" = FIELD("POI Source Type Filter"),
                                                                   "Source No." = FIELD("POI Source No. Filter"),
                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                   "Location Code" = FIELD("Location Filter")));
            Caption = 'Empties Shipment Sale (Qty.)';
            DecimalPlaces = 0 : 5;
            Description = 'LVW';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(5110398; "POI Empties Rec Sale (Qty.)"; Decimal)
        {
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE("Entry Type" = FILTER(Sale | Transfer),
                                                                  "Item No." = FIELD("No."),
                                                                  Positive = CONST(false),
                                                                  "Source Type" = FIELD("POI Source Type Filter"),
                                                                  "Source No." = FIELD("POI Source No. Filter"),
                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                  "Location Code" = FIELD("Location Filter")));
            Caption = 'Empties Receipt Sale (Qty.)';
            DecimalPlaces = 0 : 5;
            Description = 'LVW';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(5110399; "POI Source No. Filter"; Code[20])
        {
            Caption = 'Source No. Filter';
            Description = 'LVW';
            FieldClass = FlowFilter;
            TableRelation = IF ("POI Source Type Filter" = CONST(Customer)) Customer
            ELSE
            IF ("POI Source Type Filter" = CONST(Vendor)) Vendor
            ELSE
            IF ("POI Source Type Filter" = CONST(Item)) Item;
        }
        field(5110400; "POI Source Type Filter"; Option)
        {
            Caption = 'Source Type Filter';
            Description = 'LVW  ,Customer,Vendor,Item';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Customer,Vendor,Item';
            OptionMembers = " ",Customer,Vendor,Item;
        }
        field(5110411; "POI Empties Organisation"; Option)
        {
            Caption = 'Empties Organisation';
            OptionCaption = ' ,IFCO,,,STECO,,,POOL,,,Others';
            OptionMembers = " ",IFCO,,,STECO,,,POOL,,,Others;
        }
        field(5110430; "POI Not in Intrastat"; Boolean)
        {
            Caption = 'Not in Intrastat';
        }
        field(5110438; "POI Cultivation Associat. Code"; Code[10])
        {
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            TableRelation = "POI Cultivation Association";
        }
        field(5110439; "POI Item Attribute 1"; Code[10])
        {
            //CaptionClass = '5110310,1,1';
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 1";
        }
        field(5110440; "POI Countr of Ori Code (Fruit)"; Code[10])
        {
            Caption = 'Country of Origin Code (Fruit)';
            Description = 'EIA';
            TableRelation = "Country/Region".Code;

            trigger OnLookup()
            begin
                ADF_FieldsLookUp(FIELDNO("POI Countr of Ori Code (Fruit)"));
            end;

            trigger OnValidate()
            begin
                ADF_FieldsValidate(FIELDNO("POI Countr of Ori Code (Fruit)"));
            end;
        }
        field(5110441; "POI Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            Description = 'EIA';
            TableRelation = "POI Variety".Code;

            // trigger OnLookup()
            // begin
            //     ADF_FieldsLookUp(FIELDNO("Variety Code"));
            // end;

            // trigger OnValidate()
            // begin
            //     ADF_FieldsValidate(FIELDNO("Variety Code"));
            // end;


        }
        field(5110442; "POI Trademark Code"; Code[20])
        {
            Caption = 'Marken';
            Description = 'alle am Artikel hinterlegten Marken';
            TableRelation = "POI Trademark";

            // trigger OnLookup()
            // begin
            //     ADF_FieldsLookUp(FIELDNO("POI Trademark Code"));
            // end;

            // trigger OnValidate()
            // begin
            //     ADF_FieldsValidate(FIELDNO("POI Trademark Code"));
            // end;
        }
        field(5110443; "POI Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            Description = 'EIA';
            TableRelation = "POI Caliber".Code;
            ValidateTableRelation = false;

            // trigger OnValidate()
            // begin
            //     ADF_FieldsValidate(FIELDNO("Caliber Code"));
            // end;
        }
        field(5110445; "POI Item Attribute 3"; Code[10])
        {
            //CaptionClass = '5110310,1,3';
            Caption = 'Quality Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 3".Code;
        }
        field(5110446; "POI Item Attribute 2"; Code[10])
        {
            //CaptionClass = '5110310,1,2';
            Caption = 'Color Code';
            Description = 'EIA';
        }
        field(5110447; "POI Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            Description = 'EIA';
            trigger OnLookup()
            begin
                ItemAttribute.SetRange("Item No.", "No.");
                ItemAttribute.SetRange("Attribute Type", ItemAttribute."Attribute Type"::"Grade of Goods");
                ItemAttributePage.setItemNo("No.");
                ItemAttributePage.SetTableView(ItemAttribute);
                ItemAttributePage.Run();
            end;
        }
        field(5110448; "POI Item Attribute 7"; Code[10])
        {
            //CaptionClass = '5110310,1,7';
            Caption = 'Conservation Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 7";
        }
        field(5110449; "POI Item Attribute 4"; Code[10])
        {
            //CaptionClass = '5110310,1,4';
            Caption = 'Packing Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 4";
        }
        field(5110450; "POI Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            Description = 'EIA';
            TableRelation = "POI Coding";
        }
        field(5110451; "POI Item Attribute 5"; Code[10])
        {
            //CaptionClass = '5110310,1,5';
            Caption = 'Treatment Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 5";
        }
        field(5110452; "POI Item Attribute 6"; Code[20])
        {
            //CaptionClass = '5110310,1,6';
            Caption = 'Proper Name Code';
            Description = 'EIA';
            TableRelation = "POI Proper Name";
            ValidateTableRelation = false;
        }
        field(5110453; "POI Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            Description = 'EIA';
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;
        }
        field(5110455; "POI Stock Kind of Checking"; Option)
        {
            Caption = 'Stock Kind of Checking';
            Description = ' ,Stock,Available Stock,Future Available Stock';
            OptionCaption = ' ,Stock,Available Stock,Future Available Stock';
            OptionMembers = " ",Stock,"Available Stock","Future Available Stock";
        }
        field(5110456; "POI Stock Action on neg. Check"; Option)
        {
            Caption = 'Stock Action on neg. Check';
            Description = ' ,Warning,Blocking';
            OptionCaption = ' ,Warning,Blocking';
            OptionMembers = " ",Warning,Blocking;
        }
        field(5110457; "POI Empties Posting Item No."; Code[20])
        {
            Caption = 'Empties Posting Item No.';
            TableRelation = Item;
        }
        field(5110458; "POI Stock Check Point"; Option)
        {
            Caption = 'Stock Check Point';
            OptionMembers = " ",,,"Sales Order Entry";
        }
        field(5110464; "POI Steuerung Artikeleinheiten"; Option)
        {
            Caption = 'Steuerung Artikeleinheiten';
            Description = ' ,Mit fester VPE,In Karton oder Kiste,Keine Einheitsverpackung (gewogen),Ohne Verpackung (loose Ware)';
            OptionCaption = ' ,Mit fester VPE,In Karton oder Kiste,Keine Einheitsverpackung (gewogen),Ohne Verpackung (loose Ware)';
            OptionMembers = " ","Mit fester VPE","In Karton oder Kiste","Keine Einheitsverpackung (gewogen)","Ohne Verpackung (loose Ware)";
        }
        field(5110465; "POI Transp. with Air Condition"; Boolean)
        {
            Caption = 'Transport with Air Condition';

            trigger OnValidate()
            begin
                IF "POI Transp. with Air Condition" = FALSE THEN
                    "POI Transport Temperature" := 0;
            end;
        }
        field(5110466; "POI Transport Temperature"; Decimal)
        {
            BlankZero = true;
            Caption = 'Transport Temperature';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                TESTFIELD("POI Transp. with Air Condition", TRUE);
            end;
        }
        field(5110467; "POI Stock Temperature from"; Decimal)
        {
            Caption = 'Stock Temperature from';
        }
        field(5110468; "POI Stock Temperature till"; Decimal)
        {
            Caption = 'Stock Temperature till';
        }
        field(5110470; "POI Qty. on Reservation (FV)"; Decimal)
        {
            CalcFormula = Sum ("POI Reservation Line"."Remaining Qty. (Base)" WHERE(State = CONST(Opened),
                                                                                "Item No." = FIELD("No."),
                                                                                "Variant Code" = FIELD("Variant Filter"),
                                                                                "Batch Variant No." = FIELD("POI Batch Variant Filter"),
                                                                                "Location Code" = FIELD("Location Filter")));
            Caption = 'Qty. on Reservation (FV)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110471; "POI Qty. on Packing Input"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Input Items"."Remaining Quantity (Base)" WHERE("Item No." = FIELD("No."),
                                                                                           "Variant Code" = FIELD("Variant Filter"),
                                                                                           "Location Code" = FIELD("Location Filter")));
            Caption = 'Qty. on Packing Input';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110472; "POI Qty. on Packing Output"; Decimal)
        {
            CalcFormula = Sum ("POI Pack. Order Output Items"."Remaining Quantity (Base)" WHERE("Item No." = FIELD("No."),
                                                                                            "Variant Code" = FIELD("Variant Filter"),
                                                                                            "Location Code" = FIELD("Location Filter")));
            Caption = 'Qty. on Packing Output';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110473; "POI Qty. on Pack PackItem Inp"; Decimal)
        {
            CalcFormula = Sum ("POI PO Input Pack. Items"."Remaining Quantity (Base)" WHERE("Item No." = FIELD("No."),
                                                                                                 "Variant Code" = FIELD("Variant Filter"),
                                                                                                 "Location Code" = FIELD("Location Filter")));
            Caption = 'Qty. on Packing PackItem Input';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110474; "POI Qty. on Batch Variant Entr"; Decimal)
        {
            CalcFormula = Sum ("POI Batch Variant Entry"."Quantity (Base)" WHERE("Item No." = FIELD("No."),
                                                                             "Variant Code" = FIELD("Variant Filter"),
                                                                             "Location Code" = FIELD("Location Filter")));
            Caption = 'Qty. on Batch Variant Entries';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110482; "POI Qty. on Sales Credit Memo"; Decimal)
        {
            CalcFormula = Sum ("Sales Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST("Credit Memo"),
                                                                            Type = CONST(Item),
                                                                            "No." = FIELD("No."),
                                                                            "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                            "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                            "Location Code" = FIELD("Location Filter"),
                                                                            "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                            "Variant Code" = FIELD("Variant Filter"),
                                                                            "Shipment Date" = FIELD("Date Filter")));
            Caption = 'Quantity on Sales Credit Memo';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110483; "POI Qty. on Purchase Cred Memo"; Decimal)
        {
            CalcFormula = Sum ("Purchase Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST("Credit Memo"),
                                                                               Type = CONST(Item),
                                                                               "No." = FIELD("No."),
                                                                               "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                               "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                               "Location Code" = FIELD("Location Filter"),
                                                                               "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                               "Variant Code" = FIELD("Variant Filter"),
                                                                               "Expected Receipt Date" = FIELD("Date Filter")));
            Caption = 'Quantity on Purchase Credit Memo';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110490; "POI Allow Bonus"; Boolean)
        {
            Caption = 'Allow Bonus';
        }
        field(5110590; "POI Producer No."; Code[20])
        {
            Caption = 'Producer No.';
            TableRelation = Vendor WHERE("POI Is Manufacturer" = CONST(true));
        }
        field(5110600; "POI ABC Sign Turnover"; Option)
        {
            Caption = 'ABC Sign Turnover';
            Description = ' ,A,B,C,D,E,F';
            OptionCaption = ' ,A,B,C,D,E,F';
            OptionMembers = " ",A,B,C,D,E,F;
        }
        field(5110601; "POI ABC Sign Quantity"; Option)
        {
            Caption = 'ABC Sign Quantity';
            OptionCaption = ' ,A,B,C,D,E,F';
            OptionMembers = " ",A,B,C,D,E,F;
        }
        field(5110602; "POI ABC Sign Rohertrag"; Option)
        {
            Caption = 'ABC Sign Rohertrag';
            OptionCaption = ' ,A,B,C,D,E,F';
            OptionMembers = " ",A,B,C,D,E,F;
        }
        field(5110608; "POI Allow Partial Quantity"; Boolean)
        {
            Caption = 'Allow Partial Quantity';

            trigger OnValidate()
            begin
                IF "POI Allow Partial Quantity" = FALSE THEN BEGIN
                    "POI Add Charge Partitial Qty" := "POI Add Charge Partitial Qty"::" ";
                    "POI Add Charge Value Part. Qty" := 0;
                END;
            end;
        }
        field(5110610; "POI Lagerartikel"; Option)
        {
            Caption = 'Lagerartikel';
            OptionCaption = ' ,Stock Item,,,Auslauf Item';
            OptionMembers = " ","Stock Item",,,"Auslauf Item";
        }
        field(5110611; "POI Order Item"; Option)
        {
            Caption = 'Bestellartikel';
            OptionCaption = ' ,Allways Order,,,,,Order if no Stock';
            OptionMembers = " ","Allways Order",,,,,"Order if no Stock";
        }
        field(5110613; "POI Artikelzeiten"; Option)
        {
            OptionCaption = ' ,Season Item,,,Only Action Item,,,,,Only Sample';
            OptionMembers = " ","Season Item",,,"Only Action Item",,,,,"Only Sample";
        }
        field(5110614; "POI In Bestellvorschlag"; Boolean)
        {
        }
        field(5110615; "POI Ausgabe Preisliste"; Option)
        {
            OptionCaption = ' ,Alle Ausgabearten,,,,,Nur Druckpreisliste,,,,,Nur Elektronische Preisliste';
            OptionMembers = " ","Alle Ausgabearten",,,,,"Nur Druckpreisliste",,,,,"Nur Elektronische Preisliste";
        }
        field(5110621; "POI Guarant. Shelf Life Purch."; DateFormula)
        {
            Caption = 'Guaranteed Shelf Life Purch.';
        }
        field(5110622; "POI Guarant. Shelf Life Sales"; DateFormula)
        {
            Caption = 'Guaranteed Shelf Life Sales';
        }
        field(5110623; "POI First Batch State in Purch"; Option)
        {
            Caption = 'Erster Positionstatus im Einkauf';
            OptionCaption = ' ,Gesperrt';
            OptionMembers = " ",Blocked;
        }
        field(5110630; "POI No Stock in Packing Order"; Boolean)
        {
            Caption = 'Keine Bestandsführung in Packerei';
            Description = 'für PAC';
        }
    }


    trigger OnModify()
    begin
        GetDimName("No.");
    end;

    procedure GetDimName(ItemNo: Code[20]): Text[100]
    var
        DimensionValue: Record "Dimension Value";
        Item: Record Item;
        OutText: Text[100];
    begin
        Item.Get(ItemNo);
        OutText := Description;
        DefDimension.SetRange("Table ID", 27);
        DefDimension.SetRange("No.", ItemNo);
        IF DefDimension.FindSet() then
            repeat
                IF DefDimension."Dimension Value Code" IN ['BIO', 'FAIRTRADE', 'BECLIMATE'] THEN
                    IF DimensionValue.Get(DefDimension."Dimension Code", DefDimension."Dimension Value Code") then
                        if StrLen(OutText) + StrLen(DimensionValue.Name) + 1 <= MaxStrLen(OutText) then
                            OutText := copyStr(OutText + ' ' + DimensionValue.Name, 1, 50);
            until DefDimension.Next() = 0;
        exit(OutText);
    end;

    procedure ADF_FieldsLookUp(vin_FieldNo: Integer)
    var
        BDMBaseDataMgt: Codeunit "POI BDM Base Data Mgmt";
        lco_ReturnCode: Code[10];
    begin
        // ---------------------------------------------------------------------------------
        // Funktion zur Ausführung LookUp für die übergebene Feldnummer
        // ---------------------------------------------------------------------------------

        CASE vin_FieldNo OF
            FIELDNO("POI Caliber Code"):
                BEGIN
                    lco_ReturnCode := gcu_BaseDataMgt.CaliberLookUp("POI Product Group Code");
                    IF lco_ReturnCode <> '' THEN
                        VALIDATE("POI Caliber Code", lco_ReturnCode);
                END;

            FIELDNO("POI Variety Code"):
                BEGIN
                    lco_ReturnCode := gcu_BaseDataMgt.VarietyLookUp("POI Product Group Code");
                    IF lco_ReturnCode <> '' THEN
                        VALIDATE("POI Variety Code", lco_ReturnCode);
                END;

            FIELDNO("POI Trademark Code"):
                IF BDMBaseDataMgt.TrademarkLookUp("POI Trademark Code", "POI Product Group Code") THEN
                    VALIDATE("POI Trademark Code", "POI Trademark Code");


            FIELDNO("Sales Unit of Measure"):
                BEGIN
                    lco_ReturnCode := gcu_BaseDataMgt.UnitOfMeasureLookUp("POI Product Group Code", "No.");
                    IF lco_ReturnCode <> '' THEN
                        VALIDATE("Sales Unit of Measure", lco_ReturnCode);
                END;

            FIELDNO("Purch. Unit of Measure"):
                BEGIN
                    lco_ReturnCode := gcu_BaseDataMgt.UnitOfMeasureLookUp("POI Product Group Code", "No.");
                    IF lco_ReturnCode <> '' THEN
                        VALIDATE("Purch. Unit of Measure", lco_ReturnCode);
                END;

            FIELDNO("POI Countr of Ori Code (Fruit)"):
                BEGIN
                    lco_ReturnCode := gcu_BaseDataMgt.CountryLookUp("POI Product Group Code");
                    IF lco_ReturnCode <> '' THEN
                        VALIDATE("POI Countr of Ori Code (Fruit)", lco_ReturnCode);
                END;

        END;
    end;

    procedure ADF_ItemStructureValidate(vin_FieldNo: Integer)
    var
        lrc_ADFSetup: Record "POI ADF Setup";
        lrc_ItemCategory: Record "Item Category";
        lrc_ItemMainCategory: Record "POI Item Main Category";
    begin
        // --------------------------------------------------------------------------
        // Funktion zur Validierung der Eingabe Artikelhierarchie
        // --------------------------------------------------------------------------

        lrc_ADFSetup.GET();

        CASE lrc_ADFSetup."Item Hierarchy" OF
            // Abhängige Hierarchie
            lrc_ADFSetup."Item Hierarchy"::Depending:
                CASE vin_FieldNo OF
                    FIELDNO("POI Product Group Code"):
                        BEGIN
                            lrc_ProductGroup.SETRANGE(Code, "POI Product Group Code");
                            IF lrc_ProductGroup.FINDFIRST() THEN BEGIN
                                "POI Item Typ" := lrc_ProductGroup."Def. Item Typ";
                                "POI Batch Item" := lrc_ProductGroup."Def. Batch Item";
                                "Tariff No." := lrc_ProductGroup."Def. Tariff No.";
                                "POI Cultivation Type" := lrc_ProductGroup."Def. Cultivation Type";
                                "POI Transport Temperature" := lrc_ProductGroup."Transport Temperature";
                                // Vorbelegung mit Beschreibung aus Produktgruppe
                                IF Description = '' THEN
                                    Description := lrc_ProductGroup.Description;
                                lrc_ItemCategory.GET(lrc_ProductGroup."Item Category Code");
                                "Item Category Code" := lrc_ProductGroup."Item Category Code";
                                lrc_ItemMainCategory.GET(lrc_ItemCategory."POI Item Main Category Code");
                                "POI Item Main Category Code" := lrc_ItemCategory."POI Item Main Category Code";

                                CASE lrc_ADFSetup."Item Hierarchy Def. Level" OF
                                    lrc_ADFSetup."Item Hierarchy Def. Level"::"Product Group":
                                        BEGIN
                                            VALIDATE("Base Unit of Measure", lrc_ProductGroup."Def. Base Unit of Measure");
                                            //"Product Group Code BNN" := lrc_ProductGroup."Product Group Code BNN";
                                            //"Product Group Code IfH" := lrc_ProductGroup."Product Group Code IfH";

                                            "Gen. Prod. Posting Group" := lrc_ProductGroup."Def. Gen. Prod. Posting Group";
                                            "Inventory Posting Group" := lrc_ProductGroup."Def. Inventory Posting Group";
                                            "Tax Group Code" := lrc_ProductGroup."Def. Tax Group Code";
                                            "Costing Method" := lrc_ProductGroup."Def. Costing Method";
                                            "VAT Prod. Posting Group" := lrc_ProductGroup."Def. VAT Prod. Posting Group";
                                        END;
                                    lrc_ADFSetup."Item Hierarchy Def. Level"::"Item Category":
                                        BEGIN
                                            VALIDATE("Base Unit of Measure", lrc_ItemCategory."POI Def. Base Unit of Measure");
                                            //"Product Group Code BNN" := lrc_ItemCategory."Product Group Code BNN";
                                            //"Product Group Code IfH" := lrc_ItemCategory."Product Group Code IfH";

                                            "Gen. Prod. Posting Group" := lrc_ItemCategory."POI Def. Gen. Prod. Post Group";
                                            "Inventory Posting Group" := lrc_ItemCategory."POI Def. Inventory Post Group";
                                            "Tax Group Code" := lrc_ItemCategory."POI Def. Tax Group Code";
                                            "Costing Method" := lrc_ItemCategory."POI Def. Costing Method";
                                            "VAT Prod. Posting Group" := lrc_ItemCategory."POI Def. VAT Prod. Post Group";
                                        END;
                                    lrc_ADFSetup."Item Hierarchy Def. Level"::"Item main Category":
                                        BEGIN

                                            VALIDATE("Base Unit of Measure", lrc_ItemMainCategory."Def. Base Unit of Measure");
                                            //"Product Group Code BNN" := lrc_ItemMainCategory."Product Group Code BNN";
                                            //"Product Group Code IfH" := lrc_ItemMainCategory."Product Group Code IfH";

                                            "Gen. Prod. Posting Group" := lrc_ItemMainCategory."Def. Gen. Prod. Posting Group";
                                            "Inventory Posting Group" := lrc_ItemMainCategory."Def. Inventory Posting Group";
                                            "Tax Group Code" := lrc_ItemMainCategory."Def. Tax Group Code";
                                            "Costing Method" := lrc_ItemMainCategory."Def. Costing Method";
                                            "VAT Prod. Posting Group" := lrc_ItemMainCategory."Def. VAT Prod. Posting Group";

                                        END;
                                END;//case
                            END;//begin
                        end; //begin
                    FIELDNO("Item Category Code"):
                        ;
                    FIELDNO("POI Item Main Category Code"):
                        ;
                END;//case
                    //END; //case

            // Unabhängige Hierarchie
            lrc_ADFSetup."Item Hierarchy"::"Not Depending":
                CASE vin_FieldNo OF
                    FIELDNO("POI Product Group Code"):
                        BEGIN
                            lrc_ProductGroup.SETRANGE(Code, "POI Product Group Code");
                            IF lrc_ProductGroup.FINDFIRST() THEN BEGIN
                                "POI Item Typ" := lrc_ProductGroup."Def. Item Typ";
                                "POI Batch Item" := lrc_ProductGroup."Def. Batch Item";
                                "Tariff No." := lrc_ProductGroup."Def. Tariff No.";
                                "POI Cultivation Type" := lrc_ProductGroup."Def. Cultivation Type";
                                "POI Transport Temperature" := lrc_ProductGroup."Transport Temperature";
                                // Vorbelegung mit Beschreibung aus Produktgruppe
                                IF Description = '' THEN
                                    Description := lrc_ProductGroup.Description;
                                lrc_ItemCategory.GET(lrc_ProductGroup."Item Category Code");
                                "Item Category Code" := lrc_ProductGroup."Item Category Code";
                                lrc_ItemMainCategory.GET(lrc_ItemCategory."POI Item Main Category Code");
                                "POI Item Main Category Code" := lrc_ItemCategory."POI Item Main Category Code";
                                CASE lrc_ADFSetup."Item Hierarchy Def. Level" OF
                                    lrc_ADFSetup."Item Hierarchy Def. Level"::"Product Group":
                                        BEGIN

                                            VALIDATE("Base Unit of Measure", lrc_ProductGroup."Def. Base Unit of Measure");
                                            //"Product Group Code BNN" := lrc_ProductGroup."Product Group Code BNN";
                                            //"Product Group Code IfH" := lrc_ProductGroup."Product Group Code IfH";

                                            "Gen. Prod. Posting Group" := lrc_ProductGroup."Def. Gen. Prod. Posting Group";
                                            "Inventory Posting Group" := lrc_ProductGroup."Def. Inventory Posting Group";
                                            "Tax Group Code" := lrc_ProductGroup."Def. Tax Group Code";
                                            "Costing Method" := lrc_ProductGroup."Def. Costing Method";
                                            "VAT Prod. Posting Group" := lrc_ProductGroup."Def. VAT Prod. Posting Group";

                                        END;
                                    lrc_ADFSetup."Item Hierarchy Def. Level"::"Item Category":
                                        BEGIN
                                            VALIDATE("Base Unit of Measure", lrc_ItemCategory."POI Def. Base Unit of Measure");
                                            //"Product Group Code BNN" := lrc_ItemCategory."Product Group Code BNN";
                                            //"Product Group Code IfH" := lrc_ItemCategory."Product Group Code IfH";
                                            "Gen. Prod. Posting Group" := lrc_ItemCategory."POI Def. Gen. Prod. Post Group";
                                            "Inventory Posting Group" := lrc_ItemCategory."POI Def. Inventory Post Group";
                                            "Tax Group Code" := lrc_ItemCategory."POI Def. Tax Group Code";
                                            "Costing Method" := lrc_ItemCategory."POI Def. Costing Method";
                                            "VAT Prod. Posting Group" := lrc_ItemCategory."POI Def. VAT Prod. Post Group";
                                        END;
                                    lrc_ADFSetup."Item Hierarchy Def. Level"::"Item main Category":
                                        BEGIN
                                            VALIDATE("Base Unit of Measure", lrc_ItemMainCategory."Def. Base Unit of Measure");
                                            //"Product Group Code BNN" := lrc_ItemMainCategory."Product Group Code BNN";
                                            //"Product Group Code IfH" := lrc_ItemMainCategory."Product Group Code IfH";
                                            "Gen. Prod. Posting Group" := lrc_ItemMainCategory."Def. Gen. Prod. Posting Group";
                                            "Inventory Posting Group" := lrc_ItemMainCategory."Def. Inventory Posting Group";
                                            "Tax Group Code" := lrc_ItemMainCategory."Def. Tax Group Code";
                                            "Costing Method" := lrc_ItemMainCategory."Def. Costing Method";
                                            "VAT Prod. Posting Group" := lrc_ItemMainCategory."Def. VAT Prod. Posting Group";
                                        END;
                                END; //Case
                            END; //begin
                        END;//begin
                    FIELDNO("Item Category Code"):
                        ;
                    FIELDNO("POI Item Main Category Code"):
                        ;
                END;//Case
        END; //case
    end;

    procedure ADF_FieldsValidate(vin_FieldNo: Integer)
    var
        BDMBaseDataMgt: Codeunit "POI BDM Base Data Mgmt";
        BaseDataTemplateMgt: Codeunit "POI BDT Base Data Template Mgt";
    begin
        // ---------------------------------------------------------------------------------
        // Funktion zur Validierung von Eingaben
        // ---------------------------------------------------------------------------------

        CASE vin_FieldNo OF
            FIELDNO("POI Caliber Code"):
                gcu_BaseDataMgt.CaliberValidate("POI Caliber Code", "POI Product Group Code");

            FIELDNO("POI Variety Code"):
                BEGIN
                    gcu_BaseDataMgt.VarietyValidate("POI Variety Code", "POI Product Group Code");
                    Description := BaseDataTemplateMgt.GenerateItemDesc1(Rec);
                END;

            FIELDNO("POI Trademark Code"):
                BDMBaseDataMgt.AttributeTrademarkValidate("POI Trademark Code", "POI Product Group Code");

            FIELDNO("Sales Unit of Measure"):
                gcu_BaseDataMgt.UnitOfMeasureValidate("Sales Unit of Measure", "POI Product Group Code");

            FIELDNO("Purch. Unit of Measure"):
                gcu_BaseDataMgt.UnitOfMeasureValidate("Purch. Unit of Measure", "POI Product Group Code");

            FIELDNO("POI Countr of Ori Code (Fruit)"):
                gcu_BaseDataMgt.CountryValidate("POI Countr of Ori Code (Fruit)", "POI Product Group Code");

        END;

        // Suchbegriff neu erstellen
        "Search Description" := gcu_BaseDataTemplateMgt.GenerateItemSearchDesc(Rec);
    end;


    var
        ItemAttribute: Record "POI Item Attribute";
        ItemCountry: Record "POI Item Country";
        lrc_DefaultDimension: Record "Default Dimension";
        DefDimension: Record "Default Dimension";
        lrc_ProductGroup: Record "POI Product Group";
        gcu_BaseDataMgt: Codeunit "POI Base Data Mgt";
        gcu_BaseDataTemplateMgt: Codeunit "POI BDT Base Data Template Mgt";
        ItemAttributePage: page "POI Item Attribute";
}