table 50113 "MC Product"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Name"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Description"; text[250])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Category No."; code[20])
        {
            TableRelation = "MC Product Category"."No.";

        }
        field(5; "Supplier No."; code[20])
        {
            TableRelation = "MC Supplier"."No.";

        }
        field(6; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Inventory"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Active"; boolean)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then
            "No." := NoSeries.GetNextNo('MC-PRODUCT', WorkDate(), true);
    end;
}