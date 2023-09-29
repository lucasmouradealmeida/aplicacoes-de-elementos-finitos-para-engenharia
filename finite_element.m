# Método dos Elementos finitos - Método Direto

# Número de elementos
ne = 2;

# Elemento 1
Ae(1) = 9e2; # mm2
Ee(1) = 7e4; # Mpa
Le(1) = 2e2; # mm

# Elemento 2
Ae(2) = 1.2e3; # mm2
Ee(2) = 2e5; # Mpa
Le(2) = 3e2; # mm

# Matriz de rigidez global
KG = zeros(ne+1, ne+1);

for i=1:2
   ke(1,1,i) = 1*Ae(i)*Ee(i)/Le(i);
   ke(1,2,i) = -1*Ae(i)*Ee(i)/Le(i);
   ke(2,1,i) = -1*Ae(i)*Ee(i)/Le(i);
   ke(2,2,i) = 1*Ae(i)*Ee(i)/Le(i);

   KG(i, i) = KG(i,i) + ke(1,1,i);
   KG(i, i+1) = KG(i,i+1) + ke(1,2,i);
   KG(i+1, i) = KG(i+1,i) + ke(2,1,i);
   KG(i+1, i+1) = KG(i+1,i+1) + ke(2,2,i);
end

disp(ke);
disp(KG);


# Método da penalidade
