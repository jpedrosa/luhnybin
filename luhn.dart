
#library('luhn');
#import('util.dart');

class Luhn {

  final DOUBLE_DIGITS = const [0, 2, 4, 6, 8, 1, 3, 5, 7, 9];

  bool testIt(List a, num startAt, num maxLen) {
    var total = 0;
    var doubleDigit = false;
    for (var i = startAt + maxLen - 1; i >= startAt; i--) {
      total += doubleDigit ? DOUBLE_DIGITS[a[i]] : a[i];
      doubleDigit = !doubleDigit;
    }
    return total % 10 == 0;
  }

  String mask(String s) {
    var masked = null;
    var i = 0;
    var digitCount = 0;
    var maskOffset = -1;
    var digits = [];
    var len = s.length;
    while (i < len) {
      var c = s[i].charCodeAt(0);
      if (c >= 48 && c <= 57) { //between 0 and 9
        digitCount += 1;
        digits.add(c - 48);
        if (digitCount >= 14) {
          for (var theLen = digitCount < 16 ? digitCount : 16; theLen >= 14; theLen--) {
            var startAt = digitCount - theLen;
            if (testIt(digits, startAt, theLen)) {
              if (masked === null) { masked = s.splitChars(); }
              var j = i;
              var maskLen = theLen;
              while (maskLen > 0 && j > maskOffset) {
                var mc = s.charCodeAt(j);
                if (mc >= 48 && mc <= 57) { //between 0 and 9
                  masked[j] = 'X';
                  maskLen -= 1;
                }
                j -= 1;
              }
              if (theLen == 16) { maskOffset = i; }
            }
          }
        }
      } else if (c != 45 && c != 32) { //not - or space
        if (digitCount > 0) {
          digitCount = 0;
          digits = [];
        }
      }
      i += 1;
    }
    return masked !== null ? Strings.concatAll(masked) : s;
  }

  readRawLines(fn) {
    var a;
    var saved;
    while ((a = stdin.read(16384)) !== null) {
      var startAt = 0;
      var len = a.length;
      for (var i = 0; i < len; i++) {
        if (a[i] == 10) { // Newline, \n.
          if (saved !== null) {
            saved.addAll(a.getRange(startAt, i - startAt));
            fn(new String.fromCharCodes(saved));
            saved = null;
          } else {
            fn(new String.fromCharCodes(a.getRange(startAt, i - startAt)));
          }
          startAt = i + 1;
        }
      }
      if (startAt < len) { saved = a.getRange(startAt, len - startAt); }
    }
  }

  void tapStdin() {
    var s = "";
    var args = new Options().arguments;
    var nRepeats = args.length > 0 ? Math.parseInt(args[0]) : 1;
    if (nRepeats > 1) {
      var lines = [];
      readRawLines((s) => lines.add(s));
      for (var i = 0; i < nRepeats; i++) {
        for (s in lines) {
          print(mask(s));
        }
      }
    } else {
      readRawLines((s) => print(mask(s)));
    }
    exit(0);
  }
}






