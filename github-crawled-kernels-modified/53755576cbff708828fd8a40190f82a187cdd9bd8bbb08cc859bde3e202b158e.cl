//{"BUFFER_SIDE_LENGTH":0,"array":4,"booleans":5,"gradients01":2,"gradients23":3,"potentials":1}
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

kernel void gradient(const unsigned int BUFFER_SIDE_LENGTH, global float4* potentials, write_only image2d_t gradients01, write_only image2d_t gradients23) {
  size_t i = get_global_id(0);

  int2 position = positionFromIndex(i, BUFFER_SIDE_LENGTH);

  int2 positionNorth = position;
  int2 positionEast = position;
  int2 positionSouth = position;
  int2 positionWest = position;

  positionNorth.y += 1;
  positionEast.x += 1;
  positionSouth.y -= 1;
  positionWest.x -= 1;

  float4 potentialN = getValueOrInfinity(positionNorth, BUFFER_SIDE_LENGTH, potentials);
  float4 potentialS = getValueOrInfinity(positionSouth, BUFFER_SIDE_LENGTH, potentials);
  float4 potentialW = getValueOrInfinity(positionWest, BUFFER_SIDE_LENGTH, potentials);
  float4 potential = getValueOrInfinity(position, BUFFER_SIDE_LENGTH, potentials);
  float4 potentialE = getValueOrInfinity(positionEast, BUFFER_SIDE_LENGTH, potentials);

  float4 positiveDirection01 = (float4)(potentialE.x, potentialN.x, potentialE.y, potentialN.y);
  float4 negativeDirection01 = (float4)(potentialW.x, potentialS.x, potentialW.y, potentialS.y);
  float4 center01 = (float4)(potential.x, potential.x, potential.y, potential.y);

  int4 isNegativeDirectionSmaller01 = negativeDirection01 <= positiveDirection01;

  float4 forwardDifferenceQuotient01 = positiveDirection01 - center01;
  float4 backwardDifferenceQuotient01 = center01 - negativeDirection01;

  float4 gradient01 = select(forwardDifferenceQuotient01, backwardDifferenceQuotient01, isNegativeDirectionSmaller01);

  int4 isInfinityPositiveDirection01 = isinf((float4)(potentialE.x, potentialN.x, potentialE.y, potentialN.y));
  int4 isInfinityNegativeDirection01 = isinf((float4)(potentialW.x, potentialS.x, potentialW.y, potentialS.y));

  int4 isInfinity01 = isInfinityPositiveDirection01 && isInfinityNegativeDirection01;

  gradient01 = select(gradient01, ZEROS, isInfinity01);

  float4 positiveDirection23 = (float4)(potentialE.z, potentialN.z, potentialE.w, potentialN.w);
  float4 negativeDirection23 = (float4)(potentialW.z, potentialS.z, potentialW.w, potentialS.w);
  float4 center23 = (float4)(potential.z, potential.z, potential.w, potential.w);

  int4 isNegativeDirectionSmaller23 = negativeDirection23 <= positiveDirection23;

  float4 forwardDifferenceQuotient23 = positiveDirection23 - center23;
  float4 backwardDifferenceQuotient23 = center23 - negativeDirection23;

  float4 gradient23 = select(forwardDifferenceQuotient23, backwardDifferenceQuotient23, isNegativeDirectionSmaller23);

  int4 isInfinityPositiveDirection23 = isinf((float4)(potentialE.z, potentialN.z, potentialE.w, potentialN.w));
  int4 isInfinityNegativeDirection23 = isinf((float4)(potentialW.z, potentialS.z, potentialW.w, potentialS.w));

  int4 isInfinity23 = isInfinityPositiveDirection23 && isInfinityNegativeDirection23;

  gradient23 = select(gradient23, ZEROS, isInfinity23);

  write_imagef(gradients01, position, gradient01);
  write_imagef(gradients23, position, gradient23);
}