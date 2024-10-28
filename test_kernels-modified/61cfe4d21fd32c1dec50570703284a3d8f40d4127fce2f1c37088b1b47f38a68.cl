//{"in":0,"out":1,"temp":2,"tmp":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void write_local(global int* in, local int* tmp, unsigned int id) {
  tmp[hook(3, id)] = in[hook(0, id)];
}

void read_local(global int* out, local int* tmp, unsigned int id) {
  out[hook(1, id)] = tmp[hook(3, id)];
}

kernel void local_memory(global int* in, global int* out, local int* temp) {
  unsigned int gid = get_global_id(0);
  write_local(in, temp, gid);
  barrier(0x01 | 0x02);
  read_local(out, temp, gid);
}