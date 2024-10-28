//{"BUFFER_SIDE_LENGTH":0,"MAXIMUM_DENSITY":4,"MAXIMUM_SPEED":5,"MINIMUM_DENSITY":3,"array":6,"booleans":7,"densitiesDiscomfortsVelocities":1,"speedNESWs":2}
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

  float4 arrayValue = array[hook(6, clamp(indexFromPosition(p, size), 0, size * size - 1))];

  v = select(INFINITIES, arrayValue, isInsideArea);

  return v;
}

float4 getValueOrZero(int2 p, int size, global float4* array) {
  float4 v;

  int4 isInsideArea = isInside(p, size);

  float4 arrayValue = array[hook(6, clamp(indexFromPosition(p, size), 0, size * size - 1))];

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
    return array[hook(6, indexFromPosition(p, size))];
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
      int isTrueA = booleans[hook(7, localId)];
      int isTrueB = booleans[hook(7, localId + offset)];

      booleans[hook(7, localId)] = isTrueA && isTrueB;
    }

    barrier(0x01);
  }

  return booleans[hook(7, 0)];
}

int reduceOr(local int* booleans, size_t localId, size_t localSize) {
  for (int offset = localSize / 2; offset > 0; offset >>= 1) {
    if (localId < offset) {
      int isTrueA = booleans[hook(7, localId)];
      int isTrueB = booleans[hook(7, localId + offset)];

      booleans[hook(7, localId)] = isTrueA || isTrueB;
    }

    barrier(0x01);
  }

  return booleans[hook(7, 0)];
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

constant float MINIMUM_SPEED = 0.001f;
float4 getSpeed(float4 flowSpeed, float4 density, const float4 MINIMUM_DENSITY, const float4 MAXIMUM_DENSITY, const float4 MAXIMUM_SPEED) {
  float4 topographicalSpeed = MAXIMUM_SPEED;

  float4 mediumSpeed = topographicalSpeed - ((density - MINIMUM_DENSITY) / (MAXIMUM_DENSITY - MINIMUM_DENSITY)) * (topographicalSpeed - flowSpeed);

  int4 isGreaterEqualMaximum = density >= MAXIMUM_DENSITY;
  int4 isLessEqualMinimum = density <= MINIMUM_DENSITY;

  float4 speed = select(select(mediumSpeed, topographicalSpeed, isLessEqualMinimum), flowSpeed, isGreaterEqualMaximum);
  return speed;
}

kernel void speed(const unsigned int BUFFER_SIDE_LENGTH, global float4* densitiesDiscomfortsVelocities, global float4* speedNESWs, const float MINIMUM_DENSITY, const float MAXIMUM_DENSITY, const float MAXIMUM_SPEED) {
  size_t i = get_global_id(0);

  int2 position = (int2)(i % BUFFER_SIDE_LENGTH, i / BUFFER_SIDE_LENGTH);

  float4 densityNESW = getNESWNeighborsXComponentOrInfinity(position, BUFFER_SIDE_LENGTH, densitiesDiscomfortsVelocities);

  float4 flowSpeedNESW;
  int2 positionNorth = position;
  int2 positionEast = position;
  int2 positionSouth = position;
  int2 positionWest = position;

  positionNorth.y += 1;
  positionEast.x += 1;
  positionSouth.y -= 1;
  positionWest.x -= 1;

  flowSpeedNESW.x = getValueOrZero(positionNorth, BUFFER_SIDE_LENGTH, densitiesDiscomfortsVelocities).w;
  flowSpeedNESW.y = getValueOrZero(positionEast, BUFFER_SIDE_LENGTH, densitiesDiscomfortsVelocities).z;
  flowSpeedNESW.z = -getValueOrZero(positionSouth, BUFFER_SIDE_LENGTH, densitiesDiscomfortsVelocities).w;
  flowSpeedNESW.w = -getValueOrZero(positionWest, BUFFER_SIDE_LENGTH, densitiesDiscomfortsVelocities).z;

  flowSpeedNESW = fmax(flowSpeedNESW, (float4)(MINIMUM_SPEED, MINIMUM_SPEED, MINIMUM_SPEED, MINIMUM_SPEED));

  float4 speedNESW = getSpeed(flowSpeedNESW, densityNESW, (float4)(MINIMUM_DENSITY, MINIMUM_DENSITY, MINIMUM_DENSITY, MINIMUM_DENSITY), (float4)(MAXIMUM_DENSITY, MAXIMUM_DENSITY, MAXIMUM_DENSITY, MAXIMUM_DENSITY), (float4)(MAXIMUM_SPEED, MAXIMUM_SPEED, MAXIMUM_SPEED, MAXIMUM_SPEED));

  speedNESWs[hook(2, i)] = speedNESW;
}