//{"data":0,"lp":3,"lvl":4,"myfloor":11,"mywall":10,"player":2,"scr":1,"wall1":6,"wall2":7,"wall3":8,"wall4":9,"wp":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct screen_params {
  unsigned int res_x;
  unsigned int res_y;
};

struct level_params {
  unsigned int level_x;
  unsigned int level_y;
};

struct player_params {
  float pos_x;
  float pos_y;
  float dir_x;
  float dir_y;
  float plane_x;
  float plane_y;
};

struct wall_params {
  int res_x;
  int res_y;
};

struct pixel {
  uchar r;
  uchar g;
  uchar b;
  uchar unused;
};

struct ray {
  int map_x;
  int map_y;
  float intersect_x;
  float intersect_y;
  float distance;
  bool verticalhit;
};

constant struct pixel ceiling_color = {0x60, 0x60, 0x60};
constant struct pixel floor_color = {0x80, 0x80, 0x80};

void swap(int* i, int* j) {
  const int tmp = *i;
  *i = *j;
  *j = tmp;
}

void draw_vertical_line(global struct pixel* data, const struct screen_params scr, const int x, int y_start, int y_end, const struct pixel wall_color) {
  if (y_end < y_start) {
    swap(&y_start, &y_end);
  }

  if ((x < 0) || (x >= scr.res_x) || (y_end < 0) || (y_start >= scr.res_y)) {
    return;
  }

  if (y_start < 0) {
    y_start = 0;
  }
  if (y_end >= scr.res_x) {
    y_end = scr.res_y - 1;
  }

  for (int y = 0; y < scr.res_y; y++) {
    const int xy = x + (y * scr.res_x);

    if (y < y_start) {
      data[hook(0, xy)] = ceiling_color;
    } else if (y <= y_end) {
      data[hook(0, xy)] = wall_color;
    } else {
      data[hook(0, xy)] = floor_color;
    }
  }
}

struct ray cast_ray(const struct screen_params scr, const int x, struct player_params player, const struct level_params lp, global int* lvl) {
  struct ray r;
  r.map_x = player.pos_x;
  r.map_y = player.pos_y;

  const float cam_x = 2.f * x / scr.res_x - 1;

  const float ray_dir_x = player.dir_x + (player.plane_x * cam_x);
  const float ray_dir_y = player.dir_y + (player.plane_y * cam_x);

  const float delta_dist_x = sqrt(pow(ray_dir_y, 2) / pow(ray_dir_x, 2) + 1);
  const float delta_dist_y = sqrt(pow(ray_dir_x, 2) / pow(ray_dir_y, 2) + 1);

  int step_x;
  int step_y;
  float side_dist_x;
  float side_dist_y;

  if (ray_dir_x < .0f) {
    step_x = -1;
    side_dist_x = (player.pos_x - r.map_x) * delta_dist_x;
  } else {
    step_x = 1;
    side_dist_x = (r.map_x + 1.f - player.pos_x) * delta_dist_x;
  }

  if (ray_dir_y < .0f) {
    step_y = -1;
    side_dist_y = (player.pos_y - r.map_y) * delta_dist_y;
  } else {
    step_y = 1;
    side_dist_y = (r.map_y + 1.f - player.pos_y) * delta_dist_y;
  }

  for (;;) {
    if (side_dist_x < side_dist_y) {
      r.map_x += step_x;
      side_dist_x += delta_dist_x;
      r.verticalhit = false;
    } else {
      r.map_y += step_y;
      side_dist_y += delta_dist_y;
      r.verticalhit = true;
    }

    if ((r.map_x < 0) || (r.map_x >= lp.level_x) || (r.map_y < 0) || (r.map_y >= lp.level_y) || (lvl[hook(4, r.map_y + (r.map_x * lp.level_y))] != 0)) {
      break;
    }
  }

  if (!r.verticalhit) {
    const float unit_x = r.map_x + (1 - step_x) / 2;
    const float intersect_x = player.pos_y + ((unit_x - player.pos_x) / ray_dir_x) * ray_dir_y;

    r.intersect_x = unit_x;
    r.intersect_y = intersect_x;

    r.distance = fabs((unit_x - player.pos_x) / ray_dir_x);
  } else {
    const float unit_y = r.map_y + (1 - step_y) / 2;
    const float intersect_y = player.pos_x + ((unit_y - player.pos_y) / ray_dir_y) * ray_dir_x;

    r.intersect_x = unit_y;
    r.intersect_y = intersect_y;

    r.distance = fabs((unit_y - player.pos_y) / ray_dir_y);
  }
  return r;
}

