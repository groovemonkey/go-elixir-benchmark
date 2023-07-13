defmodule BenchmarkRandomWords do
  # old and busted
  # :eprof.start()
  # :eprof.profile(fn -> RandomWords.wordlist_from_file() end)
  # :eprof.analyze()

  # new hotness
  # def run() do
  #   words = RandomWords.wordlist_from_file()
  #   arraywords = RandomWordsArray.wordlist_from_file()
  #
  #   Benchee.run(%{
  #     "build_wordlist" => fn -> RandomWords.wordlist_from_file() end,
  #     "array_build_wordlist" => fn -> RandomWordsArray.wordlist_from_file() end,
  #     "five_words" => fn -> RandomWords.new(words, 5) end,
  #     "fifty_five_words" => fn -> RandomWords.new(words, 55) end,
  #     "5555_words" => fn -> RandomWords.new(words, 5555) end,
  #     "array_five_words" => fn -> RandomWordsArray.new(arraywords, 5) end,
  #     "array_fifty_five_words" => fn -> RandomWordsArray.new(arraywords, 55) end,
  #     "array_5555_words" => fn -> RandomWordsArray.new(arraywords, 5555) end
  #   })
  # end
  def run() do
    run_5()
    run_55()
    run_5555()
  end

  def run_5() do
    words = RandomWords.wordlist_from_file()
    arraywords = RandomWordsArray.wordlist_from_file()

    Benchee.run(%{
      "five_words" => fn -> RandomWords.new(words, 5) end,
      "array_five_words" => fn -> RandomWordsArray.new(arraywords, 5) end
    })
  end

  def run_55() do
    words = RandomWords.wordlist_from_file()
    arraywords = RandomWordsArray.wordlist_from_file()

    Benchee.run(%{
      "fifty_five_words" => fn -> RandomWords.new(words, 55) end,
      "array_fifty_five_words" => fn -> RandomWordsArray.new(arraywords, 55) end
    })
  end

  def run_5555() do
    words = RandomWords.wordlist_from_file()
    arraywords = RandomWordsArray.wordlist_from_file()

    Benchee.run(%{
      "5555_words" => fn -> RandomWords.new(words, 5555) end,
      "array_5555_words" => fn -> RandomWordsArray.new(arraywords, 5555) end
    })
  end
end
