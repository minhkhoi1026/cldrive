//{"mem0":1,"mem16":6,"mem2":2,"mem3":3,"mem4":4,"mem8":5,"results":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_memory_alignment_private(global unsigned int* results) {
 private
  char mem0[3];
 private
  char2 mem2[3];
 private
  char3 mem3[3];
 private
  char4 mem4[3];
 private
  char8 mem8[3];
 private
  char16 mem16[3];
  results[hook(0, 0)] = (unsigned int)&mem0[hook(1, 0)];
  results[hook(0, 1)] = (unsigned int)&mem2[hook(2, 0)];
  results[hook(0, 2)] = (unsigned int)&mem3[hook(3, 0)];
  results[hook(0, 3)] = (unsigned int)&mem4[hook(4, 0)];
  results[hook(0, 4)] = (unsigned int)&mem8[hook(5, 0)];
  results[hook(0, 5)] = (unsigned int)&mem16[hook(6, 0)];
}