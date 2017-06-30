ccc;

data_path = 'data/';
image_name = 'ramzan2.jpg';

[path, name_only, ext] = fileparts(image_name);
image = imread([data_path image_name]);
load([data_path name_only '_roi.mat']);
load([data_path name_only '_homography.mat']);
H = matlab2cv(H);

R = get_edge_rotation(H, image);
H = R'*H;

[y, x] = ind2sub(size(roi), find(roi(:)));
[xx, yy] = pttransform(cv2matlab(H), x, y);


H = cv2matlab(H);
tform = maketform('projective', H);

xyscale = 1;
xdata = [min(xx) max(xx)];
ydata = [min(yy) max(yy)];
[im_out, xdata, ydata] = imtransform(image, tform, 'XYScale', xyscale, 'xdata', xdata, 'ydata', ydata);
imshow(im_out)
save([data_path name_only '_homography_updated.mat'], 'H', 'xdata', 'ydata', 'xyscale');