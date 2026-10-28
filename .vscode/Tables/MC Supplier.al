table 50111 "MC Supplier"
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

            trigger OnValidate()
            begin
                if "Name" = '' then
                    Error('Supplier Name cannot be empty.');
            end;
        }
        field(3; "Email"; text[100])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Email" = '' then
                    Error('Supplier Email cannot be empty.');
            end;
        }
        field(4; "Phone No."; text[30])
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
        key(Key2; "Email")
        {
        }
    }
}