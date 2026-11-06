
table 50140 "MC Inventory Entry"
{
    Caption = 'MC Inventory Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        field(2; "Product No."; Code[20])
        {
            Caption = 'Product No.';
            TableRelation = "MC Product"."No.";

            trigger OnValidate()
            var
                Product: Record "MC Product";
            begin
                if Product.Get("Product No.") then
                    Description := Product.Name;
            end;
        }

        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }

        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }

        field(5; "Entry Type"; Enum "MC Inventory Entry Type")
        {
            Caption = 'Entry Type';
        }

        field(6; Quantity; Integer)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                if Quantity = 0 then
                    Error('Inventory quantity cannot be zero.');
            end;
        }

        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(ProductDate; "Product No.", "Posting Date")
        {
        }
    }
}
