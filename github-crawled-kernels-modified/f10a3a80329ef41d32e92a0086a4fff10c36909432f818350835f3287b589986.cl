//{"aligned_items_per_row":10,"csr_cols":3,"csr_elements":4,"csr_rows":2,"ell_coords":0,"ell_elements":1,"internal_row_num":8,"items_per_row":9,"result":6,"row_num":7,"vector":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_mul(const global int* ell_coords, const global float* ell_elements, const global unsigned int* csr_rows, const global unsigned int* csr_cols, const global float* csr_elements, const global float* vector, global float* result, unsigned int row_num, unsigned int internal_row_num, unsigned int items_per_row, unsigned int aligned_items_per_row) {
  unsigned int glb_id = get_global_id(0);
  unsigned int glb_sz = get_global_size(0);

  for (unsigned int row_id = glb_id; row_id < row_num; row_id += glb_sz) {
    float sum = 0;

    unsigned int offset = row_id;
    for (unsigned int item_id = 0; item_id < items_per_row; item_id++, offset += internal_row_num) {
      float val = ell_elements[hook(1, offset)];

      if (val != 0.0f) {
        int col = ell_coords[hook(0, offset)];
        sum += (vector[hook(5, col)] * val);
      }
    }

    unsigned int col_begin = csr_rows[hook(2, row_id)];
    unsigned int col_end = csr_rows[hook(2, row_id + 1)];

    for (unsigned int item_id = col_begin; item_id < col_end; item_id++) {
      sum += (vector[hook(5, csr_cols[ihook(3, item_id))] * csr_elements[hook(4, item_id)]);
    }

    result[hook(6, row_id)] = sum;
  }
}