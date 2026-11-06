codeunit 50145 "MC Sales Order Management"
{
    procedure GetSalesOrder(
    SalesOrderNo: Code[20];
    var SalesOrder: Record "MC Sales Order")
    begin
        if not SalesOrder.Get(SalesOrderNo) then
            Error(
                'Sales Order %1 does not exist.',
                SalesOrderNo);
    end;

    procedure ValidateCustomer(CustomerNo: Code[20])
    var
        Customer: Record "MC Customer";
    begin
        if CustomerNo = '' then
            Error('A customer must be selected.');

        if not Customer.Get(CustomerNo) then
            Error(
                'Customer %1 does not exist.',
                CustomerNo);

        if not Customer.Active then
            Error(
                'Customer %1 is inactive.',
                CustomerNo);
    end;

    procedure ValidateOrderLines(SalesOrderNo: Code[20])
    var
        SalesLine: Record "MC Sales Order Line";
        Product: Record "MC Product";
    begin
        SalesLine.SetRange("Sales Order No.", SalesOrderNo);

        if SalesLine.IsEmpty() then
            Error('The Sales Order has no lines.');

        if SalesLine.FindSet() then
            repeat
                if SalesLine."Product No." = '' then
                    Error('A product must be selected on line %1.',
                        SalesLine."Line No.");

                if not Product.Get(SalesLine."Product No.") then
                    Error('Product %1 does not exist.',
                        SalesLine."Product No.");

                if not Product.Active then
                    Error('Product %1 is inactive.',
                        Product.Name);

                if SalesLine.Quantity <= 0 then
                    Error('Quantity must be greater than zero on line %1.',
                        SalesLine."Line No.");

                if SalesLine."Unit Price" <= 0 then
                    Error('A valid unit price is required on line %1.',
                        SalesLine."Line No.");

            until SalesLine.Next() = 0;
    end;

    procedure CalculateOrderTotal(
        SalesOrderNo: Code[20]): Decimal
    var
        SalesOrder: Record "MC Sales Order";
    begin
        GetSalesOrder(SalesOrderNo, SalesOrder);

        SalesOrder.CalcFields("Total Amount");

        exit(SalesOrder."Total Amount");
    end;

    procedure CheckStock(SalesOrderNo: Code[20])
    var
        SalesLine: Record "MC Sales Order Line";
        Product: Record "MC Product";
    begin
        SalesLine.SetRange("Sales Order No.", SalesOrderNo);

        if SalesLine.FindSet() then
            repeat
                if not Product.Get(SalesLine."Product No.") then
                    Error('Product %1 does not exist.',
                        SalesLine."Product No.");

                if Product.Inventory < SalesLine.Quantity then
                    Error(
                        'Insufficient stock for %1. Available: %2, Requested: %3.',
                        Product.Name,
                        Product.Inventory,
                        SalesLine.Quantity);

            until SalesLine.Next() = 0;
    end;

    procedure ReleaseSalesOrder(SalesOrderNo: Code[20])
    var
        SalesOrder: Record "MC Sales Order";
    begin
        GetSalesOrder(SalesOrderNo, SalesOrder);

        if SalesOrder.Status <> SalesOrder.Status::Open then
            Error('Only Open Sales Orders can be released.');

        // Run all business validations first.
        ValidateOrder(SalesOrderNo);

        // Change status only after validation succeeds.
        SalesOrder.Validate(Status, SalesOrder.Status::Released);
        SalesOrder.Modify(true);

        Message('Sales Order %1 has been released.', SalesOrderNo);
    end;

    procedure ValidateOrder(SalesOrderNo: Code[20])
    var
        SalesOrder: Record "MC Sales Order";
    begin
        GetSalesOrder(SalesOrderNo, SalesOrder);

        ValidateCustomer(SalesOrder."Customer No.");

        ValidateOrderLines(SalesOrderNo);

        CheckStock(SalesOrderNo);

        Message('Sales Order %1 passed validation.',
            SalesOrderNo);
    end;
}