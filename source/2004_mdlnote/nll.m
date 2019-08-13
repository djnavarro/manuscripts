function L=nll(X,C,T,N,model);

switch model
    case 1;  f=X(1)*exp(-X(2).*T);
    case 2;  f=X(1)*exp(-X(2).*(T.^X(3)));
end
h=C.*log(f) + (N-C).*log(1-f);
L=-sum(h);% [L X]