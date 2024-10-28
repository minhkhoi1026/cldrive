//{"atom_tcoord":7,"individuals":1,"new_atom_tcoord":8,"poses":4,"rotation":6,"translation":5,"ttl_ligand_atoms":0,"ttl_poses":3,"ttl_torsions":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transform_ligand_root(global const long* ttl_ligand_atoms, global const double* individuals, global const long* ttl_torsions, global const long* ttl_poses, global double* poses) {
  long thread_id = get_global_id(0);

  long atom_id = (thread_id / ttl_poses[hook(3, 0)]) + 1;

  long pose_id = thread_id % ttl_poses[hook(3, 0)];

  double translation[3];
  for (long i = 0; i < 3; i++) {
    translation[hook(5, i)] = individuals[hook(1, (pose_id * (3 + 4 + ttl_torsions[0hook(2, 0))) + 0 + i)];
  }

  double rotation[4];
  for (long i = 0; i < 4; i++) {
    rotation[hook(6, i)] = individuals[hook(1, (pose_id * (3 + 4 + ttl_torsions[0hook(2, 0))) + 3 + i)];
  }

  double atom_tcoord[3];
  for (long i = 0; i < 3; i++) {
    atom_tcoord[hook(7, i)] = poses[hook(4, (atom_id * ttl_poses[0hook(3, 0) * 3) + (pose_id * 3) + i)];
  }

  double a = rotation[hook(6, 0)];
  double b = rotation[hook(6, 1)];
  double c = rotation[hook(6, 2)];
  double d = rotation[hook(6, 3)];

  double db = b + b;
  double dc = c + c;
  double dd = d + d;

  double a_db = a * db;
  double a_dc = a * dc;
  double a_dd = a * dd;

  double b_db_i = 1.0 - (b * db);

  double c_db = c * db;
  double c_dc = c * dc;
  double c_dc_i = 1.0 - c_dc;

  double d_db = d * db;
  double d_dc = d * dc;
  double d_dd = d * dd;

  double r_xx = c_dc_i - d_dd;
  double r_xy = c_db + a_dd;
  double r_xz = d_db - a_dc;
  double r_yx = c_db - a_dd;
  double r_yy = b_db_i - d_dd;
  double r_yz = d_dc + a_db;
  double r_zx = d_db + a_dc;
  double r_zy = d_dc - a_db;
  double r_zz = b_db_i - c_dc;

  double new_atom_tcoord[3];
  new_atom_tcoord[hook(8, 0)] = atom_tcoord[hook(7, 0)] * r_xx;
  new_atom_tcoord[hook(8, 0)] += atom_tcoord[hook(7, 1)] * r_xy;
  new_atom_tcoord[hook(8, 0)] += atom_tcoord[hook(7, 2)] * r_xz;

  new_atom_tcoord[hook(8, 1)] = atom_tcoord[hook(7, 0)] * r_yx;
  new_atom_tcoord[hook(8, 1)] += atom_tcoord[hook(7, 1)] * r_yy;
  new_atom_tcoord[hook(8, 1)] += atom_tcoord[hook(7, 2)] * r_yz;

  new_atom_tcoord[hook(8, 2)] = atom_tcoord[hook(7, 0)] * r_zx;
  new_atom_tcoord[hook(8, 2)] += atom_tcoord[hook(7, 1)] * r_zy;
  new_atom_tcoord[hook(8, 2)] += atom_tcoord[hook(7, 2)] * r_zz;

  for (long i = 0; i < 3; i++) {
    poses[hook(4, (atom_id * ttl_poses[0hook(3, 0) * 3) + (pose_id * 3) + i)] = new_atom_tcoord[hook(8, i)] + translation[hook(5, i)];
  }
}