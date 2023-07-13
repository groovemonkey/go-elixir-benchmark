# Go/Elixir benchmarking writeup
Story time:

I was looking for an Elixir datatype like a List that has fast (constant-time) index-based access to arbitrary elements like an array or slice in e.g. Go.

Context: I was writing some code that needs to repeatedly pick a random element from a large list of words. In other languages, I'd have expected this to be (close to) constant time, since it just gets the length of the list and then accesses the elements via pointers or a known offset (easier in statically typed languages, I know).

I.e. I was just looking for a list-like datastructure where Struct[i] returns the ith element without traversing ALL of Struct[0]..Struct[i].

Disclaimer: this is not a "which language is faster" thing, or "faster is always better" thing. It's just an interesting exploration of what using the right (or wrong) datatype can do for a program's performance.

I benchmarked an implementation using an Elixir List and Enum.random() against a simple Go implementation and found it almost unbelievably slower (five random words is ~2.3ms with Elixir, and about 218ns with Go which is about ~9000x faster -- and this scaled linearly with number of words). That's why I think I must just be missing the correct, idiomatic Elixir implementation which doesn't scan a giant List n times for n words.

```
Elixir:
five_words                    484.96        2.06 ms (2,060,000 ns) 
fifty_five_words               43.87       22.79 ms (22,790,000 ns)
5555_words                      0.44     2289.70 ms (2,289,700,000 ns)

Go:
BenchmarkFiveWords-12         	 5406362	       218.7 ns/op
BenchmarkFiftyFiveWords-12    	  736993	      1612 ns/op
Benchmark5555Words-12         	    6357	    175125 ns/op
```

Someone suggested erlang's :array (dynamic arrays the way I'm used to from other languages), and then I also found https://github.com/Qqwy/elixir-arrays which I ended up using.

This Arrays implementation is ~1500x faster than Elixir Lists for this use case. That makes Go only ~6x-8x faster.

```
Name                             ips        average            
array_five_words           792941.41     0.00126 ms (1,260 ns)
array_fifty_five_words      74037.02      0.0135 ms (13,500 ns)
```

Then I found [Aja](https://github.com/sabiwara/aja) and its Vector implementation. Conveniently you can use an Aja-vector implementation for Arrays via [arrays_aja](https://github.com/Qqwy/elixir-arrays_aja), which gave me another 2x speedup. Nice. This implementation is ~3000 times faster than what I started with, and Go is only ~4x faster, which seems reasonable.

```
Name                             ips        average            
array_five_words          1219115.95     0.00082 ms (820 ns)   
array_fifty_five_words     138452.40     0.00722 ms (7220 ns)  
array_5555_words             1359.00        0.74 ms (740,000 ns)
```

For comparison:

```
Original Elixir Lists: 5555_words                      0.44     2289.70 ms (2,289,700,000 ns)
Go: Benchmark5555Words-12         	    6357	    175125 ns/op
```


## Run it yourself!

### Benchmark Go:

```
cd go
go mod download

go test -bench=.
```

### Benchmark Elixir:

```
cd elixir
mix deps.get
iex -S mix

BenchmarkRandomWords.run()
```

