// Compiled with: nvcc -o tensor_core tensor_core.cu -arch=sm_70

#include <cuda_fp16.h>

// Kernel for FP16 Tensor Core matrix multiplication
__global__ void tcMul(const __half* A, const __half* B, __half* C, int M, int N, int K) {
    int row = blockIdx.y * blockDim.y + threadIdx.y; 
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    __half result = __float2half(0.0f);
    for (int k = 0; k < K; ++k) {
        __half a = __ldg(&A[row * K + k]); // Use __ldg to load from global memory
        __half b = __ldg(&B[k * N + col]);
        result = __hfma(result, a, b, result); // Fused multiply-add with Tensor Cores
    }
    C[row * N + col] = result;
}

int main() {
    const int M = 1024;
    const int N = 1024; 
    const int K = 1024;

    // Allocate host memory
    __half* h_A = (__half*)malloc(M * K * sizeof(__half));
    __half* h_B = (__half*)malloc(K * N * sizeof(__half));
    __half* h_C = (__half*)malloc(M * N * sizeof(__half));

    // Initialize input matrices
    // ...

    // Allocate device memory
    __half* d_A, *d_B, *d_C;
    cudaMalloc(&d_A, M * K * sizeof(__half));
    cudaMalloc(&d_B, K * N * sizeof(__half));
    cudaMalloc(&d_C, M * N * sizeof(__half));

    // Copy input data to device
    cudaMemcpy(d_A, h_A, M * K * sizeof(__half), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, K * N * sizeof(__half), cudaMemcpyHostToDevice);

    // Launch Tensor Core kernel
    dim3 blockDim(16, 16);
    dim3 gridDim((N + blockDim.x - 1) / blockDim.x, (M + blockDim.y - 1) / blockDim.y);
    tcMul<<<gridDim, blockDim>>>(d_A, d_B, d_C, M, N, K);

    // Copy output data back to host
    cudaMemcpy(h_C, d_C, M * N * sizeof(__half), cudaMemcpyDeviceToHost);

    // Free device memory
    cudaFree(d_A);
    cudaFree(d_B); 
    cudaFree(d_C);

    // Free host memory
    free(h_A);
    free(h_B);
    free(h_C);

    return 0;
}
