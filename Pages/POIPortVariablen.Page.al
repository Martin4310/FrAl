page 50055 "POI Port Variablen"
{
    Caption = 'Port Variablen';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    //SourceTable = TableName;

    layout
    {
        area(Content)
        {
            group(General)
            {
                grid(grid1)
                {
                    GridLayout = Columns;
                    field(txtVari1f; txtVari1)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(Vari1f; Vari1)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
                grid(grid2)
                {
                    GridLayout = Columns;
                    field(txtVari2f; txtVari2)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(Vari2f; Vari2)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
                grid(grid3)
                {
                    GridLayout = Columns;
                    field(txtVari3f; txtVari3)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(Vari3f; Vari3)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
                grid(grid4)
                {
                    GridLayout = Columns;
                    field(txtVari4f; txtVari4)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(Vari4f; Vari4)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
                grid(grid5)
                {
                    GridLayout = Columns;
                    field(txtVari5f; txtVari5)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(Vari5f; Vari5)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
                grid(grid6)
                {
                    GridLayout = Columns;
                    field(txtBoolVari1f; txtBoolVari1)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(BoolVari1f; BoolVari1)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
                grid(grid7)
                {
                    GridLayout = Columns;
                    field(txtBoolVari2f; txtBoolVari2)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(BoolVari2f; BoolVari2)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
            }
        }
    }
    PROCEDURE GetVari(VAR GetVari1: Text[30]; VAR GetVari2: Text[30]; VAR GetVari3: Text[30]; VAR GetBoolVari1: Boolean);
    BEGIN
        GetVari1 := Vari1;
        GetVari2 := Vari2;
        GetVari3 := Vari3;
        GetBoolVari1 := BoolVari1;
    END;

    PROCEDURE GetVariMore(VAR GetVari1: Text[30]; VAR GetVari2: Text[30]; VAR GetVari3: Text[30]; VAR GetVari4: Text[30]; VAR GetVari5: Text[30]; VAR GetBoolVari1: Boolean; VAR GetBoolVari2: Boolean);
    BEGIN
        GetVari1 := Vari1;
        GetVari2 := Vari2;
        GetVari3 := Vari3;
        GetVari4 := Vari4;
        GetVari5 := Vari5;
        GetBoolVari1 := BoolVari1;
        GetBoolVari2 := BoolVari2;
    END;

    PROCEDURE SetVari(SettxtVar1: Text[30]; SettxtVar2: Text[30]; SettxtVar3: Text[30]; SettxtBoolVari1: Text[30]);
    BEGIN
        txtVari1 := SettxtVar1;
        txtVari2 := SettxtVar2;
        txtVari3 := SettxtVar3;
        txtBoolVari1 := SettxtBoolVari1;
        ChoiceMore := FALSE;
    END;

    PROCEDURE SetVariMore(SettxtVar1: Text[30]; SettxtVar2: Text[30]; SettxtVar3: Text[30]; SettxtVar4: Text[30]; SettxtVar5: Text[30]; SettxtBoolVari1: Text[30]; SettxtBoolVari2: Text[30]);
    BEGIN
        txtVari1 := SettxtVar1;
        txtVari2 := SettxtVar2;
        txtVari3 := SettxtVar3;
        txtVari4 := SettxtVar4;
        txtVari5 := SettxtVar5;

        txtBoolVari1 := SettxtBoolVari1;
        txtBoolVari2 := SettxtBoolVari2;

        ChoiceMore := TRUE;
    END;

    PROCEDURE SetFieldLookup(SetFieldText: Text[30]; SetField: Integer);
    BEGIN
        CASE SetFieldText OF
            'Debitor':
                FieldLookup[SetField] := FieldLookup::Debitor;
            'Kreditor':
                FieldLookup[SetField] := FieldLookup::Kreditor;
        END;
        FieldLookupSet[SetField] := TRUE;
    END;

    PROCEDURE LookupDebitor(VAR DebNo: Code[20]): Boolean;
    VAR

        lfr_ADFCustomerList: Page "POI Customer List";
    BEGIN
        CLEAR(lfr_ADFCustomerList);
        IF DebNo <> '' THEN BEGIN
            lrc_Customer.SETFILTER("No.", DebNo);
            lrc_Customer.FINDSET();
        END;
        lfr_ADFCustomerList.SETRECORD(lrc_Customer);
        lfr_ADFCustomerList.SETTABLEVIEW(lrc_Customer);
        lfr_ADFCustomerList.LOOKUPMODE := TRUE;
        IF lfr_ADFCustomerList.RUNMODAL() = ACTION::LookupOK THEN BEGIN
            lfr_ADFCustomerList.GETRECORD(lrc_Customer);
            DebNo := lrc_Customer."No.";
            EXIT(TRUE);
        END ELSE BEGIN
            CLEAR(lfr_ADFCustomerList);
            EXIT(FALSE);
        END;
    END;


    VAR
        lrc_Customer: Record Customer;
        ChoiceMore: Boolean;
        Vari1: Text[30];
        Vari2: Text[30];
        Vari3: Text[30];
        Vari4: Text[30];
        Vari5: Text[30];
        BoolVari1: Boolean;
        BoolVari2: Boolean;
        txtVari1: Text[30];
        txtVari2: Text[30];
        txtVari3: Text[30];
        txtVari4: Text[30];
        txtVari5: Text[30];
        txtBoolVari1: Text[30];
        txtBoolVari2: Text[30];
        FieldLookup: ARRAY[5] OF Option Debitor,Kreditor;
        FieldLookupSet: Array[5] of Boolean;
}