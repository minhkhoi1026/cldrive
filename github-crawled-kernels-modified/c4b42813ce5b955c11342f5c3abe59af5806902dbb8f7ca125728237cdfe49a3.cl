//{"W":2,"X":0,"Y":1,"block_weights":8,"block_weights[i]":9,"block_weights[local_id]":7,"eta":6,"misclassified":3,"x_dim":5,"x_length":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calculate_weights(global float* X, global char* Y, global float* W, global char* misclassified, int x_length, int x_dim, float eta) {
  int worker_id = get_global_id(0);
  int local_id = get_local_id(0);
  int group_id = get_group_id(0);
  local float block_weights[300][6];
  int i, j;
  if (misclassified[hook(3, worker_id)] == 1) {
    for (j = 0; j < x_dim; j++) {
      block_weights[hook(8, local_id)][hook(7, j)] = eta * X[hook(0, worker_id * x_dim + j)] * Y[hook(1, worker_id)];
    }
  } else {
    for (j = 0; j < x_dim; j++) {
      block_weights[hook(8, local_id)][hook(7, j)] = 0;
    }
  }

  barrier(0x01);
  float sum;
  if (local_id == 1) {
    for (j = 0; j < x_dim; j++) {
      sum = 0;
      for (i = 0; i < 300; i++) {
        sum = sum + block_weights[hook(8, i)][hook(9, j)];
      }
      W[hook(2, group_id * x_dim + j)] = sum;
    }
  }
}