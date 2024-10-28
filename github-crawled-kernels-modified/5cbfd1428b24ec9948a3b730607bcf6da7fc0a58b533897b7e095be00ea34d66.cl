//{"P":0,"Q":1,"buffer":5,"buffer[tx]":6,"buffer[ty]":4,"input":2,"output":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose(const unsigned int P, const unsigned int Q, const global float* input, global float* output) {
  const unsigned int tx = get_local_id(0);
  const unsigned int ty = get_local_id(1);
  const unsigned int ID0 = get_group_id(0) * 8 + tx;
  const unsigned int ID1 = get_group_id(1) * 8 + ty;

  local float buffer[8][8];

  buffer[hook(5, ty)][hook(4, tx)] = input[hook(2, ID1 * P + ID0)];

  barrier(0x01);

  const unsigned int newID0 = get_group_id(1) * 8 + tx;
  const unsigned int newID1 = get_group_id(0) * 8 + ty;

  output[hook(3, newID1 * Q + newID0)] = buffer[hook(5, tx)][hook(6, ty)];
}