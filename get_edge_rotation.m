function R = get_edge_rotation(Hcv, image)
    x = [1 size(image, 2)];
    y = [size(image, 1) size(image, 1)];
    [xx, yy] = pttransform(cv2matlab(Hcv), x, y);

    v = [x(1) - x(2), y(1) - y(2)];
    vv = [xx(1) - xx(2), yy(1) - yy(2)];

    r = vrrotvec([vv, 0], [v, 0]);
    R = vrrotvec2mat(r);
end