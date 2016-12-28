function C(hObject, eventdata, handles)
%     global y;
%     fprintf('inC\n');
%     y=y+1;
global bxbport;
fprintf(bxbport,['c10', char(13)]); %XID mode

fprintf(bxbport,['e5',char(13)]);
if(bxbport.BytesAvailable() == 12)
    r = uint32(fread(bxbport,6));
    uint32(fread(bxbport,6));
    press = uint32(bitand (r(2), 16) ~= 0);    %binary 10000 bit 4
    if press
         response = bitshift (r(2), -5);    %leftmost 3 bits
    else
        response =0;
    end
    fprintf('%d\n' , response);
end