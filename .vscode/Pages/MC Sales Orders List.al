page 50124 "MC Sales Orders List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "MC Sales Order";
    CardPageId = "MC Sales Order Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(No; rec."No.")
                {

                }
                field(Customer; rec."Customer No.")
                {

                }
                field("Order Date"; rec."Order Date")
                {

                }
                field(Status; rec.Status)
                {

                }
                field("Total Amount"; rec."Total Amount")
                {

                }
            }
        }
        area(Factboxes)
        {

        }
    }
}