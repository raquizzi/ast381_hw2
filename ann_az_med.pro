;;; This function creates a brightness profile for an image. It
;;; accepts as inputs an image data cube and annulus pixel
;;; width. Since the annuli are centered on the center of the image,
;;; the input data cube needs to be of registered images.

function ann_az_med,image_arr,width
  
idim=size(image_arr)
xdim=idim[1]
ydim=idim[2]
nimg=idim[3]
  
dist_circle,rdist,[xdim,ydim],(xdim/2-1),(ydim/2-1)
num_rings=xdim/(2*width)
prof_arr=dblarr(xdim,ydim,nimg)  
  
for i0=0,nimg-1 do begin

img=reform(image_arr[*,*,i0])
prof=dblarr(xdim,ydim)

ann=where(rdist le width)
ann_med=median(img[ann])
prof[ann]=ann_med
  
ann=where(rdist gt xdim/2)
ann_med=median(img[ann])
prof[ann]=ann_med
  
for i1=1,num_rings-1 do begin

ann=where((rdist le (i1+1)*width) and (rdist gt i1*width))
ann_med=median(img[ann])
prof[ann]=ann_med
  
endfor

prof_arr[*,*,i0]=prof
   
endfor

return,prof_arr
  
end
