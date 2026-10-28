page 50120 "MC Customer List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "MC Customer";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("NO."; rec."NO.")
                {
                }
                field("Name"; rec."Name")
                {
                }
                field("Email"; rec."Email")
                {
                }
                field("Phone No."; rec."Phone No.")
                {
                }
                field("Active"; rec."Active")
                {
                }
            }
        }
        area(Factboxes)
        {

        }
    }
    trigger OnModifyRecord(): Boolean
    var
        CustomerManagement: Codeunit "MC Customer Management";
    begin
        if not Dialog.Confirm(
            'Update customer %1?',
            false,
            Rec."No.")
        then
            exit(false);

        CustomerManagement.UpdateCustomer(Rec, Rec.Name, Rec.Email, Rec."Phone No.");
        exit(true);
    end;
}