//{"elec_totals":4,"elecs":2,"emap_totals":5,"emaps":3,"ttl_atoms":0,"ttl_poses":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_total_inter_energy(global const long* ttl_atoms, global const long* ttl_poses, global const double* elecs, global const double* emaps, global double* elec_totals, global double* emap_totals) {
  long thread_id = get_global_id(0);

  long e_id = (thread_id / ttl_poses[hook(1, 0)]);

  long pose_id = thread_id % ttl_poses[hook(1, 0)];

  if (e_id == 0) {
    double elec_total = 0.0;
    for (long i = 1; i < ttl_atoms[hook(0, 0)] + 1; i++) {
      elec_total += elecs[hook(2, (i * ttl_poses[0hook(1, 0)) + pose_id)];
    }
    elec_totals[hook(4, pose_id)] = elec_total;
  }

  if (e_id == 1) {
    double emap_total = 0.0;
    for (long i = 1; i < ttl_atoms[hook(0, 0)] + 1; i++) {
      emap_total += emaps[hook(3, (i * ttl_poses[0hook(1, 0)) + pose_id)];
    }
    emap_totals[hook(5, pose_id)] = emap_total;
  }
}