function sd = sampson_dist(F, x1_pixel, x2_pixel)
    % Diese Funktion berechnet die Sampson Distanz basierend auf der
    % Fundamentalmatrix F
    
    x1=x1_pixel;
    x2=x2_pixel;
    e3=[0;0;1];
   
    
    e3m=[0,-e3(3),e3(2);
       e3(3),0,-e3(1);
       -e3(2),e3(1),0];
   
    
     
    
   
    
    
     
   dsM=(dot((x2'*F)',x1).^2)./(dot(e3m*F*x1,e3m*F*x1)+(dot((x2'*F*e3m)',(x2'*F*e3m)')));
         
    sd=dsM;
    
end