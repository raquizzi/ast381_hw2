;;; This program looks for the calibrated images of each object in
;;; their respective folders and finds the centroid based on a
;;; guess. The initial guess came from me looking at the image.

home='/Users/ram/Dropbox/ut/2015fa/ast381/hw2/'

;;; ROXs 12 folder home and initial centroid guess
rox12_home=home+'roxs12/'
x_rox12=613
y_rox12=471

;;; ROXs 42B folder home and initial centroid guess
;;; Something happened with the position of the corona graph on
;;; N2.20110623.33576_drp.fits - could not find a centroid. I did not
;;; use it for the rest of the assignment
rox42_home=home+'roxs42b/'
x_rox42=611
y_rox42=470

obj_home=[rox12_home,rox42_home]
x_guess=[x_rox12,x_rox42]
y_guess=[y_rox12,y_rox42]

;;; Find calibrated images, read them, and find centroid using IDL
;;; cntrd routine. Printed output to text file, stored in each
;;; object's folder
for i0=0,1 do begin

   ;;; Find images of the object
   images=file_search(obj_home[i0]+'calibrated/','*.fits')

   for i1=0,n_elements(images)-1 do begin
      
      ;;; Read fits files
      img=readfits(images[i1],hdr,/silent)
      
      ;;; Create string of filename
      filename=strmid(images[i1],25,/reverse_offset)
      
      ;;; Find centroid
      cntrd,img,x_guess[i0],y_guess[i0],xcen,ycen,3

      ;;; Print centroid and filename to text file
      openw,1,obj_home[i0]+'centroids.txt',/append
      printf,1,xcen,ycen,' ',filename
      close,1
      
   endfor

endfor

end
