# 6809-sorting
implementations of various sorting algos for the 6809

For each sorting routine the next information is provided:  its size, whether it uses stack or not, required amount of additional memory, the size of code for its call.  All sizes are in bytes.  Benchmark results are clock cycles.  One clock cycle is equal to one millionth of a second for the 6809 at 1 MHz.  All results were gotten using 6809.c by Arto Salmi and Joze Fabcic.

Quicksort depends on its *stacklvl* parameter, it must be more than binary logarithm of the number of elements in the sorted array.  Number 26 is used as its default value (16 is enough for any case but it is slower).  Total amount of stack space required may be calculated by *stacklvl\*N*+*stackint* where *N=6* for *quick* and *N=4* for *quick-nr* (nr means no recursion), *stackint* is amount of stack space reserved for interrupts, it is 24 by default.  If interrupts are disabled *stackint* may be equal to 0.  An attempt to use quicksort when your system has less free space on stack causes the immidiate return with *C=1*, *C=0* means the sort is done successfully.

Shellsort depends on its *shelltabidx* parameter which is used in a normal Shellsort invocation.  For the benchmarks, the value 7 has been used for 1000 element arrays, and the value 11 has been used for 30000 and 60000 element arrays.

Various kinds of filling have been used for testing and benchmarking:
  * *random-1* &ndash; every byte is generated randomly by the standard C random number generator function, numbers in range 0 and 255 are generated;
  * *random-2* &ndash; every byte is generated randomly by a quick and simple homebrew random number generator, numbers in range 0 and 255 are generated;
  * *2-values* &ndash; every byte is generated randomly by the standard C random number generator function, only numbers 0 and 1 are generated;
  * *4-values* &ndash; every 16-bit word is generated randomly by the standard C random number generator function, only numbers 0, 1, 256 and 257 are generated;
  * *killer-qs-r* &ndash; this sequence kills Hoare's Quicksort from its right edge;
  * *killer-qs-l* &ndash; this sequence kills Hoare's Quicksort from its left edge;
  * *reversed* &ndash; every next element is equal or lower than the previous;
  * *sorted* &ndash; every next element is equal or higher than the previous;
  * *constant* &ndash; all elements are equal.

The killer sequence generators may be taken from this [file](https://github.com/litwr2/research-of-sorting/blob/master/fillings.cpp), seek for *fill_for_quadratic_qsort_hoare* routines.  The *random-2* generator is available within the same file, seek for *fill_homebrew_randomly* routine.

The standard C random generator (GCC) is initializared with *srand(0)*.

## Byte sorting

Routine  | Size | Stack | Memory | Startup
--------:|-----:|------:|-------:|-------:
quick    |  161 |   182¹|      0 |      11
quick-nr |  181 |   130²|      0 |      11
shell    |  113 |     2 |      0 |      13
selection|   45 |     2 |      0 |       9
insertion|   47 |     2 |      0 |      10
radix8   |   77 |    10 |    512 |      13

¹ - *stacklvl\*6+stackint+2*

² - *stacklvl\*4+stackint+2*

### 1000 byte benchmarking

  &nbsp; |    quick | quick-nr|   shell |  selection |  insertion | radix8
--------:|---------:|--------:|--------:|-----------:|-----------:|-------:
random-1 |  414,876 | 426,273 | 614,823 | 13,570,105 | 11,890,464 |  81,557
random-2 |  417,915 | 423,640 | 589,522 | 13,566,403 |  9,260,526 |  81,557
2-values |  432,302 | 420,599 | 326,206 | 13,543,567 |  5,778,896 |  81,581
reversed |  324,257 | 352,909 | 442,004 | 13,934,953 | 23,428,030 |  81,557
sorted   |  303,466 | 332,001 | 285,279 | 13,540,525 |     45,001 |  81,557
constant |  397,579 | 389,434 | 285,279 | 13,540,525 |     45,001 |  81,593

### 60000 byte benchmarking

  &nbsp; |    quick | quick-nr |    shell |    selection |     insertion |  radix8 
--------:|---------:|---------:|---------:|-------------:|--------------:|--------:
random-1 |37,875,499|37,200,327|54,410,577|48,604,259,341| 42,120,340,195|4,329,785
random-2 |38,059,640|37,381,803|52,145,357|48,604,306,471| 42,068,605,691|4,330,745
2-values |39,838,018|39,095,723|31,145,859|48,602,611,093| 21,058,278,682|4,332,353
reversed |30,562,039|30,075,127|39,513,594|48,625,574,707| 84,270,682,710|4,329,785
sorted   |29,324,762|28,838,874|28,131,687|48,602,430,025|      2,700,001|4,329,785
constant |38,280,179|37,755,938|28,131,687|48,602,430,025|      2,700,001|4,332,365

## Word sorting

Routine  | Size | Stack | Memory | Startup
--------:|-----:|------:|-------:|-------:
quick    |  166 |   182¹|      0 |      11
quick_nr |  186 |   130²|      0 |      11
shell    |  114 |     2 |      0 |      13
selection|   48 |     2 |      0 |       9
insertion|   52 |     2 |      0 |      10

### 1000 word benchmarking

  &nbsp; |   quick | quick-nr|   shell | selection | insertion 
--------:|--------:|--------:|--------:|----------:|----------:
random-1 |  528,491|  556,974|  754,225| 15,577,147| 15,266,405
random-2 |  527,930|  552,834|  712,162| 15,578,965| 13,499,185
4-values |  500,711|  487,517|  396,139| 15,550,981| 12,149,599
kill-qs-r|  941,372|  934,970|  616,567| 15,555,091| 10,386,242
kill-qs-l|2,227,196|1,031,056|  613,867| 15,553,501| 10,386,103
reversed |  290,959|  282,814|  521,890| 17,044,525| 31,003,012
sorted   |  268,331|  260,186|  311,167| 15,544,525|     48,997
constant |  452,247|  444,102|  311,167| 15,544,525|     48,997

### 30000 word benchmarking

  &nbsp; |     quick |  quick-nr |    shell |    selection |    insertion 
--------:|----------:|----------:|---------:|-------------:|-------------:
random-1 | 21,075,844| 21,831,014|37,441,589|13,952,910,949|13,964,986,018
random-2 | 20,933,860| 21,443,891|35,824,820|13,952,845,117|13,937,815,243
4-values | 21,437,248| 21,079,611|17,459,669|13,951,529,755|10,599,299,071
kill-qs-r| 37,226,270| 36,911,944|30,347,921|13,951,654,177| 9,301,524,790
kill-qs-l| 72,657,854| 45,823,012|30,247,891|13,951,605,001| 9,301,524,651
reversed | 12,234,977| 11,972,880|23,578,009|15,301,335,025|27,900,090,012
sorted   | 11,559,732| 11,297,635|14,849,043|13,951,335,025|     1,469,997
constant | 20,529,743| 20,267,646|14,849,043|13,951,335,025|     1,469,997

Check also [Z80-sorting](https://github.com/litwr2/Z80-sorting) and [6502-sorting](https://github.com/litwr2/6502-sorting).
