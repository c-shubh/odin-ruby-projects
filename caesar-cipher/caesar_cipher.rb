def upcase?(char)
  ('A'.ord <= char.ord && char.ord <= 'Z'.ord)
end

def downcase?(char)
  ('a'.ord <= char.ord && char.ord <= 'z'.ord)
end

def alpha?(char)
  upcase?(char) || downcase?(char)
end

def caesar_cipher(string, shift)
  string.split('').each_with_object('') do |c, res|
    if alpha?(c)
      change = downcase?(c) ? 'a'.ord : 'A'.ord
      res << ((c.ord - change + shift) % 26 + change).chr
    else
      res << c
    end
  end
end

puts caesar_cipher('QEB NRFZH YOLTK CLU GRJMP LSBO QEB IXWV ALD', 3)
