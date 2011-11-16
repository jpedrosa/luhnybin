#!/usr/bin/env dart

#import('util.dart');

testIt(s) {
  var a = s is String ? scan(s, @'\d') : s;
  a = map(a, (v) => Math.parseInt(v));
  var i = a.length - 2;
  var n = 0;
  while (i >= 0) {
    n = a[i] * 2;
    if (n == 10) {
      n = 1;
    } else if (n == 12) {
      n = 3;
    } else if (n == 14) {
      n = 5;
    } else if (n == 16) {
      n = 7;
    } else if (n == 18) {
      n = 9;
    }
    a[i] = n;
    i -= 2;
  }
  var total = 0;
  for (var i in a) total += i;
  return total % 10 == 0;
}

iterate(s) {
  var len = s.length;
  var result = false;
  var match_start = 0;
  var match_len = 0;
  if (len >= 14) {
    var n = 0;
    var max_len = len > 16 ? 16 : len;
    while (n + max_len - 1 < len) {
      result = testIt(s.getRange(n, max_len));
      if (result) {
        match_start = n;
        match_len = max_len;
        break;
      }
      if (max_len == 16) {
        result = testIt(s.getRange(n, 15));
        if (result) {
          match_start = n;
          match_len = 15;
          break;
        }
      }
      if (max_len == 16 || max_len == 15) {
        result = testIt(s.getRange(n, 14));
        if (result) {
          match_start = n;
          match_len = 14;
          break;
        }
      }
      n += 1;
      if (max_len > 14 && n + max_len >= len) {
        max_len -= 1;
      }
    }
  }
  return [result, match_start, match_len];
}


mask(s) {
  var match_from = 0;
  var len = s.length;
  var masked = null;
  var re = Helpers.regexp(@'\d[\d\s\-]+\d');
  var re_digit = Helpers.regexp(@'\d');
  var re_any = Helpers.regexp(@'.');
  var md = null;
  while (match_from < len && (md = re.firstMatch(s.substring(match_from, len))) !== null) {
    var iterateResult = iterate(scan(md[0], re_digit));
    var found = iterateResult[0];
    var match_start = iterateResult[1];
    var match_len = iterateResult[2];
    if (found) {
      var n = match_from + md.start();
      if (masked === null) masked = scan(s, re_any);
      while (match_start > 0) {
        if (re_digit.hasMatch(s[n])) match_start -= 1;
        n += 1;
      }
      while (match_len > 0) {
        if (re_digit.hasMatch(s[n])) {
          masked[n] = 'X';
          match_len -= 1;
        }
        n += 1;
      }
      match_from += md.start() + 1;
    } else {
      match_from += md.end();
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
  //'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
  //'5212843322137064296101908962963186202766554788983704435814703972605368416396055678877682488862234546927406211307521284332213706429610190896296318620276655478898370443581470397260536841639605567887768248886223454692740621130752128433221370642961019089629631862027665547889837044358147039726053684163960556788776824888622345469274062113075212843322137064296101908962963186202766554788983704435814703972605368416396055678877682488862234546927406211307521284332213706429610190896296318620276655478898370443581470397260536841639605567887768248886223454692740621130752128433221370642961019089629631862027665547889837044358147039726053684163960556788776824888622345469274062113075212843322137064296101908962963186202766554788983704435814703972605368416396055678877682488862234546927406211307521284332213706429610190896296318620276655478898370443581470397260536841639605567887768248886223454692740621130752128433221370642961019089629631862027665547889837044358147039726053684163960556788776824888622345469274',
  '5451496852732996063216961135925002811586537152199011985874232493633063047918301881385483284586533476253043731721256291647129524137724321728426184434461211703740649863341542579718271551110706936707319896126135944655506777360650140073402696573847382312143994860950153547889826890506187544774005026327396239056283010290981735778560515623251759619833225650753259593746554508212002384743816147220901767420098517594528110348433559626620298669171000062321471778438988210772771125375553564585320157635817785646893772472227467874437527001732836456864256454316370375336790286880557855773092293464498480234269658315323895080609167720971257548045968322939533404152970558280322501801922337656360557826932953501196791996392141409716242024358132638936168824328539157595191336754405365165167449323818836023303930252215414173373588852488517005006682091203000533131570369087503070508446066122223326556254899598241462739083519446495374791938334509806165682356091342533772992235963750210739883141610937988149208758059239',
  ];
  for (var s in samples) {
    print(mask(s));
  }
}

main() {
  sampleTest();
}






