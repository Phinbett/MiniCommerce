table 50112 "MC Product"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(2; "Name"; Text[100])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Name = '' then
                    Error('Product Name cannot be empty.');
            end;
        }

        field(3; "Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }

        field(4; "Category No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "MC Product Category"."No.";
        }

        field(5; "Supplier No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "MC Supplier"."No.";
        }

        field(6; "Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Unit Price" < 0 then
                    Error('Unit Price cannot be negative.');
            end;
        }

        field(7; "Inventory"; Integer)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Inventory < 0 then
                    Error('Inventory cannot be negative.');
            end;
        }

        field(8; "Active"; Boolean)
        {
            DataClassification = CustomerContent;
        }

        field(20; "Total Quantity Sold"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("MC Sales Order Line".Quantity
                WHERE("Product No." = FIELD("No.")));
        }

        field(21; "Sales Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("MC Sales Order Line"."Line Amount"
                WHERE("Product No." = FIELD("No."),
                      "Order Date" = FIELD("Date Filter")));
        }

        field(30; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }

        key(Category; "Category No.")
        {
        }

        key(Supplier; "Supplier No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, "Unit Price")
        {
        }

        fieldgroup(Brick; "No.", Name, "Unit Price")
        {
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