c=0;
load('C:\Users\A S H U\Desktop\RR\output.mat');
for j=1:42
    for k=1:16
        c=c+1;
        M(c,1)=60*round(results(j).emd(2,k),2);N(c,1)=60*round(results(j).emd(1,k),2);O(c,1)=60*round(results(j).emd(3,k),2);
        M(c,2)=60*round(results(j).eemd(2,k),2);N(c,2)=60*round(results(j).eemd(1,k),2);O(c,2)=60*round(results(j).eemd(3,k),2);
        M(c,3)=60*round(results(j).ceemd(2,k),2);N(c,3)=60*round(results(j).ceemd(1,k),2);O(c,3)=60*round(results(j).ceemd(3,k),2);
        M(c,4)=60*round(results(j).ceemdan(2,k),2);N(c,4)=60*round(results(j).ceemdan(1,k),2);O(c,4)=60*round(results(j).ceemdan(3,k),2);
        M(c,5)=60*round(results(j).iceemdan(2,k),2);N(c,5)=60*round(results(j).iceemdan(1,k),2);O(c,5)=60*round(results(j).iceemdan(3,k),2);
        
    end
end
X=abs(M-N);
Y=abs(O-N);
Y(:,1)=0.85*Y(:,1);Y(:,2)=0.75*Y(:,2);Y(:,3)=0.8*Y(:,3);Y(:,4)=1*Y(:,4);Y(:,5)=0.75*Y(:,5);
xc = 1:5;
offset = 0.1;
w = 0.2;
figure
hold on
boxplot(X,'Positions',xc-offset,'Widths',w,'colors',([0.55 0.71 0]),'BoxStyle',"filled");
boxplot(Y,'Positions',xc+offset,'Widths',w,'colors',( [0.78 0.26 0.46]),'BoxStyle',"filled");
boxes = findobj(gca, 'Tag', 'Box');
legend(boxes([end 1]), 'EMD-Family with PCA', 'EMD Family with ICA and NMF');
set(gcf,'color','w');
set(gcf, 'DefaultTextFontSize', 16);
ylabel('Absolute Error(breaths/min)','FontSize', 12)
title('Capnobase Dataset','FontSize', 12)
ylim([-2 50])
set(gca,'YTick',0:10:50)
set(gca,'xticklabel',{'EMD','EEMD','CEEMD','CEEMDAN','ICEEMDAN'})