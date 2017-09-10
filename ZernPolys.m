function [ Zern ] = ZernPolys( n , m , r , t )

if m >= 0
    
    SUM=0;
    for k=0:(n-m)/2
        
        Rmn=(((-1)^k*factorial((n-k)))/(factorial(k)*factorial((n+m)/2-k)*factorial((n-m)/2-k))).*r.^(n-2*k);
        SUM=SUM+Rmn;
    end
        Zern=SUM.*cos(m.*t);
        
else
     
     m=-m;
     SUM=0;
    for k=0:(n-m)/2
        
        Rmn=(((-1)^k*factorial((n-k)))/(factorial(k)*factorial((n+m)/2-k)*factorial((n-m)/2-k))).*r.^(n-2*k);
        SUM=SUM+Rmn;
    end
        Zern=SUM.*sin(m.*t);
               

end

