codeunit 5110311 "POI PrintFaxMail Globals"
{
    SingleInstance = true;

    var

        grc_SelectPrintDoc: Record "POI Selection Print Documents";
        grc_FreightPrintDocuments: Record "POI Selection Print Documents";
        gop_Label_UnitOfMeasureCode: Option Unit,Packing,Transport;
        gin_LabelCopies: Integer;
        gtx_PrinterID: Text[250];
        gtx_ArrCommand: array[5] of Text[250];
        gLabelType: Option "Transport Label","Collo Label";
        gCustomerNo: Code[20];
        gItemNo: Code[20];
        gbn_MailFaxDataExternal: Boolean;
        gbn_Preview: Boolean;

        FileForAttachement: Text[1024];
        gcd_MailID: Code[20];
        gbn_Mail: Boolean;
        gbn_Fax: Boolean;
        gtx_MailPfad: Text[150];
        gtx_MailDatei: Text[100];
        gtx_MailAddress: Text[250];
        gtx_MailSubject: Text[250];
        gtx_FaxNo: Text[250];
        gco_DetailCode: Code[20];

    procedure SetMail(vbn_Mail: Boolean)
    begin
        ResetFaxMail();
        gbn_Mail := vbn_Mail;
    end;

    procedure GetMail(): Boolean
    begin
        EXIT(gbn_Mail);
    end;

    procedure SetMailPath(vtx_Pfad: Text[150])
    begin
        gtx_MailPfad := vtx_Pfad;
    end;

    procedure GetMailPath(): Text[150]
    begin
        EXIT(gtx_MailPfad);
    end;

    procedure SetMailFile(vtx_Datei: Text[100])
    begin
        gtx_MailDatei := vtx_Datei;
    end;

    procedure GetMailFile(): Text[100]
    begin
        EXIT(gtx_MailDatei);
    end;

    procedure SetFax(vbn_Fax: Boolean)
    begin
        ResetFaxMail();
        gbn_Fax := vbn_Fax;
    end;

    procedure GetFax(): Boolean
    begin
        EXIT(gbn_Fax);
    end;

    procedure SetMailAddress(vtx_MailAddress: Text[250])
    begin
        gtx_MailAddress := vtx_MailAddress;
    end;

    procedure GetMailAddress(): Text[250]
    begin
        EXIT(gtx_MailAddress);
    end;

    procedure SetMailSubject(vrc_MailSubject: Text[250])
    begin
        gtx_MailSubject := vrc_MailSubject;
    end;

    procedure GetMailSubject(): Text[250]
    begin
        EXIT(gtx_MailSubject);
    end;

    procedure SetMailID(vcd_MailID: Code[20])
    begin
        //POI 002 setzen eindeutige Mail ID, Aufruf aus CU 5110309
        gcd_MailID := vcd_MailID;
    end;

    procedure GetMailID(): Code[20]
    begin
        //POI 002 holen von Mail ID aus CU 5110310
        EXIT(gcd_MailID);
    end;

    procedure SetFaxNo(vtx_FaxNo: Text[250])
    begin
        gtx_FaxNo := vtx_FaxNo;
    end;

    procedure GetFaxNo(): Text[250]
    begin
        EXIT(gtx_FaxNo);
    end;

    procedure SetPrinterID(vtx_PrinterID: Text[250])
    begin
        gtx_PrinterID := vtx_PrinterID;
    end;

    procedure GetPrinterID(): Text[250]
    begin
        EXIT(gtx_PrinterID);
    end;

    procedure ClearPrintDocRec()
    begin
        CLEAR(grc_SelectPrintDoc);
    end;

    procedure SetPurchPrintDocRec(vrc_SelectPrintDoc: Record "POI Selection Print Documents")
    begin
        grc_SelectPrintDoc := vrc_SelectPrintDoc;
    end;

    procedure GetPurchPrintDocRec(var vrc_SelectPrintDocuments: Record "POI Selection Print Documents")
    begin
        vrc_SelectPrintDocuments := grc_SelectPrintDoc;
    end;

    procedure ClearPurchPrintDocRec()
    begin
        CLEAR(grc_SelectPrintDoc);
    end;

    procedure SetSalesPrintDocRec(vrc_SelectPrintDoc: Record "POI Selection Print Documents")
    begin
        grc_SelectPrintDoc := vrc_SelectPrintDoc;
    end;

    procedure GetSalesPrintDocRec(var vrc_SelectPrintDocuments: Record "POI Selection Print Documents")
    begin
        vrc_SelectPrintDocuments := grc_SelectPrintDoc;
    end;

    procedure ClearSalesPrintDocRec()
    begin
        CLEAR(grc_SelectPrintDoc);
    end;

    procedure SetTransferPrintDocRec(vrc_SelectPrintDoc: Record "POI Selection Print Documents")
    begin
        grc_SelectPrintDoc := vrc_SelectPrintDoc;
    end;

    procedure GetTransferPrintDocRec(var vrc_SelectPrintDoc: Record "POI Selection Print Documents")
    begin
        vrc_SelectPrintDoc := grc_SelectPrintDoc;
    end;

    procedure SetFreightPrintDocRec(vrc_FreightPrintDocuments: Record "POI Selection Print Documents")
    begin
        grc_FreightPrintDocuments := vrc_FreightPrintDocuments;
    end;

    procedure GetFreightPrintDocRec(var vrc_FreightPrintDocuments: Record "POI Selection Print Documents")
    begin
        vrc_FreightPrintDocuments := grc_FreightPrintDocuments;
    end;

    procedure ClearFreightPrintDocRec()
    begin
        CLEAR(grc_FreightPrintDocuments);
    end;

    procedure SetPackPrintDocRec(vrc_SelectPrintDoc: Record "POI Selection Print Documents")
    begin
        grc_SelectPrintDoc := vrc_SelectPrintDoc;
    end;

    procedure GetPackPrintDocRec(var vrc_SelectPrintDocuments: Record "POI Selection Print Documents")
    begin
        vrc_SelectPrintDocuments := grc_SelectPrintDoc;
    end;

    procedure SetFaxMailCommands(var rtx_ArrCommand: array[5] of Text[450])
    begin
        gtx_ArrCommand[1] := rtx_ArrCommand[1];
        gtx_ArrCommand[2] := rtx_ArrCommand[2];
        gtx_ArrCommand[3] := rtx_ArrCommand[3];
        gtx_ArrCommand[4] := rtx_ArrCommand[4];
        gtx_ArrCommand[5] := rtx_ArrCommand[5];
    end;

    procedure GetFaxMailCommands(var rtx_ArrCommand: array[5] of Text[450])
    begin
        rtx_ArrCommand[1] := gtx_ArrCommand[1];
        rtx_ArrCommand[2] := gtx_ArrCommand[2];
        rtx_ArrCommand[3] := gtx_ArrCommand[3];
        rtx_ArrCommand[4] := gtx_ArrCommand[4];
        rtx_ArrCommand[5] := gtx_ArrCommand[5];
    end;

    procedure ResetFaxMail()
    begin
        gbn_Mail := FALSE;
        gbn_Fax := FALSE;

        gtx_MailPfad := '';
        gtx_MailDatei := '';
        gtx_MailAddress := '';
        gtx_MailSubject := '';
        gtx_FaxNo := '';
        gco_DetailCode := '';

        //POI 002 160216 rs
        //gcd_MailID := '';

        gbn_MailFaxDataExternal := FALSE;
        gbn_Preview := FALSE;
    end;

    procedure SetPackOrderLabelParameter(rop_Label_UnitOfMeasureCode: Option Unit,Packing,Transport; rin_LabelCopies: Integer)
    begin
        ResetPackOrderLabelParameter();
        gop_Label_UnitOfMeasureCode := rop_Label_UnitOfMeasureCode;
        gin_LabelCopies := rin_LabelCopies;
    end;

    procedure GetPackOrderLabelUnitOfMeasure(): Integer
    begin
        EXIT(gop_Label_UnitOfMeasureCode);
    end;

    procedure GetPackOrderLabelCopies(): Integer
    begin
        EXIT(gin_LabelCopies);
    end;

    procedure ResetPackOrderLabelParameter()
    begin
        gop_Label_UnitOfMeasureCode := 0;
        gin_LabelCopies := 0;
    end;

    procedure SetBarcodedefinition(pCustomerNo: Code[20]; pLabelType: Option "Transport Label","Collo Label","WE Transport Label","WE Collo Label",,,,,,,,"Sales Shipment"; pItemNo: Code[20])
    begin
        gCustomerNo := pCustomerNo;
        gLabelType := pLabelType;
        gItemNo := pItemNo;
    end;

    procedure GetBarcodedefinition(var vCustomerNo: Code[20]; var vLabelType: Option "Transport Label","Collo Label","WE Transport Label","WE Collo Label",,,,,,,,"Sales Shipment"; var vItemNo: Code[20])
    begin
        vCustomerNo := gCustomerNo;
        vLabelType := gLabelType;
        vItemNo := gItemNo;
    end;


    procedure SetMailFaxDataExternal(vbn_MailFaxDataExternal: Boolean)
    begin
        gbn_MailFaxDataExternal := vbn_MailFaxDataExternal;
    end;

    procedure GetMailFaxDataExternal(): Boolean
    begin
        EXIT(gbn_MailFaxDataExternal);
    end;

    procedure SetPreview(vbn_Preview: Boolean)
    begin
        ResetFaxMail();
        gbn_Preview := vbn_Preview;
    end;

    procedure GetPreview(): Boolean
    begin
        EXIT(gbn_Preview);
    end;

    procedure SetFileOfAttachement(FileForAttachement2: Text[1024])
    begin
        FileForAttachement := FileForAttachement2;
    end;

    procedure GetFileOfAttachement(): Text[1024]
    begin
        EXIT(FileForAttachement);
    end;

    procedure Get_PrintRepDesc(): Text[150]
    begin
        //mly
        EXIT(grc_SelectPrintDoc."Print Report Description");
    end;
}

