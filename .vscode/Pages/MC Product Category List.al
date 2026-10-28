page 50122 "MC Product Category List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "MC Product Category";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                }
                field("Name"; Rec."Name")
                {
                }
                field("Description"; Rec."Description")
                {
                }
                field("Active"; Rec."Active")
                {
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ProductCategoryManagement: Codeunit "MC Product Category Management";
    begin

        // if not Dialog.Confirm(
        //     'Create product category %1?',
        //     false,
        //     Rec.Name)
        // then
        //     exit(false);

        ProductCategoryManagement.CreateProductCategory(
            Rec.Name,
            Rec.Description,
            Rec.Active);

        exit(false);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ProductCategoryManagement: Codeunit "MC Product Category Management";
    begin
        if not Dialog.Confirm(
            'Delete product category %1?',
            false,
            Rec."No.")
        then
            exit(false);
        ProductCategoryManagement.DeleteProductCategory(Rec."No.");
        exit(true);
    end;
}