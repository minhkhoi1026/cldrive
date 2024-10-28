//{"e_internal_totals":3,"e_internals":2,"ttl_non_bond_list":1,"ttl_poses":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_total_intra_energy(global const long* ttl_poses, global const long* ttl_non_bond_list, global const double* e_internals, global double* e_internal_totals) {
  long pose_id = get_global_id(0);

  double total_e_internal = 0.0;
  for (long i = 0; i < ttl_non_bond_list[hook(1, 0)]; i++) {
    total_e_internal += e_internals[hook(2, (pose_id * ttl_non_bond_list[0hook(1, 0)) + i)];
  }
  e_internal_totals[hook(3, pose_id)] = total_e_internal;
}