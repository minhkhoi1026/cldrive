//{"count":3,"input":0,"output":2,"vec1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void int_bubble_filter(global int* input, constant int* vec1, global int* output, const int count) {
  int i;
  int k = 1;
  int nb_threads = get_global_size(0);
  if (get_global_id(0) <= count / 2) {
    output[hook(2, get_global_id(0) * 2)] = vec1[hook(1, get_global_id(0) * 2)];
    output[hook(2, get_global_id(0) * 2 + 1)] = vec1[hook(1, get_global_id(0) * 2 + 1)];

    for (int n = 0; n < count * 2; n++) {
      k = (k) ? 0 : 1;
      i = (get_global_id(0) * 2) + k;
      if (i + 1 < count) {
        if ((!input[hook(0, i)]) && (input[hook(0, i + 1)])) {
          input[hook(0, i)] = 1;
          input[hook(0, i + 1)] = 0;
          output[hook(2, i)] = output[hook(2, i + 1)];
          output[hook(2, i + 1)] = 0;
        } else {
          if (!input[hook(0, i)])
            output[hook(2, i)] = 0;
          if (!input[hook(0, i + 1)])
            output[hook(2, i + 1)] = 0;
        }
      }
      barrier(0x02);
    }
  }
}