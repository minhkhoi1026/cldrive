//{"counter":2,"input":0,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void globalAtomics(volatile global unsigned int* input, unsigned int value, global unsigned int* counter) {
  size_t globalId = get_global_id(0);

  if (value == input[hook(0, globalId)])
    atomic_inc(&counter[hook(2, 0)]);
}