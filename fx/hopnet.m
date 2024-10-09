%[OUTPUT] = HOPNET(PRES1,PRES2,PRES3,CUE,VARARGIN)
%
%Hopnet trains an artificial neural network on three presentation items and
%then cues the network with an item that may or may not have been among the
%presentation items.  This approach is a model of the Sternberg Working
%Memory Task.
%
%PRES1 through PRES3 and CUE must be 5x5 matrix representations of letters.
%
%VARARGIN gives the user to specify learning rule constants and the time to
%display each iteration of the memory.
%
%The variable arguments must be inputted in this order:
%                       encodingtime - this is the number of loops for
%                       training on the presentation matrices, the default
%                       is set to 10.
%
%                       learningrate - this is the rate of learning for the
%                       system.  Values greater than one may result in
%                       overtraining. The default value is 1.
%
%                       decay - this can be though of as an auxilliary
%                       variable that influences the stability of the
%                       memory.  A greater decay means that the memory is
%                       not faithfully reproduced in the weights of the
%                       neurons.  Introduces 'noise.' The default value is
%                       0.
%
%                       pause1 - this stops the training and allows
%                       visualization of the current memory input.  The
%                       default value is 0.  This is not the stable state.
%
%                       pause2 - this stops the training once the stable
%                       state weights have been determined.  Allows
%                       visualization of what the system is holding in
%                       memory.  The default value is 0. 
%                       
%IMPORTANT NOTE:  if you want to input the latter arguments (e.g. pause2), you 
%must input the preceeding constants first (encodingtime,learningrate,etc).
%The program assigns the variable inputs in terms of the order defined
%above, if you don't input in that order you are not using the program
%correctly.
%LAST EDIT:  Shady El Damaty 14 MAR 0:30:00
function [timetorecall]=hopnet(pres1,pres2,pres3,cue,varargin)
switch nargin
    case 4
        encodingtime=10;learningrate=1;decay=0;pause1=0;pause2=0;
    case 7
        encodingtime=varargin{1};learningrate=varargin{2};decay=varargin{3};
        pause1=0;pause2=0;
    case 9
        encodingtime=varargin{1};learningrate=varargin{2};decay=varargin{3};
        pause1=varargin{4};pause2=varargin{5};
    otherwise
        error('Incorrect Number of Inputs')
end
%Create neurons
[ineuron1 jneuron1 ineuron2 jneuron2 ineuron3 jneuron3]...
    = setneuronval(pres1,pres2,pres3);
%Set initial weights
iweights = hebbian(ineuron1,jneuron1,ineuron2,jneuron2, ...
    ineuron3,jneuron3);
%train
sswp = trainer(...
    iweights,pres1,pres2,pres3,...
    encodingtime,learningrate,decay...
    ,pause1,pause2);
%cue network with input
[timetorecall]=retrieval(sswp,cue);