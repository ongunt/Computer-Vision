function Cake = cake(min_dist)
    % Die Funktion cake erstellt eine "Kuchenmatrix", die eine kreisfoermige
    % Anordnung von Nullen beinhaltet und den Rest der Matrix mit Einsen
    % auffuellt. Damit koennen, ausgehend vom staerksten Merkmal, andere Punkte
    % unterdrueckt werden, die den Mindestabstand hierzu nicht einhalten. 
   ganze =(-min_dist:min_dist);
   ersteHalbe =(-min_dist:-1);
   zweiteHalbe = (0:min_dist);
    
   [X,Y]=meshgrid(ganze,[ersteHalbe,zweiteHalbe]);
   
   kuchen=sqrt(X.*X+Y.*Y);
   Cake=kuchen>min_dist;
    
end