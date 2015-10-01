;;; This is basically an program that produces the output for Homework 2

home='/Users/ram/Dropbox/ut/2015fa/ast381/hw2/'

;;; ROXs 12 folder home
rox12_home=home+'roxs12/'

;;; ROXs 42B folder home
rox42_home=home+'roxs42b/'

obj_home=[rox12_home,rox42_home]

for i0=0,1 do begin

   images=file_search(obj_home[i0]+'calibrated/','*.fits')
   img_arr=dblarr(1024,1024,n_elements(images))
   aaz_arr=dblarr(1024,1024,n_elements(images))
   pa_arr=dblarr(n_elements(images))

   for i1=0,n_elements(images)-1 do begin

      img=readfits(images[i1],hdr,/silent)
      img_arr[*,*,i1]=img
      parang=float(sxpar(hdr,'PARANG'))
      rotpposn=float(sxpar(hdr,'ROTPPOSN'))
      el=float(sxpar(hdr,'EL'))
      instangl=float(sxpar(hdr,'INSTANGL'))
      pa_arr[i1]=parang+rotpposn-el-instangl
      
   endfor
   
   readcol,obj_home[i0]+'centroids.txt',x,y,filename,format='(d,d,a)'
   
   part3=register(img_arr,x,y)
   p3sum=total(part3,3)
   p3med=median(part3,dimension=3)

   writefits,obj_home[i0]+'p3sum.fits',p3sum
   writefits,obj_home[i0]+'p3med.fits',p3med
   
   ;;; For each object, I used a broad ring 50 pixels wide (18 < r <
   ;;; 68 from the center of the registered image) to scale the
   ;;; potential calibrator frame.
   dist_circle,rdist,[1024,1024],511,511
   broad=where((rdist gt 18.) and (rdist lt 68.))
   
   part4=register_rot(img_arr,x,y,pa_arr)
   p4sum=total(part4,3)
   p4med=median(part4,dimension=3)

   writefits,obj_home[i0]+'p4sum.fits',p4sum
   writefits,obj_home[i0]+'p4med.fits',p4med

   ;;; Create brightness profile array from output of Part 3. To be
   ;;; used for Part 5.
   aaz_arr=ann_az_med(part3,2)

   ;;; Create final image array for Part 5.
   img_aaz=dblarr(1024,1024,n_elements(images))

   ;;; Create final image array for Part 6.
   img_adi=dblarr(1024,1024,n_elements(images))
   
   ;;; Create final image array for Part 7. Also create array to store
   ;;; Chi-squared values of subtracting images from each other.
   img_psf=dblarr(1024,1024,n_elements(images))
   psf_chi=dblarr(n_elements(images),n_elements(images))
   
   for i2=0,n_elements(images)-1 do begin

      ;;; This step is for Part 5. It subtracts the azimuthal-median brightness profile
      ;;; from the image that created it and stores it for later
      ;;; registration and rotation.
      img_aaz[*,*,i2]=part3[*,*,i2]-aaz_arr[*,*,i2]

      ;;; This step is for Part 6. It uses the output of Part 3, then
      ;;; uses the "broad" part of each image to calculate a scale
      ;;; factor. This scale factor is multiplied by the median image
      ;;; from Part 3, then subtracted from the original science
      ;;; image, then stored in the image array "img_adi"
      img_adi_tmp=part3[*,*,i2]
      scale=median(img_adi_tmp[broad]/p3med[broad])
      img_adi[*,*,i2]=img_adi_tmp-scale*p3med

      ;;; This step is for Part 7. It scales the science images to
      ;;; each other, then determines the Chi-squared residuals after
      ;;; subracting the potential calibrator from it. The Chi-squared
      ;;; values are stored in psf_chi.
      for i3=0,n_elements(images)-1 do begin
         img_psf_tmp=part3[*,*,i3]
         bpsf=median(img_adi_tmp[broad]/img_psf_tmp[broad])
         chisquared=total((img_adi_tmp-bpsf*img_psf_tmp)^2/(bpsf*img_psf_tmp))
         psf_chi[i2,i3]=chisquared
      endfor
      ;;; The diagonal elements of the Chi-squared arrays need to be
      ;;; set to large numbers, because subtracting an image from
      ;;; itself would obviously leave no residuals. The science image
      ;;; whose PSF best matches each image is then scaled and subtracted
      ;;; and stored in the image array img_psf.
      psf_chi[i2,i2]=1d20
      temp=min(reform(psf_chi[i2,*]),minchi)
      ;print,images[i2],' ',images[minchi],' ',temp
      img_psf_tmp=part3[*,*,minchi]
      bpsf=median(img_adi_tmp[broad]/img_psf_tmp[broad])
      img_psf[*,*,i2]=img_adi_tmp-bpsf*img_psf_tmp

      ;;; This was commented out so that the best-fit-PSFs wouldn't
      ;;; continually be appended to the text file. The final images
      ;;; used for PSFs are tabulated in the latex document
      ;;; I'll turn in.
      ;openw,1,obj_home[i0]+'p7_best-psf.txt',/append
      ;printf,1,filename[i2],' ',filename[minchi]
      ;close,1
   endfor

   ;;; Since I registered the images to the center and used these to
   ;;; created brightness profiles, the classical adi images, and the
   ;;; best-fit-PSF images, I created a "no shift" array to feed to
   ;;; register.pro and register_rot.pro so an extraneous shift
   ;;; wouldn't occur.
   ns=dblarr(n_elements(images))+512

   ;;; img_aaz was the brightness profile subtracted array of Part 3
   ;;; images. No rotation here though.
   part5a=register(img_aaz,ns,ns)
   p5asum=total(part5a,3)
   p5amed=median(part5a,dimension=3)

   writefits,obj_home[i0]+'p5asum.fits',p5asum
   writefits,obj_home[i0]+'p5amed.fits',p5amed

   ;;; Same as above, but with rotation.
   part5b=register_rot(img_aaz,ns,ns,pa_arr)
   p5bsum=total(part5b,3)
   p5bmed=median(part5b,dimension=3)

   writefits,obj_home[i0]+'p5bsum.fits',p5bsum
   writefits,obj_home[i0]+'p5bmed.fits',p5bmed

   ;;; img_adi is the Part 3 image output less its median image.
   part6=register_rot(img_adi,ns,ns,pa_arr)
   p6sum=total(part6,3)
   p6med=median(part6,dimension=3)

   writefits,obj_home[i0]+'p6sum.fits',p6sum
   writefits,obj_home[i0]+'p6med.fits',p6med
   
   ;;; img_psf is the Part 3 image output less the other science image
   ;;; whose PSF most closely matches. These are then run through
   ;;; register_rot.pro to create sum and median images with the output.
   part7=register_rot(img_psf,ns,ns,pa_arr)
   p7sum=total(part7,3)
   p7med=median(part7,dimension=3)

   writefits,obj_home[i0]+'p7sum.fits',p7sum
   writefits,obj_home[i0]+'p7med.fits',p7med

endfor
  
end
