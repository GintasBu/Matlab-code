function c=speeditup(conc),

fs=10; tau=0.45;

cm=conc;

t=[0:1:length(cm)]/fs;
dcm_dt=gradient(cm,t);
c=cm+tau*dcm_dt;

