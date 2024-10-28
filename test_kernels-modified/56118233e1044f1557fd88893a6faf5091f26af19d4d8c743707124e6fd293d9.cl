//{"alignment_s":7,"avoid_s":10,"clf":15,"cli":16,"cohesion_s":8,"dt":0,"flockp":13,"goal_s":9,"gridp":14,"leaderfollowing_s":11,"pos_s":3,"pos_u":2,"separation_s":6,"sort_indices":12,"two_dimensional":1,"vel_s":5,"vel_u":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct GridParams {
  float4 grid_size;
  float4 grid_min;
  float4 grid_max;
  float4 bnd_min;
  float4 bnd_max;

  float4 grid_res;
  float4 grid_delta;

  int nb_cells;
};

kernel void euler_integration(float dt, int two_dimensional, global float4* pos_u, global float4* pos_s, global float4* vel_u, global float4* vel_s, global float4* separation_s, global float4* alignment_s, global float4* cohesion_s, global float4* goal_s, global float4* avoid_s, global float4* leaderfollowing_s, global int* sort_indices, constant struct FLOCKParameters* flockp, constant struct GridParams* gridp, global float4* clf, global int4* cli)

{
  unsigned int i = get_global_id(0);
  int num = flockp->num;

  if (i >= num)
    return;

  float4 pi = pos_s[hook(3, i)] * flockp->simulation_scale;

  float4 vi = vel_s[hook(5, i)];

  float4 vel = (float4)(0.f, 0.f, 0.f, 1.f);
  float4 vel_sep = (float4)(0.f, 0.f, 0.f, 1.f);
  float4 vel_aln = (float4)(0.f, 0.f, 0.f, 1.f);
  float4 vel_coh = (float4)(0.f, 0.f, 0.f, 1.f);
  float4 vel_goal = (float4)(0.f, 0.f, 0.f, 1.f);
  float4 vel_avoid = (float4)(0.f, 0.f, 0.f, 1.f);
  float4 vel_leadfoll = (float4)(0.f, 0.f, 0.f, 1.f);

  float4 separation = separation_s[hook(6, i)];
  float4 alignment = alignment_s[hook(7, i)];
  float4 cohesion = cohesion_s[hook(8, i)];
  float4 goal = goal_s[hook(9, i)];
  float4 avoid = avoid_s[hook(10, i)];
  float4 leaderfollowing = leaderfollowing_s[hook(11, i)];

  float w_sep = flockp->w_sep;
  float w_aln = flockp->w_align;
  float w_coh = flockp->w_coh;
  float w_goal = flockp->w_goal;
  float w_avoid = flockp->w_avoid;
  float w_leadfoll = flockp->w_leadfoll;

  float4 bndMax = gridp->bnd_max;
  float4 bndMin = gridp->bnd_min;

  vel_sep = separation * w_sep;

  vel_aln = alignment * w_aln;

  vel_coh = cohesion * w_coh;

  vel_goal = goal * w_goal;

  vel_avoid = avoid * w_avoid;

  vel_leadfoll = leaderfollowing * w_leadfoll;

  vel = vi + vel_sep + vel_aln + vel_coh + vel_goal + vel_avoid + vel_leadfoll;
  vel.w = 0.f;

  float velspeed = length(vel);
  float4 velnorm = normalize(vel);
  if (velspeed > flockp->max_speed) {
    vel = velnorm * flockp->max_speed;
  }

  float4 v = (float4)(-3 * pi.y, pi.x, 0.f, 0.f);
  v *= flockp->ang_vel;

  vi = v + vel;
  vi.w = 0.f;

  pi += dt * vi;

  if (pi.x >= bndMax.x) {
    pi.x -= bndMax.x;
  } else if (pi.x <= bndMin.x) {
    pi.x += bndMax.x;
  } else if (pi.y >= bndMax.y) {
    pi.y -= bndMax.y;
  } else if (pi.y <= bndMin.y) {
    pi.y += bndMax.y;
  } else if (pi.z >= bndMax.z) {
    pi.z -= bndMax.z;
  } else if (pi.z <= bndMin.z) {
    pi.z += bndMax.z;
  }

  if (two_dimensional)
    pi.z = 0.f;

  unsigned int originalIndex = sort_indices[hook(12, i)];
  vel_u[hook(4, originalIndex)] = vi;
  pos_u[hook(2, originalIndex)] = (float4)(pi.xyz / flockp->simulation_scale, 1.f);
}