codeunit 50020 "POI Basic Function"
{
    procedure CheckIBAN(BankAccountNo: code[30]): Boolean
    var
        CheckTextTxt: label '000000000ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        BBAN: text[30];
        CheckNumber: Decimal;
    begin
        BBAN := CopyStr(BankAccountNo, 2, StrLen(BankAccountNo));
        BBAN += strsubstno('%1', StrPos(CheckTextTxt, CopyStr(BankAccountNo, 1, 1)));
        BBAN += strsubstno('%1', StrPos(CheckTextTxt, CopyStr(BankAccountNo, 2, 1)));
        Evaluate(CheckNumber, BBAN);
        if (CheckNumber mod 97) = 1 then
            exit(true)
        else
            exit(false);
    end;
}