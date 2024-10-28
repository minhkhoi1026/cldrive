//{"A":0,"B":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void global_bandwidth_v4_local_offset(global float4* A, global float* B) {
  int id = (get_group_id(0) * get_local_size(0) * 16) + get_local_id(0);
  float4 sum = 0;

  sum += A[hook(0, id)];
  id += get_local_size(0);
  sum += A[hook(0, id)];
  id += get_local_size(0);
  ;
  sum += A[hook(0, id)];
  id += get_local_size(0);
  sum += A[hook(0, id)];
  id += get_local_size(0);
  ;
  ;
  sum += A[hook(0, id)];
  id += get_local_size(0);
  sum += A[hook(0, id)];
  id += get_local_size(0);
  ;
  sum += A[hook(0, id)];
  id += get_local_size(0);
  sum += A[hook(0, id)];
  id += get_local_size(0);
  ;
  ;
  ;
  sum += A[hook(0, id)];
  id += get_local_size(0);
  sum += A[hook(0, id)];
  id += get_local_size(0);
  ;
  sum += A[hook(0, id)];
  id += get_local_size(0);
  sum += A[hook(0, id)];
  id += get_local_size(0);
  ;
  ;
  sum += A[hook(0, id)];
  id += get_local_size(0);
  sum += A[hook(0, id)];
  id += get_local_size(0);
  ;
  sum += A[hook(0, id)];
  id += get_local_size(0);
  sum += A[hook(0, id)];
  id += get_local_size(0);
  ;
  ;
  ;

  B[hook(1, get_global_id(0))] = (sum.S0) + (sum.S1) + (sum.S2) + (sum.S3);
}