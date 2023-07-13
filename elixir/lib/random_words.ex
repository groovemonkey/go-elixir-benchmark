defmodule RandomWords do
  @default_length 5
  @default_dictpath "./data/wordlist.txt"

  # When given just a wordlist, use the default length and an empty map
  def new(wordlist) when is_list(wordlist) do
    new(wordlist, @default_length, %{})
  end

  # TODO(random choice from a list takes really long, right? O(n) traversal? Maybe store wordlist in a map?)
  def new(wordlist, length, taken \\ %{}) do
    chosenWords = choose_words(wordlist, length, [])
    words = Enum.join(chosenWords, "-")

    ## THIS IS NOT HOW ELIXIR WORKS -- this rebind will never happen (top-level chosenWords will always be empty)
    # chosenWords = []
    # Enum.each(0..length, fn(_x) ->
    #   chosenWords = [ Enum.random(wordlist) | chosenWords]
    # end)

    case Enum.member?(taken, {words, true}) do
      # Not already in taken? Return words.
      false -> words
      # Duplicate? run this function again
      true -> new(wordlist, length, taken)
    end
  end

  defp choose_words(_wordlist, 0, words) do
    words
  end

  defp choose_words(wordlist, num_words, words) do
    choose_words(wordlist, num_words - 1, [Enum.random(wordlist) | words])
  end

  def wordlist_from_file(dictpath \\ @default_dictpath) do
    case File.read(dictpath) do
      {:ok, s} -> String.split(s, "\n")
      {_error, _s} -> []
    end
  end
end
