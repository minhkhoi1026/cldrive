//{"PARTICLE_COUNT":9,"gridCellsX":1,"gridCellsY":2,"gridCellsZ":3,"hashGridCellSizeInv":4,"particleIndex":8,"position":0,"xmin":5,"ymin":6,"zmin":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int cellId(int4 cellFactors_, unsigned int gridCellsX, unsigned int gridCellsY, unsigned int gridCellsZ) {
  int cellId_ = cellFactors_.x + cellFactors_.y * gridCellsX + cellFactors_.z * gridCellsX * gridCellsY;
  return cellId_;
}

int4 cellFactors(float4 position, float xmin, float ymin, float zmin, float hashGridCellSizeInv) {
  int4 result;
  result.x = (int)(position.x * hashGridCellSizeInv);
  result.y = (int)(position.y * hashGridCellSizeInv);
  result.z = (int)(position.z * hashGridCellSizeInv);
  return result;
}
kernel void hashParticles(global float4* position, unsigned int gridCellsX, unsigned int gridCellsY, unsigned int gridCellsZ, float hashGridCellSizeInv, float xmin, float ymin, float zmin, global uint2* particleIndex, unsigned int PARTICLE_COUNT) {
  int id = get_global_id(0);
  if (id >= PARTICLE_COUNT)
    return;
  float4 _position = position[hook(0, id)];
  int4 cellFactors_ = cellFactors(_position, xmin, ymin, zmin, hashGridCellSizeInv);
  int cellId_ = cellId(cellFactors_, gridCellsX, gridCellsY, gridCellsZ) & 0xffffff;
  uint2 result;
  result.x = cellId_;
  result.y = id;
  particleIndex[hook(8, id)] = result;
}