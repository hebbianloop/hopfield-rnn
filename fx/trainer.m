%SSW = TRAINER(IWEIGHTS,PRES1,PRES2,PRES3,
%                                   ENCODINGTIME,LEARNINGRATE,DECAY,
%                                   TRAINPAUSE,STEADYSTATEPAUSE
%
%TRAINER takes a initial weights as an input and three letters represented
%as binary 5x5 matrices and produces a steady state weight matrix.  This
%weight matrix contains the connections between neurons necessary for
%detecting one of the given presentations.  
% Note that several constants are necessary for proper use of this
% function. 
% ENCODINGTIME is the number of times the network rehearses the
% weights.
% LEARNINGRATE is a constant that specifies the rate of learning.
% DECAY is a constant that introduces noise into the steady state weight
% matrix (SSW).  
% TRAINPAUSE and STEADYSTATEPAUSE indicate how long the
% visualizations of the rehearsed memory and weight matrix remain on
% screen.  If these values are 0 then the visualizations are not produced.
%LAST EDIT:  Shady El Damaty 14 Mar 4:30:40
function ssw = trainer(...
    iweights,pres1,pres2,pres3,...
    encodingtime,learningrate,decay...
    ,trainpause,steadystatepause)
%PREALLOCATION OF ALL VARIABLES
ssw=iweights;memory = horzcat(pres1,pres2,pres3);s=numel(pres1);
a=zeros(1,s);y=zeros(1,s);e=zeros(1,s);gw=zeros(s,s);
%DEFINITION OF ALL FIGURE OBJECTS AND PROPERTIES
h1=figure('Visible','off','Name','Simulation Memory Content',...
                                'NumberTitle','off', ...
                                'Toolbar','none','MenuBar','none');
h2=figure('Visible','off','Name','Hopfield Neural Network: Weight Dynamics',...
                                'NumberTitle','off','Toolbar','none','Menubar','none');
                            h1place=get(h1,'Position');
                            h2place=get(h2,'Position');h2place(1)=(h1place(1)/2)-59;
                            set(h2,'Position',h2place)
hh=uicontrol('Parent',h1,'Position',[30 20 500 30],'Style','text');
a1=axes('Parent',h1);a2=axes('Parent',h2);
%FOR EACH OF THE PRESENTATIONS REHEARSE 'encodingtime' TIMES
for presloop=1:3
    sprintf('Training on Presentation %d',presloop)
    auxvec=[1 26 51]; %ugh noneloquent.. i know-any ideas let me know
    indvec = auxvec(presloop):(presloop*s);
    randind = randperm(s); randind2=randperm(s); randind3=randperm(s);
    for learn = 1:encodingtime
        sprintf('Training Pass %d of %d',learn,encodingtime)
        for i = 1:s
            sprintf('Integrating input for output neuron %d',randind(i));
            for j = 1:s
                %GIVEN: output neuron = i (r0w)   input neuron = (c0l);
                %Randomly select a neuron pair i,j:
                    %Compute the activity of the randomly selected output 
                    %neuron i by summing across the product of the input of
                    %a randomly selected input neuron j and the weight 
                    %between input neuron j and i
                a(randind(i))=a(randind(i))...  
                    +memory(randind(j))...
                    *iweights(randind(i),randind(j));
            end
            %Compute the output of a randomly selected neuron i via the
            %logistic function of the randomly selected neuron i
            disp('Calculating activity')
            y(randind(i))=1/(1+exp(-a(randind(i))));
            %Now that we have the output, we assume that the network
            %possesses an intrinsic error minimization mechanism that is
            %also random.
            %We can calculate the error in a randomly selected output
            %neuron i by subtracting the expected output of neuron i
            %from the actual input of neuron i.  In this case the
            %expected output is the value of the corresponding input
            %neuron i
            disp('Calculating error in activity')
            e(randind(i))=memory(randind2(i))-y(randind2(i));
            %GIVEN the error, we can calculate the weight gradient by
            %multiplying the value of a randomly selected input neuron
            %j by the error of the corresponding output neuron i.
            %Here j = k.
            disp('Calculating weight gradient')
            for k = 1:s
                gw(randind(i),randind2(k))=...
                    memory(randind2(k))*e(randind(i));
            end
            %GIVEN the weight gradient, we can update the steady state
            %weights assuming that the network possesses an intrinsic
            %weight adjustment mechanism.  In this model we assume neurons
            %are updated sequentially and randomly.
            %We can calculate the steady state weights between input
            %neuron j and output neuron i by adding the current weight 
            %to the difference between the weight gradient and current
            %weight between input neuron j and input neuron i.  This
            %difference can be multiplied by a learning rate constant.  The
            %weight matrix within the difference can be also be multiplied
            %by a decay rate constant. Here u = j.
            disp('Adjusting weights..')
            for u = 1:s
                ssw(randind(i),randind3(u)) = ssw(randind(i),randind3(u))...
                    + (learningrate * (gw(randind(i),randind3(u)) - ...
                                        (decay*ssw(randind(i),randind3(u))...
                      )               )                                   );
%                 Feed current memory into neuron to show memory contents
%                 Take the memory, run it through the weight matrix and set
%                 each value to a 0 or a 1 depending on if the value of the
%                 new memory is greater than or equal to 0.
                  if trainpause==0&&steadystatepause==0
                      disp('Skipping Visualization')
                      continue
                  else
                        disp('Visualization')
                        cue = memory(indvec)';
                        steadystate=0;timetorecall=-1;
                        while steadystate==0    
                            template=cue;
                            invtemp=abs(reshape(template,sqrt(s),sqrt(s))-1);
                            memimage=mat2gray(invtemp);
                            %OUTPUT CURRENT NEURON INTEGRATION/WEIGHT MOD
                            set(hh,'String', ...
                                sprintf('Training Output Neuron %d with Input Neuron %d',...
                                randind3(i),randind3(u)));                                
                            %SET APPROPRIATE AXES AND MAKE VISIBLE
                            set(h1,'CurrentAxes',a1,'Visible','on')
                            imshow(memimage,'InitialMagnification','fit'); %visualize memory
                            set(h2,'CurrentAxes',a2,'Visible','on')
                            surface(ssw);colorbar %visualize weight matrix
                            pause(trainpause)
                            indvec=randperm(s);
                            for ii=1:s
                                cue(indvec(ii))=ssw(indvec(ii),:)*cue;
                                if cue(indvec(ii)) >= 0
                                    cue(indvec(ii))=1;
                                elseif cue(indvec(ii)) < 0
                                    cue(indvec(ii))=0;
                                end
                            end
                        if template==cue
                            %INFORM USER OF STABLE STATE
                            set(hh,'String',sprintf('Stable State: Output Neuron %d and Input Neuron %d',...
                                randind3(i),randind3(u)));
                            pause(steadystatepause)
                            steadystate=1;
                            timetorecall=timetorecall+1;
                        else
                            timetorecall=timetorecall+1;
                        end
                        end
                  end
            end
        end
    end
    a=zeros(1,s);
end
%Clear all self weights
for cleardiag=1:s
    ssw(s,s)=0;
end