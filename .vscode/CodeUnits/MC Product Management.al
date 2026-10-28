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

}