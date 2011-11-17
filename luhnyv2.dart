#!/usr/bin/env dart_release

#import('util.dart');

final DOUBLE_DIGITS = const [0, 2, 4, 6, 8, 1, 3, 5, 7, 9];

testIt(a) {
  var total = 0;
  var doubleDigit = false;
  var n = 0;
  for (var i = a.length - 1; i >= 0; i--) {
    n = Math.parseInt(a[i]);
    total += doubleDigit ? DOUBLE_DIGITS[n] : n;
    doubleDigit = !doubleDigit;
  }
  return total % 10 == 0;
}

iterate(s) {
  var len = s.length;
  var result = false;
  var matchStart = 0;
  var matchLen = 0;
  if (len >= 14) {
    var n = 0;
    var maxLen = len > 16 ? 16 : len;
    while (n + maxLen - 1 < len) {
      result = testIt(s.getRange(n, maxLen));
      if (result) {
        matchStart = n;
        matchLen = maxLen;
        break;
      }
      if (maxLen == 16) {
        result = testIt(s.getRange(n, 15));
        if (result) {
          matchStart = n;
          matchLen = 15;
          break;
        }
      }
      if (maxLen == 16 || maxLen == 15) {
        result = testIt(s.getRange(n, 14));
        if (result) {
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
  return [result, matchStart, matchLen];
}


mask(s) {
  var matchFrom = 0;
  var len = s.length;
  var masked = null;
  var re = Helpers.regexp(@'\d[\d\s\-]+\d');
  var reDigit = Helpers.regexp(@'\d');
  var reAny = Helpers.regexp(@'.');
  var md = null;
  while (matchFrom < len && (md = re.firstMatch(s.substring(matchFrom, len))) !== null) {
    var iterateResult = iterate(scan(md[0], reDigit));
    var found = iterateResult[0];
    var matchStart = iterateResult[1];
    var matchLen = iterateResult[2];
    if (found) {
      var n = matchFrom + md.start();
      if (masked === null) masked = scan(s, reAny);
      while (matchStart > 0) {
        if (reDigit.hasMatch(s[n])) matchStart -= 1;
        n += 1;
      }
      matchFrom = n + 1;
      while (matchLen > 0) {
        if (reDigit.hasMatch(s[n])) {
          masked[n] = 'X';
          matchLen -= 1;
        }
        n += 1;
      }
    } else {
      matchFrom += md.end();
    }
  }
  return masked !== null ? Strings.concatAll(masked) : s;
}


sampleTest() {
  var samples = [
    '56613959932537',
    '508733740140655',
    '6853371389452376',
    '49536290423965',
  '306903975081421',
  '6045055735309820',
  '5872120460121',
  '99929316122852072',
  '0003813474535310',
  '0114762758182750',
  '9875610591081018250321',
  '4352 7211 4223 5131',
  '7288-8379-3639-2755',
  'java.lang.FakeException: 7230 3161 3748 4124 is a card #.',
  "4111 1111 1111 111 doesn't have enough digits.",
  '56613959932535089 has too many digits.',
  '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
  '5212843322137064296101908962963186202766554788983704435814703972605368416396055678877682488862234546927406211307521284332213706429610190896296318620276655478898370443581470397260536841639605567887768248886223454692740621130752128433221370642961019089629631862027665547889837044358147039726053684163960556788776824888622345469274062113075212843322137064296101908962963186202766554788983704435814703972605368416396055678877682488862234546927406211307521284332213706429610190896296318620276655478898370443581470397260536841639605567887768248886223454692740621130752128433221370642961019089629631862027665547889837044358147039726053684163960556788776824888622345469274062113075212843322137064296101908962963186202766554788983704435814703972605368416396055678877682488862234546927406211307521284332213706429610190896296318620276655478898370443581470397260536841639605567887768248886223454692740621130752128433221370642961019089629631862027665547889837044358147039726053684163960556788776824888622345469274',
  '5451496852732996063216961135925002811586537152199011985874232493633063047918301881385483284586533476253043731721256291647129524137724321728426184434461211703740649863341542579718271551110706936707319896126135944655506777360650140073402696573847382312143994860950153547889826890506187544774005026327396239056283010290981735778560515623251759619833225650753259593746554508212002384743816147220901767420098517594528110348433559626620298669171000062321471778438988210772771125375553564585320157635817785646893772472227467874437527001732836456864256454316370375336790286880557855773092293464498480234269658315323895080609167720971257548045968322939533404152970558280322501801922337656360557826932953501196791996392141409716242024358132638936168824328539157595191336754405365165167449323818836023303930252215414173373588852488517005006682091203000533131570369087503070508446066122223326556254899598241462739083519446495374791938334509806165682356091342533772992235963750210739883141610937988149208758059239',
  ];
  for (var s in samples) {
    print(mask(s));
  }
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

main() {
//  sampleTest();
  tapStdin();
}






