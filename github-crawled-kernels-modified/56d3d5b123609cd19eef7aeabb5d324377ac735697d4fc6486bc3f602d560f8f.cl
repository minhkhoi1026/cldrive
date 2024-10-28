//{"d_pos":2,"height":1,"spherePos":3,"sphereRad":4,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 SatisfyConstraint(float4 pos1, float4 int2, float restDistance) {
  float4 toNeighbor = int2 - pos1;
  return (toNeighbor - normalize(toNeighbor) * restDistance);
}
kernel __attribute__((reqd_work_group_size(16, 16, 1))) kernel void CheckCollisions(unsigned int width, unsigned int height, global float4* d_pos, float4 spherePos, float sphereRad) {
  const uint2 gid = (uint2)(get_global_id(0), get_global_id(1));

  if (gid.x < width && gid.y < height) {
    float4 distance_vector = d_pos[hook(2, gid.x + gid.y * width)] - spherePos;

    if (length(distance_vector) < sphereRad) {
      d_pos[hook(2, gid.x + gid.y * width)] = spherePos + sphereRad * normalize(distance_vector);
    }
  }
}