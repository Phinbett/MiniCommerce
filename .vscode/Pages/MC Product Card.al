page 50121 "MC Product Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MC Product";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                field("Category No."; Rec."Category No.")
                {
                    ApplicationArea = All;
                }

                field("Supplier No."; Rec."Supplier No.")
                {
                    ApplicationArea = All;
                }
            }

            group(Pricing)
            {
                Caption = 'Pricing';

                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
            }

            group(Inventory)
            {
                Caption = 'Inventory';

                field("Inventory Qty"; Rec.Inventory)
                {
                    ApplicationArea = All;
                }

                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part(ProductStatistics; "MC Product Statistics")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CalculateSales)
            {
                ApplicationArea = All;
                Caption = 'Calculate Sales';
                Image = Calculate;

                trigger OnAction()
                var
                    ProductManagement: Codeunit "MC Product Management";
                    SalesAmount: Decimal;
                begin
                    SalesAmount :=
                        ProductManagement.CalculateProductSales(Rec."No.");

                    Message(
                        'Product %1 has generated %2 in sales.',
                        Rec.Name,
                        SalesAmount);
                end;
            }
        }
    }
}