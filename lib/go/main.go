package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
	"time"
)

func exitError(msg string, err error) {
	fmt.Println(msg, err)
	os.Exit(1)
}

func vectFromFile(size int64, filename string) []float64 {

	var (
		data   []byte
		values []string
		value  float64
		vector []float64
		i      int64
		err    error
	)

	if data, err = ioutil.ReadFile(filename); err != nil {
		exitError("read "+filename, err)
	}

	vector = make([]float64, size)
	values = strings.Fields(string(data))

	for i = 0; i < size; i += 1 {
		if value, err = strconv.ParseFloat(values[i], 64); err != nil {
			exitError("ParseFloat "+values[i], err)
		}
		vector[i] = value
	}

	return vector
}

func main() {
	var (
		repeat, size, i int64
		similarity      float64
		vectA, vectB    []float64
		start           time.Time
		avgTime         time.Duration
		err             error
	)

	if len(os.Args) != 5 {
		fmt.Println("Usage: <repeat> <size> <vector fp> <vector fp>")
		os.Exit(1)
	}

	if repeat, err = strconv.ParseInt(os.Args[1], 10, 32); err != nil {
		exitError("ParseInt (repeat) "+os.Args[1], err)
	}

	if size, err = strconv.ParseInt(os.Args[2], 10, 64); err != nil {
		exitError("ParseInt (size) "+os.Args[2], err)
	}

	vectA = vectFromFile(size, os.Args[3])
	vectB = vectFromFile(size, os.Args[4])

	for i = 0; i < repeat; i++ {
		start = time.Now()
		if similarity, err = GetCosineSimilarity(vectA, vectB); err != nil {
			exitError("GetCosineSimilarity", err)
		}
		avgTime += time.Since(start)
	}

	fmt.Printf("%.20f %.15f", similarity, avgTime.Seconds()/float64(repeat))
}
