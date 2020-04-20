function [T1, R1, T2, R2, U, V]=TR_aus_E(E)
    % Diese Funktion berechnet die moeglichen Werte fuer T und R
    % aus der Essentiellen Matrix
    [U,S,V] = svd(E);
    R_P=[0 -1 0; 1 0 0;0 0 1];    
    R_Z=[0 1 0;-1 0 0;0 0 1];
      
      if det(U) < 0
	U = U*diag([1 1 -1]);
end

if det(V) < 0
	V = V*diag([1 1 -1]);
end

  
R1=U*R_P'*V';
R2=U*R_Z'*V';

t1=U*R_P*S*U';
t2=U*R_Z*S*U';

T1=[t1(3,2); t1(1,3);t1(2,1)];
T2=[t2(3,2); t2(1,3);t2(2,1)];

end