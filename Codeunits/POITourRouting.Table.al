table 5110436 "POI Tour Routing"
{

    Caption = 'Tour Routing';
    // DrillDownFormID = Form5110601;
    // LookupFormID = Form5110601;

    fields
    {
        field(1; "Tour No."; Code[10])
        {
            Caption = 'Tour No.';
            TableRelation = "POI Tour";
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Destination Type"; Option)
        {
            Caption = 'Destination Type';
            Description = 'Customer,,Vendor,,Location';
            OptionCaption = 'Customer,,Vendor,,Location';
            OptionMembers = Customer,,Vendor,,Location;

            trigger OnValidate()
            begin
                IF "Destination Type" <> xRec."Destination Type" THEN BEGIN
                    "Destination Code" := '';
                    "Destination Subcode" := '';
                    "Destination Name" := '';
                    "Destination Search Name" := '';
                    "Destination City" := '';
                END;
            end;
        }
        field(11; "Destination Code"; Code[20])
        {
            Caption = 'Destination Code';
            TableRelation = IF ("Destination Type" = CONST(Customer)) Customer
            ELSE
            IF ("Destination Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Destination Type" = CONST(Location)) Location;

            trigger OnValidate()
            var
                lrc_Customer: Record Customer;
                lrc_Vendor: Record Vendor;
                lrc_Location: Record Location;
            begin
                IF "Destination Code" <> xRec."Destination Code" THEN
                    "Destination Subcode" := '';

                IF "Destination Code" = '' THEN BEGIN
                    "Destination Name" := '';
                    "Destination Search Name" := '';
                    "Destination City" := '';
                END ELSE
                    CASE "Destination Type" OF
                        "Destination Type"::Customer:
                            BEGIN
                                lrc_Customer.GET("Destination Code");
                                "Destination Name" := lrc_Customer.Name;
                                "Destination Search Name" := lrc_Customer."Search Name";
                                "Destination City" := lrc_Customer.City;
                            END;
                        "Destination Type"::Vendor:
                            BEGIN
                                lrc_Vendor.GET("Destination Code");
                                "Destination Name" := lrc_Vendor.Name;
                                "Destination Search Name" := lrc_Vendor."Search Name";
                                "Destination City" := lrc_Vendor.City;
                            END;
                        "Destination Type"::Location:
                            BEGIN
                                lrc_Location.GET("Destination Code");
                                "Destination Name" := lrc_Location.Name;
                                "Destination Search Name" := lrc_Location."POI Search Name";
                                "Destination City" := lrc_Location.City;
                            END;
                    END;

            end;
        }
        field(12; "Destination Subcode"; Code[10])
        {
            Caption = 'Destination Subcode';
            TableRelation = IF ("Destination Type" = CONST(Customer)) "Ship-to Address".Code WHERE("Customer No." = FIELD("Destination Code"))
            ELSE
            IF ("Destination Type" = CONST(Vendor)) "Order Address".Code WHERE("Vendor No." = FIELD("Destination Code"));
        }
        field(14; "Destination Arrival Region"; Code[20])
        {
            Caption = 'Destination Arrival Region';
            TableRelation = "POI Departure Region" where(RegionType = const(Arrival));
        }
        field(15; "Destination Name"; Text[100])
        {
            Caption = 'Destination Name';
            Editable = false;
        }
        field(18; "Destination Search Name"; Code[100])
        {
            Caption = 'Ziel Suchbegriff';
            Editable = false;
        }
        field(19; "Destination City"; Text[30])
        {
            Caption = 'City';
            Editable = false;

        }
        field(20; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            Description = 'Unloading,Loading,Both';
            OptionCaption = 'Unloading,Loading,Both';
            OptionMembers = Unloading,Loading,Both;
        }
        field(25; "Loading Order"; Integer)
        {
            Caption = 'Loading Order';
        }
        field(30; Comment; Text[50])
        {
            Caption = 'Comment';
        }
        field(31; "Comment 2"; Text[50])
        {
            Caption = 'Comment 2';
        }
        field(35; "Available at Target"; DateFormula)
        {
            Caption = 'Available at Target';
        }
        field(36; "Available Target Day of Week"; Option)
        {
            Caption = 'Available Target Day of Week';
            OptionCaption = ' ,Monday,Tuesday,Wendsday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = " ",Monday,Tuesday,Wendsday,Thursday,Friday,Saturday,Sunday;
        }
        field(40; "Tour Type"; Option)
        {
            Caption = 'Tour Type';
            Description = ' ,Sporadisch,,,,,Nicht Aktiv';
            OptionCaption = 'Hauptliefertag,,,,,Liefertag,,,,,Nach Rücksprache';
            OptionMembers = Hauptliefertag,,,,,Liefertag,,,,,"Nach Rücksprache";
        }
        field(70; "Key"; Boolean)
        {
            Caption = 'Key';
        }
        field(71; Rampe; Boolean)
        {
            Caption = 'Rampe';
        }
    }

    keys
    {
        key(Key1; "Tour No.", "Line No.")
        {
        }
        key(Key2; "Tour No.", "Loading Order", "Destination Type", "Destination Code", "Destination Subcode")
        {
        }
    }

    trigger OnInsert()

    begin
        IF "Line No." = 0 THEN BEGIN
            lrc_TourRouting.SETRANGE("Tour No.", "Tour No.");
            IF lrc_TourRouting.FINDLAST() THEN
                "Line No." := lrc_TourRouting."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;
    end;

    var
        lrc_TourRouting: Record "POI Tour Routing";
}

