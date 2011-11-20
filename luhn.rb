

DOUBLE_DIGITS = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]


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

  def mask s
    masked = nil
    i = 0
    digit_count = 0
    digits = []
    match_from = -1
    max_len = 0
    len = s.length
    mask_offset = -1
    c = ''
    while i < len
      c = s[i]
      case c
      when '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
        match_from = i if match_from < 0
        digit_count += 1
        digits << c.to_i
        if digit_count >= 14
          max_len = digit_count > 16 ? 16 : digit_count
          the_len = 14
          while the_len <= max_len
            start_at = digit_count - 14
            if the_len >= 16
              start_at -= 2
            elsif the_len >= 15
              start_at -= 1
            end
            if test_it(digits, start_at, the_len)
              masked = s[0..-1] if not masked
              j = i
              while j >= match_from && j > mask_offset
                case s[j]
                when '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
                  masked[j] = 'X'
                end
                j -= 1
              end
              mask_offset = i
            end
            the_len += 1
          end
        end
        match_from += 1 if digit_count >= 16
      when '-', ' '
        # Keep going.
      else
        if digit_count > 0
          digit_count = 0
          digits = []
          match_from = -1
        end
      end
      i += 1
    end
    masked || s
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





