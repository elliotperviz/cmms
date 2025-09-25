program calc_gdr
  implicit none
  real(8), parameter :: dbin = 0.005d0, rmin = -dbin / 2.d0, rmax = 12.d0
  integer, parameter :: nbin = int( (rmax-rmin) / dbin )
  integer, parameter :: n = 864
  integer :: i, j, k, iconf, istat
  real(8) :: gdr(0:nbin), pos(n,3), x(3)
  real(8) :: xlo, xhi, r, side(3), pbc(3), pi
  character(2) :: at
  character(100) :: input, output

  write(*,*) 'input file, output file?'
  read(*,*) input, output
  
  iconf = 0
  gdr(:) = 0.d0
  open(unit=10,file=input)
  main: do
     read(10,*,iostat=istat)
     if ( istat /= 0 ) exit main 
     iconf = iconf + 1 
     if ( mod(iconf,100) == 0 ) write(*,*) trim(adjustl(input)), iconf
     read(10,*) !timestep
     read(10,*) 
     read(10,*) !natoms
     read(10,*) 
     do i = 1, 3
        read(10,*) xlo, xhi
        side(i) = xhi - xlo
     end do
     read(10,*) 
     do i = 1, n 
        read(10,*) at, (pos(i,j),j=1,3)
     end do
     
     do i = 1, n-1
        x(:) = pos(i,:)
        do j = i+1, n
           pbc(:) = x(:) - pos(j,:)
           pbc(:) = pbc(:) - dble(nint(pbc(:)/side(:))) * side(:)
           r = sqrt( dot_product(pbc,pbc) )
           if ( r <= rmax ) then
              k = int( ( r - rmin ) / dbin )
              gdr(k) = gdr(k) + 2.d0
           end if
        end do
     end do

  end do main
  
  open ( unit=400, file=output )
  pi = acos(-1.d0)
  do i = 0, nbin
     gdr(i) = gdr(i) / dble(iconf) / dble(n)
     if ( i /= 0 ) then
        gdr(i) = gdr(i) / dbin / 4.d0 / pi / (rmin+real(i)*dbin)**2 * side(1)*side(2)*side(3) / dble(n)
        write(400,'(f12.5,es20.10)') rmin+(dble(i)+0.5d0)*dbin, gdr(i)
     end if
  end do
  close(400)
  
  stop
end program calc_gdr
