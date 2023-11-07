pkg load image
pkg load geometry

im = imread('image.jpg');
im_bw=(double(im(:,:,1))+double(im(:,:,2))+double(im(:,:,3)))/3;
im_green = double(im(:,:,2));

im_green(im_green > 190) = 190;

imshow(im_green, [0 255])
f =fspecial("gaussian",[5 5],1);
im_f=imfilter(uint8(im_bw),f);

im_e_delta = edge(uint8(im_green), 'andy', 37);
im_e = edge(uint8(im_bw), 'andy', 5);
im_e_delta_down = edge(uint8(im_f), 'andy', 3.8);

imshow(im_e_delta_down)

im_edged = im_e-im_e_delta;
im_edged(405:1:428, 310) = 0;
im_edged(480, 590:608) = 0;
im_edged(468:523, 312:612) = im_edged(468:523, 312:612) +im_e_delta_down(468:523, 312:612);
imshow(im_edged)

im_cf = bwfill(im_edged,'holes');
imshow(im_cf)

im_z=im;
im_z(:,:,1)=im(:,:,1)+im_cf*100;
figure(3)
imshow(im_z)
hold on

param = zeros()

for i = [13, 20]
  b=bwboundaries(im_cf);
  bx=cell2mat(b(i))(:,2);
  by=cell2mat(b(i))(:,1);
  size(b)
  A=polygonArea([bx by])
  r=sqrt(A/pi)
  C=polygonCentroid([bx by])
  if i == 13
    plot(bx,by,'-r','LineWidth',3)
  else
    plot(bx,by,'-b','LineWidth',3)
  endif
  drawCircle(C(1),C(2),r,'-y','LineWidth',2)

endfor
hold off
