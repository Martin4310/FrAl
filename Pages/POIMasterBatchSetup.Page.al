page 5110301 "POI Master Batch Setup"
{
    Caption = 'Master Batch Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "POI Master Batch Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Allgemein';
                field("Dim. Code Batch No."; "Dim. Code Batch No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Dim. No. Batch No."; "Dim. No. Batch No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Dim. Code Cost Category"; "Dim. Code Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Dim. No. Cost Category"; "Dim. No. Cost Category")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Sales Page ID Batch Var. List"; "Sales Page ID Batch Var. List")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Sales Page ID Matrix Criteria"; "Sales Page ID Matrix Criteria")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Sales Page ID Matrix"; "Sales Page ID Matrix")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Sales Page ID Sales Line"; "Sales Page ID Sales Line")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("P. Cr.Memo Page ID Purch. Line"; "P. Cr.Memo Page ID Purch. Line")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Page ID Batch Detail Stat"; "Page ID Batch Detail Stat")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Sales Batch Assignment"; "Sales Batch Assignment")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Purch. Plan Master Batch No."; "Purch. Plan Master Batch No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Purch. Plan Batch No. Series"; "Purch. Plan Batch No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Page ID Pos.-Var. List"; "Page ID Pos.-Var. List")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Page ID Pos.-Var. Serach List"; "Page ID Pos.-Var. Serach List")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Batch Stockout Warning"; "Batch Stockout Warning")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Dummy Batch Variant No."; "Dummy Batch Variant No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Put Batch Var. Changes to Sale"; "Put Batch Var. Changes to Sale")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Set Batch Var. Closed when"; "Set Batch Var. Closed when")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Batchsystem activ"; "Batchsystem activ")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Purch. Alloc. thru Doc. Type"; "Purch. Alloc. thru Doc. Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Res. Page ID Reservation Line"; "Res. Page ID Reservation Line")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Res. Page ID Batch Var. List"; "Res. Page ID Batch Var. List")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Res. Page ID Matrix"; "Res. Page ID Matrix")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Batch Var. No. Series"; "Batch Var. No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Batch Var. Detail No. Series"; "Batch Var. Detail No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
            group(Sortiment)
            {
                field("Assort. Master Batch No."; "Assort. Master Batch No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Assort. Batch No. Series"; "Assort. Batch No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Assort. Source Batch Variant"; "Assort. Source Batch Variant")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Assort. Batch Var. No Series"; "Assort. Batch Var. No Series")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Assort. Batch Var. Separator"; "Assort. Batch Var. Separator")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Assort. Batch V. PostfixPlaces"; "Assort. Batch V. PostfixPlaces")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                group(Transit)
                {
                    caption = 'Transfer';
                    field("Trans. Page ID Matrix"; "Trans. Page ID Matrix")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Trans. Page ID Transfer Line"; "Trans. Page ID Transfer Line")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Trans. Page ID Batch Var. List"; "Trans. Page ID Batch Var. List")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Trans. Page ID Matrix Criteria"; "Trans. Page ID Matrix Criteria")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
                group(SalesNotice)
                {

                    field("Sales Stat. No. Series"; "Sales Stat. No. Series")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Sales Stat. Posted No. Series"; "Sales Stat. Posted No. Series")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Sales Stat. Purchase"; "Sales Stat. Purchase")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Sales Stat. Sales"; "Sales Stat. Sales")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Sales Stat. Econ. Can"; "Sales Stat. Econ. Can")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Sa. Stat. Line not Del. AfterP"; "Sa. Stat. Line not Del. AfterP")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Sales Stat. Line not Del. Qty0"; "Sales Stat. Line not Del. Qty0")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
                group(BatchCalculation)
                {

                    field("Acc. Sales Post Acc. Sales"; "Acc. Sales Post Acc. Sales")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Write Back in P.Ord"; "Acc. Sales Write Back in P.Ord")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales No. Series"; "Acc. Sales No. Series")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Posted No. Series"; "Acc. Sales Posted No. Series")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Default Quantity"; "Acc. Sales Default Quantity")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Qty of Sales"; "Acc. Sales Qty of Sales")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Qty of Purchase"; "Acc. Sales Qty of Purchase")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Purch. Qty. Rec."; "Acc. Sales Purch. Qty. Rec.")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Cost Category Com 1"; "Acc. Sales Cost Category Com 1")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Cost Category Com 2"; "Acc. Sales Cost Category Com 2")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Cost Category Com 3"; "Acc. Sales Cost Category Com 3")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Cr.Memo Inland"; "Acc. Sales Cr.Memo Inland")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Cr.Memo EU"; "Acc. Sales Cr.Memo EU")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Cr.Memo Ausland"; "Acc. Sales Cr.Memo Ausland")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Posting Type Neg. Acc. Sales"; "Posting Type Neg. Acc. Sales")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("CrM. ItemCharge neg. Acc.Sales"; "CrM. ItemCharge neg. Acc.Sales")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Cost Cat. Refund"; "Acc. Sales Cost Cat. Refund")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales No. Series Refund"; "Acc. Sales No. Series Refund")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Gen. Jnl. Temp. Name Refund"; "Gen. Jnl. Temp. Name Refund")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Gen. Jnl. Batch Refund"; "Gen. Jnl. Batch Refund")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Cost Schema"; "Acc. Sales Cost Schema")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Print Post. P.Order"; "Acc. Sales Print Post. P.Order")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Print Post. C.Memo"; "Acc. Sales Print Post. C.Memo")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. S. Kind of Pur.Price Calc"; "Acc. S. Kind of Pur.Price Calc")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales No. Series Profit S"; "Acc. Sales No. Series Profit S")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Gen. Jnl. Temp. Name Prof.Spli"; "Gen. Jnl. Temp. Name Prof.Spli")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Gen. Jnl. Batch Prof. Split"; "Gen. Jnl. Batch Prof. Split")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Acc. Sales Card Page ID"; "Acc. Sales Card Page ID")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
                group(Packerei)
                {
                    Caption = 'Packerei';


                    field("Pack. Master Batch No. Series"; "Pack. Master Batch No. Series")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Pack. Batch No. Series"; "Pack. Batch No. Series")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Pack. Allocation Batch No."; "Pack. Allocation Batch No.")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("P.O. Page ID Pack. Inp. Line"; "P.O. Page ID Pack. Inp. Line")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("P.O. Page ID Batch Var. List"; "P.O. Page ID Batch Var. List")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("P.O. Page ID Matrix"; "P.O. Page ID Matrix")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("P.O. Page ID Matrix Criteria"; "P.O. Page ID Matrix Criteria")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Subst. Master Batch No. Series"; "Subst. Master Batch No. Series")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Subst. Batch No. Series"; "Subst. Batch No. Series")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Subst. Allocation Batch No."; "Subst. Allocation Batch No.")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("IJnlLi Allocation Master Batch"; "IJnlLi Allocation Master Batch")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("IJnlLi Source Master Batch"; "IJnlLi Source Master Batch")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("IJnlLi Master Batch No. Series"; "IJnlLi Master Batch No. Series")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("IJnlLi Allocation Batch No."; "IJnlLi Allocation Batch No.")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("IJnlLi Source Batch No."; "IJnlLi Source Batch No.")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("IJnlLi Batch No. Series"; "IJnlLi Batch No. Series")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("IJnlLi Source Batch Variant"; "IJnlLi Source Batch Variant")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("IJnlLi Batch Variant No Series"; "IJnlLi Batch Variant No Series")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
                group(PosVarInfo)
                {
                    field("B.I.S. Page ID"; "B.I.S. Page ID")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("B.I.S. Cust. Pr.-Grp. 1"; "B.I.S. Cust. Pr.-Grp. 1")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("B.I.S. Cust. Pr.-Grp. 2"; "B.I.S. Cust. Pr.-Grp. 2")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("B.I.S. Cust. Pr.-Grp. 3"; "B.I.S. Cust. Pr.-Grp. 3")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("B.I.S. Marge 1"; "B.I.S. Marge 1")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("B.I.S. Marge 2"; "B.I.S. Marge 2")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("B.I.S. Marge 3"; "B.I.S. Marge 3")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("ExpAvail. Stock incl. SalesCrM"; "ExpAvail. Stock incl. SalesCrM")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }


                    field("ExpAvail. Stock incl. PurchCrM"; "ExpAvail. Stock incl. PurchCrM")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Avail. Stock incl. Sales Cr. M"; "Avail. Stock incl. Sales Cr. M")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("Avail. Stock incl. Purch Cr. M"; "Avail. Stock incl. Purch Cr. M")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
            }
        }
    }
}