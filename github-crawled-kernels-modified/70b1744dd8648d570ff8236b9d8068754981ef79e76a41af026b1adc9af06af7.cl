//{"pipe":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_pipe_query_functions(write_only pipe int out_pipe, global int* num_packets, global int* max_packets) {
  *max_packets = get_pipe_max_packets(out_pipe);
  *num_packets = get_pipe_num_packets(out_pipe);
}