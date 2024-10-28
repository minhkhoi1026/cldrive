//{"dout":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef int int4 __attribute((ext_vector_type(4)));
typedef long long4 __attribute((ext_vector_type(4)));
typedef float float4 __attribute((ext_vector_type(4)));
typedef double double4 __attribute((ext_vector_type(4)));
kernel void doubleops(global long4* out, global double4* dout) {
  out[hook(0, 0)] = (double4)(1, 1, 1, 1) && 1.0;

  out[hook(0, 1)] = (double4)(0, 0, 0, 0) && (double4)(0, 0, 0, 0);

  out[hook(0, 2)] = (double4)(0, 0, 0, 0) || (double4)(1, 1, 1, 1);

  out[hook(0, 3)] = (double4)(0, 0, 0, 0) || 0.0f;

  out[hook(0, 4)] = !(double4)(0, 0, 0, 0);

  out[hook(0, 5)] = !(double4)(1, 2, 3, 4);

  out[hook(0, 6)] = !(double4)(0, 1, 0, 1);

  dout[hook(1, 0)] = (double4)(!0.0f);

  dout[hook(1, 1)] = (double4)(!1.0f);
}