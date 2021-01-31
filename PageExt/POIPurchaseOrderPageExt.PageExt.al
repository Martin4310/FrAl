pageextension 50027 "POI Purchase Order Page Ext" extends "Purchase Order"
{
    layout
    {
        addfirst(General)
        {
            grid(No)
            {
                field("No.1"; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }
                field("POI Purch. Doc. Subtype Code"; "POI Purch. Doc. Subtype Code")
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }
            }
            grid(Vendor)
            {
                field("Buy-from Vendor No.1"; "Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        validate("Buy-from Vendor No.", OnlookupVendor(''));
                    end;
                }
            }
        }
        moveafter("Buy-from Vendor No.1"; "Order Address Code")
        addafter(Vendor)
        {
            field("Buy-from Vendor Name1"; "Buy-from Vendor Name")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("Buy-from Address1"; "Buy-from Address")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        addafter("Buy-from Address1")
        {
            grid(byfromaddress)
            {
                Field("Buy-from Post Code1"; "Buy-from Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Buy-from City1"; "Buy-from City")
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            field("Buy-from Country/Region Code1"; "Buy-from Country/Region Code")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("Buy-from Contact No.1"; "Buy-from Contact No.")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("Buy-from Contact1"; "Buy-from Contact")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("Your Reference"; "Your Reference")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Avise"; "POI Avise")
            {
                Caption = 'Avise';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("POI Avise"; "Vendor Order No.")
        addafter("Vendor Order No.")
        {
            group(DedateGrp)
            {
                Caption = 'Warenabgangsdatum';
                grid(DepDate)
                {
                    //GridLayout = Columns;
                    // label(DepDatelbl)
                    // {
                    //     Caption = 'Warenabgangsdatum';
                    // }
                    field("POI Departure Date"; "POI Departure Date")
                    {
                        Caption = 'Warenabgangsdatum';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                    field("Departure Week"; POIFunctions.getCalendarWeek("POI Departure Date"))
                    {
                        Caption = 'Departure Week';
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("POI Departure Time From"; "POI Departure Time From")
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("POI Departure Time Till"; "POI Departure Time Till")
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
            }
            group(RecDategrp)
            {
                caption = 'geplantes Wareneingangsdatum';
                grid(RecDate)
                {
                    GridLayout = Columns;
                    field("POI Planned Receipt Date"; "POI Planned Receipt Date")
                    {
                        caption = 'geplantes Wareneingangsdatum';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                    field("Planned Week"; POIFunctions.getCalendarWeek("POI Planned Receipt Date"))
                    {
                        Caption = 'Planned Week';
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(Dummy1; Dummy1)
                    {
                        Caption = ' ';
                        HideValue = true;
                        Editable = false;
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(Dummy2; Dummy2)
                    {
                        Caption = ' ';
                        HideValue = true;
                        Editable = false;
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
            }
            group(Expdategrp)
            {
                Caption = 'erwartetes Wareneingangsdatum';
                grid(ExpDate)
                {
                    field("Expected Receipt Date1"; "Expected Receipt Date")
                    {
                        Caption = 'erwartetes Wareneingangsdatum';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                    field("Expected Week"; POIFunctions.getCalendarWeek("Expected Receipt Date"))
                    {
                        Caption = 'Expected Week';
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("POI Expected Receipt Time"; "POI Expected Receipt Time")
                    {
                        Caption = 'POI Expected Receipt Time';
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("POI Expected Receipt Time Till"; "POI Expected Receipt Time Till")
                    {
                        Caption = 'POI Expected Receipt Time Till';
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
            }
            field("POI Means of Transport Type"; "POI Means of Transport Type")
            {
                Caption = 'Transportmittel Typ';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Means of Transp.Code(Dep.)"; "POI Means of Transp.Code(Dep.)")
            {
                Caption = 'Transportmittel Abgang';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Means of TransCode(Arriva)"; "POI Means of TransCode(Arriva)")
            {
                Caption = 'Transportmittel Ankunft';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Means of Transport Info"; "POI Means of Transport Info")
            {
                Caption = 'Transportmittel Info';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI No. of Containers"; "POI No. of Containers")
            {
                Caption = 'Anzahl Container';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("POI No. of Containers"; "Location Code")
        moveafter("Location Code"; "Shipment Method Code")
        addafter("Shipment Method Code")
        {
            field("POI Shipping Agent Code"; "POI Shipping Agent Code")
            {
                Caption = 'Spedition';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Einkaufsfracht"; "POI Einkaufsfracht")
            {
                Caption = 'Einkaufsfracht';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Document Status"; "POI Document Status")
            {
                Caption = 'Belegstatus';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Waste Disposal Duty"; "POI Waste Disposal Duty")
            {
                Caption = 'Entsorgungspflicht';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Waste Disposal Paymt Thru"; "POI Waste Disposal Paymt Thru")
            {
                Caption = 'Entsorgung bezahlt durch';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("POI Waste Disposal Paymt Thru"; "Currency Code")
        addafter("Currency Code")
        {
            field("Language Code"; "Language Code")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Destination Country Code"; "POI Destination Country Code")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            grid(DepartureLocation)
            {
                GridLayout = Columns;
                field("POI Departure Location Code"; "POI Departure Location Code")
                {
                    Caption = 'Abgangslager';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnValidate()
                    begin
                        GetLocationCountry();
                    end;
                }
                field("POI DepartureCountryCode"; POIDepartureCountryCode)
                {
                    Caption = 'Abgangsland';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }
            }
            field("POI Our VAT Registration No."; "POI Our VAT Registration No.")
            {
                Caption = 'unsere Ust.-Nr.';
                ApplicationArea = All;
                ToolTip = ' ';
                Editable = false;
            }
            grid(postingdate)
            {
                field("Posting Date1"; "Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(POIPostingCW; POIFunctions.getCalendarWeek("Posting Date"))
                {
                    Caption = 'POIPostingCW';
                    ShowCaption = false;
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            grid(POIOrderDate)
            {
                field("Order Date1"; "Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(POIOrderDateCW; POIFunctions.getCalendarWeek("Order Date"))
                {
                    Caption = 'POIOrderDateCW';
                    ShowCaption = false;
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            grid(POIDocumentDate)
            {
                field("Document Date1"; "Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(POIDocumentDateCW; POIFunctions.getCalendarWeek("Document Date"))
                {
                    Caption = 'POIDocumentDateCW';
                    ShowCaption = false;
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            field("POI Master Batch No."; "POI Master Batch No.")
            {
                Caption = 'Partienr.';
                ApplicationArea = All;
                ToolTip = ' ';
                Editable = false;
            }
            field("POI Adv. Pay. Rem. Amt (LCY)"; "POI Adv. Pay. Rem. Amt (LCY)")
            {
                Caption = 'Restbetrag Vorauszahlung';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Person in Charge Code"; "POI Person in Charge Code")
            {
                Caption = 'Sachbearbeiter/in';
                ApplicationArea = All;
                ToolTip = ' ';
                Lookup = true;
                trigger OnLookup(var Text: Text): Boolean
                var
                    SalesPurch: Record "Salesperson/Purchaser";
                begin
                    SalesPurch.FILTERGROUP(2);
                    SalesPurch.SETRANGE("POI Is Person in Charge", TRUE);
                    SalesPurch.FILTERGROUP(0);
                    IF Page.RUNMODAL(0, SalesPurch) = ACTION::LookupOK THEN
                        VALIDATE("POI Person in Charge Code", SalesPurch.Code);
                end;
            }
            field("Purchaser Code1"; "Purchaser Code")
            {
                Lookup = true;
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnLookup(var Text: Text): Boolean
                var
                    SalesPurch: Record "Salesperson/Purchaser";
                begin
                    SalesPurch.FILTERGROUP(2);
                    SalesPurch.SETRANGE("POI Is Purchaser", TRUE);
                    SalesPurch.FILTERGROUP(0);
                    IF Page.RUNMODAL(0, SalesPurch) = ACTION::LookupOK THEN
                        VALIDATE("Purchaser Code", SalesPurch.Code);
                end;
            }
            field("POI Kind of Settlement"; "POI Kind of Settlement")
            {
                Caption = 'Abrechnungsart';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Cost Schema Name Code"; "POI Cost Schema Name Code")
            {
                Caption = 'Kostenschemaname Code';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        addafter("POI Cost Schema Name Code")
        {
            field("Vendor Invoice No.1"; "Vendor Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                ShowMandatory = true;
            }
            field("POI Status Customs Duty"; "POI Status Customs Duty")
            {
                Caption = 'Zollstatus';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field(POINumberofClaims; PurchaseClaimNotifyCount)
            {
                Caption = 'Anzahl Reklamationen';
                ApplicationArea = All;
                ToolTip = ' ';
                Editable = false;
            }
        }

        addafter(PurchLines)
        {
            group(transport1)
            {
                Caption = 'Transport';
                field("POI Shipping Company Code"; "POI Shipping Agent Code")
                {
                    Caption = 'Transportunternehmen';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Shipping Comp. Vendor No."; "POI Shipping Comp. Vendor No.")
                {
                    Caption = 'Reedereikreditorennr.';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        validate("POI Shipping Comp. Vendor No.", OnlookupVendor('SHIPPING'));
                    end;
                }
                field("POI Port of Loading Code"; "POI Port of Loading Code")
                {
                    Caption = 'Abgangshafen Code';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Port of Disch. Code (UDE)"; "POI Port of Disch. Code (UDE)")
                {
                    Caption = 'Löschhafen Code UDE';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Kind of Loading"; "POI Kind of Loading")
                {
                    Caption = 'Verladeart';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Container No."; "POI Container No.")
                {
                    Caption = 'Containernr.';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Pallet number"; "POI Pallet number")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Fiscal Agent Code"; "POI Fiscal Agent Code")
                {
                    Caption = 'Fiskalvertreter Code';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Validate("POI Fiscal Agent Code", OnlookupVendor('FISCAL'));
                    end;
                }
                field("POI Entry via Transf Loc. Code"; "POI Entry via Transf Loc. Code")
                {
                    Caption = 'Eingang über Zwischenlagercode';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Ship-Agent Code to Tra Loc"; "POI Ship-Agent Code to Tra Loc")
                {
                    Caption = 'Zustellercode bis Zwischenlager';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(PurchaseComplaint; PurchaseComplaint)
                {
                    Caption = 'EK-Reklamation vorh.';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnValidate()
                    begin
                        CreateAndShowClaim();
                    end;
                }
                field("POI Claim Document Date"; "POI Claim Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
        //addafter("Ship-to Contact")
        addafter(Control83)
        {
            field("POI Receipt Info"; "POI Receipt Info")
            {
                Caption = 'Info Lieferung';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Manufacturer Code"; "POI Manufacturer Code")
            {
                Caption = 'Hersteller Code';
                ApplicationArea = All;
                ToolTip = ' ';

            }
            field("POI Country of Origin Code"; "POI Country of Origin Code")
            {
                Caption = 'Erzeugerland';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Cultivation Associat. Code"; "POI Cultivation Associat. Code")
            {
                Caption = 'Anbauverbands Code';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Appendix Shipment Method"; "POI Appendix Shipment Method")
            {
                Caption = 'Zusatzlieferbedingung';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("POI Appendix Shipment Method"; "Lead Time Calculation")
        moveafter("Lead Time Calculation"; "Promised Receipt Date")
        addafter("Promised Receipt Date")
        {
            field("POI Quality Control Vendor No."; "POI Quality Control Vendor No.")
            {
                Caption = 'Qualitätskontr. Kreditornr.';
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnLookup(var Text: Text): Boolean
                begin
                    Validate("POI Quality Control Vendor No.", OnlookupVendor('QUALITY'));
                end;
            }
        }
        moveafter("POI Quality Control Vendor No."; "Sell-to Customer No.")
        moveafter("Sell-to Customer No."; "Ship-to Code")

        addafter("Shipping and Payment")
        {
            group("Payment")
            {
                field(Dummy3; Dummy3)
                {
                    Caption = ' ';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Visible = false;
                }
            }
        }
        moveafter(Dummy3; Paytooptions)
        moveafter(PayToOptions; "Pay-to Name")
        moveafter("Pay-to Name"; "Pay-to Address")
        moveafter("Pay-to Address"; "Pay-to Post Code")
        moveafter("Pay-to Post Code"; "Pay-to City")
        moveafter("Pay-to City"; "Pay-to Country/Region Code")
        moveafter("Pay-to Country/Region Code"; "Pay-to Contact No.")
        moveafter("Pay-to Contact No."; "Pay-to Contact")
        moveafter("Pay-to Contact"; "Vendor Invoice No.")
        addafter("Vendor Invoice No.")
        {
            grid(DiffOriginal)
            {
                GridLayout = Columns;

                field("POI Original Invoice Amount"; "POI Original Invoice Amount")
                {
                    Caption = 'Original Rechnungsbetrag';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Reason Code"; "POI Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Caption = 'Differenzgrund';
                }
            }
            grid(Apply)
            {
                field("POI Applies to Difference"; "POI Applies to Difference")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI open Differences"; "POI open Differences")
                {
                    Caption = 'Offene Differenzen';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(PartieDifferenceF; PartieDifference)
                {
                    Caption = 'PartieDifference';
                    ShowCaption = false;
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }
            }
        }
        moveafter(Apply; "Shortcut Dimension 1 Code")
        moveafter("Shortcut Dimension 1 Code"; "Shortcut Dimension 2 Code")
        addafter("Shortcut Dimension 2 Code")
        {
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                Editable = false;
            }
        }
        moveafter("Gen. Bus. Posting Group"; "VAT Bus. Posting Group")
        addafter("VAT Bus. Posting Group")
        {
            field("Vendor Posting Group"; "Vendor Posting Group")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                Editable = false;
            }
        }
        moveafter("Vendor Posting Group"; "Payment Terms Code")
        moveafter("Payment Terms Code"; "Due Date")
        moveafter("Due Date"; "Payment Discount %")
        moveafter("Payment Discount %"; "Pmt. Discount Date")
        moveafter("Pmt. Discount Date"; "Payment Method Code")
        moveafter("Payment Method Code"; "On Hold")
        moveafter("On Hold"; Status)


        movefirst("Foreign Trade"; "Currency Code")
        moveafter("Currency Code"; "Transaction Specification")
        moveafter("Transaction Specification"; "Transaction Type")
        moveafter("Transaction Type"; "Transport Method")
        moveafter("Transport Method"; "Entry Point")
        moveafter("Entry Point"; "Area")
        addafter("Area")
        {
            field("POI EU Dreiecksgeschäft"; "POI EU Dreiecksgeschäft")
            {
                Caption = 'EU Dreiecksgeschäft';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            group(Customs)
            {
                Caption = 'Zoll';

                field("POI Status Customs Duty1"; "POI Status Customs Duty")
                {
                    Caption = 'Status Zoll';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Clearing by Vendor No."; "POI Clearing by Vendor No.")
                {
                    Caption = 'Verzollung durch Kreditornr.';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        validate("POI Clearing by Vendor No.", OnlookupVendor('CUSTOMS'));
                    end;
                }

                // field("POI Fiscal Agent Code1"; "POI Fiscal Agent Code")
                // {
                //     Caption = 'Fiscalvertreter Code';
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                //  trigger OnLookup(var Text: Text): Boolean
                //         begin
                //             Validate("POI Fiscal Agent Code", OnlookupVendor('FISCAL'));
                //         end;
                // }
            }
            group(Waste)
            {
                Caption = 'Entsorgung';

                field("POI Waste Disposal Duty1"; "POI Waste Disposal Duty")
                {
                    Caption = 'Entsorgungspflichtig';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Waste Disposal Paymt Thru1"; "POI Waste Disposal Paymt Thru")
                {
                    Caption = 'Entsorgung Zahlung durch';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }

        modify("Expected Receipt Date")
        {
            Visible = false;
        }
        modify("Posting Date")
        {
            Visible = false;
        }
        modify("Order Date")
        {
            Visible = false;
        }
        modify("Document Date")
        {
            Visible = false;
        }
        modify("Vendor Invoice No.")
        {
            Visible = true;
        }
        modify("No. of Archived Versions")
        {
            Visible = false;
        }
        modify("Quote No.")
        {
            Visible = false;
        }
        modify("Vendor Shipment No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Due Date")
        {
            Visible = false;
        }
        modify("Buy-from")
        {
            Visible = false;
        }
        modify("Buy-from Address")
        {
            Visible = true;
        }
        modify("Buy-from City")
        {
            Visible = true;
        }
        modify("Buy-from Country/Region Code")
        {
            Visible = true;
        }
        modify("Buy-from Vendor Name")
        {
            Visible = false;
        }
        modify("Order Address Code")
        {
            ShowCaption = false;
        }
        modify("Location Code")
        {
            Editable = false;
        }
        modify("Currency Code")
        {
            Editable = false;
            trigger OnLookup(var Text: Text): Boolean
            var
                Currency: Record Currency;
            begin
                Currency.SETFILTER(Code, '%1|%2', 'USD', 'CHF');
                IF Page.RUNMODAL(0, Currency) = ACTION::LookupOK THEN
                    VALIDATE("Currency Code", Currency.Code);
            end;
        }
        modify("Ship-to Address 2")
        {
            Visible = false;
        }
        modify("Shipping and Payment")
        {
            CaptionML = DEU = 'Lieferung';
        }
        modify("Pay-to Name")
        {
            Visible = true;
            trigger OnLookup(var Text: Text): Boolean
            begin
                validate("Pay-to Vendor No.", OnlookupVendor(''));
            end;
        }
        modify("Pay-to Address")
        {
            Visible = true;
        }
        modify("Pay-to City")
        {
            Visible = true;
        }
        modify("Pay-to Contact No.")
        {
            Visible = true;
        }
        modify("Pay-to Country/Region Code")
        {
            Visible = true;
        }
        modify("Pay-to Post Code")
        {
            Visible = true;
        }
        modify("Sell-to Customer No.")
        {
            Caption = 'Verk. an Deb.-Nr.';
            trigger OnLookup(var Text: Text): Boolean
            begin
                "Sell-to Customer No." := OnlookupCustomer('');
            end;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Buy-from Vendor No.")
        {
            Visible = false;
        }
    }

    actions
    {
        addafter(Warehouse)
        {
            action(POIPayToVendor)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                Caption = 'Zahlung an Kreditor';
                RunObject = page "Vendor Card";
                RunPageLink = "No." = field("Pay-to Vendor No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetLocationCountry();

        Clear(PurchaseClaimNotifyCount);
        PurchClaimNotifyHeader.Reset();
        PurchClaimNotifyHeader.SetCurrentKey("Purch. Order No.");
        PurchClaimNotifyHeader.SetRange("Purch. Order No.", "No.");
        PurchaseClaimNotifyCount := PurchClaimNotifyHeader.Count();

        PurchaseComplaint := PurchClaimNotifyHeader.Count() > 0;

        InvoiceDifference();
    end;

    procedure GetLocationCountry()
    begin
        if ("POI Departure Location Code" <> '') and Location.Get("POI Departure Location Code") then
            POIDepartureCountryCode := Location."Country/Region Code"
        else
            POIDepartureCountryCode := '';
    end;

    procedure CreateAndShowClaim()
    var
        PurchaseClaimNotifyCard: Page "POI Purchase Claim Notify Card";
    begin
        PurchClaimNotifyHeader1.Reset();
        PurchClaimNotifyHeader1.SETRANGE("Purch. Order No.", rec."No.");
        IF PurchClaimNotifyHeader1.FINDFIRST() THEN BEGIN
            CLEAR(PurchaseClaimNotifyCard);
            PurchaseClaimNotifyCard.SETRECORD(PurchClaimNotifyHeader1);
            PurchaseClaimNotifyCard.SETTABLEVIEW(PurchClaimNotifyHeader1);
            PurchaseClaimNotifyCard.LOOKUPMODE(TRUE);
            IF PurchaseClaimNotifyCard.RUNMODAL() = ACTION::LookupOK THEN;
            CLEAR(PurchaseClaimNotifyCard);
            PurchaseComplaint := TRUE;
        END ELSE
            IF CONFIRM(NoClaimExistsTxt, FALSE) THEN BEGIN
                PurchClaimNotifyHeader1.INIT();
                PurchClaimNotifyHeader1.RESET();
                PurchClaimNotifyHeader1.INSERT(TRUE);
                PurchClaimNotifyHeader1.VALIDATE("Purch. Order No.", "No.");
                PurchClaimNotifyHeader1.MODIFY();
                PurchaseComplaint := TRUE;
                COMMIT();
                CLEAR(PurchaseClaimNotifyCard);
                PurchaseClaimNotifyCard.SETRECORD(PurchClaimNotifyHeader1);
                PurchaseClaimNotifyCard.SETTABLEVIEW(PurchClaimNotifyHeader1);
                PurchaseClaimNotifyCard.LOOKUPMODE(TRUE);
                IF PurchaseClaimNotifyCard.RUNMODAL() = ACTION::LookupOK THEN;
                CLEAR(PurchaseClaimNotifyCard);
            END;
    end;

    procedure InvoiceDifference()
    begin
        CALCFIELDS("Amount Including VAT");
        IF Status > 0 THEN
            PartieDifference := "Amount Including VAT" - "POI Original Invoice Amount";
    end;

    procedure OnlookupVendor(TypeCode: code[20]): code[20]
    var
        VendorLP: page "Vendor List";
        Filterstring: Text[50];
    begin
        Vendor.Reset();
        if uppercase(CompanyName()) <> uppercase(POICompany.GetBasicCompany()) then begin
            POICompany.Get(CompanyName());
            FilterGroup(2);
            case Typecode of
                'CUSTOMS':
                    Vendor.SetRange("POI Customs Agent", true);
                'QUALITY':
                    Vendor.SetRange("POI Is Quality Controller", true);
                'SHIPPING':
                    Vendor.SetRange("POI Is Shipping Company", true);
                'SHIPAGENT':
                    Vendor.SetRange("POI Is Shipping Agent", true);
                'FISCAL':
                    Vendor.SetRange("POI Tax Representative", true);
            end;
            Vendor.SetFilter(Blocked, '%1|%2', Vendor.Blocked::" ", Vendor.Blocked::Payment);
            filterstring := StrSubstNo('*%1*', POICompany."Company System ID");
            Vendor.SetFilter("POI Company System Filter", Filterstring);
        end;
        VendorLP.SetTableView(Vendor);
        if VendorLP.RunModal() = action::OK then
            VendorLP.GetRecord(Vendor);
        exit(Vendor."No.");
    end;

    procedure OnlookupCustomer(TypeCode: code[20]): code[20]
    var
        CustomerLP: page "Customer List";
        Filterstring: Text[50];
    begin
        Customer.Reset();
        if uppercase(CompanyName()) <> uppercase(POICompany.GetBasicCompany()) then begin
            POICompany.Get(CompanyName());
            FilterGroup(2);
            case Typecode of
                'SERVICE':
                    Customer.SetRange("POI Service Customer", true);
                'GOODS':
                    Customer.SetRange("POI Goods Customer", true);
            end;
            Customer.SetRange(Blocked, Customer.Blocked::" ");
            filterstring := StrSubstNo('*%1*', POICompany."Company System ID");
            Customer.SetFilter("POI Company System Filter", Filterstring);
        end;
        CustomerLP.SetTableView(Customer);
        if CustomerLP.RunModal() = action::OK then
            CustomerLP.GetRecord(Customer);
        exit(Customer."No.");
    end;

    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        Location: Record Location;
        POICompany: Record "POI Company";
        PurchClaimNotifyHeader: Record "POI Purch. Claim Notify Header";
        PurchClaimNotifyHeader1: Record "POI Purch. Claim Notify Header";
        POIFunctions: Codeunit POIFunction;
        Dummy1: Code[1];
        Dummy2: Code[1];
        Dummy3: Code[1];

        POIDepartureCountryCode: Code[20];
        PartieDifference: Decimal;
        PurchaseClaimNotifyCount: Integer;
        PurchaseComplaint: Boolean;
        NoClaimExistsTxt: label 'Es wurde keine Reklamation gefunden, soll eine neue anglegt werden ?';


}