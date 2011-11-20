
#library('luhn');
#import('util.dart');

class Luhn {

  final DOUBLE_DIGITS = const [0, 2, 4, 6, 8, 1, 3, 5, 7, 9];
  final C_0;
  final C_9;
  
  Luhn() : C_0 = '0'.charCodeAt(0), C_9 = '9'.charCodeAt(0);

  bool testIt(List a, num startAt, num maxLen) {
    var total = 0;
    var doubleDigit = false;
    for (var i = startAt + maxLen - 1; i >= startAt; i--) {
      total += doubleDigit ? DOUBLE_DIGITS[a[i]] : a[i];
      doubleDigit = !doubleDigit;
    }
    return total % 10 == 0;
  }

  String mask(s) {
    var masked = null;
    var i = 0;
    var digitCount = 0;
    var digitOffset = 0;
    var digits = [];
    var matchFrom = -1;
    var maxLen = 0;
    var len = s.length;
    var mask_offset = -1;
    var c = '';
    var cc = 0;
    while (i < len) {
      c = s[i];
      cc = c.charCodeAt(0);
      if (cc >= C_0 && cc <= C_9) {
        if (matchFrom < 0) { matchFrom = i; }
        digitCount += 1;
        digits.add(Math.parseInt(c));
        maxLen = digitCount - digitOffset;
        if (maxLen >= 14) {
          var found = testIt(digits, digitOffset, maxLen);
          if (found) {
            if (masked === null) { masked = s.splitChars(); }
            var j = i;
            while (j >= matchFrom && j > mask_offset) {
              var mc = s.charCodeAt(j);
              if (mc >= C_0 && mc <= C_9) {
                masked[j] = 'X';
              }
              j -= 1;
            }
            mask_offset = i;
          }
        }
        if (maxLen >= 16) {
          digitOffset += 1;
          matchFrom += 1;
        }
      } else if (c == '-' || c == ' ') {
        // Keep going.
      } else {
        if (digitCount > 0) {
          digitCount = 0;
          digits = [];
          matchFrom = -1;
          digitOffset = 0;
        }
      }
      i += 1;
    }
    return masked !== null ? Strings.concatAll(masked) : s;
  }

  void tapStdin() {
    var s;
    var ios = new StringInputStream(stdin);
    var lines = [];
    while ((s = ios.readLine()) !== null) {
      lines.add(s);
    }
    var args = new Options().arguments;
    var nRepeats = args.length > 0 ? Math.parseInt(args[0]) : 1;
    for (var i = 0; i < nRepeats; i++) {
      for (s in lines) {
        print(mask(s));
      }
    }
    exit(0);
  }
}






