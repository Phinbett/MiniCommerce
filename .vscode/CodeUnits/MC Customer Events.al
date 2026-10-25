codeunit 50111 "MC Customer Events"
{
    // Event subscriber
    [EventSubscriber(
        ObjectType::Codeunit,
        Codeunit::"MC Customer Management",
        'OnAfterCustomerUpdated',
        '',
        false,
        false)]
    local procedure CustomerUpdated(
        var Customer: Record "MC Customer";
        NewName: Text[100];
        NewEmail: Text[100];
        NewPhoneNo: Text[30])
    begin
        Message(
            'Customer %1 has been updated.',
            Customer."No.");
    end;
}