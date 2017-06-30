function [n, mask, vx, vy] = get_count_in_box(cx, cy, pix_per_meter, scale, X, Y)

    scale = (pix_per_meter/2)*scale;
    vx = X > cx-scale & X < cx+scale;
    vy = Y > cy-scale & Y < cy+scale;
    
    mask = and(vx, vy);
    n = sum(mask);

end