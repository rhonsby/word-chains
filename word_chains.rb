def adjacent_words(word, dictionary)
  regexp_pattern = generate_adj_regexp_pattern(word)

  [].tap do |adj_words|
    dictionary.each { |word| adj_words << word if word =~ regexp_pattern }
  end
end

def generate_adj_regexp_pattern(word)
  any_letter = '\w'

  regexp_patterns = []
  word.split(//).each_index do |idx|
    pattern = "^#{word[0...idx]}#{any_letter}#{word[idx + 1..-1]}$"
    regexp_patterns << pattern
  end

  Regexp.new(regexp_patterns.join('|'))
end

