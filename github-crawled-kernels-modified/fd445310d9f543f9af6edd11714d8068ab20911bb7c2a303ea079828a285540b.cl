//{"fout":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef int int4 __attribute((ext_vector_type(4)));
typedef long long4 __attribute((ext_vector_type(4)));
typedef float float4 __attribute((ext_vector_type(4)));
typedef double double4 __attribute((ext_vector_type(4)));
kernel void floatops(global int4* out, global float4* fout) {
  out[hook(0, 0)] = (float4)(1, 1, 1, 1) && 1.0f;

  out[hook(0, 1)] = (float4)(0, 0, 0, 0) && (float4)(0, 0, 0, 0);

  out[hook(0, 2)] = (float4)(0, 0, 0, 0) || (float4)(1, 1, 1, 1);

  out[hook(0, 3)] = (float4)(0, 0, 0, 0) || 0.0f;

  out[hook(0, 4)] = !(float4)(0, 0, 0, 0);

  out[hook(0, 5)] = !(float4)(1, 2, 3, 4);

  out[hook(0, 6)] = !(float4)(0, 1, 0, 1);

  fout[hook(1, 0)] = (float4)(!0.0f);

  fout[hook(1, 1)] = (float4)(!1.0f);
}