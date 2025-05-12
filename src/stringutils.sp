// stringutils.sp

fun TextWrapper(text, wrapLine, lineLimiter) { 

    local.requestedText = "";
    length = text.Length();

    currentLineLength = 0;
    lines = 1;
    for (i = 0; i < length; i++) {
        currentChar = text.CharAt(i);

        if (lines <= lineLimiter) {
            if (currentChar == "\n") {
                currentLineLength = 0;
                lines++;
                requestedText += currentChar;
            }
            else if (currentChar == " " && currentLineLength + 1 >= wrapLine) {
                currentLineLength = 0;
                lines++;
                requestedText += "\n";
            }
            else {
                requestedText += currentChar;
                currentLineLength++;
            }
        }
        else {
            requestedText += "...";
            break;
        }

    }

    return requestedText;
}

fun Format(string, param) {
    local.requestedText = "";
    for (i = 0; i < string.Length(); i++) {
        firstChar = string.CharAt(i);
        secondChar = string.CharAt(i + 1);

        if (firstChar == "%" && secondChar == "i") {
            requestedText += param;
            i += 1;
        }
        else
        {
            requestedText += firstChar;
        }
    }

    return requestedText;
}

fun CountLines(string) {
    local.lines = 1;
    for (i = 0; i < string.Length(); i++) {
        if (string.CharAt(i) == "\n") {
            lines++;
        }
    }

    return lines;
}

fun CreateMany(char, times) {
    text = "";
    for (i = 0; i <= times; i++) {
        text += char;
    }

    return text;
}