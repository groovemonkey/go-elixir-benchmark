defmodule RandomWordsArray do
  @default_length 5
  @default_dictpath "./data/wordlist.txt"

  def new(wordlist, length, taken \\ %{}) do
    chosenWords = choose_words(wordlist, length, [])
    words = Enum.join(chosenWords, "-")

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
    choose_words(wordlist, num_words - 1, [rand_from_array(wordlist) | words])
  end

  def rand_from_array(arr) do
    idx = :rand.uniform(Arrays.size(arr) - 1)
    arr[idx]
  end

  def wordlist_from_file(dictpath \\ @default_dictpath) do
    case File.read(dictpath) do
      {:ok, s} -> Arrays.new(String.split(s, "\n"), implementation: Aja.Vector)
      {_error, _s} -> []
    end
  end
end
