function mapped_response = MapResponseButtonOption(response, responseButtonOption , is2Interval)

if response == 0
    mapped_response = 0;
else
    if is2Interval % '' is mean the button value
        if responseButtonOption == 1 %regular responses ('up' is up , and 'down' is down)
            mapped_response = response;
        elseif responseButtonOption == 2 %inversed responses ('up' is down , and 'down' is up)
            if response == 3
                mapped_response = 4;
            elseif response == 4
                mapped_response = 3;
            end
        elseif responseButtonOption == 3 %regular responses ('right' is up , and 'left' is down)
            if response == 2
                mapped_response = 3;
            elseif response == 1
                mapped_response = 4;
            end
        else                            %inversed regular responses ('left' is up , and 'right' is down)
            if response == 1
                mapped_response =3;
            elseif response == 2
                mapped_response = 4;
            end
        end
    else
        mapped_response = response;
    end
end
end