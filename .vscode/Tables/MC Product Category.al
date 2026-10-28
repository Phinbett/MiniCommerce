table 50111 "MC Product Category"
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

        }
        field(3; "Description"; text[250])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Active"; boolean)
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

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name)
        {
        }
        fieldgroup(Brick; "No.", Name)
        {
        }
    }

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then
            "No." := NoSeries.GetNextNo('MC-PRODUCT-CATEGORY', WorkDate(), true);
    end;
}