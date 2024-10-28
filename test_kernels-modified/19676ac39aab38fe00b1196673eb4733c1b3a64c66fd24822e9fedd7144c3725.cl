//{"distances":2,"indices":1,"input":0,"k":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void findKNearest(const global float* input, global unsigned int* indices, global float* distances, const ulong k) {
  size_t startMat = get_global_id(0) * get_global_size(0);
  size_t endMat = (get_global_id(0) + 1) * get_global_size(0);

  size_t startK = get_global_id(0) * k;
  size_t endK = (get_global_id(0) + 1) * k;

  size_t ourself = startMat + get_global_id(0);

  for (size_t i = startMat; i < endMat; ++i) {
    if (input[hook(0, i)] < distances[hook(2, startK)]

        && i != ourself) {
      size_t us = startK;
      for (size_t j = startK; j < endK; ++j) {
        us = input[hook(0, i)] < distances[hook(2, j)] ? j : us;
      }

      for (size_t j = us + 1; j > startK; --j) {
        indices[hook(1, j - 1)] = indices[hook(1, j)];
        distances[hook(2, j - 1)] = distances[hook(2, j)];
      }

      distances[hook(2, us)] = input[hook(0, i)];
      indices[hook(1, us)] = i;
    }
  }
}