clear,clc,close all
%INPUTS
%Q1 2 and 3 are the input vectors. The weight matrix will be taught to
%recognize A from Q1, B from Q2 and C from Q3
Q1=[1 0 1 0 0;0 1 0 1 0;0 1 0 1 0;1 0 0 0 1;1 0 1 0 1];
Q2=[1 1 0 0 0;1 0 1 1 0;1 1 1 0 0;1 1 0 1 0;1 1 1 0 0]; 
Q3=[0 1 1 1 0;1 0 0 1 1;0 1 0 0 0; 0 1 0 0 0;0 1 0 1 1]; 
q1=mat2col(Q1);
q2=mat2col(Q2); % creates a column vector from each of the input matrices (separated by column), 
q3=mat2col(Q3); % for later use in training and neuron updating
inputs=[q1,q2,q3]; % stors the inputs into a matrix for use in training
%TARGETS
%setting a binary matrix to represent the letter A in zeros and ones. This
%matrix is used to train the weight matrix to contin the letter A
A=[0 0 1 0 0;0 1 0 1 0;0 1 1 1 0;1 0 0 0 1;1 0 0 0 1]; 
%setting a binary matrix to represent the letter B in zeros and ones. This
%matrix is used to train the weight matrix to contin the letter B
B=[1 1 1 0 0;1 0 0 1 0;1 1 1 1 0;1 0 0 1 0;1 1 1 0 0]; 
%setting a binary matrix to represent the letter C in zeros and ones. This
%matrix is used to train the weight matrix to contin the letter C
C=[0 1 1 1 1;0 1 0 0 0;0 1 0 0 0; 0 1 0 0 0;0 1 1 1 1];
disp(A)
disp(B)  % displayed A ,B ,and C in order to visualize the target matrices
disp(C)
%CONVERT TARGETS
%is this necessary? linear indexing...
% Turning the target matices into colum vector and then storing the
% transpose for use in determining the weight matrix
aa=mat2col(A);
a=aa';
bb=mat2col(B);
b=bb';
cc=mat2col(C); 
c=cc';
target_outputs=[aa,bb,cc]; % Storing the target columns in a matrix

%WEIGHT MATRIX - defined as the same size as the targets
[M,N]=size(A);
V=M*N; % The number of rows and columns in the weight matrix are both equal to V
W=zeros(V,V); % Predefining a weight matrix of zeros

% determining the initial weight matrix from the target colum and row
% vectors defined previously W = sum(i)sum(j)[ (2*a(i)-1)*(2*a'(j)-1) ]
for i=1:V
    for j=1:V
        W(i,j)=(((2*a(i))-1)*((2*aa(j))-1))+(((2*b(i))-1)*((2*bb(j))-1))+(((2*c(i))-1)*((2*cc(j))-1));
        
        if i==j
            W(i,j)=0;
        end
    end
end

L=1;
eta=1;
alpha=0;
gw=zeros(V,V);

for i=1:3
    x=inputs(:,i);%inputs(:,i); %go along each of the inputs 
    t=target_outputs(:,i);
    for j=1:L
        o=randperm(V);
        for l=1:V
            p=randperm(V);
            for m=1:V
       % a=x'*W;
        %y=1./(1+(exp(-a)));
       % e=t'-y;
        %gw=x*e;
        %gw=gw+gw';
        %W=W+(eta.*(gw-(alpha.*W)));
        gw(o(l),p(m))=x(o(l))*(t(p(m))-(1/(1-exp(-(x'*W(:,p(m)))))));
        W(o(l),p(m))=W(o(l),p(m))+eta*(gw(o(l),p(m))-(alpha*W(o(l),p(m))));
  Vinit=x;     
 g=0;
z=-1;
while g==0
    
    j=Vinit;
    jj=abs(reshape(Vinit,M,N)-1);% turns cue input into matrix and flips image
    J=mat2gray(jj);
    imshow(J,'InitialMagnification','fit')
    pause(0.5)
    %iptgetpref
    
    indvec=randperm(V);    
for i=1:V
    Vinit(indvec(i))=W(indvec(i),:)*Vinit;
    if Vinit(indvec(i)) >= 0
        Vinit(indvec(i))=1;
    elseif Vinit(indvec(i)) < 0
        Vinit(indvec(i))=0;
    end
end
if j==Vinit
    g=1;
    z=z+1;
else
    z=z+1;
end

disp('z')
disp(z)
end

            end
        end
        for k=1:V
            W(k,k)=0;
        end
    end
end

%Vinit=q3;

%g=0;
%z=-1;
%while g==0
    
 %   j=Vinit;
  %  jj=abs(reshape(Vinit,M,N)-1);% turns cue input into matrix and flips image
   % J=mat2gray(jj);
%    imshow(J,'InitialMagnification','fit')
 %   pause(1.5)
  %  iptgetpref
    
   % indvec=randperm(V);    
%for i=1:V
 %   Vinit(indvec(i))=W(indvec(i),:)*Vinit;
  %  if Vinit(indvec(i)) >= 0
   %     Vinit(indvec(i))=1;
%    elseif Vinit(indvec(i)) < 0
 %       Vinit(indvec(i))=0;
  %  end
%end
%if j==Vinit
 %   g=1;
  %  z=z+1;
%else
 %   z=z+1;
%end

%disp('z')
%disp(z)
%end

Vfin=reshape(Vinit,M,N);
disp('Vfin')
disp(Vfin)
    