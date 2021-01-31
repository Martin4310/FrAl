table 5110448 "POI Reservation Header"
{

    Caption = 'Reservation Header';
    // DrillDownFormID = Form5110495;
    // LookupFormID = Form5110495;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(9; "Source Reservation"; Option)
        {
            Caption = 'Source Reservation';
            OptionCaption = 'Sale,Transfer,Packerei,Feature Assortment,Block Goods,User Internal,Other';
            OptionMembers = Sale,Transfer,Packerei,"Feature Assortment","Block Goods","User Internal",Other;

            trigger OnValidate()
            var
                lrc_ResLine: Record "POI Reservation Line";
            begin
                IF "Source Reservation" <> xRec."Source Reservation" THEN BEGIN
                    lrc_ResLine.SETRANGE("Res. No.", "No.");
                    IF NOT lrc_ResLine.ISEMPTY() THEN
                        ERROR('Es sind bereits Zeilen erfaßt. Änderung nicht zulässig!');
                END ELSE
                    EXIT;

                VALIDATE("Sales to Customer No.", '');
                VALIDATE("Transfer-To Loc. Code", '');
                "Packing Order No." := '';
                "Sales Claim No." := '';
                VALIDATE("Location Code", '');

                CASE "Source Reservation" OF
                    "Source Reservation"::Sale:
                        ;
                    "Source Reservation"::Transfer:
                        ;
                    "Source Reservation"::Packerei:
                        ;
                    "Source Reservation"::"Block Goods":
                        ;
                    "Source Reservation"::Other:
                        ERROR('Nicht zulässig!');
                END;
            end;
        }
        field(10; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF ("Source Reservation" = CONST(Sale)) Customer
            ELSE
            IF ("Source Reservation" = CONST(Transfer)) Location
            ELSE
            IF ("Source Reservation" = CONST(Packerei)) "POI Pack. Order Header";

            trigger OnValidate()
            var
                lrc_ReservationLine: Record "POI Reservation Line";
            begin
                IF "Source No." <> xRec."Source No." THEN BEGIN
                    lrc_ReservationLine.SETRANGE("Res. No.", "No.");
                    IF NOT lrc_ReservationLine.ISEMPTY THEN
                        ERROR('Es sind bereits Zeilen erfaßt. Änderung nicht zulässig!');

                END ELSE
                    EXIT;

                Name := '';
                "Name 2" := '';
                Adress := '';
                "Adress 2" := '';
                "Country Code" := '';
                "Post Code" := '';
                City := '';
                "Contact Name" := '';

                CASE "Source Reservation" OF
                    "Source Reservation"::Sale:
                        VALIDATE("Sales to Customer No.", "Source No.");
                    "Source Reservation"::Transfer:
                        VALIDATE("Transfer-To Loc. Code", "Source No.");
                    "Source Reservation"::Packerei:
                        VALIDATE("Packing Order No.", "Source No.");
                    "Source Reservation"::"Feature Assortment":
                        ERROR('');
                    "Source Reservation"::"Block Goods":
                        ERROR('');
                    "Source Reservation"::"User Internal":
                        ERROR('');
                    "Source Reservation"::Other:
                        ERROR('');
                END;
            end;
        }
        field(20; "Sales to Customer No."; Code[20])
        {
            Caption = 'Reservation for Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                lrc_Customer: Record Customer;
            begin
                IF ("Source Reservation" <> "Source Reservation"::Sale) AND
                   ("Sales to Customer No." <> '') THEN BEGIN
                    "Sales to Customer No." := '';
                    MESSAGE('Eingabe für gewählte Reservierung nicht zulässig!');
                END ELSE BEGIN
                    IF "Sales to Customer No." <> '' THEn BEGIN
                        lrc_Customer.GET("Sales to Customer No.");
                        Name := lrc_Customer.Name;
                        "Name 2" := lrc_Customer."Name 2";
                        Adress := lrc_Customer.Address;
                        "Adress 2" := lrc_Customer."Address 2";
                        "Country Code" := lrc_Customer."Country/Region Code";
                        "Post Code" := lrc_Customer."Post Code";
                        City := lrc_Customer.City;
                        "Contact Name" := lrc_Customer.Contact;
                    END;

                    // Zeilen aktualisieren
                    lrc_ResLine.SETRANGE("Res. No.", "No.");
                    IF lrc_ResLine.FINDSET(TRUE, FALSE) THEN
                        REPEAT
                            lrc_ResLine."Transfer-To Loc. Code" := '';
                            lrc_ResLine."Sales to Customer No." := "Sales to Customer No.";
                            lrc_ResLine.MODIFY();
                        UNTIL lrc_ResLine.NEXT() = 0;
                END;
            end;
        }
        field(21; "Transfer-To Loc. Code"; Code[10])
        {
            Caption = 'Transfer-To Loc. Code';
            TableRelation = Location;

            trigger OnValidate()
            var
                lrc_Location: Record Location;
            begin
                IF ("Source Reservation" <> "Source Reservation"::Transfer) AND
                   ("Transfer-To Loc. Code" <> '') THEN BEGIN
                    "Transfer-To Loc. Code" := '';
                    MESSAGE('Eingabe für gewählte Reservierung nicht zulässig!');
                END ELSE BEGIN
                    IF "Transfer-To Loc. Code" <> '' THEN BEGIN
                        lrc_Location.GET("Transfer-To Loc. Code");
                        Name := lrc_Location.Name;
                        "Name 2" := lrc_Location."Name 2";
                        Adress := lrc_Location.Address;
                        "Adress 2" := lrc_Location."Address 2";
                        "Country Code" := lrc_Location."Country/Region Code";
                        "Post Code" := lrc_Location."Post Code";
                        City := lrc_Location.City;
                        "Contact Name" := lrc_Location.Contact;
                    END;

                    // Zeilen aktualisieren
                    lrc_ResLine.SETRANGE("Res. No.", "No.");
                    IF lrc_ResLine.FINDSET(TRUE, FALSE) THEN
                        REPEAT
                            lrc_ResLine."Transfer-To Loc. Code" := "Transfer-To Loc. Code";
                            lrc_ResLine."Sales to Customer No." := '';
                            lrc_ResLine.MODIFY();
                        UNTIL lrc_ResLine.NEXT() = 0;
                END;
            end;
        }
        field(22; "Packing Order No."; Code[20])
        {
            Caption = 'Packing Order No.';
            TableRelation = "POI Pack. Order Header";
        }
        field(25; "Sales Claim No."; Code[20])
        {
            Caption = 'Sales Claim No.';
            TableRelation = "POI Sales Claim Notify Header";
        }
        field(29; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(50; "Date of Reservation"; Date)
        {
            Caption = 'Date of Reservation';
        }
        field(51; "Reserved Up To Date"; Date)
        {
            Caption = 'Reserved Up To Date';
        }
        field(52; "Reserved Up To Time"; Time)
        {
            Caption = 'Reserved Up To Time';
        }
        field(55; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser" WHERE("POI Is Salesperson" = CONST(true));
        }
        field(56; "Person in Charge Code"; Code[20])
        {
            Caption = 'Person in Charge Code';
            TableRelation = "Salesperson/Purchaser" WHERE("POI Is Person in Charge" = CONST(true));
        }
        field(75; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(76; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(88; "Your Reference"; Text[70])
        {
            Caption = 'Your Reference';
        }
        field(100; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(200; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(201; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(202; Adress; Text[100])
        {
            Caption = 'Address';
        }
        field(203; "Adress 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(206; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            TableRelation = "Country/Region";
        }
        field(207; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
        }
        field(208; City; Text[30])
        {
            Caption = 'City';
        }
        field(209; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
        }
        field(210; "Contact Name"; Text[100])
        {
            Caption = 'Contact Name';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        lrc_ResLine.RESET();
        lrc_ResLine.SETRANGE("Res. No.", "No.");
        lrc_ResLine.SETRANGE("Typ of Reservation", "Source Reservation");
        IF NOT lrc_ResLine.ISEMPTY THEN
            lrc_ResLine.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    var
        lrc_ADFSetup: Record "POI ADF Setup";
        lcu_NoSeriesMgt: Codeunit NoSeriesManagement;
        lcu_BaseData: Codeunit "POI Base Data Mgt";
    begin
        IF "No." = '' THEN BEGIN
            lrc_ADFSetup.GET();
            lrc_ADFSetup.TESTFIELD("No. Series Reservation");
            lcu_NoSeriesMgt.InitSeries(lrc_ADFSetup."No. Series Reservation", xRec."No. Series", TODAY, "No.", "No. Series");
            TESTFIELD("No.");
        END;

        "Date of Reservation" := TODAY;
        "Reserved Up To Date" := TODAY;
        "Person in Charge Code" := lcu_BaseData.GetPersonInCharge();
        "Salesperson Code" := lcu_BaseData.GetSalesman();
    end;

    trigger OnRename()
    begin
        ERROR('Umbennenung nicht zulässig!');
    end;

    var
        lrc_ResLine: Record "POI Reservation Line";
}

