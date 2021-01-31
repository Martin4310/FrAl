page 5110315 "POI Item Card"
{
    Caption = 'Item';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Item;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Allgemein';
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("No. 2"; "No. 2")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                grid(ProdGroupgrid)
                {
                    GridLayout = Columns;
                    field("POI Product Group Code"; "POI Product Group Code")
                    {
                        Caption = 'Produktgruppencode';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(GroupNameF; GroupName)
                    {
                        Caption = 'GroupName';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                        Editable = false;
                    }
                }
                grid(ItemCategorygrid)
                {
                    GridLayout = Columns;
                    field("Item Category Code"; "Item Category Code")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(ItemCategoryNameF; ItemCategoryName)
                    {
                        caption = 'ItemCategoryName';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                        Editable = false;
                    }
                }
                grid(ItemMainCategorygrid)
                {
                    GridLayout = Columns;
                    field("POI Item Main Category Code"; "POI Item Main Category Code")
                    {
                        Caption = 'Artikelhauptkategorien Code';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(ItemMainCategoryNameF; ItemMainCategoryName)
                    {
                        Caption = 'ItemMainCategoryName';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                        Editable = false;
                    }
                }
                grid(MainProductGroupgrid)
                {
                    GridLayout = Columns;
                    field("POI Main Product Group Code"; "POI Main Product Group Code")
                    {
                        Caption = 'Hauptwarengruppen Code';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = false;
                    }
                    field(MainProductGroupNameF; MainProductGroupName)
                    {
                        Caption = 'MainProductGroupName';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                        Editable = false;
                    }
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Search Description"; "Search Description")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Grundpreisfaktor"; "POI Grundpreisfaktor")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Created From Nonstock Item"; "Created From Nonstock Item")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Automatic Ext. Texts"; "Automatic Ext. Texts")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("No. of Substitutes"; "No. of Substitutes")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI No. of Cross References"; "POI No. of Cross References")
                {
                    Caption = 'Anzahl Artikelreferenzen';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                grid(BaseUnitOfMeasuregrid)
                {
                    field("Base Unit of Measure"; "Base Unit of Measure")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Sales Unit of Measure"; "Sales Unit of Measure")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                        Style = Strong;
                    }
                }
                grid(Inventorygrid)
                {

                    field(Inventory; Inventory)
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(QtyInvSUF; QtyInvSU)
                    {
                        Caption = 'QtyInvSU';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                        Editable = false;
                    }
                }
                field("POI Qty. on Batch Variant Entr"; "POI Qty. on Batch Variant Entr")
                {
                    Caption = 'Menge Positionsvar. Posten';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                grid(Purchasegrid)
                {
                    field("Qty. on Purch. Order"; "Qty. on Purch. Order")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(QtyPurchOrderSUF; QtyPurchOrderSU)
                    {
                        Caption = 'QtyPurchOrderSU';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                        Editable = false;
                    }
                }
                grid(salesgrid)
                {
                    field("Qty. on Sales Order"; "Qty. on Sales Order")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(QtySalesOrderSUF; QtySalesOrderSU)
                    {
                        Caption = 'QtySalesOrderSUF';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                        Editable = false;
                    }
                }
                field("POI Item Typ"; "POI Item Typ")
                {
                    Caption = 'Artikeltyp';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Only for Company Chain"; "POI Only for Company Chain")
                {
                    Caption = 'nur für Unternehmenskette';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

                field("POI Activ in Purchase"; "POI Activ in Purchase")
                {
                    Caption = 'Aktiv im Einkauf';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Activ in Sales"; "POI Activ in Sales")
                {
                    Caption = 'Aktiv im Verkauf';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI First Batch State in Purch"; "POI First Batch State in Purch")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI No Stock in Packing Order"; "POI No Stock in Packing Order")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Last User ID Modified"; "POI Last User ID Modified")
                {
                    Caption = 'Korrigiert durch';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            group(Attribute)
            {
                Caption = 'Merkmale';

                field("POI Description Base"; "POI Description Base")
                {
                    Caption = 'Basisbeschreibung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Variety Code"; "POI Variety Code")
                {
                    Caption = 'Sorte';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Countr of Ori Code (Fruit)"; "POI Countr of Ori Code (Fruit)")
                {
                    Caption = 'Erzeugerland';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Caliber Code"; "POI Caliber Code")
                {
                    Caption = 'Kaliber';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Grade of Goods Code"; "POI Grade of Goods Code")
                {
                    Caption = 'Handelsklasse';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Trademark Code"; "POI Trademark Code")
                {
                    Caption = 'Marke';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Coding Code"; "POI Coding Code")
                {
                    Caption = 'Kodierung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Cultivation Type"; "POI Cultivation Type")
                {
                    Caption = 'Anbauart';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Item Attribute 1"; "POI Item Attribute 1")
                {
                    Caption = 'Anbauverfahren';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Item Attribute 2"; "POI Item Attribute 2")
                {
                    Caption = 'Farbe';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                // field("POI Item Attribute 3"; "POI Item Attribute 3")
                // {
                //     Caption = 'Qualität';
                //     ApplicationArea = All;
                //    ToolTip = ' ';
                // }
                // field("POI Item Attribute 4"; "POI Item Attribute 4")
                // {
                //     Caption = 'Abpackung';
                //     ApplicationArea = All;
                //    ToolTip = ' ';
                // }
                // field("POI Item Attribute 5"; "POI Item Attribute 5")
                // {
                //     Caption = 'Aufbereitungsart';
                //     ApplicationArea = All;
                //    ToolTip = ' ';
                // }
                // field("POI Item Attribute 6"; "POI Item Attribute 6")
                // {
                //     Caption = 'Eigenname';
                //     ApplicationArea = All;
                //   ToolTip = ' ';
                // }
                // field("POI Item Attribute 7"; "POI Item Attribute 7")
                // {
                //     Caption = 'Konservierung';
                //     ApplicationArea = All;
                //   ToolTip = ' ';
                // }
                field("POI Weight"; "POI Weight")
                {
                    Caption = 'Wiegen';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                group(EmptiesControl)
                {
                    Caption = 'Leergut';
                    field("POI Empties Item No."; "POI Empties Item No.")
                    {
                        Caption = 'Leergut Artikelnr.';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("POI Empties Quantity"; "POI Empties Quantity")
                    {
                        Caption = 'Leergutmenge';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("POI Empties Posting Item No."; "POI Empties Posting Item No.")
                    {
                        Caption = 'Leergut Buchungsartikelnr.';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("POI Empties Organisation"; "POI Empties Organisation")
                    {
                        Caption = 'Leergutorganisation';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }

                field("POI Cultivation Associat. Code"; "POI Cultivation Associat. Code")
                {
                    Caption = 'Anbauverband';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            group(Financials)
            {
                Caption = 'Fakturierung';
                field("Costing Method"; "Costing Method")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Cost is Adjusted"; "Cost is Adjusted")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Cost is Posted to G/L"; "Cost is Posted to G/L")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Standard Cost"; "Standard Cost")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Overhead Rate"; "Overhead Rate")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Indirect Cost Calculation"; "POI Indirect Cost Calculation")
                {
                    Caption = 'Nebenkostenberechnung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Indirect Cost %"; "Indirect Cost %")
                {
                    Caption = 'Kosten %';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Last Direct Cost"; "Last Direct Cost")
                {
                    Caption = 'EK-Preis (neuester)';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Price/Profit Calculation"; "Price/Profit Calculation")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Profit %"; "Profit %")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Inventory Posting Group"; "Inventory Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Net Invoiced Qty."; "Net Invoiced Qty.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Item Disc. Group"; "Item Disc. Group")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Allow Bonus"; "POI Allow Bonus")
                {
                    Caption = 'Bonus zugelssen';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Sales Unit of Measure1"; "Sales Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Price Base (Sales Price)"; "POI Price Base (Sales Price)")
                {
                    Caption = 'Preisbasis (VK-Preis)';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Allow Partial Quantity"; "POI Allow Partial Quantity")
                {
                    Caption = 'Anbruch zulässig';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Add Charge Partitial Qty"; "POI Add Charge Partitial Qty")
                {
                    Caption = 'Aufschlag bei Anbruch';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Add Charge Value Part. Qty"; "POI Add Charge Value Part. Qty")
                {
                    Caption = 'Aufschlagswert bei Anbruch';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            group(Replenishment)
            {
                Caption = 'Beschaffung';
                field("Replenishment System"; "Replenishment System")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Manufacturer Code"; "Manufacturer Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Producer No."; "POI Producer No.")
                {
                    Caption = 'Produzentennr.';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                group(Purchase)
                {
                    Caption = 'Einkauf';
                    field("Vendor No."; "Vendor No.")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Vendor Item No."; "Vendor Item No.")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Purch. Unit of Measure"; "Purch. Unit of Measure")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("POI Price Base (Purch. Price)"; "POI Price Base (Purch. Price)")
                    {
                        Caption = 'Preisbasis (Ek-Preis)';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Lead Time Calculation"; "Lead Time Calculation")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
            }
            group(Planning)
            {
                field("Reordering Policy"; "Reordering Policy")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Include Inventory"; "Include Inventory")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Reserve; Reserve)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Order Tracking Policy"; "Order Tracking Policy")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Stockkeeping Unit Exists"; "Stockkeeping Unit Exists")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Critical; Critical)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI ABC Sign Turnover"; "POI ABC Sign Turnover")
                {
                    Caption = 'ABC-Kennzeichen Umsatz';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI ABC Sign Quantity"; "POI ABC Sign Quantity")
                {
                    Caption = 'ABC-Kennzeichen Menge';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI ABC Sign Rohertrag"; "POI ABC Sign Rohertrag")
                {
                    Caption = 'ABC-Kennzeichen Rohertrag';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Safety Lead Time"; "Safety Lead Time")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Time Bucket"; "Time Bucket")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Safety Stock Quantity"; "Safety Stock Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Reorder Point"; "Reorder Point")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Reorder Quantity"; "Reorder Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Maximum Inventory"; "Maximum Inventory")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Minimum Order Quantity"; "Minimum Order Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

                field("Maximum Order Quantity"; "Maximum Order Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Order Multiple"; "Order Multiple")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            group(ForeignTrade)
            {
                Caption = 'Aussenhandel';
                field("Tariff No."; "Tariff No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Duty Unit Conversion"; "Duty Unit Conversion")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Country/Region of Origin Code"; "Country/Region of Origin Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Not in Intrastat"; "POI Not in Intrastat")
                {
                    Caption = 'Nicht in Intrastat';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Net Weight"; "Net Weight")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Gross Weight"; "Gross Weight")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Unit Volume"; "Unit Volume")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            group(ItemTrakcing)
            {
                Caption = 'Artikelverfolgung';
                field("Item Tracking Code"; "Item Tracking Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Serial Nos."; "Serial Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Lot Nos."; "Lot Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Expiration Calculation"; "Expiration Calculation")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            group(POILocation)
            {
                Caption = 'Lager';
                field("Special Equipment Code"; "Special Equipment Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Put-away Template Code"; "Put-away Template Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Put-away Unit of Measure Code"; "Put-away Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Phys Invt Counting Period Code"; "Phys Invt Counting Period Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Last Phys. Invt. Date"; "Last Phys. Invt. Date")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Last Counting Period Update"; "Last Counting Period Update")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Identifier Code"; "Identifier Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Use Cross-Docking"; "Use Cross-Docking")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Batch Item"; "POI Batch Item")
                {
                    Caption = 'Partiegeführter Artikel';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Stock Kind of Checking"; "POI Stock Kind of Checking")
                {
                    Caption = 'Bestand Art der Prüfung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Stock Action on neg. Check"; "POI Stock Action on neg. Check")
                {
                    Caption = 'Bestand Aktion wenn';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Stock Check Point"; "POI Stock Check Point")
                {
                    Caption = 'Bestand Prüfungszeitpunkt';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Location Code"; "POI Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Shelf No."; "Shelf No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Date of Expiry Mandatory"; "POI Date of Expiry Mandatory")
                {
                    Caption = 'MHD Pflicht';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Guarant. Shelf Life Purch."; "POI Guarant. Shelf Life Purch.")
                {
                    Caption = 'Mindesrestlaufzeit Einkauf';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Guarant. Shelf Life Sales"; "POI Guarant. Shelf Life Sales")
                {
                    Caption = 'Mindesrestlaufzeit Verkauf';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Transp. with Air Condition"; "POI Transp. with Air Condition")
                {
                    Caption = 'Transport mit Kühlung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Transport Temperature"; "POI Transport Temperature")
                {
                    Caption = 'Transporttemperatur';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Stock Temperature from"; "POI Stock Temperature from")
                {
                    Caption = 'Lagertemperatur von';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Stock Temperature till"; "POI Stock Temperature till")
                {
                    Caption = 'Lagertemperatur bis';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Purch. Order Sign"; "POI Purch. Order Sign")
                {
                    Caption = 'Einkauf Bestellkennung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Lagerartikel"; "POI Lagerartikel")
                {
                    Caption = 'Lagerartikel';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Order Item"; "POI Order Item")
                {
                    Caption = 'Bestellartikel';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Artikelzeiten"; "POI Artikelzeiten")
                {
                    Caption = 'Artikelzeiten';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Ausgabe Preisliste"; "POI Ausgabe Preisliste")
                {
                    Caption = 'Ausgabe Preisliste';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI In Bestellvorschlag"; "POI In Bestellvorschlag")
                {
                    Caption = 'In Bestellvorschlag';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
        area(factboxes)
        {
            part(ItemPicture; "Item Picture")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                Caption = 'Picture';
                SubPageLink = "No." = FIELD("No."),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                              "Location Filter" = FIELD("Location Filter"),
                              "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                              "Variant Filter" = FIELD("Variant Filter");
            }
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(27),
                              "No." = FIELD("No.");
            }
            part(ItemAttributesFactbox; "Item Attributes Factbox")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control132; "Social Listening FactBox")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                SubPageLink = "Source Type" = CONST(Item),
                              "Source No." = FIELD("No.");
                Visible = SocialListeningVisible;
            }
            part(Control134; "Social Listening Setup FactBox")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                SubPageLink = "Source Type" = CONST(Item),
                              "Source No." = FIELD("No.");
                UpdatePropagation = Both;
                Visible = SocialListeningSetupVisible;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(ItemActionGroup)
            {
                Caption = 'Item';
                Image = DataEntry;
                action(Attributes)
                {
                    AccessByPermission = TableData "Item Attribute" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Attributes';
                    Image = Category;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'View or edit the item''s attributes, such as color, size, or other characteristics that help to describe the item.';

                    trigger OnAction()
                    begin
                        PAGE.RunModal(PAGE::"Item Attribute Value Editor", Rec);
                        CurrPage.SaveRecord();
                        CurrPage.ItemAttributesFactbox.PAGE.LoadItemAttributesData("No.");
                    end;
                }
                action(AdjustInventory)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Adjust Inventory';
                    Enabled = IsInventoriable;
                    Image = InventoryCalculation;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Increase or decrease the item''s inventory quantity manually by entering a new quantity. Adjusting the inventory quantity manually may be relevant after a physical count or if you do not record purchased quantities.';
                    Visible = IsFoundationEnabled;

                    trigger OnAction()
                    var
                        AdjustInventory: Page "Adjust Inventory";
                    begin
                        Commit();
                        AdjustInventory.SetItem("No.");
                        AdjustInventory.RunModal();
                    end;
                }
                action("Va&riants")
                {
                    ApplicationArea = Planning;
                    Caption = 'Va&riants';
                    Image = ItemVariant;
                    RunObject = Page "Item Variants";
                    RunPageLink = "Item No." = FIELD("No.");
                    ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';
                }
                action(Identifiers)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Identifiers';
                    Image = BarCode;
                    RunObject = Page "Item Identifiers";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.", "Variant Code", "Unit of Measure Code");
                    ToolTip = 'View a unique identifier for each item that you want warehouse employees to keep track of within the warehouse when using handheld devices. The item identifier can include the item number, the variant code and the unit of measure.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Item),
                                  "No." = FIELD("No.");
                    ToolTip = 'View or add comments for the record.';
                }
                action(Attachments)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal();
                    end;
                }
            }
            group(PricesandDiscounts)
            {
                Caption = 'Special Sales Prices & Discounts';
                action("Set Special Prices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Set Special Prices';
                    Image = Price;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Item No." = FIELD("No.");
                    ToolTip = 'Set up different prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
                }
                action("Set Special Discounts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Set Special Discounts';
                    Image = LineDiscount;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = Type = CONST(Item),
                                  Code = FIELD("No.");
                    RunPageView = SORTING(Type, Code);
                    ToolTip = 'Set up different discounts for the item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';
                }
                action(PricesDiscountsOverview)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Special Prices & Discounts Overview';
                    Image = PriceWorksheet;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ToolTip = 'View the special prices and line discounts that you grant for this item when certain criteria are met, such as vendor, quantity, or ending date.';

                    trigger OnAction()
                    var
                        SalesPriceAndLineDiscounts: Page "Sales Price and Line Discounts";
                    begin
                        SalesPriceAndLineDiscounts.InitPage(true);
                        SalesPriceAndLineDiscounts.LoadItem(Rec);
                        SalesPriceAndLineDiscounts.RunModal();
                    end;
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RecordId());
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RecordId());
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category7;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RecordId());
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category7;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group(RequestApproval)
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = EnabledApprovalWorkflowsExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedOnly = true;
                    ToolTip = 'Request approval to change the record.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.CheckItemApprovalsWorkflowEnabled(Rec) then
                            ApprovalsMgmt.OnSendItemForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
                    begin
                        ApprovalsMgmt.OnCancelItemApprovalRequest(Rec);
                        WorkflowWebhookManagement.FindAndCancel(RecordId());
                    end;
                }
                group(Flow)
                {
                    Caption = 'Flow';
                    action(CreateFlow)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Create a Flow';
                        Image = Flow;
                        Promoted = true;
                        PromotedCategory = Category8;
                        PromotedOnly = true;
                        ToolTip = 'Create a new Flow from a list of relevant Flow templates.';
                        Visible = IsSaaS;

                        trigger OnAction()
                        var
                            FlowServiceManagement: Codeunit "Flow Service Management";
                            FlowTemplateSelector: Page "Flow Template Selector";
                        begin
                            // Opens page 6400 where the user can use filtered templates to create new Flows.
                            FlowTemplateSelector.SetSearchText(FlowServiceManagement.GetItemTemplateFilter());
                            FlowTemplateSelector.Run();
                        end;
                    }
                    action(SeeFlows)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'See my Flows';
                        Image = Flow;
                        Promoted = true;
                        PromotedCategory = Category8;
                        PromotedOnly = true;
                        RunObject = Page "Flow Selector";
                        ToolTip = 'View and configure Flows that you created.';
                    }
                }
            }
            group(Workflow)
            {
                Caption = 'Workflow';
                action(CreateApprovalWorkflow)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Approval Workflow';
                    Image = CreateWorkflow;
                    ToolTip = 'Set up an approval workflow for creating or changing items, by going through a few pages that will guide you.';

                    trigger OnAction()
                    begin
                        PAGE.RunModal(PAGE::"Item Approval WF Setup Wizard");
                    end;
                }
                action(ManageApprovalWorkflow)
                {
                    ApplicationArea = Suite;
                    Caption = 'Manage Approval Workflow';
                    Enabled = EnabledApprovalWorkflowsExist;
                    Image = WorkflowSetup;
                    ToolTip = 'View or edit existing approval workflows for creating or changing items.';

                    trigger OnAction()
                    var
                        WorkflowManagement: Codeunit "Workflow Management";
                    begin
                        WorkflowManagement.NavigateToWorkflows(DATABASE::Item, EventFilter);
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Create Stockkeeping Unit")
                {
                    AccessByPermission = TableData "Stockkeeping Unit" = R;
                    ApplicationArea = Warehouse;
                    Caption = '&Create Stockkeeping Unit';
                    Image = CreateSKU;
                    ToolTip = 'Create an instance of the item at each location that is set up.';

                    trigger OnAction()
                    var
                        Item: Record Item;
                    begin
                        Item.SetRange("No.", "No.");
                        REPORT.RunModal(REPORT::"Create Stockkeeping Unit", true, false, Item);
                    end;
                }
                action(CalculateCountingPeriod)
                {
                    AccessByPermission = TableData "Phys. Invt. Item Selection" = R;
                    ApplicationArea = Warehouse;
                    Caption = 'C&alculate Counting Period';
                    Image = CalculateCalendar;
                    ToolTip = 'Prepare for a physical inventory by calculating which items or SKUs need to be counted in the current period.';

                    trigger OnAction()
                    var
                        Item: Record Item;
                        PhysInvtCountMgt: Codeunit "Phys. Invt. Count.-Management";
                    begin
                        Item.SetRange("No.", "No.");
                        PhysInvtCountMgt.UpdateItemPhysInvtCount(Item);
                    end;
                }
                action(Templates)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Templates';
                    Image = Template;
                    RunObject = Page "Config Templates";
                    RunPageLink = "Table ID" = CONST(27);
                    ToolTip = 'View or edit item templates.';
                }
                action(CopyItem)
                {
                    AccessByPermission = TableData Item = I;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Copy Item';
                    Image = Copy;
                    ToolTip = 'Create a copy of the current item.';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Copy Item", Rec);
                    end;
                }
                action(ApplyTemplate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    ToolTip = 'Apply a template to update the entity with your standard settings for a certain type of entity.';

                    trigger OnAction()
                    var
                        ItemTemplate: Record "Item Template";
                    begin
                        ItemTemplate.UpdateItemFromTemplate(Rec);
                    end;
                }
                action(SaveAsTemplate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Save as Template';
                    Ellipsis = true;
                    Image = Save;
                    ToolTip = 'Save the item card as a template that can be reused to create new item cards. Item templates contain preset information to help you fill in fields on item cards.';

                    trigger OnAction()
                    var
                        TempItemTemplate: Record "Item Template" temporary;
                    begin
                        TempItemTemplate.SaveAsTemplate(Rec);
                    end;
                }
            }
            action("Requisition Worksheet")
            {
                ApplicationArea = Planning;
                Caption = 'Requisition Worksheet';
                Image = Worksheet;
                RunObject = Page "Req. Worksheet";
                ToolTip = 'Calculate a supply plan to fulfill item demand with purchases or transfers.';
            }
            action("Item Journal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Journal";
                ToolTip = 'Open a list of journals where you can adjust the physical quantity of items on inventory.';
            }
            action("Item Reclassification Journal")
            {
                ApplicationArea = Warehouse;
                Caption = 'Item Reclassification Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Reclass. Journal";
                ToolTip = 'Change information on item ledger entries, such as dimensions, location codes, bin codes, and serial or lot numbers.';
            }
            action("Item Tracing")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item Tracing';
                Image = ItemTracing;
                RunObject = Page "Item Tracing";
                ToolTip = 'Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.';
            }
        }
        area(navigation)
        {
            group(History)
            {
                Caption = 'History';
                Image = History;
                group(Entries)
                {
                    Caption = 'E&ntries';
                    Image = Entries;
                    action("Ledger E&ntries")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ledger E&ntries';
                        Image = ItemLedger;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Category5;
                        //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedIsBig = true;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Item No." = FIELD("No.");
                        RunPageView = SORTING("Item No.")
                                      ORDER(Descending);
                        ShortCutKey = 'Ctrl+F7';
                        ToolTip = 'View the history of transactions that have been posted for the selected record.';
                    }
                    action("&Phys. Inventory Ledger Entries")
                    {
                        ApplicationArea = Warehouse;
                        Caption = '&Phys. Inventory Ledger Entries';
                        Image = PhysicalInventoryLedger;
                        Promoted = true;
                        PromotedCategory = Category5;
                        PromotedIsBig = true;
                        RunObject = Page "Phys. Inventory Ledger Entries";
                        RunPageLink = "Item No." = FIELD("No.");
                        RunPageView = SORTING("Item No.");
                        ToolTip = 'View how many units of the item you had in stock at the last physical count.';
                    }
                    action("&Reservation Entries")
                    {
                        ApplicationArea = Reservation;
                        Caption = '&Reservation Entries';
                        Image = ReservationLedger;
                        RunObject = Page "Reservation Entries";
                        RunPageLink = "Reservation Status" = CONST(Reservation),
                                      "Item No." = FIELD("No.");
                        RunPageView = SORTING("Item No.", "Variant Code", "Location Code", "Reservation Status");
                        ToolTip = 'View all reservations that are made for the item, either manually or automatically.';
                    }
                    action("&Value Entries")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = '&Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Item No." = FIELD("No.");
                        RunPageView = SORTING("Item No.");
                        ToolTip = 'View the history of posted amounts that affect the value of the item. Value entries are created for every transaction with the item.';
                    }
                    action("Item &Tracking Entries")
                    {
                        ApplicationArea = ItemTracking;
                        Caption = 'Item &Tracking Entries';
                        Image = ItemTrackingLedger;
                        ToolTip = 'View serial or lot numbers that are assigned to items.';

                        trigger OnAction()
                        var
                            ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
                        begin
                            ItemTrackingDocMgt.ShowItemTrackingForMasterData(3, '', "No.", '', '', '', '');
                        end;
                    }
                    action("&Warehouse Entries")
                    {
                        ApplicationArea = Warehouse;
                        Caption = '&Warehouse Entries';
                        Image = BinLedger;
                        RunObject = Page "Warehouse Entries";
                        RunPageLink = "Item No." = FIELD("No.");
                        RunPageView = SORTING("Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.", "Entry Type", Dedicated);
                        ToolTip = 'View the history of quantities that are registered for the item in warehouse activities. ';
                    }
                    action("Application Worksheet")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Application Worksheet';
                        Image = ApplicationWorksheet;
                        RunObject = Page "Application Worksheet";
                        RunPageLink = "Item No." = FIELD("No.");
                        ToolTip = 'Edit item applications that are automatically created between item ledger entries during item transactions. Use special functions to manually undo or change item application entries.';
                    }
                    action("Export Item Data")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Export Item Data';
                        Image = ExportFile;
                        ToolTip = 'Use this function to export item related data to text file (you can attach this file to support requests in case you may have issues with costing calculation).';

                        trigger OnAction()
                        var
                            Item: Record Item;
                            ExportItemData: XMLport "Export Item Data";
                        begin
                            Item.SetRange("No.", "No.");
                            Clear(ExportItemData);
                            ExportItemData.SetTableView(Item);
                            ExportItemData.Run();
                        end;
                    }
                }
            }
            group(Navigation_Item)
            {
                Caption = 'Item';
                action(Dimensions)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    PromotedIsBig = true;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(27),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                action("Cross Re&ferences")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cross Re&ferences';
                    Image = Change;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Item Cross Reference Entries";
                    RunPageLink = "Item No." = FIELD("No.");
                    ToolTip = 'Set up a customer''s or vendor''s own identification of the item. Cross-references to the customer''s item number means that the item number is automatically shown on sales documents instead of the number that you use.';
                }
                action("&Units of Measure")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Units of Measure';
                    Image = UnitOfMeasure;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Item Units of Measure";
                    RunPageLink = "Item No." = FIELD("No.");
                    ToolTip = 'Set up the different units that the item can be traded in, such as piece, box, or hour.';
                }
                action("E&xtended Texts")
                {
                    ApplicationArea = Suite;
                    Caption = 'E&xtended Texts';
                    Image = Text;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Extended Text List";
                    RunPageLink = "Table Name" = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                    ToolTip = 'Select or set up additional text for the description of the item. Extended text can be inserted under the Description field on document lines for the item.';
                }
                action(Translations)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Translations';
                    Image = Translations;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Item Translations";
                    RunPageLink = "Item No." = FIELD("No.");
                    ToolTip = 'View or edit translated item descriptions. Translated item descriptions are automatically inserted on documents according to the language code.';
                }
                action("Substituti&ons")
                {
                    ApplicationArea = Suite;
                    Caption = 'Substituti&ons';
                    Image = ItemSubstitution;
                    RunObject = Page "Item Substitution Entry";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    ToolTip = 'View substitute items that are set up to be sold instead of the item.';
                }
                action(ApprovalEntries)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedOnly = true;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(RecordId());
                    end;
                }
                action(CreateSearchName)
                {
                    Caption = 'Suchbegriff für alle Artikel erstellen';
                    ApplicationArea = All;
                    ToolTip = ' ';

                    trigger OnAction()
                    var
                        BaseDataTemplateMgt: Codeunit "POI BDT Base Data Template Mgt";
                    begin
                        BaseDataTemplateMgt.GenerateAllItemSearchDesc();
                    end;
                }
            }
            group(Availability)
            {
                Caption = 'Availability';
                Image = ItemAvailability;
                action(ItemsByLocation)
                {
                    AccessByPermission = TableData Location = R;
                    ApplicationArea = Location;
                    Caption = 'Items b&y Location';
                    Image = ItemAvailbyLoc;
                    ToolTip = 'Show a list of items grouped by location.';

                    trigger OnAction()
                    begin
                        PAGE.Run(PAGE::"Items by Location", Rec);
                    end;
                }
                group(ItemAvailabilityBy)
                {
                    Caption = '&Item Availability by';
                    Image = ItemAvailability;
                    action("<Action110>")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Event';
                        Image = "Event";
                        ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Rec, ItemAvailFormsMgt.ByEvent());
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period';
                        Image = Period;
                        RunObject = Page "Item Availability by Periods";
                        RunPageLink = "No." = FIELD("No."),
                                      "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD("Location Filter"),
                                      "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD("Variant Filter");
                        ToolTip = 'Show the projected quantity of the item over time according to time periods, such as day, week, or month.';
                    }
                    action(Variant)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Variant';
                        Image = ItemVariant;
                        RunObject = Page "Item Availability by Variant";
                        RunPageLink = "No." = FIELD("No."),
                                      "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD("Location Filter"),
                                      "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD("Variant Filter");
                        ToolTip = 'View how the inventory level of an item will develop over time according to the variant that you select.';
                    }
                    action(Location)
                    {
                        ApplicationArea = Location;
                        Caption = 'Location';
                        Image = Warehouse;
                        RunObject = Page "Item Availability by Location";
                        RunPageLink = "No." = FIELD("No."),
                                      "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD("Location Filter"),
                                      "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD("Variant Filter");
                        ToolTip = 'View the actual and projected quantity of the item per location.';
                    }
                    action("BOM Level")
                    {
                        AccessByPermission = TableData "BOM Buffer" = R;
                        ApplicationArea = Assembly;
                        Caption = 'BOM Level';
                        Image = BOMLevel;
                        ToolTip = 'View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Rec, ItemAvailFormsMgt.ByBOM());
                        end;
                    }
                }
                group(StatisticsGroup)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    action(Statistics)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Statistics';
                        Image = Statistics;
                        ShortCutKey = 'F7';
                        ToolTip = 'View statistical information, such as the value of posted entries, for the record.';

                        trigger OnAction()
                        var
                            ItemStatistics: Page "Item Statistics";
                        begin
                            ItemStatistics.SetItem(Rec);
                            ItemStatistics.RunModal();
                        end;
                    }
                    action("Entry Statistics")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Entry Statistics';
                        Image = EntryStatistics;
                        RunObject = Page "Item Entry Statistics";
                        RunPageLink = "No." = FIELD("No."),
                                      "Date Filter" = FIELD("Date Filter"),
                                      "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD("Location Filter"),
                                      "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD("Variant Filter");
                        ToolTip = 'View statistics for item ledger entries.';
                    }
                    action("T&urnover")
                    {
                        ApplicationArea = Suite;
                        Caption = 'T&urnover';
                        Image = Turnover;
                        RunObject = Page "Item Turnover";
                        RunPageLink = "No." = FIELD("No."),
                                      "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                      "Location Filter" = FIELD("Location Filter"),
                                      "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                                      "Variant Filter" = FIELD("Variant Filter");
                        ToolTip = 'View a detailed account of item turnover by periods after you have set the relevant filters for location and variant.';
                    }
                }
            }
            group(Purchases)
            {
                Caption = '&Purchases';
                Image = Purchasing;
                action("Ven&dors")
                {
                    ApplicationArea = Planning;
                    Caption = 'Ven&dors';
                    Image = Vendor;
                    RunObject = Page "Item Vendor Catalog";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.");
                    ToolTip = 'View the list of vendors who can supply the item, and at which lead time.';
                }
                action("Prepa&yment Percentages")
                {
                    ApplicationArea = Prepayments;
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Purchase Prepmt. Percentages";
                    RunPageLink = "Item No." = FIELD("No.");
                    ToolTip = 'View or edit the percentages of the price that can be paid as a prepayment. ';
                }
                action(Orders)
                {
                    ApplicationArea = Suite;
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Purchase Orders";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", Type, "No.");
                    ToolTip = 'View a list of ongoing orders for the item.';
                }
                action("Return Orders")
                {
                    ApplicationArea = SalesReturnOrder, PurchReturnOrder;
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Purchase Return Orders";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", Type, "No.");
                    ToolTip = 'Open the list of ongoing return orders for the item.';
                }
            }
            group(PurchPricesandDiscounts)
            {
                Caption = 'Special Purchase Prices & Discounts';
                action(Action86)
                {
                    ApplicationArea = Suite;
                    Caption = 'Set Special Prices';
                    Image = Price;
                    RunObject = Page "Purchase Prices";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.");
                    ToolTip = 'Set up different prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';
                }
                action(Action85)
                {
                    ApplicationArea = Suite;
                    Caption = 'Set Special Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Purchase Line Discounts";
                    RunPageLink = "Item No." = FIELD("No.");
                    ToolTip = 'Set up different discounts for the item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';
                }
                action(PurchPricesDiscountsOverview)
                {
                    ApplicationArea = Suite;
                    Caption = 'Special Prices & Discounts Overview';
                    Image = PriceWorksheet;
                    ToolTip = 'View the special prices and line discounts that you grant for this item when certain criteria are met, such as vendor, quantity, or ending date.';

                    trigger OnAction()
                    var
                        PurchasesPriceAndLineDisc: Page "Purchases Price and Line Disc.";
                    begin
                        PurchasesPriceAndLineDisc.LoadItem(Rec);
                        PurchasesPriceAndLineDisc.RunModal();
                    end;
                }
            }
            group(Sales)
            {
                Caption = 'S&ales';
                Image = Sales;
                action(Action300)
                {
                    ApplicationArea = Prepayments;
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Sales Prepayment Percentages";
                    RunPageLink = "Item No." = FIELD("No.");
                    ToolTip = 'View or edit the percentages of the price that can be paid as a prepayment. ';
                }
                action(Action83)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Sales Orders";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", Type, "No.");
                    ToolTip = 'View a list of ongoing orders for the item.';
                }
                action(Action163)
                {
                    ApplicationArea = SalesReturnOrder, PurchReturnOrder;
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Sales Return Orders";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", Type, "No.");
                    ToolTip = 'Open the list of ongoing return orders for the item.';
                }
            }

            group(Navigation_Warehouse)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("&Bin Contents")
                {
                    ApplicationArea = Warehouse;
                    Caption = '&Bin Contents';
                    Image = BinContent;
                    RunObject = Page "Item Bin Contents";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.");
                    ToolTip = 'View the quantities of the item in each bin where it exists. You can see all the important parameters relating to bin content, and you can modify certain bin content parameters in this window.';
                }
                action("Stockkeepin&g Units")
                {
                    ApplicationArea = Planning;
                    Caption = 'Stockkeepin&g Units';
                    Image = SKU;
                    RunObject = Page "Stockkeeping Unit List";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.");
                    ToolTip = 'Open the item''s SKUs to view or edit instances of the item at different locations or with different variants. ';
                }
            }
            group(Service)
            {
                Caption = 'Service';
                Image = ServiceItem;
                action("Ser&vice Items")
                {
                    ApplicationArea = Service;
                    Caption = 'Ser&vice Items';
                    Image = ServiceItem;
                    RunObject = Page "Service Items";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.");
                    ToolTip = 'View instances of the item as service items, such as machines that you maintain or repair for customers through service orders. ';
                }
                action(Troubleshooting)
                {
                    AccessByPermission = TableData "Service Header" = R;
                    ApplicationArea = Service;
                    Caption = 'Troubleshooting';
                    Image = Troubleshoot;
                    ToolTip = 'View or edit information about technical problems with a service item.';

                    trigger OnAction()
                    var
                        TroubleshootingHeader: Record "Troubleshooting Header";
                    begin
                        TroubleshootingHeader.ShowForItem(Rec);
                    end;
                }
                action("Troubleshooting Setup")
                {
                    ApplicationArea = Service;
                    Caption = 'Troubleshooting Setup';
                    Image = Troubleshoot;
                    RunObject = Page "Troubleshooting Setup";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    ToolTip = 'View or edit your settings for troubleshooting service items.';
                }
            }
            group(Resources)
            {
                Caption = 'Resources';
                Image = Resource;
                action("Resource Skills")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Resource Skills';
                    Image = ResourceSkills;
                    RunObject = Page "Resource Skills";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    ToolTip = 'View the assignment of skills to resources, items, service item groups, and service items. You can use skill codes to allocate skilled resources to service items or items that need special skills for servicing.';
                }
                action("Skilled Resources")
                {
                    AccessByPermission = TableData "Service Header" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Skilled Resources';
                    Image = ResourceSkills;
                    ToolTip = 'View a list of all registered resources with information about whether they have the skills required to service the particular service item group, item, or service item.';

                    trigger OnAction()
                    var
                        ResourceSkill: Record "Resource Skill";
                    begin
                        Clear(SkilledResourceList);
                        SkilledResourceList.Initialize(ResourceSkill.Type::Item, "No.", Description);
                        SkilledResourceList.RunModal();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        Showdescriptions();
        // Mengen in Verkaufseinheit umrechnen
        QtyInvSU := 0;
        QtyPurchOrderSU := 0;
        QtySalesOrderSU := 0;
        IF ItemUnitofMeasure.GET("No.", "Sales Unit of Measure") THEN BEGIN
            CALCFIELDS(Inventory, "Qty. on Purch. Order", "Qty. on Sales Order");
            QtyInvSU := Inventory / ItemUnitofMeasure."Qty. per Unit of Measure";
            QtyPurchOrderSU := "Qty. on Purch. Order" / ItemUnitofMeasure."Qty. per Unit of Measure";
            QtySalesOrderSU := "Qty. on Sales Order" / ItemUnitofMeasure."Qty. per Unit of Measure";
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        GroupName := '';
        ItemCategoryName := '';
        ItemMainCategoryName := '';
        MainProductGroupName := '';

        QtyInvSU := 0;
        QtyPurchOrderSU := 0;
        QtySalesOrderSU := 0;

        "POI Activ in Purchase" := TRUE;
        "POI Activ in Sales" := TRUE;
    end;

    procedure Showdescriptions()
    var
        ItemCategories: Record "Item Category";
        ItemMainCategory: Record "POI Item Main Category";
        MainProductGroup: Record "POI Main Product Groups";
        ProductGroup: Record "POI Product Group";
    begin
        if ItemCategories.Get("Item Category Code") then ItemCategoryName := ItemCategories.Description;
        if ItemMainCategory.Get("POI Item Main Category Code") then ItemMainCategoryName := ItemMainCategory.Description;
        if MainProductGroup.Get("POI Main Product Group Code") then MainProductGroupName := MainProductGroup.Description;
        if ProductGroup.Get("POI Product Group Code") then GroupName := ProductGroup.Description;
    end;

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        SkilledResourceList: Page "Skilled Resource List";
        GroupName: Text[100];
        ItemCategoryName: Text[100];
        ItemMainCategoryName: Text[100];
        MainProductGroupName: Text[100];
        QtyInvSU: Decimal;
        QtyPurchOrderSU: Decimal;
        QtySalesOrderSU: Decimal;
        OpenApprovalEntriesExist: Boolean;
        EnabledApprovalWorkflowsExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        OpenApprovalEntriesExistCurrUser: Boolean;
        IsInventoriable: Boolean;
        IsFoundationEnabled: Boolean;
        IsSaaS: Boolean;
        SocialListeningVisible: Boolean;
        SocialListeningSetupVisible: Boolean;
        ShowWorkflowStatus: Boolean;
        EventFilter: Text;
}