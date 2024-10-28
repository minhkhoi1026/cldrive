//{"aligned_items_per_row":8,"col_num":5,"coords":0,"elements":1,"internal_row_num":6,"items_per_row":7,"result":3,"row_num":4,"vector":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_mul(global const unsigned int* coords, global const float* elements, global const float* vector, global float* result, unsigned int row_num, unsigned int col_num, unsigned int internal_row_num, unsigned int items_per_row, unsigned int aligned_items_per_row) {
  unsigned int glb_id = get_global_id(0);
  unsigned int glb_sz = get_global_size(0);

  for (unsigned int row_id = glb_id; row_id < row_num; row_id += glb_sz) {
    float sum = 0;

    unsigned int offset = row_id;
    for (unsigned int item_id = 0; item_id < items_per_row; item_id++, offset += internal_row_num) {
      float val = elements[hook(1, offset)];

      if (val != 0.0f) {
        int col = coords[hook(0, offset)];
        sum += (vector[hook(2, col)] * val);
      }
    }

    result[hook(3, row_id)] = sum;
  }
}