report 50141 "MC Product Sales Report"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'MiniCommerce Product Sales';

    dataset
    {
        dataitem(Product; "MC Product")
        {
            column(ProductNo; "No.")
            {
            }

            column(ProductName; Name)
            {
            }

            column(UnitPrice; "Unit Price")
            {
            }

            column(Inventory; Inventory)
            {
            }
        }
    }
}