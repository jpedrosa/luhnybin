#!/usr/bin/env ruby

DOUBLE_DIGITS = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]
DIGITS = {'0' => 0, '1' => 1, '2' => 2, '3' => 3, '4' => 4,
  '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9}

def test_it a, startAt, maxLen
  total = 0
  doubleDigit = false
  i = startAt + maxLen - 1
  while i >= startAt
    total += doubleDigit ? DOUBLE_DIGITS[a[i]] : a[i]
    doubleDigit = !doubleDigit
    i -= 1
  end
  total % 10 == 0
end

def iterate s, startAt
  len = s.length
  found = false
  match_start = 0
  match_len = 0
  if len - startAt >= 14
    n = startAt
    max_len = len > 16 ? 16 : len
    while n + max_len - 1 < len do
      found = test_it(s, n, max_len)
      if found
        match_start = n
        match_len = max_len
        break
      end
      if max_len == 16
        found = test_it(s, n, 15)
        if found
          match_start = n
          match_len = 15
          break
        end
      end
      if max_len == 16 or max_len == 15
        found = test_it(s, n, 14)
        if found
          match_start = n
          match_len = 14
          break
        end
      end
      n += 1
      max_len -= 1 if max_len > 14 and n + max_len >= len
    end
  end
  [found, match_start - startAt, match_len]
end

def all_matches s, re
  a = []
  i = 0
  while m = s.match(re, i)
    a << m
    i = m.end(0)
  end
  a
end

def mask s
  masked = nil
  broadMatches = s.length > 0 ? all_matches(s, /\d[\d\s-]+\d/) : []
  numBroadMatches = broadMatches.length
  if numBroadMatches > 0
    md = broadMatches[0]
    mdIndex = 0
    matchFrom = 0
    mi = 0
    broadDigits = md[0].scan(/\d/).map{|v| v.to_i }
    while true
      found, matchStart, matchLen = iterate(broadDigits, mi)
      if found
        mi += matchStart + 1
        n = matchFrom + md.begin(0)
        masked = s[0..-1] if not masked
        while matchStart > 0
          matchStart -= 1 if DIGITS[s[n]]
          n += 1
        end
        matchFrom = n - md.begin(0) + 1
        while matchLen > 0
          if DIGITS[s[n]]
            masked[n] = 'X'
            matchLen -= 1
          end
          n += 1
        end
      else
        mdIndex += 1
        if mdIndex < numBroadMatches
          matchFrom = 0
          mi = 0
          md = broadMatches[mdIndex]
          broadDigits = md[0].scan(/\d/).map{|v| v.to_i }
        else 
          break
        end
      end
    end
  end
  masked || s
end

def sample_test
[ '56613959932537',
#  '508733740140655',
#  '6853371389452376',
#  '49536290423965',
#  '306903975081421',
#  '6045055735309820',
#  '5872120460121',
#  '99929316122852072',
#  '0003813474535310',
#  '0114762758182750',
#  '9875610591081018250321',
#  '0' * 1000,
#  '4352 7211 4223 5131',
#  '7288-8379-3639-2755',
#  'java.lang.FakeException: 7230 3161 3748 4124 is a card #.',
#  "4111 1111 1111 111 doesn't have enough digits.",
#  '56613959932535089 has too many digits.',
  #'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
  #'5212843322137064296101908962963186202766554788983704435814703972605368416396055678877682488862234546927406211307521284332213706429610190896296318620276655478898370443581470397260536841639605567887768248886223454692740621130752128433221370642961019089629631862027665547889837044358147039726053684163960556788776824888622345469274062113075212843322137064296101908962963186202766554788983704435814703972605368416396055678877682488862234546927406211307521284332213706429610190896296318620276655478898370443581470397260536841639605567887768248886223454692740621130752128433221370642961019089629631862027665547889837044358147039726053684163960556788776824888622345469274062113075212843322137064296101908962963186202766554788983704435814703972605368416396055678877682488862234546927406211307521284332213706429610190896296318620276655478898370443581470397260536841639605567887768248886223454692740621130752128433221370642961019089629631862027665547889837044358147039726053684163960556788776824888622345469274',
  #'5451496852732996063216961135925002811586537152199011985874232493633063047918301881385483284586533476253043731721256291647129524137724321728426184434461211703740649863341542579718271551110706936707319896126135944655506777360650140073402696573847382312143994860950153547889826890506187544774005026327396239056283010290981735778560515623251759619833225650753259593746554508212002384743816147220901767420098517594528110348433559626620298669171000062321471778438988210772771125375553564585320157635817785646893772472227467874437527001732836456864256454316370375336790286880557855773092293464498480234269658315323895080609167720971257548045968322939533404152970558280322501801922337656360557826932953501196791996392141409716242024358132638936168824328539157595191336754405365165167449323818836023303930252215414173373588852488517005006682091203000533131570369087503070508446066122223326556254899598241462739083519446495374791938334509806165682356091342533772992235963750210739883141610937988149208758059239',
].each do |s|
  puts mask(s)
end
end

def tap_stdin
  n_repeats = ARGV[0] ? ARGV[0].to_i : 1
  lines = STDIN.readlines
  n_repeats.times do
    lines.each do |s|
      puts mask(s)
    end
  end
end


#sample_test
tap_stdin




