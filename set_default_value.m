function set_default_value(argName, defaultValue)
% Initialise a missing or empty value in the caller function.
% 
% SETDEFAULTVALUE(POSITION, ARGNAME, DEFAULTVALUE) checks to see if the
% argument named ARGNAME in position POSITION of the caller function is
% missing or empty, and if so, assigns it the value DEFAULTVALUE.
% 
% Example:
% function x = TheCaller(x)
% SetDefaultValue('x', 10);
% end
% TheCaller()    % 10
% TheCaller([])  % 10
% TheCaller(99)  % 99
% 
% $Author: Muhammad Tayyab $  $Date: 06/11/2015

    variables = evalin('caller','whos');

    assign_default = 1;
    for i=1:length(variables)
        if strcmp(argName, variables(i).name)
            if sum(variables(i).size) ~= 0
                assign_default = 0;
            end
        end
    end

    if assign_default
        assignin('caller', argName, defaultValue);
    end

end