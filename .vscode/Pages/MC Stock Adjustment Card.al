page 50148 "MC Stock Adjustment Card"
{
    Caption = 'Stock Adjustment';
    PageType = Document;
    SourceTable = "MC Stock Adjustment";
    ApplicationArea = All;

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

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

            part(AdjustmentLines; "MC Stock Adjustment SubPage")
            {
                ApplicationArea = All;
                SubPageLink = "Adjustment No." = field("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PostAdjustment)
            {
                Caption = 'Post Adjustment';
                ApplicationArea = All;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                Enabled = Rec.Status = Rec.Status::Open;

                trigger OnAction()
                var
                    StockAdjustmentPosting: Codeunit "MC Stock Adjustment Posting";
                begin
                    if not Confirm('Do you want to post this stock adjustment?') then
                        exit;

                    StockAdjustmentPosting.PostAdjustment(Rec."No.");

                    CurrPage.Update(false);

                    Message('Stock adjustment %1 has been posted successfully.', Rec."No.");
                end;
            }
        }
    }
}