//{"additive":5,"input":0,"output":1,"pat_h":4,"pat_w":3,"pattern":2,"rotated":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gegl_video_degradation(global const float4* input, global float4* output, global const int* pattern, const int pat_w, const int pat_h, const int additive, const int rotated) {
  const size_t gidx = get_global_id(0);
  const size_t gidy = get_global_id(1);
  const size_t gid = gidx - get_global_offset(0) + (gidy - get_global_offset(1)) * get_global_size(0);
  const float4 indata = input[hook(0, gid)];

  const int sel_b = pattern[hook(2, rotated ? pat_w * (gidx % pat_h) + gidy % pat_w : pat_w * (gidy % pat_h) + gidx % pat_w)];

  float4 value = select(0.f, indata, sel_b == (int4)(0, 1, 2, 3));

  if (additive)
    value = fmin(value + indata, 1.0f);

  value.w = indata.w;

  output[hook(1, gid)] = value;
}