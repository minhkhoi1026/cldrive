//{"angleMin":12,"angleStick":13,"bundleEndPoints":15,"clusterIndices":4,"clusterInverse":5,"clusterLengths":3,"clusterStarts":2,"magnetRadius":10,"offset":14,"pointSize":9,"pointToTrackIndices":8,"points":6,"pointsResult":7,"stepsize":11,"trackLengths":1,"trackStarts":0}
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
  float4 result = normalize(points[hook(6, last)] - points[hook(6, first)]);

  return result;
}

float4 calculateOverallDirection(global const float4* points, int begin, int trackLength) {
  int end = begin + trackLength - 1;

  float4 result = normalize(points[hook(6, end)] - points[hook(6, begin)]);

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

  float anglePrev1 = dot(normalize(points[hook(6, prePrev)] - points[hook(6, prev)]), normalize(points[hook(6, prev)] - points[hook(6, myIndex)]));
  float angle1 = dot(normalize(points[hook(6, prev)] - points[hook(6, myIndex)]), normalize(points[hook(6, myIndex)] - points[hook(6, next)]));
  float angleNext1 = dot(normalize(points[hook(6, myIndex)] - points[hook(6, next)]), normalize(points[hook(6, next)] - points[hook(6, postNext)]));
  float angleSum1 = anglePrev1 + angle1 + angleNext1;

  float anglePrev2 = dot(normalize(points[hook(6, prePrev)] - points[hook(6, prev)]), normalize(points[hook(6, prev)] - newPoint));
  float angle2 = dot(normalize(points[hook(6, prev)] - newPoint), normalize(newPoint - points[hook(6, next)]));
  float angleNext2 = dot(normalize(newPoint - points[hook(6, next)]), normalize(points[hook(6, next)] - points[hook(6, postNext)]));
  float angleSum2 = anglePrev2 + angle2 + angleNext2;

  if (angleSum2 > angleSum1)
    return true;

  return (angleMin <= anglePrev2) && (angleMin <= angle2) && (angleMin <= angleNext2);
}

int calculateClosestIndex(int trackStart, int trackLength, global const float4* points, float4 myPosition) {
  float minDistance = 99999;
  int bestIndex = -1;
  for (int i = trackStart; i < trackStart + trackLength; i++) {
    float newDistance = length(points[hook(6, i)] - myPosition);

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
    int trackId = clusterIndices[hook(4, i)];
    int trackStart = trackStarts[hook(0, trackId)];
    int trackLength = trackLengths[hook(1, trackId)];
    int closestIndex = calculateClosestIndex(trackStart, trackLength, points, myPosition);

    float minDistance = length(points[hook(6, closestIndex)] - myPosition);

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
    force += weight * (points[hook(6, closestIndex)] - myPosition);
  }

  force /= weightSum;

  if (!isnan(myDirection.x)) {
    force = transformForcePerpendicular(myDirection, force);
  }

  return force;
}

kernel void edgeBundling(global const int* trackStarts, global const int* trackLengths, global const int* clusterStarts, global const int* clusterLengths, global const int* clusterIndices, global const int* clusterInverse, global const float4* points, global float4* pointsResult, global const int* pointToTrackIndices, const int pointSize, const float magnetRadius, const float stepsize, const float angleMin, const float angleStick, const int offset, const int bundleEndPoints) {
  int pointId = get_global_id(0) + offset;
  int trackId = pointToTrackIndices[hook(8, pointId)];
  int clusterId = clusterInverse[hook(5, trackId)];
  int trackStart = trackStarts[hook(0, trackId)];
  int trackLength = trackLengths[hook(1, trackId)];
  int trackEnd = trackStart + trackLength - 1;
  int clusterStart = clusterStarts[hook(2, clusterId)];
  int clusterLength = clusterLengths[hook(3, clusterId)];

  if (bundleEndPoints == 0 && (pointId == trackStart || pointId == trackEnd)) {
    pointsResult[hook(7, pointId)] = points[hook(6, pointId)];
    return;
  }

  float4 myPosition = points[hook(6, pointId)];
  float4 direction = calculateOverallDirection(points, trackStart, trackLength);

  float4 force = calculateForce(clusterIndices, clusterStart, clusterLength, trackStarts, trackLengths, points, myPosition, direction, angleStick, magnetRadius);
  float4 innerDirection = (points[hook(6, pointId + 1)] + points[hook(6, pointId - 1)]);

  {}

  float4 resultPoint = {0., 0., 0., 0.};
  resultPoint.x = myPosition.x + stepsize * force.x;
  resultPoint.y = myPosition.y + stepsize * force.y;
  resultPoint.z = myPosition.z + stepsize * force.z;
  if (pointId < pointSize) {
    pointsResult[hook(7, pointId)] = resultPoint;
  }
}