clear Z n sig imf M s p V Q H W A;
Z=PPGsig(1).y;
n=1;
sig=Z(9000*n-8999:9000*n,1);
sig = sgolayfilt(sig,3,9);
sig=sig-mean(sig);

set(gcf,'color','w');
[imf]=eemd(sig,0.2,5,2000);
Fs=300;
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
set(gcf,'color','w');
set(gca, 'Position', [-0.1,0.1,1.2,0.85])
set(gca, 'OuterPosition', [0,0,1,1])
for i=1:(size(imf,1)-1)
    subplot(size(imf,1),1,i);
    plot(t,imf(i,:));
    ylabel((sprintf('IMF %d', i)));set(gca,'XTick',[], 'YTick', []);
    hold on;
    X = fftshift(fft(imf(i,:)));
    [maxpeak, maxpeakindes] = max(abs(X)*2);
    if [(abs(f(maxpeakindes)))>=0.05 && (abs(f(maxpeakindes)))<=0.75]
        c=c+1;
        q=i;
        M(c,:)=imf(i,:)

    end
end
subplot(size(imf,1),1,size(imf,1));
plot(t,imf(size(imf,1),:));
ylabel('Res');xlabel('Time(Seconds)');set(gca, 'YTick', []);

figure(3);
set(gcf,'color','w');
for i=1:size(M,1)
    subplot(size(M,1),1,i);
    plot(t,M(i,:));
    ylabel((sprintf('IMF %d',q-size(M,1)+i)));set(gca, 'YTick', []);
    hold on
end
xlabel('Time(Seconds)');

V=M-min(M);

Q= fastICA1(M,2);
[W,H]=nnmf(M,2);

figure(4);
set(gcf,'color','w');
subplot(211);
plot(t,Q(1,:),'-b');
xlabel('Time(Seconds)');ylabel('S1');title('ICA Components');
axis([0  30    ylim]);
subplot(212);
plot(t,Q(2,:),'-b');
xlabel('Time(Seconds)');ylabel('S2');
axis([0  30    ylim]);

figure(6);
set(gcf,'color','w');
subplot(211);
plot(t,H(1,:),'-b');
xlabel('Time(Seconds)');ylabel('H1');title('Decomposed source signals after NMF');
axis([0  30    ylim]);
subplot(212);
plot(t,H(2,:),'-b');
xlabel('Time(Seconds)');ylabel('H2');
axis([0  30    ylim]);

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

[s,p]=pca(A);

figure(7);
set(gcf,'color','w');
subplot(211);
plot(t,s(:,1),'-b');
xlabel('Time(Seconds)');ylabel('Amplitude(Volts)');title('First PC of the selected surrogate signals');
axis([0  30    ylim]);

X = fftshift(fft(s(:,1)));
         

figure;
plot(f,abs(X)/N);
xlabel('Frequency (in hertz)');
title('Magnitude Response');
axis([0  3    ylim]);

