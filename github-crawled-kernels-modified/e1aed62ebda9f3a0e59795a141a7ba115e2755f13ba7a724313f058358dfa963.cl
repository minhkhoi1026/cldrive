//{"atom_tcoord1":15,"atom_tcoord2":16,"bond_properties":8,"calc_inter_elec_e":9,"e_internals":14,"et_inv_r_epsilon":11,"et_solvation":12,"et_vdw_hb":13,"hi_grid":3,"include_1_4_interactions":10,"lo_grid":2,"non_bond_list":6,"poses":1,"r_tcoord2":17,"ttl_atom_types":7,"ttl_non_bond_list":4,"ttl_non_bond_properties":5,"ttl_poses":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_intra_energy(global const long* ttl_poses, global const double* poses, global const double* lo_grid, global const double* hi_grid, global const long* ttl_non_bond_list, global const long* ttl_non_bond_properties, global const double* non_bond_list, global const long* ttl_atom_types, global const double* bond_properties, global const long* calc_inter_elec_e, global const long* include_1_4_interactions, global const double* et_inv_r_epsilon, global const double* et_solvation, global const double* et_vdw_hb, global double* e_internals) {
  long thread_id = get_global_id(0);

  long pose_id = (thread_id / ttl_non_bond_list[hook(4, 0)]);

  long nb_id = thread_id % ttl_non_bond_list[hook(4, 0)];

  long non_bond_start_idx = nb_id * ttl_non_bond_properties[hook(5, 0)];
  long atom_id1 = non_bond_list[hook(6, non_bond_start_idx + 0)];
  long atom_type1 = non_bond_list[hook(6, non_bond_start_idx + 1)];
  long atom_id2 = non_bond_list[hook(6, non_bond_start_idx + 2)];
  long atom_type2 = non_bond_list[hook(6, non_bond_start_idx + 3)];
  long non_bond_type = non_bond_list[hook(6, non_bond_start_idx + 4)];
  double desolv = non_bond_list[hook(6, non_bond_start_idx + 5)];
  double q1q2 = non_bond_list[hook(6, non_bond_start_idx + 6)];

  double3 atom_tcoord1;
  for (long i = 0; i < 3; i++) {
    atom_tcoord1[hook(15, i)] = poses[hook(1, (atom_id1 * ttl_poses[0hook(0, 0) * 3) + (pose_id * 3) + i)];
  }
  double3 atom_tcoord2;
  for (long i = 0; i < 3; i++) {
    atom_tcoord2[hook(16, i)] = poses[hook(1, (atom_id2 * ttl_poses[0hook(0, 0) * 3) + (pose_id * 3) + i)];
  }

  if (atom_tcoord1[hook(15, 0)] <= lo_grid[hook(2, 0)] || atom_tcoord1[hook(15, 1)] <= lo_grid[hook(2, 1)] || atom_tcoord1[hook(15, 2)] <= lo_grid[hook(2, 2)] || atom_tcoord1[hook(15, 0)] >= hi_grid[hook(3, 0)] || atom_tcoord1[hook(15, 1)] >= hi_grid[hook(3, 1)] || atom_tcoord1[hook(15, 2)] >= hi_grid[hook(3, 2)] || atom_tcoord2[hook(16, 0)] <= lo_grid[hook(2, 0)] || atom_tcoord2[hook(16, 1)] <= lo_grid[hook(2, 1)] || atom_tcoord2[hook(16, 2)] <= lo_grid[hook(2, 2)] || atom_tcoord2[hook(16, 0)] >= hi_grid[hook(3, 0)] || atom_tcoord2[hook(16, 1)] >= hi_grid[hook(3, 1)] || atom_tcoord2[hook(16, 2)] >= hi_grid[hook(3, 2)]) {
    e_internals[hook(14, (pose_id * ttl_non_bond_list[0hook(4, 0)) + nb_id)] = (__builtin_inff());
    return;
  }

  double3 r_tcoord2 = atom_tcoord1 - atom_tcoord2;
  double r2 = (r_tcoord2[hook(17, 0)] * r_tcoord2[hook(17, 0)]) + (r_tcoord2[hook(17, 1)] * r_tcoord2[hook(17, 1)]) + (r_tcoord2[hook(17, 2)] * r_tcoord2[hook(17, 2)]);
  r2 = max(bond_properties[hook(8, 2)], r2);
  long index = (long)(r2 * bond_properties[hook(8, 3)]);

  long i_ns_intl = min(index, (long)bond_properties[hook(8, 0)]);
  long i_ns_el = min(index, (long)bond_properties[hook(8, 1)]);

  double e_internal = 0.0;
  if (calc_inter_elec_e[hook(9, 0)] == 1) {
    e_internal += q1q2 * et_inv_r_epsilon[hook(11, i_ns_el)];
  }
  if (r2 < bond_properties[hook(8, 4)]) {
    double e_desolv = desolv * et_solvation[hook(12, i_ns_intl)];

    long a1 = atom_type1;
    long a2 = atom_type2;
    if (atom_type1 > atom_type2) {
      a1 = atom_type2;
      a2 = atom_type1;
    }
    long n = ttl_atom_types[hook(7, 0)];
    long col = (n * a1) + a2 - ((a1 * (a1 + 1)) / 2);
    long ns_intl = (long)bond_properties[hook(8, 0)] + 1;
    if (include_1_4_interactions[hook(10, 0)] == 1 && non_bond_type == 4) {
      e_internal += bond_properties[hook(8, 5)] + (et_vdw_hb[hook(13, (col * ns_intl) + i_ns_intl)] + e_desolv);
    } else {
      e_internal += et_vdw_hb[hook(13, (col * ns_intl) + i_ns_intl)] + e_desolv;
    }
  }
  e_internals[hook(14, (pose_id * ttl_non_bond_list[0hook(4, 0)) + nb_id)] = e_internal;
}