//{"MVP":6,"destination":1,"indirectCommandData":4,"indirectCommandOffset":5,"numInstances":2,"offset":3,"source":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pass_along(global const float4* source, global float4* destination, int numInstances, int offset, global unsigned int* indirectCommandData, int indirectCommandOffset, float16 MVP) {
  int iGID = get_global_id(0);

  if (iGID >= numInstances) {
    return;
  }

  float4 translation = source[hook(0, offset + iGID)];

  float4 clipSpace;
  clipSpace.x = dot(MVP.lo.lo, translation);
  clipSpace.y = dot(MVP.lo.hi, translation);
  clipSpace.z = dot(MVP.hi.lo, translation);
  clipSpace.w = dot(MVP.hi.hi, translation);

  if (clipSpace.x < clipSpace.w && clipSpace.x > -clipSpace.w && clipSpace.y < clipSpace.w && clipSpace.y > -clipSpace.w && clipSpace.z < clipSpace.w && clipSpace.z > -clipSpace.w) {
    unsigned int index = atomic_inc(&indirectCommandData[hook(4, indirectCommandOffset)]);

    destination[hook(1, offset + index)] = translation;
  }
}