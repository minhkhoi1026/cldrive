//{"arg_c":0,"arg_i":2,"arg_l":3,"arg_s":1,"arg_uc":4,"arg_ui":6,"arg_ul":7,"arg_us":5}
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
kernel void printf_int_length_modifiers(char4 arg_c, short4 arg_s, int4 arg_i, long4 arg_l, uchar4 arg_uc, ushort4 arg_us, uint4 arg_ui, ulong4 arg_ul) {
  printf("%v4hhd", arg_c);
  printf("%v4hhd", arg_s);
  printf("%v4hhd", arg_i);
  printf("%v4hhd", arg_l);

  printf("%v4hd", arg_c);
  printf("%v4hd", arg_s);
  printf("%v4hd", arg_i);
  printf("%v4hd", arg_l);

  printf("%v4hld", arg_c);
  printf("%v4hld", arg_s);
  printf("%v4hld", arg_i);
  printf("%v4hld", arg_l);

  printf("%v4ld", arg_c);
  printf("%v4ld", arg_s);
  printf("%v4ld", arg_i);
  printf("%v4ld", arg_l);

  printf("%v4hhu", arg_uc);
  printf("%v4hhu", arg_us);
  printf("%v4hhu", arg_ui);
  printf("%v4hhu", arg_ul);

  printf("%v4hu", arg_uc);
  printf("%v4hu", arg_us);
  printf("%v4hu", arg_ui);
  printf("%v4hu", arg_ul);

  printf("%v4hlu", arg_uc);
  printf("%v4hlu", arg_us);
  printf("%v4hlu", arg_ui);
  printf("%v4hlu", arg_ul);

  printf("%v4lu", arg_uc);
  printf("%v4lu", arg_us);
  printf("%v4lu", arg_ui);
  printf("%v4lu", arg_ul);

  printf("%v4n", &arg_i);
  printf("%v4hln", &arg_i);
}