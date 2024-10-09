%TIMETORECALL = RETRIEVAL(SSWP,CUE)
%
%Retreival takes in a 25 x 25 steady state weight matrix produced from 
%training the network on 3 sequential letter presentations and uses this
%steady state weight matrix to produce an activation pattern that is
%supposed to represent the given input.
%
%
%SSWP - steady state weight matrix for presentations
%
%CUE - 5 x 5 matrix representation of grayscale letter
%
%TIMETORECALL - number of iterations 
function [timetorecall]=retrieval(sswp,cue)
steadystate=0; loop=numel(cue); cue=cue(:);
timetorecall=-1;
figfig=figure(1001);
while steadystate==0    
    template=cue;
    invtemp=abs(reshape(template,sqrt(loop),sqrt(loop))-1);
    memimage=mat2gray(invtemp);
    set(figfig,'Name','Simulation Memory Content'...
    ,'NumberTitle','off', ...
    'Toolbar','none','MenuBar','none')
    hh=uicontrol('Parent',gcf,'Position',[30 20 500 30],...
    'Style','text','String',...
    'Evaluating Cue with Respect to Memory Contents...');
    imshow(memimage,'InitialMagnification','fit');
    pause(.5)
    indvec=randperm(loop);
for i=1:loop
    cue(indvec(i))=sswp(indvec(i),:)*cue;
    if cue(indvec(i)) >= 0
        cue(indvec(i))=1;
    elseif cue(indvec(i)) < 0
        cue(indvec(i))=0;
    end
end
if template==cue
    set(hh,'String',('This is the letter I remember'))
    pause(1)
    steadystate=1;
    timetorecall=timetorecall+1;
else
    timetorecall=timetorecall+1;
end
end

