
# Cosine Benchmark v2

This framework compares computational performance of programming languages in calculating cosine similarity of random vectors. Current version includes [packages](#packages) in __C__, __C++__, __Go__, __Oberon2__, __Perl__ and a number of optimizations in __Python3__. 

Running `benchmarker.sh` will create a benchmark on your own machine and plot the results (see [Usage](#usage), but check [Requirements](#requirements) first). An example, created on a 8GB/i5 machine:

<center><img src=example_plot.svg></center>

X-axis represents the vector size. For the y-axis, three metrics are used:

- `total_cputime` (user+system) : CPU seconds spent by the package to fulfill the task, measured externally, but includes time spent to read vectors from files and float conversion.
- `avg_walltime` (per calculation) : Human-experienced seconds spent on eachh calculation, measured by the package iteself, less reliable in reflecting actual resource usage.
- `max_rss` (kilobytes) : max memory used by the package, measured externally. 

As one can see, there is a considerable disparity between performance in all three metrics. 


## Cosine Similarity
Cosine similarity is a measure of similarity between two vectors. It is widely used in machine learning where documents, words or images are treated as vectors.

The similarity value is calculated by measuring the distance between two vectors and normalizing it by the length of the vectors:
<center><img src="cosine_similarity.svg" width="50%"></center>

# Requirements
The only requirement to run the Benchmarker is GCC (or other C compiler). Optionally [gnuplot](http://www.gnuplot.info/) is used for plotting the results.

Each individual package in [lib/](lib) might have its own requirements (see under [Packages](#packages)). You don't need to meet all package requirements, you can run the benchmark only on selected packages.

# Usage

Run `benchmarker.sh` with 4 positional arguments, which are repsectively:
- `min` : initial size of vectors
- `max` : final size of vectors 
- `step` : increase size of vectors after each iteration
- `repeat` : ask packages to repeat calculation each time (to increase statistical significance)

Use `-s` and `-p` to save results as `.csv` files and draw plots reslectively. Use `--libs <lib1,lib2...>` to run the benchmarker on a subset of packages. Run `./benchmarker.sh --help` for more details.

### Examples
```bash
$ ./benchmarker.sh -sp 10000 30000 10000 100
```

Will run 3 iterations, with random vectors of size 10,000, 20,000 and 30,000. Each calculation will be repeated 100 times. Results will be saved and plotted.

```bash
$ ./benchmarker.sh -sp --libs c,go,py_numpy 10000 30000 10000 100
```

Same, but on the packages [c](lib/c), [go](lib/go) and [py_numpy](lib/py_numpy).


# Packages

| package               | description	         | requirement         | where to get from      |
|-----------------------|------------------------|---------------------|------------------------|
| [c](lib/c)            | C                      | `gcc` or any other c compiler |              | 
| [c++](lib/cpp)        | C++                    | `g++` (C++ frontend of gcc)   |              |
| [go](lib/go)          | Go                     | `go`   | [golang.org](https://golang.org/doc/install) |
| [oberon_voc](lib/oberon_voc) | [Oberon-2](https://en.wikipedia.org/wiki/Oberon-2) | `voc` | [Vishap Oberon Compiler](https://github.com/vishaps/voc) |
| [perl](lib/perl)      | vanilla Perl           | `perl`                    |                        | 
| [py](lib/py)          | vanilla Python         | `python3`           |                        |
| [py_compr](lib/py_compr) | uses list comprehension |                 |                        |
| [py_array](lib/py_array) | uses [python arrays](https://docs.python.org/3/library/array.html) | | |
| [py_numpy](lib/py_compr) | uses NumPy | python3 lib `numpy`  | `pip3 install numpy` or [numpy.org](https://numpy.org/) |
| [py_sklearn](lib/py_compr) | uses NumPy+Sklearn | python3 lib `skearn`  | `pip3 install sklearn` or [scikit-learn.org](https://scikit-learn.org/) |


# Contributing

You are more than welcome to suggest improvements for the existing packages or add a new package in your own preferred language.

A new package should be a subdirectory in [lib/](lib/). If your language is interpretted, then it should contain an executable file `main` (i.e. a script with a shebang). If it's compiled, then it should contain a Makefile that compiles a binary `main`.

`main` should accept 4 CLI arguments, which are respectively:
- repeat (int) : how many times to repeat the calculation
- size (int) : size of the input vectors
- filepath1 (string) : file with the first vector (line-seperated double-precision floats)
- filepath1 (string) : file with the second vector 

`main` should calculate cosine similarity of the two vectors `repeat` times and write to stdout two values (seperated by space):
- cosine similarity score (double-precision float)
- average calculation time (double-precision float), this should be monotonic time (wall time)

Compile your package if necessary and test it as follows:
```
$ ./util/randvect.py 100000 -10 10 > v1
$ ./util/randvect.py 100000 -10 10 > v2
$ ./lib/my_package/main 100000 100 v1 v2
```
output should be something like this:
```
> 0.00262265036644376 0.00015899505716224666
```

# Why you should not trust this benchmark
This project is meant for educational purposes. You should not use it to make a final decision about what language to use for your project (although it might help you to make an *educated* guess). Why?

- I have a very superficial knowledge of some of the languages here, so the benchmark might not reflect their best performance
- Running this benchmark on different machines will likely yield different results
- You should always create a benchmark for your own specific task (and maybe hardware). Here's an example: for a job project (with heavy vector-calculations) I had to choose between Python arrays and Python with numpy. I knew numpy should be much faster, but it turned out that the overhead was more than the benefit, and in fact it made my project slower.

# Notes on v1

First version of this project included a number of flaws. For example, it used two statically generated vectors of 10s and -10s respectively (so the cosine similarity was always -1). This would poorly reflect the computational performance of the packages, it also did not relfect real-world applications of cosine similarity (which is almost always calculated between vectors of real numbers).