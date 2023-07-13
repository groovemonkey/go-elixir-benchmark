package main

import (
	"testing"
)

func BenchmarkFiveWords(b *testing.B) {
	wordlist := wordListFromDictFile("./data/wordlist.txt")

	// This is just a Set
	var subdomains = make(map[string]struct{})

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		buildRandomWordString(*wordlist, 5, subdomains)
	}
}

func BenchmarkFiftyFiveWords(b *testing.B) {
	wordlist := wordListFromDictFile("./data/wordlist.txt")

	// This is just a Set
	var subdomains = make(map[string]struct{})

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		buildRandomWordString(*wordlist, 55, subdomains)
	}
}

func Benchmark5555Words(b *testing.B) {
	wordlist := wordListFromDictFile("./data/wordlist.txt")

	// This is just a Set
	var subdomains = make(map[string]struct{})

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		buildRandomWordString(*wordlist, 5555, subdomains)
	}
}

func BenchmarkDictfileRead(b *testing.B) {
	for i := 0; i < b.N; i++ {
		wordListFromDictFile("./data/wordlist.txt")
	}
}
