function A(hObject, eventdata, handles)
    global x;
    global y;
    y=0;
    x=0;
    Resploop_timer2 = timer('TimerFcn','B','Period',0.001,'Tag','respLoop','ExecutionMode','fixedRate','StartDelay',0,'TasksToExecute',1000);
    start(Resploop_timer2);
    Resploop_timer = timer('TimerFcn','C','Period',0.001,'Tag','respLoop','ExecutionMode','fixedRate','StartDelay',0,'TasksToExecute',1000);
    start (Resploop_timer);
    pause(10);
    fprintf('the value is %d',x);
