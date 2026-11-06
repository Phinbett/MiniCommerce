table 50113 "MC Sales Order Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Sales Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "MC Sales Order"."No.";
        }

        field(2; "Line No."; Integer)
        {
            DataClassification = SystemMetadata;
        }

        field(3; "Product No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "MC Product"."No.";

            trigger OnValidate()
            var
                Product: Record "MC Product";
            begin
                if "Product No." = '' then
                    exit;

                if not Product.Get("Product No.") then
                    Error('Product %1 does not exist.', "Product No.");

                Description := Product.Name;
                Validate("Unit Price", Product."Unit Price");
            end;
        }

        field(4; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(5; Quantity; Integer)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Quantity <= 0 then
                    Error('Quantity must be greater than zero.');

                CalculateLineAmount();
            end;
        }

        field(6; "Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Unit Price" < 0 then
                    Error('Unit Price cannot be negative.');

                CalculateLineAmount();
            end;
        }

        field(7; "Line Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(8; "Order Date"; Date)
        {
            DataClassification = CustomerContent;

        }
    }

    keys
    {
        key(PK; "Sales Order No.", "Line No.")
        {
            Clustered = true;
        }

        key(ProductKey; "Product No.")
        {
        }
    }

    local procedure CalculateLineAmount()
    begin
        "Line Amount" := Quantity * "Unit Price";
    end;

    trigger OnInsert()
    begin
        if "Order Date" = 0D then
            "Order Date" := WorkDate();
    end;
}
