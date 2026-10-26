table 50110 "MC Customer"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "NO."; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Name"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Email"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Phone No."; text[30])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Active"; boolean)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "NO.")
        {
            Clustered = true;
        }
        key(Key2; "Email")
        {
        }
    }
}