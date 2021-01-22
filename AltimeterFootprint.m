clear all

R0e=785e3; %Envisat = 785; jason-2 = 1336
R0j=1336e3; 
Re=6371*1000; % km x 1000 = m
c=3e8; %m/s
tau=3.125e-9; %pulse length
Hw=0:15;

re=((c.*tau + 2.*Hw).*R0e./(1+R0e./Re)).^.5;
rj=((c.*tau + 2.*Hw).*R0j./(1+R0j./Re)).^.5;

plot(Hw,re./1000,Hw,rj./1000)