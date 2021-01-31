table 50956 "POI W.D. Journ. Name"
{
    Caption = 'W.D. Journ. Name';
    DataCaptionFields = "Journal Batch Name", Description;
    //LookupFormID = Form5087907; //TODO: Lookup page

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            NotBlank = true;
            TableRelation = "POI W.D. Journ. Template".Name;
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            NotBlank = true;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(5; "Entry No. DSD Export"; Integer)
        {
            Caption = 'Entry No. DSD Export';
        }
        field(11; "Disposal of Waste Company"; Option)
        {
            Caption = 'Entsorgungsunternehmen';
            Description = 'DSD';
            OptionCaption = ' ,DSD,BellandVision,Interseroh,Edeka,,,,ARA';
            OptionMembers = " ",DSD,BellandVision,Interseroh,Edeka,Fruitness,"Belland Ratio","Belland Tegut",ARA,METRO;
        }
        field(13; Evaluated; Boolean)
        {
            Caption = 'Evaluated';
        }
        field(14; "Statistics Period"; Code[10])
        {
            Caption = 'Statistics Period';

            trigger OnValidate()
            begin
                TESTFIELD(Evaluated, FALSE);
                IF STRLEN("Statistics Period") <> 4 THEN
                    ERROR(
                      '%1 muß 4 Zeichen haben, beispielsweise 9410 für Oktober 1994.',
                      FIELDNAME("Statistics Period"));
                EVALUATE(gin_Monat, COPYSTR("Statistics Period", 3, 2));
                IF (gin_Monat < 1) OR (gin_Monat > 12) THEN
                    ERROR('Bitte die Monatsnummer prüfen.');
            end;
        }
        field(15; "Amounts (ARC)"; Boolean)
        {
            Caption = 'Amounts (ARC)';

            trigger OnValidate()
            begin
                TESTFIELD(Evaluated, FALSE);
            end;
        }
        field(16; "Currency Code Number"; Code[10])
        {
            Caption = 'Currency Code Number';

            trigger OnValidate()
            begin
                TESTFIELD(Evaluated, FALSE);
            end;
        }
        field(17; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(18; "Till Date"; Date)
        {
            Caption = 'Till Date';
        }
        field(30; Grossverpackung; Boolean)
        {
            Caption = 'Big Packing';
        }
        field(31; "Condition M 2"; Decimal)
        {
            Caption = 'Condition M 2';
        }
        field(32; "Condition M 3"; Decimal)
        {
            Caption = 'Condition M 3';
        }
        field(33; "Condition M 4"; Decimal)
        {
            Caption = 'Condition M 4';
        }
        field(34; "Condition P I a"; Decimal)
        {
            Caption = 'Condition P I a';
        }
        field(35; "Condition P I b"; Decimal)
        {
            Caption = 'Condition P I b';
        }
        field(36; "Condition P I c"; Decimal)
        {
            Caption = 'Condition P I c';
        }
        field(37; "Condition P I d"; Decimal)
        {
            Caption = 'Condition P I d';
        }
        field(38; "Condition P II a"; Decimal)
        {
            Caption = 'Condition P II a';
        }
        field(39; "Condition P II b"; Decimal)
        {
            Caption = 'Condition P II b';
        }
        field(40; "Condition P II c"; Decimal)
        {
            Caption = 'Condition P II c';
        }
        field(41; "Condition P II d"; Decimal)
        {
            Caption = 'Condition P II d';
        }
        field(45; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(50; "Amount 100 %"; Decimal)
        {
            Caption = 'Amount 100 %';
        }
        field(60; "Lfd. No. Internal DSD"; Code[20])
        {
            Caption = 'Lfd. No. Internal DSD';
        }
        field(65; "Quantity BA 71"; Integer)
        {
            Caption = 'Quantity BA 71';
        }
        field(66; "Quantity BA 73"; Integer)
        {
            Caption = 'Quantity BA 73';
        }
        field(70; "Start Option 1"; Boolean)
        {
            Caption = 'Start Option 1';
        }
        field(71; "Start Option 2"; Boolean)
        {
            Caption = 'Start Option 2';
        }
        field(72; "Start Option 3"; Boolean)
        {
            Caption = 'Start Option 3';
        }
        field(73; "Start Option 4"; Boolean)
        {
            Caption = 'Start Option 4';
        }
        field(74; "Start Option 5"; Boolean)
        {
            Caption = 'Start Option 5';
        }
        field(80; "Reporting Type"; Option)
        {
            Caption = 'Reporting Type';
            OptionCaption = 'New Report,After-Report';
            OptionMembers = "New Report","After-Report";
        }
        field(81; "Period Of Reporting"; Option)
        {
            Caption = 'Period Of Reporting';
            OptionCaption = 'Month,Quarter,Year,Annual Accounts';
            OptionMembers = Month,Quarter,Year,"Annual Accounts";
        }
        field(85; "Temp Path"; Text[250])
        {
            Caption = 'Temp Path';

            trigger OnValidate()
            begin
                DSDEinrichtung.GET();
                IF "Temp Path" = '' THEN BEGIN
                    "Temp Path" := DSDEinrichtung."Export Path DSD";
                    MODIFY();
                END;
            end;
        }
        field(90; "Filename BA 21/22"; Text[30])
        {
            Caption = 'Filename BA 21/22';
        }
        field(91; "Filename BA 70"; Text[30])
        {
            Caption = 'Filename BA 70';
        }
        field(92; "Filename BA 71"; Text[30])
        {
            Caption = 'Filename BA 71';
        }
        field(93; "Filename BA 73"; Text[30])
        {
            Caption = 'Filename BA 73';
        }
        field(94; "Filename BA 23"; Text[30])
        {
            Caption = 'Filename BA 23';
        }
        field(95; "Filename BA 24"; Text[30])
        {
            Caption = 'Filename BA 24';
        }
        field(96; "Filename BA 25"; Text[30])
        {
            Caption = 'Filename BA 25';
        }
        field(97; "Filename BA 72"; Text[30])
        {
            Caption = 'Filename BA 72';
        }
        field(110; "Amount Total G1"; Decimal)
        {
            Caption = 'Amount Total G1';
        }
        field(111; "Amount Total G2"; Decimal)
        {
            Caption = 'Amount Total G2';
        }
        field(112; "Amount Total G3"; Decimal)
        {
            Caption = 'Amount Total G3';
        }
        field(113; "Amount Total G4"; Decimal)
        {
            Caption = 'Amount Total G4';
        }
        field(114; "Amount Total G5"; Decimal)
        {
            Caption = 'Amount Total G5';
        }
        field(115; "Amount Total G6"; Decimal)
        {
            Caption = 'Amount Total G6';
        }
        field(116; "Amount Total G7"; Decimal)
        {
            Caption = 'Amount Total G7';
        }
        field(117; "Amount Total G8"; Decimal)
        {
            Caption = 'Amount Total G8';
        }
        field(118; "Amount Total V1"; Decimal)
        {
            Caption = 'Amount Total V1';
        }
        field(119; "Amount Total V2"; Decimal)
        {
            Caption = 'Amount Total V2';
        }
        field(120; "Amount Total V3"; Decimal)
        {
            Caption = 'Amount Total V3';
        }
        field(121; "Amount Total V4"; Decimal)
        {
            Caption = 'Amount Total V4';
        }
        field(122; "Amount Total V5"; Decimal)
        {
            Caption = 'Amount Total V5';
        }
        field(123; "Amount Total V6"; Decimal)
        {
            Caption = 'Amount Total V6';
        }
        field(124; "Amount Total V7"; Decimal)
        {
            Caption = 'Amount Total V7';
        }
        field(125; "Amount Total V8"; Decimal)
        {
            Caption = 'Amount Total V8';
        }
        field(126; "Amount Total F1"; Decimal)
        {
            Caption = 'Amount Total F1';
        }
        field(127; "Amount Total F2"; Decimal)
        {
            Caption = 'Amount Total F2';
        }
        field(128; "Amount Total F3"; Decimal)
        {
            Caption = 'Amount Total F3';
        }
        field(129; "Amount Total F4"; Decimal)
        {
            Caption = 'Amount Total F4';
        }
        field(130; "Amount Total F5"; Decimal)
        {
            Caption = 'Amount Total F5';
        }
        field(131; "Amount Total F6"; Decimal)
        {
            Caption = 'Amount Total F6';
        }
        field(132; "Amount Total F7"; Decimal)
        {
            Caption = 'Amount Total F7';
        }
        field(133; "Amount Total F6a"; Decimal)
        {
            Caption = 'Amount Total F6a';
        }
        field(134; "Amount Total F6b"; Decimal)
        {
            Caption = 'Amount Total F6b';
        }
        field(135; "Amount Total F7a"; Decimal)
        {
            Caption = 'Amount Total F7a';
        }
        field(136; "Amount Total F7b"; Decimal)
        {
            Caption = 'Amount Total F7b';
        }
        field(137; "Amount Total F7c"; Decimal)
        {
            Caption = 'Amount Total F7c';
        }
        field(138; "Weight/Piece G1"; Decimal)
        {
            Caption = 'Weight/Piece G1';
        }
        field(139; "Weight/Piece G2"; Decimal)
        {
            Caption = 'Weight/Piece G2';
        }
        field(140; "Weight/Piece G3"; Decimal)
        {
            Caption = 'Weight/Piece G3';
        }
        field(141; "Weight/Piece G4"; Decimal)
        {
            Caption = 'Weight/Piece G4';
        }
        field(142; "Weight/Piece G5"; Decimal)
        {
            Caption = 'Weight/Piece G5';
        }
        field(143; "Weight/Piece G6"; Decimal)
        {
            Caption = 'Weight/Piece G6';
        }
        field(144; "Weight/Piece G7"; Decimal)
        {
            Caption = 'Weight/Piece G7';
        }
        field(145; "Weight/Piece G8"; Decimal)
        {
            Caption = 'Weight/Piece G8';
        }
        field(146; "Weight/Piece V1"; Decimal)
        {
            Caption = 'Weight/Piece V1';
        }
        field(147; "Weight/Piece V2"; Decimal)
        {
            Caption = 'Weight/Piece V2';
        }
        field(148; "Weight/Piece V3"; Decimal)
        {
            Caption = 'Weight/Piece V3';
        }
        field(149; "Weight/Piece V4"; Decimal)
        {
            Caption = 'Weight/Piece V4';
        }
        field(150; "Weight/Piece V5"; Decimal)
        {
            Caption = 'Weight/Piece V5';
        }
        field(151; "Weight/Piece V6"; Decimal)
        {
            Caption = 'Weight/Piece V6';
        }
        field(152; "Weight/Piece V7"; Decimal)
        {
            Caption = 'Weight/Piece V7';
        }
        field(153; "Weight/Piece V8"; Decimal)
        {
            Caption = 'Weight/Piece V8';
        }
        field(154; "Weight/Piece F1"; Decimal)
        {
            Caption = 'Weight/Piece F1';
        }
        field(155; "Weight/Piece F2"; Decimal)
        {
            Caption = 'Weight/Piece F2';
        }
        field(156; "Weight/Piece F3"; Decimal)
        {
            Caption = 'Weight/Piece F3';
        }
        field(157; "Weight/Piece F4"; Decimal)
        {
            Caption = 'Weight/Piece F4';
        }
        field(158; "Weight/Piece F5"; Decimal)
        {
            Caption = 'Weight/Piece F5';
        }
        field(159; "Weight/Piece F6"; Decimal)
        {
            Caption = 'Weight/Piece F6';
        }
        field(160; "Weight/Piece F7"; Decimal)
        {
            Caption = 'Weight/Piece F7';
        }
        field(161; "Weight/Piece F6a"; Decimal)
        {
            Caption = 'Weight/Piece F6a';
        }
        field(162; "Weight/Piece F6b"; Decimal)
        {
            Caption = 'Weight/Piece F6b';
        }
        field(163; "Weight/Piece F7a"; Decimal)
        {
            Caption = 'Weight/Piece F7a';
        }
        field(164; "Weight/Piece F7b"; Decimal)
        {
            Caption = 'Weight/Piece F7b';
        }
        field(165; "Weight/Piece F7c"; Decimal)
        {
            Caption = 'Weight/Piece F7c';
        }
        field(170; "Reduction 1"; Decimal)
        {
            Caption = 'Reduction 1';
        }
        field(171; "Reduction 2"; Decimal)
        {
            Caption = 'Reduction 2';
        }
        field(172; Quote; Decimal)
        {
            Caption = 'Quote';
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name")
        {
        }
        key(Key2; "Entry No. DSD Export")
        {
        }
    }


    trigger OnDelete()
    begin
        DSDBuchBlZeile.SETRANGE("Journal Template Name", "Journal Template Name");
        DSDBuchBlZeile.SETRANGE("Journal Batch Name", "Journal Batch Name");
        IF DSDBuchBlZeile.FIND('-') THEN
            DSDBuchBlZeile.DELETEALL(TRUE);
    end;

    trigger OnRename()
    begin
        DSDBuchBlZeile.SETRANGE("Journal Template Name", xRec."Journal Template Name");
        DSDBuchBlZeile.SETRANGE("Journal Batch Name", xRec."Journal Batch Name");
        IF DSDBuchBlZeile.FIND('-') THEN
            REPEAT
                DSDBuchBlZeile.RENAME("Journal Template Name", "Journal Batch Name", DSDBuchBlZeile."Line No");
            UNTIL (DSDBuchBlZeile.NEXT() = 0);
    end;

    var
        DSDBuchBlZeile: Record "POI W.D. Journ. Line Entry";
        DSDEinrichtung: Record "POI W.D. Setup";
        gin_Monat: Integer;
}

