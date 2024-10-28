//{"col_num":3,"input":0,"output":1,"row_num":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose(global float2* input, global float2* output, unsigned int row_num, unsigned int col_num) {
  unsigned int size = row_num * col_num;
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    unsigned int row = i / col_num;
    unsigned int col = i - row * col_num;

    unsigned int new_pos = col * row_num + row;

    output[hook(1, new_pos)] = input[hook(0, i)];
  }
}