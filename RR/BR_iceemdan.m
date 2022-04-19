tic;
for j=1:length(matData)
clear Z Y;
numSegments = 16; % number of segments
Z = PPGsig(j).y;
Y = COsig(j).y;
for k = 1:numSegments
    clear sig imf M s p refsig;
    sig=Z(9000*k-8999:9000*k,1);
    sig=sgolayfilt(sig,3,9);
    [imf]=iceemdan(sig,0.2,5,2000,1);

    Fs=300;
    N = length(sig);
    %t = [0:N-1]/Fs;
    dF = Fs/N;                    
    f = -Fs/2:dF:Fs/2-dF; 
    %M=zeros(14,9000);
    c=0;
    for i=1:size(imf,1)
        clear X maxpeak maxpeakindes;
        X = fftshift(fft(imf(i,:)));
        [maxpeak, maxpeakindes] = max(abs(X)*2);
        if [(abs(f(maxpeakindes)))>=0.05 && (abs(f(maxpeakindes)))<=0.75]
            c=c+1;
            M(c,:)=imf(i,:);
        end
    end
    %M( ~any(M,2), : ) = [];  %rows
    %M( :, ~any(M,1) ) = [];  %columns
  
    clear X maxpeak maxpeakindes;
    if exist('M','var')
        [s,p]=pca(M);
    else
        results(j).iceemdan(1,k)=0;
    end
    
    if exist('s','var')==0
        results(j).iceemdan(1,k)=0;
    else
        X = fftshift(fft(s(:,1)));       
        [maxpeak, maxpeakindes] = max(abs(X)*2);
        results(j).iceemdan(1,k)=abs(f(maxpeakindes));
    end
    clear X refmaxpeak refmaxpeakindes;   
    refsig=Y(9000*k-8999:9000*k,1);
    refsig=refsig-mean(refsig);
    X =fftshift(fft(refsig));           
    [refmaxpeak, refmaxpeakindes] = max(abs(X)*2);
    results(j).iceemdan(2,k)=abs(f(refmaxpeakindes));
    
        if exist('M','var')
        if (size(M,1))==1
            Q(1,:)=M(1,:);
            Q(2,:)=M(1,:);
            [W,H]=nnmf(M,1);
            H(2,:)=zeros(1,size(M,2));
            
        else
            Q= fastICA1(M,2);
            [W,H]=nnmf(M,2);
        end
     
    xcf(1,:) = crosscorr(Q(1,:),H(1,:));
    xcf(2,:) = crosscorr(Q(1,:),H(2,:));
    xcf(3,:) = crosscorr(Q(2,:),H(1,:));
    xcf(4,:) = crosscorr(Q(2,:),H(2,:));

    [x,y]=max(abs(xcf(:,1)));

    switch y
        case 1
            A(1,:)=Q(1,:);A(2,:)=H(1,:);
        case 2
            A(1,:)=Q(1,:);A(2,:)=H(2,:);
        case 3
            A(1,:)=Q(2,:);A(2,:)=H(1,:);
        otherwise
            A(1,:)=Q(2,:);A(2,:)=H(2,:);
    end
    clear s p X refmaxpeak refmaxpeakindes;
     [s,p]=pca(A);
     X = fftshift(fft(s(:,1)));       
     [maxpeak, maxpeakindes] = max(abs(X)*2);
     results(j).iceemdan(3,k)=abs(f(maxpeakindes));
    else
        results(j).iceemdan(3,k)=0;
    end
end
end
save('C:\Users\A S H U\Desktop\RR\output','results');
toc;