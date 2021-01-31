pageextension 50020 "POI Bank Account Card" extends "Bank Account Card"
{
    layout
    {
        moveafter("Bank Account No."; IBAN)
        moveafter("Bank Clearing Code"; "SWIFT Code")
        modify(Name)
        {
            ShowMandatory = true;
        }
        modify("Bank Clearing Code")
        {
            Visible = false;
        }
        modify(Address)
        {
            ShowMandatory = true;
        }
        modify(City)
        {
            ShowMandatory = true;
        }
        modify("Post Code")
        {
            ShowMandatory = true;
        }
        modify("Bank Clearing Standard")
        {
            Visible = false;
        }
        modify("Home Page")
        {
            Visible = false;
        }
        modify("Bank Account No.")
        {
            ShowMandatory = true;
        }
        modify("Currency Code")
        {
            ShowMandatory = true;
        }
        modify("SWIFT Code")
        {
            ShowMandatory = true;
        }
        modify(IBAN)
        {
            ShowMandatory = true;
        }
        modify("Bank Statement Import Format")
        {
            ShowMandatory = true;
        }
        modify("Payment Export Format")
        {
            ShowMandatory = true;
        }
        modify("SEPA Direct Debit Exp. Format")
        {
            visible = false;
        }
        modify("Our Contact Code")
        {
            visible = false;
        }
        modify("Creditor No.")
        {
            visible = false;
        }
        modify("Bank Branch No.")
        {
            Visible = false;
        }
        modify("Country/Region Code")
        {
            ShowMandatory = true;
        }
        modify("Transit No.")
        {
            Visible = false;
        }
    }

    actions
    {
    }
}