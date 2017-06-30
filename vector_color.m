function out_color = vector_color(color_bar, vec)
%     color_bar = jet;
%     vec = rand(1, 1000);

    ran = range(vec);
    min_vec = min(vec);
    max_vec = max(vec);
    
    n = size(color_bar, 1);
    
    temp = (vec-min_vec)/ran;
    idx = round((n-1)*temp);
    idx = idx + 1;
    
    out_color = color_bar(idx, :);
end