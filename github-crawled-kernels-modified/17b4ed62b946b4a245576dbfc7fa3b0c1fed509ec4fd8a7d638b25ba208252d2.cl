//{"arg_d":2,"arg_f":1,"arg_h":0}
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
kernel void format_v4f64(float4 arg_h, float4 arg_f, double4 arg_d) {
  printf("%v4lf", arg_d);
  printf("%v4lf", arg_f);
  printf("%v4lf", arg_h);

  printf("%v4lF", arg_d);
  printf("%v4lF", arg_f);
  printf("%v4lF", arg_h);

  printf("%v4le", arg_d);
  printf("%v4le", arg_f);
  printf("%v4le", arg_h);

  printf("%v4lE", arg_d);
  printf("%v4lE", arg_f);
  printf("%v4lE", arg_h);

  printf("%v4lg", arg_d);
  printf("%v4lg", arg_f);
  printf("%v4lg", arg_h);

  printf("%v4lG", arg_d);
  printf("%v4lG", arg_f);
  printf("%v4lG", arg_h);

  printf("%v4la", arg_d);
  printf("%v4la", arg_f);
  printf("%v4la", arg_h);

  printf("%v4lA", arg_d);
  printf("%v4lA", arg_f);
  printf("%v4lA", arg_h);
}