The first iteration of these tests involved analyzing files that had been downloaded by syrah (https://github.com/dib-lab/syrah.git). 
From the github: 

syrah reads sequences from stdin and outputs subsequences containing solid or trusted k-mers suitable for counting or MinHashing.

syrah automatically exits when it has seen enough solid k-mers.

In the end, this likely was not The Way To Go with RNA-seq reads, as abundance is pretty important and syrah could care less about abundance (kind of).
