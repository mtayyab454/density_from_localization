function [P] = matlab2cv(H)
    
    e = H(1,1); b = H(1,2); h = H(1,3); d = H(2,1); a = H(2,2); g = H(2,3); f = H(3,1); c = H(3,2); i = H(3,3);

    P = [a b c;
         d e f;
         g h i];
end