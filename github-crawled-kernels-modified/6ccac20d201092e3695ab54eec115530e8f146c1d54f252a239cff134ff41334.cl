//{"lds_f16":24,"lds_f32":30,"lds_f64":36,"lds_i16":6,"lds_i32":12,"lds_i64":18,"lds_i8":0,"lds_v16f16":29,"lds_v16f32":35,"lds_v16f64":41,"lds_v16i16":11,"lds_v16i32":17,"lds_v16i64":23,"lds_v16i8":5,"lds_v2f16":25,"lds_v2f32":31,"lds_v2f64":37,"lds_v2i16":7,"lds_v2i32":13,"lds_v2i64":19,"lds_v2i8":1,"lds_v3f16":26,"lds_v3f32":32,"lds_v3f64":38,"lds_v3i16":8,"lds_v3i32":14,"lds_v3i64":20,"lds_v3i8":2,"lds_v4f16":27,"lds_v4f32":33,"lds_v4f64":39,"lds_v4i16":9,"lds_v4i32":15,"lds_v4i64":21,"lds_v4i8":3,"lds_v8f16":28,"lds_v8f32":34,"lds_v8f64":40,"lds_v8i16":10,"lds_v8i32":16,"lds_v8i64":22,"lds_v8i8":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef char __attribute__((ext_vector_type(2))) char2;
typedef char __attribute__((ext_vector_type(3))) char3;
typedef char __attribute__((ext_vector_type(4))) char4;
typedef char __attribute__((ext_vector_type(8))) char8;
typedef char __attribute__((ext_vector_type(16))) char16;
typedef short __attribute__((ext_vector_type(2))) short2;
typedef short __attribute__((ext_vector_type(3))) short3;
typedef short __attribute__((ext_vector_type(4))) short4;
typedef short __attribute__((ext_vector_type(8))) short8;
typedef short __attribute__((ext_vector_type(16))) short16;
typedef int __attribute__((ext_vector_type(2))) int2;
typedef int __attribute__((ext_vector_type(3))) int3;
typedef int __attribute__((ext_vector_type(4))) int4;
typedef int __attribute__((ext_vector_type(8))) int8;
typedef int __attribute__((ext_vector_type(16))) int16;
typedef long __attribute__((ext_vector_type(2))) long2;
typedef long __attribute__((ext_vector_type(3))) long3;
typedef long __attribute__((ext_vector_type(4))) long4;
typedef long __attribute__((ext_vector_type(8))) long8;
typedef long __attribute__((ext_vector_type(16))) long16;
typedef float __attribute__((ext_vector_type(2))) float2;
typedef float __attribute__((ext_vector_type(3))) float3;
typedef float __attribute__((ext_vector_type(4))) float4;
typedef float __attribute__((ext_vector_type(8))) float8;
typedef float __attribute__((ext_vector_type(16))) float16;
typedef float __attribute__((ext_vector_type(2))) float2;
typedef float __attribute__((ext_vector_type(3))) float3;
typedef float __attribute__((ext_vector_type(4))) float4;
typedef float __attribute__((ext_vector_type(8))) float8;
typedef float __attribute__((ext_vector_type(16))) float16;
typedef double __attribute__((ext_vector_type(2))) double2;
typedef double __attribute__((ext_vector_type(3))) double3;
typedef double __attribute__((ext_vector_type(4))) double4;
typedef double __attribute__((ext_vector_type(8))) double8;
typedef double __attribute__((ext_vector_type(16))) double16;
kernel void local_memory_alignment_arg(volatile local char* lds_i8, volatile local char2* lds_v2i8, volatile local char3* lds_v3i8, volatile local char4* lds_v4i8, volatile local char8* lds_v8i8, volatile local char16* lds_v16i8, volatile local short* lds_i16, volatile local short2* lds_v2i16, volatile local short3* lds_v3i16, volatile local short4* lds_v4i16, volatile local short8* lds_v8i16, volatile local short16* lds_v16i16, volatile local int* lds_i32, volatile local int2* lds_v2i32, volatile local int3* lds_v3i32, volatile local int4* lds_v4i32, volatile local int8* lds_v8i32, volatile local int16* lds_v16i32, volatile local long* lds_i64, volatile local long2* lds_v2i64, volatile local long3* lds_v3i64, volatile local long4* lds_v4i64, volatile local long8* lds_v8i64, volatile local long16* lds_v16i64, volatile local float* lds_f16, volatile local float2* lds_v2f16, volatile local float3* lds_v3f16, volatile local float4* lds_v4f16, volatile local float8* lds_v8f16, volatile local float16* lds_v16f16, volatile local float* lds_f32, volatile local float2* lds_v2f32, volatile local float3* lds_v3f32, volatile local float4* lds_v4f32, volatile local float8* lds_v8f32, volatile local float16* lds_v16f32, volatile local double* lds_f64, volatile local double2* lds_v2f64, volatile local double3* lds_v3f64, volatile local double4* lds_v4f64, volatile local double8* lds_v8f64, volatile local double16* lds_v16f64) {
  *lds_i8 = 0;
  *lds_v2i8 = 0;
  *lds_v3i8 = 0;
  *lds_v4i8 = 0;
  *lds_v8i8 = 0;
  *lds_v16i8 = 0;

  *lds_i16 = 0;
  *lds_v2i16 = 0;
  *lds_v3i16 = 0;
  *lds_v4i16 = 0;
  *lds_v8i16 = 0;
  *lds_v16i16 = 0;

  *lds_i32 = 0;
  *lds_v2i32 = 0;
  *lds_v3i32 = 0;
  *lds_v4i32 = 0;
  *lds_v8i32 = 0;
  *lds_v16i32 = 0;

  *lds_i64 = 0;
  *lds_v2i64 = 0;
  *lds_v3i64 = 0;
  *lds_v4i64 = 0;
  *lds_v8i64 = 0;
  *lds_v16i64 = 0;

  *lds_f16 = 0;
  *lds_v2f16 = 0;
  *lds_v3f16 = 0;
  *lds_v4f16 = 0;
  *lds_v8f16 = 0;
  *lds_v16f16 = 0;

  *lds_f32 = 0;
  *lds_v2f32 = 0;
  *lds_v3f32 = 0;
  *lds_v4f32 = 0;
  *lds_v8f32 = 0;
  *lds_v16f32 = 0;

  *lds_f64 = 0;
  *lds_v2f64 = 0;
  *lds_v3f64 = 0;
  *lds_v4f64 = 0;
  *lds_v8f64 = 0;
  *lds_v16f64 = 0;
}