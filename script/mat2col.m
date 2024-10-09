function QQ = mat2col(A)

[m,n]=size(A);

q=1;

QQ=zeros((m*n),1);

for i=1:n
    for j=1:m
        QQ(q,1)=A(j,i);
        q=q+1;
    end
end


        