//{"BUFFER_SIDE_LENGTH":0,"agentCounts":16,"areaSideLength":12,"array":17,"booleans":18,"deltaTime":11,"directions":4,"entries":14,"exitMode":15,"gradientIn01":1,"gradientIn23":2,"ids":7,"maximumSpeeds":6,"positions":3,"potentials":13,"radii":8,"speedField":10,"speeds":5,"turnRates":9}
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

  float4 arrayValue = array[hook(17, clamp(indexFromPosition(p, size), 0, size * size - 1))];

  v = select(INFINITIES, arrayValue, isInsideArea);

  return v;
}

float4 getValueOrZero(int2 p, int size, global float4* array) {
  float4 v;

  int4 isInsideArea = isInside(p, size);

  float4 arrayValue = array[hook(17, clamp(indexFromPosition(p, size), 0, size * size - 1))];

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
    return array[hook(17, indexFromPosition(p, size))];
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
      int isTrueA = booleans[hook(18, localId)];
      int isTrueB = booleans[hook(18, localId + offset)];

      booleans[hook(18, localId)] = isTrueA && isTrueB;
    }

    barrier(0x01);
  }

  return booleans[hook(18, 0)];
}

int reduceOr(local int* booleans, size_t localId, size_t localSize) {
  for (int offset = localSize / 2; offset > 0; offset >>= 1) {
    if (localId < offset) {
      int isTrueA = booleans[hook(18, localId)];
      int isTrueB = booleans[hook(18, localId + offset)];

      booleans[hook(18, localId)] = isTrueA || isTrueB;
    }

    barrier(0x01);
  }

  return booleans[hook(18, 0)];
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

constant float2 PARKING_POSITION = (float2)(-1000.0f, -1000.0f);

constant int AGENT_COUNT_PARKED_BASE = 4;

constant float TURN_RATE_FAST_FACTOR = 4.0f;
constant float TURN_RATE_FAST_THRESHOLD = 0.6f;

constant float OPPOSITE_DIRECTION_DOT_PRODUCT_THRESHOLD = -0.8f;

float2 turnToDirection(float2 direction, float2 targetDirection, float dotProduct, float turnRate) {
  float2 newDirection;

  if (dotProduct < OPPOSITE_DIRECTION_DOT_PRODUCT_THRESHOLD) {
    float2 orthogonalDirection = (float2)(-direction.y, direction.x);

    newDirection = normalize(direction + normalize(orthogonalDirection - direction) * turnRate);
  } else {
    float2 directionOffset = targetDirection - direction;
    float directionOffsetLength = length(directionOffset);

    if (directionOffsetLength > turnRate) {
      directionOffset /= directionOffsetLength;

      newDirection = normalize(direction + directionOffset * turnRate);
    } else {
      newDirection = targetDirection;
    }
  }

  return newDirection;
}

float getTurnRate(float turnRate, float dotProduct, bool isFacingWall) {
  bool isTurningAround = dotProduct < TURN_RATE_FAST_THRESHOLD;

  bool isTurningFast = isFacingWall || isTurningAround;

  turnRate = select(turnRate, turnRate * TURN_RATE_FAST_FACTOR, isTurningFast);

  return turnRate;
}

float2 getGradient(unsigned int group, float2 positionWithOffset, read_only image2d_t gradientIn01, read_only image2d_t gradientIn23, const unsigned int BUFFER_SIDE_LENGTH) {
  float2 gradient;

  switch (group) {
    case 0: {
      gradient = getValueWithBilinearFilteringOrZero(positionWithOffset, BUFFER_SIDE_LENGTH, gradientIn01).xy;
      break;
    }

    case 1: {
      gradient = getValueWithBilinearFilteringOrZero(positionWithOffset, BUFFER_SIDE_LENGTH, gradientIn01).zw;
      break;
    }

    case 2: {
      gradient = getValueWithBilinearFilteringOrZero(positionWithOffset, BUFFER_SIDE_LENGTH, gradientIn23).xy;
      break;
    }

    case 3: {
      gradient = getValueWithBilinearFilteringOrZero(positionWithOffset, BUFFER_SIDE_LENGTH, gradientIn23).zw;
      break;
    }
  }

  return gradient;
}

kernel void move(const unsigned int BUFFER_SIDE_LENGTH, read_only image2d_t gradientIn01, read_only image2d_t gradientIn23, global float2* positions, global float2* directions, global float* speeds, global float* maximumSpeeds, global unsigned int* ids, global float* radii, global float* turnRates, global float4* speedField, const float deltaTime, const int areaSideLength, global float4* potentials, const global int4* entries, const int exitMode, global unsigned int* agentCounts) {
  size_t i = get_global_id(0);
  size_t agentCount = get_global_size(0);
  float radius = radii[hook(8, i)];

  float2 position = positions[hook(3, i)];
  float2 direction = directions[hook(4, i)];

  unsigned int id = ids[hook(7, i)];
  unsigned int group = ID_GROUP_MASK & id;

  bool isInsideArea = (position.x >= 0.0f) && (position.y >= 0.0f) && (position.x < areaSideLength) && (position.y < areaSideLength);

  if (isInsideArea) {
    int2 gridPosition = convert_int2_rtn(position);

    bool isInsideWall = isinf(getPotentialInfinity(group, gridPosition, BUFFER_SIDE_LENGTH, potentials));

    if (isInsideWall) {
      positions[hook(3, i)] = PARKING_POSITION;

      atomic_dec(&agentCounts[hook(16, group)]);
      atomic_inc(&agentCounts[hook(16, AGENT_COUNT_PARKED_BASE + group)]);
    } else {
      float2 offset = direction * radius;

      float2 positionWithOffset = position + offset;
      int2 gridPositionWithOffset = convert_int2_rtn(positionWithOffset);

      float2 gradient = getGradient(group, positionWithOffset, gradientIn01, gradientIn23, BUFFER_SIDE_LENGTH);

      bool isInsideWall = any(isinf(gradient) || isnan(gradient));

      bool isInsideInvalidEdge = all(gradient == (float2)(0.0f, 0.0f));

      float potential = getPotentialInfinity(group, gridPositionWithOffset, BUFFER_SIDE_LENGTH, potentials);

      if (potential == 0.0f) {
        switch (exitMode) {
          case 0:
          case 2:
          default: {
            positions[hook(3, i)] = PARKING_POSITION;

            atomic_dec(&agentCounts[hook(16, group)]);
            atomic_inc(&agentCounts[hook(16, AGENT_COUNT_PARKED_BASE + group)]);

            break;
          }

          case 1: {
            atomic_dec(&agentCounts[hook(16, group)]);

            group = (group + 1) % 4;

            atomic_inc(&agentCounts[hook(16, group)]);

            ids[hook(7, i)] = (~ID_GROUP_MASK & id) | (ID_GROUP_MASK & group);

            break;
          }
        }
      } else {
        bool isFacingWall = isInsideWall || isInsideInvalidEdge;

        float2 targetDirection = -normalize(gradient);

        targetDirection = select(targetDirection, -direction, (int2)isFacingWall);

        float dotProduct = dot(targetDirection, direction);

        float turnRate = getTurnRate(turnRates[hook(9, i)], dotProduct, isFacingWall);

        float2 newDirection = turnToDirection(direction, targetDirection, dotProduct, turnRate);

        float speed = 0.0f;

        if (!isFacingWall) {
          float4 anisotropicSpeeds = getValueOrZero(gridPositionWithOffset, BUFFER_SIDE_LENGTH, speedField);

          float xComponentFactor = newDirection.x * newDirection.x;
          float yComponentFactor = newDirection.y * newDirection.y;

          int2 isGreaterThanEqual = newDirection >= 0.0f;

          speed = select(speed, speed + (xComponentFactor * anisotropicSpeeds.y), isGreaterThanEqual.x);

          speed = select(speed, speed + (xComponentFactor * anisotropicSpeeds.w), !isGreaterThanEqual.x);

          speed = select(speed, speed + (yComponentFactor * anisotropicSpeeds.x), isGreaterThanEqual.y);

          speed = select(speed, speed + (yComponentFactor * anisotropicSpeeds.z), !isGreaterThanEqual.y);
        }

        speed = fmin(speed, maximumSpeeds[hook(6, i)]);

        float2 newVelocity = newDirection * speed;
        float2 newPosition = position + newVelocity * deltaTime;

        int2 newGridPosition = convert_int2_rtn(newPosition);
        bool isNewPositionInsideWall = isinf(getPotentialInfinity(group, newGridPosition, BUFFER_SIDE_LENGTH, potentials));

        newPosition = select(newPosition, position, (int2)isNewPositionInsideWall);
        speed = select(speed, 0.0f, isNewPositionInsideWall);

        positions[hook(3, i)] = newPosition;
        directions[hook(4, i)] = newDirection;
        speeds[hook(5, i)] = speed;
      }
    }
  } else {
    switch (exitMode) {
      default: {
        break;
      }

      case 2: {
        int4 entry = entries[hook(14, group)];

        int width = entry.z - entry.x + 1;
        int height = entry.w - entry.y + 1;

        int locations = width * height;

        int index = i % locations;

        int2 localPosition = positionFromIndex(index, width);

        int2 globalPosition = entry.xy + localPosition;

        positions[hook(3, i)] = (float2)(globalPosition.x, globalPosition.y);

        atomic_dec(&agentCounts[hook(16, AGENT_COUNT_PARKED_BASE + group)]);
        atomic_inc(&agentCounts[hook(16, group)]);

        break;
      }
    }
  }
}