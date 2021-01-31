codeunit 5110349 "POI Purch. Contract Mgt"
{
    //     var
    //         SubjectAreaCodeGlobal: Code[10];
    //         UserIDGlobal: Code[20];
    //         FromSubjectAreaCodeGlobal: Boolean;
    //         "Purchaser CodeGlobal": Code[20];

    //     procedure FindPossibleBlanketOrder(var ReqLine: Record "246";Showmessage9: Boolean)
    //     var
    //         PurchLine: Record "39";
    //         Item: Record Item;
    //         Text1000094800: Label 'A blanket order %1 exists for item % 2 at vendor % 3';
    //         RequisitionLine_5: Record "246";
    //         BlanketOrderExist5: Code[20];
    //     begin
    //         WITH ReqLine DO BEGIN
    //           IF (Type <> Type::Item) OR ("No." = '') OR ("Vendor No." = '') OR ( Quantity = 0 ) THEN BEGIN
    //             "Possible Blanket Order No." := '';
    //             "Possible Blanket Order Line No" := 0;
    //             EXIT;
    //           END;

    //           PurchLine.SETCURRENTKEY("Document Type", Type, "No.", "Buy-from Vendor No.");
    //           PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::"Blanket Order");
    //           IF ReqLine."Vendor No." <> '' THEN
    //             PurchLine.SETRANGE("Buy-from Vendor No.", "Vendor No.");
    //           PurchLine.SETRANGE(Type, PurchLine.Type::Item);
    //           PurchLine.SETRANGE("No.", "No.");
    //           PurchLine.SETFILTER("Outstanding Quantity", '%1..', Quantity);

    //           BlanketOrderExist5 := '';

    //           IF PurchLine.FIND('-') THEN REPEAT
    //             BlanketOrderExist5 := PurchLine."Document No.";
    //             PurchLine.CALCFIELDS("Rem.Qty. (Base) in Purch.Order", "Qty. (Base) in Req. Line/Plan.");

    //             RequisitionLine_5.Reset();
    //             RequisitionLine_5.SETCURRENTKEY("Possible Blanket Order No.", "Possible Blanket Order Line No");
    //             RequisitionLine_5.SETRANGE("Possible Blanket Order No.", PurchLine."Document No.");
    //             RequisitionLine_5.SETRANGE("Possible Blanket Order Line No", PurchLine."Line No.");
    //             RequisitionLine_5.SETFILTER("Line No.", '<> %1', ReqLine."Line No.");
    //             RequisitionLine_5.CALCSUMS("Quantity (Base)");

    //             IF (PurchLine."Outstanding Qty. (Base)" - PurchLine."Rem.Qty. (Base) in Purch.Order" -
    //                 RequisitionLine_5."Quantity (Base)" >= ReqLine."Quantity (Base)") AND

    //                NOT TestBlnktOrderDate(PurchLine) THEN
    //               BEGIN
    //                 "Possible Blanket Order No." := PurchLine."Document No.";
    //                 "Possible Blanket Order Line No" := PurchLine."Line No.";
    //                 VALIDATE("Vendor No.", PurchLine."Buy-from Vendor No.");
    //                 "Direct Unit Cost" := PurchLine."Direct Unit Cost";
    //                 EXIT;
    //               END;
    //           UNTIL PurchLine.NEXT() = 0;

    //           "Possible Blanket Order No." := '';
    //           "Possible Blanket Order Line No" := 0;
    //           IF BlanketOrderExist5 <> '' THEN BEGIN
    //              IF Showmessage9 = TRUE THEN
    //                 MESSAGE( Text1000094800, BlanketOrderExist5, "No.", "Vendor No."  );
    //           END ELSE BEGIN
    //              PurchLine.Reset();
    //              PurchLine.SETCURRENTKEY("Document Type", Type, "No.", "Buy-from Vendor No.");
    //              PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::"Blanket Order");
    //              IF ReqLine."Vendor No." <> '' THEN
    //                PurchLine.SETRANGE("Buy-from Vendor No.", "Vendor No.");
    //              PurchLine.SETRANGE(Type, PurchLine.Type::Item);
    //              PurchLine.SETRANGE("No.", "No.");
    //              BlanketOrderExist5 := '';
    //              IF PurchLine.FIND('-') THEN BEGIN
    //                 BlanketOrderExist5 := PurchLine."Document No.";
    //                 IF Showmessage9 = TRUE THEN
    //                    MESSAGE( Text1000094800, BlanketOrderExist5, "No.", "Vendor No."  );
    //              END;
    //           END;
    //         END;
    //     end;

    //     procedure AddRequisitionLine(var ReqLine: Record "246")
    //     var
    //         PurchLine: Record "39";
    //     begin
    //         IF (ReqLine."Possible Blanket Order No." = '') OR (ReqLine."Possible Blanket Order Line No" = 0) THEN
    //           EXIT;

    //         PurchLine.GET(PurchLine."Document Type"::"Blanket Order", ReqLine."Possible Blanket Order No.", ReqLine.
    //         "Possible Blanket Order Line No");
    //         ReqLine.VALIDATE("Vendor No.", PurchLine."Buy-from Vendor No.");
    //         ReqLine."Direct Unit Cost" := PurchLine."Direct Unit Cost";
    //     end;

    //     procedure FindReqLineForBlanketOrders(var ReqLine: Record "246")
    //     var
    //         ActualBlnktOrderNo: Code[10];
    //     begin
    //         WITH ReqLine DO
    //           BEGIN
    //             SETCURRENTKEY("Worksheet Template Name", "Journal Batch Name", "Possible Blanket Order No.");
    //             SETFILTER("Possible Blanket Order No.", '<>%1', '');
    //             IF FIND('-') THEN
    //               REPEAT
    //                 IF "Possible Blanket Order No." <> ActualBlnktOrderNo THEN
    //                   BEGIN

    //                     CreateOrderFromBlanketOrder(ReqLine);
    //                     ActualBlnktOrderNo := "Possible Blanket Order No.";
    //                   END;
    //               UNTIL ReqLine.NEXT() = 0;
    //             DELETEALL(TRUE);

    //             SETRANGE("Possible Blanket Order No.", '');
    //           END;
    //     end;

    //     procedure CreateOrderFromBlanketOrder(ReqLine: Record "246")
    //     var
    //         PurchHeader: Record "38";
    //         PurchLine: Record "39";
    //         PurchLineTemp: Record "39" temporary;
    //         BlanketPurchOrderToOrder: Codeunit "97";
    //     begin
    //         PurchHeader.LOCKTABLE(TRUE, TRUE);
    //         PurchHeader.GET(PurchHeader."Document Type"::"Blanket Order", ReqLine."Possible Blanket Order No.");
    //         MESSAGE( '%1 %2 %3', ReqLine."Worksheet Template Name", ReqLine."Journal Batch Name", ReqLine."Line No." );
    //         // PurchHeader.TESTFIELD(Status, PurchHeader.Status::Released);

    //         PurchLine.SETRANGE(PurchLine."Document Type", PurchLine."Document Type"::"Blanket Order");
    //         PurchLine.SETRANGE("Document No.", PurchHeader."No.");
    //         IF PurchLine.FIND('-') THEN REPEAT
    //           PurchLineTemp := PurchLine;
    //           PurchLineTemp.insert();

    //           PurchLine.VALIDATE("Qty. to Receive", 0);
    //           PurchLine.Modify();
    //         UNTIL PurchLine.NEXT() = 0;

    //         PurchLine.GET(PurchLine."Document Type"::"Blanket Order",
    //                       ReqLine."Possible Blanket Order No.",
    //                       ReqLine."Possible Blanket Order Line No");

    //         PurchLine.CALCFIELDS(PurchLine."Rem.Qty. (Base) in Purch.Order", "Qty. (Base) in Req. Line/Plan.");
    //         IF (PurchLine."Outstanding Quantity" - PurchLine."Rem.Qty. (Base) in Purch.Order" - PurchLine."Qty. (Base) in Req. Line/Plan." ) <
    //            ReqLine.Quantity THEN
    //            PurchLine.VALIDATE("Qty. to Receive", PurchLine."Outstanding Quantity" - PurchLine."Rem.Qty. (Base) in Purch.Order" -
    //            PurchLine."Qty. (Base) in Req. Line/Plan.")
    //         ELSE
    //            PurchLine.VALIDATE("Qty. to Receive", ReqLine.Quantity);

    //         PurchLine.Modify();

    //         IF FromSubjectAreaCodeGlobal THEN BEGIN
    //           //PurchHeader."Subject Area Code" := SubjectAreaCodeGlobal;
    //           PurchHeader."Purchaser Code" := UserIDGlobal;
    //         END;

    //         BlanketPurchOrderToOrder.RUN(PurchHeader);

    //         IF PurchLineTemp.FIND('-') THEN
    //           REPEAT
    //             IF (PurchLineTemp.Type <> PurchLineTemp.Type::" ") AND (PurchLineTemp."No." <> '') THEN
    //               BEGIN
    //                 PurchLine.GET(PurchLine."Document Type", PurchLine."Document No.", PurchLine."Line No.");
    //                 PurchLine.CALCFIELDS("Rem.Qty. (Base) in Purch.Order", "Qty. (Base) in Req. Line/Plan.");
    //                 IF (PurchLine."Outstanding Quantity" - PurchLine."Rem.Qty. (Base) in Purch.Order" - PurchLine.
    //         "Qty. (Base) in Req. Line/Plan.") <
    //                     PurchLineTemp."Qty. to Receive" THEN
    //                   PurchLine.VALIDATE("Qty. to Receive", PurchLine."Outstanding Quantity" - PurchLine."Rem.Qty. (Base) in Purch.Order" -
    //                     PurchLine."Qty. (Base) in Req. Line/Plan.")
    //                 ELSE
    //                   PurchLine.VALIDATE("Qty. to Receive", PurchLineTemp."Qty. to Receive");
    //                 PurchLine.Modify();
    //               END;
    //           UNTIL PurchLineTemp.NEXT() = 0;
    //     end;

    //     procedure ExistsBlanketOrderLine(PurchLine: Record "39")
    //     var
    //         PurchLine2: Record "39";
    //         Text01: Label 'There are some blanket orders you may use for %1 %2.';
    //         PossibleBlanketOrders5: Text[255];
    //     begin
    //         PurchLine2.SETCURRENTKEY("Document Type", Type, "No.", "Buy-from Vendor No.");
    //         PurchLine2.SETRANGE("Document Type", PurchLine."Document Type"::"Blanket Order");
    //         PurchLine2.SETRANGE(Type, PurchLine.Type);
    //         PurchLine2.SETRANGE("No.", PurchLine."No.");
    //         PurchLine2.SETRANGE("Buy-from Vendor No.", PurchLine."Buy-from Vendor No.");
    //         IF PurchLine2.FIND('-') THEN BEGIN
    //            PossibleBlanketOrders5 := '';
    //            REPEAT
    //               PurchLine2.CALCFIELDS( "Rem.Qty. (Base) in Purch.Order", "Qty. (Base) in Req. Line/Plan." );
    //               IF ( PurchLine2."Outstanding Quantity" > 0 ) AND
    //                  ( PurchLine2."Outstanding Quantity"  - PurchLine2."Rem.Qty. (Base) in Purch.Order" -
    //                    PurchLine2."Qty. (Base) in Req. Line/Plan." > 0 ) THEN BEGIN
    //                 IF STRPOS( PossibleBlanketOrders5, PurchLine2."Document No." ) = 0 THEN BEGIN
    //                    IF PossibleBlanketOrders5 <> '' THEN BEGIN
    //                       PossibleBlanketOrders5 := PossibleBlanketOrders5 + ', ' + PurchLine2."Document No.";
    //                    END ELSE BEGIN
    //                       PossibleBlanketOrders5 := PurchLine2."Document No.";
    //                    END;
    //                 END;
    //               END;
    //            UNTIL PurchLine2.NEXT() = 0;
    //            IF PossibleBlanketOrders5 <> '' THEN
    //               MESSAGE(Text01, PurchLine2.Type, PurchLine2."No.", PossibleBlanketOrders5 );
    //         END;
    //     end;

    //     procedure UserTestValidBlnktOrderDeact(PurchLine: Record "39")
    //     var
    //         Text01: Label 'Field is only used with %1.';
    //         UserSetup: Record "91";
    //         Text02: Label 'User %1 is not allowed to change the validation date.';
    //     begin
    //         IF PurchLine."Document Type" <> PurchLine."Document Type"::"Blanket Order" THEN
    //           ERROR(Text01, PurchLine.FIELDNAME(PurchLine."Document Type"));

    //         UserSetup.GET(Userid());
    //         /*
    //         IF UserSetup."Edit Valid.Test in Blank. Ord." THEN
    //           EXIT;

    //         ERROR(Text02, UserID());
    //         */

    //     end;

    procedure UserTestValidBlnktOrderHeDeact(PurchHeader: Record "Purchase Header")
    var
        UserSetup: Record "User Setup";
        Text01Txt: Label 'Field is only used with %1.', Comment = '%1';
    begin
        IF PurchHeader."Document Type" <> PurchHeader."Document Type"::"Blanket Order" THEN
            ERROR(Text01Txt, PurchHeader.FIELDNAME(PurchHeader."Document Type"));
        UserSetup.GET(USERID());
    end;

    //     procedure TestValidationBlnktOrderDate(PurchLine: Record "39")
    //     var
    //         Text01: Label 'In Line No. %1 the validation date is old.\Valid from %2 to %3.';
    //     begin
    //         IF (PurchLine."Document Type" <> PurchLine."Document Type"::"Blanket Order") OR
    //            (PurchLine."Qty. to Receive" = 0) THEN
    //           EXIT;

    //         IF TestBlnktOrderDate(PurchLine) THEN
    //           ERROR(Text01, PurchLine."Line No.", PurchLine."Blanket Order Valid from", PurchLine."Blanket Order Valid till");
    //     end;

    //     procedure TestBlnktOrderDate(PurchLine: Record "39"): Boolean
    //     begin
    //         EXIT(((PurchLine."Blanket Order Valid from" <> 0D) AND (PurchLine."Blanket Order Valid from" > TODAY)) OR
    //            ((PurchLine."Blanket Order Valid till" <> 0D) AND (PurchLine."Blanket Order Valid till" < TODAY)));
    //     end;

    //     procedure DefineSubjectAreaCode(RequisitionLine9: Record "246";SubjectAreaCode9: Code[20];UserID9: Code[20];PurchaserCodeGlobal9: Code[20])
    //     begin
    //         SubjectAreaCodeGlobal := SubjectAreaCode9;
    //         UserIDGlobal := UserID9;
    //         FromSubjectAreaCodeGlobal := TRUE;
    //         // FindReqLineForBlanketOrders(RequisitionLine9);
    //         "Purchaser CodeGlobal" := PurchaserCodeGlobal9;
    //     end;
}

