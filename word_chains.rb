module WordChains
  extend self

  def generate_adj_regexp_pattern(word)
    any_letter = '\w'

    regexp_patterns = []
    word.split(//).each_index do |idx|
      pattern = "^#{word[0...idx]}#{any_letter}#{word[idx + 1..-1]}$"
      regexp_patterns << pattern
    end

    Regexp.new(regexp_patterns.join('|'))
  end

  def adjacent_words(word, dictionary)
    regexp_pattern = generate_adj_regexp_pattern(word)

    [].tap do |adj_words|
      dictionary.each { |word| adj_words << word if word =~ regexp_pattern }
    end
  end

  def find_chain(source, target, dictionary)
    words_to_expand = [source]
    words_already_expanded = []
    candidate_words = dictionary.select { |word| word.length == source.length }
    parents = { source => nil }

    until words_to_expand.empty?
      word = words_to_expand.shift
      words_already_expanded << word

      adjacent_words(word, candidate_words).each do |adj_word|
        next if words_already_expanded.include?(adj_word)

        words_to_expand << adj_word
        parents[adj_word] = word
        return parents if adj_word == target
      end
    end

    nil
  end

  def build_path_from_breadcrumbs(source, target, parents)
    path = []
    current_child = target

    begin
      path.unshift(current_child)
      current_child = parents[current_child]
    end until current_child.nil?

    path
  end

  def find_path(source, target, dictionary)
    parents = find_chain(source, target, dictionary)
    build_path_from_breadcrumbs(source, target, parents) if parents
  end
end

dictionary = File.readlines('dictionary.txt').map(&:chomp)

p WordChains.find_path('duck', 'ruby', dictionary)