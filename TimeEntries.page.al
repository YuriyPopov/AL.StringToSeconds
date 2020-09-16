page 51100 "Time Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Time Entry";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(String; Rec.String)
                {
                    ApplicationArea = All;
                }
                field(Seconds; Rec.Seconds)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}