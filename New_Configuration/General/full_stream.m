function full_stream(hObject, eventdata, handles)
    global bxbport
    global bxbresult
    r = uint32(fread(bxbport,6));
    % byte 2 determines button number, press/release and port
    press = uint32(bitand (r(2), 16) ~= 0);    %binary 10000 bit 4
    if press
      button = bitshift (r(2), -5);    %leftmost 3 bits
      % skip the port since we always use the buttons
      % port = bitand(r(2), 15);       %binary 01111 bottom 4 bits
      % bytes 3-6 - the time elapsed in milliseconds 
      time = ((r(6) * 256 + r(5)) * 256 + r(4)) * 256 + r(3);
    %   cedrus.count = cedrus.count + 1;
    %   cedrus.event{cedrus.count} = [button time press];
      bxbresult = button;
    end