page 50147 "MC Stock Adjustment SubPage"
{
    Caption = 'Adjustment Lines';
    PageType = ListPart;
    SourceTable = "MC Stock Adjustment Line";
    ApplicationArea = All;

    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Product No."; Rec."Product No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the product being adjusted.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter a positive quantity to increase stock or a negative quantity to decrease stock.';
                }
            }
        }
    }
}