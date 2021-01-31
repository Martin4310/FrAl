pageextension 5110330 "POI Purchase List" extends "Purchase List"
{
    layout
    {
        addbefore("No.")
        {
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("No."; "Buy-from Vendor No.")
        moveafter("Buy-from Vendor No."; "Order Address Code")
        addafter("Order Address Code")
        {
            field("Your Reference"; "Your Reference")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Released for Claim"; "POI Released for Claim")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Released for Invoice"; "POI Released for Invoice")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("Vendor Order No."; "Vendor Order No.")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("Vendor Order No."; "Buy-from Vendor Name")
        moveafter("Buy-from Vendor Name"; "Vendor Authorization No.")
        moveafter("Vendor Authorization No."; "Buy-from Post Code")
        moveafter("Buy-from Post Code"; "Buy-from Country/Region Code")
        moveafter("Buy-from Country/Region Code"; "Buy-from Contact")
        moveafter("Buy-from Contact"; "Pay-to Vendor No.")
        moveafter("Pay-to Vendor No."; "Pay-to Name")
        moveafter("Pay-to Name"; "Pay-to Post Code")
        moveafter("Pay-to Post Code"; "Pay-to Country/Region Code")
        moveafter("Pay-to Country/Region Code"; "Pay-to Contact")
        moveafter("Pay-to Contact"; "Ship-to Code")
        moveafter("Ship-to Code"; "Ship-to Name")
        moveafter("Ship-to Name"; "Ship-to Post Code")
        moveafter("Ship-to Post Code"; "Ship-to Country/Region Code")
        moveafter("Ship-to Country/Region Code"; "Ship-to Contact")
        addafter("Ship-to Contact")
        {
            field("Vendor Shipment No."; "Vendor Shipment No.")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Manufacturer Code"; "POI Manufacturer Code")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Manufacturer Lot No."; "POI Manufacturer Lot No.")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Kind of Settlement"; "POI Kind of Settlement")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Person in Charge Code"; "POI Person in Charge Code")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("POI Person in Charge Code"; "Purchaser Code")
        addafter("Purchaser Code")
        {
            field("Order Date"; "Order Date")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("Expected Receipt Date"; "Expected Receipt Date")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Expected Receipt Time"; "POI Expected Receipt Time")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("POI Expected Receipt Time"; "Posting Date")
        addafter("Posting Date")
        {
            field("Shipment Method Code"; "Shipment Method Code")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Entry via Transf Loc. Code"; "POI Entry via Transf Loc. Code")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Ship-Agent Code to Tra Loc"; "POI Ship-Agent Code to Tra Loc")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Means of Transp.Code(Dep.)"; "POI Means of Transp.Code(Dep.)")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Means of Transport Type"; "POI Means of Transport Type")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Means of TransCode(Arriva)"; "POI Means of TransCode(Arriva)")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Means of Transport Info"; "POI Means of Transport Info")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Port of Disch. Code (UDE)"; "POI Port of Disch. Code (UDE)")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("POI Port of Disch. Code (UDE)"; "Location Code")
        addafter("Location Code")
        {
            field("POI Shipping Agent Code"; "POI Shipping Agent Code")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Status Customs Duty"; "POI Status Customs Duty")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Clearing by Vendor No."; "POI Clearing by Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Fiscal Agent Code"; "POI Fiscal Agent Code")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Quality Control Vendor No."; "POI Quality Control Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Total Gross Weight"; "POI Total Gross Weight")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }


        }
        moveafter("POI Total Gross Weight"; "Currency Code")
        addafter("Currency Code")
        {
            field("Currency Factor"; "Currency Factor")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("Currency Factor"; "Assigned User ID")
        moveafter("Assigned User ID"; "Shortcut Dimension 1 Code")
        addafter("Shortcut Dimension 1 Code")
        {
            field(Amount; Amount)
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("Completely Received"; "Completely Received")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Document Status"; "POI Document Status")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("POI Document Status"; "Shortcut Dimension 2 Code")
        addafter("Shortcut Dimension 2 Code")
        {
            field("POI Avise"; "POI Avise")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        modify("Buy-from Post Code")
        {
            Visible = true;
        }
        modify("Buy-from Country/Region Code")
        {
            Visible = true;
        }
        modify("Buy-from Contact")
        {
            Visible = true;
        }
        modify("Pay-to Vendor No.")
        {
            Visible = true;
        }
        modify("Pay-to Name")
        {
            Visible = true;
        }
        modify("Pay-to Country/Region Code")
        {
            Visible = true;
        }
        modify("Pay-to Contact")
        {
            Visible = true;
        }
        modify("Pay-to Post Code")
        {
            Visible = true;
        }
        modify("Ship-to Code")
        {
            Visible = true;
        }
        modify("Ship-to Name")
        {
            Visible = true;
        }
        modify("Ship-to Post Code")
        {
            Visible = true;
        }
        modify("Ship-to Country/Region Code")
        {
            Visible = true;
        }
        modify("Ship-to Contact")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Purchaser Code")
        {
            Visible = true;
        }
        modify("Currency Code")
        {
            Visible = true;
        }
        modify("Order Address Code")
        {
            Visible = true;
        }
    }

    actions
    {
        addlast(Processing)
        {
            action("Change Doc Subtype")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    Message('Wechsel Doc Subtype');
                end;
            }
        }
    }
}