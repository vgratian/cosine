package main

import (
	"os"
	"strconv"
	"fmt"
	"io/ioutil"
	"strings"
	"time"
	"example.org/cos_sim"
)

func vector_from_file(size int64, filename string) ([]float64) {
	
	var data []byte
	var values []string
	var value float64
	var err error
	var i int64
	var vector = make([]float64, size)

	data, err = ioutil.ReadFile(filename)
	if err != nil { panic(err) }

	values = strings.Fields(string(data))

	for i=0; i<size; i+=1 {
		value, err = strconv.ParseFloat(values[i], 64)
		if err != nil { panic(err) }
		vector[i] = value
	}

	return vector
}

func main() {
	var repeat, size, i int64
	var similarity, avg_time float64
	var vector_a, vector_b []float64
	var start time.Time
	var elapsed time.Duration
	var err error

	repeat, err = strconv.ParseInt(os.Args[1], 10, 32)
	if err != nil { panic(err) }
	size, err = strconv.ParseInt(os.Args[2], 10, 64)
	if err != nil { panic(err) }

	vector_a = vector_from_file(size, os.Args[3])
	vector_b = vector_from_file(size, os.Args[4])

	for i=0; i<repeat; i++ {
		start = time.Now()
		similarity, err = cos_sim.GetCosineSimilarity(vector_a, vector_b)
		if err != nil { panic(err) }
		elapsed = time.Since(start)
		if err != nil { panic(err) }
		avg_time += elapsed.Seconds()
	}
	
	avg_time = avg_time / float64(repeat)

	fmt.Printf("%.20f %.10f\n", similarity, avg_time)
}
