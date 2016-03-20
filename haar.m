% This program is used to compress a given image
% Author : Ashwini Singh-HW 3 Computer Vision
% filename  : buttress.jpg or lappi.jpg
% threshold : 20
% Works for RGB images as well.

function [n] = haar(filename, threshold)
% Check for correct input paremeters
if (nargin < 1)
error(' Not an image, please give a proper image name ');
elseif(nargin == 1)
     threshold = 0;
elseif(nargin == 2)
P=((imread(filename)));
end
flag1=0;
% For RGB Images
if (size(P,3)>1)
P=rgb2lab(P);
a=P(:,:,2);
b=P(:,:,3);
P=P(:,:,1);
flag1=1;
end
P=double(P);
n=max(size(P,1),size(P,2));
% Get the nearest highest value of n, which is power of 2.
% If n is 600 then highest 2 to the power index is 1024.
for i=1:n
   if(pow2(i)>=n)
       index=i;
       n=pow2(i);
       break;
   end
end
% Padding start row and column
[extra_row,extra_col]=size(P);

P(size(P,1)+1:n,size(P,2)+1:n)=0;
flag=0;
m=n;
% Linear Algebraic approach 
A3=ones(n,n);
for i=1:index
A=zeros(n,n);
% odd is for positive sign and even is for negative sign
odd=1;even=1; 
for j=1:2:n
    if(odd==j)
      A(j,even)=1/sqrt(2);
      A(j+1,even)=1/sqrt(2);
      A(j,even+(n/2))=1/sqrt(2);
      A(j+1,even+(n/2))=-1/sqrt(2);
    end
      odd=odd+2;
      even=even+1;    

end
if(flag==1)
 for k=(n):(m-1)
   A(k+1,k+1)=1;
    
end   
end
A2=A;
   flag=1; 
   if(~(i==1))
   A3=A3*A2; 
   else
   A3=A2;    
   end
    n=n/2;  % After each iteration, matrix is divided into 4 parts and one of them is taken at a time
end

W=P*A3;  % Row transformed matrix 
P=W'*A3;
P=P';  % Column transformed matrix
T = P;
% Thresholding: clip off all the lower and upper bounds of threshold
for i = 1  : size(P,1)
    for j = 1 : size(P,2)
if(abs(P(i,j)) <= threshold)
    T(i,j) = 0;
end
    end
end

%Inverse transformation
W = (inv(A3));
T = T*W;

P=W'*T;
% Clip off extra padded pixels
P(extra_row+1:end,:)=[];
P(:,extra_col+1:end)=[];
if flag1==1
P(:,:,2)=a;
P(:,:,3)=b;
P=lab2rgb(P);
imshow(P);
imwrite((P),['new' filename '.jpg']);
else
imshow(uint8(P));
imwrite(uint8(P),['new' filename '.jpg']);
end
toc


