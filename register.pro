;;; Program that registers each image to the center of an
;;; array. image_arr is an array containing all of the images for the
;;; object. The 1st and 2nd dimensions are the X and Y dimensions,
;;; respectively. The third dimension of the array is the number of
;;; images. xcen and ycen are the centroid coordinates for all of the
;;; images found in part2.pro.

function register,image_arr,xcen,ycen

  ;;; Find image dimensions and number.
  idim=size(image_arr)
  xdim=idim[1]
  ydim=idim[2]
  nimg=idim[3]

  ;;; Create output array that will contain all of the registered images.
  all_img=dblarr(xdim,ydim,nimg)

  for i1=0,nimg-1 do begin
     
     ;;; Find amount centroid of star needs to be shifted to be placed at
     ;;; the center of the image.
     delx=xdim/2-xcen[i1]
     dely=ydim/2-ycen[i1]
     ;;; Use fshift to be able to shift by fractions of a pixel.
     reg_img=fshift(reform(image_arr[*,*,i1]),delx,dely)
     all_img[*,*,i1]=reg_img

  endfor

;;; Return the registered images in a data cube!   
  return,all_img

end
