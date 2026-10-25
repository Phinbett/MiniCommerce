codeunit 50110 "MC Customer Management"
{
    // Explicit business operation
    procedure UpdateCustomer(var Customer: Record "MC Customer"; NewName: Text[100]; NewEmail: Text[100]; NewPhoneNo: Text[30])
    begin
        if NewName.Trim() = '' then
            Error('Customer name cannot be empty.');
        if NewEmail.Trim() = '' then
            Error('Customer email cannot be empty.');

        Customer.Validate(Name, NewName);
        Customer.Validate(Email, NewEmail);
        Customer.Validate("Phone No.", NewPhoneNo);
        Customer.Modify();

        OnAfterCustomerUpdated(Customer, NewName, NewEmail, NewPhoneNo);
    end;


    // Event publisher
    [IntegrationEvent(false, false)]
    local procedure OnAfterCustomerUpdated(
        var Customer: Record "MC Customer";
        NewName: Text[100];
        NewEmail: Text[100];
        NewPhoneNo: Text[30])
    begin
    end;
}