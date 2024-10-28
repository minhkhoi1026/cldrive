//{"gridA":0,"gridB":1,"lcl_acc":12,"mean":1,"n":5,"n_per_group":3,"n_per_work_item":4,"numElements":4,"r":2,"result":3,"weightB":2,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel __attribute__((reqd_work_group_size(256, 1, 1))) void sum_persist_kernel(global const float* x, global float* r, unsigned int n_per_group, unsigned int n_per_work_item, unsigned int n) {
  unsigned int lcl_id = get_local_id(0);
  unsigned int grp_id = get_group_id(0);

  float priv_acc = 0.f;
  local float lcl_acc[256];

  unsigned int grp_off = mul24(n_per_group, grp_id);
  unsigned int lcl_off = grp_off + lcl_id;

  float priv_val = 0.f;
  for (unsigned int i = 0; i < n_per_work_item; i++, lcl_off += 256) {
    bool in_range = (lcl_off < n);
    unsigned int lcl_off2 = (in_range) ? lcl_off : 0;
    priv_val = x[hook(0, lcl_off2)];
    priv_acc += (in_range) ? priv_val : 0.f;
  }

  lcl_acc[hook(12, lcl_id)] = priv_acc;
  barrier(0x01);

  unsigned int dist = 256;
  while (dist > 1) {
    dist >>= 1;
    if (lcl_id < dist) {
      priv_acc += lcl_acc[hook(12, lcl_id + dist)];
      lcl_acc[hook(12, lcl_id)] = priv_acc;
    }
    barrier(0x01);
  }

  if (lcl_id == 0) {
    r[hook(2, grp_id)] = priv_acc;
  }
}

kernel __attribute__((reqd_work_group_size(256, 1, 1))) void stddev_persist_kernel(global const float* x, float const mean, global float* r, unsigned int n_per_group, unsigned int n_per_work_item, unsigned int n) {
  unsigned int lcl_id = get_local_id(0);
  unsigned int grp_id = get_group_id(0);

  float priv_acc = 0.f;
  local float lcl_acc[256];

  unsigned int grp_off = mul24(n_per_group, grp_id);
  unsigned int lcl_off = grp_off + lcl_id;

  float priv_val = 0.f;
  for (unsigned int i = 0; i < n_per_work_item; i++, lcl_off += 256) {
    bool in_range = (lcl_off < n);
    unsigned int lcl_off2 = (in_range) ? lcl_off : 0;
    priv_val = x[hook(0, lcl_off2)] - mean;
    priv_val *= priv_val;
    priv_acc += (in_range) ? priv_val : 0.f;
  }

  lcl_acc[hook(12, lcl_id)] = priv_acc;
  barrier(0x01);

  unsigned int dist = 256;
  while (dist > 1) {
    dist >>= 1;
    if (lcl_id < dist) {
      priv_acc += lcl_acc[hook(12, lcl_id + dist)];
      lcl_acc[hook(12, lcl_id)] = priv_acc;
    }
    barrier(0x01);
  }

  if (lcl_id == 0) {
    r[hook(2, grp_id)] = priv_acc;
  }
}

kernel __attribute__((reqd_work_group_size(256, 1, 1))) void dot_persist_kernel(global const float* x, global const float* y, global float* r, unsigned int n_per_group, unsigned int n_per_work_item, unsigned int n) {
  unsigned int lcl_id = get_local_id(0);
  unsigned int grp_id = get_group_id(0);

  float priv_acc = 0.f;

  local float lcl_acc[256];

  unsigned int grp_off = mul24(n_per_group, grp_id);
  unsigned int lcl_off = grp_off + lcl_id;

  float priv_val = 0.f;
  for (unsigned int i = 0; i < n_per_work_item; i++, lcl_off += 256) {
    bool in_range = (lcl_off < n);
    unsigned int lcl_off2 = (in_range) ? lcl_off : 0;
    priv_val = x[hook(0, lcl_off2)] * y[hook(1, lcl_off2)];
    priv_acc += (in_range) ? priv_val : 0.f;
  }

  lcl_acc[hook(12, lcl_id)] = priv_acc;
  barrier(0x01);

  unsigned int dist = 256;
  while (dist > 1) {
    dist >>= 1;
    if (lcl_id < dist) {
      priv_acc += lcl_acc[hook(12, lcl_id + dist)];
      lcl_acc[hook(12, lcl_id)] = priv_acc;
    }
    barrier(0x01);
  }

  if (lcl_id == 0) {
    r[hook(2, grp_id)] = priv_acc;
  }
}

kernel void weightedSSD(global const float* gridA, global const float* gridB, const float weightB, global float* result, int const numElements) {
  int iGID = get_global_id(0);
  int totalThreads = get_global_size(0);
  int workPerThread = (numElements / totalThreads) + 1;

  int offset = 0;
  offset = iGID * workPerThread;

  result[hook(3, iGID)] = 0;
  for (int i = 0; i < workPerThread; ++i) {
    if (offset + i < numElements) {
      float diff = ((weightB * gridB[hook(1, offset + i)] - gridA[hook(0, offset + i)]));
      result[hook(3, iGID)] += diff * diff;
    }
  }
}