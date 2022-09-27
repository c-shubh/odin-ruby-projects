# frozen_string_literal: true

def count_substr_occurrences(str, substr)
  count = 0
  (str.length - substr.length + 1).times do |i|
    count += 1 if str[i, substr.length] == substr
  end
  count
end

def substrings(str, substr_arr)
  # loop over all substrings
  # if curr substr is really a substr
  #   count the number of times it occured in given string
  str = str.downcase
  substr_arr.each_with_object(Hash.new(0)) do |substr, res|
    substr = substr.downcase
    count = count_substr_occurrences(str, substr)
    res[substr] += count unless count.zero?
  end
end

dictionary = %w[below down go going horn how howdy it i low own part partner sit]
pp substrings('below', dictionary)
