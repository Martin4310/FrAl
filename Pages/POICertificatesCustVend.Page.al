page 50015 "POI Certificates Cust./Vend."
{
    Caption = 'QM-Übersicht';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "POI Certificates Cust./Vend.";
    DataCaptionExpression = Showcaption();

    layout
    {
        area(Content)
        {
            group(Account)
            {
                // field(Source; Source)
                // {
                //     Caption = 'Herkunftsart';
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                //     Editable = false;
                // }
                // field("Source No."; "Source No.")
                // {
                //     Caption = 'Herkunftsnr.';
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                //     Editable = false;
                // }
                // field("Source Name"; "Source Name")
                // {
                //     Caption = 'Name';
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                //     Editable = false;
                // }
                //     field("Source Name 2"; "Source Name 2")
                //     {
                //         Caption = 'Name 2';
                //         ApplicationArea = All;
                //         ToolTip = ' ';
                //     }
            }
            repeater(GroupName)
            {
                field("Internal ID"; "Internal ID")
                {
                    Caption = 'Interne Nummer';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    visible = false;
                }
                field(Source; Source)
                {
                    Caption = 'Herkunftsart';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }
                field("Source No."; "Source No.")
                {
                    Caption = 'Herkunftsnr.';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }
                field("Source Name"; "Source Name")
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }
                field("Source Name 2"; "Source Name 2")
                {
                    Caption = 'Name 2';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                // field("Manufacturer No."; "Manufacturer No.")
                // {
                //     Caption = 'Hersteller';
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                //     Visible = false;
                // }
                field("Certification Typ Code"; "Certification Typ Code")
                {
                    Caption = 'Zertifikatstyp';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                // field("Country of Origin Code"; "Country of Origin Code")
                // {
                //     Caption = 'Herkunftsland';
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                //     Visible = false;
                // }
                // field("No. of Prod.-Grp Restrictions"; "No. of Prod.-Grp Restrictions")
                // {
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                //     Visible = false;
                // }
                // field("Source No. 2"; "Source No. 2")
                // {
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                //     Visible = false;
                // }
                // field("Item No."; "Item No.")
                // {
                //     Caption = 'Artikelnr.';
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                //     Visible = false;
                // }
                field("Certification No."; "Certification No.")
                {
                    Caption = 'Zertifikatsnr.';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Valid From"; "Valid From")
                {
                    Caption = 'gültig ab';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Valid Untill"; "Valid Untill")
                {
                    Caption = 'gültig bis';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Date of Receiving"; "Date of Receiving")
                {
                    Caption = 'Empfangsdatum:';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Comment; Comment)
                {
                    Caption = 'Bemerkung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Status; Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Print on Label"; "Print on Label")
                {
                    Caption = 'Etikettendruck';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                // field("Print Priority"; "Print Priority")
                // {
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                // }
            }
            part("POI certif Cust/vend Chapter"; "POI certif. Cust/Vend Chapter")
            {
                SubPageLink = "Entry No." = field("Entry No.");
                Editable = false;
            }
        }
    }
    procedure showcaption(): Text
    begin
        exit(Format(Source) + ' ' + "Source No." + ' ' + "Source Name" + ' ' + "Source Name 2");
    end;
}