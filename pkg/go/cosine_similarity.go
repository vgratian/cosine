package main

import (
	"errors"
	"math"
)

func GetCosineSimilarity(A []float64, B []float64) (float64, error) {
	var eucl_magn, dot_product, similarity float64
	var err error
	err = nil
	eucl_magn = GetMagnitude(A, B)
	if eucl_magn > 0 {
		dot_product = GetDotProduct(A, B)
		similarity = dot_product / eucl_magn
	} else {
		similarity = 0
		err = errors.New("undefined")
	}
	return similarity, err
}

func GetMagnitude(A []float64, B []float64) float64 {
	var A_len, B_len float64
	var i int

	A_len = 0
	B_len = 0

	for i = 0; i < len(A); i += 1 {
		A_len += (A[i] * A[i]) //math.Pow(A[i], 2)
		B_len += (B[i] * B[i]) //math.Pow(B[i], 2)
	}

	return math.Sqrt(A_len * B_len)
}

func GetDotProduct(A []float64, B []float64) float64 {
	var dot_product float64
	var i int
	for i = 0; i < len(A); i++ {
		dot_product += (A[i] * B[i])
	}
	return dot_product
}
