table 50114 "MC Sales Order"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Customer No."; code[20])
        {
            TableRelation = "MC Customer"."No.";
        }
        field(5; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Status"; Enum "MC Order Status")
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Order Date"; Date)
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
}