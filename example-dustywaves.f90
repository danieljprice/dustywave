!--------------------------------------------------------------------!
! An example program illustrating the use of the dustywave solution  !
! from Laibe & Price (2011), Mon. Not. Roy. Astron. Soc. 418, 1491L  !
! http://arXiv.org/abs/1106.1736                                     !
! Copyright (c) 2011 Daniel Price and Guillaume Laibe                !
! Distributed under MIT license                                      !
!--------------------------------------------------------------------!
program dustywave_example
 use dustywaves, only:exact_dustywave
 use prompting,  only:prompt
 implicit none
 integer, parameter :: ifile = 11, ifileev = 12
 real, allocatable, dimension(:) :: xplot,vgas,vdust,rhogas,rhodust
 real :: dt,tmax,tmin,time,ampl,cs,Kdragin,lambda
 real :: ekingas,ekindust,ekintot,rhomaxgas,rhomaxdust
 real :: xmin,xmax,dx,rhogasin,rhodustin,grainsize,graindens
 integer :: ierr,i,j,idragtype,nsteps,nx
 character(len=10) :: timestring
 character(len=60) :: filename
 
 print "(/,a)",' DUSTYWAVE exact solution generator (from Laibe & Price 2011)'
 print "(a,/)",' (example program showing use of exact_dustywave subroutine) '
 print "(a)",' All quantities should be entered in a consistent set of units (i.e. code units, cgs, SI etc)'

 !
 !--prompt user for input parameters
 !
 print*
 cs = 1.
 call prompt('Enter sound speed in gas ',cs)
 rhogasin = 1.
 call prompt('Enter initial gas density',rhogasin,0.)
 rhodustin = 1.
 call prompt('Enter dust-to-gas ratio',rhodustin,0.)
 rhodustin = rhodustin*rhogasin

 xmin = 0.
 xmax = 1.
 nx = 100
 print*
 call prompt('Enter xmin',xmin)
 call prompt('Enter xmax',xmax)
 call prompt('Enter number of grid points to use ',nx,1)

 print*
 ampl = 1.e-2
 call prompt('Enter (relative) amplitude of initial perturbation',ampl)
 lambda = 1.
 call prompt('Enter wavelength of initial perturbation',lambda)
 
 idragtype = 1
 print "(/,a)",' 1) Constant drag coefficient '
 print "(a)",' 2) Epstein drag '
 call prompt('Enter drag type ',idragtype,1,2)
 
 Kdragin = 1.
 select case(idragtype)
 case(2)
    call prompt('Enter grain size ',grainsize)
    call prompt('Enter intrinsic grain density',graindens)
    Kdragin = rhogasin*cs/(graindens*grainsize)
    print "(a)",' Drag coefficient due to Epstein drag = ',Kdragin
 case default
    call prompt('Enter drag coefficient ',Kdragin)
 end select

 print*
 tmin = 0.
 tmax = 5.
 dt = 0.1
 call prompt('Enter start time',tmin,0.)
 call prompt('Enter end time',tmax,0.)
 call prompt('Enter time interval to write output',dt,0.,tmax-tmin)
 nsteps = int((tmax-tmin)/dt) + 1

 allocate(xplot(nx),vgas(nx),vdust(nx),rhogas(nx),rhodust(nx),stat=ierr)
 if (ierr.ne.0) stop 'error allocating memory: aborting'

 !
 !--setup spatial grid to compute solution on
 !
 dx = (xmax - xmin)/real(nx)
 do i=1,nx
    xplot(i) = xmin + (i-1)*dx
 enddo

 !
 !--open an output file for the time evolution of the kinetic energy
 !
 open(unit=ifileev,file='dustywave-energies.out',status='replace',form='formatted',iostat=ierr)
 write(ifileev,"(a)") '# [time][Ekin(tot)][Ekin(gas)][rhomax(gas)][rhomax(dust)]'
 !
 !--output one file per time interval
 !
 do i=1,nsteps
    print "(80('-'))"
    time = (i-1)*dt
    call exact_dustywave(time,ampl,cs,Kdragin,lambda,xmin,rhogasin,rhodustin,xplot,vgas,vdust,rhogas,rhodust,ierr)
    if (ierr.eq.0) then
       write(timestring,"(f10.3)") time
       filename = 'dustywave-t'//trim(adjustl(timestring))//'.out'
       print "(a)",' WRITING to file '//trim(filename)
       open(unit=ifile,file=trim(filename),status='replace',form='formatted',iostat=ierr)
       if (ierr.ne.0) then
          print "(a)",' ERROR opening '//trim(filename)//' for output'
       else
          write(ifile,"(a)") '# [x][vgas][vdust][rhogas][rhodust]'
          do j=1,nx
             write(ifile,*) xplot(j),vgas(j),vdust(j),rhogas(j),rhodust(j)
          enddo
          close(unit=ifile)
       endif
       !
       !--compute energies by integrating over the domain
       !
       ekingas    = 0.
       ekindust   = 0.
       rhomaxgas  = -1.
       rhomaxdust = -1.
       do j=1,nx
          ekingas = ekingas + 0.5*rhogas(j)*vgas(j)**2*dx
          ekindust = ekindust + 0.5*rhodust(j)*vdust(j)**2*dx
          rhomaxgas = max(rhomaxgas,rhogas(j))
          rhomaxdust = max(rhomaxdust,rhodust(j))
       enddo
       ekintot = ekingas + ekindust       
       write(ifileev,*) time,ekintot,ekingas,ekindust,rhomaxgas,rhomaxdust
    else
       print "(a)",' ERROR computing dusty wave solution'
    endif
 enddo
 print "(80('-'))"

 close(ifileev)
 !
 !--clean up
 !
 if (allocated(xplot)) deallocate(xplot)
 if (allocated(vgas)) deallocate(vgas)
 if (allocated(vdust)) deallocate(vdust)
 if (allocated(rhogas)) deallocate(rhogas)
 if (allocated(rhodust)) deallocate(rhodust)

end program dustywave_example
