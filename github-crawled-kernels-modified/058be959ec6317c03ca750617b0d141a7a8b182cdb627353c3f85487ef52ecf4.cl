//{"completion_code":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void start_clock(global uint32_t* completion_code);
void stop_clock(global uint32_t* completion_code);
kernel void Kstop_clock(global uint32_t* completion_code) {
  stop_clock(completion_code);
}