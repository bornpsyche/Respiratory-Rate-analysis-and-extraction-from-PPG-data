function [modos its]=ceemd1(x,Nstd,NR,MaxIter)
%--------------------------------------------------------------------------
%WARNING: this code needs to include in the same
%directoy the file emd.m developed by Rilling and Flandrin.
%This file is available at %http://perso.ens-lyon.fr/patrick.flandrin/emd.html
%We use the default stopping criterion.
%We use the last modification: 3.2007
% -------------------------------------------------------------------------
%  OUTPUT
%   modos: contain the obtained modes in a matrix with the rows being the modes
%   its: contain the iterations needed for each mode for each realization
%
%  INPUT
%  x: signal to decompose
%  Nstd: noise standard deviation
%  NR: number of realizations
%  MaxIter: maximum number of sifting iterations allowed.
% -------------------------------------------------------------------------
%   Syntax
%
%   modos=eemd(x,Nstd,NR,MaxIter)
%  [modos its]=eemd(x,Nstd,NR,MaxIter)
% -------------------------------------------------------------------------
%  NOTE:   if Nstd=0 and NR=1, the EMD decomposition is obtained.
% -------------------------------------------------------------------------
% EEMD was introduced in 
% Wu Z. and Huang N.
% "Ensemble Empirical Mode Decomposition: A noise-assisted data analysis method". 
% Advances in Adaptive Data Analysis. vol 1. pp 1-41, 2009.
%--------------------------------------------------------------------------
% The present EEMD implementation was used in
% M.E.TORRES, M.A. COLOMINAS, G. SCHLOTTHAUER, P. FLANDRIN,
%  "A complete Ensemble Empirical Mode decomposition with adaptive noise," 
%  IEEE Int. Conf. on Acoust., Speech and Signal Proc. ICASSP-11, pp. 4144-4147, Prague (CZ)
%
% in order to compare the performance of the new method CEEMDAN with the performance of the EEMD.
%
% -------------------------------------------------------------------------
% Date: June 06,2011
% Authors:  Torres ME, Colominas MA, Schlotthauer G, Flandrin P.
% For problems with the code, please contact the authors:   
% To:  macolominas(AT)bioingenieria.edu.ar 
% CC:  metorres(AT)santafe-conicet.gov.ar
% -------------------------------------------------------------------------
%  This version was run on Matlab 7.10.0 (R2010a)
%--------------------------------------------------------------------------

desvio_estandar=std(x);
x=x/desvio_estandar;
p=randn(size(x));
xconruido1=x+Nstd*p;
xconruido2=x-Nstd*p;
[modos1, o1, it1]=emd(xconruido1,'MAXITERATIONS',MaxIter);
[modos2, o2, it2]=emd(xconruido2,'MAXITERATIONS',MaxIter);
if size(modos1,1)<size(modos2,1)
    newA = zeros(size(modos2));
    newA(1:size(modos1,1),:) = modos1;
    newB=modos2;
else
    newB = zeros(size(modos1));
    newB(1:size(modos2,1),:) = modos2;
    newA=modos1;
end
modos=0.5*(newA+newB);
modos=modos/NR;
iter=it1;
if NR>=2
    for i=2:NR
        xconruido1=x+Nstd*randn(size(x));
        xconruido2=x-Nstd*randn(size(x));
        [temp1, ort1, it1]=emd(xconruido1,'MAXITERATIONS',MaxIter);
        [temp2, ort2, it2]=emd(xconruido2,'MAXITERATIONS',MaxIter);
        
        if size(temp1,1)<size(temp2,1)
            newA = zeros(size(temp2));
            newA(1:size(temp1,1),:) = temp1;
            newB=temp2;
        else
            newB = zeros(size(temp1));
            newB(1:size(temp2,1),:) = temp2;
            newA=temp1;
        end

        temp=0.5*(newA+newB);
        temp=temp/NR;
        it=it1;
        lit=length(it);
        [p liter]=size(iter);
        if lit<liter
            it=[it zeros(1,liter-lit)];
        end;
        if liter<lit
            iter=[iter zeros(p,lit-liter)];
        end;
        
        iter=[iter;it];
        
        [filas columnas]=size(temp);
        [alto ancho]=size(modos);
        diferencia=alto-filas;
        if filas>alto
            modos=[modos; zeros(abs(diferencia),ancho)];
        end;
        if alto>filas
            temp=[temp;zeros(abs(diferencia),ancho)];
        end;
        
        modos=modos+temp;
    end;
end;
its=iter;
modos=modos*desvio_estandar;