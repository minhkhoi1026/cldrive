//{"results":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant char mem0[3] = {0};
constant char2 mem2[3] = {(char2)(0)};
constant char3 mem3[3] = {(char3)(0)};
constant char4 mem4[3] = {(char4)(0)};
constant char8 mem8[3] = {(char8)(0)};
constant char16 mem16[3] = {(char16)(0)};

kernel void kernel_memory_alignment_constant(global unsigned int* results) {
  results[hook(0, 0)] = (unsigned int)&mem0;
  results[hook(0, 1)] = (unsigned int)&mem2;
  results[hook(0, 2)] = (unsigned int)&mem3;
  results[hook(0, 3)] = (unsigned int)&mem4;
  results[hook(0, 4)] = (unsigned int)&mem8;
  results[hook(0, 5)] = (unsigned int)&mem16;
}