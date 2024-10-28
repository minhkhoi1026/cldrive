//{"column_indices":1,"elements":2,"option":5,"result":3,"row_indices":0,"size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void row_info_extractor(global const unsigned int* row_indices, global const unsigned int* column_indices, global const float* elements, global float* result, unsigned int size, unsigned int option) {
  for (unsigned int row = get_global_id(0); row < size; row += get_global_size(0)) {
    float value = 0;
    unsigned int row_end = row_indices[hook(0, row + 1)];

    switch (option) {
      case 0:
        for (unsigned int i = row_indices[hook(0, row)]; i < row_end; ++i)
          value = max(value, fabs(elements[hook(2, i)]));
        break;

      case 1:
        for (unsigned int i = row_indices[hook(0, row)]; i < row_end; ++i)
          value += fabs(elements[hook(2, i)]);
        break;

      case 2:
        for (unsigned int i = row_indices[hook(0, row)]; i < row_end; ++i)
          value += elements[hook(2, i)] * elements[hook(2, i)];
        value = sqrt(value);
        break;

      case 3:
        for (unsigned int i = row_indices[hook(0, row)]; i < row_end; ++i) {
          if (column_indices[hook(1, i)] == row) {
            value = elements[hook(2, i)];
            break;
          }
        }
        break;

      default:
        break;
    }
    result[hook(3, row)] = value;
  }
}