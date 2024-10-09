function [initweights]=hebbian(ineuron1,jneuron1,...
    ineuron2,jneuron2,ineuron3,jneuron3)
sizeparam=numel(ineuron1); initweights=zeros(sizeparam,sizeparam);
for i=1:sizeparam
    for j=1:sizeparam
        initweights(i,j)= ...
            (((2*ineuron1(i))-1)*((2*jneuron1(j))-1))...
            +(((2*ineuron2(i))-1)*((2*jneuron2(j))-1))...
            +(((2*ineuron3(i))-1)*((2*jneuron3(j))-1));
        if i==j
            initweights(i,j)=0;
        end
    end
end