# Benchmarking Results

## Elixir:
BenchmarkRandomWords.run()

This benchmark uses a LIST of dictionary words, which (I think?) is terribly inefficient. I don't think you can get a constant-time access for an arbitrary list item index.


Name                       ips        average                 deviation         median         99th %
five_words              491.50        2.03 ms (2,060,000 ns)  ±10.85%        2.03 ms        2.54 ms
build_wordlist           93.14       10.74 ms (10,740,000 ns) ±4.02%        10.64 ms       11.98 ms
fifty_five_words         43.79       22.84 ms (22,840,000 ns)  ±4.00%        22.77 ms       26.20 ms


## Elixir: arrays

The dynamic Array implementation is ~1500x faster than Elixir Lists for this use case. That makes Go only ~6x-8x faster, which is reasonable.

The List implementations are almost 10,000x (TIMES) slower than Go.

Name                             ips        average                deviation         median        99th %
array_build_wordlist           13.95       71.69 ms                 ±7.44%         70.24 ms       86.53 ms
array_five_words           792941.41     0.00126 ms (1,260 ns)      ±1305.47%       0.00108 ms     0.00204 ms
array_fifty_five_words      74037.02      0.0135 ms (13,500 ns)     ±139.74%        0.0118 ms      0.0234 ms

build_wordlist                 92.83       10.77 ms                 ±4.33%         10.70 ms       12.02 ms
five_words                    484.96        2.06 ms (2,060,000 ns)  ±10.58%         2.06 ms        2.57 ms
fifty_five_words               43.87       22.79 ms (22,790,000 ns) ±3.80%         22.79 ms       26.12 ms

## Elixir: aja vector arrays

Another 2x speedup. Nice. Now Go is only 3.7x faster at 5 words, and 4.3x faster at 55 words.

Name                             ips        average            deviation      median         99th %
array_build_wordlist           57.95       17.26 ms            ±8.42%         17.20 ms       20.09 ms
array_five_words          1219115.95     0.00082 ms (820 ns)   ±2471.97%      0.00067 ms     0.00096 ms
array_fifty_five_words     138452.40     0.00722 ms (7220 ns)  ±122.26%       0.00658 ms     0.0142 ms

build_wordlist                 95.53       10.47 ms            ±3.13%         10.37 ms       11.32 ms
five_words                    490.91        2.04 ms            ±10.69%        2.04 ms        2.54 ms
fifty_five_words               43.86       22.80 ms            ±3.71%         22.76 ms       25.10 ms


## Go:
go test -bench=.

This dictfile-read function is SLOWER than the elixir version. (~14.5ms in Go vs. ~10.5ms in Elixir). Possibly a memory tradeoff with the buffered io reader I'm using.

goos: darwin
goarch: arm64
pkg: github.com/groovemonkey/dgrok
BenchmarkFiveWords-12         	 5406362	       218.7 ns/op
BenchmarkFiftyFiveWords-12    	  736993	      1612 ns/op
Benchmark5555Words-12         	    6357	    175125 ns/op
BenchmarkDictfileRead-12      	      81	  14559522 ns/op
PASS
ok  	github.com/groovemonkey/dgrok	5.404s

