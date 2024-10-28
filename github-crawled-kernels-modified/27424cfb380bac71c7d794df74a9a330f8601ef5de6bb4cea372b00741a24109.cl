//{"A":0,"B":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void global_bandwidth_v16_global_offset(global float16* A, global float* B) {
  int id = get_global_id(0);
  float16 sum = 0;

  sum += A[hook(0, id)];
  id += get_global_size(0);
  sum += A[hook(0, id)];
  id += get_global_size(0);
  ;
  sum += A[hook(0, id)];
  id += get_global_size(0);
  sum += A[hook(0, id)];
  id += get_global_size(0);
  ;
  ;
  sum += A[hook(0, id)];
  id += get_global_size(0);
  sum += A[hook(0, id)];
  id += get_global_size(0);
  ;
  sum += A[hook(0, id)];
  id += get_global_size(0);
  sum += A[hook(0, id)];
  id += get_global_size(0);
  ;
  ;
  ;
  sum += A[hook(0, id)];
  id += get_global_size(0);
  sum += A[hook(0, id)];
  id += get_global_size(0);
  ;
  sum += A[hook(0, id)];
  id += get_global_size(0);
  sum += A[hook(0, id)];
  id += get_global_size(0);
  ;
  ;
  sum += A[hook(0, id)];
  id += get_global_size(0);
  sum += A[hook(0, id)];
  id += get_global_size(0);
  ;
  sum += A[hook(0, id)];
  id += get_global_size(0);
  sum += A[hook(0, id)];
  id += get_global_size(0);
  ;
  ;
  ;

  float t = (sum.S0) + (sum.S1) + (sum.S2) + (sum.S3) + (sum.S4) + (sum.S5) + (sum.S6) + (sum.S7);
  t += (sum.S8) + (sum.S9) + (sum.SA) + (sum.SB) + (sum.SC) + (sum.SD) + (sum.SE) + (sum.SF);
  B[hook(1, get_global_id(0))] = t;
}