function [nPoints] = normalizeHomogeneous(hPoints)
%normalizeHomogeneous Normalize homogeneous points to non-homogeneous by dividing with (w)
%   Input: hPoints is [n*3] array

    w = hPoints(:,3);
    nPoints = hPoints./repmat(w, 1,3);

end