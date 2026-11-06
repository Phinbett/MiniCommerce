page 50127 "MC Sales Order Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "MC Sales Order";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }

                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

            part(SalesLines; "MC Sales Order SubPage")
            {
                ApplicationArea = All;

                SubPageLink =
                    "Sales Order No." = field("No.");

                UpdatePropagation = Both;
            }

            group(Totals)
            {
                Caption = 'Totals';

                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ValidateOrder)
            {
                ApplicationArea = All;
                Caption = 'Validate Order';
                Image = Approve;

                trigger OnAction()
                var
                    SalesOrderManagement:
                    Codeunit "MC Sales Order Management";
                begin
                    SalesOrderManagement.ValidateOrder(Rec."No.");
                end;
            }

            action(ReleaseOrder)
            {
                ApplicationArea = All;
                Caption = 'Release Order';
                Image = ReleaseDoc;

                trigger OnAction()
                var
                    SalesOrderManagement: Codeunit "MC Sales Order Management";
                begin
                    SalesOrderManagement.ReleaseSalesOrder(Rec."No.");
                    CurrPage.Update(false);
                end;

            }
            action(Post)
            {
                Caption = 'Post';
                ApplicationArea = All;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                Enabled = Rec.Status = Rec.Status::Released;

                trigger OnAction()
                var
                    SalesPosting: Codeunit "MC Sales Order Management";
                begin
                    if not Confirm('Do you want to post this sales order?') then
                        exit;

                    SalesPosting.PostSalesOrder(Rec."No.");

                    CurrPage.Update(false);

                    Message('Sales order %1 has been posted successfully.', Rec."No.");
                end;
            }
        }
    }
}