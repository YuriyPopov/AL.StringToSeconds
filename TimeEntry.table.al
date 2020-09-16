table 51100 "Time Entry"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }

        field(10; Seconds; Integer)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                String := SecToTimeStr(Seconds);
            end;

        }
        field(20; String; Text[50])
        {
            DataClassification = CustomerContent;
            CharAllowed = '++--09HHhhMMmm,,..  ';

            trigger OnValidate()
            begin
                Validate(Seconds, ParseWorkedTime(String));
            end;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        EvaluationErrorMsg: Label 'Evaluation error';

    local procedure ParseWorkedTime(TimeData: text): Integer
    var
        ListOfText: List of [Text];
        ListItem: Text;
        i: Integer;
        TimeSeconds: Integer;
    begin
        TimeData := TimeData.ToLower();
        // TimeData := TimeData.Replace(',', '.');
        TimeData := TimeData.Replace(' ', '$');
        TimeData := TimeData.Replace('h', 'h$');
        TimeData := TimeData.Replace('m', 'm$');
        ListOfText := TimeData.Split('$');

        for i := 1 to ListOfText.Count() do begin
            ListItem := ListOfText.get(i);
            case true of
                ListItem.Contains('h'):
                    IncreaseTimeSeconds(TimeSeconds, ListItem, 'h', 3600);
                ListItem.Contains('m'):
                    IncreaseTimeSeconds(TimeSeconds, ListItem, 'm', 60);
                else
                    IncreaseTimeSeconds(TimeSeconds, ListItem, 'h', 3600);
            end;
        end;

        exit(TimeSeconds);

    end;

    local procedure IncreaseTimeSeconds(var TimeSeconds: Integer; CurrValue: Text; Unit: Text; Factor: Integer)
    var
        EvaluatedValue: Decimal;
    begin

        if Unit <> '' then
            CurrValue := CurrValue.Replace(Unit, '');

        if StrLen(CurrValue) = 0 then
            exit;

        if Evaluate(EvaluatedValue, CurrValue) then
            TimeSeconds += Round(EvaluatedValue * Factor, 1, '=')
        else
            Error(EvaluationErrorMsg);

    end;

    local procedure SecToTimeStr(TimeSeconds: Integer): Text[15]
    var
        h: Integer;
        m: Integer;
        template: Text;
        result: Text;
    begin

        h := TimeSeconds div 3600;
        m := TimeSeconds div 60 - 60 * h;

        if h > 0 then
            template += '%1h ';

        if m > 0 then
            template += '%2m';

        result := StrSubstNo(template, Format(h), Format(m));
        result := result.Trim();

        exit(copystr(result, 1, 15));

    end;
}