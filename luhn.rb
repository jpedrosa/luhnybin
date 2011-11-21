

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
    len = s.length
    while i < len
      c = s[i]
      case c
      when '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
        digit_count += 1
        digits << c.to_i
        if digit_count >= 14
          the_len = digit_count < 16 ? digit_count : 16
          while the_len >= 14
            start_at = digit_count - the_len
            if test_it(digits, start_at, the_len)
              masked = s[0..-1] if not masked
              mask_len = the_len
              j = i
              while mask_len > 0
                case s[j]
                when '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
                  masked[j] = 'X'
                  mask_len -= 1
                end
                j -= 1
              end
            end
            the_len -= 1
          end
        end
      when '-', ' '
        # Keep going.
      else
        if digit_count > 0
          digit_count = 0
          digits = []
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





