table 50141 "MC Stock Adjustment"
{
    Caption = 'Stock Adjustment';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; integer)
        {
            Caption = 'No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }

        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }

        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(4; Status; Enum "MC Stock Adjustment Status")
        {
            Caption = 'Status';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();
    end;

    // trigger OnModify()
    // begin
    //     if xRec.Status = xRec.Status::Posted then
    //         Error('A posted stock adjustment cannot be modified.');
    // end;

    trigger OnDelete()
    begin
        if Status = Status::Posted then
            Error('A posted stock adjustment cannot be deleted.');
    end;
}