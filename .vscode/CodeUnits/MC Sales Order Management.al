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
        SalesOrderLine: Record "MC Sales Order Line";
        Product: Record "MC Product";

        ProductTotals: Dictionary of [Text, Decimal];
        CheckedProducts: Dictionary of [Text, Boolean];

        TotalQuantity: Decimal;
        IsChecked: Boolean;
    begin
        // First pass: aggregate required quantities by product.
        SalesOrderLine.SetRange("Sales Order No.", SalesOrderNo);

        if SalesOrderLine.FindSet() then begin
            repeat
                if SalesOrderLine.Quantity <= 0 then
                    Error(
                        'Invalid quantity on sales order line %1.',
                        SalesOrderLine."Line No."
                    );

                if not ProductTotals.Get(SalesOrderLine."Product No.", TotalQuantity) then
                    TotalQuantity := 0;

                TotalQuantity += SalesOrderLine.Quantity;

                ProductTotals.Set(SalesOrderLine."Product No.", TotalQuantity);
            until SalesOrderLine.Next() = 0;
        end;

        // Second pass: check each product only once.
        SalesOrderLine.Reset();
        SalesOrderLine.SetRange("Sales Order No.", SalesOrderNo);

        if SalesOrderLine.FindSet() then begin
            repeat
                if not CheckedProducts.Get(SalesOrderLine."Product No.", IsChecked) then
                    IsChecked := false;

                if not IsChecked then begin
                    Product.Get(SalesOrderLine."Product No.");
                    Product.CalcFields(Inventory);

                    ProductTotals.Get(SalesOrderLine."Product No.", TotalQuantity);

                    if Product.Inventory < TotalQuantity then
                        Error(
                            'Insufficient stock for product %1. Available: %2. Required: %3.',
                            Product."No.",
                            Product.Inventory,
                            TotalQuantity
                        );

                    CheckedProducts.Set(SalesOrderLine."Product No.", true);
                end;
            until SalesOrderLine.Next() = 0;
        end;
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

    procedure PostSalesOrder(SalesOrderNo: Code[20])
    var
        SalesOrder: Record "MC Sales Order";
        SalesOrderLine: Record "MC Sales Order Line";
        InventoryEntry: Record "MC Inventory Entry";
        SalesOrderManagement: Codeunit "MC Sales Order Management";
    begin
        SalesOrder.Get(SalesOrderNo);

        if SalesOrder.Status <> SalesOrder.Status::Released then
            Error('Only released sales orders can be posted.');

        // Lock the inventory ledger before rechecking stock.
        InventoryEntry.LockTable();

        // Revalidate stock immediately before posting.
        SalesOrderManagement.CheckStock(SalesOrderNo);

        SalesOrderLine.SetRange("Sales Order No.", SalesOrderNo);

        if not SalesOrderLine.FindSet() then
            Error('The sales order has no lines.');

        repeat
            InventoryEntry.Init();

            InventoryEntry.Validate("Product No.", SalesOrderLine."Product No.");
            InventoryEntry.Validate("Posting Date", SalesOrder."Order Date");
            InventoryEntry."Document No." := SalesOrder."No.";
            InventoryEntry.Validate("Entry Type", InventoryEntry."Entry Type"::Sale);

            // Sales reduce inventory.
            InventoryEntry.Validate(Quantity, -SalesOrderLine.Quantity);

            InventoryEntry.Description :=
                CopyStr(
                    StrSubstNo(
                        'Sales Order %1',
                        SalesOrder."No."
                    ),
                    1,
                    MaxStrLen(InventoryEntry.Description)
                );

            InventoryEntry.Insert(true);
        until SalesOrderLine.Next() = 0;

        SalesOrder.Status := SalesOrder.Status::Posted;
        SalesOrder.Modify(true);
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