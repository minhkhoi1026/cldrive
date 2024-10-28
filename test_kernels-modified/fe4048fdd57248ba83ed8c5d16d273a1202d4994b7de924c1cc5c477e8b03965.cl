//{"upd_offset":1,"v_bodies":0,"v_prev_bodies":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void save_prev_bodies(const global float4* v_bodies, int upd_offset, global float4* v_prev_bodies) {
  int idx = get_global_id(0) + upd_offset;
  v_prev_bodies[hook(2, idx)] = v_bodies[hook(0, idx)];
}