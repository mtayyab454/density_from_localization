ccc;

data_path = 'data/';
image_name = 'ramzan2.jpg';
[path, name_only, ext] = fileparts(image_name);
image = imread([data_path image_name]);

world_line = mark_lines(image, 'Mark World Length');

x1 = world_line(1, 1);
y1 = world_line(2, 1);
x2 = world_line(3, 1);
y2 = world_line(4, 1);

figure; imshow(image)
hold on;
scatter([x1 x2], [y1 y2], 'rx');

length_in_meters = [];
length_in_meters = input('Enter the length in metres: ');

save([data_path name_only '_world_measurement.mat'], 'x1', 'y1', 'x2', 'y2', 'length_in_meters');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Verify %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load([name_only '_world_measurement.mat']);
% figure; imshow(image)
% hold on;
% scatter([x1 x2], [y1 y2], 'rx');
% 
% save([name_only '_world_measurement.mat'], 'x1', 'y1', 'x2', 'y2', 'length_in_meters');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%