//{"col_num":2,"input":0,"row_num":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose_inplace(global float* input, unsigned int row_num, unsigned int col_num) {
  unsigned int size = row_num * col_num;
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    unsigned int row = i / col_num;
    unsigned int col = i - row * col_num;

    unsigned int new_pos = col * row_num + row;

    if (i < new_pos) {
      float val = input[hook(0, i)];
      input[hook(0, i)] = input[hook(0, new_pos)];
      input[hook(0, new_pos)] = val;
    }
  }
}