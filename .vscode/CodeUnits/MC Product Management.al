codeunit 50130 "MC Product Management"
{
    procedure CalculateProductSales(ProductNo: Code[20]): Decimal
    var
        Product: Record "MC Product";
    begin
        if not Product.Get(ProductNo) then
            Error('Product %1 does not exist.', ProductNo);

        Product.CalcFields("Sales Amount");

        exit(Product."Sales Amount");
    end;

    procedure GetProductSalesForPeriod(
    ProductNo: Code[20];
    StartDate: Date;
    EndDate: Date): Decimal
    var
        Product: Record "MC Product";
    begin
        if not Product.Get(ProductNo) then
            Error('Product %1 does not exist.', ProductNo);

        Product.SetRange("Date Filter", StartDate, EndDate);

        Product.CalcFields("Sales Amount");

        exit(Product."Sales Amount");
    end;

    procedure GetAllProductSalesForPeriod(
        StartDate: Date;
        EndDate: Date): Decimal
    var
        Product: Record "MC Product";
        TotalSales: Decimal;
    begin
        Product.SetRange("Date Filter", StartDate, EndDate);
        Product.CalcFields("Sales Amount");
        TotalSales := Product."Sales Amount";
        exit(TotalSales);
    end;

    procedure DeleteProduct(ProductNo: Code[20])
    var
        Product: Record "MC Product";
    begin
        if not Product.Get(ProductNo) then
            Error('Product %1 does not exist.', ProductNo);

        //ask user for confirmation before deleting the product
        if not Confirm(StrSubstNo('Are you sure you want to delete product %1?', ProductNo), false) then
            exit;

        //set product as inactive instead of deleting it
        Product.Active := false;
        Product.Modify();
    end;

    procedure GetProductSoldQuantityForPeriod(
        ProductNo: Code[20];
        StartDate: Date;
        EndDate: Date): Decimal
    var
        Product: Record "MC Product";
    begin
        if not Product.Get(ProductNo) then
            Error('Product %1 does not exist.', ProductNo);

        Product.SetRange("Date Filter", StartDate, EndDate);
        Product.CalcFields("Total Quantity Sold");
        exit(Product."Total Quantity Sold");
    end;

    procedure GetAllProductsSoldQuantityForPeriod(
            StartDate: Date;
            EndDate: Date): Decimal
    var
        Product: Record "MC Product";
        TotalQuantitySold: Decimal;
    begin
        Product.SetRange("Date Filter", StartDate, EndDate);
        Product.CalcFields("Total Quantity Sold");
        TotalQuantitySold := Product."Total Quantity Sold";
        exit(TotalQuantitySold);
    end;

    procedure UpdateProduct(NewName: Text[100]; NewCategoryNo: Code[20]; NewSupplierNo: Code[20]; NewUnitPrice: Decimal; NewInventory: Integer; NewActive: Boolean)
    var
        Product: Record "MC Product";
    begin
        if not Product.Get(NewName) then
            Error('Product %1 does not exist.', NewName);
        Product.Validate("Name", NewName);
        Product.Validate("Category No.", NewCategoryNo);
        Product.Validate("Supplier No.", NewSupplierNo);
        Product.Validate("Unit Price", NewUnitPrice);
        Product.Validate("Inventory", NewInventory);
        Product.Validate("Active", NewActive);
        Product.Modify();
    end;

    procedure DeactivateProduct(ProductNo: Code[20])
    var
        Product: Record "MC Product";
    begin
        if not Product.Get(ProductNo) then
            Error('Product %1 does not exist.', ProductNo);

        Product.Active := false;
        Product.Modify();
    end;
}