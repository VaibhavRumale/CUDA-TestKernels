// --atomics 15 ---fake_divergence -g 42,55,3 -l 6,1,1
#ifndef NO_GROUP_DIVERGENCE
#define GROUP_DIVERGE(a, b) get_block_id(a)
#else
#define GROUP_DIVERGE(x, y) (y)
#endif

#ifndef NO_FAKE_DIVERGENCE
#define FAKE_DIVERGE(x, y, z) (x - y)
#else
#define FAKE_DIVERGE(x, y, z) (z)
#endif


// Seed: 1123171451

#include "CUDA.h"

/* --- Struct/Union Declarations --- */
/* --- Struct/Union Declarations End --- */
struct S1 {
    int32_t g_3;
    uint64_t global_0_offset;
    uint64_t global_1_offset;
    uint64_t global_2_offset;
    uint64_t local_0_offset;
    uint64_t local_1_offset;
    uint64_t local_2_offset;
    uint64_t group_0_offset;
    uint64_t group_1_offset;
    uint64_t group_2_offset;
};


/* --- FORWARD DECLARATIONS --- */
__device__ int32_t  func_1(struct S1 * p_4);


/* --- FUNCTIONS --- */
/* ------------------------------------------ */
/* 
 * reads : p_4->g_3
 * writes: p_4->g_3
 */
__device__ int32_t  func_1(struct S1 * p_4)
{ /* block id: 4 */
    int32_t *l_2 = &p_4->g_3;
    (*l_2) |= 1L;
    return (*l_2);
}


extern "C" __global__ void entry( long *result,  volatile uint *g_atomic_input,  volatile uint *g_special_values , int *sequence_input) {
    int ;
    struct S1 c_5;
    struct S1* p_4 = &c_5;
    struct S1 c_6 = {
        0x5AE8C9F3L, // p_4->g_3
        sequence_input[get_global_id(0)], // p_4->global_0_offset
        sequence_input[get_global_id(1)], // p_4->global_1_offset
        sequence_input[get_global_id(2)], // p_4->global_2_offset
        sequence_input[get_local_id(0)], // p_4->local_0_offset
        sequence_input[get_local_id(1)], // p_4->local_1_offset
        sequence_input[get_local_id(2)], // p_4->local_2_offset
        sequence_input[get_group_id(0)], // p_4->group_0_offset
        sequence_input[get_group_id(1)], // p_4->group_1_offset
        sequence_input[get_group_id(2)], // p_4->group_2_offset
    };
    c_5 = c_6;
    __syncthreads();
    func_1(p_4);
    __syncthreads();
    uint64_t crc64_context = 0xFFFFFFFFFFFFFFFFUL;
    int print_hash_value = 0;
    transparent_crc(p_4->g_3, "p_4->g_3", print_hash_value);
       result[get_linear_global_id()] = crc64_context ^ 0xFFFFFFFFFFFFFFFFUL;
}
