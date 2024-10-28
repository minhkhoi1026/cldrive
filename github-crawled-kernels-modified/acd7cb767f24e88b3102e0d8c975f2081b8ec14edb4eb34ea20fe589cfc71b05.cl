//{"W":2,"X":0,"Y":1,"misclassified":3,"not_classified":4,"score_shared":8,"sum_missed":5,"x_dim":6,"x_length":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void classify(global float* X, global char* Y, global float* W, global char* misclassified, global char* not_classified, global int* sum_missed, int x_dim, int x_length) {
  local float score_shared[500];
  int worker_id = get_global_id(0);
  int j;
  score_shared[hook(8, worker_id)] = 0;
  sum_missed[hook(5, worker_id)] = 0;
  not_classified[hook(4, worker_id)] = 0;
  for (j = 0; j < x_dim; j++) {
    score_shared[hook(8, worker_id)] += X[hook(0, worker_id * x_dim + j)] * W[hook(2, j)];
  }
  barrier(0x01);
  misclassified[hook(3, worker_id)] = score_shared[hook(8, worker_id)] * Y[hook(1, worker_id)] <= 0.0 ? 1 : 0;
  barrier(0x01);
  if (misclassified[hook(3, worker_id)] == 1) {
    sum_missed[hook(5, worker_id)] = 1;
    not_classified[hook(4, worker_id)] = 1;
  }
  barrier(0x01);
}