clear all
clc

% NUMBER OF ELEMENTS
ne = 2;

% ELEMENT 1
Ae(1) = 9.0E+02; % mm^2
Ee(1) = 7.0E+04; % MPa
le(1) = 2.0E+02; % mm

% ELEMENT 2
Ae(2) = 1.2E+03; % mm^2
Ee(2) = 2.0E+05; % MPa
le(2) = 3.0E+02; % mm


% ELEMENT AND GLOBAL STIFFNESS MATRICES
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

% PRINTIG MATRICES
ke % elements matrices

KG % global matrix

% SAVING ORIGINAL STIFFNESS MATRIX
KG_ORIG = KG;

% NATURAL BOUNDARY CONDITIONS (FORCES AND MOMENTS)
F = zeros(ne+1,1);
F(2,1) = 200.0E+03;

% SAVING ORIGINAL FORCE VECTOR
F_ORIG = F;

% APPLYINNG ESSENTIAL (DISPLACEMENT) BOUNDARY CONDITIONS
% USING THE DIRECT METHOD
% MODIFYING GLOBAL STIFFNESS MATRIX
KG(1,:) = 0.0;
KG(:,1) = 0.0;
KG(1,1) = 1.0;

KG(ne+1,:)    = 0.0;
KG(:,ne+1)    = 0.0;
KG(ne+1,ne+1) = 1.0;

% PRINTIG MATRIX WITH BOUNDARY CONDITIONS
KG % global matrix

% MODIFYING GLOBAL FORCE VECTOR
F(1,1) = 0.0; % CONSEQUENCE OF ESSENTIAL BOUDARY CONDITION
F(ne+1,1) = 0.0; % CONSEQUENCE OF ESSENTIAL BOUDARY CONDITION

% PRINTING GLOBAL FORCE VECTOR (F)
F

% SOLVING THE PROBLEM WITH ALL BOUNDARY CONDITIONS
Q = inv(KG)*F;

%PRINTING GLOBAL NODAL DISPLACEMENTS (Q)
Q

% CALCULATING REACTION FORCES
R = KG_ORIG*Q - F;

% PRNNTING REACTION FORCES
R