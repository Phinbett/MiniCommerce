table 50142 "MC Stock Adjustment Line"
{
    Caption = 'Stock Adjustment Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Adjustment No."; integer)
        {
            Caption = 'Adjustment No.';
            TableRelation = "MC Stock Adjustment"."No.";
            DataClassification = CustomerContent;
        }

        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }

        field(3; "Product No."; Code[20])
        {
            Caption = 'Product No.';
            TableRelation = "MC Product"."No.";

            trigger OnValidate()
            var
                Product: Record "MC Product";
            begin
                if "Product No." = '' then begin
                    Description := '';
                    exit;
                end;

                Product.Get("Product No.");
                Description := Product.Name;
            end;
        }

        field(4; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(5; Quantity; Decimal)
        {
            Caption = 'Adjustment Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                if Quantity = 0 then
                    Error('Adjustment quantity cannot be zero.');
            end;
        }
    }

    keys
    {
        key(PK; "Adjustment No.", "Line No.")
        {
            Clustered = true;
        }

        key(Product; "Product No.")
        {
        }
    }

    trigger OnInsert()
    begin
        CheckAdjustmentIsOpen();
    end;

    trigger OnModify()
    begin
        CheckAdjustmentIsOpen();
    end;

    trigger OnDelete()
    begin
        CheckAdjustmentIsOpen();
    end;

    local procedure CheckAdjustmentIsOpen()
    var
        StockAdjustment: Record "MC Stock Adjustment";
    begin
        if not StockAdjustment.Get("Adjustment No.") then
            Error('Stock adjustment %1 does not exist.', "Adjustment No.");

        if StockAdjustment.Status <> StockAdjustment.Status::Open then
            Error('You can only modify lines on an open stock adjustment.');
    end;
}