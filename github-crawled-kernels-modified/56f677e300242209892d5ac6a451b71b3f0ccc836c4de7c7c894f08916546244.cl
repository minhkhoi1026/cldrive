//{"iteration":2,"matrix":0,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Access(global ulong* matrix, int width, int iteration) {
  int y = get_global_id(1) * 16;
  int x = get_global_id(0) * 16;

  global ulong* curr = (global ulong*)(matrix[hook(0, y * width + x)]);

  for (int i = 0; i < iteration; i++) {
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
    curr = (global ulong*)(*curr);
  }
  matrix[hook(0, y * width + x)] = curr;
}