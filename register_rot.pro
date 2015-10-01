;;;Basically the same as register.pro, but also accepts a position
;;;angle array of the PAs for the images' y-axis.

function register_rot,image_arr,xcen,ycen,pa_arr

  idim=size(image_arr)
  xdim=idim[1]
  ydim=idim[2]
  nimg=idim[3]

  sum_img=dblarr(xdim,ydim)
  all_img=dblarr(xdim,ydim,nimg)

  for i1=0,nimg-1 do begin

     delx=512-xcen[i1]
     dely=512-ycen[i1]
     reg_img=fshift(reform(image_arr[*,*,i1]),delx,dely)
     ;;; Rotates image -PA degrees so that North is along y-axis in
     ;;; final image
     rot_img=rot(reg_img,-pa_arr[i1])
      
     all_img[*,*,i1]=rot_img

   endfor
   
   return,all_img

end
