//{"e_internal_totals":2,"e_totals":3,"elec_totals":0,"emap_totals":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_total_energy(global const double* elec_totals, global const double* emap_totals, global const double* e_internal_totals, global double* e_totals) {
  long pose_id = get_global_id(0);
  e_totals[hook(3, pose_id)] = elec_totals[hook(0, pose_id)] + emap_totals[hook(1, pose_id)] + e_internal_totals[hook(2, pose_id)];
}