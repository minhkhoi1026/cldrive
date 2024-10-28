//{"atom_tcoord":17,"atom_type_map_lut":9,"atoms_properties":12,"desolvation_lut":8,"elecs":15,"electrostatic_lut":7,"emaps":16,"field_spacing":3,"hi_grid":2,"lo_grid":1,"maps":10,"num_points1":5,"poses":4,"protein_ignore_inter":13,"ttl_atom_properties":11,"ttl_maps":6,"ttl_poses":0,"ttl_protein_ignore_inter":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_inter_energy(global const long* ttl_poses, global const double* lo_grid, global const double* hi_grid, global const double* field_spacing, global const double* poses, global const long* num_points1, global const long* ttl_maps, global const long* electrostatic_lut, global const long* desolvation_lut, global const long* atom_type_map_lut, global const double* maps, global const long* ttl_atom_properties, global const double* atoms_properties, global const long* protein_ignore_inter, global const long* ttl_protein_ignore_inter, global double* elecs, global double* emaps) {
  long thread_id = get_global_id(0);

  long atom_id = (thread_id / ttl_poses[hook(0, 0)]) + 1;

  long pose_id = thread_id % ttl_poses[hook(0, 0)];

  for (long i = 0; i < ttl_protein_ignore_inter[hook(14, 0)]; i++) {
    if (atom_id == protein_ignore_inter[hook(13, i)]) {
      elecs[hook(15, (atom_id * ttl_poses[0hook(0, 0)) + pose_id)] = 0.0;
      emaps[hook(16, (atom_id * ttl_poses[0hook(0, 0)) + pose_id)] = 0.0;
      return;
    }
  }

  double atom_tcoord[3];
  for (long i = 0; i < 3; i++) {
    atom_tcoord[hook(17, i)] = poses[hook(4, (atom_id * ttl_poses[0hook(0, 0) * 3) + (pose_id * 3) + i)];
  }

  if (atom_tcoord[hook(17, 0)] <= lo_grid[hook(1, 0)] || atom_tcoord[hook(17, 1)] <= lo_grid[hook(1, 1)] || atom_tcoord[hook(17, 2)] <= lo_grid[hook(1, 2)] || atom_tcoord[hook(17, 0)] >= hi_grid[hook(2, 0)] || atom_tcoord[hook(17, 1)] >= hi_grid[hook(2, 1)] || atom_tcoord[hook(17, 2)] >= hi_grid[hook(2, 2)]) {
    elecs[hook(15, (atom_id * ttl_poses[0hook(0, 0)) + pose_id)] = (__builtin_inff());
    emaps[hook(16, (atom_id * ttl_poses[0hook(0, 0)) + pose_id)] = (__builtin_inff());
    return;
  }

  double u = (atom_tcoord[hook(17, 0)] - lo_grid[hook(1, 0)]) / field_spacing[hook(3, 0)];
  double v = (atom_tcoord[hook(17, 1)] - lo_grid[hook(1, 1)]) / field_spacing[hook(3, 0)];
  double w = (atom_tcoord[hook(17, 2)] - lo_grid[hook(1, 2)]) / field_spacing[hook(3, 0)];

  long u0 = (long)u;
  long v0 = (long)v;
  long w0 = (long)w;

  long u1 = u0 + 1;
  long v1 = v0 + 1;
  long w1 = w0 + 1;

  double p0u = u - (double)u0;
  double p0v = v - (double)v0;
  double p0w = w - (double)w0;

  double p1u = (double)u1 - u;
  double p1v = (double)v1 - v;
  double p1w = (double)w1 - w;

  double p000 = p0u * p0v * p0w;
  double p001 = p0u * p0v * p1w;
  double p010 = p0u * p1v * p0w;
  double p011 = p0u * p1v * p1w;
  double p100 = p1u * p0v * p0w;
  double p101 = p1u * p0v * p1w;
  double p110 = p1u * p1v * p0w;
  double p111 = p1u * p1v * p1w;

  long num_points1_2 = num_points1[hook(5, 2)] * num_points1[hook(5, 1)];
  long num_points1_1 = num_points1[hook(5, 2)];

  long atom_type_id = (long)atoms_properties[hook(12, (atom_id * ttl_atom_properties[0hook(11, 0)) + 0)];

  double e = 0.0;
  double d = 0.0;
  double m = 0.0;

  long w1v1u1_idx = ttl_maps[hook(6, 0)] * ((w1 * num_points1_2) + (v1 * num_points1_1) + u1);
  e += p000 * maps[hook(10, w1v1u1_idx + electrostatic_lut[0hook(7, 0))];
  d += p000 * maps[hook(10, w1v1u1_idx + desolvation_lut[0hook(8, 0))];
  m += p000 * maps[hook(10, w1v1u1_idx + atom_type_map_lut[ahook(9, atom_type_id))];
  long w1v1u0_idx = ttl_maps[hook(6, 0)] * ((w1 * num_points1_2) + (v1 * num_points1_1) + u0);
  e += p001 * maps[hook(10, w1v1u0_idx + electrostatic_lut[0hook(7, 0))];
  d += p001 * maps[hook(10, w1v1u0_idx + desolvation_lut[0hook(8, 0))];
  m += p001 * maps[hook(10, w1v1u0_idx + atom_type_map_lut[ahook(9, atom_type_id))];
  long w1v0u1_idx = ttl_maps[hook(6, 0)] * ((w1 * num_points1_2) + (v0 * num_points1_1) + u1);
  e += p010 * maps[hook(10, w1v0u1_idx + electrostatic_lut[0hook(7, 0))];
  d += p010 * maps[hook(10, w1v0u1_idx + desolvation_lut[0hook(8, 0))];
  m += p010 * maps[hook(10, w1v0u1_idx + atom_type_map_lut[ahook(9, atom_type_id))];
  long w1v0u0_idx = ttl_maps[hook(6, 0)] * ((w1 * num_points1_2) + (v0 * num_points1_1) + u0);
  e += p011 * maps[hook(10, w1v0u0_idx + electrostatic_lut[0hook(7, 0))];
  d += p011 * maps[hook(10, w1v0u0_idx + desolvation_lut[0hook(8, 0))];
  m += p011 * maps[hook(10, w1v0u0_idx + atom_type_map_lut[ahook(9, atom_type_id))];
  long w0v1u1_idx = ttl_maps[hook(6, 0)] * ((w0 * num_points1_2) + (v1 * num_points1_1) + u1);
  e += p100 * maps[hook(10, w0v1u1_idx + electrostatic_lut[0hook(7, 0))];
  d += p100 * maps[hook(10, w0v1u1_idx + desolvation_lut[0hook(8, 0))];
  m += p100 * maps[hook(10, w0v1u1_idx + atom_type_map_lut[ahook(9, atom_type_id))];
  long w0v1u0_idx = ttl_maps[hook(6, 0)] * ((w0 * num_points1_2) + (v1 * num_points1_1) + u0);
  e += p101 * maps[hook(10, w0v1u0_idx + electrostatic_lut[0hook(7, 0))];
  d += p101 * maps[hook(10, w0v1u0_idx + desolvation_lut[0hook(8, 0))];
  m += p101 * maps[hook(10, w0v1u0_idx + atom_type_map_lut[ahook(9, atom_type_id))];
  long w0v0u1_idx = ttl_maps[hook(6, 0)] * ((w0 * num_points1_2) + (v0 * num_points1_1) + u1);
  e += p110 * maps[hook(10, w0v0u1_idx + electrostatic_lut[0hook(7, 0))];
  d += p110 * maps[hook(10, w0v0u1_idx + desolvation_lut[0hook(8, 0))];
  m += p110 * maps[hook(10, w0v0u1_idx + atom_type_map_lut[ahook(9, atom_type_id))];
  long w0v0u0_idx = ttl_maps[hook(6, 0)] * ((w0 * num_points1_2) + (v0 * num_points1_1) + u0);
  e += p111 * maps[hook(10, w0v0u0_idx + electrostatic_lut[0hook(7, 0))];
  d += p111 * maps[hook(10, w0v0u0_idx + desolvation_lut[0hook(8, 0))];
  m += p111 * maps[hook(10, w0v0u0_idx + atom_type_map_lut[ahook(9, atom_type_id))];

  double atom_charge = atoms_properties[hook(12, (atom_id * ttl_atom_properties[0hook(11, 0)) + 1)];
  double abs_atom_charge = fabs(atom_charge);

  elecs[hook(15, (atom_id * ttl_poses[0hook(0, 0)) + pose_id)] = e * atom_charge;
  emaps[hook(16, (atom_id * ttl_poses[0hook(0, 0)) + pose_id)] = m + (d * abs_atom_charge);
}