

DOUBLE_DIGITS = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]
DIGITS = {'0' => 0, '1' => 1, '2' => 2, '3' => 3, '4' => 4,
  '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9}


class Luhn

  def test_it a, start_at, max_len
    total = 0
    double_digit = false
    i = start_at + max_len - 1
    while i >= start_at
      total += double_digit ? DOUBLE_DIGITS[a[i]] : a[i]
      double_digit = !double_digit
      i -= 1
    end
    total % 10 == 0
  end

  def iterate s, start_at
    len = s.length
    found = false
    match_start = 0
    match_len = 0
    max_len = len - start_at
    if max_len >= 14
      n = start_at
      max_len = max_len > 16 ? 16 : max_len
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
        if max_len != 14
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
    [found, match_start - start_at, match_len]
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
    broad_matches = s.length > 0 ? all_matches(s, /\d[\d\s-]+\d/) : []
    num_broad_matches = broad_matches.length
    if num_broad_matches > 0
      md = broad_matches[0]
      md_start_at = md.begin(0)
      md_index = 0
      match_from = 0
      mi = 0
      broad_digits = md[0].scan(/\d/).map{|v| v.to_i }
      while true
        found, match_start, match_len = iterate(broad_digits, mi)
        if found
          mi += match_start + 1
          n = match_from + md_start_at
          masked = s[0..-1] if not masked
          while match_start > 0
            match_start -= 1 if DIGITS[s[n]]
            n += 1
          end
          match_from = -1
          while match_len > 0
            if DIGITS[s[n]]
              match_from = n - md_start_at + 1 if match_from < 0
              masked[n] = 'X'
              match_len -= 1
            end
            n += 1
          end
        else
          md_index += 1
          if md_index < num_broad_matches
            match_from = 0
            mi = 0
            md = broad_matches[md_index]
            md_start_at = md.begin(0)
            broad_digits = md[0].scan(/\d/).map{|v| v.to_i }
          else 
            break
          end
        end
      end
    end
    masked || s
  end

  # A simpler implementation of mask with gsub, with fewer variables to juggle with.
  def mask_with_gsub s
    s.gsub(/\d[\d\s-]+\d/) do |broad_match|
      masked = nil
      match_from = 0
      mi = 0
      broad_digits = broad_match.scan(/\d/).map{|v| v.to_i }
      next broad_match if broad_digits.length < 14
      while true
        found, match_start, match_len = iterate(broad_digits, mi)
        if found
          mi += match_start + 1
          n = match_from
          masked = broad_match[0..-1] if not masked
          while match_start > 0
            match_start -= 1 if DIGITS[broad_match[n]]
            n += 1
          end
          match_from = -1
          while match_len > 0
            if DIGITS[broad_match[n]]
              match_from = n + 1 if match_from < 0
              masked[n] = 'X'
              match_len -= 1
            end
            n += 1
          end
        else
          break
        end
      end
      masked || broad_match
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
end





