codeunit 50144 "MC Stock Adjustment Posting"
{
    procedure PostAdjustment(AdjustmentNo: integer)
    var
        StockAdjustment: Record "MC Stock Adjustment";
        AdjustmentLine: Record "MC Stock Adjustment Line";
        InventoryEntry: Record "MC Inventory Entry";
        Product: Record "MC Product";

        ProductTotals: Dictionary of [Text, Decimal];
        CheckedProducts: Dictionary of [Text, Boolean];

        TotalQuantity: Decimal;
        IsChecked: Boolean;
        HasLines: Boolean;
    begin
        StockAdjustment.Get(AdjustmentNo);

        if StockAdjustment.Status <> StockAdjustment.Status::Open then
            Error('Only open stock adjustments can be posted.');

        // Lock the ledger before checking stock and creating entries.
        InventoryEntry.LockTable();

        // First pass: collect quantities for each product.
        AdjustmentLine.SetRange("Adjustment No.", AdjustmentNo);

        if AdjustmentLine.FindSet() then begin
            repeat
                HasLines := true;

                if AdjustmentLine."Product No." = '' then
                    Error('Line %1 has no product selected.', AdjustmentLine."Line No.");

                if AdjustmentLine.Quantity = 0 then
                    Error('Line %1 has a zero adjustment quantity.', AdjustmentLine."Line No.");

                if not ProductTotals.Get(AdjustmentLine."Product No.", TotalQuantity) then
                    TotalQuantity := 0;

                TotalQuantity += AdjustmentLine.Quantity;

                ProductTotals.Set(AdjustmentLine."Product No.", TotalQuantity);
            until AdjustmentLine.Next() = 0;
        end;

        if not HasLines then
            Error('There are no adjustment lines to post.');

        // Second pass: check the resulting stock for each distinct product.
        AdjustmentLine.Reset();
        AdjustmentLine.SetRange("Adjustment No.", AdjustmentNo);

        if AdjustmentLine.FindSet() then begin
            repeat
                if not CheckedProducts.Get(AdjustmentLine."Product No.", IsChecked) then
                    IsChecked := false;

                if not IsChecked then begin
                    Product.Get(AdjustmentLine."Product No.");
                    Product.CalcFields(Inventory);

                    ProductTotals.Get(AdjustmentLine."Product No.", TotalQuantity);

                    if Product.Inventory + TotalQuantity < 0 then
                        Error(
                            'Insufficient stock for product %1. Current stock: %2. Net adjustment: %3.',
                            Product."No.",
                            Product.Inventory,
                            TotalQuantity
                        );

                    CheckedProducts.Set(AdjustmentLine."Product No.", true);
                end;
            until AdjustmentLine.Next() = 0;
        end;

        // Third pass: create one permanent ledger entry per line.
        AdjustmentLine.Reset();
        AdjustmentLine.SetRange("Adjustment No.", AdjustmentNo);

        if AdjustmentLine.FindSet() then begin
            repeat
                InventoryEntry.Init();

                InventoryEntry.Validate("Product No.", AdjustmentLine."Product No.");
                InventoryEntry.Validate("Posting Date", StockAdjustment."Posting Date");
                InventoryEntry."Document No." := Format(StockAdjustment."No.");
                InventoryEntry.Validate("Entry Type", InventoryEntry."Entry Type"::Adjustment);
                InventoryEntry.Validate(Quantity, AdjustmentLine.Quantity);

                // Preserve the description captured on the adjustment line.
                InventoryEntry.Description := AdjustmentLine.Description;

                InventoryEntry.Insert(true);
            until AdjustmentLine.Next() = 0;
        end;

        // Finally, mark the document as posted.
        StockAdjustment.Status := StockAdjustment.Status::Posted;
        StockAdjustment.Modify(true);
    end;
}