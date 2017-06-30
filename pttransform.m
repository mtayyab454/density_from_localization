function [x_, y_] = pttransform(H, x, y, xyscale, xdata, ydata)

    % H is homography matrix, 3x3
    % x is a vector of column positions
    % y is a vector of row positions

    set_default_value('xyscale', 1);
    set_default_value('xdata', 0);
    set_default_value('ydata', 0);    

    transPts = H' * [x(:)'; y(:)'; ones(1, length(x))];
    transPts = normalizeHomogeneous(transPts');
    x_ = transPts(:,1) - xdata(1);
    y_ = transPts(:,2) - ydata(1);
    x_ = x_/xyscale;
    y_ = y_/xyscale;
end