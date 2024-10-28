//{"X":1,"Y":2,"Z":0,"x":3,"y":4,"z":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float float4 __attribute__((ext_vector_type(4)));
kernel void k_gen_4_4_cl_gemm_v3_(global float4* restrict Z, const global float4* restrict X, const global float4* restrict Y) {
  float4 x[4];
  float4 y[4];
  float4 z[4];

  x[hook(3, 0)] = X[hook(1, 0)];
  x[hook(3, 1)] = X[hook(1, 1)];
  x[hook(3, 2)] = X[hook(1, 2)];
  x[hook(3, 3)] = X[hook(1, 3)];

  y[hook(4, 0)] = Y[hook(2, 0)];
  y[hook(4, 1)] = Y[hook(2, 1)];
  y[hook(4, 2)] = Y[hook(2, 2)];
  y[hook(4, 3)] = Y[hook(2, 3)];

  z[hook(5, 0)] = 0.0f;
  z[hook(5, 1)] = 0.0f;
  z[hook(5, 2)] = 0.0f;
  z[hook(5, 3)] = 0.0f;

  z[hook(5, 0)] = ((z[hook(5, 0)]) + (x[hook(3, 0)]) * (y[hook(4, 0)].x));
  z[hook(5, 1)] += x[hook(3, 0)] * y[hook(4, 1)].x;
  z[hook(5, 2)] += x[hook(3, 0)] * y[hook(4, 2)].x;
  z[hook(5, 3)] += x[hook(3, 0)] * y[hook(4, 3)].x;

  z[hook(5, 0)] += x[hook(3, 1)] * y[hook(4, 0)].y;
  z[hook(5, 1)] += x[hook(3, 1)] * y[hook(4, 1)].y;
  z[hook(5, 2)] += x[hook(3, 1)] * y[hook(4, 2)].y;
  z[hook(5, 3)] += x[hook(3, 1)] * y[hook(4, 3)].y;

  z[hook(5, 0)] += x[hook(3, 2)] * y[hook(4, 0)].z;
  z[hook(5, 1)] += x[hook(3, 2)] * y[hook(4, 1)].z;
  z[hook(5, 2)] += x[hook(3, 2)] * y[hook(4, 2)].z;
  z[hook(5, 3)] += x[hook(3, 2)] * y[hook(4, 3)].z;

  z[hook(5, 0)] += x[hook(3, 3)] * y[hook(4, 0)].w;
  z[hook(5, 1)] += x[hook(3, 3)] * y[hook(4, 1)].w;
  z[hook(5, 2)] += x[hook(3, 3)] * y[hook(4, 2)].w;
  z[hook(5, 3)] += x[hook(3, 3)] * y[hook(4, 3)].w;

  Z[hook(0, 0)] = z[hook(5, 0)];
  Z[hook(0, 1)] = z[hook(5, 1)];
  Z[hook(0, 2)] = z[hook(5, 2)];
  Z[hook(0, 3)] = z[hook(5, 3)];
}