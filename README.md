
# Cosine Similarity: Python, Perl and C++ library

# About

Cosine Similarity is a measure of similarity between two vectors. This package, with functions performing same task in __Python__, __C++__ and __Perl__, is only meant foreducational purposes and I mainly focus here on optimizing Python.

The comparison is mainly between the two modules: `cos_sim.py` (poor performance, but better readability) and `cos_sim_np.py` which achieves close to C++ performance using NumPy arrays. The average runtime difference between the two Python scripts is about 1:250.


### About Cosine Similarity
This measure is widely used in document classification and information retrieval where documents are treated as vectors. For example we would like to
find the document that has the highest similarity to the search query. We can get vectors by calculating a score for each word in the dataset (frequency or TF-IDF). With cosine similarity we are then able to measure the similarity between each pair of vectors.

This similarity is calculated by measuring the distance between two vectors and normalizing that by the length of the vectors (so the length of the documents don't play a role: a short document can be very similar to a long one and vice versa).

# Usage
### Input
Expected input is two vectors of equal length.

In the test files, we just randomly generate two vectors, therefore the "similarity" between them is also random.

### Output

Output is a number between -1 and 1, where 1 means the two vectors are completely similar (or identical), 0 means they have no similarity at all and -1
means they are opposites of each other.

# Computational performance

For testing, 2 vectors of size 50,000 are generated which point at opposite directions (so the calculated cosine similarity should be -1). We calculate cosine similarity, repeat this 50 times in total and calculate average runtime. The following test were done on a 8GB/i5 machine.

Note that although Python is the slowest initially, it beats C++ and Perl when we use NumPy arrays instead of built-in lists. (Also note that my knowledge of C++ is very superficial, I'm sure there are ways make it run much faster.)


__C++__:
```
$ make cos_sim_test && ./cos_sim_test
Done. Average runtime: 0.00284s. Similarity: -1.
```

__Perl__:
```
$ perl cos_sim_test.pl
Done. Average runtime : 0.0306 s. Similarity: -1.
```

__Python__:
```
$ python cos_sim_test.py
Done. Average runtime: 0.0491 s. Similarity: -1.0.
```

# Python optimization

First step to optimize Python is to use list comprehensions instead of `for` loops. See the comments in `get_dot_prod()` and `get_eucl_magn()` in `cos_sim.py` to see how this is done. The difference is however not significant:

```
$ python cos_sim_test.py
Done. Average runtime: 0.0437 s. Similarity: -1.0.
```
(Here I use the lines commented in `cos_sim.py`)


Using only standard/builtin data structures, I tried a few other optimizations (`map` with `lambda` instead of list comprehension), function call instead of object), but none improved the running time. This is strange, I would expect that at least a function call should be less expensive than creating an object.

Next step was to use external libraries: using NumPy's `ndarray` (N dimensional array) instead of Python lists is here the game changer. Running the same test as above is almost 250x faster than the initial Python test and 14x faster than C++:

```
$ python cos_sim_np_test.py
Done. Average runtime: 0.0002 s. Similarity: -1.0.
```

It could not be better than this, I thought, but I went on with experiments. This time I used two methods from `sklearn` to calculate dot product (`sklearn.utils.extmath.safe_sparse_dot`) and euclidean distance (`sklearn.metrics.pairwise.euclidean_distances`) respectively. We continue to use NumPy arrays to store the vectors. The result significantly slower than the last experiment:


```
$ python cos_sim_sk_test.py
Done. Average runtime: 0.0025 s. Similarity: -1.0.
```

So what if we delegate the calculation completely to `sklearn`? My last experiment was to use `sklearn.metrics.pairwise.cosine_similarity` as a method (see my comments in `cos_sim_sk_test.py` for how it is done). Slightly better but still 10x slower than simply using NumPy arrays _and_ a not-so-accurate result.

```
$ python cos_sim_np_test.py
Done. Average runtime: 0.0021 s. Similarity: -1.0000000000000024.
```
