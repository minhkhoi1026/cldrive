//{"PARTICLE_COUNT":6,"particleIndex":0,"particleIndexBack":1,"position":2,"sortedPosition":4,"sortedVelocity":5,"velocity":3}
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
kernel void sortPostPass(global uint2* particleIndex, global unsigned int* particleIndexBack, global float4* position, global float4* velocity, global float4* sortedPosition, global float4* sortedVelocity, unsigned int PARTICLE_COUNT) {
  int id = get_global_id(0);
  if (id >= PARTICLE_COUNT)
    return;
  uint2 spi = particleIndex[hook(0, id)];
  int serialId = spi.y;
  int cellId = spi.x;
  float4 position_ = position[hook(2, serialId)];
  position_.w = (float)cellId;
  float4 velocity_ = velocity[hook(3, serialId)];
  sortedVelocity[hook(5, id)] = velocity_;
  sortedPosition[hook(4, id)] = position_;
  particleIndexBack[hook(1, serialId)] = id;
}