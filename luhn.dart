#!/usr/bin/env dart_release

#library('luhn');
#import('util.dart');

class Luhn {

  final DOUBLE_DIGITS = const [0, 2, 4, 6, 8, 1, 3, 5, 7, 9];
  var C_0;
  var C_9;
  
  Luhn() {
    C_0 = '0'.charCodeAt(0);
    C_9 = '9'.charCodeAt(0);     
  }

  testIt(a, startAt, maxLen) {
    var total = 0;
    var doubleDigit = false;
    for (var i = startAt + maxLen - 1; i >= startAt; i--) {
      total += doubleDigit ? DOUBLE_DIGITS[a[i]] : a[i];
      doubleDigit = !doubleDigit;
    }
    return total % 10 == 0;
  }

  iterate(a, startAt) {
    var len = a.length;
    var found = false;
    var matchStart = 0;
    var matchLen = 0;
    var maxLen = len - startAt;
    if (maxLen >= 14) {
      var n = startAt;
      maxLen = maxLen > 16 ? 16 : maxLen;
      while (n + maxLen - 1 < len) {
        found = testIt(a, n, maxLen);
        if (found) {
          matchStart = n;
          matchLen = maxLen;
          break;
        }
        if (maxLen == 16) {
          found = testIt(a, n, 15);
          if (found) {
            matchStart = n;
            matchLen = 15;
            break;
          }
        }
        if (maxLen != 14) {
          found = testIt(a, n, 14);
          if (found) {
            matchStart = n;
            matchLen = 14;
            break;
          }
        }
        n += 1;
        if (maxLen > 14 && n + maxLen >= len) {
          maxLen -= 1;
        }
      }
    }
    return [found, matchStart - startAt, matchLen];
  }

  mask(s) {
    var masked = null;
    var re = Helpers.regexp(@'\d[\d\s-]+\d');
    var broadMatches = s.length > 0 ? re.allMatches(s) : [];
    var numBroadMatches = broadMatches.length;
    if (numBroadMatches > 0) {
      var reDigit = Helpers.regexp(@'\d');
      var md = broadMatches[0];
      var mdStartAt = md.start();
      var mdIndex = 0;
      var matchFrom = 0;
      var mi = 0;
      var broadDigits = map(scan(md[0], reDigit), (v) => Math.parseInt(v));
      while (true) {
       var iterateResult = iterate(broadDigits, mi);
        var found = iterateResult[0];
        if (found) {
          var matchStart = iterateResult[1];
          var matchLen = iterateResult[2];
          mi += matchStart + 1;
          var n = matchFrom + mdStartAt;
          if (masked === null) { masked = s.splitChars(); }
          while (matchStart > 0) {
            var c = s.charCodeAt(n);
            if (c >= C_0 && c <= C_9) { matchStart -= 1; }
            n += 1;
          }
          matchFrom = -1;
          while (matchLen > 0) {
            var c = s.charCodeAt(n);
            if (c >= C_0 && c <= C_9) {
              if (matchFrom < 0) {
                matchFrom = n - mdStartAt + 1;
              }
              masked[n] = 'X';
              matchLen -= 1;
            }
            n += 1;
          }
        } else {
          mdIndex += 1;
          if (mdIndex < numBroadMatches) {
            matchFrom = 0;
            mi = 0;
            md = broadMatches[mdIndex];
            mdStartAt = md.start();
            broadDigits = map(scan(md[0], reDigit), (v) => Math.parseInt(v));
          } else {
            break;
          }
        }
      }
    }
    return masked !== null ? Strings.concatAll(masked) : s;
  }

  tapStdin() {
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






