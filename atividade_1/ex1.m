% Determinar: Deslocamentos nodais, tensões de cada material, forças de reação
% Método: direto
% Elemento 1: L = 300mm; A = 2400 m²; E = 70 10⁹ N/m²
% Elemento 2: L = 400 mm; A = 600 m²; E = 200 10⁹ N/m²

clear all
clc

% NÚMERO DE ELEMENTOS
ne = 2;

% ELEMENTO 1
Ae(1) = 2.4E+08; % Área transversal do elemento 1 em mm^2
Ee(1) = 7.0E+04; % Módulo de elasticidade do elemento 1 em MPa
le(1) = 3.0E+02; % Comprimento do elemento 1 em mm

% ELEMENTO 2
Ae(2) = 6.0E+07; % Área transversal do elemento 2 em mm^2
Ee(2) = 2.0E+05; % Módulo de elasticidade do elemento 2 em MPa
le(2) = 4.0E+02; % Comprimento do elemento 2 em mm

% MATRIZES DE RIGIDEZ DO ELEMENTO E MATRIZ DE RIGIDEZ GLOBAL
KG = zeros(ne+1,ne+1);

for i=1:2
  ke(1,1,i) =  1.0*Ae(i)*Ee(i)/le(i);
  ke(1,2,i) = -1.0*Ae(i)*Ee(i)/le(i);
  ke(2,1,i) = -1.0*Ae(i)*Ee(i)/le(i);
  ke(2,2,i) =  1.0*Ae(i)*Ee(i)/le(i);

  KG(i,i)     = KG(i,i)     + ke(1,1,i);
  KG(i,i+1)   = KG(i,i+1)   + ke(1,2,i);
  KG(i+1,i)   = KG(i+1,i)   + ke(2,1,i);
  KG(i+1,i+1) = KG(i+1,i+1) + ke(2,2,i);
end

% EXIBIÇÃO DAS MATRIZES DE RIGIDEZ DO ELEMENTO
ke % Matrizes de rigidez dos elementos

KG % Matriz de rigidez global

% SALVANDO A MATRIZ DE RIGIDEZ ORIGINAL
KG_ORIG = KG;

% CONDIÇÕES DE CONTORNO NATURAIS (FORÇAS E MOMENTOS)
F = zeros(ne+1,1);
F(2,1) = 200.0E+03; % Aplicando uma força de 200 kN no segundo nó

% SALVANDO O VETOR DE FORÇA ORIGINAL
F_ORIG = F;

% APLICANDO CONDIÇÕES DE CONTORNO ESSENCIAIS (DESLOCAMENTO)
% USANDO O MÉTODO DIRETO
% MODIFICANDO A MATRIZ DE RIGIDEZ GLOBAL
KG(1,:) = 0.0;
KG(:,1) = 0.0;
KG(1,1) = 1.0;

KG(ne+1,:)    = 0.0;
KG(:,ne+1)    = 0.0;
KG(ne+1,ne+1) = 1.0;

% EXIBIÇÃO DA MATRIZ COM CONDIÇÕES DE CONTORNO
KG % Matriz de rigidez global com condições de contorno

% MODIFICANDO O VETOR DE FORÇA GLOBAL
F(1,1) = 0.0; % Consequência da condição de contorno essencial
F(ne+1,1) = 0.0; % Consequência da condição de contorno essencial

% EXIBIÇÃO DO VETOR DE FORÇA GLOBAL (F)
F

% RESOLVENDO O PROBLEMA COM TODAS AS CONDIÇÕES DE CONTORNO
Q = inv(KG)*F; % Vetor de deslocamentos nodais globais

% EXIBIÇÃO DOS DESLOCAMENTOS NODAIS GLOBAIS (Q)
Q

% CALCULANDO AS FORÇAS DE REAÇÃO
R = KG_ORIG*Q - F;

% EXIBIÇÃO DAS FORÇAS DE REAÇÃO
R

% DETERMINAÇÃO DAS TENSÕES EM CADA MATERIAL

% TENSÕES NO ELEMENTO 1
S1 = zeros(ne+1,1);
for i=1:size(S1) 
  S1(i,1) = F(i, 1)/Ae(1);
end
S1

% TENSÕES NO ELEMENTO 2
S2 = zeros(ne+1,1);
for i=1:size(S2) 
  S2(i,1) = F(i, 1)/Ae(2);
end
S2