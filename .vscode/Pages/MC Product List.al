page 50123 "MC Product List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "MC Product";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(No; rec."No.")
                {

                }
                field(Name; rec.Name)
                {

                }
                field(Description; rec.Description)
                {

                }
                field(Price; rec."Unit Price")
                {

                }
                field(Category; rec."Category No.")
                {

                }
                field(Supplier; rec."Supplier No.")
                {

                }
                field(Inventory; rec.Inventory)
                {

                }
                field(Active; rec.Active)
                {
                }
            }
        }
        area(Factboxes)
        {

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
}