//{"begin":1,"num_elements":2,"output_buffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void util_create_sequence(global unsigned long* output_buffer, unsigned long begin, unsigned long num_elements) {
  size_t tid = get_global_id(0);

  if (tid < num_elements) {
    output_buffer[hook(0, tid)] = begin + tid;
  }
}