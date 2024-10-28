//{"depth":0,"metaball_positions":4,"normals":2,"num_metaballs":5,"positions":1,"screen_size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float smoothstepmap(float val) {
  return val * val * (3 - 2 * val);
}

constant int METABALL_SIZE = 5;

const sampler_t smp = 1 | 4 | 0x10;

const sampler_t smpcom = 0 | 4 | 0x10;

kernel void generate_normals(read_only image2d_t depth, read_only image2d_t positions, write_only image2d_t normals, int2 screen_size, constant float4* metaball_positions, int num_metaballs) {
  int id = get_global_id(0);
  int2 pixel = (int2)(id % screen_size.x, id / screen_size.x);

  float pixdepth = read_imagef(depth, smpcom, pixel).x;

  if (pixdepth == 1.0) {
    write_imagef(normals, pixel, (float4)(0, 0, 0, 0));
    return;
  }

  float3 pos = read_imagef(positions, smpcom, pixel).xyz;

  float3 normal = (float3)(0, 0, 0);
  for (int i = 0; i < num_metaballs; i++) {
    float dist = distance(pos, metaball_positions[hook(4, i)].xyz) / METABALL_SIZE;
    float amount = 1 - smoothstepmap(clamp(dist, 0.0f, 1.0f));

    normal += (pos - metaball_positions[hook(4, i)].xyz) * amount;
  }
  normal = normalize(normal);

  write_imagef(normals, pixel, (float4)(normal, 1));
}