page 50066 "POI Bank Copy"
{
    Caption = 'Caption';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {

                field(BankAccountIBAN; BankAccountIBAN)
                {
                    Caption = 'IBAN';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(BankCurrency; BankCurrency)
                {
                    Caption = 'Währung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    TableRelation = Currency.Code;
                }
                field(BankAccount; BankAccount)
                {
                    Caption = 'Kopieren von Konto';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    TableRelation = "Bank Account"."No.";
                    trigger OnValidate()
                    begin
                        if NewBankNo = '' then
                            NewBankNo := copystr(BankAccount + BankCurrency, 1, 20);
                    end;
                }
                Field(NewBankNo; NewBankNo)
                {
                    Caption = 'Neuer Bankcode';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CopyBank)
            {
                Caption = 'Neue Bank erstellen';
                ApplicationArea = All;
                ToolTip = ' ';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = New;
                trigger OnAction()
                begin
                    if (BankAccountIBAN <> '') and (BankCurrency <> '') then
                        CopyBankAccount();
                    CurrPage.Close();
                end;
            }
        }
    }

    procedure CopyBankAccount()
    begin
        if BankAccounts.get(BankAccount) then
            if not BankAccounts2.Get() then begin
                BankAccounts2 := BankAccounts;
                BankAccounts2."No." := NewBankNo;
                BankAccounts2.IBAN := BankAccountIBAN;
                BankAccounts2."Currency Code" := BankCurrency;
                BankAccounts2.Insert();
                Message('Bank wurde angelegt.');
            end else
                Message('BankCode existiert bereits');
    end;

    var
        BankAccounts: Record "Bank Account";
        BankAccounts2: Record "Bank Account";
        BankAccountIBAN: Code[30];
        BankAccount: Code[20];
        BankCurrency: Code[10];
        NewBankNo: code[20];
}