% rmpath(genpath('/home/tayyab/codes/Custom_Matlab_Codes'));

ccc;

% addpath('export_fig');
data_path = 'data/';
files = dir([data_path '*.jpg']);

for ii=1:length(files)
    name_only = files.name(1:end-4);
    image = imread([data_path name_only '.jpg']);

    load([data_path name_only '_homography_updated.mat']);
    load([data_path name_only '_roi.mat']);
    load([data_path name_only '_ann.mat']);
    load([data_path name_only '_hsm.mat']);

    load([data_path name_only '_localization.mat']);
    load([data_path name_only '_world_measurement.mat']);

    pX = X; pY = Y;
    gX = annPoints(:, 1); gY = annPoints(:, 2);

    xyscale = 0.5;
    tform = maketform('projective', H);
    roi_r = imtransform(roi, tform, 'XYScale', xyscale, 'xdata', xdata, 'ydata', ydata);
    im_r = imtransform(image, tform, 'XYScale', xyscale, 'xdata', xdata, 'ydata', ydata);
    [~, lys] = pttransform(H, 1, size(image, 1), xyscale, xdata, ydata);

    [x_, y_] = pttransform(H, [x1 x2], [y1 y2], xyscale, xdata, ydata);
    [gX_, gY_] = pttransform(H, gX, gY, xyscale, xdata, ydata);
    [pX_, pY_] = pttransform(H, pX, pY, xyscale, xdata, ydata);

    % figure; imshow(im_r)
    % hold on
    % scatter(x_, y_, 'gx');
    % scatter(gX_, gY_, 'go');
    % scatter(pX_, pY_, 'rx');

    %%%%%%%%%%%% get ground scale %%%%%%%%%%%%%

    temp = [x_(1) - x_(2), y_(1) - y_(2)];
    d = sqrt(sum(temp.^2));
    pix_per_meter = d/length_in_meters;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    pix_per_meter = round(pix_per_meter);
    lys = round(lys);

    lx = 1:pix_per_meter:size(im_r, 2);
    ly = lys:-pix_per_meter:1;

    num_cells = (length(lx)-1)*(length(ly)-1);
    poly = zeros(num_cells, 8);
    poly_ = zeros(num_cells, 8);
    gN = zeros(num_cells, 1);
    pN = zeros(num_cells, 1);

    count_average_scale = 2;
    loop_count = 1;
    for i=1:length(lx)-1
        for j=1:length(ly)-1

            xbl =  lx(i);   ybl = ly(j);    % bottom left
            xbr =  lx(i+1); ybr = ly(j);    % bottom right
            xtr =  lx(i+1); ytr = ly(j+1);  % top right
            xtl =  lx(i);   ytl = ly(j+1);  % top left

            cx = [xbl + xbr]/2;
            cy = [ybr + ytl]/2;

            poly_(loop_count, :) = [xbl, ybl, xbr, ybr, xtr, ytr, xtl, ytl]; 

            [px, py] = ptinvtransform(H, [xbl, xbr, xtr, xtl, ], [ybl, ybr, ytr, ytl], xyscale, xdata, ydata);
            poly(loop_count, :) = [px(1), py(1), px(2), py(2), px(3), py(3), px(4), py(4)];

            [gn, gmask, gvx, gvy] = get_count_in_box(cx, cy, pix_per_meter, count_average_scale, gX_, gY_);
            [pn, pmask, pvx, pvy] = get_count_in_box(cx, cy, pix_per_meter, count_average_scale, pX_, pY_);
            gN(loop_count) = gn/(count_average_scale^2);
            pN(loop_count) = pn/(count_average_scale^2);

            loop_count = loop_count + 1;
        end
    end

    valid_mask = false(size(gN));

    for i=1:size(poly, 1)

        px = round(poly(i, [1 3 5 7]));
        py = round(poly(i, [2 4 6 8]));

        xpos = px > 0;
        xin = px <= size(image, 2);
        ypos = py > 0;
        yin = py <= size(image, 1);

        if sum(xpos) == 4 && sum(xin) == 4 && sum(ypos) == 4 && sum(yin) == 4
            ind = sub2ind(size(roi), py, px);
            if sum(roi(ind)) == 4
                valid_mask(i) = 1;
            end
        else
            valid_mask(i) = 1;
        end

    end

    gN = gN(valid_mask);
    pN = pN(valid_mask);
    poly = poly(valid_mask, :);    

    height = size(image, 1);
    [gc, mycolorbar] = get_colors('jet', gN, round(0.05*height), height, 9);
    pc = gc; %pc = get_colors('jet', pN, round(0.05*height), height, 9);    
    
    seprater = uint8(255*ones(height, 10, 3));

    gdensity = insertShape(image, 'FilledPolygon', poly, 'Color', 255*gc, 'Opacity', 0.8);
    pdensity = insertShape(image, 'FilledPolygon', poly, 'Color', 255*pc, 'Opacity', 0.8);

    gcolor_layer = insertShape(255*ones(size(image), 'uint8'), 'FilledPolygon', poly, 'Color', 255*gc, 'Opacity', 0.8);
    pcolor_layer = insertShape(255*ones(size(image), 'uint8'), 'FilledPolygon', poly, 'Color', 255*pc, 'Opacity', 0.8);

    ghead_pixels = get_head_pixels(hsm, gX, gY);
    phead_pixels = get_head_pixels(hsm, pX, pY);
    gdots_layer = insertShape(255*ones(size(image), 'uint8'), 'FilledCircle', [gX, gY, ghead_pixels], 'Color', 'Red', 'Opacity', 1);
    pdots_layer = insertShape(255*ones(size(image), 'uint8'), 'FilledCircle', [pX, pY, phead_pixels], 'Color', 'Red', 'Opacity', 1);
    % roi3 = cat(3, roi, roi, roi);
    % color_layer(~roi3) = 255;

    imwrite(image, ['results/' name_only '.jpg']);

    imwrite([gdensity seprater mycolorbar], ['results/' name_only '_groundtruth_density.jpg']);
    imwrite([pdensity seprater mycolorbar], ['results/' name_only '_predicted_density.jpg']);

    imwrite([gcolor_layer seprater mycolorbar], ['results/' name_only '_groundtruth_color_layer.png']);
    imwrite([pcolor_layer seprater mycolorbar], ['results/' name_only '_predicted_color_layer.png']);

    imwrite(gdots_layer, ['results/' name_only '_groundtruth_dots_layer.png']);
    imwrite(pdots_layer, ['results/' name_only '_predicted_dots_layer.png']);

    imwrite(roi, ['results/' name_only '_roi.png'])
end
