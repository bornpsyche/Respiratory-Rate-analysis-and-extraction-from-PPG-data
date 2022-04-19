clear Z n sig imf M s p;
load('bidmc_data.mat');
addpath('C:\Users\A S H U\Desktop\RR\Functions');
Z=data(1).ppg.v;
Y = data(1).ref.resp_sig.imp.v; 
n=1;
sig=Z(3750*n-3749:3750*n,1);
sig = sgolayfilt(sig,3,9);
[imf]=eemd(sig,0.2,5,2000);
%[imf]=emd(sig,'MAXMODES',10);
%[imf]=eemd(sig,0.2,5,2000);
%[imf]=ceemd1(sig,0.2,5,10);
%[imf]=iceemdan(sig,0.2,5,2000,1);
%[imf]=ceemdan(sig,0.2,5,2000);


Fs=125;
N = length(sig);
t = [0:N-1]/Fs;
figure(1);
subplot(211);
plot(t,sig,'-b');
xlabel('Time(Seconds)');ylabel('Amplitude(Volts)');title('PPG Signal');
axis([0  30    ylim]);

dF = Fs/(N);                    
f = -Fs/2:dF:Fs/2-dF;  
clear M;
c=0;
figure(2);
for i=1:(size(imf,1)-1)
    subplot(size(imf,1),1,i);
    plot(t,imf(i,:));
    ylabel((sprintf('IMF %d', i)));
    hold on;
    X = fftshift(fft(imf(i,:)));
    [maxpeak, maxpeakindes] = max(abs(X)*2);
    if [(abs(f(maxpeakindes)))>=0.05 & (abs(f(maxpeakindes)))<=0.75]
        c=c+1;
        M(c,:)=imf(i,:);

    end
end
subplot(size(imf,1),1,size(imf,1));
plot(t,imf(size(imf,1),:));
ylabel('Res');xlabel('Time(Seconds)');

figure(3);
for i=1:size(M,1)
    subplot(size(M,1),1,i);
    plot(t,M(i,:));
    hold on
end
title('Selected IMFs for RR est');
[s,p]=pca(M);

figure(4);
subplot(211);
plot(t,s(:,1),'-b');
xlabel('Time(Seconds)');ylabel('Amplitude(Volts)');title('First PC for RR group of IMFs');
axis([0  30    ylim]);

clear X maxpeak maxpeakindes;
X = fftshift(fft(s(:,1)));
         
figure(5);
plot(f,abs(X)/N);
xlabel('Frequency (in hertz)');
title('Magnitude Response of estimated RR sig');
axis([0  3    ylim]);

clear X refmaxpeak refmaxpeakindes;
refsig=Y(3750*n-3749:3750*n,1);
refsig=refsig-mean(refsig);
X =fftshift(fft(refsig));
figure(6);
subplot(211);
plot(t,refsig,'-b');
xlabel('Time(Seconds)');ylabel('Amplitude(Volts)');title('Reference Resp Sig');
axis([0  30    ylim]);
figure(7);
plot(f,abs(X)/N);
xlabel('Frequency (in hertz)');
title('Magnitude Response of Refence sig');
axis([0  3    ylim]);
