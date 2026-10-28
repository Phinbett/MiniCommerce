table 50113 "MC Sales Order Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sales Order No."; code[20])
        {
            TableRelation = "MC Sales Order"."No.";
        }
        field(2; "Line No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Product No."; code[20])
        {
            TableRelation = "MC Product"."No.";
        }
        field(5; "Quantity"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Line Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Order Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Sales Order No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
    begin
        if "Line No." = '' then
            "Line No." := NoSeries.GetNextNo('MC-SALES-ORDER-LINE', WorkDate(), true);
    end;
}