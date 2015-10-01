;;; This code takes the final image output from hw2.pro to find the
;;; centroids of the companions and calculate their PAs and projected separation

home='/Users/ram/Dropbox/ut/2015fa/ast381/hw2/'

;;; ROXs 12 folder home
rox12_home=home+'roxs12/'

;;; ROXs 42B folder home
rox42_home=home+'roxs42b/'

obj_home=[rox12_home,rox42_home]

;;; Read the images!!!
rox12_p4=readfits(obj_home[0]+'p4med.fits',hdr,/silent)
rox12_p5=readfits(obj_home[0]+'p5bmed.fits',hdr,/silent)
rox12_p6=readfits(obj_home[0]+'p6med.fits',hdr,/silent)
rox12_p7=readfits(obj_home[0]+'p7med.fits',hdr,/silent)
rox42_p4=readfits(obj_home[1]+'p4med.fits',hdr,/silent)
rox42_p5=readfits(obj_home[1]+'p5bmed.fits',hdr,/silent)
rox42_p6=readfits(obj_home[1]+'p6med.fits',hdr,/silent)
rox42_p7=readfits(obj_home[1]+'p7med.fits',hdr,/silent)

;;; I looked at the final output to have a guess for the companion
;;; centroid. p7med.fits for ROXs 12 was weird in that it wasn't able to
;;; find a centroid with the FWHM set to 3. ROXs 42B appears to have
;;; two companions. I found both of their parameters. This output was then
;;; printed to a text file (and also tabulated in my final homework write-up).
cntrd,rox12_p4,486,690,x4,y4,3
cntrd,rox12_p5,486,690,x5,y5,3
cntrd,rox12_p6,486,690,x6,y6,3
cntrd,rox12_p7,486,690,x7,y7,3

openw,1,obj_home[0]+'comp_pos.txt',/append
printf,1,x4,y4,' p4med'
printf,1,x5,y5,' p5bmed'
printf,1,x6,y6,' p6med'
printf,1,x7,y7,' p7med'
close,1

cntrd,rox42_p4,631,513,x4a,y4a,3
cntrd,rox42_p5,631,513,x5a,y5a,3
cntrd,rox42_p6,631,513,x6a,y6a,3
cntrd,rox42_p7,631,513,x7a,y7a,3

openw,1,obj_home[1]+'compa_pos.txt',/append
printf,1,x4a,y4a,' p4med'
printf,1,x5a,y5a,' p5bmed'
printf,1,x6a,y6a,' p6med'
printf,1,x7a,y7a,' p7med'
close,1

cntrd,rox42_p4,553,471,x4b,y4b,3
cntrd,rox42_p5,553,471,x5b,y5b,3
cntrd,rox42_p6,553,471,x6b,y6b,3
cntrd,rox42_p7,553,471,x7b,y7b,3

openw,1,obj_home[1]+'compb_pos.txt',/append
printf,1,x4b,y4b,' p4med'
printf,1,x5b,y5b,' p5bmed'
printf,1,x6b,y6b,' p6med'
printf,1,x7b,y7b,' p7med'
close,1

;;; Pixel Scale was found in the original headers of the Keck data.
pxscl=.009952
rox12b_xcoo=[x4,x5,x6,x7]
rox12b_ycoo=[y4,y5,y6,y7]
rox42b_xcoo=[x4a,x5a,x6a,x7a]
rox42b_ycoo=[y4a,y5a,y6a,y7a]
rox42c_xcoo=[x4b,x5b,x6b,x7b]
rox42c_ycoo=[y4b,y5b,y6b,y7b]

;;; Math to find the projected separation in arcseconds.
rox12b_prosep=pxscl*sqrt((512.-rox12b_xcoo)^2+(512.-rox12b_ycoo)^2)
rox42b_prosep=pxscl*sqrt((512.-rox42b_xcoo)^2+(512.-rox42b_ycoo)^2)
rox42c_prosep=pxscl*sqrt((512.-rox42c_xcoo)^2+(512.-rox42c_ycoo)^2)

;;; Math to find the PAs in degrees.
rox12b_pa=asin((512.-rox12b_xcoo)*pxscl/rox12b_prosep)*180./!pi
rox42b_pa=360.0+asin((512.-rox42b_xcoo)*pxscl/rox42b_prosep)*180./!pi
rox42c_pa=180.0+atan((-512.+rox42c_xcoo)/(512.-rox42c_ycoo))*180./!pi

;;; Print it all out!!! Also tabulated in my homework write-up.
print,rox12b_prosep,rox12b_pa
print,rox42b_prosep,rox42b_pa
print,rox42c_prosep,rox42c_pa

end
