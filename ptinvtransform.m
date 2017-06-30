function [x_, y_] = ptinvtransform(H, x, y, xyscale, xdata, ydata)

    set_default_value('xyscale', 1);
    set_default_value('xdata', 0);
    set_default_value('ydata', 0);    

    x = x*xyscale;
    y = y*xyscale;    
    
    x = x + xdata(1);
    y = y + ydata(1);    
    
    transPts = inv(H)' * [x(:)'; y(:)'; ones(1, length(x))];
    transPts = normalizeHomogeneous(transPts');
    
    x_ = transPts(:,1);
    y_ = transPts(:,2);    
end