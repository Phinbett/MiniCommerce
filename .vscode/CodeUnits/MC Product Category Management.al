codeunit 50133 "MC Product Category Management"
{

    procedure CreateProductCategory(
    Name: Text[100];
    Description: Text[250];
    Active: Boolean)
    var
        ProductCategory: Record "MC Product Category";
        ExistingCategory: Record "MC Product Category";
    begin
        if Name.Trim() = '' then
            Error('Product Category Name cannot be empty.');

        // Check for an existing category with the same name.
        ExistingCategory.SetRange(Name, Name);

        if not ExistingCategory.IsEmpty() then
            Error('Product Category %1 already exists.', Name);

        ProductCategory.Init();
        ProductCategory.Validate(Name, Name);
        ProductCategory.Validate(Description, Description);
        ProductCategory.Validate(Active, Active);

        // TRUE runs the table's OnInsert trigger.
        ProductCategory.Insert(true);
    end;

    procedure DeleteProductCategory(CategoryNo: Code[20])
    var
        ProductCategory: Record "MC Product Category";
        Product: Record "MC Product";
    begin
        if not ProductCategory.Get(CategoryNo) then
            Error('Product Category %1 does not exist.', CategoryNo);

        // Check if there are any products associated with this category
        //Product.SetRange("Category No.", CategoryNo);
        //if Product.FindSet() then
        //Error('Cannot delete Product Category %1 because there are products associated with it.', CategoryNo);

        ProductCategory.Active := false;
        ProductCategory.Modify();
    end;
}