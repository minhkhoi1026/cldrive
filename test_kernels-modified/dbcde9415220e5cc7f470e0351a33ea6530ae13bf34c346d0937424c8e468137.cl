//{"final":3,"size":0,"x":1,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void calc_pq_index(int size, int idx, int* p, int* q);
void calc_pq_index(int size, int idx, int* p, int* q) {
  int i;
  int count = idx;
  *p = 0;
  *q = *p + 1;
  for (i = size - 1; i > 0; i--) {
    if (count < i) {
      *q = count + *q;
      break;
    } else {
      count -= i;
      *p = *p + 1;
      *q = *p + 1;
    }
  }
}

kernel void calc_distance(int size, global float* x, global float* y, global float* final) {
  int global_id = get_global_id(0);
  int p_idx, q_idx;

  calc_pq_index(size, global_id, &p_idx, &q_idx);

  float2 p = (float2)(x[hook(1, p_idx)], y[hook(2, p_idx)]);
  float2 q = (float2)(x[hook(1, q_idx)], y[hook(2, q_idx)]);
  final[hook(3, global_id)] = distance(p, q);
}