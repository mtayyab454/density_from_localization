function [P] = cv2matlab(H)
    
    a = H(1,1); b = H(1,2); c = H(1,3); d = H(2,1); e = H(2,2); f = H(2,3); g = H(3,1); h = H(3,2); i = H(3,3);

    P = [e b h;
         d a g
         f c i];
end