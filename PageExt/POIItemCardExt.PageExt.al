pageextension 50010 "POI Item Card Ext" extends "Item Card"
{
    layout
    {
        // addlast(Item)
        // {
        //     field(SearchcodePOI; "POI Searchcode")
        //     {
        //         ApplicationArea = All;
        //         ToolTip = ' ';
        //     }
        // }
        addafter("Item Category Code")
        {
            field("POI Wizzard Status"; "POI Wizzard Status")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                Importance = Additional;
            }
            field("POI Is Base Item"; "POI Is Base Item")
            {
                Caption = 'Basisartikel';
                ApplicationArea = All;
                ToolTip = ' ';
                Importance = Additional;
            }
            field("POI Base Item Code"; "POI Base Item Code")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                Importance = Additional;
            }
        }
        addafter(Item)
        {
            group(attributes)
            {
                Caption = 'Basisartikelmerkmale';
                Visible = "POI Is Base Item";

                field("POI Grade of Goods Codes"; "POI Grade of Goods Codes")
                {
                    Caption = 'Handelsklassen';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Trademarks"; "POI Trademarks")
                {
                    Caption = 'Marken';
                    ApplicationArea = All;
                    ToolTip = 'verwendete Marken';
                }
                field("POI Country of Origin"; "POI Country of Origin")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Caliber Codes"; "POI Caliber Codes")
                {
                    Caption = 'Kaliber';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Coding Codes"; "POI Coding Codes")
                {
                    Caption = 'Kodierungen';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Variety Codes"; "POI Variety Codes")
                {
                    Caption = 'Sorte';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Cultivation Types"; "POI Cultivation Types")
                {
                    Caption = 'Anbauarten';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI PLU-Codes"; "POI PLU-Codes")
                {
                    Caption = 'PLU-Code';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }

        }
        addfirst(ItemTracking)
        {
            field("POI Batch Item"; "POI Batch Item")
            {
                Caption = 'Partieartikel';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI GGN Tracking"; "POI GGN Tracking")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        addafter("Tariff No.")
        {
            field("POI Tariff Description"; "POI Tariff Description")
            {
                ApplicationArea = All;
                ToolTip = 'Beschreibung Zolltarifnummer';
            }
        }
        addfirst("Prices & Sales")
        {
            field("POI Price Base (Sales Price)"; "POI Price Base (Sales Price)")
            {
                Caption = 'Preisbasis VK';
                ApplicationArea = All;
                ToolTip = 'Preisbasis im Verkauf';
            }
        }
        addfirst("Costs & Posting")
        {
            field("POI Price Base (Purch. Price)"; "POI Price Base (Purch. Price)")
            {
                Caption = 'Preisbasis EK';
                ApplicationArea = All;
                ToolTip = 'Preisbasis im Einkauf';
            }
        }
        addfirst(factboxes)
        {
            part(POIItemAttributes; "POI Item Specification Factbox")
            {
                Caption = 'Artikelspezifikation';
                ApplicationArea = All;
                SubPageLink = "Item No." = field("No."), Blocked = const(false);
            }
        }
        modify(Warehouse)
        {
            Visible = false;
        }
        modify(InventoryGrp)
        {
            Visible = false;
        }
        modify("Service Item Group")
        {
            Visible = false;
        }
        modify("Automatic Ext. Texts")
        {
            Visible = false;
        }
        modify("Common Item No.")
        {
            Visible = false;
        }
        modify(ItemPicture)
        {
            Visible = false;
        }
        modify("Standard Cost")
        {
            Visible = false;
        }
        modify("Unit Cost")
        {
            Visible = false;
        }
        modify("Net Invoiced Qty.")
        {
            Visible = false;
        }
        modify(SpecialPricesAndDiscountsTxt)
        {
            Visible = false;
        }
        modify(SpecialPurchPricesAndDiscountsTxt)
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }
        modify("Tariff No.")
        {
            Caption = 'Zolltarifnummer';
        }
        modify("Unit Price")
        {
            Visible = false;
        }
        modify("Price Includes VAT")
        {
            Visible = false;
        }
        modify(Replenishment)
        {
            Visible = false;
        }
        modify(Planning)
        {
            Visible = false;
        }
        modify("Lot Nos.")
        {
            Visible = false;
        }
        modify("Serial Nos.")
        {
            Visible = false;
        }
        modify("Item Tracking Code")
        {
            Visible = false;
        }
        modify("Expiration Calculation")
        {
            Visible = false;
        }
        modify(ItemAttributesFactbox)
        {
            Visible = false;
        }

    }


    actions
    {
        addlast(Processing)
        {
            action(Attribut)
            {
                Caption = 'Artikelspezifikation';
                ApplicationArea = All;
                ToolTip = 'Auswahl der zum Artikel gehörigen Merkmale';
                RunObject = Page "POI item Specification";
                RunPageLink = "Item No." = field("No.");
            }
            action(ItemCodes)
            {
                Caption = 'Artikelkennungen';
                ApplicationArea = All;
                ToolTip = 'Hinterlegen von EAN und Plu Codes';
                RunObject = page "POI Item codes";
                RunPageLink = "Item No." = field("No.");
            }
            action(Trademark)
            {
                Caption = 'Markenauswahl';
                ApplicationArea = All;
                ToolTip = 'Auswahl der möglichen Marken';
                RunObject = page "POI Item Attribute";
                RunPageLink = "Item No." = field("No.");
            }
            action("Generate SearchCodePOI")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    "POI Searchcode" := GetDimName("No.");
                end;
            }
            action(DownloadPicture)
            {
                Caption = 'Download Picture';
                ToolTip = ' ';
                Image = Picture;

                trigger OnAction()
                var
                    TempBlob: Record "Tenant Media" temporary;
                    DownloadMgt: Codeunit "POI Notification Test";
                    Instr: InStream;
                begin
                    DownloadMgt.DownloadPicture('https://www.clipartsfree.de/images/joomgallery/details/schule_24/kostenlose_bildr_fuer_schule_20130803_1938879159.jpg', TempBlob);
                    TempBlob.Content.CreateInStream(Instr);
                    rec.Picture.ImportStream(Instr, 'default Image');
                    CurrPage.Update(true);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BaseItemTrue := "POI Is Base Item";
    end;

    var
        BaseItemTrue: Boolean;
}