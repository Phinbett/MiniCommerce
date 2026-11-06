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
            Caption = 'Total Amount';
            FieldClass = FlowField;

            CalcFormula = Sum(
        "MC Sales Order Line"."Line Amount"
        WHERE("Sales Order No." = FIELD("No."))
    );
        }
        field(4; "Status"; Enum "MC Sales Order Status")
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

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then
            "No." := NoSeries.GetNextNo('MC-SALES-ORDER', WorkDate(), true);

        if "Order Date" = 0D then
            "Order Date" := WorkDate();
    end;
}