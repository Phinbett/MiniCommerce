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
            group(Details)
            {
                field("No."; rec."No.")
                {

                }
                field("Name"; rec."Name")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Category No."; rec."Category No.")
                {

                }
                field("Supplier No."; rec."Supplier No.")
                {

                }
                field("Unit Price"; rec."Unit Price")
                {

                }
                field("Inventory"; rec."Inventory")
                {

                }
                field("Active"; rec."Active")
                {

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}