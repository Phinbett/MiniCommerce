page 50130 "MC Product Statistics"
{
    PageType = CardPart;
    ApplicationArea = All;
    SourceTable = "MC Product";

    layout
    {
        area(Content)
        {
            group(Statistics)
            {
                Caption = 'Product Statistics';

                field("Total Quantity Sold"; Rec."Total Quantity Sold")
                {
                    ApplicationArea = All;
                }

                field("Sales Amount"; Rec."Sales Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}