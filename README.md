
# Cosine Similarity: Python, Perl and C++ library

# About

Cosine Similarity is a measure of similarity between two vectors. This package
is a simple library in three languages: __Python__, __C++__ and __Perl__. This
is only intended for educational purposes and for your large projects I recommend
to use higher performance libraries, such `cosine_similarity` from the library `sklearn` for Python.


### About Cosine Similarity
This measure is widely used in document classification and information retrieval documents in the database are treated as vectors. For example we would like to
find the document that has the highest similarity to the query. We can get vectors by calculating a score (frequency or TF-IDF) for each word in the collection. Using cosine similarity we can measure the similarity between each pair of these vectors.

This similarity is calculated by measuring the angle between the vectors and not
their length (the number of words in the document therefore don't play a role:)

For an example of a project where Cosine Similarity is used, see [here](https://gitlab.com/vgratian/porn_tweets).

# Usage
### Input
Expected input is two vectors of equal length that represent two documents.
These vectors are typically TF-IDF scores, but you can also use word frequencies
or counts.

In the test files, we just randomly generate two vectors, therefore the
"similarity" between them is also random.

### Output

Output is a number between -1 and 1, where 1 means the two vectors are
completely similar (or identical), 0 means they have no similarity at all and -1
means they are opposite of each other.

# Computational Performance

For testing I generate 2 vectors of size 10,000 and calculate CS 100 times.
On my Dell XPS computer with 8G memory and 4 core i5 processor and running on
Arch Linux, I got the following runtimes :


__Python__:
```
$ python cos_sim_test.py
Runtime: 0.934 s
```

__Perl__:
```
$ perl cos_sim_test.pl
Runtime: 0.339 s
```

__C++__:
```
$ make cos_sim_test
$ ./cos_sim_test
Runtime: 0.036 s.

```

# License

Feel free to reuse this code anyhow you want under the GPL license.
