//{"anchor_tcoord":9,"atom_tcoord":13,"branches_rot_anchor_buf":3,"branches_rot_link_buf":4,"branches_rot_seq_buf":6,"branches_rot_size_buf":5,"individuals":1,"link_tcoord":10,"longest_branch":2,"new_atom_tcoord":14,"poses":8,"rotation":12,"tor_axis":11,"ttl_poses":7,"ttl_torsions":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rotate_branches(global const long* ttl_torsions, global const double* individuals, global const long* longest_branch, global const long* branches_rot_anchor_buf, global const long* branches_rot_link_buf, global const long* branches_rot_size_buf, global const long* branches_rot_seq_buf, global const long* ttl_poses, global double* poses) {
  long pose_id = get_global_id(0);

  for (long br_i = 0; br_i < ttl_torsions[hook(0, 0)]; br_i++) {
    for (long br_j = 0; br_j < longest_branch[hook(2, 0)]; br_j++) {
      long atom_tcoord_id = branches_rot_seq_buf[hook(6, (br_i * longest_branch[0hook(2, 0)) + br_j)];
      if (atom_tcoord_id == 0)
        continue;

      double tor_angle = individuals[hook(1, (pose_id * (3 + 4 + ttl_torsions[0hook(0, 0))) + 7 + br_i)];

      double anchor_tcoord[3];
      double link_tcoord[3];
      double3 tor_axis;
      long anchor_tcoord_id = branches_rot_anchor_buf[hook(3, br_i)];
      long link_tcoord_id = branches_rot_link_buf[hook(4, br_i)];
      for (long i = 0; i < 3; i++) {
        anchor_tcoord[hook(9, i)] = poses[hook(8, (anchor_tcoord_id * ttl_poses[0hook(7, 0) * 3) + (pose_id * 3) + i)];
        link_tcoord[hook(10, i)] = poses[hook(8, (link_tcoord_id * ttl_poses[0hook(7, 0) * 3) + (pose_id * 3) + i)];
        tor_axis[hook(11, i)] = anchor_tcoord[hook(9, i)] - link_tcoord[hook(10, i)];
      }

      double rotation[4];
      double half_tor_angle = tor_angle / 2;
      rotation[hook(12, 0)] = cos(half_tor_angle);
      tor_axis = normalize(tor_axis);
      double s = sin(half_tor_angle);
      rotation[hook(12, 1)] = tor_axis[hook(11, 0)] * s;
      rotation[hook(12, 2)] = tor_axis[hook(11, 1)] * s;
      rotation[hook(12, 3)] = tor_axis[hook(11, 2)] * s;

      double atom_tcoord[3];
      for (long i = 0; i < 3; i++) {
        atom_tcoord[hook(13, i)] = poses[hook(8, (atom_tcoord_id * ttl_poses[0hook(7, 0) * 3) + (pose_id * 3) + i)] - link_tcoord[hook(10, i)];
      }
      double a = rotation[hook(12, 0)];
      double b = rotation[hook(12, 1)];
      double c = rotation[hook(12, 2)];
      double d = rotation[hook(12, 3)];

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
      new_atom_tcoord[hook(14, 0)] = atom_tcoord[hook(13, 0)] * r_xx;
      new_atom_tcoord[hook(14, 0)] += atom_tcoord[hook(13, 1)] * r_xy;
      new_atom_tcoord[hook(14, 0)] += atom_tcoord[hook(13, 2)] * r_xz;

      new_atom_tcoord[hook(14, 1)] = atom_tcoord[hook(13, 0)] * r_yx;
      new_atom_tcoord[hook(14, 1)] += atom_tcoord[hook(13, 1)] * r_yy;
      new_atom_tcoord[hook(14, 1)] += atom_tcoord[hook(13, 2)] * r_yz;

      new_atom_tcoord[hook(14, 2)] = atom_tcoord[hook(13, 0)] * r_zx;
      new_atom_tcoord[hook(14, 2)] += atom_tcoord[hook(13, 1)] * r_zy;
      new_atom_tcoord[hook(14, 2)] += atom_tcoord[hook(13, 2)] * r_zz;

      for (long i = 0; i < 3; i++) {
        poses[hook(8, (atom_tcoord_id * ttl_poses[0hook(7, 0) * 3) + (pose_id * 3) + i)] = new_atom_tcoord[hook(14, i)] + link_tcoord[hook(10, i)];
      }
    }
    barrier(0x01 | 0x02);
  }
}