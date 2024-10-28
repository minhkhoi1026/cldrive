//{}
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
kernel void private_memory_alignment_alloca() {
  volatile private char private_i8[4];
  volatile private char2 private_v2i8[4];
  volatile private char3 private_v3i8[4];
  volatile private char4 private_v4i8[4];
  volatile private char8 private_v8i8[4];
  volatile private char16 private_v16i8[4];

  volatile private short private_i16[4];
  volatile private short2 private_v2i16[4];
  volatile private short3 private_v3i16[4];
  volatile private short4 private_v4i16[4];
  volatile private short8 private_v8i16[4];
  volatile private short16 private_v16i16[4];

  volatile private int private_i32[4];
  volatile private int2 private_v2i32[4];
  volatile private int3 private_v3i32[4];
  volatile private int4 private_v4i32[4];
  volatile private int8 private_v8i32[4];
  volatile private int16 private_v16i32[4];

  volatile private long private_i64[4];
  volatile private long2 private_v2i64[4];
  volatile private long3 private_v3i64[4];
  volatile private long4 private_v4i64[4];
  volatile private long8 private_v8i64[4];
  volatile private long16 private_v16i64[4];

  volatile private float private_f16[4];
  volatile private float2 private_v2f16[4];
  volatile private float3 private_v3f16[4];
  volatile private float4 private_v4f16[4];
  volatile private float8 private_v8f16[4];
  volatile private float16 private_v16f16[4];

  volatile private float private_f32[4];
  volatile private float2 private_v2f32[4];
  volatile private float3 private_v3f32[4];
  volatile private float4 private_v4f32[4];
  volatile private float8 private_v8f32[4];
  volatile private float16 private_v16f32[4];

  volatile private double private_f64[4];
  volatile private double2 private_v2f64[4];
  volatile private double3 private_v3f64[4];
  volatile private double4 private_v4f64[4];
  volatile private double8 private_v8f64[4];
  volatile private double16 private_v16f64[4];

  *private_i8 = 0;
  *private_v2i8 = 0;
  *private_v3i8 = 0;
  *private_v4i8 = 0;
  *private_v8i8 = 0;
  *private_v16i8 = 0;

  *private_i16 = 0;
  *private_v2i16 = 0;
  *private_v3i16 = 0;
  *private_v4i16 = 0;
  *private_v8i16 = 0;
  *private_v16i16 = 0;

  *private_i32 = 0;
  *private_v2i32 = 0;
  *private_v3i32 = 0;
  *private_v4i32 = 0;
  *private_v8i32 = 0;
  *private_v16i32 = 0;

  *private_i64 = 0;
  *private_v2i64 = 0;
  *private_v3i64 = 0;
  *private_v4i64 = 0;
  *private_v8i64 = 0;
  *private_v16i64 = 0;

  *private_f16 = 0;
  *private_v2f16 = 0;
  *private_v3f16 = 0;
  *private_v4f16 = 0;
  *private_v8f16 = 0;
  *private_v16f16 = 0;

  *private_f32 = 0;
  *private_v2f32 = 0;
  *private_v3f32 = 0;
  *private_v4f32 = 0;
  *private_v8f32 = 0;
  *private_v16f32 = 0;

  *private_f64 = 0;
  *private_v2f64 = 0;
  *private_v3f64 = 0;
  *private_v4f64 = 0;
  *private_v8f64 = 0;
  *private_v16f64 = 0;
}