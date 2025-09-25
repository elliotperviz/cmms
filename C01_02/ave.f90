program average
  implicit none
  integer :: i, j, k, N
  real(8) :: t, xxx, x, ave, std
  character(100) :: input, output

  write(*,*) 'input file, output file, column to average?'
  read(*,*) input, output, N

  open (unit=10,file=input)
  open (unit=100,file=output)
  k = 0
  ave = 0.d0
  std = 0.d0
  do
     read(10,*,iostat=i) t, (xxx,j=1,N-2), x
     if ( i /= 0 ) exit
     k = k + 1
     ave = ave + x
     std = std + x*x
     write(100,*) t, ave/dble(k)
  end do
  close(10)
  close(100)

  write(*,*) 'average = ', ave/dble(k)
  write(*,*) 'std dev = ', sqrt(std/dble(k)-(ave/dble(k))**2)

  stop
end program average
