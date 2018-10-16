include <servo.scad>
include <high-detail.scad>

module bassist_hub() {
    round_hub(spacing=inch_to_mm(0.625), hole_d = M3_through_hole_d(), clamp_ext = 0, thread_d = M3_heat_set_hole_d(), clamp_side_d = 6);
}

bassist_hub();