void draw_slice(global struct pixel* data, const struct screen_params scr, const int x, const struct ray ray, const struct player_params player, const struct level_params lp, global int* lvl,

                const struct wall_params wp, global struct pixel* wall1, global struct pixel* wall2, global struct pixel* wall3, global struct pixel* wall4) {
  const float cam_x = 2.f * x / scr.res_x - 1;

  const float ray_dir_x = player.dir_x + (player.plane_x * cam_x);
  const float ray_dir_y = player.dir_y + (player.plane_y * cam_x);

  const int wall_height = abs((int)(scr.res_y / ray.distance));

  int wall_start = (scr.res_y / 2) - (wall_height / 2);
  int wall_end = (scr.res_y / 2) + (wall_height / 2);

  if (wall_start < 0) {
    wall_start = 0;
  }

  if (wall_end >= scr.res_y) {
    wall_end = scr.res_y - 1;
  }

  global struct pixel* mywall;
  switch (lvl[hook(4, ray.map_y + (ray.map_x * lp.level_y))]) {
    case 1:
      mywall = wall1;
      break;
    case 2:
      mywall = wall2;
      break;
    case 3:
      mywall = wall3;
      break;
    case 4:
      mywall = wall4;
      break;
    default:
      mywall = wall1;
      break;
  }

  float wall_x = ray.intersect_y;
  wall_x -= floor(wall_x);

  int tex_x = wall_x * wp.res_x;

  if ((ray.verticalhit && ray_dir_y < 0) || (!ray.verticalhit && ray_dir_x > 0)) {
    tex_x = wp.res_x - tex_x - 1;
  }

  for (int y = 0; y < wall_start; y++) {
    const int xy = x + (y * scr.res_x);
    data[hook(0, xy)] = ceiling_color;
  }

  for (int y = wall_start; y < wall_end; y++) {
    const int tex_y = (y * 2 - scr.res_y + wall_height) * (wp.res_y / 2) / wall_height;
    const int tex_xy = tex_x + (tex_y * wp.res_x);

    struct pixel wall_px = mywall[hook(10, tex_xy)];

    if (ray.verticalhit) {
      wall_px.r /= 2;
      wall_px.g /= 2;
      wall_px.b /= 2;
    }

    const int xy = x + (y * scr.res_x);
    data[hook(0, xy)] = wall_px;
  }

  global struct pixel* myfloor = wall3;

  float floor_x_wall;
  float floor_y_wall;

  if (!ray.verticalhit && (ray_dir_x > 0)) {
    floor_x_wall = ray.intersect_x;
    floor_y_wall = ray.intersect_y + wall_x;
  } else if (!ray.verticalhit && (ray_dir_x < 0)) {
    floor_x_wall = ray.intersect_x + 1.f;
    floor_y_wall = ray.intersect_y + wall_x;
  } else if (ray.verticalhit && (ray_dir_y > 0)) {
    floor_x_wall = ray.intersect_x + wall_x;
    floor_y_wall = ray.intersect_y;
  } else {
    floor_x_wall = ray.intersect_x + wall_x;
    floor_y_wall = ray.intersect_y + 1.f;
  }

  const float dist_wall = ray.distance;
  const float dist_player = .0f;

  for (int y = wall_end; y < scr.res_y; y++) {
    const float cur_dist = scr.res_y / (2.f * y - scr.res_y);
    const float weight = (cur_dist - dist_player) / (dist_wall - dist_player);

    const float cur_floor_x = weight * floor_x_wall + (1.f - weight) * player.pos_x;
    const float cur_floor_y = weight * floor_y_wall + (1.f - weight) * player.pos_y;

    const int floor_tex_x = (int)(cur_floor_x * wp.res_x / 4) % wp.res_x;
    const int floor_tex_y = (int)(cur_floor_y * wp.res_y / 4) % wp.res_y;

    const int floor_tex_xy = floor_tex_x + (floor_tex_y * wp.res_x);
    struct pixel floor_px = myfloor[hook(11, floor_tex_xy)];

    floor_px.r /= 2;
    floor_px.g /= 2;
    floor_px.b /= 2;

    const int xy = x + (y * scr.res_x);
    data[hook(0, xy)] = floor_px;
  }
}

kernel void rc_2(global struct pixel* data, const struct screen_params scr, const struct player_params player, const struct level_params lp, global int* lvl,

                 const struct wall_params wp, global struct pixel* wall1, global struct pixel* wall2, global struct pixel* wall3, global struct pixel* wall4) {
  const int x = (int)get_global_id(0);
  if (x >= scr.res_x) {
    return;
  }

  const struct ray ray = cast_ray(scr, x, player, lp, lvl);
  draw_slice(data, scr, x, ray, player, lp, lvl, wp, wall1, wall2, wall3, wall4);
}