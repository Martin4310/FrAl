pageextension 50021 "POI Bank Account List" extends "Bank Account List"
{
    layout
    {
        modify(Contact)
        {
            Visible = false;
        }
        modify("Phone No.")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = true;
        }
    }
    actions
    {
        addafter("C&ontact")
        {
            action(CreateNewBank)
            {
                Caption = 'Neues Bankonto erstellen';
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ToolTip = ' ';
                Image = NewBank;
                trigger OnAction()
                begin
                    page.RunModal(Page::"POI Bank Copy");
                end;
            }
        }
    }
}