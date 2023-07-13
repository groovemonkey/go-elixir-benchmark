package main

import (
	"bufio"
	"log"
	"math/rand"
	"os"
	"strings"
)

func main() {
	return
}

// buildRandomWordString builds a pseudorandom string of words, using the number of words specified
// TODO(dcohen) this is probably not the best approach - in prod, it would rely on a bunch of lookups which will hit the DB
func buildRandomWordString(wordlist []string, length int, taken map[string]struct{}) string {
	// chosenwords is how we build up the string; words is what we return
	var chosenWords []string
	var words string

	// Infinite loop which we'll break out of when we have a non-duplicate wordstring
	for {
		for i := 0; i < length; i++ {
			randIdx := rand.Intn(len(wordlist))
			chosenWords = append(chosenWords, wordlist[randIdx])
		}

		words = strings.Join(chosenWords, "-")
		_, isDuplicate := taken[words]
		if !isDuplicate {
			return words
		}
		// else try again...
		log.Printf("Duplicate detected; chosen words were: %v", chosenWords)
	}
}

// wordListFromDictFile builds a wordlist datastructure from a "dictionary" file (one word per line)
func wordListFromDictFile(dictPath string) *[]string {
	// this will introduce a bug if we have less than 500 words in our wordlist
	wordlist := make([]string, 500)

	// Read wordlist file
	file, err := os.Open(dictPath)
	defer file.Close()
	if err != nil {
		panic("Unable to load wordlist. Exiting.")
	}
	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)
	for scanner.Scan() {
		wordlist = append(wordlist, scanner.Text())
	}

	if err := scanner.Err(); err != nil {
		log.Printf("Scanner error while reading wordlist: %v", err)
	}

	return &wordlist
}
