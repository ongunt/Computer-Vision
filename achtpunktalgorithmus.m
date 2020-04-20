function [EF] = achtpunktalgorithmus(Korrespondenzen, K)
    % Diese Funktion berechnet die Essentielle Matrix oder Fundamentalmatrix
    % mittels 8-Punkt-Algorithmus, je nachdem, ob die Kalibrierungsmatrix 'K'
    % vorliegt oder nicht
    
    EF ={0, 0, 0 ,0};
    
    x1=[Korrespondenzen(1:2,:);ones(1,size(Korrespondenzen,2))];
    x2=[Korrespondenzen(3:4,:);ones(1,size(Korrespondenzen,2))];
    A=[];
    
    if nargin~=1
        x1=K\x1;
        x2=K\x2;
    end   
     
        
    for i=1:size(x2,2)     
       A=[A;(kron(x1(:,i),x2(:,i)))'];
    end
    
    [U,S,V] = svd(A)
   
     
     
     %A=kron(P1,P2)
    EF{1}=x1;
    EF{2}=x2;
    EF{3}=A;
    EF{4}=V;

 EF = 0;
    K1=[1 0 0;0 1 0;0 0 0];
    Gs=V(:,9);
    G=reshape(Gs,3,3);
    [Ug,Sg,Vg] = svd(G);
    F=Ug*([Sg(1,1) 0 0;0 Sg(2,2) 0;0 0 0])*Vg';
     E=Ug*K1*Vg';
    if nargin~=1
        EF=E;
    else
    EF=F;
    end
    
end