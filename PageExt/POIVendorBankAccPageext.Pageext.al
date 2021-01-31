pageextension 50024 "POI Vendor Bank Acc. Pageext" extends "Vendor Bank Account Card"
{
    layout
    {
        addlast(General)
        {
            group(AccountCheckgrp)
            {
                Caption = 'Kontoverifikation';
                grid(BankAccountCheckgrid)
                {
                    label(BankAccCheckLabel)
                    {
                        Caption = 'Ein authentischer, ordnungsgemäß unterzeichneter Auftrag zur Bankverbindung liegt vor, ist archiviert und der Kontoinhaber stimmt mit dem Kreditor überein”.';
                    }
                    field("POI BankAccountChecked"; "POI BankAccountChecked")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
                field("POI AccCheckUser"; "POI AccCheckUser")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI AccCheck DateTime"; "POI AccCheck DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

                grid(VeriCall)
                {
                    label(VeriCallLabel)
                    {
                        Caption = 'Verifikationsanruf';
                    }
                    field("POI Verifikationsanruf"; "POI Verifikationsanruf")
                    {
                        Caption = 'Verifikationsanruf';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(VeriName)
                {
                    label(VeriNameLabel)
                    {
                        Caption = 'Name der angerufenen Person';
                    }
                    field("POI Verifikationsanruf Name"; "POI Verifikationsanruf Name")
                    {
                        Caption = 'Name der angerufenen Person';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(VeriPhoneno)
                {
                    label(VeriPhoneLabel)
                    {
                        Caption = 'Telefonnr. der angerufenen Person';
                    }
                    field("POI Verifikat. Anruf Tel. Nr."; "POI Verifikat. Anruf Tel. Nr.")
                    {
                        Caption = 'Telefonnr. der angerufenen Person';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(VeriPhoneSource)
                {
                    label(VeriPhoneSourceLabel)
                    {
                        Caption = 'Quelle der Telefonnr.';
                    }
                    field("POI Verianruf Quelle Tel."; "POI Verianruf Quelle Tel.")
                    {
                        Caption = 'Quelle der Telefonnr.';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(verification)
                {
                    label(verificationlabel)
                    {
                        Caption = 'Verifikationsanruf durch Mitarbeiter am';
                    }
                    field("POI Verifikationsanruf User"; "POI Verifikationsanruf User")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                    field("POI VerifikatsanrufDatZeit"; "POI VerifikatsanrufDatZeit")
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }

                }
            }
        }
        modify("Bank Clearing Standard")
        {
            Visible = false;
        }
        modify("Bank Clearing Code")
        {
            Visible = false;
        }
        modify("Bank Branch No.")
        {
            Visible = false;
        }
        modify("Home Page")
        {
            Visible = false;
        }
        moveafter("E-Mail"; "Phone No.")
        moveafter("Phone No."; "Fax No.")

        modify(Name)
        {
            ShowMandatory = true;
        }
        modify(Address)
        {
            ShowMandatory = "Bank Account No." <> '';
        }
        modify("Country/Region Code")
        {
            ShowMandatory = true;
        }
        modify("Currency Code")
        {
            ShowMandatory = true;
        }
        modify("Bank Account No.")
        {
            ShowMandatory = IBAN = '';
        }
        modify("Post Code")
        {
            ShowMandatory = "Bank Account No." <> '';
        }
        modify(City)
        {
            ShowMandatory = "Bank Account No." <> '';
        }
    }
    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Vendor.Get("Vendor No.");
        if not (Vendor."Payment Method Code" IN ['SEPA', 'SEPA-I', 'SEPA-EILIG']) and (IBAN = '') and not Deleted then
            if Code <> '' then begin
                CheckMandFields();
                CheckSwift();
            end;

    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Deleted := true;
    end;

    procedure CheckMandFields()
    begin
        Vendor.Get("Vendor No.");
        MandTxt := '';
        if Name = '' then
            MandTxt += 'Name /';
        if ("Bank Account No." <> '') then begin
            if City = '' then
                MandTxt += 'Ort /';
            if Address = '' then
                MandTxt += 'Adresse /';
            if "Post Code" = '' Then
                MandTxt += 'PLZ /';
        end;
        if (("Bank Account No." = '') and (Vendor."Payment Method Code" = 'SWIFTEILIG')) or (IBAN <> '') then
            MandTxt += 'Bankkontonr. /';
        if "Currency Code" = '' then
            MandTxt += 'Währung /';
        if "Country/Region Code" = '' then
            MandTxt += 'Land /';
        if MandTxt <> '' then
            Error(MandTxt);
    end;

    procedure CheckSwift()
    var
        Country: Record "Country/Region";
    begin
        Country.Get("Country/Region Code");
        if (Country."POI IBAN numbers" = 0) and (("SWIFT Code" = '') or ("Bank Account No." = '')) then
            Error('Swift-Code oder Bankkonto fehlen')
        else
            if IBAN = '' then
                error('IBAN muss angegeben werden.');
    end;

    var
        Vendor: Record Vendor;
        MandTxt: Text[100];
        Deleted: Boolean;
}
