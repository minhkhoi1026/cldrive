//{"clusterIndices":9,"intensity":7,"offset":8,"pointSize":5,"pointToTrackIndices":4,"points":2,"pointsResult":3,"radius":6,"trackLengths":1,"trackStarts":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 calculateLocalDirection(global const float4* points, int begin, int trackLength, int myIndex) {
  int end = begin + trackLength - 1;
  int first = myIndex - 1;
  int last = myIndex + 1;

  first = max(begin, first);
  last = min(end, last);
  float4 result = normalize(points[hook(2, last)] - points[hook(2, first)]);

  return result;
}

float4 calculateOverallDirection(global const float4* points, int begin, int trackLength) {
  int end = begin + trackLength - 1;

  float4 result = normalize(points[hook(2, end)] - points[hook(2, begin)]);

  return result;
}
bool checkCurvature(global const float4* points, int begin, int trackLength, int myIndex, float4 newPoint, float angleMin) {
  return true;

  int end = begin + trackLength - 1;

  int prePrev = myIndex - 2;
  int prev = myIndex - 1;
  int next = myIndex + 1;
  int postNext = myIndex + 2;

  prePrev = max(begin, prePrev);
  prev = max(begin, prev);
  next = min(end, next);
  postNext = min(end, postNext);

  float anglePrev1 = dot(normalize(points[hook(2, prePrev)] - points[hook(2, prev)]), normalize(points[hook(2, prev)] - points[hook(2, myIndex)]));
  float angle1 = dot(normalize(points[hook(2, prev)] - points[hook(2, myIndex)]), normalize(points[hook(2, myIndex)] - points[hook(2, next)]));
  float angleNext1 = dot(normalize(points[hook(2, myIndex)] - points[hook(2, next)]), normalize(points[hook(2, next)] - points[hook(2, postNext)]));
  float angleSum1 = anglePrev1 + angle1 + angleNext1;

  float anglePrev2 = dot(normalize(points[hook(2, prePrev)] - points[hook(2, prev)]), normalize(points[hook(2, prev)] - newPoint));
  float angle2 = dot(normalize(points[hook(2, prev)] - newPoint), normalize(newPoint - points[hook(2, next)]));
  float angleNext2 = dot(normalize(newPoint - points[hook(2, next)]), normalize(points[hook(2, next)] - points[hook(2, postNext)]));
  float angleSum2 = anglePrev2 + angle2 + angleNext2;

  if (angleSum2 > angleSum1)
    return true;

  return (angleMin <= anglePrev2) && (angleMin <= angle2) && (angleMin <= angleNext2);
}

int calculateClosestIndex(int trackStart, int trackLength, global const float4* points, float4 myPosition) {
  float minDistance = 99999;
  int bestIndex = -1;
  for (int i = trackStart; i < trackStart + trackLength; i++) {
    float newDistance = length(points[hook(2, i)] - myPosition);

    if (newDistance < minDistance) {
      minDistance = newDistance;
      bestIndex = i;
    }
  }

  return bestIndex;
}

float4 transformForcePerpendicular(float4 direction, float4 force) {
  float l = length(force);
  float4 forceOriginal = force;

  if (l <= 0.0) {
    return force;
  }

  force /= l;

  float t = dot(direction, force);
  float sgn = 1.;
  if (t > 0) {
    t = t * -1.;
    sgn = 1.;
  }

  force.x -= t * direction.x;
  force.y -= t * direction.y;
  force.z -= t * direction.z;

  if (dot(forceOriginal, force) < 0.) {
    force *= -1.f;
  }

  return l * force;
}

float4 calculateForce(global const int* clusterIndices, int clusterStart, int clusterLength, global const int* trackStarts, global const int* trackLengths, global const float4* points, float4 myPosition, float4 myDirection, float angleStick, float radius) {
  float weightSum = 1.;
  float4 force = {0., 0., 0., 0.};

  for (int i = clusterStart; i < clusterStart + clusterLength; i++) {
    int trackId = clusterIndices[hook(9, i)];
    int trackStart = trackStarts[hook(0, trackId)];
    int trackLength = trackLengths[hook(1, trackId)];
    int closestIndex = calculateClosestIndex(trackStart, trackLength, points, myPosition);

    float minDistance = length(points[hook(2, closestIndex)] - myPosition);

    if (minDistance > radius || minDistance < 0.00001) {
      continue;
    }

    float4 direction = calculateLocalDirection(points, trackStart, trackLength, closestIndex);

    float weight = ((radius - minDistance) / radius);
    if (!isnan(myDirection.x) && !isnan(direction.x)) {
      float angle = pow((float)dot(myDirection, direction), (float)2.);
      angle = max(0., (angle - angleStick) / (1. - angleStick));
      float weight = angle * weight;
    }

    weight = pow((float)weight, (float)2.);
    weightSum += weight;
    force += weight * (points[hook(2, closestIndex)] - myPosition);
  }

  force /= weightSum;

  if (!isnan(myDirection.x)) {
    force = transformForcePerpendicular(myDirection, force);
  }

  return force;
}

float4 smoothPosition(global const float4* points, int begin, int trackLength, int myIndex, const int radius, const float intensity) {
  float4 reference = points[hook(2, myIndex)];

  int end = begin + trackLength - 1;
  int first = myIndex - radius;
  int last = myIndex + radius;
  first = max(begin, first);
  last = min(end, last);

  float4 result = {0., 0., 0., 0.};

  for (int i = first; i < last + 1; i++) {
    result.x += points[hook(2, i)].x / (last - first + 1);
    result.y += points[hook(2, i)].y / (last - first + 1);
    result.z += points[hook(2, i)].z / (last - first + 1);
  }

  result.x = result.x * intensity + reference.x * (1. - intensity);
  result.y = result.y * intensity + reference.y * (1. - intensity);
  result.z = result.z * intensity + reference.z * (1. - intensity);

  return result;
}

kernel void smooth(global const int* trackStarts, global const int* trackLengths, global const float4* points, global float4* pointsResult, global const int* pointToTrackIndices, const int pointSize, const int radius, const float intensity, const int offset) {
  if (radius == 0 || intensity <= 0.0) {
    return;
  }

  int pointId = get_global_id(0) + offset;
  int trackId = pointToTrackIndices[hook(4, pointId)];
  int trackStart = trackStarts[hook(0, trackId)];
  int trackLength = trackLengths[hook(1, trackId)];
  int trackEnd = trackStart + trackLengths[hook(1, trackId)] - 1;
  ;

  if (pointId == trackStart || pointId == trackEnd) {
    return;
  }

  float4 resultPoint = smoothPosition(points, trackStart, trackLength, pointId, radius, intensity);
  if (pointId < pointSize) {
    pointsResult[hook(3, pointId)] = resultPoint;
  }
}