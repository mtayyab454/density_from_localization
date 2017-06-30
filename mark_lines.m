function [line_end_points] = mark_lines(im, fig_title)
%     ccc
%     im = imread('DynTex.jpg');
    set_default_value('fig_title', 'Fig')
    
    global h_fig h_axis h_motion_line points
    h_fig = figure;
    imshow(im);
    title(fig_title);    
    h_axis = get(h_fig, 'CurrentAxes');
    h_motion_line = line('XData',[],'YData',[], 'color', 'y', 'linestyle', '--'); 
    
    set(h_fig, 'WindowButtonDownFcn', @get_mouse_input);
    uiwait(h_fig);

    line_end_points = zeros(4, size(points, 1)/2);
    for i=1:size(points, 1)/2
        en = i*2;
        st = en-1;
        
        x1 = points(st, 1);
        y1 = points(st, 2);
        x2 = points(en, 1);
        y2 = points(en, 2);        
        
        line_end_points(:, i) = [x1 y1 x2 y2]';
    end
%     close(h_fig)
    clear global
%     hold on
%     for i=1:length(line_end_points)
%        line( line_end_points([1,3], i), line_end_points([2,4], i), 'Color', 'b', 'LineWidth', 2);
%     end
    
end

function get_mouse_input(src, evnt)
    global h_fig h_axis
    
    selection_type = get(src,'SelectionType');
    currPoint = get(h_axis, 'CurrentPoint');
    x = currPoint(1,1);
    y = currPoint(1,2);
    
    if strcmp(selection_type, 'open')
        release_all();
        uiresume(h_fig);
    elseif strcmp(selection_type, 'normal')
        mark_point(x, y);
    elseif strcmp(selection_type, 'alt')
        del_point();
    end
end

function mouse_motion(src, evnt)

    global h_axis h_motion_line points
    
    currPoint = get(h_axis, 'CurrentPoint');
    x = currPoint(1,1); 
    y = currPoint(1,2);
    
    last_point = points(end, :);
    
    xdat = [last_point(1) x];
    ydat = [last_point(2) y];
    set(h_motion_line, 'XData', xdat, 'YData', ydat);
%     drawnow;
end

function mark_point(x, y)
    global h_fig points h_lines h_points
    points(end + 1, :) = [x, y];
    
    hold on
    h_points{end+1} = scatter(x, y, 'ro');
    hold off
    
    if mod(size(points, 1), 2) == 1
        set(h_fig,'WindowButtonMotionFcn', @mouse_motion);
    else
        set(h_fig,'WindowButtonMotionFcn', '');
        hold on
        h_lines{end+1} = line(points(end-1:end, 1) , points(end-1:end, 2), 'Color', 'r', 'LineWidth', 1.5);
        hold off
    end
end

function release_all()
    global h_fig h_points points
    
    set(h_fig, 'WindowButtonDownFcn', '');
    set(h_fig,'WindowButtonMotionFcn', '');
    if mod(size(points, 1), 2) == 1
        points(end, :) = [];
        h_last_point = h_points{end};
        h_last_point.delete();
        h_points(end) = [];
    end
end

function del_point()
    global h_fig h_motion_line h_lines h_points points

    if size(points, 1) > 0    
        points(end, :) = [];
        
        h_last_point = h_points{end};
        h_last_point.delete();
        h_points(end) = [];        

        if mod(size(points, 1), 2) == 1
            h_last_line = h_lines{end};
            h_last_line.delete();
            h_lines(end) = [];            
            set(h_fig,'WindowButtonMotionFcn', @mouse_motion);
        else
            set(h_fig,'WindowButtonMotionFcn', '');
            set(h_motion_line, 'XData', [], 'YData', []);
        end
    end
end