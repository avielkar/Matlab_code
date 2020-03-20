function [enable_right, enable_left , enable_up ,enable_down] = GetResponseOptionalButtons(responseButtonOption , is2Interval)
 
enable_right = false;
enable_left = false;
enable_up = false;
enable_down = false;

if is2Interval
    if responseButtonOption == 1 %regular responses ('up' is up , and 'down' is down)
        enable_up = true;
        enable_down = true;
    elseif responseButtonOption == 2 %inversed responses ('up' is down , and 'down' is up)
        enable_up = true;
        enable_down = true;
    elseif responseButtonOption == 3
          enable_right = true;
          enable_left = true;
    else
          enable_right = true;
          enable_left = true;
    end
else
    enable_right = true;
    enable_left = true;
    enable_up = false;
    enable_down = false;
end