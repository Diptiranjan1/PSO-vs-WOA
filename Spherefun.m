function z = Spherefun(x)

    %%z=sum(abs(x))+prod(abs(x)); %F2
    %%%z = sum(x.^2);             %F1
    
    z=4*(x(1)^2)-2.1*(x(1)^4)+(x(1)^6)/3+x(1)*x(2)-4*(x(2)^2)+4*(x(2)^4);                %F3

end
