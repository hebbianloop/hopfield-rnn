function[ineuron1 jneuron1 ineuron2 jneuron2 ineuron3 jneuron3]...
    = setneuronval(pres1,pres2,pres3)
%check pres for equal size?
%var arg to add fluctuation in neural values? 
%would be interesting to see how that affects learning
%simulation of abnormal brain states...
ineuron1=pres1(:);
jneuron1=pres1(:);
ineuron2=pres2(:);
jneuron2=pres2(:);
ineuron3=pres3(:);
jneuron3=pres3(:);