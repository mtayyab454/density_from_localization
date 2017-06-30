function out_color = color_vector(color_bar, vec, max_ppl)
%     color_bar = jet;
%     vec = rand(1, 1000);
    
    n = size(color_bar, 1);
    
%     ran = range([log(1) log(max_ppl+1)]);
    temp = vec/max_ppl;
    idx = round((n-1)*temp);
    idx = idx + 1;
    
    out_color = color_bar(idx, :);
end