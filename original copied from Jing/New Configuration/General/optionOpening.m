function optionOpening(hObject, catval)
global basicdispfig

basicdispfig = hObject;

xy.c(1) = 5;
xy.c(2) = 150;
xy.c(3) = 240;
for i=4:16
    xy.c(i)=xy.c(i-1)+70;
end

%------comment out and move it to placeObjects---jing
%xy.c0 = 5;
%xy.c1 = 150;
%xy.c2 = 240;
%xy.c3 = 310;
%xy.c4 = 380;
%xy.c5 = 450;
%xy.c6 = 520;
%xy.c7 = 590;
%xy.c8 = 660;
%xy.c9 = 730;
%xy.c10 = 790;
%xy.c11 = 850;
%xy.c12 = 910;
%xy.c13 = 970;
%xy.c14 = 1030;
%xy.c15 = 1090;


%xy.r0 = 60;
%xy.r1 = 860;
%xy.r2 = 840;
%xy.r3 = 810;
%xy.r4 = 780;
%xy.r5 = 750;
%xy.r6 = 720;
%xy.r7 = 690;
%xy.r8 = 660;
%xy.r9 = 630;
%xy.r10 = 600;
%xy.r11 = 570;
%xy.r12 = 540;
%xy.r13 = 510;
%xy.r14 = 480;
%xy.r15 = 450;
%xy.r16 = 420;
%xy.r17 = 390;
%xy.r18 = 360;
%xy.r19 = 330;
%xy.r20 = 300;
%xy.r21 = 270;
%xy.r22 = 240;
%xy.r23 = 210;
%xy.r24 = 180;
%xy.r25 = 150;
%xy.r26 = 120;
%xy.r27 = 90;
%xy.r28 = 60;
%xy.r29 = 30;
%xy.r30 = 0;

xy.texth1 = 20;
xy.textw1 = 50;
xy.labelh1 = 15;
xy.labelw1 = 60;

%xy.rowcntr = 1;-----jing-----------
% End row, column defs
% data.configpath = 'Z:\Users\Dylan\TestSetup\Protocols';
% data.condvect = struct('name','','data',[]);

% setappdata(basicfig,'protinfo',data);

setappdata(basicdispfig,'rowscols',xy);

PlaceObjects(catval);
