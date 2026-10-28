page 50125 "MC Supplier List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "MC Supplier";

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
                field(Email; rec.Email)
                {

                }
                field(Phone; rec."Phone No.")
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