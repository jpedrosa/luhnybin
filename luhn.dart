
#library('luhn');
#import('util.dart');

class Luhn {

  final DOUBLE_DIGITS = const [0, 2, 4, 6, 8, 1, 3, 5, 7, 9];

  bool testIt(List<int> digits, num startAt, num maxLen) {
    var total = 0;
    var doubleDigit = false;
    for (var i = startAt + maxLen - 1; i >= startAt; i--) {
      total += doubleDigit ? DOUBLE_DIGITS[digits[i]] : digits[i];
      doubleDigit = !doubleDigit;
    }
    return total % 10 == 0;
  }

  List<int> mask(List<int> charCodes) {
    var masked = null;
    var i = 0;
    var digitCount = 0;
    var maskOffset = -1;
    var digits = [];
    var len = charCodes.length;
    while (i < len) {
      var c = charCodes[i];
      if (c >= 48 && c <= 57) { //between 0 and 9
        digitCount += 1;
        digits.add(c - 48);
        if (digitCount >= 14) {
          for (var theLen = digitCount < 16 ? digitCount : 16; theLen >= 14; theLen--) {
            var startAt = digitCount - theLen;
            if (testIt(digits, startAt, theLen)) {
              if (masked === null) { masked = charCodes.getRange(0, len); }
              var j = i;
              var maskLen = theLen;
              while (maskLen > 0 && j > maskOffset) {
                var mc = charCodes[j];
                if (mc >= 48 && mc <= 57) { //between 0 and 9
                  masked[j] = 88; //X
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
    return masked !== null ? masked : charCodes;
  }

  void readRawLines(fn) {
    var a = null;
    var saved = null;
    while ((a = stdin.read(16384)) !== null) {
      var startAt = 0;
      var len = a.length;
      for (var i = 0; i < len; i++) {
        if (a[i] == 10) { // Newline, \n.
          if (saved !== null) {
            saved.addAll(a.getRange(startAt, i - startAt));
            fn(saved);
            saved = null;
          } else {
            fn(a.getRange(startAt, i - startAt));
          }
          startAt = i + 1;
        }
      }
      if (startAt < len) { saved = a.getRange(startAt, len - startAt); }
    }
    if (saved !== null) { fn(saved); }
  }

  void tapStdin() {
    var args = new Options().arguments;
    var nRepeats = args.length > 0 ? Math.parseInt(args[0]) : 1;
    if (nRepeats > 1) {
      var lines = [];
      readRawLines((a) => lines.add(a));
      for (var i = 0; i < nRepeats; i++) {
        for (var a in lines) {
          print(new String.fromCharCodes(mask(a)));
        }
      }
    } else {
      readRawLines((a) => print(new String.fromCharCodes(mask(a))));
    }
    exit(0);
  }
}





