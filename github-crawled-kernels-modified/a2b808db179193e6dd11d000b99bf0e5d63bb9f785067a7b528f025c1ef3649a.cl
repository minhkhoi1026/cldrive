//{"arg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef __attribute__((ext_vector_type(4))) float float4;
typedef __attribute__((ext_vector_type(2))) float float2;
typedef __attribute__((ext_vector_type(4))) float float4;
typedef __attribute__((ext_vector_type(4))) double double4;
typedef __attribute__((ext_vector_type(4))) char char4;
typedef __attribute__((ext_vector_type(4))) unsigned char uchar4;
typedef __attribute__((ext_vector_type(4))) short short4;
typedef __attribute__((ext_vector_type(4))) unsigned short ushort4;
typedef __attribute__((ext_vector_type(2))) int int2;
typedef __attribute__((ext_vector_type(4))) int int4;
typedef __attribute__((ext_vector_type(16))) int int16;
typedef __attribute__((ext_vector_type(4))) long long4;
typedef __attribute__((ext_vector_type(4))) unsigned int uint4;
typedef __attribute__((ext_vector_type(4))) unsigned long ulong4;
int printf(constant const char* st, ...) __attribute__((format(printf, 1, 2)));
kernel void format_not_num(int arg) {
  printf("%vNd", arg);
  printf("%v*d", arg);
}