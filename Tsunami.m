%space and time steps
delta_y=111320;
delta_x=102470;
delta_t=250;

time=0:delta_t:3*86400;
x=0:359; 
y=-89:90;

load topo;

g=9.8;
[a,b]=size(topo);
blank=zeros(a+2,b+2);

depth=blank;
depth(2:a+1,2:b+1)=topo;

depth(1,:)=depth(2,:); %top row
depth(:,1)=depth(:,2); %left col
depth(length(y)+2,:)=depth(length(y)+1,:); %bottom row
depth(:,length(x)+2)=depth(:,length(x)+1); %right col

h=blank;
h(37+90,143)=17.5;
h(38+90,143)=18.5;
h(37+90,144)=17.5;
h(38+90,144)=20.5;
h(39+90,144)=15.5;

past_h=h;
newh=blank;

for i=1:length(time) %through time
            h(1,:)=h(2,:); %top row
            h(:,1)=h(:,2); %left col
            h(length(y),:)=h(length(y)-1,:); %bottom row
            h(:,length(x))=h(:,length(x)-1); %right col

    for j=2:length(y)-1 %down
        for k=2:length(x)-1 %across           
            if depth(j,k)>0% on land
                newh(j,k)=0;
            else
                c=sqrt(-g*depth(j,k));
                center=h(j,k);
            
                if depth(j,k+1)>0 %land to north
                    N=center;
                else
                    N=h(j,k+1);
                end
                
                if depth(j,k-1)>0 %land to south
                    S=center;
                else
                    S=h(j,k-1);
                end
                
                if depth(j-1,k)>0 %land to west
                    W=center;
                else
                    W=h(j-1,k);
                end
            
                if depth(j+1,k)>0 %land to east
                    E=center;
                else
                    E=h(j+1,k);
                end
            
               newh(j,k)=c^2*((W-2*center+E)/delta_x^2 + (N-2*center+S)/delta_y^2)*delta_t^2+2*center-past_h(j,k);         
       
            end
        end
    end
    
    courant=sqrt(-9.8*depth(j,k))*delta_t/delta_x;
       if courant >1
            courant
            pause;
       end
    
    hold on;
    imagesc(x,y,newh(2:length(y),2:length(x)));
    colormap(topomap1);
    axis xy;
    colorbar;
    
    contour(0:359,-89:90,topo,[0 0],'k');
    axis equal;
    box on;

    legend(['t=',num2str(time(i)/3600),' hours'])
    hold off;
    shg;
    
    
    past_h=h;
    h=newh;
 
end
