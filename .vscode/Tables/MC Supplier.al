table 50115 "MC Supplier"
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

    fieldGroups
    {
        fieldGroup(DropDown; "No.", Name)
        {
        }
        fieldGroup(Brick; "No.", Name)
        {
        }
    }

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            "No." := NoSeries.GetNextNo('MC-SUPPLIER', WorkDate(), true);
            if "No." = '' then
                Error('The Number Series "MC-SUPPLIER" is not set up correctly.');
        end;
    end;
}