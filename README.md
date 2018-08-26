
# Cosine Similarity: Python, Perl and C++ library

# About

Cosine Similarity is a measure of similarity between two vectors. This package
is a simple library in three languages: __Python__, __C++__ and __Perl__. This
is only intended for educational purposes and for your large projects I recommend
to use higher performance libraries.

Using only standard libraries, Python is the slowest of all three, but using NumPy arrays, Python is the fastest.


### About Cosine Similarity
This measure is widely used in document classification and information retrieval where documents are treated as vectors. For example we would like to
find the document that has the highest similarity to the search query. We can get vectors by calculating a score for each word in the dataset (frequency or TF-IDF). With cosine similarity we are then able to measure the similarity between each pair of vectors.

This similarity is calculated by measuring the distance between two vectors and normalizing that by the length of the vectors (so the length of the documents don't play a role: a short document can be very similar to a long one and vice versa).

# Usage
### Input
Expected input is two vectors of equal length.

In the test files, we just randomly generate two vectors, therefore the
"similarity" between them is also random.

### Output

Output is a number between -1 and 1, where 1 means the two vectors are
completely similar (or identical), 0 means they have no similarity at all and -1
means they are opposites of each other.

# Computational performance

For testing I generate 2 vectors of size 10,000 and calculate cosine similarity 100 times. (Since vectors are random ints between -10 and 10 the runtime is slightly different for each experiment). The following test were done on a 8GB/i5 machine.

Note that although Python is the slowest in the race, its time costs can be reduced drastically by using NumPy arrays instead of built-in lists.


__C++__:
```
$ make cos_sim_test && ./cos_sim_test
Runtime: 0.034 s.
```

__Perl__:
```
$ perl cos_sim_test.pl
Runtime: 0.358 s
```

__Python__:
```
$ python cos_sim_test.py
Runtime: 0.962 s
```

__Python__ with NumPy arrays:
```
$ python cos_sim_np_test.py
Runtime: 0.010 s
```

_Note_: since vectors are initialized with random values, these runtimes are not very precise and have a ~3-4% variation.

# Python optimization

Python can run a bit faster (~0.865 s) if we use list comprehensions instead open `for` loops. For the sake of readability (which is the sole purpose here) I leave the Python script as it, but as mentioned before I don't recommend using it for practical purposes.

If we choose for list comprehensions, we can simple replace the methods `get_dot_prod` and `get_eucl_magn` in the class `Cos_Sim` by the following two lines respectively:

```python
return sum([a*b for a,b in zip(self.vec0,self.vec1)])
```


and:
```python
return sqrt(sum([pow(x,2) for x in self.vec0]) * sum([pow(x,2) for x in self.vec1]))
```

There must be other ways to improve Python performance. I tried using `map` with `lambda`, arrays instead of lists, simple function instead of class, and all made the runtime even worse.

Game-changer is when we use _NumPy_'s `ndarray` instead of Python's builtin lists. Running the same test as above, the runtime is __0.010__ beating even C++. See `cos_sim_np.py` and `cos_sim_np_test.py` for how to use numpy.
