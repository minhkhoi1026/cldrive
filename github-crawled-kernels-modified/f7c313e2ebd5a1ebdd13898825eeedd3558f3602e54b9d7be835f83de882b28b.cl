//{"BUFFER_SIDE_LENGTH":0,"array":4,"baseGroupStatesOut":2,"booleans":5,"isInfinitiesScratch":3,"potentials":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float4 ZEROS = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
constant float4 ONES = (float4)(1.0f, 1.0f, 1.0f, 1.0f);
constant float4 INFINITIES = (float4)((__builtin_inff()), (__builtin_inff()), (__builtin_inff()), (__builtin_inff()));
constant unsigned int ID_GROUP_MASK = 0x3;
int2 positionFromIndex(int i, int width) {
  int2 p;

  p.x = i % width;
  p.y = i / width;

  return p;
}

int indexFromPosition(int2 p, int width) {
  int i;

  i = p.x + p.y * width;

  return i;
}

bool isInside(int2 p, int size) {
  return (p.x >= 0) && (p.x < size) && (p.y >= 0) && (p.y < size);
}
bool isInsideFloat(float2 p, int size) {
  return (p.x >= 0) && (p.x <= size) && (p.y >= 0) && (p.y <= size);
}

float4 getValueOrInfinity(int2 p, int size, global float4* array) {
  float4 v;

  int4 isInsideArea = isInside(p, size);

  float4 arrayValue = array[hook(4, clamp(indexFromPosition(p, size), 0, size * size - 1))];

  v = select(INFINITIES, arrayValue, isInsideArea);

  return v;
}

float4 getValueOrZero(int2 p, int size, global float4* array) {
  float4 v;

  int4 isInsideArea = isInside(p, size);

  float4 arrayValue = array[hook(4, clamp(indexFromPosition(p, size), 0, size * size - 1))];

  v = select(ZEROS, arrayValue, isInsideArea);

  return v;
}

float4 getValueWithBilinearFilteringOrZero(float2 position, int size, read_only image2d_t image) {
  float4 v;

  int4 isInsideArea = isInsideFloat(position, size);

  float4 imageValue = read_imagef(image, 0 | 2 | 0x20, position);

  v = select(ZEROS, imageValue, isInsideArea);

  return v;
}

int getIntOrZeroRestrict(int2 p, size_t size, global int const* restrict array) {
  int isInsideArea = isInside(p, size);

  if (isInsideArea) {
    return array[hook(4, indexFromPosition(p, size))];
  } else {
    return 0;
  }
}

float4 getNESWNeighborsXComponentOrInfinity(int2 position, int bufferSideLength, global float4* buffer) {
  int2 positionNorth = position;
  int2 positionEast = position;
  int2 positionSouth = position;
  int2 positionWest = position;

  positionNorth.y += 1;
  positionEast.x += 1;
  positionSouth.y -= 1;
  positionWest.x -= 1;

  float4 neighbors;

  neighbors.x = getValueOrInfinity(positionNorth, bufferSideLength, buffer).x;
  neighbors.y = getValueOrInfinity(positionEast, bufferSideLength, buffer).x;
  neighbors.z = getValueOrInfinity(positionSouth, bufferSideLength, buffer).x;
  neighbors.w = getValueOrInfinity(positionWest, bufferSideLength, buffer).x;

  return neighbors;
}

float4 getNESWNeighborsYComponentOrInfinity(int2 position, int bufferSideLength, global float4* buffer) {
  int2 positionNorth = position;
  int2 positionEast = position;
  int2 positionSouth = position;
  int2 positionWest = position;

  positionNorth.y += 1;
  positionEast.x += 1;
  positionSouth.y -= 1;
  positionWest.x -= 1;

  float4 neighbors;

  neighbors.x = getValueOrInfinity(positionNorth, bufferSideLength, buffer).y;
  neighbors.y = getValueOrInfinity(positionEast, bufferSideLength, buffer).y;
  neighbors.z = getValueOrInfinity(positionSouth, bufferSideLength, buffer).y;
  neighbors.w = getValueOrInfinity(positionWest, bufferSideLength, buffer).y;

  return neighbors;
}

