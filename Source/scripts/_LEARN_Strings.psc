scriptname _LEARN_Strings Hidden
{Localization support for scripts. 
author:nexusishere}

string function SubStringSafe(string source, int startIndex, int len) global
{Uses StringUtil.SubString underneath. if len = 0 returns empty string}
;/ StringUtil thinks we want all remaining part of the string if len = 0. 
imo default value should be -1 and 0 should be a valid input for returning empty string.
It is more useful for batch operations that way /;
    if (len == 0)
        return "";
    endIf
    return StringUtil.SubString(source, startIndex, len);
endFunction

string function StringReplaceAll(string source, string replaceFrom, string replaceTo) global
{Replaces all occurences of replaceFrom from source text with replaceTo paramater}
    if (!replaceFrom || replaceFrom == "" || !source)
        return source;
    endIf
    int lastIndex = 0;
    int p = StringUtil.Find(source, replaceFrom);
    string output = "";
    int rlen = StringUtil.GetLength(replaceFrom);
    while (p >= 0)
        output += (SubStringSafe(source, lastIndex, p - lastIndex) + replaceTo)
        lastIndex = p + rlen;
        p = StringUtil.Find(source, replaceFrom, lastIndex);
    endWhile
    output += SubStringSafe(source, lastIndex, StringUtil.GetLength(source) - lastIndex)

    return output;
endFunction

string function FormatString1(string source, string p1) global
    return StringReplaceAll(source, "{0}", p1)
endFunction

string function __l(string keyName, string defaultValue = "") global
{use this function to translate text. Function name is unusual for more readable code}
    string r = JsonUtil.GetStringValue("SpellLearning_Strings.json", keyName, "");
    if (!r || r == "")
        Debug.Trace("[Spell Learning] Localization entry not found => " + keyName);
        if (defaultValue == "")
            return keyName;
        endIf
        return defaultValue 
    endIf
    return r;
endFunction

int function GetMenuLangId() global
    ; we don't allow this to be higher than 9. 
    return JsonUtil.GetIntValue("SpellLearning_Strings.json", "menu_lang_id", 0) % 10;
endFunction

string function FormatString2(string source, string p1, string p2) global
    string r = FormatString1(source, p1)
    return StringReplaceAll(r, "{1}", p2);
endFunction