size_t getIGlobalGroupBase(const unsigned int workGroupSideLength) {
  return get_group_id(0) * workGroupSideLength * workGroupSideLength;
}

size_t getLocalX(const unsigned int workGroupSideLength) {
  return get_local_id(0) % workGroupSideLength;
}

size_t getLocalY(const unsigned int workGroupSideLength) {
  return get_local_id(0) / workGroupSideLength;
}

size_t getGlobalBaseX(const unsigned int workGroupSideLength, const unsigned int bufferSideLength) {
  return (get_group_id(0) * workGroupSideLength) % bufferSideLength;
}

size_t getGlobalBaseY(const unsigned int workGroupSideLength, const unsigned int bufferSideLength) {
  return get_group_id(0) * workGroupSideLength / bufferSideLength * workGroupSideLength;
}

int reduceAnd(local int* booleans, size_t localId, size_t localSize) {
  for (int offset = localSize / 2; offset > 0; offset >>= 1) {
    if (localId < offset) {
      int isTrueA = booleans[hook(5, localId)];
      int isTrueB = booleans[hook(5, localId + offset)];

      booleans[hook(5, localId)] = isTrueA && isTrueB;
    }

    barrier(0x01);
  }

  return booleans[hook(5, 0)];
}

int reduceOr(local int* booleans, size_t localId, size_t localSize) {
  for (int offset = localSize / 2; offset > 0; offset >>= 1) {
    if (localId < offset) {
      int isTrueA = booleans[hook(5, localId)];
      int isTrueB = booleans[hook(5, localId + offset)];

      booleans[hook(5, localId)] = isTrueA || isTrueB;
    }

    barrier(0x01);
  }

  return booleans[hook(5, 0)];
}

float getPotentialInfinity(unsigned int group, int2 gridPosition, const unsigned int BUFFER_SIDE_LENGTH, global float4* potentials) {
  float potential;

  switch (group) {
    case 0: {
      potential = getValueOrInfinity(gridPosition, BUFFER_SIDE_LENGTH, potentials).x;
      break;
    }

    case 1: {
      potential = getValueOrInfinity(gridPosition, BUFFER_SIDE_LENGTH, potentials).y;
      break;
    }

    case 2: {
      potential = getValueOrInfinity(gridPosition, BUFFER_SIDE_LENGTH, potentials).z;
      break;
    }

    case 3: {
      potential = getValueOrInfinity(gridPosition, BUFFER_SIDE_LENGTH, potentials).w;
      break;
    }
  }

  return potential;
}

constant float4 EPSILONS = (float4)(0.001f, 0.001f, 0.001f, 0.001f);
kernel void initialize(const unsigned int BUFFER_SIDE_LENGTH, global float4* potentials, global int* baseGroupStatesOut, local int* isInfinitiesScratch) {
  size_t globalId = get_global_id(0) + get_global_id(1) * get_global_size(0);
  size_t localId = get_local_id(0) + get_local_id(1) * get_local_size(0);
  size_t groupId = get_group_id(0) + get_group_id(1) * get_num_groups(0);

  int4 isZeros = potentials[hook(1, globalId)] == ZEROS;

  int isInfinity = !any(isZeros);

  isInfinitiesScratch[hook(3, localId)] = isInfinity;

  barrier(0x01);

  int isGroupInfinity = reduceAnd(isInfinitiesScratch, localId, get_local_size(0) * get_local_size(1));

  if (localId == 0) {
    if (isGroupInfinity) {
      baseGroupStatesOut[hook(2, groupId)] = 0;
    } else {
      baseGroupStatesOut[hook(2, groupId)] = 2;
    }
  }
}